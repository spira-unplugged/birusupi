# Layouts Hierarchy

**Last Updated:** 2026-03-29

## Layout Structure

```
default.html (base layout for all pages)
│
├─ head.html (injected in <head>)
├─ header.html (site navigation)
├─ footer.html (site footer)
├─ ga-events.html (GA event tracking)
│
└─ Specific layouts (extend default)
   │
   ├── home.html
   │   └─ Uses: paginator (jekyll-paginate-v2)
   │   └─ Includes post grid with home-card component
   │
   ├── page.html
   │   └─ Standard content page with hero section
   │   └─ No sidebar or TOC
   │
   ├── post.html
   │   ├─ toc.html (table of contents sidebar)
   │   ├─ post-date.html (publication metadata)
   │   ├─ post-share.html (social share buttons)
   │   ├─ disqus.html (optional comments)
   │   └─ image-zoom.js, toc.js (post-specific JS)
   │
   ├── category.html
   │   └─ category-card.html (repeated for each post in category)
   │   └─ Filters posts by page.category frontmatter
   │
   ├── tags.html
   │   └─ Lists all tags as links
   │
   ├── tag.html (jekyll-archives)
   │   └─ Generated archive page for each tag
   │
   └── archive-date.html (jekyll-archives)
       └─ Generated archive pages for years and months
```

## Layout Details

### default.html
**Purpose:** Base layout wrapping all pages

**Includes:**
- `head.html` - Document head with CSP, meta tags, stylesheets
- `header.html` - Navigation bar with logo, menu, mobile dropdown
- `footer.html` - Site footer
- `ga-events.html` - Google Analytics event tracking

**Scripts (conditional):**
```liquid
{% if page.layout == "post" %}
  <script src="/assets/js/image-zoom.js"></script>
  <script src="/assets/js/toc.js"></script>
{% endif %}
<script src="/assets/js/menu-toggle.js"></script>
<script src="/assets/js/external-links.js"></script>
```

**CSS Classes applied to body:**
```liquid
<body class="{{ page.layout }}{% if page.body_class %} {{ page.body_class }}{% endif %}">
```

---

### home.html
**Extends:** default.html
**Purpose:** Homepage with paginated post grid
**Pagination:** 6 posts per page (jekyll-paginate-v2)

**Layout Logic:**
- **Page 1 Only:**
  - Featured card (latest post) with larger styling
  - 5 regular posts below
- **Other Pages:**
  - 6 regular posts (with offset calculation)

**Variables Used:**
- `paginator.page` - Current page number
- `paginator.previous_page_path` - Previous page URL
- `paginator.next_page_path` - Next page URL
- `site.posts` - All posts with offset/limit
- `site.date_format` - From _config.yml (YYYY.MM.DD)
- `site.data.settings.pagination` - Button text

**Post Card Structure:**
```
.home-card-latest (page 1 only)
  └─ Featured image + title + excerpt + tags

.home-card (regular cards)
  └─ Image + date + title + excerpt + tags (up to 3)
```

---

### page.html
**Extends:** default.html
**Purpose:** Standard content page (About, Documentation, etc.)

**Content Sections:**
```html
<div class="page-content">
  <header class="page-hero">
    <!-- Optional kicker, title, description, featured image -->
  </header>
  <article class="page-body">
    {{ content }}
  </article>
</div>
```

**Frontmatter Options:**
```yaml
layout: page
title: "Page Title"
kicker: "Optional subtitle"
description: "Page description"
image: /path/to/image.jpg
body_class: "optional-css-class"
```

---

### post.html
**Extends:** default.html
**Purpose:** Blog post with sidebar TOC, navigation, metadata

**Layout Structure:**
```
.post-shell
  └─ .post-content
    └─ .post-layout (grid: sidebar + main)
      ├─ .post-sidebar
      │  └─ toc.html (table of contents)
      │
      └─ .post-main
         ├─ .post-header
         │  ├─ Category (from frontmatter)
         │  ├─ Title
         │  ├─ Excerpt/dek
         │  ├─ Meta row: date + update time (if modified)
         │  └─ Featured image
         │
         ├─ .post-body (article content)
         │
         ├─ .post-tags (footer tags)
         │
         ├─ post-share.html (social buttons)
         │
         ├─ .post-navigation
         │  ├─ Next post link (← 前の記事)
         │  └─ Previous post link (次の記事 →)
         │
         └─ disqus.html (if enabled)
```

