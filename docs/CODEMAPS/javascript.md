# JavaScript Modules

**Last Updated:** 2026-03-29

## JavaScript Architecture

```
assets/js/
├── image-zoom.js       # Click-to-expand images with overlay
├── menu-toggle.js      # Mobile menu with keyboard navigation
├── toc.js              # Table of contents scroll highlighting
└── external-links.js   # Open external links in new tab
```

## Overview

| Module | Size | Loaded On | Purpose | Dependencies |
|--------|------|-----------|---------|--------------|
| image-zoom.js | ~1.5 KB | Posts only | Image expansion overlay | DOM, CSS classes |
| menu-toggle.js | ~2 KB | All pages | Mobile menu toggle + a11y | DOM, header.html |
| toc.js | ~1 KB | Posts only | Highlight TOC section | DOM, post.html |
| external-links.js | ~0.5 KB | All pages | External link handling | DOM |

---

## Detailed Module Specifications

### image-zoom.js

**Purpose:** Provide image zoom functionality with keyboard + mouse accessibility

**Trigger:** User clicks on image in post content

**Location:** `assets/js/image-zoom.js`

**Code Flow:**
```javascript
document.addEventListener("DOMContentLoaded", () => {
  // 1. Create overlay container once
  const overlay = document.createElement("div");
  overlay.className = "image-zoom-overlay";
  const overlayImg = document.createElement("img");
  overlay.appendChild(overlayImg);
  document.body.appendChild(overlay);

  // 2. Define close function
  const close = () => {
    overlay.classList.remove("is-open");
    overlayImg.removeAttribute("src");
    overlayImg.removeAttribute("alt");
    document.body.style.overflow = "";
  };

  // 3. Bind close handlers
  overlay.addEventListener("click", close);
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape") close();
  });

  // 4. Find all images in post content
  const scope = document.querySelector(".post-content") || document;
  scope.querySelectorAll("img").forEach((img) => {
    // Skip images already wrapped in <a> tags
    if (img.closest("a")) return;

    // 5. Add keyboard accessibility
    img.setAttribute("tabindex", "0");
    img.setAttribute("role", "button");
    img.setAttribute("aria-label", img.alt ? img.alt + "を拡大表示" : "画像を拡大表示");

    // 6. Define open function
    const openZoom = () => {
      overlayImg.src = img.currentSrc || img.src;
      overlayImg.alt = img.alt || "";
      overlay.classList.add("is-open");
      document.body.style.overflow = "hidden";
    };

    // 7. Bind open handlers (click + keyboard)
    img.addEventListener("click", openZoom);
    img.addEventListener("keydown", (e) => {
      if (e.key === "Enter" || e.key === " ") {
        e.preventDefault();
        openZoom();
      }
    });
  });
});
```

**Key Features:**
- Single overlay reused for all images (performance optimization)
- Scope limited to `.post-content` container
- Skips images already wrapped in links
- WCAG accessibility: tabindex, role, aria-label, keyboard support
- Supports both currentSrc (responsive images) and src
- Body overflow hidden when zoom active (prevents scroll)

**Accessibility:**
- Keyboard: Enter/Space to open, Escape to close
- Screen readers: aria-label with action
- Focus-visible: Images have tabindex="0"
- Mobile: Touch support via click event

**CSS Dependencies:**
- `.image-zoom-overlay` - Overlay container (hidden/visible)
- `.image-zoom-overlay.is-open` - Visible state

**Load Condition:**
```liquid
{% if page.layout == "post" %}
  <script src="{{ '/assets/js/image-zoom.js' | relative_url }}"></script>
{% endif %}
```

**Only on post pages** (loaded in default.html)

---

### menu-toggle.js

**Purpose:** Toggle mobile navigation menu with full keyboard navigation support

**Trigger:** User clicks hamburger button or uses keyboard

**Location:** `assets/js/menu-toggle.js`

