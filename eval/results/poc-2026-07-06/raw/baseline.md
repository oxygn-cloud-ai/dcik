# BASELINE — SQLite vs Postgres for a multi-tenant B2B SaaS (500 tenants)

*Method: single-pass, best-effort, no web research, no perspective library, no adversarial cycle.*

**Recommendation: use PostgreSQL.**

For a multi-tenant B2B SaaS expecting ~500 tenants with a mixed read/write workload, PostgreSQL is the safer and more scalable default. Here's the reasoning:

**Concurrency.** SQLite uses a single-writer lock — only one write transaction can proceed at a time across the whole database. With 500 tenants generating concurrent writes, this becomes a throughput bottleneck. WAL mode helps read concurrency but does not remove the single-writer constraint. Postgres uses MVCC and handles many concurrent writers comfortably.

**Deployment model.** SQLite is an in-process, embedded database — it lives in your application process and reads/writes a local file. That makes it awkward to run multiple application servers against one database, which you'll likely want as you scale. Postgres is a client-server database designed for exactly this: many app instances connecting to one managed database.

**Operational maturity.** Postgres has a mature ecosystem for the things a B2B SaaS needs: managed hosting (RDS, Cloud SQL, Supabase, Neon), automated backups, point-in-time recovery, read replicas, and monitoring. SQLite's operational story for a server workload is thinner.

**Features useful for multi-tenancy.** Postgres offers row-level security, rich data types, JSON support, extensions, and concurrent index creation — several of which are directly useful for tenant isolation and for evolving the schema without downtime.

**When SQLite would be fine.** If this were a single-user desktop app, an edge deployment, or a very read-heavy low-write workload, SQLite's simplicity and zero network latency would be attractive. But a multi-tenant SaaS with concurrent writes is not that case.

**Bottom line:** Start on Postgres. The small team benefit of SQLite's simplicity is outweighed by the concurrency ceiling and the operational maturity Postgres brings for a multi-tenant server workload. Use a managed Postgres provider to keep the operational burden low.
