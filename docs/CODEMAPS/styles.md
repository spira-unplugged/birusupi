# Styling System

**Last Updated:** 2026-03-29

## SCSS Architecture

```
assets/css/
├── main.scss                   # Main entry point (imports from _sass)
└── syntax.css                  # Rouge syntax highlighting (static)

_sass/
├── _index.scss                 # Barrel file: imports all modules
├── _tokens.scss                # Design tokens (colors, spacing, typography)
├── _base.scss                  # Global resets and typography
├── _default.scss               # Default layout (container, content-wrapper)
├── _header.scss                # Header navigation styles
├── _footer.scss                # Footer styles
├── _home.scss                  # Homepage grid layout
├── _page.scss                  # Page layout (hero, body)
├── _post.scss                  # Post layout (article, sidebar, TOC)
├── _card.scss                  # Card component (.home-card, .category-card)
├── _code.scss                  # Code blocks (pairs with syntax.css)
└── _social-icons.scss          # Social icon styles
```

## Compilation

**Entry Point:** `assets/css/main.scss`
```scss
---
# Jekyll YAML front matter (required)
---

@import 'index';  // Imports from _sass/_index.scss
```

**_sass/_index.scss:**
```scss
@import 'tokens';
@import 'base';
@import 'default';
@import 'header';
@import 'footer';
@import 'home';
@import 'page';
@import 'post';
@import 'card';
@import 'code';
@import 'social-icons';
```

**Output:** `_site/assets/css/main.css` (minified via jekyll-minifier)

---

## Design Tokens (_tokens.scss)

**Purpose:** Centralized design system values

**Typical Contents:**

```scss
// Colors
$color-primary: #007bff;
$color-text: #333;
$color-background: #fff;
$color-border: #ddd;

// Typography
$font-sans: 'IBM Plex Sans JP', sans-serif;
$font-mono: 'JetBrains Mono', monospace;
$font-size-base: 16px;
$font-size-h1: 32px;
$line-height-base: 1.6;

// Spacing
$spacing-xs: 4px;
$spacing-sm: 8px;
$spacing-md: 16px;
$spacing-lg: 24px;
$spacing-xl: 32px;

// Breakpoints
$breakpoint-mobile: 600px;
$breakpoint-tablet: 900px;
$breakpoint-desktop: 1200px;

// Transitions
$transition-duration: 200ms;
$transition-timing: ease-in-out;
```

---

## Module Details

### _base.scss
**Purpose:** Global styles and resets

**Includes:**
- CSS reset (normalize defaults)
- Root font-size and line-height
- Global link styles
- Code block defaults
- Image defaults (max-width, display)

---

### _default.scss
**Purpose:** Default layout container and structure

**Classes:**
```scss
.container
  └─ Max-width wrapper with horizontal padding
     └─ .content-wrapper
        └─ Main content area
```

**Responsive Behavior:**
- Single column on mobile
- Increases padding/max-width on tablet/desktop

---

### _header.scss
**Purpose:** Header and navigation styles

**Classes:**
```scss
.site-header
  └─ .site-header-inner
     ├─ .site-title (logo)
     ├─ .menu-list
     │  ├─ .menu-group.menu-primary (desktop nav items)
     │  └─ .menu-group.menu-social (social icons)
     └─ .dropdown (mobile menu)
        ├─ .dropbtn (hamburger button)
        └─ .dropdown-content
           ├─ .dropdown-section.dropdown-nav
           ├─ .dropdown-divider
           └─ .dropdown-section.dropdown-icons
```

**Breakpoints:**
- Mobile: Dropdown visible, desktop menu hidden
- Tablet+: Desktop menu visible, dropdown hidden

**States:**
- `.is-open` - Mobile menu open (added by JS)

---

### _footer.scss
**Purpose:** Footer layout and styling

**Classes:**
```scss
.site-footer
  ├─ .footer-content
  ├─ .footer-links
  ├─ .footer-social
  └─ .footer-copyright
```

---

### _home.scss
**Purpose:** Homepage grid layout

**Classes:**
```scss
.home-grid
  ├─ .home-card.home-card-latest (featured, page 1 only)
  │  └─ Larger card with featured image
  │
  └─ .home-card (regular cards)
     └─ Image + metadata grid

.pagination
  ├─ .pagination-button
  ├─ .pagination-button.pagination-active (clickable)
  └─ .pagination-button.next (next page)
```

