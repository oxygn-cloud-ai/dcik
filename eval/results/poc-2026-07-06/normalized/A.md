# Assessment A — SQLite vs Postgres for a multi-tenant B2B SaaS (~500 tenants)

## Recommendation
Postgres is the right default, but the decision hinges on the tenancy architecture and the per-tenant write workload; "SQLite" is not automatically the naïve choice.

## Key considerations
- The question implicitly assumes one shared database. SQLite's single-writer lock is per file, so a database-per-tenant design (Turso/libSQL, Cloudflare D1, LiteFS) lets ~500 independent tenants write in parallel. Choose the tenancy model (shared-table `tenant_id` / schema-per-tenant / database-per-tenant) first; the engine follows.
- Write concurrency: shared SQLite serialises writers (WAL helps throughput/reads-during-write, not writer parallelism); per-tenant SQLite dissolves most of this, though a single DB still writes one-at-a-time so hot tenants bottleneck. The load-bearing unknowns are writes/sec per tenant, burstiness, and transaction duration. Postgres MVCC removes the concern.
- Deployment: many app servers sharing one SQLite file over a network filesystem is genuinely fragile (WAL needs writers on one host), but primary/replica (LiteFS) and serverless SQLite (D1) avoid it. Postgres is simpler for a conventional multi-server topology.
- Operational maturity: managed Postgres is broader and more battle-tested, but managed SQLite now exists (D1 Time-Travel PITR + read replicas; Turso replication). File-per-tenant makes per-tenant export/restore trivial, whereas shared-Postgres PITR restores the whole cluster unless you build logical per-tenant recovery — relevant to B2B support/compliance.
- Migration/lock-in cost runs both ways: Postgres-first locks in centralised relational assumptions; SQLite-per-tenant-first locks in orchestrating migrations across ~500 files (version skew, partial failure), which can erase small-team simplicity.
- Cross-tenant analytics and admin: shared-schema Postgres makes global reporting/search/admin straightforward; per-tenant SQLite needs fan-out or ETL. Often the decisive argument for Postgres. RLS helps shared-schema isolation at the cost of policy complexity; per-tenant designs isolate physically instead.

## Confidence & what would change the answer
For a small team wanting one operational surface and cross-tenant analytics, start on managed Postgres (shared-schema `tenant_id` or schema-per-tenant). Choose SQLite/libSQL per-tenant only if tenant workloads are write-light and independent, isolation/edge latency is first-order, and you'll build the many-databases migration/monitoring story from day one. Decide from actual write rates and whether cross-tenant queries are core.
