# RustyEddy.com Site Cleanup TODO

## Goal: 

Clean up RustyEddy.com as a whole with primary focus on
site-wide message, tone, navigation, information architecture, and
general user experience.

## Context:

The site is a Hugo static site. The repo contains content/, layouts/,
assets/, data/, scripts/, static/, config.yml, STYLEGUIDE.md,
EDITORIAL.md, and related site tooling. The live site currently has
top navigation: iot, software, projects, notes, resume, about. The
current homepage says "I build and teach practical IoT, Linux, and Go
automation systems" and surfaces Projects, Writing, About/Resume, and
Recent writing. The strongest site direction is practical engineering
content around IoT, edge systems, Go, Linux, architecture, and
software delivery.

## Working rules:

- Preserve the author's direct, practical, mildly opinionated
  technical voice.
- Prefer architecture, boundaries, tradeoffs, and decision-making over
  beginner tutorials.
- Avoid marketing copy, hype, vague claims, visible TODOs, broken
  placeholders, and AI-sounding phrasing.
- Do not invent claims. Keep content grounded in existing projects and
  articles.
- Use Hugo front matter consistently.
- After each group of changes, run the existing site checks and Hugo
  build.

Suggested validation commands:
- hugo --minify
- ./scripts/check-links
- ./scripts/check-metadata
- ./scripts/check-discovery
- grep -RIn "TODO\\|FIXME\\|localhost\\|draft note\\|merge conflict\\|<<<<<<<\\|>>>>>>>" content layouts assets static || true

## Humor

Humor is welcome when it makes the writing feel human, but it should never
compete with the technical point.

Preferred humor:
- Dry, understated, and engineering-specific
- Used to acknowledge real-world messiness
- Short enough that it does not derail the paragraph
- Mildly self-aware, not performative

Good examples:
- "Hardware has a way of turning clean abstractions into field reports."
- "The happy path is where demos live. Production lives everywhere else."
- "MQTT is simple until the network disappears, which it will, usually during lunch."
- "A small script becomes infrastructure the moment someone else depends on it."
- "If the device needs a reboot ritual, the architecture is already leaving clues."

Avoid:
- Meme-heavy writing
- Sarcasm aimed at beginners or specific communities
- Jokes in titles, meta descriptions, or technical claims
- Forced punchlines
- Anything that makes the article less credible when skimmed by a technical lead

Rule of thumb:
One small wink per section is plenty. The reader came for useful engineering
judgment, not a stand-up set with YAML front matter.

P0 — Site-wide message and first impression
-------------------------------------------

[x] P0.1 Rewrite the homepage hero into a clearer positioning statement.
Files:
- content/_index.md
- layouts/index.html if homepage layout controls hero/cards

Problem:
The homepage message is directionally good but still reads partly personal/general. It should immediately tell an engineer what the site is about and why it is worth reading.

Implement:
- Replace/adjust homepage opening copy around this positioning:
  "Practical notes on building IoT, edge, Linux, and Go systems that
  survive contact with real hardware, unreliable networks, and
  changing requirements."
- Keep the Panasonic role only as a short credibility note, not the
  central message.
- Reduce the autobiographical paragraph on the homepage; move longer
  personal motivation to /about/.
- Make the homepage orient users around 3 paths:
  1. IoT & Edge Systems
  2. Software Architecture & Delivery
  3. Projects / Reference Implementations

Acceptance:
- Homepage H1 remains clear and simple.
- Above-the-fold copy answers: what this site is, who it is for, and where to go next.
- No hype words such as "revolutionary", "robust", "enterprise-grade", or "game-changing".
- Recent writing remains visible but is not the only path into the site.

[x] P0.2 Add a short site-wide tagline/subtitle near the brand or homepage.
Files:
- layouts/partials/header.html
- content/_index.md
- possibly config.yml if params are introduced

Problem: 

The nav brand currently appears as "rusty eddy:" and the live
nav only lists section names. Good minimalist style, but the site
lacks a persistent orientation cue for new visitors.

Implement:
- Add optional small subtitle on homepage or under brand:
  "IoT, edge systems, Go, Linux, and practical software architecture."
- Keep the header compact. Do not crowd mobile nav.
- If adding a site param, use config.yml:
  params:
    tagline: "IoT, edge systems, Go, Linux, and practical software architecture."

Acceptance:
- Desktop and mobile header remain readable.
- Subtitle does not appear as marketing copy.
- Header still feels lightweight.

P0 — Navigation and information architecture
--------------------------------------------

[x] P0.3 Rework top navigation labels for clearer user intent.
Files:
- layouts/partials/header.html

