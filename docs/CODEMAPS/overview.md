# Birusupi Jekyll Blog - Project Overview

**Last Updated:** 2026-03-29

**Repository:** GitHub Pages Jekyll Blog (Jekyll 4.2)
**Language:** Liquid (templates), SCSS, JavaScript, Ruby (Gemfile)
**Base URL:** https://spira-unplugged.github.io/birusupi

## Project Structure

```
birusupi/
├── _config.yml                 # Jekyll configuration (markdown, plugins, site metadata)
├── _data/                      # Data files for site configuration
│   ├── authors.yml
│   └── settings.yml            # Menu, social links, pagination text, analytics ID
├── _layouts/                   # Page layout templates (HTML + Liquid)
│   ├── default.html            # Base layout (head, header, footer, scripts)
│   ├── home.html               # Homepage with post grid and pagination
│   ├── page.html               # Standard page layout (with hero section)
│   ├── post.html               # Blog post layout (with TOC, metadata, navigation)
│   ├── category.html           # Category archive page with post grid
│   ├── tag.html                # Individual tag page
│   ├── tags.html               # Tags index page
│   └── archive-date.html       # Year/month archive layout
├── _includes/                  # Reusable HTML components
│   ├── head.html               # Document head (CSP, meta, links, analytics)
│   ├── header.html             # Site header with navigation and dropdown menu
│   ├── footer.html             # Site footer
│   ├── category-card.html      # Card component for posts (NEW)
│   ├── post-date.html          # Post metadata (date, author)
│   ├── post-share.html         # Social share buttons
│   ├── post-navigation.html    # Previous/next post links
│   ├── toc.html                # Table of contents sidebar
│   ├── disqus.html             # Comments section
│   ├── google-analytics.html   # GA script
│   ├── ga-events.html          # GA event tracking
│   └── json-ld.html            # Schema.org structured data
├── _sass/                      # SCSS stylesheets
│   ├── _index.scss             # Main imports
│   ├── _tokens.scss            # Design tokens (colors, spacing, typography)
│   ├── _base.scss              # Global styles (resets, typography)
│   ├── _default.scss           # Default layout styles
│   ├── _header.scss            # Header and navigation styles
│   ├── _footer.scss            # Footer styles
│   ├── _home.scss              # Homepage grid layout
│   ├── _page.scss              # Page layout styles
│   ├── _post.scss              # Post layout styles (article, sidebar, TOC)
│   ├── _card.scss              # Card component styles
│   ├── _code.scss              # Code block syntax highlighting
│   └── _social-icons.scss      # Social icon styles
├── assets/
│   ├── css/
│   │   ├── main.scss           # SCSS entry point (imports from _sass/)
│   │   └── syntax.css          # Rouge syntax highlighting
│   ├── js/
│   │   ├── image-zoom.js       # Click image to expand overlay (accessibility)
│   │   ├── menu-toggle.js      # Mobile menu toggle with keyboard nav (WCAG)
│   │   ├── toc.js              # Table of contents scroll highlighting
│   │   └── external-links.js   # Open external links in new tab
│   └── img/                    # Post images (organized by post date)
├── _posts/                     # Blog posts in YYYY-MM-DD-slug.md format
├── _drafts/                    # Draft posts (not published)
├── pages/                      # Static pages (blog, about, documentation, etc.)
├── _tag/                       # Tag archive pages (generated)
├── .github/workflows/          # GitHub Actions (publish to Pages)
└── Gemfile                     # Ruby dependencies
```

## Key Features

### Layout Hierarchy

```
default.html (base)
├── home.html (homepage with paginated grid)
├── page.html (standard page)
├── post.html (blog post with sidebar)
├── category.html (category archive)
├── tags.html (tags index)
├── tag.html (individual tag page)
└── archive-date.html (year/month archive)
```

### Site Configuration

**_config.yml highlights:**
- Markdown: kramdown
- Syntax highlighting: rouge
- Plugins: jekyll-paginate-v2, jekyll-feed, jekyll-seo-tag, jekyll-archives, jekyll-last-modified-at, jekyll-minifier
- Archive layouts: year, month, tags
- Pagination: 6 posts per page (homepage: 1 latest + 5 regular on page 1)
- Date format: `YYYY.MM.DD`
- Timezone: Asia/Tokyo
- Language: ja (Japanese)

**_data/settings.yml:**
- Menu: Blog, Documentation, Tags, GPTs, Playlist, About
- Social: X/Twitter, Bluesky, GitHub, Last.fm, Ko-fi
- Analytics: Google Analytics ID G-W1PYX136X2
- Comments: Disqus disabled

### Content Security Policy

**head.html includes CSP meta tag:**
```
default-src 'self'
style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://cdnjs.cloudflare.com
font-src https://fonts.gstatic.com https://cdnjs.cloudflare.com
script-src 'self' 'unsafe-inline' https://www.googletagmanager.com https://cdn.jsdelivr.net
img-src 'self' data: https:
connect-src https://www.google-analytics.com
frame-src https://open.spotify.com
object-src 'none'
```

## JavaScript Features

| File | Purpose | Used On |
|------|---------|---------|
| image-zoom.js | Click images to expand in overlay (keyboard + click) | Posts |
| menu-toggle.js | Mobile hamburger menu with WCAG keyboard nav (Arrow keys, Escape) | All pages |
| toc.js | Highlight TOC items as user scrolls | Posts |
| external-links.js | Open external links in new tab | All pages |

## Stylesheet Architecture

SCSS is organized into modular files:
- `_tokens.scss` - Design tokens (colors, spacing, breakpoints)
- `_base.scss` - Global resets and typography
- Component styles: `_card.scss`, `_header.scss`, `_footer.scss`, `_post.scss`, etc.
- `_home.scss` - CSS Grid layout for post cards
- `_code.scss` - Code block styling (pairs with syntax.css from Rouge)

## Recent Changes (as of 2026-03-29)

1. **New component:** `_includes/category-card.html` - Reusable card for displaying posts
2. **Updated JS:** `image-zoom.js`, `menu-toggle.js` - Enhanced accessibility
3. **CSP in head.html** - Content Security Policy meta tag added
4. **jekyll-archives plugin** - Year/month archive pages support
5. **jekyll-last-modified-at plugin** - "Updated" date on modified posts
6. **jekyll-minifier plugin** - JS minification disabled for complex syntax

## Build & Deploy

**Development:**
```bash
bundle exec jekyll serve
```

**Production:**
- GitHub Actions workflow: `.github/workflows/pages.yml`
- Builds and deploys to GitHub Pages on push to main
- URL pattern: `/archive/YYYY/MM/` (month), `/archive/YYYY/` (year), `/tags/TAGNAME/` (tags)

## Related Codemaps

- [Layouts Hierarchy](./layouts.md) - Detailed layout relationships and includes
- [Includes Architecture](./includes.md) - All include files and dependencies
- [Styling System](./styles.md) - SCSS structure and design tokens
- [JavaScript Modules](./javascript.md) - Client-side scripts and functionality
