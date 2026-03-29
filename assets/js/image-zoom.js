document.addEventListener("DOMContentLoaded", () => {
  // オーバーレイ要素を1個だけ作って使い回す
  const overlay = document.createElement("div");
  overlay.className = "image-zoom-overlay";
  const overlayImg = document.createElement("img");
  overlayImg.alt = "";
  overlay.appendChild(overlayImg);
  document.body.appendChild(overlay);

  let lastFocused = null;

  const close = () => {
    overlay.classList.remove("is-open");
    overlayImg.removeAttribute("src");
    overlayImg.removeAttribute("alt");
    document.body.style.overflow = "";
    if (lastFocused) {
      lastFocused.focus();
      lastFocused = null;
    }
  };

  overlay.addEventListener("click", close);
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape") close();
  });

  // 記事本文内の画像を対象にする（クラス名は環境に合わせて）
  const scope = document.querySelector(".post-content") || document;
  scope.querySelectorAll("img").forEach((img) => {
    // すでにリンク付きの画像（<a><img></a>）は邪魔しない
    if (img.closest("a")) return;

    img.setAttribute("tabindex", "0");
    img.setAttribute("role", "button");
    img.setAttribute("aria-label", img.alt ? img.alt + "を拡大表示" : "画像を拡大表示");

    const openZoom = () => {
      lastFocused = img;
      overlayImg.src = img.currentSrc || img.src;
      overlayImg.alt = img.alt || "";
      overlay.classList.add("is-open");
      // 背景スクロールを止める（スマホで効く）
      document.body.style.overflow = "hidden";
    };

    img.addEventListener("click", openZoom);
    img.addEventListener("keydown", (e) => {
      if (e.key === "Enter" || e.key === " ") {
        e.preventDefault();
        openZoom();
      }
    });
  });
});
