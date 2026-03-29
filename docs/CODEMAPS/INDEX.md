# Birusupi Jekyll Blog - Codebase Documentation Index

**Last Updated:** 2026-03-29

## Quick Navigation

Welcome to the Birusupi blog codebase documentation. This directory contains comprehensive architectural maps and technical specifications for every system in the project.

### Main Codemaps

| Document | Purpose | For Who |
|----------|---------|---------|
| [overview.md](./overview.md) | Full project structure, dependencies, and architecture | Everyone |
| [layouts.md](./layouts.md) | Layout hierarchy, template inheritance, frontmatter | Template developers |
| [includes.md](./includes.md) | All include files, dependencies, data sources | Template developers |
| [styles.md](./styles.md) | SCSS architecture, design tokens, responsive design | Frontend developers |
| [javascript.md](./javascript.md) | Client-side scripts, event handlers, accessibility | Frontend developers |

---

## Project at a Glance

**Tech Stack:**
- Jekyll 4.2 (static site generator)
- Liquid (templates)
- SCSS (styling)
- Vanilla JavaScript (client-side)
- Ruby (Gemfile)
- GitHub Pages (hosting)

**Key Features:**
- Paginated blog with post grid
- Tag-based archives (year, month, tags)
- Responsive design (mobile, tablet, desktop)
- Keyboard accessible navigation
- Image zoom with accessibility
- Table of contents with scroll highlighting
- Google Analytics + SEO optimization
- Content Security Policy

**Site URL:** https://spira-unplugged.github.io/birusupi

---

## File Structure Overview

```
birusupi/
├── _config.yml                 ← Configuration (plugins, site metadata)
├── _data/
│   └── settings.yml            ← Menu, social, analytics
├── _layouts/                   ← Page templates (8 files)
├── _includes/                  ← Reusable components (11 files)
├── _sass/                      ← SCSS modules (12 files)
├── assets/
│   ├── css/main.scss           ← CSS entry point
│   ├── js/                     ← JavaScript (4 files)
│   └── img/                    ← Post images
├── _posts/                     ← Blog posts (markdown)
├── pages/                      ← Static pages (about, blog, etc.)
├── docs/CODEMAPS/              ← This documentation
└── .github/workflows/          ← CI/CD (GitHub Actions)
```

---

## Quick Links by Role

### For Blog Contributors (Content)

1. Read [overview.md](./overview.md) - Understand how the site works
2. Check [layouts.md](./layouts.md) - Post frontmatter requirements (section: Frontmatter Standards)
3. Post format: `_posts/YYYY-MM-DD-slug.md` with required frontmatter

**Frontmatter Template:**
```yaml
---
layout: post
title: "Post Title"
date: 2026-03-29 12:00:00 +0900
categories: [category-name]
tags: [tag1, tag2, tag3]
excerpt: "Brief summary (shown in listings)"
image: /assets/img/post-slug/001.png
---
```

### For Template Developers

1. Start with [overview.md](./overview.md) - Full architecture overview
2. Read [layouts.md](./layouts.md) - Template hierarchy and relationships
3. Refer to [includes.md](./includes.md) - Reusable component specifications
4. Check [styles.md](./styles.md) - CSS classes and structure

**Common Tasks:**
- Add new page type → Create new file in `_layouts/` extending `default.html`
- Reuse component → Use `{% include component-name.html ... %}`
- Modify styling → Update relevant file in `_sass/` or `assets/css/`

### For Frontend Developers

1. Read [overview.md](./overview.md) - Feature overview
2. Check [styles.md](./styles.md) - Styling system, responsive design, tokens
3. Review [javascript.md](./javascript.md) - Client-side interactivity
4. Refer to [includes.md](./includes.md) - Component structure and data

**Common Tasks:**
- Add feature → Create new JS file in `assets/js/` and include in template
- Update styles → Modify SCSS modules in `_sass/`
- Fix accessibility issue → Check related JS or include for a11y attributes

### For DevOps / Deployment

1. Check [overview.md](./overview.md) - Build settings and plugins section
2. Review `.github/workflows/pages.yml` - GitHub Actions workflow
3. See `_config.yml` - Jekyll configuration and plugins