**Code Flow:**
```javascript
document.addEventListener("DOMContentLoaded", function () {
  // 1. Find menu elements
  const dropdown = document.querySelector(".dropdown");
  if (!dropdown) return;

  const button = dropdown.querySelector(".dropbtn");
  const menu = dropdown.querySelector(".dropdown-content");
  if (!button || !menu) return;

  // 2. Setup ARIA attributes
  button.setAttribute("aria-expanded", "false");
  button.setAttribute("aria-controls", "site-mobile-menu");
  menu.id = "site-mobile-menu";

  // 3. Define open/close functions
  const closeMenu = function () {
    dropdown.classList.remove("is-open");
    button.setAttribute("aria-expanded", "false");
  };

  const openMenu = function () {
    dropdown.classList.add("is-open");
    button.setAttribute("aria-expanded", "true");
  };

  // 4. Button click handler (toggle)
  button.addEventListener("click", function (event) {
    event.stopPropagation();
    if (dropdown.classList.contains("is-open")) {
      closeMenu();
    } else {
      openMenu();
    }
  });

  // 5. Menu click handler (stop propagation)
  menu.addEventListener("click", function (event) {
    event.stopPropagation();
  });

  // 6. Document click handler (close menu when clicking outside)
  document.addEventListener("click", function (event) {
    if (!dropdown.contains(event.target)) {
      closeMenu();
    }
  });

  // 7. Escape key handler
  document.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
      closeMenu();
      button.focus();
    }
  });

  // 8. Arrow key navigation within menu
  menu.addEventListener("keydown", function (event) {
    const links = Array.from(menu.querySelectorAll("a"));
    if (!links.length) return;
    const focused = document.activeElement;
    const idx = links.indexOf(focused);

    if (event.key === "ArrowDown") {
      event.preventDefault();
      links[Math.min(idx + 1, links.length - 1)].focus();
    } else if (event.key === "ArrowUp") {
      event.preventDefault();
      if (idx <= 0) {
        closeMenu();
        button.focus();
      } else {
        links[idx - 1].focus();
      }
    }
  });

  // 9. ArrowDown from button opens menu
  button.addEventListener("keydown", function (event) {
    if (event.key === "ArrowDown") {
      event.preventDefault();
      openMenu();
      const first = menu.querySelector("a");
      if (first) first.focus();
    }
  });
});
```

**Keyboard Interactions:**
| Key | Action |
|-----|--------|
| Click button | Toggle menu open/close |
| Escape | Close menu, focus button |
| ArrowDown (on button) | Open menu, focus first item |
| ArrowDown (in menu) | Focus next menu item |
| ArrowUp (in menu) | Focus previous item or close menu |
| Click outside | Close menu |

**WCAG Features:**
- `aria-expanded` - Announces button state
- `aria-controls` - Links button to menu
- `aria-label` - Hamburger button label
- Full keyboard navigation (arrow keys, escape)
- Focus management (focus moved to first item when opening)

**CSS Dependencies:**
- `.dropdown` - Menu container
- `.dropdown.is-open` - Open state (CSS handles visibility/animation)
- `.dropbtn` - Button element
- `.dropdown-content` - Menu content wrapper

**Event Handlers:**
- Click: Button, menu, document
- Keydown: Document, menu, button
- Stoppage: Prevents menu closing on self-clicks

**Load Condition:**
```liquid
<script src="{{ '/assets/js/menu-toggle.js' | relative_url }}"></script>
```

**Loaded on all pages** (in default.html)

---

### toc.js

**Purpose:** Highlight table of contents items as user scrolls through post

**Trigger:** Page load and scroll events

**Location:** `assets/js/toc.js`