Current:
- iot
- software
- projects
- notes
- resume
- about

Implement:
- Change labels to title case for scanability:
  - IoT
  - Software
  - Projects
  - Notes
  - About
- Remove "resume" from primary nav or move it under About/footer.
- Keep /resume/ available, but reduce its prominence.
- Add a visible "Start Here" or "Writing" entry only if it maps to a real page. Do not add empty nav destinations.

Suggested nav:
- IoT
- Software
- Projects
- Notes
- About

Acceptance:
- Primary nav fits in one line on desktop.
- Resume remains reachable from /about/ and footer.
- Active section highlighting still works.
- Mobile navbar still expands/collapses correctly.

[x] P0.4 Add a "Start here" section to the homepage.
Files:
- content/_index.md
- layouts/index.html if needed

Implement:
Create three compact cards or sections:
- "Build IoT systems like software systems" -> /iot/
- "Make software projects predictable" -> /software/
- "See the reference implementations" -> /projects/

Each card should include:
- one sentence of plain-language value
- one primary link
- optional 2–3 supporting links

Acceptance:
- New visitors can choose a path without understanding the whole archive.
- Links use descriptive anchor text, not "click here".
- Homepage still has recent writing, but the content hubs are more prominent.

[x] P0.5 Add section intro/navigation blocks to article pages.
Files:
- layouts/_default/single.html or section-specific single templates
- layouts/partials/related-content.html
- content/iot/_index.md
- content/software/_index.md

Problem:
Individual articles have related reading, but readers need stronger next-step paths within the main content clusters.

Implement:
- Keep existing related content.
- For IoT articles, add a small "In this cluster" or "Where this fits" block near the end or sidebar:
  - IoT system architecture
  - Device abstraction layer
  - OttO edge runtime
  - MQTT / REST gateway notes
- For Software articles, add a similar sequence:
  - Software is Hard
  - Use Cases
  - Use Cases to Tasks
  - Kanban
  - TDD
  - Peer Review
  - Release Process
- Prefer a data-driven partial if simple, for example data/clusters.yml.

Acceptance:
- At least IoT and Software article pages expose a coherent next-step path.
- No duplicate "Related reading" sections.
- Current Hugo build succeeds.

P0 — Remove visible unfinished or low-confidence content
-------------------------------------------------------