**Build Command:**
```bash
bundle exec jekyll build --destination _site
```

**Development Server:**
```bash
bundle exec jekyll serve
```

---

## Architecture Highlights

### Template Inheritance

```
default.html (base for all pages)
│
├─ home.html → Homepage with paginated grid
├─ page.html → Standard content pages
├─ post.html → Blog posts with sidebar and TOC
├─ category.html → Category archives
├─ tag.html → Tag archive (auto-generated)
├─ tags.html → Tags index
└─ archive-date.html → Year/month archives (auto-generated)
```

### Component System

**Reusable includes:**
- `category-card.html` - Post card display
- `toc.html` - Table of contents
- `post-date.html` - Date metadata
- `post-share.html` - Social sharing
- `disqus.html` - Comments (optional)

### Styling Organization

**SCSS modular structure:**
- `_tokens.scss` - Design tokens (colors, spacing, fonts)
- `_base.scss` - Global styles
- `_header.scss`, `_footer.scss` - Layout components
- `_home.scss`, `_page.scss`, `_post.scss` - Page layouts
- `_card.scss` - Card component
- `_code.scss` - Code blocks

### JavaScript Modules

| Module | Purpose | Loaded On |
|--------|---------|-----------|
| image-zoom.js | Click images to expand | Posts only |
| menu-toggle.js | Mobile menu + keyboard nav | All pages |
| toc.js | Highlight TOC during scroll | Posts only |
| external-links.js | Open external links in new tab | All pages |

---

## Recent Changes (as of 2026-03-29)

1. **New component:** `_includes/category-card.html` - Reusable card component
2. **Enhanced accessibility:** `menu-toggle.js` and `image-zoom.js` improvements
3. **Content Security Policy:** Added to `head.html` for security
4. **New plugins:**
   - jekyll-archives - Year/month/tag archives
   - jekyll-last-modified-at - "Updated" date for posts
   - jekyll-minifier - CSS/HTML minification (JS disabled)

---

## Key Concepts

### Liquid Templating

Jekyll uses Liquid for dynamic content:
```liquid
{% if condition %}
  {{ variable | filter }}
{% endif %}

{% for item in collection %}
  <article>{{ item.title }}</article>
{% endfor %}
```

**Variables:**
- `site.*` - Site-wide data (title, posts, date_format, etc.)
- `page.*` - Current page frontmatter (title, categories, tags, etc.)
- `paginator.*` - Pagination info (page, next_page, previous_page, etc.)

### Frontmatter

YAML metadata at top of markdown files:
```yaml
---
layout: post
title: "Post Title"
date: 2026-03-29
categories: [category]
tags: [tag1, tag2]
---
```

### Jekyll Plugins Used

| Plugin | Purpose |
|--------|---------|
| jekyll-feed | Atom feed (`/feed.xml`) |
| jekyll-seo-tag | SEO meta tags |
| jekyll-paginate-v2 | Homepage pagination |
| jekyll-archives | Archive pages (year/month/tag) |
| jekyll-last-modified-at | Post update date |
| jekyll-minifier | CSS/HTML minification |

---

## Common Tasks & How-Tos

### Add a New Blog Post

1. Create file: `_posts/2026-03-29-post-slug.md`
2. Add frontmatter (see [layouts.md](./layouts.md) - Frontmatter Standards)
3. Write markdown content
4. Optional: Add featured image to `assets/img/post-slug/`
5. Run `bundle exec jekyll serve` to preview
6. Commit and push to main branch

### Create a New Category Page

1. Create file in pages directory (e.g., `pages/travel.md`)
2. Set layout: `category`
3. Add frontmatter:
   ```yaml
   layout: category
   title: "Travel"
   category: travel
   description: "Travel posts"
   ```
4. Posts with `categories: [travel]` will be listed

### Modify Site Navigation

1. Edit `_data/settings.yml`
2. Update `menu` section:
   ```yaml
   menu:
     - {name: 'New Item', url: 'new-page'}
   ```
3. Changes apply to all pages automatically

### Update Social Links

