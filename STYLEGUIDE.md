# RustyEddy.com Styleguide

This site should feel plain, technical, readable, and deliberate. It is a personal engineering site, not a marketing landing page. Prefer restrained structure, clear hierarchy, and durable content over decorative layout.

## Design Principles

- Keep pages text-first and easy to scan.
- Favor practical navigation and readable article layouts over visual novelty.
- Use Bootstrap utilities where they already fit the site.
- Add custom CSS only when it improves a repeated pattern or fixes a real readability issue.
- Keep visual changes modest unless they are part of a tracked design issue.

## Typography

- Body copy uses `Lora`.
- Headings and navigation use `Quicksand`.
- Base font size is defined in `assets/scss/style.scss` as `$font-size-base: 1.1rem`.
- Heading sizes should stay proportional to the base font size.
- Do not use viewport-scaled font sizes.
- Use `.small-text` for 14px text.
- Use `.smaller-text` for 11px text.
- Use `.footer-text` for footer-specific 13px text.

## Layout

- Use Bootstrap containers and grid classes for page structure.
- Keep prose content in a readable centered column.
- Avoid nested cards.
- Use cards only for distinct repeated items, clear calls to action, or framed tools.
- Do not use decorative gradient blobs, large abstract hero graphics, or ornamental background effects.
- Preserve stable dimensions for repeated UI elements so hover states and labels do not shift layout.

## Navigation

- Header links are generated in `layouts/partials/header.html`.
- Do not use `&nbsp;` or literal spacing in nav labels; use CSS spacing.
- The current section should receive `active` and `aria-current="page"`.
- Keep nav labels short and lowercase unless a broader site naming convention changes.
- The brand should remain lighter than page titles and should not use `h1` styling.

## Color

- Primary blue is `#0074d9`.
- Danger red is `#ff4136`.
- Keep the site mostly white with restrained accents.
- Link, hover, muted text, border, and background colors should be defined consistently in SCSS when expanded.
- Avoid one-note palettes and decorative gradients.

## Content Lists

- Section pages should help readers choose what to read next.
- Prefer article listings with title, date, description, and tags when useful.
- Avoid duplicate automatic and curated listings on the same page.
- Keep metadata visible only when it helps browsing or context.

## Articles

- Long articles should prioritize readable line length, clear heading rhythm, and code legibility.
- Code blocks should be horizontally scrollable when needed.
- Inline code and block code should use a consistent monospace stack.
- Blockquotes should use valid CSS and a restrained visual treatment.

## Images

- Images should have descriptive alt text.
- Article images should not overflow on mobile.
- Prefer consistent image margins, max widths, borders, and captions when captions are introduced.
- Captions should not replace alt text.

## CSS Maintenance

- Source styles live in `assets/scss/style.scss`.
- The site currently tracks generated CSS in both `static/css/style.css` and `assets/css/style.css`; keep them in sync when SCSS changes.
- Remove dead selectors and stale commented code.
- Prefer named variables for repeated sizes and colors.
- Keep helper classes named according to what they actually do.

## Validation

Run this before committing style changes:

```bash
make check
```

The check should pass metadata validation, Hugo build, link checking, and discovery checks.