**Grid Behavior:**
- Mobile: 1 column
- Tablet: 2 columns
- Desktop: 3 columns

**Featured Card (Page 1):**
- Spans full width
- Larger image
- Special `.home-card-latest` styling

---

### _page.scss
**Purpose:** Standard page layout

**Classes:**
```scss
.page-content
  ├─ .page-hero
  │  ├─ .page-kicker (subtitle)
  │  ├─ .page-title (h1)
  │  ├─ .page-subtitle (description)
  │  └─ .featured-image (optional)
  │
  └─ .page-body
     └─ Page content (h2-h6, p, lists, etc.)
```

**Hero Section:**
- Full-width background (optional image)
- Centered text overlay
- Special styling for hero-category (category pages)

---

### _post.scss
**Purpose:** Blog post layout

**Classes:**
```scss
.post-shell
  └─ .post-content
     └─ .post-layout (CSS Grid: sidebar + main)
        │
        ├─ .post-sidebar
        │  └─ .toc-nav (table of contents)
        │     ├─ .toc-title
        │     ├─ .toc-item
        │     └─ .toc-link (with .is-active state)
        │
        └─ .post-main
           ├─ .post-header
           │  ├─ .section-kicker (category)
           │  ├─ h1 (title)
           │  ├─ .post-dek (excerpt)
           │  ├─ .post-meta-row
           │  │  ├─ .post-meta-item.post-date
           │  │  └─ .post-meta-item.post-updated
           │  └─ .featured-image.post-cover
           │
           ├─ .post-body
           │  └─ Post markdown content (h2-h6, p, lists, code, blockquote)
           │
           ├─ .post-tags.post-footer-tags
           │  └─ .post-tag-link
           │
           ├─ .post-share
           │  └─ Share buttons
           │
           ├─ .post-navigation
           │  ├─ .next-post (← 前の記事)
           │  └─ .prev-post (次の記事 →)
           │
           └─ #disqus_thread (if enabled)
```

**Grid Layout:**
- Mobile: Single column (sidebar hidden)
- Tablet+: Sidebar (25%) + Main (75%)

**Post Body Styling:**
- Heading hierarchy (h2-h6)
- Paragraph spacing
- List styling (ul, ol)
- Blockquote styling
- Code block styling

**Sidebar (TOC):**
- Fixed position on desktop
- Scrolls with content
- Highlights current section

---

### _card.scss
**Purpose:** Card component styles (reusable)

**Classes:**
```scss
.home-card, .category-card
  ├─ .home-card-link, .category-card-link
  ├─ .home-card-media, .category-card-media
  │  └─ Background image container
  ├─ .home-card-body, .category-card-body
  ├─ .home-card-kicker (optional, "Latest" label)
  ├─ .home-card-date, .category-card-date
  ├─ h3 (title)
  ├─ .home-card-excerpt, .category-card-excerpt
  └─ .card-tags
     └─ li (tag items)

.home-card-latest
  └─ Larger featured card variant
```

**Card Variants:**
- `.home-card-latest` - Featured card (full-width, larger image)
- `.category-card` - Category archive cards

**Interactions:**
- Hover: Card shadow/lift effect
- Focus: Keyboard navigation focus rings

---

### _code.scss
**Purpose:** Code block styling

**Classes:**
```scss
.highlight
  └─ Code block wrapper (from markdown)
     └─ Syntax tokens (from Rouge syntax.css)

pre
  ├─ Background color
  ├─ Padding
  ├─ Overflow (horizontal scroll)
  └─ Font: JetBrains Mono

code
  ├─ Inline code styling
  ├─ Font: JetBrains Mono
  └─ Background/border

table.highlighttable
  └─ Line numbers (if enabled)
     ├─ .lineno (line number column)
     └─ .highlight (code column)
```

**Configuration in _config.yml:**
```yaml
markdown: kramdown
highlighter: rouge
```

---

### _social-icons.scss
**Purpose:** Social icon styling

**Classes:**
```scss
.menu-link-icon
  ├─ fa-brands, fa-solid (Font Awesome)
  ├─ .kofi-symbol (Ko-fi custom SVG)
  └─ Hover/focus states
```

**Icons Used:**
- Font Awesome 6.5.2
- Brands: x-twitter, bluesky, github, lastfm
- Solid: mug-hot (Ko-fi)

---

## Responsive Design

