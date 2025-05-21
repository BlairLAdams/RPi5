# Silver Layer — QA & Parsing

This layer applies the following:

- Timestamp parsing into date and time
- Engineering unit standardization
- QA checks using domain logic (e.g., turbidity ≤ 5 NTU)

**Validation**: Great Expectations  
**Refresh**: Hourly  
**Downstream**: Gold model, Metabase QA dashboards
