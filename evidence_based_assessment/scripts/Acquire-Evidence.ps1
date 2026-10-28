param(
    [string]$OutputRoot = (Join-Path $PSScriptRoot '..'),
    [int]$MaximumAssetBytes = 25000000,
    [switch]$RetryLocalFailuresOnly,
    [switch]$AcquireCatalogueResourcesOnly,
    [switch]$AcquireMarketGazetteerSourcesOnly,
    [string]$GazetteerLookup,
    [switch]$AcquireBuildingIndexOnly,
    [switch]$AcquireGazetteerOsmObjectsOnly,
    [switch]$AcquireGazetteerReferencesOnly,
    [switch]$AcquireGazetteerOsmWaysOnly
)

$ErrorActionPreference = 'Stop'
$OutputRoot = [System.IO.Path]::GetFullPath($OutputRoot)
$rawRoot = Join-Path $OutputRoot 'raw'
$logRoot = Join-Path $OutputRoot 'acquisition'
[System.IO.Directory]::CreateDirectory($rawRoot) | Out-Null
[System.IO.Directory]::CreateDirectory($logRoot) | Out-Null
$records = [System.Collections.Generic.List[object]]::new()
$manifestPath = Join-Path $logRoot 'acquisition_manifest.json'
if (Test-Path -LiteralPath $manifestPath) {
    foreach ($previous in (Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json)) {
        $records.Add($previous)
    }
}
$client = [System.Net.Http.HttpClient]::new()
$client.Timeout = [TimeSpan]::FromSeconds(60)
$client.DefaultRequestHeaders.UserAgent.ParseAdd('KhartoumSecondaryEvidenceAssessment/1.0')

function Receive-Evidence {
    param(
        [string]$AssetId,
        [string]$Url,
        [string]$FileName,
        [string]$Method = 'GET',
        [string]$Body,
        [string]$ContentType = 'application/json'
    )
    $target = Join-Path $rawRoot $FileName
    $request = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::new($Method), $Url)
    $response = $null
    $record = [ordered]@{
        asset_id = $AssetId
        requested_url = $Url
        method = $Method
        request_body = $Body
        retrieved_at_utc = [DateTimeOffset]::UtcNow.ToString('o')
        status = 'not_acquired'
        http_status = $null
        content_type = $null
        source_last_modified = $null
        bytes = $null
        sha256 = $null
        local_path = $null
        error = $null
    }
    try {
        if ($Body) {
            $request.Content = [System.Net.Http.StringContent]::new($Body, [System.Text.Encoding]::UTF8, $ContentType)
        }
        $response = $client.SendAsync($request, [System.Net.Http.HttpCompletionOption]::ResponseHeadersRead).GetAwaiter().GetResult()
        $record.http_status = [int]$response.StatusCode
        $record.content_type = [string]$response.Content.Headers.ContentType
        if ($response.Content.Headers.LastModified) {
            $record.source_last_modified = $response.Content.Headers.LastModified.ToString('o')
        }
        $response.EnsureSuccessStatusCode() | Out-Null
        if ($response.Content.Headers.ContentLength -gt $MaximumAssetBytes) {
            throw 'Asset exceeds configured acquisition size limit; no large-file download authorized by this run.'
        }
        $inputStream = $response.Content.ReadAsStreamAsync().GetAwaiter().GetResult()
        $outputStream = [System.IO.File]::Create($target)
        try {
            $buffer = [byte[]]::new(65536)
            $totalBytes = 0
            while (($readBytes = $inputStream.Read($buffer, 0, $buffer.Length)) -gt 0) {
                $totalBytes += $readBytes
                if ($totalBytes -gt $MaximumAssetBytes) {
                    throw 'Stream exceeds configured acquisition size limit.'
                }
                $outputStream.Write($buffer, 0, $readBytes)
            }
        }
        finally {
            $inputStream.Dispose()
            $outputStream.Dispose()
        }
        $record.bytes = (Get-Item -LiteralPath $target).Length
        $record.sha256 = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToLowerInvariant()
        $record.local_path = 'raw/' + $FileName
        $record.status = 'acquired_unreviewed'
        Write-Host "ACQUIRED $AssetId ($($record.bytes) bytes)"
    }
    catch {
        $record.error = $_.Exception.Message
        if (Test-Path -LiteralPath $target) {
            Remove-Item -LiteralPath $target
        }
        Write-Host "GAP $AssetId : $($record.error)"
    }
    finally {
        if ($response) { $response.Dispose() }
        $request.Dispose()
        $records.Add([pscustomobject]$record)
    }
    return [pscustomobject]$record
}

