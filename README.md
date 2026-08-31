# Common Ground Cheltenham — website

Live site: https://commongroundcheltenham.com

A single-page static website. No build step, no server, no database.
Everything it needs is in this repository.

## Files

| Path            | What it is                                                  |
|-----------------|-------------------------------------------------------------|
| `index.html`    | The whole website — markup and CSS in one file               |
| `assets/`       | Photos (`.webp`) and the two fonts (Caprasimo, Figtree)      |
| `favicon.svg`   | The little icon in the browser tab                           |
| `robots.txt`    | Tells search engines they may index the site                 |
| `sitemap.xml`   | Lists the site's pages for search engines                    |
| `CNAME`         | Tells GitHub Pages which domain serves this site             |

## Hosting

Hosted free on GitHub Pages, deployed automatically from this repository.
Push a change to the `main` branch and the live site updates within a minute.

DNS stays with IONOS: four A records and a `www` CNAME point at GitHub. All
mail records (MX, SPF, DKIM, DMARC) are untouched by the website hosting.

Domain `commongroundcheltenham.com` is registered with IONOS.

## Viewing it locally

Open `index.html` in a browser. (Fonts may not load over `file://` because of
browser security rules — that's normal and does not affect the live site.)

To preview it exactly as it will appear live:

    cd community-site
    python3 -m http.server 8000

Then visit http://localhost:8000

## Making changes

Edit `index.html`, commit, push:

    git add -A
    git commit -m "Describe what changed"
    git push

## Known gaps

- Two photo slots in the original design were never filled in ("people together
  in the space", "workshop / creative activity"). Those two sections are now
  centred text blocks instead. To reintroduce a photo, convert the section back
  to `<div class="split">` with a `<div class="split-media">` alongside it — the
  "Our Story" section is the pattern to copy.
- Navigation links are anchors to sections on this one page. There are no
  separate pages yet.
- The footer "Explore" links point at existing sections, so several of them
  currently lead to the same place.
- The three Support buttons and "Tell Us Your Idea" open a pre-filled email to
  `hello@`. If a donation platform is set up later, point "Donate" at it.

## Design notes

Colours and typefaces (Caprasimo headings, Figtree body) are the "Organic /
Giverny" palette from the original design. The layout was rebuilt for the web:

- sticky header; on phones the menu becomes a full-screen panel
- a facts strip under the hero showing café hours, address and travel
- `scroll-margin-top` on sections so anchor links don't land under the header
- cards, split rows and a two-column contact grid instead of fixed-height blocks
- gentle reveal-on-scroll, all of which respects `prefers-reduced-motion`
- a skip link, visible focus rings and labelled interactive controls

The mobile nav panel deliberately sits *outside* `<header>`: the header uses
`backdrop-filter`, which creates a containing block and would otherwise trap
the `position: fixed` panel inside the 68px header.

## Origin

Built as a Claude Design canvas artifact, then converted to plain static HTML:
the canvas runtime, React and the Claude Design badge were removed, and images
and fonts were unpacked out of the bundle into `assets/`.
