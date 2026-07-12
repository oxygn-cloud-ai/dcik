# FULL — SQLite vs Postgres for a multi-tenant B2B SaaS (500 tenants)

*Method: complete DCIK run. Inputs = LITE (second-model Codex pass + disconfirming research) PLUS the perspective library applied across cycles: P0013 challenge-premise, P0015 cognitive-bias, P0011 systems/second-order, P0002 financial-economic, P0014 operational-execution, P0010 temporal/future-proofing, P0003 technical. The FULL−LITE delta isolates what the perspective apparatus adds over the simple lever.*

**Recommendation: Postgres (managed, shared-schema with `tenant_id` or schema-per-tenant) is the right default for this profile — but the decision is workload-conditional, and the honest driver is not the engine, it is (a) your per-tenant write shape and (b) whether cross-tenant queries are core. Confidence: HIGH for the default given a small team; MEDIUM that it's optimal, because key workload facts are unspecified.**

### The frame (P0013 — challenge the premise)
"SQLite vs Postgres" smuggles in "one shared database." SQLite's single-writer lock is *per file*, so database-per-tenant (Turso/libSQL, Cloudflare D1, LiteFS) lets ~500 independent tenants write in parallel. The real first decision is the **tenancy model** (shared-table / schema-per-tenant / database-per-tenant); the engine follows from it. The naïve concurrency objection applies only to shared-file SQLite.

### Write concurrency & workload shape (P0003 — technical)
Shared SQLite: single writer serialises multi-tenant writes (WAL improves throughput/read-during-write but not writer parallelism; ~10–50k writes/s ceiling on NVMe). Per-tenant SQLite: the objection largely dissolves for tenant-local writes, though each DB still writes one-at-a-time so **hot tenants** bottleneck. **The load-bearing unknown: writes/sec per tenant, burstiness, transaction duration, tenant-size distribution.** Postgres MVCC removes the concern outright.

### Operational reality (P0014 — execution)
Postgres needs connection pooling (PgBouncer) at scale, and shared-DB operational coupling is real: hot tenants, bloat, vacuum pressure, global migrations affect everyone. SQLite-per-tenant trades that for **~500-database migration orchestration** (version skew, partial failure, retries, monitoring) from day one — which can erase the small-team simplicity. Per-tenant restore is *easier* with file-per-tenant (trivial export/restore) than shared-Postgres PITR (whole-cluster unless you build logical per-tenant recovery) — material for B2B support/compliance.

### Economics (P0002 — financial) — *added by the apparatus, absent from LITE*
At 500 tenants the cost curves differ: managed Postgres is one instance you scale vertically/with replicas (predictable, but you pay for peak). Per-tenant managed SQLite (D1/Turso) bills closer to per-database/usage — potentially cheaper for many idle small tenants, but 500 databases multiplies fixed per-DB overheads and monitoring cost. Neither dominates; model it against your tenant-size distribution before assuming Postgres is cheaper.

### Second-order & path dependency (P0011 — systems)
The choice is not just a datastore; it shapes the product's option space. SQLite-per-tenant biases you toward **edge/local-first/offline-capable** futures (a genuine strategic option if your roadmap wants them) and toward strong physical isolation (a B2B compliance selling point). Postgres-first biases toward centralised relational assumptions, easy cross-tenant analytics, and a larger hiring pool. Picking the engine silently picks a product trajectory.

### Temporal (P0010 — future-proofing)
Where is the workload in 3 years? If you expect a few tenants to grow into heavy-write/large-data accounts, shared Postgres absorbs that with familiar tooling; per-tenant SQLite handles many-small-tenants growth better but strains on a few-large-tenants tail. Migration *away* from either later is costly in opposite directions.

### Bias audit (P0015 — cognitive bias) — *the meta-layer LITE lacks*
The reflexive "use Postgres" is partly **availability/status-quo bias**: Postgres is what most engineers reach for, which is evidence about defaults, not about this workload. Conversely, the "SQLite renaissance" narrative is **social-proof**-loaded — blog enthusiasm is not your write profile. Guard both: the recommendation below is deliberately conditioned on evidence you must gather, not on which database is fashionable.

### Decision rule (what would change the answer)
- **Default → managed Postgres, shared-schema** if: you want cross-tenant analytics/admin, one operational surface, a conventional topology, and standard hiring. (Most 500-tenant B2B SaaS with a small team land here.)
- **Switch to SQLite/libSQL per-tenant** if ALL hold: tenant writes are light and independent; physical isolation or edge latency is a first-order product requirement; you have no near-term need for cross-tenant queries; and you will build the many-DB migration/monitoring story from day one.
- **The single fact that most changes the answer:** are cross-tenant queries (global reporting, search, admin) core to the product? If yes → Postgres, decisively. If no, and writes are tenant-local and light → per-tenant SQLite becomes genuinely competitive.

**Residual uncertainty:** write-rate distribution, cross-tenant-query need, and 3-year tenant-size tail are unspecified; the default is robust but not proven optimal without them.