[x] P0.6 Hide or fix visible TODO placeholders.
Files:
- content/projects/this-website/*
- search all content files

Known issue:
The live "How I Made This Web Site" page contains a visible "TODO - put a screen shot here…"

Implement:
- Either add a real screenshot/image with useful alt text, or remove the TODO entirely.
- Search all content for TODO/FIXME/placeholder/draft markers.
- Any public page with unresolved TODOs should be fixed or marked draft: true.

Acceptance:
- grep finds no public visible TODO/FIXME placeholders in content.
- The "How I Made This Web Site" page no longer contains a visible TODO.
- If the page is not worth updating now, set draft: true or remove it from project listings.

[x] P0.7 Review /notes/ for broken, typo-heavy, or outdated entries and demote weak pages.
Files:
- content/notes/*
- content/notes/_index.md
- EDITORIAL.md

Problem:
The Notes section mixes strong newer content with older rough notes. The section can remain a notebook, but it should not undermine the current site tone.

Implement:
- Audit all published notes for:
  - obvious typos in titles/descriptions
  - broken grammar in summaries
  - obsolete or unsupported claims
  - visible rough-draft language
- Fix quick wins.
- For pages that are historically useful but rough, keep them as notes and add a short editorial note at top:
  "Older project note. Kept for context; not a current recommendation."
- For pages that are broken or not useful, set draft: true.
- Update content/notes/_index.md copy to explain that Notes are smaller working references, not canonical architecture articles.

Acceptance:
- /notes/ still has useful archive value.
- Old notes no longer compete with pillar articles as canonical guidance.
- Titles and summaries are typo-clean.

P1 — Tone and content consistency
---------------------------------
[ ] P1.x Add restrained humor guidance to the writing style guide.
Files:
- STYLEGUIDE.md

Implement:
- Add a "Humor" section after "Voice & Tone".
- Define the desired humor as dry, understated, engineering-specific, and sparse.
- Include examples that match RustyEddy.com topics: IoT, hardware,
  networking, Go, Linux, automation, and small-team software delivery.
- Explicitly warn against memes, forced jokes, sarcasm toward
  beginners, and humor that weakens technical credibility.

Acceptance:
- The guide allows personality without changing the core voice.
- Humor supports clarity and trust.
- Technical pages still feel useful to engineers, technical leads, and founders.

[ ] P1.1 Tighten /about/ so it supports the site mission.
Files:
- content/about/_index.md or equivalent

Problem:
The About page has strong background but can better connect the career story to the site's present focus.

Implement:
- Keep the career credibility.
- Shorten historical sections where they delay the current message.
- Add a clear "What this site is for" section:
  - practical engineering notes
  - IoT and edge architecture
  - Go/Linux systems
  - small-team software delivery
- Add links to /iot/, /software/, /projects/ and /resume/.
- Keep personal voice, but remove phrases that feel too casual for the current site if they interrupt flow.

Acceptance:
- About page explains why readers should trust the writing.
- Resume is linked from About.
- Page does not feel like a disconnected biography.

[ ] P1.2 Modernize /resume/ or reduce its public prominence.
Files:
- content/resume/*
- layouts/resume/*
- footer/header partials as needed

Problem:
The resume page includes older phrasing, typos, and personal contact details. It is currently in primary nav, which makes it feel like a main site destination.

Implement:
- Move Resume out of top nav.
- Link it from About and footer as "Resume".
- Fix obvious typos and outdated phrasing:
  - "truley" -> "truly"
  - "devics" -> "devices"
  - "maintanance" -> "maintenance"
  - "Firmaware" -> "firmware"
  - "indepently" -> "independently"
  - "kernal" -> "kernel"
- Consider removing phone number from public page or moving detailed contact info to PDF only.
- Align resume headline with current positioning:
  "Software engineer focused on networking, embedded systems, IoT, Go, and distributed systems."

Acceptance:
- Resume remains accessible but not a primary site path.
- Obvious typos are fixed.
- Public contact details are intentional.

[ ] P1.3 Normalize section index pages.
Files:
- content/iot/_index.md
- content/software/_index.md
- content/projects/_index.md
- content/notes/_index.md

Implement:
For each section index, ensure it has:
- one-sentence purpose
- who the section is for
- 3–6 curated links grouped by intent
- a clear distinction between pillar articles, supporting articles, projects, and notes

Specific improvements:
- /iot/ is strong; keep the architecture-first tone and make the article grouping more compact.
- /software/ is clear; add a short "Start with..." path.
- /projects/ should clarify which projects are active/reference/historical.
- /notes/ should explicitly say notes are smaller working references and may be less polished than pillars.

Acceptance:
- All section pages answer: "Why am I here and where do I go next?"
- Section pages are not just chronological archives.
- Link groups use descriptive anchors.

[ ] P1.4 Add consistent "Why this matters" and "Common pitfalls" checks to pillar pages.
Files:
- content/iot/*.md
- content/software/*.md
- content/projects/*.md where project pages are case studies

Implement:
- Identify pillar and near-pillar pages.
- Ensure each has:
  - Why this matters
  - Common pitfalls
  - Where to go next or Related reading
- Do not force this structure onto short notes.
- Add missing sections only where they materially improve the page.

Acceptance:
- Pillar pages match the site style guide.
- Notes remain lightweight.
- No filler sections.

P1 — UX polish and readability
------------------------------

[ ] P1.5 Improve footer utility and reduce visual clutter.
Files:
- layouts/partials/footer.html

Current:
Footer includes last update, site by Eddy Consulting, GitHub/X/LinkedIn, and cookie consent.

Implement:
- Keep Last update.
- Add compact links:
  - About
  - Resume
  - GitHub
  - LinkedIn
  - RSS if generated
- Consider removing X from footer if it is not actively useful.
- Keep cookie banner, but ensure it is not visually dominant and works on mobile.
- Add a privacy link only if a privacy page exists; otherwise create a minimal /privacy/ page explaining analytics cookies.

Acceptance:
- Footer helps users find identity/contact/source links.
- No footer link points to a missing page.
- Cookie banner remains accessible.

[ ] P1.6 Add breadcrumbs or visible section context if not already rendered.
Files:
- layouts/_default/single.html
- layouts/partials/structured-data.html
- maybe new layouts/partials/breadcrumbs.html

Context:
Structured-data breadcrumbs already exist, but users need visible context too.

Implement:
- Add a small visible breadcrumb above article H1:
  Home / Section / Article
- Keep it subtle.
- Do not add breadcrumbs to homepage.
- Match schema breadcrumb logic.

Acceptance:
- Article pages show visible location.
- Breadcrumb links are valid.
- Structured data remains valid.

[ ] P1.7 Improve article list cards/snippets.
Files:
- layouts/_default/list.html
- section-specific list templates
- content front matter descriptions

Problem:
List pages should help readers choose what to read, not just expose titles/dates.

Implement:
- Ensure list entries show:
  - title
  - date only when useful
  - description
  - tags/categories where useful
- For Notes, keep date visible.
- For pillar/section pages, prefer curated order over pure date sort where appropriate.

Acceptance:
- /notes/ can remain chronological.
- /iot/ and /software/ emphasize curated learning paths.
- Descriptions render cleanly and consistently.

P1 — Metadata, SEO, and discovery
---------------------------------

[ ] P1.8 Complete front matter descriptions for all public pages.
Files:
- content/**/*.md
- scripts/check-metadata if needed

