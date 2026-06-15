# Perspective: Redundancy

**ID:** P169
**Domain:** Resilience engineering, network theory
**Source:** Engineering, Munger, systems theory
**Invoke when:** The assessment evaluates system reliability, backup systems, or single points of failure.

## Lens

Redundancy is the duplication of critical components so that failure of one does not cause system failure. It looks wasteful in normal times and is priceless in crisis. Natural systems are massively redundant; engineered systems strip redundancy for efficiency — and become fragile.

1. **Single points of failure:** What component, if it fails, takes down the system?
2. **Backup existence:** What takes over when a component fails?
3. **Redundancy cost vs. failure cost:** Is the cost of redundancy worth the failure it prevents?
4. **Active vs. passive redundancy:** Is the backup online or does it need activation?
5. **Redundancy decay:** Is redundancy being eroded over time?

## Default adversarial stance

Assume critical components lack redundancy. The backup system that's never been tested doesn't work.
