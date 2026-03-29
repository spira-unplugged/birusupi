# Birusupi Website Repository

https://spira-unplugged.github.io/birusupi/

このリポジトリは、GitHub Pages 上で公開している `Birusupi` サイトのソース一式です。  
Jekyll 4 系をベースに、Millennial テーマをカスタムした構成で運用しています。

## 技術スタック

- Ruby + Jekyll (`~> 4.2`)
- Sass（`assets/css/main.scss` + `_sass/`）
- Jekyll plugins
  - `jekyll-paginate-v2` - 高度なページネーション（1ページあたり6件）
  - `jekyll-feed` - Atom フィード生成
  - `jekyll-seo-tag` - SEO メタタグ自動生成
  - `jekyll-archives` - 年/月/タグ別アーカイブページ自動生成
  - `jekyll-last-modified-at` - 最終更新日時の自動追加
  - `jekyll-minifier` - HTML/CSS 最小化（JS はオフ）

依存関係は [Gemfile](/mnt/c/Users/moosa/Documents/001_Repository/birusupi/Gemfile) と [Gemfile.lock](/mnt/c/Users/moosa/Documents/001_Repository/birusupi/Gemfile.lock) で管理しています。

## ディレクトリ設計

- [_posts](/mnt/c/Users/moosa/Documents/001_Repository/birusupi/_posts): ブログ記事（`YYYY-MM-DD-title.md`）
- [pages](/mnt/c/Users/moosa/Documents/001_Repository/birusupi/pages): 固定ページ（About, Blog, Documentation, GPTs, Playlist など）
- [_layouts](/mnt/c/Users/moosa/Documents/001_Repository/birusupi/_layouts): レイアウトテンプレート
- [_includes](/mnt/c/Users/moosa/Documents/001_Repository/birusupi/_includes): 共通パーツ（header/footer/シェア/Toc 等）
- [_sass](/mnt/c/Users/moosa/Documents/001_Repository/birusupi/_sass): セクション別スタイル
- [assets](/mnt/c/Users/moosa/Documents/001_Repository/birusupi/assets): 画像・JS・CSSエントリ
- [_data/settings.yml](/mnt/c/Users/moosa/Documents/001_Repository/birusupi/_data/settings.yml): ナビゲーション/SNS/表示文言設定
- [_config.yml](/mnt/c/Users/moosa/Documents/001_Repository/birusupi/_config.yml): サイト全体設定（`url`, `baseurl`, timezone, plugins など）

補足:
- `baseurl` は `/birusupi` 前提です。
- テーマ仕様は [millennial.gemspec](/mnt/c/Users/moosa/Documents/001_Repository/birusupi/millennial.gemspec) でも管理しています（`birusupi-theme`）。

## ローカル開発

前提:
- Ruby（Bundler利用可能な環境）

セットアップ:

```bash
bundle install
```

ローカル起動:

```bash
bundle exec jekyll serve
```

ブラウザ確認先（通常）:
- `http://127.0.0.1:4000/birusupi/`

## 主な機能

- **Content Security Policy (CSP)** - `_includes/head.html` で厳密な CSP ヘッダーを設定
- **条件付き JS 読み込み** - `_layouts/default.html` で post レイアウトのみ画像ズームと目次 JS を読み込み
- **外部リンク対策** - 外部リンクに `rel="noopener noreferrer"` を自動付与
- **メニュー切り替え** - モバイル対応のメニュートグル機能
- **Google Analytics 統合** - ページ閲覧イベント自動記録
- **数式表示** - `math: true` をフロントマッターに設定すると MathJax で数式をレンダリング
- **Spotify 埋め込み** - CSP で Spotify iframe を許可

## 日常運用フロー

### 1. 記事を追加する

1. `_posts` に `YYYY-MM-DD-<slug>.md` を追加
2. Front Matter に `layout`, `title`, `categories`, `tags`, `excerpt`, `image` などを設定
3. 記事画像は `assets/img/<post-id>/` に配置
4. `bundle exec jekyll serve` で表示確認

### 2. 固定ページを追加・更新する

1. `pages/*.md` を追加または編集
2. 必要に応じて `_data/settings.yml` の `menu` を更新
3. レイアウトが必要なら `_layouts` / `_includes` / `_sass` を更新

### 3. SNS / ヘッダー導線を変更する

1. `_data/settings.yml` の `social` を編集
2. アイコン表示ロジックは `_includes/header.html` を参照
3. アイコンスタイルは `_sass/_social-icons.scss` と `_sass/_header.scss` を調整

## アーカイブとページネーション

- **アーカイブ**: `/archive/:year/`, `/archive/:year/:month/`, `/tags/:name/` で自動生成
- **ページネーション**: `/page/2/`, `/page/3/` など、1ページあたり6件で自動分割

## 公開について

公開は GitHub Actions 経由で行います。
`.github/workflows/pages.yml` が `bundle exec jekyll build` を実行（Ruby 3.3）し、生成した `_site` を GitHub Pages にデプロイします。

## 変更時チェックリスト

- `bundle exec jekyll serve` でビルドエラーがない
- ヘッダー/メニュー/モバイル表示が崩れていない
- 記事内画像パスが正しい（`{{ site.baseurl }}` を考慮）
- `url`/`baseurl` 前提でリンクが解決できる

## ライセンス

MIT License  
[LICENSE.md](/mnt/c/Users/moosa/Documents/001_Repository/birusupi/LICENSE.md)
