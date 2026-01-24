document.addEventListener("DOMContentLoaded", () => {
  // オーバーレイ要素を1個だけ作って使い回す
  const overlay = document.createElement("div");
  overlay.className = "image-zoom-overlay";
  overlay.innerHTML = `<img alt="">`;
  document.body.appendChild(overlay);

  const overlayImg = overlay.querySelector("img");

  const close = () => {
    overlay.classList.remove("is-open");
    overlayImg.removeAttribute("src");
    overlayImg.removeAttribute("alt");
    document.body.style.overflow = "";
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

    img.addEventListener("click", () => {
      overlayImg.src = img.currentSrc || img.src;
      overlayImg.alt = img.alt || "";
      overlay.classList.add("is-open");
      // 背景スクロールを止める（スマホで効く）
      document.body.style.overflow = "hidden";
    });
  });
});