**Breakpoints (from _tokens.scss):**

| Breakpoint | Width | Use Case |
|------------|-------|----------|
| Mobile | < 600px | Phones |
| Tablet | 600px - 900px | Tablets |
| Desktop | > 900px | Desktops |

**Mobile-First Approach:**
```scss
// Base mobile styles
.grid {
  display: grid;
  grid-template-columns: 1fr;  // 1 column
}

// Tablet
@media (min-width: 600px) {
  .grid {
    grid-template-columns: 1fr 1fr;  // 2 columns
  }
}

// Desktop
@media (min-width: 900px) {
  .grid {
    grid-template-columns: 1fr 1fr 1fr;  // 3 columns
  }
}
```

---

## Typography

**Fonts:**
- **Body:** IBM Plex Sans JP (400, 500, 600, 700)
- **Code:** JetBrains Mono (400, 500, 600)

**Font Sizes:**
```scss
h1: 32px (desktop), 24px (mobile)
h2: 24px (desktop), 20px (mobile)
h3: 20px
h4: 18px
h5: 16px
h6: 16px
p: 16px
small: 14px
```

**Line Heights:**
- Headings: 1.2
- Body text: 1.6
- Code: 1.5

---

## Color System

**Light Mode (default):**
- Background: #ffffff
- Text: #333333
- Links: #007bff (blue)
- Borders: #dddddd
- Hover: rgba(0, 123, 255, 0.1)

**Dark Mode (if implemented):**
- Background: #1a1a1a
- Text: #eeeeee
- Links: #66b3ff
- Borders: #444444

---

## Animation & Transitions

**Global Transition Duration:** 200ms, ease-in-out

**Common Transitions:**
- Link hover: color 200ms
- Button hover: background 200ms, transform 200ms
- Menu slide-in: width/opacity 300ms
- Image zoom overlay: opacity 200ms

---

## Syntax Highlighting

**File:** `assets/css/syntax.css` (static, from Rouge)

**Theme:** Monokai (dark) or default (light)

**Output Classes (Rouge):**
```html
<div class="highlight">
  <pre class="highlight"><code>
    <span class="k">keyword</span>
    <span class="s">string</span>
    <span class="n">name</span>
    <span class="c">comment</span>
    ...
  </code></pre>
</div>
```

---

## CSS Grid & Flexbox Usage

**Grid Layouts:**
- Homepage: 3-column grid (1 on mobile, 2 on tablet, 3 on desktop)
- Post: Sidebar + main content (sidebar hidden on mobile)
- Category: Same as homepage

**Flexbox Layouts:**
- Header navigation: flex row
- Menu items: flex items with gap
- Card body: flex column
- Footer: flex row

---

## Accessibility

**Focus Styles:**
```scss
a:focus, button:focus, input:focus {
  outline: 2px solid $color-primary;
  outline-offset: 2px;
}
```

**Contrast Ratios:**
- Text on background: WCAG AA (4.5:1 minimum)
- Link colors: Distinct from text

**Skip Links:**
- Optional `.skip-link` for keyboard navigation

**Semantic HTML:**
- Headings: h1-h6 with proper hierarchy
- Buttons: `<button>` for interactive elements
- Navigation: `<nav>` landmark

---

## Performance Optimization

**CSS Minification:**
- Enabled via jekyll-minifier
- JavaScript minification disabled (complex syntax)

**CSS Delivery:**
- main.css: Critical path CSS (above-the-fold)
- syntax.css: Optional (loaded on pages with code blocks)

**Font Loading:**
- Google Fonts: Preconnect + async loading
- FontAwesome: Preconnect to CDN
- Font display: swap (show fallback while loading)

---

## Browser Support

**Target Browsers:**
- Chrome/Edge 88+
- Firefox 87+
- Safari 14+
- Mobile Chrome/Safari (last 2 versions)

**CSS Features Used:**
- CSS Grid
- Flexbox
- CSS Variables (custom properties)
- CSS Transitions
- Media queries

---

## Related Files

**Configuration:**
- `_config.yml` - SCSS compilation settings
- `_data/settings.yml` - Theme colors (if using)

**Generated:**
- `_site/assets/css/main.css` - Compiled CSS
- `_site/assets/css/syntax.css` - Copied from assets/css/

**External:**
- Google Fonts (IBM Plex Sans JP, JetBrains Mono)
- Font Awesome 6.5.2
