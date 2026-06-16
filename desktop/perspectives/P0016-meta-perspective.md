# Perspective: Meta-Perspective (Library Self-Audit)

**ID:** P0016
**Domain:** Meta-cognition, perspective completeness, analytical coverage
**Invoke when:** At the start and end of every DCIK run. This perspective audits the perspective library itself.

## Lens

1. **Coverage audit:** Which analytical domains does the topic touch that are NOT represented in the current perspective library? What lens is missing?
2. **Perspective quality:** Which perspectives proved most valuable in this run? Which added the least? Should any be refined, merged, or deprecated?
3. **Blind spot detection:** What did the adversarial process consistently miss across cycles? Could a new perspective have caught it earlier?
4. **Domain specificity:** Does the topic require a domain-specific perspective (e.g., ICANN governance, gTLD economics, Singapore company law)? Should a project-local perspective be created?
5. **Interaction effects:** Did combinations of perspectives surface insights that individual perspectives missed? Are there valuable perspective pairings that should be documented?
6. **Library evolution:** What has been added, changed, or removed since the last run? Is the library improving or accumulating cruft?
7. **Gap-to-value ratio:** For each identified gap, estimate the marginal value of filling it. Prioritise high-value gaps for new perspective creation.

## Default adversarial stance

Assume the library is incomplete. Assume there are blind spots we cannot see precisely because they are blind spots. Actively seek the unknown unknowns. Every DCIK run should either add a perspective or justify why none was needed.

## Protocol

At the start of each DCIK run:
1. Review the topic. Identify domains it touches.
2. Cross-reference against the perspective library. Flag gaps.
3. If a gap is material, draft a candidate perspective for the run.

At the end of each DCIK run:
1. Review which perspectives were applied and their impact.
2. Identify at least one candidate improvement to the library (new perspective, refinement, or deprecation).
3. Write the candidate to a new `.md` file or flag it for the user.
