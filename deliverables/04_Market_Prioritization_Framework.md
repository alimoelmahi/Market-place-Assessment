# Market Prioritization Framework

Conditional rehabilitation opportunity and readiness, not a measure of humanitarian worth

## 1. Decision Logic

Apply the requested weights unchanged. Higher scores indicate stronger potential reach, physical access, supported operation, lower recorded recent conflict exposure, economic-system role, and documented feasibility. This is a proposed analytical model; neither its weights nor its cutoffs are established UNDP corporate standards. Approve assumptions before seeing market results to reduce discretionary ranking.

Keep three different outputs:

1. **Need:** documented deficits, excluded potential residents, vulnerability context, and recovery constraints. Present a documented low/moderate/high/unknown narrative classification, without pretending that unobserved traders have been surveyed.
2. **Opportunity/readiness score:** the weighted model below, with coverage and scenario bounds.
3. **Investment decision:** evidence plus safeguards, budget, additionality, distributional considerations, and approvals. A high score is not an approval.

High-functioning markets can score well but should not receive rehabilitation simply because they are large and accessible. Require an evidenced unmet deficit and additional benefit compared with no-build/service alternatives. High-need/low-readiness sites stay in an enabling-conditions portfolio, not off the map. Where no deficit is evidenced, classify as `no_rehabilitation_case_yet`, not an investment priority.

## 2. Criteria and Rationale

| Criterion | Code | Weight | Interpretation and direction |
|---|---|---|---|
| Population served | P | 20% | Modeled unique potential residents within 60 minutes walking under the stated market/network/population scenario; higher potential reach increases benefit, but not actual customers. |
| Accessibility | A | 15% | Population-weighted walking access from a fixed 5 km terrestrial neighborhood, penalized for disconnection; higher means less travel burden. Distinct from P's total catchment size. |
| Market functionality | F | 20% | Adapted evidence-supported operating/physical/service proxy; higher means a viable trading base for recovery. Not the full survey functionality index. |
| Conflict exposure | C | 15% | Inverse of recorded recent violent-event exposure; higher means lower recorded exposure, not safer passage or low humanitarian need. |
| Economic significance | E | 15% | Documented system role, network centrality, and distinct market functions; higher means a plausible wider market-system benefit. |
| Rehabilitation feasibility | R | 15% | Documentary evidence on land, engineering pathway, O&M, and environmental/social conditions; higher means more implementation preparation, not certified safety. |

Population and functionality receive the largest weights to balance potential people reached and a viable trading environment. Access, exposure, economic role, and feasibility have equal secondary weights. This is a transparent normative choice requested for this assessment, not an empirically estimated causal model. Avoid double counting by keeping conflict out of A/R subscore calculations, access out of F, and radiance out of both F and E. Correlations remain possible; inspect them without automatically changing weights.

## 3. Equations and Normalization

For scores on 0-100:

$$S_m=0.20P_m+0.15A_m+0.20F_m+0.15C_m+0.15E_m+0.15R_m.$$

Let $\operatorname{clip}(z)=\max(0,\min(1,z))$. Use the following fixed, provisional anchors in the supplied configuration. They are planning assumptions to be calibrated and signed off against the study's market types, not asserted Khartoum distributions. Freeze anchors and candidate/network extent within a published version; adding a market can otherwise change all ranks.

### P: Potential population reach

$$P_m=100\operatorname{clip}\left(\frac{\ln(\max(p_m,1000)/1000)}{\ln(100000/1000)}\right).$$

$p_m$ is unique nearest-market allocated potential residents within 60-minute walking reach. Values at or below 1,000 score 0; values at or above 100,000 score 100. The logarithm limits dominance by very large catchments. Raw low/central/high resident counts remain visible. Zero potential reach can be a valid modeled result; an unresolved location or invalid population raster is missing, not zero. Test population anchors and alternative catchment definitions before final approval. Allocation over a selected cohort must disclose omitted competing markets.

### A: Physical accessibility

For a fixed 5 km terrestrial neighborhood, let $f_m$ be the population fraction with feasible network paths and $t_m$ the population-weighted median walking time among reachable residents:

