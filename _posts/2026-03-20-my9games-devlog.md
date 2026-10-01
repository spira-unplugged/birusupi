---
layout: post
title: "私を構成する9つのゲーム MY9GAMES（My 9 Games）開発の振り返り"
author: "Birusupi"
categories: documentation
tags: [個人開発, Webアプリ, 公開運用, 設計, ポストモーテム, My9Games]
excerpt: "個人開発のWebアプリがバズで逼迫し、サービス停止に。基盤やDB設計・運用ルールなどを全面的に作り直した記録。"
image: /assets/img/2026-03-20-my9games-devlog/001.png
last_modified_at: 2026-10-01 00:00:00 +0900
---

※ 写真　[MY9GAMES（My 9 Games \| 私を構成する9つのゲーム）](https://my9games.com/) トップページ

## はじめに

2016年1月〜2月頃にTwitterやInstagramで爆発的に流行した「私を構成する9枚」というミームをご存知でしょうか。音楽アルバムを9枚並べて、自分の趣味や人格を表現する、懐かしの文化です。

![]({{ site.baseurl }}/assets/img/2026-03-20-my9games-devlog/002.png){:loading="lazy" decoding="async"}

<div class="img-cap">Google画像検索で見る「私を構成する9枚」ミームの例</div>

これのゲーム版が欲しくなりまして、[MY9GAMES](https://my9games.com/)（My 9 Games \| 私を構成する9つのゲーム、以下「MY9GAMES」）というWebアプリをこの度作ってみました。9本のゲームを選んで3×3の画像にし、共有ページとして見せられるようにしたものです。投稿データを集計して、[コミュニティ全体でどんなゲームが選ばれているか](https://my9games.com/trends)も見られるようにしています。

作り始めたときは、検索して、選んで、画像にできれば十分だと思っていました。ところが公開してみると、検索がエラーを返す、課金が膨らむ、画像の生成が失敗する、投稿をいつまで残すか決まっていない、と問題が次々に出てきました。

この記事では、2月13日に作り始めてから3月11日に落ち着くまでの約1か月を振り返ります。

なお、ありがたいことに、はじめしゃちょーさんをはじめ多くの方に遊んでいただきました。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">私を構成する9つのゲーム <a href="https://twitter.com/hashtag/My9Games">#My9Games</a> <a href="https://twitter.com/hashtag/%E7%A7%81%E3%82%92%E6%A7%8B%E6%88%90%E3%81%99%E3%82%8B9%E3%81%A4%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0">#私を構成する9つのゲーム</a></p>&mdash; はじめしゃちょー(hajime) (@hajimesyacho) <a href="https://twitter.com/hajimesyacho/status/2029858117530566731?ref_src=twsrc%5Etfw">March 5, 2026</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

こちらに様々な方の投稿をまとめています。Celeste・マイクラの作曲家のLena Raine
氏や、ホロライブの一伊那尓栖さん、小鳥遊キアラさんもいて、マジすごいです。光栄ですね。

[あの人の選ぶ9本 \| 推しクリエイターのゲーム選 \| MY9GAMES](https://my9games.com/featured)

メディアにも取り上げていただきました。

- [「My 9 Games」が流行の兆し。マイナータイトルや「ネタバレ防止機能」もある、ゲーム特化の思い出共有サイト - AUTOMATON](https://automaton-media.com/articles/newsjp/20260226-424512/)
- [好きなゲーム9本を選んで自己紹介できるサイト「My9Games」が流行中 - 電ファミニコゲーマー](https://news.denfaminicogamer.jp/news/260226r)

様々な配信者も遊んでくれています。

<div class="video-wrapper">
  <iframe src="https://www.youtube.com/embed/d-1xf-T23wg"
    title="自分と他配信の「私を構成する９つのゲーム」見比べる枠【2026/08/21】" frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    loading="lazy" allowfullscreen></iframe>
</div>
<div class="img-cap">加藤純一さんの配信の切り抜き</div>

<div class="video-wrapper">
  <iframe src="https://www.youtube.com/embed/q8h6RX0TVtg"
    title="「私を構成する9つのゲーム」を選びながら、幼少期からプロ時代までを振り返る関【雑談】" frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    loading="lazy" allowfullscreen></iframe>
</div>
<div class="img-cap">関優太さんの配信の切り抜き</div>

<div class="video-wrapper">
  <iframe src="https://www.youtube.com/embed/g2kJ_YATEc0"
    title="私を構成する9つのゲーム!!幼少期から現在までのゲーム遍歴を振り返るSasatikk【雑談】" frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    loading="lazy" allowfullscreen></iframe>
</div>
<div class="img-cap">Sasatikkさんの動画</div>

## なぜ「MY9GAMES」を作ろうと思ったのか

出発点は、先ほど触れたミーム「私を構成する9枚」でした。SNSで流行っていた頃に自分も参加したことがあって、あの「9つ並べるだけで自分が出る」感覚がずっと頭に残っていました。

ある日ふと、「これのゲーム版があってもいいのでは？」と思いました。

画像にして持ち出せて、共有URLでも見せられる！そこまでできたら面白いし、SNSで流行るに違いないと思っていました。

![]({{ site.baseurl }}/assets/img/2026-03-20-my9games-devlog/004.png){:loading="lazy" decoding="async"}

<div class="img-cap">作成ページ。トレンド上位の9本を入れてみたところ</div>

## 構想から2日でMVPを作成

2月13日に考え始めて、15日にはMVP（Minimum Viable Product）が動きました。ゲームを検索して、9本選んで、3×3に並べて、コメントを入れて、画像として保存できる。まずはそこまで通すことが目標でした。

![]({{ site.baseurl }}/assets/img/2026-03-20-my9games-devlog/005.png){:loading="lazy" decoding="async"}

<div class="img-cap">ゲームの検索画面</div>

このとき、後で問題になりそうだと薄々感じていたことも、かなり後回しにしています。投稿を何日保存するか、共有URLをいつまで有効にするか、月にいくらかかるか、ランキングをどう集計するか、消してほしいと言われたらどうするか……。早く公開してみたかったので、2日で作るために割り切りました。今考えるとかなり無謀ですね。

実装がシンプルだったぶん、粗もすぐに見えてきました。検索UIの使い勝手、コメント編集の導線、9本選ぶまでの操作制御、モバイルでの見え方などです。

そして、後回しにしたものは結局ほとんどがあとで問題になりました。共有URLを付ける前に保存方針を決めておく、従量課金の増え方を見積もっておく、ランキングのデータを共有ページと分けておく。どれもあと数日あればできたことです。それをやらずに出した結果、7日後にサービスを止めることになり、その間ユーザーの検索の半分以上にエラーを返し続けてしまいました。

早く出したから早く学べたのは事実ですが、早く出したから止めることになったのも事実で、そこは良くなかったと思っています。

## 共有機能

MVPが動いた翌日から、共有機能やbot対策、アクセス制限の実装に取りかかり、2月19日にXでリリースを告知しました。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">【お知らせ】① 9本のゲームを選んで自己紹介できるサイトを作ってみました。 引用RTで画像や共有URLを貼ってシェアして遊んでみてください！ <a href="https://t.co/s9oNtITNHD">https://t.co/s9oNtITNHD</a> <a href="https://twitter.com/hashtag/My9Games">#My9Games</a> <a href="https://twitter.com/hashtag/%E7%A7%81%E3%82%92%E6%A7%8B%E6%88%90%E3%81%99%E3%82%8B9%E3%81%A4%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0">#私を構成する9つのゲーム</a></p>&mdash; びるすぴ (@singingsores) <a href="https://twitter.com/singingsores/status/2024462993111789874?ref_src=twsrc%5Etfw">February 19, 2026</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

このWebアプリの最大の特徴は、やはり共有URLの発行機能ですよね。

![]({{ site.baseurl }}/assets/img/2026-03-20-my9games-devlog/006.png){:loading="lazy" decoding="async"}

<div class="img-cap">共有ページ。はじめしゃちょーさんの9本</div>

画像をローカルに保存するだけなら、ほぼブラウザの中で完結するのですが、共有URLを発行して他人が見られるようにすると、決めることが一気に増えました。

他の人と被らないIDをどう作るか。知らない人が見る前提で、どんな入力を許すか。何日保存するか。SNSでシェアされたときのサムネイル画像をどう返すか…。

## トレンドページ

次にやりたくなったのが、みんながどんなゲームを選んでいるのかを見せるトレンドページです。自分の9本を作ったら、みんな全体の傾向も知りたくなるかと思いました。逆にトレンドを見てゲームを思い出し、自分の9本に追加するという流れもあるかとも思いましたので、そのような導線設計も考えました。

こちらでランキング集計を見ることができます。2026/10/01時点で94万以上の共有データがあり、相当数遊ばれたことが分かります。

[みんなの9本トレンド \| 人気ゲームランキング \| MY9GAMES](https://my9games.com/trends)

![]({{ site.baseurl }}/assets/img/2026-03-20-my9games-devlog/007.png){:loading="lazy" decoding="async"}

<div class="img-cap">トレンドページ（2026年10月1日時点）</div>

## サイトを一次停止

リリースから7日後の2026年2月26日、サービスを一度止めました。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">【お知らせ】 たくさんの方にご利用いただき本当にありがとうございます。現在、想定を大きく超えるアクセスが続いておりまして…完全に私単独の趣味の範囲で開発・保守をしているため、諸所の対応がSNSの拡散の力には到底追いつかない状況になってしまいました。 <a href="https://twitter.com/hashtag/My9Games">#My9Games</a> <a href="https://twitter.com/hashtag/%E7%A7%81%E3%82%92%E6%A7%8B%E6%88%90%E3%81%99%E3%82%8B9%E3%81%A4%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0">#私を構成する9つのゲーム</a></p>&mdash; びるすぴ (@singingsores) <a href="https://twitter.com/singingsores/status/2026969121574043924?ref_src=twsrc%5Etfw">February 26, 2026</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

停止前日の計測では、1日の検索回数が18万件を超え、そのうち半分以上がエラーでした。それでも投稿は1日に7,000件以上作られていて、過去30分のアクティブユーザー数は7,000名ほどだったと記憶しています。壊れかけのサービスに、人が押し寄せ続けていました。

ここで、動かしながら直すのはもう無理だと判断しました。検索、共有ページの読み込み、データの保存期間、画像生成、メンテナンスモードの切り替えまで、前提から作り直す必要がありました。

止めるのは苦い決断でしたが、何を捨てて何を守るかははっきりしました。新規作成や重い検索は止めても、既にある共有ページは見られるようにしておきたい。アクセスのたびに外部へ問い合わせる検索は続けられない。画像生成も、作成時に必ず成功する前提では危ない……。

ユーザーの皆様にはご不便をおかけしました。

## 3月4日、再開

3月4日の深夜にサーバーを切り替えて、サービスを再開しました。

切り替え直後の3月5日23時ごろには、GA4の過去30分アクティブユーザー数が28,000名を超えていました。皆さん待ち望んでくれていたのかもしれません。

![]({{ site.baseurl }}/assets/img/2026-03-20-my9games-devlog/003.png){:loading="lazy" decoding="async"}

<div class="img-cap">3月5日23時ごろのアクセスピーク。GA4のリアルタイム画面より</div>


## 共有ページを残すことにした

技術的な作り直しが落ち着いたあと、共有ページを、長く残す前提に切り替えることにしました。

最初は、共有データを一定期間で自動削除するつもりでした。また、ユーザーが自分で投稿を消せる機能も一度は入れました。でも投稿を消すと、本人だけでなく、それを見ていた人の体験まで消えてしまうことや、沢山のめちゃ著名な方が遊んでくれたのもあり、共有URLは基本的に残すことにしました。

## 反省

### 従量課金

いちばんの反省は、Vercelの従量課金を甘く見ていたことですね。アクセスが増えるのは嬉しいはずなのに、増えた分だけ請求も増えて、サービスを続けられるかどうかの話になってしまいました。

Vercelが悪いわけではなく、どの処理でデータ転送量が増え、どこでサーバーの計算が走り、どこをキャッシュで逃がせるかみたいなことは、公開前に最低限、見積もっておくべきでしたね。

### データベースの設計

データベース設計も知識不足で、かなり苦労しました。共有ページの保存期間とランキングの保持期間はどうするのか…膨大なトラフィックに耐えられ、かつ高速検索が可能なデータベース設計とはどういうものか…最初の適当な設計では対応しきれず、短期間にデータベース構造は何度も変えることになりました。

## おわりに

2日でMVPを作り、4日後に公開し、7日後に止めて、そこから約2週間で立て直した1か月。流石に激動でしたが、作って良かったですね。

世の中が待ち望んだサービスを爆誕させることができて、超スリリングな体験でした。

この記事を読んでくださり、まだ遊んでない方は、ぜひ触ってみてください。

[MY9GAMES - 9本のゲームで自分を紹介してシェア](https://my9games.com/)

そして、ご支援という形で支えてくださった方にも、本当に感謝しています。止める判断をしたあとに立て直しきれたのは、遊んでくださった方や拡散してくださった方はもちろん、応援の言葉や支援で背中を押してくださった方々のおかげでした。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">こちらもご支援いただきありがとうございます、本当に励みになる…。<br><br>一度止めてまでもこのサイトを立て直せて良かった。まだまだなとこはありますが、少し落ち着きが見え始めているので、ゆっくり読ませていただきます。<a href="https://twitter.com/hashtag/My9Games">#My9Games</a> <a href="https://twitter.com/hashtag/%E7%A7%81%E3%82%92%E6%A7%8B%E6%88%90%E3%81%99%E3%82%8B9%E3%81%A4%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0">#私を構成する9つのゲーム</a></p>&mdash; びるすぴ (@singingsores) <a href="https://twitter.com/singingsores/status/2030080219986731348?ref_src=twsrc%5Etfw">March 7, 2026</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

おわり。
