# Assessment C — SQLite vs Postgres for a multi-tenant B2B SaaS (~500 tenants)

## Recommendation
Use PostgreSQL. For a multi-tenant B2B SaaS with ~500 tenants and a mixed read/write workload, Postgres is the safer and more scalable default.

## Key considerations
- Concurrency: SQLite uses a single-writer lock — only one write transaction proceeds at a time across the whole database. With 500 tenants generating concurrent writes this becomes a throughput bottleneck; WAL helps read concurrency but not the single-writer constraint. Postgres uses MVCC and handles many concurrent writers.
- Deployment model: SQLite is an in-process embedded database reading/writing a local file, which makes running multiple application servers against one database awkward. Postgres is a client-server database designed for many app instances connecting to one database.
- Operational maturity: Postgres has mature managed hosting (RDS, Cloud SQL, Supabase, Neon), automated backups, point-in-time recovery, read replicas, and monitoring. SQLite's operational story for a server workload is thinner.
- Features for multi-tenancy: Postgres offers row-level security, rich data types, JSON, extensions, and concurrent index creation — several directly useful for tenant isolation and evolving the schema without downtime.
- When SQLite would be fine: a single-user desktop app, an edge deployment, or a very read-heavy low-write workload — where simplicity and zero network latency are attractive. A multi-tenant SaaS with concurrent writes is not that case.

## Confidence & what would change the answer
Start on Postgres; the small-team benefit of SQLite's simplicity is outweighed by the concurrency ceiling and operational maturity Postgres brings for a multi-tenant server workload. Use a managed Postgres provider to keep operational burden low.
