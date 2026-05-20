# RustyEddy.com Content Roadmap

Tracks the intended site structure, what exists today, and what still
needs to be written. Replaces the older `sitemap.yml`, which described
a structure that didn't match the actual content tree.

Audience: engineering peers and hiring managers. Voice and structure
follow `knowledge/styleguide.md`.

---

## Home

- [x] `content/_index.md` — short hero copy exists but is **not currently
      rendered** by `layouts/index.html`. The homepage layout is a
      hardcoded 4-cell grid and needs to be rewritten to surface the
      hero, recent posts, and flagship projects.

## /iot — IoT Pillar

Existing pillar essays:
- [x] Building an IoT Device Manager in Go
- [x] IoT System Architecture: OttO
- [x] IoT System Architecture: Device to Cloud
- [x] IoT Edge Gateway
- [x] IoT Gateway: MQTT
- [x] IoT Gateway: REST
- [x] IoT Sensor Station
- [x] Self-Watering Garden

Originally planned but not written (from the old sitemap):
- [ ] OttO the IoT Edge Device — narrative-led overview of the full
      OttO system. Likely belongs under `/projects/otto/` rather than
      `/iot/`. See "Projects" below.
- [ ] IoT Station — Embedded Thing
- [ ] IoT GUI — Modern Web Technologies
- [ ] IoT Cloud — Secure Global Access

## /software — Software Engineering Pillar

Existing pillar essays:
- [x] Kanban
- [x] Version Control Systems
- [x] Test-Driven Software Development
- [x] Peer Review (Pull Requests & Code Reviews)
- [x] Release Process (CI/CD)
- [x] Software is a Team Sport
- [x] Software is Hard
- [x] Use Cases
- [x] Use Cases to Tasks
- [x] Website Design Process
- [x] Website Development Process
- [x] Wireframes and Storyboards

Planned but not written:
- [ ] The Software Development Lifecycle (SDLC) — currently absorbed
      into `software/_index.md`; could split into a dedicated pillar.

## /projects — Showcase

Audience choice (engineering peers / hiring managers) calls for the
projects page to act as a portfolio. Flagship lineup:

- [x] RedEye — `content/projects/redeye/`
- [x] This Website — `content/projects/this-website/`
- [ ] **OttO** — flagship, not yet created. Sources to draw from:
      `content/iot/iot-system-architecture-otto.md`,
      `content/iot/self-watering-garden.md`,
      `content/iot/building-iot-device-manager-in-go.md`.

## /resume + /about

- [x] Resume detail (`content/resume/`) — populated with jobs, clients,
      education, skills, summary, publications.
- [x] About bio (`content/about/_index.md`).

Pending polish:
- [ ] Soften `content/_index.md` description that calls the resume
      "reasonably outdated".

## Site Chrome / Infrastructure

- [ ] Rewrite `layouts/index.html` to render the home hero and offer a
      clear "hire me / read my work" split.
- [ ] Fix footer copyright (`© 2008 to 2024` → current year).
- [ ] Fix `claa="h1"` typo in `layouts/partials/header.html`.
- [ ] Drop the duplicate/legacy UA Google Analytics tag in
      `layouts/partials/footer.html`; keep only the GA4 tag.
- [ ] Decide on a tag/category scheme and front-matter consistency
      pass (currently inconsistent across articles).
