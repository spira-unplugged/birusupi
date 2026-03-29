# Includes Architecture

**Last Updated:** 2026-03-29

## Include Files Overview

```
_includes/
├── head.html                 # Document <head> (meta, CSP, styles)
├── header.html               # Site navigation bar
├── footer.html               # Site footer
├── category-card.html        # Post card component (NEW)
├── post-date.html            # Post publication date metadata
├── post-share.html           # Social share buttons
├── post-navigation.html      # Previous/next post links
├── toc.html                  # Table of contents sidebar
├── disqus.html               # Comments section
├── google-analytics.html     # GA tracking script
├── ga-events.html            # GA event tracking
└── json-ld.html              # Schema.org structured data
```

## Include Dependency Graph

```
default.html
├─ head.html
│  ├─ favicon references
│  ├─ main.css (from assets/css)
│  ├─ syntax.css (from assets/css)
│  ├─ {% feed_meta %} (jekyll-feed plugin)
│  ├─ {% seo %} (jekyll-seo-tag plugin)
│  └─ json-ld.html
│
├─ header.html
│  └─ site.data.settings (menu, social)
│
├─ footer.html
│  └─ (no includes)
│
└─ ga-events.html
   └─ (tracking code)

post.html (extends default)
├─ toc.html (in .post-sidebar)
├─ post-date.html (in .post-header)
├─ post-share.html (after .post-body)
└─ disqus.html (if enabled)

category.html (extends default)
└─ category-card.html (repeated per post)
```

---

## Include Details

### head.html
**Purpose:** Complete HTML document head

**Content:**
```html
<head>
  <!-- Viewport & charset -->
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta charset="utf-8">

  <!-- Content Security Policy (NEWLY ADDED) -->
  <meta http-equiv="Content-Security-Policy" content="...">

  <!-- Favicon -->
  <link rel="icon" href="/favicon.ico" type="image/x-icon">
  <link rel="icon" href="/favicon.png" type="image/png">
  <link rel="apple-touch-icon" href="/favicon.png">

  <!-- Stylesheets -->
  <link rel="stylesheet" href="/assets/css/main.css">
  <link rel="stylesheet" href="/assets/css/syntax.css">

  <!-- Feed -->
  {% feed_meta %}

  <!-- DNS Prefetch & Preconnect (Performance) -->
  <link rel="dns-prefetch" href="https://cdnjs.cloudflare.com">
  <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
  <link rel="dns-prefetch" href="https://www.googletagmanager.com">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

  <!-- Google Fonts (IBM Plex Sans JP, JetBrains Mono) -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=...">

  <!-- Font Awesome (v6.5.2) -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/.../all.min.css">

  <!-- MathJax (conditional, if page.math == true) -->
  {% if page.math == true %}
    <script id="MathJax-script" async src="..."></script>
  {% endif %}

  <!-- Analytics & SEO -->
  {% include google-analytics.html %}
  {% seo %}
  {% include json-ld.html %}
</head>
```

**Key Variables:**
- `page.math` - Loads MathJax if true
- `site.title` - From _config.yml

**Dependencies:**
- google-analytics.html
- json-ld.html
- jekyll-feed plugin
- jekyll-seo-tag plugin

---

### header.html
**Purpose:** Site header with navigation and mobile menu

**Structure:**
```html
<header class="site-header">
  <h3 class="site-title">
    <a href="/">{{ site.title }}</a>
  </h3>

  <!-- Desktop Navigation -->
  <nav class="menu-list">
    <div class="menu-group menu-primary">
      <!-- Menu items from _data/settings.yml -->
    </div>
    <div class="menu-group menu-social">
      <!-- Social icons from _data/settings.yml -->
      <!-- Special handling for Ko-fi (custom SVG) -->
    </div>
  </nav>

  <!-- Mobile Menu (Hamburger) -->
  <div class="dropdown">
    <button class="dropbtn" aria-label="Open menu">
      <i class="fa-solid fa-bars"></i>
    </button>
    <div class="dropdown-content">
      <div class="dropdown-section dropdown-nav">
        <!-- Menu items (duplicated from desktop) -->
      </div>
      <div class="dropdown-divider"></div>
      <div class="dropdown-section dropdown-icons">
        <!-- Social icons (duplicated from desktop) -->
      </div>
    </div>
  </div>
</header>
```

