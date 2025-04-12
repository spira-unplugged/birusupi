---
layout: post
title: "Filmphotography Bot"
author: "Birusupi"
categories: documentation
tags: [フィルム写真, 自動投稿ボット, Google Apps Script, Lomography, Twitter API, Xbot, 写真API, 作例共有, Bot開発, アナログ写真]
image: Filmphotography-Bot.jpg
---

# Xでのフィルム写真ボット運用について

X（旧Twitter）上で、フィルム写真を自動投稿するボット「AutoLomography」を作成・運用しています。
フィルム写真をやっている人は知っていることが多い、[Lomography](https://www.lomography.com/)というフィルム写真コミュニティと連携し、一定間隔で写真を投稿することで、アナログ写真の魅力を広めることを目的としています。

---

## 背景

過去にフィルムカメラでの撮影を趣味にしていましたが、継続的なコスト（フィルム代、現像代、スキャン等）により中断しました。フィルム代マジで高い。
撮影はしなくなったものの、フィルム写真に対する関心は残っており、Lomographyを閲覧する習慣は続いていました。

ある時、LomographyのAPIが公開されていることに気づき、同サービスの担当者に連絡を取り、APIキーを提供してもらいました。
これをきっかけに、自動投稿ボットの構築を開始。

---

## AutoLomography について

**リポジトリ**：[GitHub - AutoLomography](https://github.com/spira-unplugged/AutoLomography)

**投稿アカウント**：[https://x.com/AutoLomography](https://x.com/AutoLomography)

**投稿情報**：[Googleスプレッドシート](https://docs.google.com/spreadsheets/d/e/2PACX-1vQeafKQCtdjsx2O8oGL7FdnODIFzvVyaPzPBFJkZpry13amG8ADKxNBDZkQFEVyPe5ff8P8IbZ7lZ9j/pubhtml?gid=0&single=true)

同一写真の重複投稿を避けるため、Googleスプレッドシートで投稿履歴を管理しています。

---

## 主な構成と機能

- **Lomography API**
  写真のメタデータ（タイトル、説明、画像URL等）を取得。

- **重複チェック**
  Googleスプレッドシート上で、過去に投稿した写真IDと照合。

- **自動投稿処理**
  XのAPIを使用し、取得した写真とキャプション、Altテキスト（説明文）を投稿。

- **記録**
  投稿後、使用した写真の情報をスプレッドシートに記録。

---

## 技術要素

- **Google Apps Script**：定期実行タスク、API連携、スプレッドシート操作を統括
- **Twitter API v2**：投稿機能
- **Lomography API**：写真取得用
- **Google Spreadsheet**：投稿履歴の保存・参照

---

## 運用状況と今後の展望

現在は6時間ごとに自動投稿を実行。
Lomographyの写真は多様性があり、特定のテーマに偏らず、毎回異なる空気感の写真が流れるのが特徴。
ただ、時折XのAPIの仕様が変わることで投稿が止まってしまうことがあるのが課題。

---

## 終わりに

フィルム写真との直接的な関わりは減りましたが、本ボットを通じて間接的に接点を持ち続ける形になりました。