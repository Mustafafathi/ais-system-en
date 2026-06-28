# Economic Feasibility

This file translates the economic workbook into an auditable engineering narrative. The figures below were extracted from `ЭФФЕКТИВНОСТЬ ПРОЕКТА.xlsx`, sheet `Раздел 4`.

The key principle is that the system does not justify itself by firing staff. It reallocates expensive human time from repetitive attendance administration to educational and managerial work.

## Baseline Logic

The workbook models recovered time from two sources:

| Source | Calculation | Annual Hours |
| --- | ---: | ---: |
| Curator time | `2 x 200` | 400 |
| Dean's office staff time | `16 x 9` | 144 |
| Total recovered time | `400 + 144` | 544 |

The workbook uses a value of 500 RUB per administrative hour.

```text
544 hours x 500 RUB/hour = 272,000 RUB/year
```

## Operating Cost

| Item | Annual Amount |
| --- | ---: |
| Maintenance and updates | 48,000 RUB |
| Documentation updates | 4,000 RUB |
| Total OPEX | 52,000 RUB |

## Net Annual Cash Flow

```text
Recovered time value - OPEX = net annual cash flow
272,000 - 52,000 = 220,000 RUB/year
```

The workbook records CAPEX / one-time implementation cost as 0 RUB because the project was completed as academic graduation work using existing infrastructure.

## Discounted Cash Flow

The workbook applies a 10% discount rate across five years.

| Year | Net CF | Discount Factor | Discounted CF | Cumulative NPV |
| ---: | ---: | ---: | ---: | ---: |
| 1 | 220,000 | 0.9091 | 200,002 | 200,002 |
| 2 | 220,000 | 0.8264 | 181,808 | 381,810 |
| 3 | 220,000 | 0.7513 | 165,286 | 547,096 |
| 4 | 220,000 | 0.6830 | 150,260 | 697,356 |
| 5 | 220,000 | 0.6209 | 136,598 | 833,954 |

## Financial Outcome

| Indicator | Workbook Value |
| --- | ---: |
| Annual recovered time | 544 hours |
| Annual recovered time value | 272,000 RUB |
| Annual OPEX | 52,000 RUB |
| Annual net cash flow | 220,000 RUB |
| CAPEX | 0 RUB |
| 5-year NPV | 833,954 RUB |
| Discounted payback | Less than 1 year |

## ROI Note

The current workbook does not contain a visible ROI cell or formula. Earlier project notes mentioned 423%, but I do not report that as an audited repository figure unless the source workbook is extended with an explicit ROI calculation cell.

That is deliberate: portfolio documentation should be defensible. NPV, net cash flow, CAPEX, OPEX, and recovered hours are present in the workbook; ROI is not.
