document.addEventListener("DOMContentLoaded", function () {
  const dropdown = document.querySelector(".dropdown");
  if (!dropdown) return;

  const button = dropdown.querySelector(".dropbtn");
  const menu = dropdown.querySelector(".dropdown-content");
  if (!button || !menu) return;

  button.setAttribute("aria-expanded", "false");
  button.setAttribute("aria-controls", "site-mobile-menu");
  menu.id = "site-mobile-menu";

  const closeMenu = function () {
    dropdown.classList.remove("is-open");
    button.setAttribute("aria-expanded", "false");
  };

  const openMenu = function () {
    dropdown.classList.add("is-open");
    button.setAttribute("aria-expanded", "true");
  };

  button.addEventListener("click", function (event) {
    event.stopPropagation();
    if (dropdown.classList.contains("is-open")) {
      closeMenu();
    } else {
      openMenu();
    }
  });

  menu.addEventListener("click", function (event) {
    event.stopPropagation();
  });

  document.addEventListener("click", function (event) {
    if (!dropdown.contains(event.target)) {
      closeMenu();
    }
  });

  document.addEventListener("keydown", function (event) {
    if (event.key === "Escape" && dropdown.classList.contains("is-open")) {
      closeMenu();
      button.focus();
    }
  });

  // 矢印キーでメニュー内を移動
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

  // ボタンから↓でメニューの最初のリンクへ
  button.addEventListener("keydown", function (event) {
    if (event.key === "ArrowDown") {
      event.preventDefault();
      openMenu();
      const first = menu.querySelector("a");
      if (first) first.focus();
    }
  });
});
