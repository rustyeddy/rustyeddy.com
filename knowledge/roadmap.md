# RustyEddy.com Content Roadmap

Tracks intended site structure, what exists today, and what still
needs to be written. Audience: engineering peers and hiring managers.
Voice and structure follow `knowledge/styleguide.md`.

---

## Current focus (in order)

1. **Trader** ([github.com/rustyeddy/trader](https://github.com/rustyeddy/trader))
   — write up the trader project for the site. Structure (a single
   `/projects/trader/` showcase, supporting essays in `/software/`,
   or both) to be decided when we start.

## Working rule for formatting / systematic issues

When a systematic formatting or consistency issue surfaces during
focused work above, it gets a decision in the moment:

- **Fix now** if it's small, mechanical, and won't derail the current
  focus, **or**
- **Add to the TODO list below** for a later dedicated pass.

This keeps focused work from sprawling, but also keeps issues from
being lost.

## TODO (deferred items)

- [ ] Unified tag/category scheme across articles. Front-matter is
      currently inconsistent — most articles only have
      `title`/`date`/`description` even though
      `knowledge/front-matter-templ.md` prescribes `tags`,
      `categories`, and `slug`. Resolve when we have a clear taxonomy.
- [ ] Replace the deprecated `gist` shortcode (deprecated in Hugo
      v0.143.0). Used in `iot/iot-gateway-mqtt.md`,
      `notes/go-configuration.md`, and `projects/redeye/_index.md`.
      See [Hugo docs](https://gohugo.io/shortcodes/gist) for the
      replacement pattern.

---

## Site sections — current state

### Home

- [x] Hero copy in `content/_index.md`
- [x] `layouts/index.html` rewritten: hero + three cards + recent posts

### `/iot` — IoT Pillar

Existing pillar essays:

- [x] Building an IoT Device Manager in Go
- [x] IoT System Architecture: OttO
- [x] IoT System Architecture: Device to Cloud
- [x] IoT Edge Gateway
- [x] IoT Gateway: MQTT
- [x] IoT Gateway: REST
- [x] IoT Sensor Station
- [x] Self-Watering Garden

Originally planned but not written:

- [ ] IoT Station — Embedded Thing
- [ ] IoT GUI — Modern Web Technologies
- [ ] IoT Cloud — Secure Global Access

### `/software` — Software Engineering Pillar

Existing pillar essays:

- [x] Kanban
- [x] Version Control Systems
- [x] Test-Driven Software Development
- [x] Peer Review (Pull Requests & Code Reviews)
- [x] Release Process (CI/CD)
- [x] Software is Hard
- [x] Use Cases
- [x] Use Cases to Tasks
- [x] Website Design Process
- [x] Website Development Process
- [x] Wireframes and Storyboards
- [x] Style Guide

Planned but not written:

- [ ] The Software Development Lifecycle (SDLC) — currently absorbed
      into `software/_index.md`; could split into a dedicated pillar.

### `/projects` — Showcase

- [x] RedEye — `content/projects/redeye/`
- [x] This Website — `content/projects/this-website/`
- [ ] **Trader** — see Current Focus #1
- [x] **OttO** — `content/projects/otto/` (2026-05-22)

### `/resume` + `/about`

- [x] Resume detail (`content/resume/`)
- [x] About bio (`content/about/_index.md`)

### Site chrome / infrastructure

- [x] Homepage rewritten
- [x] Footer copyright now dynamic (`{{ now.Year }}`)
- [x] Header `claa="h1"` typo fixed
- [x] Legacy UA Google Analytics tag removed; GA4 only