**Code Flow:**
```javascript
document.addEventListener("DOMContentLoaded", function () {
  const headings = Array.from(
    document.querySelectorAll(".post-body h2, .post-body h3, .post-body h4")
  );
  if (!headings.length) return;

  const tocLinks = Array.from(document.querySelectorAll(".toc-link"));
  if (!tocLinks.length) return;

  const handleScroll = () => {
    // Find current section based on scroll position
    let current = null;
    for (const heading of headings) {
      if (heading.getBoundingClientRect().top < 100) {
        current = heading.id;
      }
    }

    // Update active TOC item
    tocLinks.forEach((link) => {
      const href = link.getAttribute("href").slice(1);
      if (href === current) {
        link.classList.add("is-active");
      } else {
        link.classList.remove("is-active");
      }
    });
  };

  // Throttle scroll handler for performance
  let scrollTimeout;
  window.addEventListener("scroll", () => {
    if (scrollTimeout) clearTimeout(scrollTimeout);
    scrollTimeout = setTimeout(handleScroll, 100);
  }, false);

  handleScroll(); // Initial call
});
```

**Key Features:**
- Queries headings from `.post-body` (h2, h3, h4)
- Maps headings to TOC links via ID matching
- Updates active state as user scrolls
- Throttled scroll handler (100ms) for performance
- Graceful degradation if no headings/TOC found

**Scroll Behavior:**
- Heading must be within 100px of top of viewport to be considered "current"
- `.is-active` class added to current section's link

**CSS Dependencies:**
- `.toc-link` - TOC link element
- `.toc-link.is-active` - Current section highlight
- `.post-body h2, h3, h4` - Content headings

**HTML Structure Required:**
```html
<nav class="toc-nav">
  <a href="#heading-id" class="toc-link">Heading Title</a>
</nav>

<article class="post-body">
  <h2 id="heading-id">Heading Title</h2>
  ...
</article>
```

**Load Condition:**
```liquid
{% if page.layout == "post" %}
  <script src="{{ '/assets/js/toc.js' | relative_url }}"></script>
{% endif %}
```

**Only on post pages** (loaded in default.html)

---

### external-links.js

**Purpose:** Open external links in new browser tab

**Trigger:** Page load (scan existing links)

**Location:** `assets/js/external-links.js`

**Code Flow:**
```javascript
document.addEventListener("DOMContentLoaded", function () {
  // Find all links
  const links = document.querySelectorAll("a[href]");

  links.forEach((link) => {
    // Check if link is external
    const href = link.getAttribute("href");
    const isExternal = href.startsWith("http") &&
                       !href.includes(window.location.hostname);

    if (isExternal) {
      link.setAttribute("target", "_blank");
      link.setAttribute("rel", "noopener noreferrer");
      // Optional: Add visual indicator
      // link.classList.add("external-link");
    }
  });
});
```

**Typical Pattern:**
- Internal links: e.g., `/blog/`, `/about/` → Same tab
- External links: e.g., `https://github.com/...` → New tab + security attrs

**Security Attributes:**
- `target="_blank"` - Opens in new tab
- `rel="noopener noreferrer"` - Prevents window.opener access (security)

**Load Condition:**
```liquid
<script src="{{ '/assets/js/external-links.js' | relative_url }}"></script>
```

**Loaded on all pages** (in default.html)

---

## Script Loading Strategy

**In default.html (base layout):**

```html
<!-- Conditional: Post pages only -->
{% if page.layout == "post" %}
  <script src="{{ '/assets/js/image-zoom.js' | relative_url }}"></script>
  <script src="{{ '/assets/js/toc.js' | relative_url }}"></script>
{% endif %}

<!-- All pages -->
<script src="{{ '/assets/js/menu-toggle.js' | relative_url }}"></script>
<script src="{{ '/assets/js/external-links.js' | relative_url }}"></script>

<!-- Analytics -->
{% include ga-events.html %}
```

**Load Timing:**
- All scripts are inline (in HTML body)
- No async/defer attributes (scripts are small)
- Scripts run after DOM is ready