**Variables Used:**
- `site.title` - "Birusupi"
- `site.data.settings.menu` - Navigation items
  ```yaml
  - {name: 'Blog', url: 'blog'}
  - {name: 'Documentation', url: 'documentation'}
  - {name: 'Tags', url: 'tags'}
  - {name: 'GPTs', url: 'gpts'}
  - {name: 'Playlist', url: 'playlist'}
  - {name: 'About', url: 'about'}
  ```
- `site.data.settings.social` - Social links
  ```yaml
  - {icon: 'x-twitter', style: 'brands', link: 'https://x.com/...'}
  - {icon: 'bluesky', style: 'brands', link: 'https://bsky.app/...'}
  - {icon: 'github', style: 'brands', link: 'https://github.com/...'}
  - {icon: 'lastfm', style: 'brands', link: 'https://www.last.fm/...'}
  - {icon: 'mug-hot', style: 'solid', link: 'https://ko-fi.com/...'}
  ```

**JavaScript Dependency:**
- `menu-toggle.js` - Handles mobile menu open/close with keyboard nav

---

### footer.html
**Purpose:** Site footer

**Typical Content:**
- Copyright notice
- Colophon
- Links (optional)

---

### category-card.html
**Purpose:** Reusable post card component (NEWLY ADDED)

**Usage:**
```liquid
{% include category-card.html post=post %}
```

**Parameters:**
- `include.post` - Post object

**Rendered HTML:**
```html
<article class="category-card">
  <a href="{{ post.url }}" class="category-card-link">
    <div class="category-card-media"
         style="background-image:url('{{ post.image }}')"></div>
    <div class="category-card-body">
      <p class="category-card-date">{{ post.date | date }}</p>
      <h2>{{ post.title }}</h2>
      <p class="category-card-excerpt">{{ post.excerpt | truncate: 90 }}</p>
      <ul class="card-tags">
        {% for tag in post.tags limit:3 %}
          <li>{{ tag }}</li>
        {% endfor %}
      </ul>
    </div>
  </a>
</article>
```

**Used In:**
- category.html (for each post in category)

**Styling:**
- CSS classes: category-card, category-card-link, category-card-media, category-card-body, category-card-date, card-tags

---

### post-date.html
**Purpose:** Display post publication date and metadata

**Typical Output:**
```html
<div class="post-meta-item post-date">
  <span class="post-meta-prefix">Written on</span>
  <time datetime="...">{{ page.date | date }}</time>
</div>
```

**Variables:**
- `page.date` - Publication date
- `site.date_format` - "YYYY.MM.DD"
- `site.data.settings.post_date_prefix` - "Written on"

**Used In:**
- post.html (conditional: if !site.hide_post_date)

---

### post-share.html
**Purpose:** Social sharing buttons

**Typical Buttons:**
- Twitter/X
- Facebook
- LinkedIn
- Copy link

**Used In:**
- post.html (conditional: if !site.hide_post_share)

---

### post-navigation.html
**Purpose:** Previous/Next post links

**Output:**
```html
<div class="post-navigation">
  <a class="next-post" href="{{ page.next.url }}">
    <span class="post-nav-label">← 前の記事 (Older post)</span>
    <span class="post-nav-title">{{ page.next.title }}</span>
  </a>
  <a class="prev-post" href="{{ page.previous.url }}">
    <span class="post-nav-label">次の記事 → (Newer post)</span>
    <span class="post-nav-title">{{ page.previous.title }}</span>
  </a>
</div>
```

**Note:** Labels are in Japanese; "next" in Jekyll is older post (reverse chronological)

**Used In:**
- post.html

---

### toc.html
**Purpose:** Table of contents sidebar with scroll highlighting

**Structure:**
```html
<nav class="toc-nav">
  <h3 class="toc-title">Contents</h3>
  <ul>
    {% for item in page.toc %}
      <li class="toc-item">
        <a href="#{{ item.id }}" class="toc-link">
          {{ item.title }}
        </a>
      </li>
    {% endfor %}
  </ul>
</nav>
```

**Generation:**
- Headers (h2, h3) in post content are auto-converted to TOC items
- IDs generated from header text

**JavaScript:**
- `toc.js` - Highlights current section as user scrolls

**Used In:**
- post.html (in .post-sidebar)

---

### disqus.html
**Purpose:** Disqus comments section

**Configuration:**
- `site.data.settings.disqus.comments` - Enable/disable (default: false)
- `site.data.settings.disqus.disqus_shortname` - "millennial-3"