Implement:
- Ensure every public content page has:
  - title
  - description, ideally 140–160 chars
  - date
  - tags/categories where appropriate
  - draft explicitly set where useful
- Use the existing front matter template.
- Do not keyword-stuff.

Acceptance:
- ./scripts/check-metadata passes.
- No important public page relies only on auto-summary for meta description.
- Descriptions are specific and useful in search results.

[ ] P1.9 Improve site title and default metadata.
Files:
- config.yml
- layouts/partials/head-cheese.html

Current:
config.yml is minimal.

Implement:
- Add site params for:
  - description
  - image
  - author
  - tagline
- Use params.description as fallback meta description on homepage and pages without description.
- Keep title format:
  Page Title | Rusty Eddy
- Ensure OG/Twitter metadata still renders.

Suggested params:
params:
  description: "Practical engineering notes on IoT, edge systems, Go, Linux, and software architecture."
  tagline: "IoT, edge systems, Go, Linux, and practical software architecture."
  author: "Rusty Eddy"
  image: "/img/rusty.png"

Acceptance:
- Homepage has a real meta description.
- Pages with custom descriptions keep them.
- No duplicate/conflicting description tags.

[ ] P1.10 Add or verify RSS and sitemap discoverability.
Files:
- config.yml
- layouts/sitemap.xml
- layouts/_default/rss.xml if present
- header/head partial

Implement:
- Verify Hugo generates sitemap.xml and RSS feeds.
- Add RSS link in head if feed exists.
- Add visible RSS link in footer if feed exists.
- Ensure robots.txt exists and points to sitemap if appropriate.

Acceptance:
- /sitemap.xml works.
- /index.xml or section feeds work if enabled.
- Footer RSS link only appears if valid.

P2 — Internal linking and cluster cleanup
-----------------------------------------

[ ] P2.1 Apply internal link map to IoT cluster.
Files:
- content/iot/*.md
- content/projects/otto/*
- content/projects/gardener/* if present

Implement:
- Ensure IoT pillar/supporting pages link early to:
  - /iot/building-iot-device-manager-in-go/
  - /iot/iot-device-management/ if present
  - /iot/edge-device-architecture/ if present
  - /iot/iot-system-architecture-device-to-cloud/
  - /projects/otto/
- Use preferred anchors:
  - "IoT device manager"
  - "device abstraction layer"
  - "Go interfaces"
  - "edge computing"
  - "Fedora IoT"

Acceptance:
- Pillar pages link to supporting posts.
- Supporting posts link back to pillar pages.
- No paragraph is overloaded with links.

[ ] P2.2 Apply internal link map to Software cluster.
Files:
- content/software/*.md

Implement:
- Make /software/ the hub for software delivery content.
- Ensure articles link logically through the workflow:
  Software is Hard -> Use Cases -> Use Cases to Tasks -> Kanban -> TDD -> Peer Review -> Release Process.
- Add a short "Where this fits" line where useful.

Acceptance:
- A reader can follow the software delivery sequence without relying on browser back.
- Links are contextual, not dumped at the end only.

[ ] P2.3 Clarify project statuses.
Files:
- content/projects/_index.md
- content/projects/*

Implement:
- Add status labels in project pages/front matter:
  - Active
  - Reference implementation
  - Historical
  - Archived
- Surface status in project list cards.
- For older projects like RedEye or This Website, clearly mark whether they are historical or current.

Acceptance:
- Projects page no longer implies every project is equally current.
- Project pages remain useful as case studies even when old.

P2 — Cleanup older content without erasing archive value
-------------------------------------------------------

[ ] P2.4 Add an "older note" shortcode or partial.
Files:
- layouts/shortcodes/older-note.html or layouts/partials/older-note.html
- content/notes/*

Implement:
Create a reusable note box:
"Older project note. Kept for historical context; some implementation details may no longer reflect my current recommendations."

Use it on old notes that are useful but not canonical.

Acceptance:
- Old content is clearly framed.
- No need to fully rewrite every historical note before publication.

[ ] P2.5 Fix obvious typos in old public notes.
Files:
- content/notes/*.md
- content/**/*.md

