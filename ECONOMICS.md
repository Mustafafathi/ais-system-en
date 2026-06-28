# Business Value Model

AIS Attendance Platform reduces repetitive attendance administration and converts fragmented paper records into auditable operational data.

The reference model is based on recovered staff time. It does not assume staff reduction. The financial value comes from reallocating administrative hours to educational, analytical, and student-support work.

## Reference Assumptions

| Metric | Value |
| --- | ---: |
| Curator time recovered | 400 hours/year |
| Dean's office time recovered | 144 hours/year |
| Total recovered time | 544 hours/year |
| Administrative hour value | 500 RUB/hour |
| Annual recovered time value | 272,000 RUB |
| Annual OPEX | 52,000 RUB |
| Reference CAPEX | 0 RUB |

## Time Recovery

| Source | Calculation | Annual Hours |
| --- | ---: | ---: |
| Curator workflow | `2 x 200` | 400 |
| Dean's office workflow | `16 x 9` | 144 |
| Total | `400 + 144` | 544 |

```text
544 hours x 500 RUB/hour = 272,000 RUB/year
```

## Operating Cost

| Item | Annual Amount |
| --- | ---: |
| Maintenance and updates | 48,000 RUB |
| Documentation updates | 4,000 RUB |
| Total OPEX | 52,000 RUB |

```text
272,000 RUB - 52,000 RUB = 220,000 RUB/year
```

## Five-Year Discounted Value

The reference model uses a 10% discount rate.

| Year | Net CF | Discount Factor | Discounted CF | Cumulative NPV |
| ---: | ---: | ---: | ---: | ---: |
| 1 | 220,000 | 0.9091 | 200,002 | 200,002 |
| 2 | 220,000 | 0.8264 | 181,808 | 381,810 |
| 3 | 220,000 | 0.7513 | 165,286 | 547,096 |
| 4 | 220,000 | 0.6830 | 150,260 | 697,356 |
| 5 | 220,000 | 0.6209 | 136,598 | 833,954 |

## Outcome

| Indicator | Value |
| --- | ---: |
| Annual net cash flow | 220,000 RUB |
| Five-year NPV | 833,954 RUB |
| Discounted payback | Less than 1 year |

## Product Interpretation

The platform pays back by reducing repeated manual reconciliation:

- one attendance source of truth;
- faster group-level risk detection;
- fewer disputes between teacher and student-leader records;
- less manual preparation for dean's office reporting;
- reusable integration data from ERP/1C and SKUD systems.

Financial results should be recalculated for each institution using its own lecture volume, staff cost, discount rate, and support model.