$$A_m=\begin{cases}0,& f_m<0.5\\100 f_m\operatorname{clip}((90-t_m)/(90-15)),& f_m\geq0.5.\end{cases}$$

The 15/90-minute anchors and the 50% reachability threshold are proposed assumptions. With no valid neighborhood population denominator, A is missing. Paths longer than 60 minutes may still enter this local burden statistic; P uses a 60-minute catchment. These represent distinct outputs, not inconsistent definitions. Use one agreed mode in the composite; freight and slower-walking cases are sensitivity results, not averaged as if they were observations. Do not penalize travel time twice inside F.

### F: Adapted functionality proxy

$$F_m=0.30V_m+0.30I_m+0.25O_m+0.15U_m.$$

| Component | Rule | Eligibility |
|---|---|---|
| V, availability | 100 x documented available eligible basket items / eligible items with valid availability observations | At least 80% of the pre-declared type-specific basket observed within freshness limit; no imputed stockouts from missing price rows. Publish basket completeness. |
| I, visible physical readiness | 100 x (1 - visibly damaged baseline-structure fraction) | Appropriate-resolution pre/post imagery or a comparable existing damage assessment; at least 80% of baseline structures observable. Counts roofs/structures, not structural safety or the quality of sanitation. If adequate baseline/imagery unavailable, I is missing. |
| O, documented operation | Closed = 0; partial = 50; open = 100 | Recent market-specific documentary status with explicit date and credible source. Disputed/unknown/historical-only = missing. No inference from nightlights alone. |
| U, supporting services | 100 x documented operating services / four service categories | Pre-declared categories: water, sanitation/waste, electricity or reliable alternative, loading/storage. Each category requires current evidence of operating or non-operating status; unknowns produce bounds. Mapped points are not proof of operation. |

I measures visible damage readiness, not all infrastructure quality. A market with no visible damage may still require rehabilitation for pre-existing deficits; that deficit must be documented separately. Specialized markets require an approved basket and comparable interpretation; present type-specific comparisons alongside any cross-type ranking. Do not compare unlike-basket assortment counts as if they were interchangeable goods.

### C: Inverse recorded conflict exposure

Define $x_m$ as the sum of qualifying violent-event records within a 5 km buffer and the preceding 180 days, with half-life 90 days:

$$x_m=\sum_{e}2^{-a_e/90},\qquad C_m=100\left[1-\operatorname{clip}\left(\frac{\ln(1+x_m)}{\ln(21)}\right)\right].$$

$a_e$ is age in days between event and analysis date, within 0-180. The sum uses unique event IDs, explicitly selected violence categories, and reviewed adequate spatial/temporal precision. Unusable geocodes are summarized separately and must not silently disappear from the narrative. Use event counts rather than fatality estimates to avoid giving uncertain death counts a spurious precision. The upper anchor of 20 weighted events is a provisional scaling assumption, not a danger threshold.

A valid dataset/window with zero qualifying records produces C = 100, but the label is **no qualifying recorded events**, not safe. If coverage, license/access, precision, or reporting suitability fails, C is missing. UN reports are corroboration and contextual disruption evidence; do not casually add report mentions to ACLED counts as separate events. Test distance, time window, reporting uncertainty, and upper anchor. Corridor exposure remains separate to avoid counting the same risk as a market and route score.

### E: Economic-system significance

$$E_m=0.40H_m+0.30B_m+0.30D_m.$$

- H, documentary reach/hierarchy: neighborhood retail = 25; district/multi-neighborhood = 50; locality-wide mixed/aggregation = 75; documented metropolitan/regional wholesale or specialized node = 100. An unsupported hierarchy is missing. Specialization alone is not proof of regional importance.
- B, physical-network centrality: $100\operatorname{clip}(b_m/0.10)$, where $b_m$ is normalized betweenness of the market's matched node on one fixed, documented road-network graph. Specify endpoint treatment, direction/mode, component handling, and normalization convention in the run manifest. It indicates possible network position, not actual trade. The 0.10 anchor is provisional and may require adjustment for the chosen graph before version approval.
- D, documentary function diversity: 25 points each for independently documented retail, wholesale, producer aggregation, and onward distribution functions, capped at 100. No inference from four commodity names. Roles may coexist; duplicated descriptions are one role.