1. Edit `_data/settings.yml`
2. Update `social` section with Font Awesome icon names
3. Special handling for Ko-fi (custom SVG)

### Change Colors/Typography

1. Edit `_sass/_tokens.scss` with design tokens
2. Verify breakpoints and responsive behavior
3. Run Jekyll dev server to preview changes
4. Check accessibility (color contrast, focus states)

### Add a New JavaScript Feature

1. Create file: `assets/js/feature-name.js`
2. Use vanilla JavaScript (no dependencies)
3. Wrap in `document.addEventListener("DOMContentLoaded", ...)`
4. Include in relevant layout/template:
   ```liquid
   <script src="{{ '/assets/js/feature-name.js' | relative_url }}"></script>
   ```
5. Add accessibility attributes if interactive

---

## Performance & Optimization

**Current Optimizations:**
- Pagination (6 posts per page) reduces initial load
- DNS prefetch for external services
- Preconnect to font servers
- Minified CSS/HTML (jekyll-minifier)
- Responsive images (lazy loading on post layout)
- Single overlay reused for image zoom (memory efficient)

**Metrics to Monitor:**
- Lighthouse scores
- Page load time (Core Web Vitals)
- JavaScript execution time
- CSS file size

---

## Security & Compliance

**Content Security Policy (head.html):**
- Restricts script execution to same-origin and trusted CDNs
- Allows fonts from Google Fonts and CDN
- Allows analytics and embedded Spotify frames
- Blocks object/embed tags

**Accessibility (WCAG 2.1 AA):**
- Semantic HTML
- Keyboard navigation (menu, images, TOC)
- ARIA attributes (aria-expanded, aria-controls, aria-label)
- Focus indicators on all interactive elements
- Sufficient color contrast

**Privacy:**
- Google Analytics for site metrics
- No tracking cookies (GA privacy mode compatible)
- Optional Disqus comments (disabled by default)

---

## Development Workflow

### Local Setup

```bash
# Clone repository
git clone https://github.com/spira-unplugged/birusupi.git
cd birusupi

# Install dependencies
bundle install

# Run development server
bundle exec jekyll serve

# Visit http://localhost:4000/birusupi/
```

### Build Production Site

```bash
# Build static site
bundle exec jekyll build

# Output in _site/ directory ready for GitHub Pages
```

### Git Workflow

- Branch: `main` (GitHub Pages source)
- Automatic deploy on push (GitHub Actions)
- All changes should be documented in commit messages

---

## Troubleshooting

**Issue: Site doesn't rebuild**
- Check `_config.yml` syntax
- Verify plugin compatibility with Jekyll 4.2
- Check Gemfile for conflicting versions
- Run `bundle update` to update dependencies

**Issue: TOC not highlighting**
- Verify headings have IDs
- Check `.post-body h2, h3, h4` are present
- Check `toc.js` is loaded on post layout

**Issue: Images not zooming**
- Verify images are in `.post-content` container
- Check images aren't already wrapped in `<a>` tags
- Check `image-zoom.js` is loaded on post layout
- Verify CSS class `.image-zoom-overlay` exists

**Issue: Mobile menu not working**
- Check `menu-toggle.js` is loaded
- Verify HTML structure matches expected (`.dropdown`, `.dropbtn`, `.dropdown-content`)
- Check for JavaScript errors in browser console

---

## Additional Resources

**Jekyll Documentation:**
- https://jekyllrb.com/docs/
- https://jekyllrb.com/docs/liquid/

**Liquid Reference:**
- https://shopify.github.io/liquid/

**Font Awesome Icons:**
- https://fontawesome.com/search

**WCAG Accessibility:**
- https://www.w3.org/WAI/WCAG21/quickref/

---

## Questions?

For detailed information on specific areas:

1. **Layouts & Templates** → See [layouts.md](./layouts.md)
2. **Components & Includes** → See [includes.md](./includes.md)
3. **Styling System** → See [styles.md](./styles.md)
4. **Client-Side Features** → See [javascript.md](./javascript.md)
5. **Overall Architecture** → See [overview.md](./overview.md)

---

**Generated:** 2026-03-29
**Version:** Jekyll 4.2
**Hosted:** GitHub Pages