**Post Metadata:**
- Date from frontmatter
- Updated date (from jekyll-last-modified-at) if `last_modified_at != date`
- Categories (first category used as kicker)
- Tags linked to tag pages

**Conditional Includes:**
```liquid
{% include post-date.html %}
{% if page.last_modified_at and page.last_modified_at != page.date %}
  <!-- Show "Updated" date -->
{% endif %}
{% if page.tags %}
  <!-- Show tag links -->
{% endif %}
{% if site.hide_post_share != true %}
  {% include post-share.html %}
{% endif %}
{% if site.data.settings.disqus.comments %}
  {% include disqus.html %}
{% endif %}
```

---

### category.html
**Extends:** default.html
**Purpose:** Category archive page with filtered post grid

**Logic:**
```liquid
{% assign category_posts = site.posts | sort: 'date' | reverse %}
{% for post in category_posts %}
  {% if post.categories contains page.category %}
    {% include category-card.html post=post %}
  {% endif %}
{% endfor %}
```

**Header:**
```html
<header class="page-hero page-hero-category">
  <p class="page-kicker">Index</p>
  <h1>{{ page.title }}</h1>
  <!-- Optional description or content -->
</header>
```

**Frontmatter Example:**
```yaml
layout: category
title: "Travel"
category: travel
description: "Travel posts and trip reports"
```

---

### tags.html
**Extends:** default.html
**Purpose:** Index page listing all available tags

**Structure:**
```liquid
{% for tag in site.tags %}
  {% assign t = tag | first %}
  {% assign posts = tag | last %}
  <a href="/tags/{{ t | slugify }}/">{{ t }} ({{ posts | size }})</a>
{% endfor %}
```

---

### tag.html (jekyll-archives)
**Extends:** default.html
**Purpose:** Individual tag archive page (auto-generated)

**Generated by:** jekyll-archives plugin
**URL Pattern:** `/tags/TAG-NAME/`
**Variables:**
- `page.title` - Tag name
- `paginator` - Paginated posts for this tag (if paginate-v2 enabled)

---

### archive-date.html (jekyll-archives)
**Extends:** default.html
**Purpose:** Year and month archive pages (auto-generated)

**Generated URLs:**
- `/archive/2026/` (year archive)
- `/archive/2026/03/` (month archive)

**Frontmatter (auto-generated):**
```yaml
title: "2026"  # or "2026-03" for month
posts: [array of posts for this date]
```

**Typical Structure:**
```liquid
<h1>{{ page.title }}</h1>
{% for post in page.posts %}
  <article>
    <h3>{{ post.title }}</h3>
    <p>{{ post.date | date: site.date_format }}</p>
    <p>{{ post.excerpt }}</p>
  </article>
{% endfor %}
```

## Layout-to-Include Dependencies

| Layout | Includes | Conditional |
|--------|----------|-------------|
| default | head, header, footer, ga-events | N/A |
| post | toc, post-date, post-share, disqus | post-date (if !hide), post-share (if !hide), disqus (if enabled) |
| category | category-card | For each post in category |
| page | (none) | N/A |
| home | (none) | N/A |
| tags | (none) | N/A |
| tag | (none) | N/A |
| archive-date | (none) | N/A |

## Frontmatter Standards

**All Posts (_posts/):**
```yaml
---
layout: post
title: "Post Title"
date: YYYY-MM-DD HH:MM:SS +0900
categories: [category-name]
tags: [tag1, tag2]
excerpt: "Brief summary shown in listings"
image: /assets/img/post-slug/001.png
last_modified_at: YYYY-MM-DD HH:MM:SS +0900  # Optional
math: true  # Optional, loads MathJax
---
```

**Pages (_pages/):**
```yaml
---
layout: page
title: "Page Title"
description: "Meta description"
image: /assets/img/page-image.jpg  # Optional
body_class: "custom-class"  # Optional
---
```
