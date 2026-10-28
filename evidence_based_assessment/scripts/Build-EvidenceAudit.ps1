param([string]$AssessmentRoot = (Join-Path $PSScriptRoot '..'))

$ErrorActionPreference = 'Stop'
$AssessmentRoot = [IO.Path]::GetFullPath($AssessmentRoot)
$workspaceRoot = Split-Path $AssessmentRoot -Parent
$rawRoot = Join-Path $AssessmentRoot 'raw'
$outputRoot = Join-Path $AssessmentRoot 'processed'
$null = New-Item -ItemType Directory -Force -Path $outputRoot
$culture = [Globalization.CultureInfo]::InvariantCulture
$attempts = @(Get-Content -Raw (Join-Path $AssessmentRoot 'acquisition/acquisition_manifest.json') | ConvertFrom-Json)
$assets = @($attempts | Where-Object status -eq 'acquired_unreviewed' | Group-Object local_path | ForEach-Object { $_.Group[-1] })

foreach ($asset in $assets) {
    $path = Join-Path $AssessmentRoot $asset.local_path
    if ((Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash -ne $asset.sha256) {
        throw "Input checksum mismatch: $($asset.local_path)"
    }
    if ((Get-Item -LiteralPath $path).Length -ne $asset.bytes) {
        throw "Input byte-length mismatch: $($asset.local_path)"
    }
}
$assets | Select-Object asset_id,requested_url,retrieved_at_utc,local_path,bytes,sha256,content_type |
    Export-Csv -NoTypeInformation -Encoding utf8 (Join-Path $outputRoot 'verified_input_assets.csv')

$prices = @(Import-Csv (Join-Path $rawRoot 'hdx_wfp_prices_sdn_resource.csv'))
$localPrices = @($prices | Where-Object admin1 -eq 'Khartoum')
if ($localPrices.Count -eq 0) { throw 'No source-labelled Khartoum price observations found.' }
$localPrices | Export-Csv -NoTypeInformation -Encoding utf8 (Join-Path $outputRoot 'wfp_khartoum_source_observations.csv')
$seriesCoverage = @(foreach ($series in ($localPrices | Group-Object market_id,commodity_id,unit,pricetype,currency,priceflag)) {
    $ordered = @($series.Group | Sort-Object date)
    $latest = $ordered[-1]
    $latestDate = [datetime]::ParseExact($latest.date, 'yyyy-MM-dd', $culture)
    $monthly = @($ordered | Group-Object { $_.date.Substring(0,7) })
    $duplicateMonths = @($monthly | Where-Object Count -gt 1).Count
    $priorMonth = $latestDate.AddMonths(-1).ToString('yyyy-MM', $culture)
    $previous = @($ordered | Where-Object { $_.date.Substring(0,7) -eq $priorMonth })
    $latestMonthRows = @($ordered | Where-Object { $_.date.Substring(0,7) -eq $latestDate.ToString('yyyy-MM', $culture) })
    $change = $null
    $latestPrice = [double]::Parse($latest.price, $culture)
    if ($latestMonthRows.Count -eq 1 -and $previous.Count -eq 1) {
        $previousPrice = [double]::Parse($previous[0].price, $culture)
        if ($latestPrice -gt 0 -and $previousPrice -gt 0) {
            $change = (($latestPrice / $previousPrice - 1) * 100).ToString('R', $culture)
        }
    }
    $windowStart = $latestDate.AddMonths(-11).ToString('yyyy-MM', $culture)
    $window = @($ordered | Where-Object { $_.date.Substring(0,7) -ge $windowStart })
    $windowGroups = @($window | Group-Object { $_.date.Substring(0,7) })
    $volatility = $null
    $volatilityStatus = 'not_calculated_incomplete_or_nonpositive_monthly_window'
    if ($window.Count -eq 12 -and $windowGroups.Count -eq 12 -and @($window | Where-Object { [double]::Parse($_.price,$culture) -le 0 }).Count -eq 0) {
        $logChanges = @(for ($index=1; $index -lt $window.Count; $index++) {
            [math]::Log([double]::Parse($window[$index].price,$culture) / [double]::Parse($window[$index-1].price,$culture))
        })
        $mean = ($logChanges | Measure-Object -Average).Average
        $squared = ($logChanges | ForEach-Object { [math]::Pow($_ - $mean,2) } | Measure-Object -Sum).Sum
        $volatility = ([math]::Sqrt($squared / ($logChanges.Count - 1))).ToString('R',$culture)
        $volatilityStatus = 'sample_sd_of_11_monthly_log_price_changes'
    }
    [pscustomobject]@{
        market=$latest.market;market_id=$latest.market_id;source_admin2=$latest.admin2
        commodity=$latest.commodity;commodity_id=$latest.commodity_id;unit=$latest.unit
        pricetype=$latest.pricetype;currency=$latest.currency;priceflag=$latest.priceflag
        observation_rows=$ordered.Count;distinct_months=$monthly.Count;duplicate_months=$duplicateMonths
        first_date=$ordered[0].date;last_date=$latest.date;latest_source_price=$latest.price
        previous_month_date=if($previous.Count -eq 1){$previous[0].date}else{$null}
        nominal_month_on_month_percent=$change;volatility_window_start=$windowStart
        monthly_log_change_sample_sd=$volatility;volatility_status=$volatilityStatus
        selected_market_match='not_established';scope='source-labelled Khartoum monitoring location only'
    }
})
$seriesCoverage | Export-Csv -NoTypeInformation -Encoding utf8 (Join-Path $outputRoot 'wfp_khartoum_series_coverage_and_changes.csv')

$bankObservations = @(foreach ($file in @('worldbank_sdn_cpi_inflation.json','worldbank_sdn_official_fx.json')) {
    $body = Get-Content -Raw (Join-Path $rawRoot $file) | ConvertFrom-Json
    foreach ($observation in $body[1]) {
        [pscustomobject]@{
            indicator_id=$observation.indicator.id;indicator_name=$observation.indicator.value
            country_iso3=$observation.countryiso3code;year=$observation.date
            value=if($null -eq $observation.value){$null}else{([double]$observation.value).ToString('R',$culture)}
            value_status=if($null -eq $observation.value){'source_null'}else{'published_value'}
            api_lastupdated=$body[0].lastupdated;scope='Sudan national context only';source_file=$file
        }
    }
})
$bankObservations | Export-Csv -NoTypeInformation -Encoding utf8 (Join-Path $outputRoot 'worldbank_national_context.csv')

$archive = [IO.Compression.ZipFile]::OpenRead((Join-Path $rawRoot 'sdn_admin_boundaries.geojson.zip'))
try {
    $reader = [IO.StreamReader]::new($archive.GetEntry('sdn_admin2.geojson').Open())
    try { $boundaries = $reader.ReadToEnd() | ConvertFrom-Json } finally { $reader.Dispose() }
} finally { $archive.Dispose() }
$khartoumBoundaries = @($boundaries.features | Where-Object { $_.properties.adm1_pcode -eq 'SD01' })
if ($khartoumBoundaries.Count -eq 0) { throw 'Boundary archive has no Khartoum features.' }
$boundaryCollection = [ordered]@{type='FeatureCollection';features=$khartoumBoundaries}
$boundaryCollection | ConvertTo-Json -Depth 100 | Set-Content -Encoding utf8 (Join-Path $outputRoot 'khartoum_cod_admin2.geojson')
$khartoumBoundaries | ForEach-Object { $_.properties } |
    Export-Csv -NoTypeInformation -Encoding utf8 (Join-Path $outputRoot 'khartoum_cod_admin2_properties.csv')

$populationAudit = @(foreach ($file in @('sdn_admpop_adm1_2025.csv','sdn_admpop_adm2_2025.csv')) {
    $rows = @(Import-Csv (Join-Path $rawRoot $file))
    [pscustomobject]@{
        source_file=$file;source_rows=$rows.Count;row_year_values=($rows.Year | Sort-Object -Unique) -join ';'
        resource_named_year='2025';release_note_reference_date='2025-07-01'
        khartoum_rows=@($rows | Where-Object ADM1_PCODE -eq 'SD01').Count
        assessment_use='blocked_pending_provider_resolution_of_row_year_and_release_note_conflict'
    }
})
$populationAudit | Export-Csv -NoTypeInformation -Encoding utf8 (Join-Path $outputRoot 'population_reference_date_conflict.csv')

$catalogue = @(Import-Csv (Join-Path $workspaceRoot 'deliverables/indicator_catalogue.csv'))
$contracts = @(Import-Csv (Join-Path $workspaceRoot 'open_source_platform/data/indicator_contracts.csv'))
$inventory = @(Import-Csv (Join-Path $workspaceRoot 'deliverables/Deliverable_D_Data_Inventory.csv'))
$priceDates = @($localPrices.date | Sort-Object)
$pricePeriod = $priceDates[0] + ' to ' + $priceDates[-1] + '; series-specific gaps and periods in processed coverage file'
$requiredMethods = @{
    I01='Corroborate original market names and distinct sites against existing registry records and independently dated maps; retain competing identities.'
    I02='Extract explicit market-specific operating status, observation date, definition and original reporting lineage from a real published assessment.'
    I03='Review adequate-resolution baseline imagery and a real structure inventory; record which structures are observable and why others are not.'
    I04='Count independently reviewed visible damaged structures against the observable baseline denominator; publish observation coverage separately.'
    I05='Deduplicate actual building polygons and facility records in a verified market footprint; divide measured footprint area by the declared analysis area.'
    I06='Extract separate dated operational evidence for water, sanitation/waste, power and loading/storage; keep each unknown category explicit.'
    I07='Extract actual storage/cold-chain/loading facility identities, capacity units, reporting dates and documented operation; do not infer capacity from roofs.'
    I08='Use a verified entrance, acquired population origins and routable network with independently supported travel costs; compute a population-weighted median over valid reachable origins.'
    I09='Classify actual routing results as reachable, disconnected or unresolved; divide reachable origin population by the valid declared population denominator.'
    I10='Use a date-compatible population surface and supported access costs; assign each resident cell once to an eligible market; publish unassigned population without extrapolation.'
    I11='Derive individual and union catchments from supported routing costs and acquired population cells; retain overlap and avoid summing individual totals.'
    I12='Match actual commodity, grade, unit, market, price type, currency and period before calculating price changes.'
    I13='Extract explicit item availability observations and monitoring completeness for a documented appropriate basket; missing price quotes are not stockouts.'
    I14='Calculate monthly log-price variability only for an observed complete comparable series; never fill missing months.'
    I15='Map explicit observed food availability to a documented food-group classification and publish completeness; item-price coverage alone is insufficient.'
    I16='Extract dated reported commodity-origin-destination links from reviewed supply-chain reports; include quantity only where the report provides compatible units.'
    I17='Use dated bridge/restriction evidence and a valid reference graph; compare supported routes and disconnection without invented closure assumptions.'
    I18='Compute explicitly defined edge-disjoint alternatives on an acquired validated graph; audit shared crossings and common hazards.'
    I19='Obtain authorized actual event records, review duplicate and location precision, and report a documented dated exposure window; no unapproved recency weights.'
    I20='Extract explicit dated closure, looting, blockade or corridor restriction reports; trace reposts to original events and protect sensitive details.'
    I21='Intersect actual raw flood-depth data and producer masks with verified asset geometries, retaining nodata; keep observed-event extents separate from modelled return periods.'
    I22='Use one acquired rainfall product version and its quality controls; compare a documented observation period with an explicitly supported climatology.'
    I23='Apply the actual Landsat product temperature scale, offset and QA; preserve overpass time and native support; keep air-temperature context separate.'
    I24='Quality-mask actual comparable reflectance observations and calculate NDVI in documented supplier areas with matched-season interpretation.'
    I25='Summarize acquired surface-water observations separately from explicit dated utility-operation evidence; do not substitute one for the other.'
    I26='Use acquired quality-controlled same-product VIIRS composites; compare matched periods and report observation counts, valid area and noise limitations.'
    I27='Deduplicate actual commercial/facility records by identity and geometry in a declared area; retain source dates and unknown operation.'
    I28='Extract positively documented geographic market reach and hierarchy from reviewed dated reports; retain historical versus current distinctions.'
    I29='Calculate road-node centrality on a real validated fixed graph with explicit normalization; do not convert it to observed trade or an unapproved score.'
    I30='Extract actual provider branches/agents, operational evidence and dated financial-product terms; do not infer uptake or affordability from proximity.'
    I31='Review licensed actual coverage/performance observations and separate dated outage/payment evidence; retain sampling and adoption gaps.'
    I32='Extract applicable existing gender, age and disability evidence with actual definitions, sampling frame, period and denominator; resident profiles are not trader shares.'
    I33='Review existing valid ownership, allocation, permission, consent and dispute records for the exact site; report documentary findings without an invented maturity score.'
    I34='Review existing qualified engineering records, dates, scope, designs and actual cost evidence; no remote structural certification or assumed readiness score.'
    I35='Review existing owner agreements, actual maintenance duties, budgets and financing evidence; do not infer revenues or financing maturity.'
    I36='Review actual environmental/social screening, permissions and documented mitigation requirements alongside suitable hazard evidence; no assumed feasibility score.'
    I37='Compare repeated applicable dated operational/service/physical observations; bracket recovery only between actual observations, without causal or income claims.'
    I38='Count distinct positively documented contemporary supplier origins/categories by commodity and season; do not use road alternatives as supplier counts.'
    I39='Match actual basket quantities and prices to an applicable dated wage, income or transfer denominator; calculate no affordability measure without both.'
    I40='Extract existing applicable trader/employment/capital records with precise definitions, dates and denominators; do not estimate from buildings, population or lights.'
    I41='Review existing relevant qualified food-safety, protection and access reports separately with actual dates and sensitivity controls; proxies cannot certify safety.'
    I42='Extract positive evidence for each documented market function with dates; absent documentation remains unknown, not an absent role or numerical diversity score.'
}
$alternativeEvidence = @{
    I01='Existing published maps and administrative boundaries can support corroboration, but cannot resolve a market entrance or the missing fifteenth identity alone.'
    I02='Repeated published market-monitoring reports can establish a dated status sequence; lights and roof condition cannot substitute for trading status.'
    I03='A dated published damage inventory with an explicit observed denominator is preferable if suitable image interpretation is unavailable.'
    I04='Use an existing qualified published damage assessment as a narrower documented finding; do not fabricate a damage fraction from medium-resolution imagery.'
    I05='OSM or Open Buildings can support mapped-presence inventories after acquisition and completeness review, not service operation or vendor counts.'
    I06='Published utility restoration reports can support dated neighbourhood context, not an assumed functioning market connection.'
    I07='Published logistics capacity records can establish documented facility provision; mapped roof area cannot estimate usable storage.'
    I08='Measured network distance could be reported as distance after network/site validation; do not convert it to time using an assumed speed.'
    I09='Documented road/bridge restrictions can describe access constraints qualitatively until valid population routing is possible.'
    I10='A verified dated locality projection may provide administrative context once the source-date conflict is resolved; it is not market customers or a catchment.'
    I11='An explicitly labelled geometric distance buffer may describe proximity after site verification; it is not a travel-time service area.'
    I12='Actual WFP monitoring-location prices provide narrower regional context; selected-market equivalence is unverified.'
    I13='Published monitoring basket coverage can describe what was monitored, not actual stock availability.'
    I14='Observed matched nominal price changes provide narrower context when a complete monthly volatility window is absent.'
    I15='Published observed food-group availability is required; prices of selected foods describe monitoring scope, not nutritious assortment.'
    I16='Published logistics route maps can show historical documented connections only, not current flows or tonnage.'
    I17='Published dated bridge status can describe a constraint; graph detours require valid network and restriction data.'
    I18='Documented alternative supplier corridors may support qualitative redundancy; no numerical path count without a validated graph.'
    I19='Dated OCHA or other published access reports can describe documented insecurity qualitatively, not an ACLED-equivalent event count or safety clearance.'
    I20='A dated published access-constraint map can provide contextual reported restriction evidence, subject to location precision and sensitivity.'
    I21='Published observed flood extents could support exposure for that event after asset verification; they do not establish return-period probability.'
    I22='Published meteorological bulletins can support reported regional rainfall conditions, not an invented local rainfall anomaly.'
    I23='Published regional air-temperature/reanalysis observations offer separate climate context, not market surface temperature or occupational WBGT.'
    I24='Published crop-condition reports can provide documented agricultural context, not a local NDVI calculation or a yield estimate.'
    I25='Existing WASH restoration reports are more directly relevant to service access than surface-water occurrence.'
    I26='Dated published power-restoration or business assessments may describe recovery directly; no conversion of light radiance into jobs or sales.'
    I27='Existing business registers can provide documented covered firms after coverage review; no informal-trader extrapolation.'
    I28='A dated logistics or economic assessment may document a particular wholesale/specialist role without supporting a full hierarchy.'
    I29='Documented logistics-hub descriptions may support qualitative role; no network centrality value without acquired graph data.'
    I30='Published financial-inclusion studies may document regional barriers; they do not establish market-level uptake or branch liquidity.'
    I31='Published outage records can describe service interruptions; operator coverage maps alone do not measure reliable access or adoption.'
    I32='Existing qualitative inclusion studies can report scoped barriers without inventing trader participation percentages.'
    I33='An existing published legal/project appraisal can identify documented tenure issues; imagery is not ownership evidence.'
    I34='Published qualified damage or rehabilitation reports may describe scoped repair needs; no inferred bill of quantities.'
    I35='Existing published management/maintenance agreements may identify responsible actors without proving financial viability.'
    I36='Published hazard and protection assessments can identify screening concerns; they do not establish consent, approvals or completed mitigation.'
    I37='Repeated dated published status reports can establish a documentary recovery interval; a single image cannot.'
    I38='Published qualitative sourcing descriptions can identify reported origins without a complete diversification count.'
    I39='Observed matched price changes can describe price pressure, not household affordability without an income denominator.'
    I40='Existing published trader/livelihood studies can support their stated sample findings; do not extrapolate unsupported market totals.'
    I41='Existing qualified food-safety/protection assessments can report their precise findings; no remotely inferred safety clearance.'
    I42='Published documented functions can be listed with evidence while unobserved functions remain unknown; no unsupported composite.'
}
$indicatorMatrix = @(foreach ($indicator in $catalogue) {
    $contract = $contracts | Where-Object indicator_id -eq $indicator.indicator_id
    $datasetIds = @($contract.dataset_ids -split ';')
    $candidates = @($inventory | Where-Object { $_.dataset_id -in $datasetIds })
    $reviewedFiles = @()
    $status = 'evidence_gap_no_eligible_market_measurement'
    $dates = 'Not established: suitable observations not acquired and reviewed for this indicator.'
    $method = 'Required method, not executed: ' + $requiredMethods[$indicator.indicator_id]
    $contextConfidence = 'Not assessable: no applicable acquired observation.'
    $proxy = $alternativeEvidence[$indicator.indicator_id] + ' Proposed evidence route only unless explicitly identified as acquired/processed in this row.'
    $additionalLimit = ''
    if ($indicator.indicator_id -eq 'I01') {
        $reviewedFiles = @('sdn_admin_boundaries.geojson.zip')
        $status = 'administrative_context_processed_site_identity_unresolved'
        $dates = 'COD v03 valid_on 2020-08-31; metadata reviewed 2025-10-30; original geometry edit 2013-08-13. Concept-note observation dates not established.'
        $method = 'Extract actual ADM2 features with adm1_pcode SD01 from downloaded archive. No site point or entrance inferred. See existing concept-note XML audit for the 14 populated entries.'
        $contextConfidence = 'Moderate for source administrative identifiers only; positional and current administrative validity not independently checked.'
        $additionalLimit = 'Seven Khartoum localities extracted; this does not assign individual markets to them.'
    }
    elseif ($indicator.indicator_id -in @('I08','I09','I10','I11','I32')) {
        $reviewedFiles = @('worldpop_sdn_catalogue.json','sdn_admpop_adm1_2025.csv','sdn_admpop_adm2_2025.csv','2025-sdn-cod-ps-end_user_release_note.pdf','sdn_2025_technical_accompanying_note.pdf')
        $status = 'population_context_conflicting_reference_date_no_market_derivation'
        $dates = 'WorldPop queried collection: 2000-2020 catalogue only. Acquired COD CSV Year=2024; named 2025; release note reference 2025-07-01. Unresolved.'
        $method = 'Audit actual Year fields and count source records; compare to the acquired release note. Do not redistribute totals, infer trader demographics or calculate catchments.'
        $contextConfidence = 'Not assessable for current population denominators until the reference-date conflict is resolved.'
        $additionalLimit = 'Release note describes cohort-component projection and ADM2 iterative proportional fitting, not observed occupancy. Grid values not downloaded.'
    }
    elseif ($indicator.indicator_id -in @('I12','I14','I39')) {
        $reviewedFiles = @('hdx_wfp_prices_sdn_resource.csv','hdx_wfp_prices_sdn_metadata.json','worldbank_sdn_cpi_inflation.json','worldbank_sdn_official_fx.json')
        $dates = $pricePeriod + '. World Bank non-null requested observations 2019-2022; 2023-2025 null; no 2026 observation returned.'
        $contextConfidence = 'Moderate for exact published monitoring series and arithmetic; low for representativeness and none for attribution to a selected market.'
        $additionalLimit = 'WFP market 2588 is labelled Khartoum, admin2 Jebal Aulya. Site equivalence to any KHM ID is unverified. Units and retail/wholesale series are kept separate; dates retain provider labels.'
        if ($indicator.indicator_id -eq 'I12') {
            $status = 'observed_source_prices_and_matched_changes_processed_context_only'
            $method = 'Keep original source rows. Group by market_id, commodity_id, unit, pricetype, currency and priceflag. Latest nominal monthly change = 100*(latest/prior-1), only for unique positive consecutive-month observations. No inflation or FX adjustment.'
            $proxy = 'Available narrower evidence: actual prices at WFP monitoring market 2588; do not label them as individual selected-market prices.'
        }
        elseif ($indicator.indicator_id -eq 'I14') {
            $status = 'eligible_source_series_volatility_processed_context_only'
            $method = 'For the latest 12 distinct consecutive positive monthly observations in each exact series, calculate sample standard deviation of 11 log price ratios, divisor 10. Otherwise leave result absent. Exchange-rate series remains explicitly labelled, not a food commodity.'
            $proxy = 'Available narrower evidence: source-series nominal variability; does not establish market resilience or real price stability.'
        }
        else {
            $status = 'price_numerator_available_income_denominator_missing'
            $method = 'Retain source price context only; no basket-cost-to-income or terms-of-trade calculation without an applicable dated denominator and basket.'
            $proxy = 'Available narrower evidence: commodity price changes, not affordability. Seek an actual comparable wage or transfer observation.'
        }
    }
    elseif ($indicator.indicator_id -in @('I21','I36')) {
        $reviewedFiles = @('jrc_flood_hazard_README.txt','jrc_flood_tile_extents.geojson')
        $status = 'hazard_metadata_reviewed_no_exposure_measurement'
        $dates = 'JRC hazard v2.1.2 README last updated 2026-01-12; temporal coverage explicitly NA; not a dated observed flood extent.'
        $method = 'Review actual producer README and tile index only. No raw hazard depth raster, asset exposure calculation or environmental permission assessment completed.'
        $contextConfidence = 'Moderate for producer-described product properties only; not assessable for local exposure or mitigation feasibility.'
        $additionalLimit = 'Approximate 90 m model grid, depth in metres; raw and classified depth differ. Need permanent-water/spurious-depth masks; nodata is not dry. Model artefacts and local drainage omissions apply.'
    }
    $matchedAssets = @($assets | Where-Object { (Split-Path $_.local_path -Leaf) -in $reviewedFiles })
    [pscustomobject]@{
        indicator_id=$indicator.indicator_id;indicator=$indicator.indicator;theme=$indicator.theme
        candidate_dataset_ids=$contract.dataset_ids
        candidate_dataset_sources=($candidates | ForEach-Object { $_.dataset_id + ': ' + $_.dataset_name + ' [' + $_.source + ']' }) -join ' | '
        candidate_source_urls=($candidates.url | Sort-Object -Unique) -join ' | '
        acquired_resource_urls=($matchedAssets.requested_url | Sort-Object -Unique) -join ' | '
        acquired_input_sha256=($matchedAssets | ForEach-Object { $_.local_path + '=' + $_.sha256 }) -join ' | '
        actual_methodology=$method;date_coverage=$dates
        limitations=$indicator.limitations + '. ' + $additionalLimit
        confidence_for_acquired_context=$contextConfidence
        confidence_for_selected_market_value='Not assessable: no eligible site-specific value established.'
        evidence_status=$status;selected_market_value_available='no'
        evidence_based_alternative_or_next_step=$proxy
        processing_reference='scripts/Build-EvidenceAudit.ps1; processed/verified_input_assets.csv'
    }
})
if ($indicatorMatrix.Count -ne 42 -or @($indicatorMatrix.indicator_id | Sort-Object -Unique).Count -ne 42) {
    throw 'Indicator matrix must cover each of the 42 existing indicators exactly once.'
}
foreach ($row in $indicatorMatrix) {
    foreach ($field in @('candidate_dataset_sources','candidate_source_urls','actual_methodology','date_coverage','limitations','confidence_for_selected_market_value','evidence_based_alternative_or_next_step')) {
        if ([string]::IsNullOrWhiteSpace($row.$field)) { throw "Missing required evidence field $field for $($row.indicator_id)" }
    }
}
$indicatorMatrix | Export-Csv -NoTypeInformation -Encoding utf8 (Join-Path $AssessmentRoot 'indicator_evidence_matrix.csv')
$summary = [ordered]@{
    generated_at=[datetimeoffset]::UtcNow.ToString('o');input_asset_checksums_verified=$assets.Count
    acquisition_attempts=$attempts.Count;wfp_sudan_source_rows=$prices.Count
    wfp_khartoum_source_rows=$localPrices.Count;wfp_khartoum_series=$seriesCoverage.Count
    wfp_selected_market_matches_established=0
    series_with_eligible_latest_12_month_volatility=@($seriesCoverage | Where-Object { $null -ne $_.monthly_log_change_sample_sd }).Count
    khartoum_admin2_features=$khartoumBoundaries.Count
    population_reference_date_conflict=$true;indicator_evidence_rows=$indicatorMatrix.Count
    selected_market_measurements_established=0;ranking_enabled=$false
    methods='Exact-label source filtering, direct nominal matched price arithmetic, source administrative extraction; no imputation, unit conversion, fuzzy site matching, population redistribution or scoring.'
}
$summary | ConvertTo-Json -Depth 6 | Set-Content -Encoding utf8 (Join-Path $outputRoot 'coverage_summary.json')
$summary | ConvertTo-Json -Depth 6