**File Sizes (Estimated):**
- image-zoom.js: ~1.5 KB (unminified)
- menu-toggle.js: ~2 KB (unminified)
- toc.js: ~1 KB (unminified)
- external-links.js: ~0.5 KB (unminified)
- **Total:** ~5 KB (minified ~3 KB)

**Minification:**
- Jekyll-minifier has JS minification disabled (complex syntax)
- Scripts are already readable and small
- Manual minification optional if needed

---

## JavaScript Standards

**Language:** Vanilla JavaScript (no frameworks)

**ES Version:** ES6+ (arrow functions, const/let, Array methods)

**Accessibility Standards:**
- WCAG 2.1 AA compliance
- Keyboard navigation support
- ARIA attributes
- Focus management
- Screen reader testing

**Performance:**
- No external dependencies
- Event delegation where applicable
- Throttled/debounced handlers for scroll/resize
- Early returns for missing elements

**Browser Compatibility:**
- IE11: Not supported (modern syntax)
- Chrome 60+, Firefox 55+, Safari 12+
- Mobile Chrome/Safari (last 2 versions)

---

## Event Flow Diagram

### Image Zoom
```
User clicks image
  ↓
openZoom()
  ├─ Set overlay image src
  ├─ Add .is-open class
  └─ Hide body scroll

User presses Escape OR clicks overlay
  ↓
close()
  ├─ Remove .is-open class
  ├─ Clear image src
  └─ Re-enable body scroll
```

### Menu Toggle
```
User clicks hamburger button
  ↓
Is menu open?
  ├─ YES: closeMenu()
  │  ├─ Remove .is-open class
  │  └─ Set aria-expanded="false"
  │
  └─ NO: openMenu()
     ├─ Add .is-open class
     └─ Set aria-expanded="true"

User presses Escape
  ↓
closeMenu() + focus button

User presses ArrowDown on button
  ↓
openMenu() + focus first link

User presses ArrowDown in menu
  ↓
Focus next link

User clicks outside menu
  ↓
closeMenu()
```

### TOC Highlight
```
Page loads
  ↓
findCurrentHeading()
  ├─ Scan all headings
  ├─ Find topmost in viewport
  └─ Get heading ID

Update TOC items
  ├─ Match link href to ID
  └─ Add/remove .is-active class

User scrolls
  ↓
throttle(100ms)
  ↓
Repeat findCurrentHeading()
```

---

## Testing Considerations

**Manual Testing:**

| Module | Test Cases |
|--------|-----------|
| image-zoom.js | Click image, press Escape, press Enter, click overlay, check aria-labels |
| menu-toggle.js | Click button, press Escape, arrow keys, click outside, check aria-expanded |
| toc.js | Scroll through post, verify highlights match section, check scrolling performance |
| external-links.js | Click internal link (same tab), click external link (new tab), check rel attribute |

**Accessibility Testing:**
- Screen reader: NVDA, JAWS, VoiceOver
- Keyboard-only navigation
- Focus visibility
- Color contrast (images not required to zoom)

**Performance Testing:**
- Lighthouse audit
- JavaScript execution time
- Memory usage (overlay reuse in image-zoom)
- Scroll performance (toc.js throttling)

---

## Future Enhancements

**Possible Improvements:**
1. Image zoom: Add left/right arrows to cycle through images
2. Menu: Search within menu on large lists
3. TOC: Sticky TOC that follows scroll (if not already implemented in CSS)
4. External links: Visual indicator (icon) for external links
5. Analytics: Event tracking for interactions

---

## Related Files

**Templates:**
- `_layouts/default.html` - Script loader
- `_layouts/post.html` - Post-specific scripts
- `_includes/header.html` - Menu structure for menu-toggle.js

**Styles:**
- `_sass/_post.scss` - Image zoom overlay styles
- `_sass/_header.scss` - Menu animation styles
- `_sass/_post.scss` - TOC active state styles

**Configuration:**
- `_config.yml` - jekyll-minifier settings (JS disabled)