**Output:**
```html
<div id="disqus_thread"></div>
<script>
  var disqus_config = function() {
    this.page.url = '{{ page.url | absolute_url }}';
    this.page.identifier = '{{ page.url }}';
  };
</script>
<script src="https://millennial-3.disqus.com/embed.js" async></script>
```

**Used In:**
- post.html (conditional: if site.data.settings.disqus.comments)

---

### google-analytics.html
**Purpose:** Google Analytics tracking

**Configuration:**
- `site.data.settings.google-ID` - "G-W1PYX136X2"

**Output:**
```html
<!-- Google Analytics (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-W1PYX136X2"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag() { dataLayer.push(arguments); }
  gtag('js', new Date());
  gtag('config', 'G-W1PYX136X2');
</script>
```

**Used In:**
- head.html

---

### ga-events.html
**Purpose:** Google Analytics event tracking

**Events Tracked:**
- Outbound link clicks
- File downloads
- Custom events

**Output:**
```html
<script>
  // Event tracking code
  document.addEventListener('click', function(event) {
    // Track outbound links, downloads, etc.
  });
</script>
```

**Used In:**
- default.html (at end of body)

---

### json-ld.html
**Purpose:** Schema.org structured data for SEO

**Generates:**
- Article schema (for posts)
- Organization schema (for site)
- BreadcrumbList schema (for navigation)

**Variables:**
- `page.title`
- `page.date`
- `page.author`
- `site.title`
- `site.url`

**Output Example:**
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "{{ page.title }}",
  "datePublished": "{{ page.date | date_to_xmlschema }}",
  ...
}
</script>
```

**Used In:**
- head.html

---

## Include Usage Summary

| Include | Used By | Frequency | Conditional |
|---------|---------|-----------|-------------|
| head.html | default.html | Every page | No |
| header.html | default.html | Every page | No |
| footer.html | default.html | Every page | No |
| ga-events.html | default.html | Every page | No |
| category-card.html | category.html | Per post in category | Yes (per post) |
| post-date.html | post.html | Per post | Yes (if !hide) |
| post-share.html | post.html | Per post | Yes (if !hide) |
| post-navigation.html | post.html | Per post | Yes (if has prev/next) |
| toc.html | post.html | Per post | Implicit (sidebar exists) |
| disqus.html | post.html | Per post | Yes (if enabled) |
| google-analytics.html | head.html | Every page | No |
| json-ld.html | head.html | Every page | No |

## Data Sources

### _data/settings.yml
```yaml
disqus:
  comments: false
  disqus_shortname: 'millennial-3'

google-ID: 'G-W1PYX136X2'

menu:
  - {name: 'Blog', url: 'blog'}
  - {name: 'Documentation', url: 'documentation'}
  - {name: 'Tags', url: 'tags'}
  - {name: 'GPTs', url: 'gpts'}
  - {name: 'Playlist', url: 'playlist'}
  - {name: 'About', url: 'about'}

social:
  - {icon: 'x-twitter', style: 'brands', link: 'https://x.com/singingsores'}
  - {icon: 'bluesky', style: 'brands', link: 'https://bsky.app/profile/thesightofspira.bsky.social'}
  - {icon: 'github', style: 'brands', link: 'https://github.com/spira-unplugged'}
  - {icon: 'lastfm', style: 'brands', link: 'https://www.last.fm/ja/user/realmofflight'}
  - {icon: 'mug-hot', style: 'solid', link: 'https://ko-fi.com/birusupi'}

pagination:
  previous_page: "← 新しい記事"
  next_page: "古い記事 →"

post_date_prefix: 'Written on'
sharing_button_prompt: 'share'
home_intro_kicker: 'Signal Terminal'
home_intro_title: 'Build logs, documentation, and notes worth keeping.'
home_intro_text: 'GitHub Pages で育てる個人サイト。...'
```

## Performance Considerations

**Conditional Includes:**
- `post-date.html` - Only if `site.hide_post_date != true`
- `post-share.html` - Only if `site.hide_post_share != true`
- `disqus.html` - Only if `site.data.settings.disqus.comments == true`
- `page.math` - Only loads MathJax if explicitly enabled

**External Resources (in head.html):**
- Fonts: Google Fonts (preconnect)
- Icons: Font Awesome CDN
- Analytics: Google Analytics (async)
- Optional: MathJax (async, on-demand)