Historical hierarchy can support a historical-role field; current E requires documentary support that the role remains relevant to the recovery scenario. Do not count warehouse/bank POIs as sales or use nightlights again here.

### R: Rehabilitation feasibility

$$R_m=0.30L_m+0.25G_m+0.25M_m+0.20Z_m.$$

L is documented land/permission pathway; G is available engineering/design/cost preparation; M is an identified and viable operations/maintenance arrangement; Z is environmental/social mitigation feasibility including flood, drainage, waste, inclusion, and potential displacement. Each component uses the same maturity rubric but requires component-specific supporting records:

| Score | Evidence requirement |
|---|---|
| 0 | Documented blocking condition with no presently viable lawful/technical/financial mitigation. |
| 25 | Documented major barrier; a possible remedy is identified but not yet shown viable. |
| 50 | Documented feasible pathway or option with unresolved approvals/design/financing requirements. |
| 75 | Supported practical option with responsible owner and most component-specific preparation complete. |
| 100 | Relevant component's required documentary preparation/approvals complete and current for the proposed scope. |

No record means missing, not 0 or 50. A component score of 100 cannot substitute for separate investment gates, future required inspections, or procurement approval. Do not infer L from apparently vacant land, G from roof appearance, M from population size, or Z from absence of a modeled flood pixel. Independent desk reviewers adjudicate rubric use and cite evidence IDs.

## 4. Missing Data, Confidence, and Comparability

Do not silently reweight available criteria. Expand the model into elementary components with fixed weights. Example: the availability component's total weight is 0.20 x 0.30 = 0.06. Within U, each of the four service categories has total weight 0.20 x 0.15 / 4 = 0.0075. If an elementary component is unknown, its lower score is 0 and upper score 100 solely for **uncertainty bounds**, not as a recorded observation.

$$S_m^- = \sum_{k\in K_m}w_k s_{mk},\qquad S_m^+ = S_m^-+100\sum_{k\notin K_m}w_k.$$

$$\mathrm{coverage}_m=\sum_{k\in K_m}w_k.$$

Known-component source/scenario intervals can further widen bounds. Publish the exact covered weight and the indicator evidence-type/confidence mix. Do not multiply the substantive score by confidence: that can systematically deprioritize poorly documented populations. Confidence remains a separate attribute and decision caveat.

Ranking rules:

- **Complete, comparable model:** all six criteria and required elementary components eligible; anchors and type rules identical within the comparison. Produce an analytical score and scenario ranks, but investment readiness still depends on gates and a documented rehabilitation case.
- **Provisional screening:** at least 80% covered weight, and at least 50% coverage within each criterion, with at least 75% within F and R. Show bounds and a provisional screening label only; do not mix these with a complete-model investment ranking.
- **Insufficient evidence:** all other cases. Show need and missing-data priorities; suppress point rank and midpoint score.
- Missing a mandatory safeguard means `unknown` and no investment-ready rank regardless of score coverage.
- For any comparison, if A's lower bound exceeds B's upper bound it robustly outranks B on this model. Otherwise the ordering may be indeterminate. Do not present arbitrary midpoint ranks as definitive.

Type-specific applicability changes require an approved model version and group-comparison statement. They must not be decided after seeing a site's score. Report any selection bias caused by comparing only documented markets.

## 5. Investment Gates and Need Portfolio

Each gate is pass/fail/unknown, supported by current documentary evidence and a responsible reviewer. Pass here means the relevant record supports proceeding to the specified stage, not universal safety certification.

| Gate | Requirement |
|---|---|
| Identity and scope | Verified location, market identity, intervention boundary, and responsible owner. |
| Security/access and explosive remnants | Current authorized operational assessment and any required qualified clearance; event maps alone cannot satisfy it. |
| Tenure and permission | Lawful land use, consent/permissions, no unresolved material dispute or forced-displacement implication. |
| Technical and environmental/social | Relevant engineering/safety review; flood/drainage/waste/fire/inclusion screening; feasible mitigation and permits for proposed scope. |
| Economic additionality and O&M | Evidenced deficit and demand rationale; viable maintenance owner/funding; no-build/service option considered; safeguards against displacement of existing traders. |