Known examples from live pages:
- "MQTT For Controllor Communication" -> "MQTT for Controller Communication"
- "reffered" -> "referred"
- "an popular" -> "a popular"
- "Wifi" / "WIFI" -> "Wi-Fi" unless preserving code/product names
- "Golang" -> "Go" in titles unless discussing search phrasing intentionally

Acceptance:
- Common typo scan returns clean or intentionally ignored results.
- Titles look professional in lists and search results.

P2 — Accessibility and HTML quality
-----------------------------------

[ ] P2.6 Audit images for useful alt text.
Files:
- content/**/*.md
- layouts shortcodes for images
- static/img or assets images

Implement:
- Ensure project images and architecture diagrams have descriptive alt text.
- Decorative images should be empty-alt if template supports that.
- Architecture diagrams should include nearby text explaining the diagram.

Acceptance:
- No meaningful image lacks alt text.
- Diagrams remain understandable in surrounding prose.

[ ] P2.7 Check heading hierarchy.
Files:
- content/**/*.md
- layouts/**/*.html

Implement:
- Ensure each page has one H1.
- Do not skip from H2 to H5 for visual styling.
- Fix resume headings if template/content creates too many tiny heading levels.

Acceptance:
- Pages have semantic heading order.
- Visual styling is done with classes, not incorrect heading levels.

P2 — Build and maintenance tooling
----------------------------------

[ ] P2.8 Add a single "site audit" script.
Files:
- scripts/check-site
- Makefile

Implement:
Create scripts/check-site that runs:
- hugo --minify
- ./scripts/check-links
- ./scripts/check-metadata
- ./scripts/check-discovery
- grep for visible TODO/FIXME/merge markers in public content
- optional markdown lint if already available

Add Makefile target:
check-site:
	./scripts/check-site

Acceptance:
- make check-site runs the complete validation.
- Script exits non-zero on failure.
- README or CLAUDE.md mentions the command.

[ ] P2.9 Add content quality checks for forbidden phrases.
Files:
- scripts/check-content-tone
- Makefile

Implement:
Create a lightweight grep-based check for phrases the editorial guide says to avoid:
- "This article will explore"
- "robust" unless allowlisted
- "enterprise-grade" unless allowlisted
- "game-changing"
- "revolutionary"
- "click here"
- visible "TODO"

Acceptance:
- make check-site includes content tone check or documents it separately.
- False positives can be allowlisted with comments.

P3 — Optional improvements after main cleanup
--------------------------------------------

[ ] P3.1 Add a dedicated /start/ page only if homepage becomes too dense.
Files:
- content/start/_index.md
- layouts as needed
- header nav only if useful

Implement:
Create "Start Here" with:
- Who this site is for
- Best IoT path
- Best software delivery path
- Best project/case-study path
- 5 recommended first reads

Acceptance:
- Only add if homepage is getting crowded.
- Do not create another thin page.

[ ] P3.2 Add a minimal /privacy/ page for analytics/cookies.
Files:
- content/privacy/_index.md
- footer.html

Implement:
Explain:
- Google Analytics cookies are used to understand traffic.
- No user accounts.
- No selling data.
- How to decline analytics cookies using the banner.

Acceptance:
- Cookie banner can link to privacy page.
- Language is plain and brief.

[ ] P3.3 Improve "How I Made This Web Site" or archive it.
Files:
- content/projects/this-website/*

Implement option A:
- Rewrite as a short current technical note about the site stack:
  Hugo, Markdown, Bootstrap, GitHub Pages, scripts, content workflow.
- Remove old cheerleading and typos.
- Add screenshot only if it teaches something.

Implement option B:
- Mark as historical or draft it.

Acceptance:
- Page no longer feels unfinished.
- Project list does not feature weak content as strongly as OttO/Trader/RedEye.

Final acceptance checklist
--------------------------

[ ] Homepage clearly positions RustyEddy.com around practical IoT, edge, Go, Linux, and software architecture.
[ ] Primary nav is simpler and more user-oriented.
[ ] Resume is accessible but not a main nav item.
[ ] Section pages act as useful hubs, not just archives.
[ ] No public visible TODO/FIXME placeholders remain.
[ ] Older notes are framed, fixed, or hidden.
[ ] Internal links connect pillars, supporting posts, and projects.
[ ] Metadata is consistent across public pages.
[ ] Hugo build and all site checks pass.
[ ] The site still sounds like Rusty: practical, direct, technical, and grounded.