try {
    if ($GazetteerLookup) {
        $lookupDigest = [Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($GazetteerLookup))).Substring(0,16).ToLowerInvariant()
        $lookupFile = 'nominatim_' + $lookupDigest + '.json'
        $lookupUrl = 'https://nominatim.openstreetmap.org/search?format=jsonv2&namedetails=1&extratags=1&polygon_geojson=1&limit=5&q=' + [uri]::EscapeDataString($GazetteerLookup)
        Receive-Evidence -AssetId ('OSM_NOMINATIM_' + $GazetteerLookup) -Url $lookupUrl -FileName $lookupFile | Out-Null
    }
    elseif ($AcquireGazetteerOsmWaysOnly) {
        $wayIds = @(Get-ChildItem (Join-Path $rawRoot 'nominatim_*.json') | ForEach-Object {
            foreach ($place in @(Get-Content -Raw $_.FullName | ConvertFrom-Json)) {
                if ($place.osm_type -eq 'way') { $place.osm_id }
            }
        } | Sort-Object -Unique)
        foreach ($wayId in $wayIds) {
            Receive-Evidence -AssetId ('OSM_GAZETTEER_WAY_' + $wayId) -Url ('https://api.openstreetmap.org/api/0.6/way/' + $wayId + '/full.json') -FileName ('osm_way_' + $wayId + '_full.json') | Out-Null
        }
    }
    elseif ($AcquireGazetteerOsmObjectsOnly) {
        $nodeIds = @(Get-ChildItem (Join-Path $rawRoot 'nominatim_*.json') | ForEach-Object {
            foreach ($place in @(Get-Content -Raw $_.FullName | ConvertFrom-Json)) {
                if ($place.osm_type -eq 'node' -and ($place.type -eq 'marketplace' -or $place.name -eq 'سوق الخيمة')) { $place.osm_id }
            }
        } | Sort-Object -Unique)
        if ($nodeIds.Count -eq 0) { throw 'No actual market-point candidates discovered.' }
        Receive-Evidence -AssetId 'OSM_GAZETTEER_CANDIDATE_NODES' -Url ('https://api.openstreetmap.org/api/0.6/nodes.json?nodes=' + ($nodeIds -join ',')) -FileName 'osm_gazetteer_candidate_nodes.json' | Out-Null
    }
    elseif ($AcquireGazetteerReferencesOnly) {
        Receive-Evidence -AssetId 'DABANGA_MARKET_IDENTITY_20230511' -Url 'https://www.dabangasudan.org/en/all-news/article/libya-market-plundered-police-remain-absent-in-sudan-capital' -FileName 'dabanga_market_identity_20230511.html' | Out-Null
        Receive-Evidence -AssetId 'UNHABITAT_KHARTOUM_URBAN_SECTOR_STUDY' -Url 'https://unhabitat.org/sites/default/files/download-manager-files/Urban%20Sector%20Studies%20and%20Capacity%20Building%20for%20Khartoum%20State.pdf' -FileName 'unhabitat_khartoum_urban_sector_study.pdf' | Out-Null
        Receive-Evidence -AssetId 'UNOSAT_KHARTOUM_PUBLISHED_MAP_20240910' -Url 'https://unosat.org/static/unosat_filesystem/3960/UNOSAT_A3_Natural_Landscape_FL20240826SDN_Khartoum_10September2024_3.jpg' -FileName 'unosat_khartoum_published_map_20240910.jpg' | Out-Null
        Receive-Evidence -AssetId 'PUBLISHED_ARABI_IDENTITY_REFERENCE' -Url 'https://en.wikipedia.org/wiki/Souq_Al_Arabi' -FileName 'published_arabi_identity_reference.html' | Out-Null
    }
    elseif ($AcquireBuildingIndexOnly) {
        Receive-Evidence -AssetId 'GOOGLE_OPEN_BUILDINGS_TILE_INDEX' -Url 'https://openbuildings-public-dot-gweb-research.uw.r.appspot.com/public/tiles.geojson' -FileName 'google_open_buildings_tiles.geojson' | Out-Null
    }
    elseif ($AcquireMarketGazetteerSourcesOnly) {
        $boundary = Get-Content -Raw (Join-Path $OutputRoot 'processed/khartoum_cod_admin2.geojson') | ConvertFrom-Json
        $positions = [System.Collections.Generic.List[object]]::new()
        function Add-BoundaryPositions($coordinates) {
            if ($coordinates.Count -ge 2 -and $coordinates[0] -is [ValueType]) {
                $positions.Add(@([double]$coordinates[0], [double]$coordinates[1]))
            }
            else {
                foreach ($part in $coordinates) { Add-BoundaryPositions $part }
            }
        }
        foreach ($feature in $boundary.features) { Add-BoundaryPositions $feature.geometry.coordinates }
        if ($positions.Count -eq 0) { throw 'No acquired boundary coordinates available for OSM query extent.' }
        $longitudeRange = $positions | ForEach-Object { $_[0] } | Measure-Object -Minimum -Maximum
        $latitudeRange = $positions | ForEach-Object { $_[1] } | Measure-Object -Minimum -Maximum
        $culture = [Globalization.CultureInfo]::InvariantCulture
        $extent = @($latitudeRange.Minimum,$longitudeRange.Minimum,$latitudeRange.Maximum,$longitudeRange.Maximum) | ForEach-Object { $_.ToString('R',$culture) }
        $osmQuery = '[out:json][timeout:45];nwr["amenity"="marketplace"](' + ($extent -join ',') + ');out meta geom;'
        $osmResult = Receive-Evidence -AssetId 'OSM_MARKETPLACES_BOUNDARY_EXTENT' -Url ('https://overpass.kumi.systems/api/interpreter?data=' + [uri]::EscapeDataString($osmQuery)) -FileName 'osm_marketplaces_boundary_extent.json'
        if ($osmResult.status -eq 'acquired_unreviewed') {
            $osm = Get-Content -Raw (Join-Path $rawRoot 'osm_marketplaces_boundary_extent.json') | ConvertFrom-Json
            if ($osm.remark) { Write-Host ('OSM QUERY WARNING: ' + $osm.remark) }
            Write-Host ('OSM elements returned: ' + @($osm.elements).Count)
        }
        Receive-Evidence -AssetId 'GOOGLE_OPEN_BUILDINGS_CATALOGUE' -Url 'https://sites.research.google/open-buildings/' -FileName 'google_open_buildings_catalogue.html' | Out-Null
        Receive-Evidence -AssetId 'GOOGLE_OPEN_BUILDINGS_TILE_INDEX' -Url 'https://openbuildings-public-dot-gweb-research.uw.r.appspot.com/public/tiles.geojson' -FileName 'google_open_buildings_tiles.geojson' | Out-Null
    }
    elseif ($AcquireCatalogueResourcesOnly) {
        $resourceRequests = @(
            @{ Metadata = 'hdx_cod_ab_sdn_metadata.json'; Pattern = '^sdn_admin_boundaries\.geojson\.zip$'; Output = 'sdn_admin_boundaries.geojson.zip' },
            @{ Metadata = 'hdx_cod_ps_sdn_metadata.json'; Pattern = '^sdn_admpop_adm2_2025\.csv$'; Output = 'sdn_admpop_adm2_2025.csv' },
            @{ Metadata = 'hdx_cod_ps_sdn_metadata.json'; Pattern = '^sdn_admpop_adm1_2025\.csv$'; Output = 'sdn_admpop_adm1_2025.csv' },
            @{ Metadata = 'hdx_cod_ps_sdn_metadata.json'; Pattern = '^sdn_2025_technical_accompanying_note\.pdf$'; Output = 'sdn_2025_technical_accompanying_note.pdf' },
            @{ Metadata = 'hdx_cod_ps_sdn_metadata.json'; Pattern = '^2025-sdn-cod-ps-end_user_release_note\.pdf$'; Output = '2025-sdn-cod-ps-end_user_release_note.pdf' }
        )
        foreach ($resourceRequest in $resourceRequests) {
            $metadata = Get-Content -Raw -LiteralPath (Join-Path $rawRoot $resourceRequest.Metadata) | ConvertFrom-Json
            $resource = $metadata.result.resources | Where-Object { $_.name -match $resourceRequest.Pattern } | Sort-Object last_modified -Descending | Select-Object -First 1
            if ($resource) {
                Receive-Evidence -AssetId ('HDX_RESOURCE_' + $resource.id) -Url $resource.url -FileName $resourceRequest.Output | Out-Null
            }
            else {
                Write-Host ('CATALOGUE GAP: no actual resource matches ' + $resourceRequest.Pattern)
            }
        }
    }
    elseif ($RetryLocalFailuresOnly) {
        $retryRecords = @($records | Where-Object { $_.http_status -eq 200 -and $_.error -eq 'You cannot call a method on a null-valued expression.' })
        foreach ($retry in $retryRecords) {
            $fileName = switch ($retry.asset_id) {
                'WB_SDN_CPI_INFLATION' { 'worldbank_sdn_cpi_inflation.json' }
                'WB_SDN_OFFICIAL_FX' { 'worldbank_sdn_official_fx.json' }
                'JRC_FLOOD_README' { 'jrc_flood_hazard_README.txt' }
                'JRC_FLOOD_TILE_EXTENTS' { 'jrc_flood_tile_extents.geojson' }
                default { 'hdx_wfp_prices_sdn_resource.csv' }
            }
            Receive-Evidence -AssetId $retry.asset_id -Url $retry.requested_url -FileName $fileName | Out-Null
        }
    }
    else {
    $packages = @(
        @{ Id = 'HDX_COD_AB_SDN'; Package = 'cod-ab-sdn' },
        @{ Id = 'HDX_COD_PS_SDN'; Package = 'cod-ps-sdn' },
        @{ Id = 'HDX_WFP_PRICES_SDN'; Package = 'wfp-food-prices-for-sudan' },
        @{ Id = 'HDX_HRSL_SDN'; Package = 'highresolutionpopulationdensitymaps-sdn' }
    )
    foreach ($package in $packages) {
        $metadataName = $package.Id.ToLowerInvariant() + '_metadata.json'
        $result = Receive-Evidence -AssetId $package.Id -Url ('https://data.humdata.org/api/3/action/package_show?id=' + $package.Package) -FileName $metadataName
        if ($result.status -eq 'acquired_unreviewed') {
            try {
                $metadata = Get-Content -Raw -LiteralPath (Join-Path $rawRoot $metadataName) | ConvertFrom-Json
                if (-not $metadata.success) { throw 'CKAN response does not confirm package success.' }
                $resourceRows = @($metadata.result.resources | ForEach-Object {
                    [pscustomobject]@{
                        package_id = $package.Package
                        resource_id = $_.id
                        name = $_.name
                        format = $_.format
                        url = $_.url
                        last_modified = $_.last_modified
                    }
                })
                $resourceRows | Export-Csv -LiteralPath (Join-Path $logRoot ($package.Id.ToLowerInvariant() + '_resources.csv')) -NoTypeInformation -Encoding utf8
                $selected = $null
                if ($package.Id -eq 'HDX_WFP_PRICES_SDN') {
                    $selected = $metadata.result.resources | Where-Object { $_.format -match '^csv$' } | Select-Object -First 1
                }
                elseif ($package.Id -eq 'HDX_COD_AB_SDN') {
                    $selected = $metadata.result.resources | Where-Object { $_.format -match 'geojson|json' -and $_.url -match '\.(geojson|json)(\?|$)' } | Select-Object -First 1
                }
                if ($selected) {
                    $extension = if ($package.Id -eq 'HDX_WFP_PRICES_SDN') { '.csv' } else { '.geojson' }
                    Receive-Evidence -AssetId ($package.Id + '_RESOURCE_' + $selected.id) -Url $selected.url -FileName ($package.Id.ToLowerInvariant() + '_resource' + $extension) | Out-Null
                }
            }
            catch {
                Write-Host "METADATA GAP $($package.Id) : $($_.Exception.Message)"
            }
        }
    }

    Receive-Evidence -AssetId 'WORLDPOP_SDN_CATALOGUE' -Url 'https://www.worldpop.org/rest/data/pop/wpgp?iso3=SDN' -FileName 'worldpop_sdn_catalogue.json' | Out-Null
    Receive-Evidence -AssetId 'WB_SDN_CPI_INFLATION' -Url 'https://api.worldbank.org/v2/country/SDN/indicator/FP.CPI.TOTL.ZG?format=json&date=2019:2026&per_page=100' -FileName 'worldbank_sdn_cpi_inflation.json' | Out-Null
    Receive-Evidence -AssetId 'WB_SDN_OFFICIAL_FX' -Url 'https://api.worldbank.org/v2/country/SDN/indicator/PA.NUS.FCRF?format=json&date=2019:2026&per_page=100' -FileName 'worldbank_sdn_official_fx.json' | Out-Null
    Receive-Evidence -AssetId 'JRC_FLOOD_README' -Url 'https://jeodpp.jrc.ec.europa.eu/ftp/jrc-opendata/CEMS-GLOFAS/flood_hazard/README.txt' -FileName 'jrc_flood_hazard_README.txt' | Out-Null
    Receive-Evidence -AssetId 'JRC_FLOOD_TILE_EXTENTS' -Url 'https://jeodpp.jrc.ec.europa.eu/ftp/jrc-opendata/CEMS-GLOFAS/flood_hazard/tile_extents.geojson' -FileName 'jrc_flood_tile_extents.geojson' | Out-Null

    $osmQuery = '[out:json][timeout:45];area["ISO3166-2"="SD-KH"]["boundary"="administrative"]->.study;nwr["amenity"="marketplace"](area.study);out center tags meta;'
    Receive-Evidence -AssetId 'OSM_KHARTOUM_MARKETPLACES' -Url 'https://overpass-api.de/api/interpreter' -Method 'POST' -Body ('data=' + [uri]::EscapeDataString($osmQuery)) -ContentType 'application/x-www-form-urlencoded' -FileName 'osm_khartoum_marketplaces.json' | Out-Null

    $reportQueries = [ordered]@{
        HNO_HRP = 'Sudan humanitarian needs response plan'
        REACH = 'Sudan REACH market assessment'
        UNHABITAT = 'Khartoum UN-Habitat'
        FAO = 'Sudan FAO markets assessment'
    }
    foreach ($query in $reportQueries.GetEnumerator()) {
        $body = @{
            filter = @{ field = 'country.iso3'; value = 'sdn' }
            query = @{ value = $query.Value; operator = 'AND' }
            sort = @('date.created:desc')
            limit = 5
            fields = @{ include = @('title','url','date','source','file') }
        } | ConvertTo-Json -Depth 8
        Receive-Evidence -AssetId ('RELIEFWEB_' + $query.Key) -Url 'https://api.reliefweb.int/v1/reports?appname=khartoum-secondary-evidence' -Method 'POST' -Body $body -FileName ('reliefweb_' + $query.Key.ToLowerInvariant() + '.json') | Out-Null
    }
    }
}
finally {
    $client.Dispose()
    $records | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $logRoot 'acquisition_manifest.json') -Encoding utf8
    $records | Select-Object asset_id,requested_url,method,retrieved_at_utc,status,http_status,content_type,source_last_modified,bytes,sha256,local_path,error | Export-Csv -LiteralPath (Join-Path $logRoot 'acquisition_log.csv') -NoTypeInformation -Encoding utf8
}