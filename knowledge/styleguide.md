# RustyEddy.com Writing Style Guide

## Purpose
This document defines the voice, tone, and structural expectations for
all content published on RustyEddy.com.

The goal is to produce high-signal technical writing that helps
engineers make better design and architectural decisions.

---

## Target Audience
- Software engineers
- Embedded / IoT developers
- Technical leads and architects
- Small teams building real systems

Readers are assumed to be technically competent. Avoid explaining
basics unless they are directly relevant.

---

## Voice & Tone

**Overall tone**
- Clear, direct, and practical
- Mildly opinionated, never preachy
- Confident but not arrogant

**Preferred style**
- Architecture-first
- Decision-oriented
- Tradeoffs > prescriptions

**Avoid**
- Marketing language
- Buzzwords without explanation
- “This article will explore…”
- Overly casual or hype-driven phrasing

---

## Content Philosophy

### What we prioritize
- System design and architecture
- Why decisions matter
- Tradeoffs and constraints
- Patterns that scale beyond toy examples
- Real-world considerations (ops, maintenance, failure modes)

### What we de-emphasize
- Step-by-step beginner tutorials (unless explicitly requested)
- Long code dumps
- Framework evangelism
- “Hello world” examples

---

## Code Usage Guidelines
- Code is optional, not mandatory
- Include code only when it:
  - Clarifies a concept
  - Demonstrates a pattern
  - Anchors an abstract idea
- Prefer:
  - Small, focused snippets
  - Pseudocode when implementation detail is not the point
- Avoid:
  - Full applications
  - Boilerplate-heavy examples

---

## Recommended Article Structure

Most articles should follow this general shape:

1. **Introduction**
   - State the problem
   - Explain why it matters in real systems

2. **Why This Matters**
   - Operational or architectural impact
   - What goes wrong if ignored

3. **Design / Architecture**
   - Core concepts
   - Patterns and abstractions
   - Alternatives and tradeoffs

4. **Common Pitfalls**
   - Mistakes seen in practice
   - Anti-patterns

5. **Checklist / TL;DR**
   - Actionable summary
   - Decision checklist

---

## Language & Formatting
- Prefer short paragraphs
- Use bullet lists for clarity
- Headings should be descriptive, not clever
- Assume readers skim first, then read deeply

---

## Opinions & Claims
- It is acceptable to be opinionated
- Opinions should be grounded in:
  - Experience
  - Engineering principles
  - Tradeoffs
- Avoid absolute statements unless justified

---

## Internal Linking
- Link to related RustyEddy.com content where appropriate
- Prefer contextual links over “See also” sections
- If unsure, leave a `TODO: internal link` note

---

## Final Quality Bar
Before publishing, ask:
- Does this help a real engineer make a better decision?
- Is every section earning its place?
- Could this apply beyond a toy project?

If yes — it’s ready.
