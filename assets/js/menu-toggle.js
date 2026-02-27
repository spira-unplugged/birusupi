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
    if (event.key === "Escape") {
      closeMenu();
    }
  });
});
