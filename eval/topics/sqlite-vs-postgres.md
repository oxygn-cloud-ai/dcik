# Topic: SQLite vs Postgres for a multi-tenant B2B SaaS

**Question posed to each arm (identical prompt):**

> We are building a new multi-tenant B2B SaaS application expecting roughly 500 tenants in
> year one, mixed read/write workload, small engineering team. Assess whether we should use
> SQLite or PostgreSQL as the primary datastore. Give a recommendation.

**Class:** technical design decision — partly verifiable (engine characteristics are facts),
partly judgement (fit to context). DCIK's marginal value is plausibly moderate here: a strong
model may already know the tradeoffs, so this topic tests whether the apparatus adds anything
on a decision the base model can partly handle.

## Gold reference (frozen 2026-07-03, before any arm was generated)

Derived from database-engineering fundamentals, independent of any DCIK run. Each item is a
material consideration a great assessment MUST genuinely engage (not merely name). Scorers
mark each hit/miss per arm.

- **g1 — Write concurrency ceiling.** SQLite serialises writes (single writer; WAL improves
  read concurrency, not concurrent writes). A write-heavy multi-tenant workload can bottleneck.
- **g2 — Deployment/concurrency model.** SQLite is in-process, not client-server. Multiple app
  servers sharing one DB file (esp. on network/NFS storage) is fragile; horizontal scaling of
  the app tier is constrained.
- **g3 — Tenant isolation architecture.** The single-DB-file vs schema-per-tenant vs
  DB-per-tenant choice is central. SQLite-per-tenant (e.g. libSQL/Turso) is a *legitimate*
  pattern that changes the analysis — a great answer surfaces it rather than assuming one DB.
- **g4 — Operational maturity.** Backups, point-in-time recovery, replication, managed
  services: Postgres ecosystem is far more mature. SQLite has litestream/LiteFS but they are
  younger and shift operational burden onto the team.
- **g5 — Feature fit for tenancy.** Postgres offers row-level security, richer types,
  concurrent DDL, extensions — several directly useful for multi-tenant isolation and
  migrations. SQLite is comparatively limited.
- **g6 — Migration cost / future-proofing.** Starting on SQLite and later moving to Postgres
  has real cost; the assessment should weigh YAGNI (start simple) against lock-in/migration risk.
- **g7 — Genuine SQLite advantages.** Zero network latency (embedded), operational simplicity,
  low cost, edge suitability. A balanced answer does not strawman SQLite; these can matter for
  read-heavy or latency-sensitive cases.
- **g8 — Team & ecosystem fit.** Small team: hiring, familiarity, library/ORM support,
  observability tooling — Postgres's ubiquity vs SQLite's simplicity.

**Gold item count: 8.** (An assessment scoring high on recall genuinely engages most of these;
naming without engaging does not count as a hit — that is the scorer's judgement call, which is
why inter-rater kappa is reported.)

**Note on the "right" answer:** there isn't a single one — for ~500 tenants with mixed
read/write and a small team, Postgres is the common default, but SQLite-per-tenant is a
defensible modern pattern. The eval does NOT score which conclusion an arm reaches; it scores
whether the reasoning engaged the material considerations and avoided errors.