If records cannot establish a gate under secondary-only constraints, mark unknown and recommend the required future due diligence as a condition outside this desk study. Do not quietly collect new primary information to make the gate pass.

Need/readiness matrix:

| Need | Readiness / gates | Portfolio |
|---|---|---|
| High | Complete comparable model; supported gates | Candidate for detailed preparation and budget appraisal, not automatic award. |
| High | Low readiness, failed or unknown gates | Enabling measures and risk mitigation; retain visibility of excluded populations. |
| Moderate/low | High readiness | Compare marginal benefit and no-build options; do not prioritize solely because work is easy. |
| Unknown | Any | Evidence-resolution track; no implied low need. |

Avoid numerical cutoffs such as "score over 75 = approved" without calibration. Final selection may apply a declared budget, complementarity, inclusion, and geographic-equity rule after scoring; disclose every override and its justification.

## 6. Sensitivity and Robustness

1. Change each top-level weight by plus/minus 20% relative (not 20 percentage points), renormalizing the others proportionally to retain a sum of 1.
2. Run an equal-weight scenario, a population-need emphasis scenario, and a rehabilitation-readiness emphasis scenario. Explicitly label these alternative policy views; do not replace the requested base without approval.
3. Run low/central/high population, slower walking, wet-season restrictions, and selected bridge-closure scenarios. Test whether changes affect upstream data, not just the final weighted sum.
4. Test P/A/C/B anchors by plus/minus 20% where meaningful, market-type baskets, and event precision choices. Keep all bounds and assumptions documented.
5. Perturb supported subscore ranges and uncertain conditions through at least 1,000 reproducible scenario draws if tooling permits; a fixed random seed and draw distributions belong in the manifest. Draw frequencies are model robustness, not statistical probability of real-world benefit.
6. Publish median/min/max rank, top-three appearance share where the candidate set permits it, and pairwise score-margin/bounds. For small or incomplete groups favor ties and priority bands over precise ordinal claims.
7. Report Spearman rank association between comparable scenarios where ranks exist, score contribution charts, and correlations that reveal possible double counting. Do not infer robustness merely from a high correlation if shortlist membership changes.

## 7. Worked Example: Entirely Synthetic

The following values belong to fictional sites, not Khartoum markets:

| Fictional case | P | A | F | C | E | R | Weighted result |
|---|---|---|---|---|---|---|---|
| Example X | 80 | 60 | 50 | 70 | 90 | 40 | 65.0 |
| Example Y | 60 | 80 | 75 | 40 | 70 | 80 | 67.5 |

For X: $0.20(80)+0.15(60)+0.20(50)+0.15(70)+0.15(90)+0.15(40)=65$.

If X's entire R criterion is missing, coverage is 0.85 and the score is bounded by 59 and 74, not assigned a score of 65 or 69.4 by available-weight renormalization. It fails the criterion-coverage rule for provisional comparable screening and has no point rank. The example demonstrates that 85% overall coverage alone is insufficient. Neither example represents a rehabilitation recommendation, and a gate failure would prevent an investment-ready rank.

## 8. Visualization and Disclosure

- Map symbols: priority/opportunity band only for eligible comparisons; hatch or gray for insufficient evidence; separate gate status. Do not depict missing as the lowest performance class.
- Ranking matrix: criterion contributions, covered weight, score interval, scenario rank interval, need, and gates. Avoid decimal-heavy league tables; one decimal is sufficient for internal scores and whole-number public bands are usually preferable.
- Dumbbell/interval chart: low-central-high scenario scores; no central point when data coverage does not support one.
- Need-readiness quadrant: high-need/blocked markets remain visible with the enabling action needed.
- Recovery scorecards: six criteria, source dates, uncertainty, key deficits, and next decision. Show unknown explicitly instead of a filled radar axis at zero.
- Interactive weights: exploratory only in a clearly separated analyst view; never silently change the published official base model. Experience Builder is not assumed to implement a custom MCDA engine without development; precompute approved scenarios by default.

The accompanying JSON defines the requested weights, subweights, anchors, illustrative scenarios, and synthetic test cases. It is configuration, not a production scoring engine or a set of real market results.