document.addEventListener("DOMContentLoaded", () => {
  const toc = document.querySelector(".toc");
  const tocList = document.getElementById("toc-list");
  const container = document.querySelector(".post-body");
  if (!toc || !tocList || !container) return;

  const headings = Array.from(container.querySelectorAll("h2, h3"));
  if (!headings.length) {
    toc.hidden = true;
    return;
  }

  const tocItems = [];
  const visibleHeadings = new Set();
  const activationOffset = 112;

  const syncTocState = () => {
    if (window.matchMedia("(max-width: 960px)").matches) {
      toc.removeAttribute("open");
    }
  };

  const setActiveItem = (id, shouldScrollIntoView) => {
    let activeElement = null;

    tocItems.forEach((item) => {
      const isActive = item.id === id;
      item.element.classList.toggle("is-active", isActive);
      if (isActive) {
        item.link.setAttribute("aria-current", "location");
        activeElement = item.element;
      } else {
        item.link.removeAttribute("aria-current");
      }
    });

    if (activeElement && shouldScrollIntoView) {
      activeElement.scrollIntoView({ block: "nearest" });
    }
  };

  const findItemByHash = () => {
    const hash = window.location.hash.replace(/^#/, "");
    if (!hash) return null;
    return tocItems.find((item) => item.id === hash);
  };

  const getFallbackActiveId = () => {
    const passed = tocItems.filter(
      (item) => item.heading.getBoundingClientRect().top <= activationOffset
    );

    if (passed.length) {
      return passed[passed.length - 1].id;
    }

    return tocItems[0].id;
  };

  const getActiveId = () => {
    const hashItem = findItemByHash();
    if (hashItem) {
      const hashTop = hashItem.heading.getBoundingClientRect().top;
      if (hashTop >= 0 && hashTop <= window.innerHeight * 0.45) {
        return hashItem.id;
      }
    }

    const visibleItems = tocItems.filter((item) => visibleHeadings.has(item.id));

    if (visibleItems.length) {
      return visibleItems[visibleItems.length - 1].id;
    }

    return getFallbackActiveId();
  };

  const updateActiveItem = (shouldScrollIntoView) => {
    if (!tocItems.length) return;
    setActiveItem(getActiveId(), shouldScrollIntoView);
  };

  syncTocState();
  window.addEventListener("resize", () => {
    syncTocState();
    updateActiveItem(false);
  });

  headings.forEach((heading) => {
    const text = heading.textContent;
    const existingId = heading.id;
    const id =
      existingId ||
      text
        .toLowerCase()
        .trim()
        .replace(/[^\w\u3040-\u30ff\u3400-\u9fff-]+/g, "-")
        .replace(/^-+|-+$/g, "");

    if (!existingId) heading.id = id;

    const li = document.createElement("li");
    li.className = heading.tagName.toLowerCase();

    const a = document.createElement("a");
    a.href = `#${id}`;
    a.textContent = text;
    a.addEventListener("click", () => {
      setActiveItem(id, false);
    });

    li.appendChild(a);
    tocList.appendChild(li);
    tocItems.push({ id, element: li, link: a, heading });
  });

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          visibleHeadings.add(entry.target.id);
        } else {
          visibleHeadings.delete(entry.target.id);
        }
      });

      window.requestAnimationFrame(() => {
        updateActiveItem(true);
      });
    },
    {
      rootMargin: "-" + activationOffset + "px 0px -55% 0px",
      threshold: [0, 1],
    }
  );

  tocItems.forEach((item) => {
    observer.observe(item.heading);
  });

  window.addEventListener(
    "scroll",
    () => {
      window.requestAnimationFrame(() => {
        updateActiveItem(false);
      });
    },
    { passive: true }
  );

  window.addEventListener("hashchange", () => {
    const hashItem = findItemByHash();
    if (hashItem) {
      setActiveItem(hashItem.id, true);
      return;
    }

    updateActiveItem(false);
  });

  const initialHashItem = findItemByHash();
  if (initialHashItem) {
    setActiveItem(initialHashItem.id, false);
  } else {
    updateActiveItem(false);
  }
});
