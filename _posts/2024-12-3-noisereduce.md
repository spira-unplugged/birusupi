---
layout: post
title: "noisereduceを用いた音声ノイズの除去"
author: "Birusupi"
categories: documentation
tags: [Python, ノイズ除去, 音声処理, noisereduce, ハイブリッドセミナー, 録音トラブル, Web会議, 社内DX, 音声ファイル処理, 技術メモ]
excerpt: "Pythonライブラリnoisereduceを使って、社内セミナー録音のノイズ除去に挑戦。実際のコードと処理手順を紹介します。"
image: /assets/img/2024-12-3-noisereduce/001.jpg
---
※noteでも同内容を投稿しています。

[Pythonを用いた音声ファイルのノイズの除去（ライブラリ: noisereduce）｜びるすぴ](https://note.com/vonflume/n/n3788d8770df7)

## はじめに

先日職場で職員全員受講必須のセミナーが行われました。
リアルとWEB配信のハイブリッド形式で開催されたのですが、ミキサーの入力設定ミスにより、WEB配信は音割れが酷かった。

一応PCMレコーダーでも会場の録音が行われていたようで、録画とそれをマッシュアップしてアーカイブを配信することとなったようです。
しかし、録音には多くの背景ノイズが含まれていたことから配信するにはこれを除去する必要があり、なんとかできないかと依頼されました。そこで、音声処理を行い品質の改善を試みました。

私は社内SEでもなんでも無いですが、以前職場のDX化に貢献したことがあり、その際に超アマチュアプログラマーとして社内に認知されたようで時折こういった頼まれ事が来ることがあります。私としても本業の合間にちょちょっとプログラムを書いて問題を解決してお礼としてお菓子をいただいたり、ランチに誘っていただいたりと中々嬉しいのでやりがいがあります。

この記事では、そのプロセスと実際に使用したコードについて簡単に解説してみます。

## プログラム概要

### 1. 環境構築とライブラリの準備

音声処理には、以下のPythonライブラリを使用しました。使用したPythonのバージョンは3.10.2です。

- **librosa**: 音声ファイルの読み込みとノーマライゼーションを処理を行う。
- **noisereduce**: ノイズ除去を行う。今回のメイン。
- **soundfile**: オーディオファイルの読み書きを行う。
- **scipy.signal**: 音声のフィルタリングを行う。

特に重要なライブラリはnoisereduceです。ありがたいことにライブラリがありました。

📌[timsainb/noisereduce: Noise reduction in python using spectral gating (speech, bioacoustics, audio, time-domain signals)](https://github.com/timsainb/noisereduce.git)

ノイズスペクトラムを分析しもとの音源から差し引くという仕組みでノイズ除去を行います。
[Audacity](https://www.audacityteam.org/)でも同様の機能があるはずですが、支給PCにフリーソフトのインストールを行うのがNGだったので却下。前述のDX化貢献時に特別にインストールを許可してもらったPythonを用いて対処することにしました。

これらのライブラリは以下のコマンドでインストールしておきます。

```
pip install librosa noisereduce soundfile scipy
```

### 2. 実際に行った音声処理のコードとその解説

以下を実行することで、ノイズ除去を行いました。

```
import librosa
import noisereduce as nr
import soundfile as sf
import scipy.signal as signal

# 音声ファイルのファイルパスを指定
file_path = '/***.MP3'

# 音声ファイルの読み込み
audio_data, sample_rate = librosa.load(file_path, sr=None)

# ノイズを含むセグメントを10秒間選択
noise_duration = 10  # ノイズサンプルとして10秒を指定
noise_segment = audio_data[0:int(sample_rate * noise_duration)]

# ノイズリダクションの実行
reduced_noise_audio = nr.reduce_noise(
    y=audio_data,
    y_noise=noise_segment,
    sr=sample_rate,
    prop_decrease=0.80  # ノイズ削減の強度を80%に設定
)

# ローカットフィルターの適用
cutoff_frequency = 100.0  # カットオフ周波数を100Hzに設定
normalized_cutoff = cutoff_frequency / (0.5 * sample_rate)  # カットオフ周波数を正規化
b, a = signal.butter(1, normalized_cutoff, btype='high', analog=False)
filtered_audio = signal.lfilter(b, a, reduced_noise_audio)

# ノーマライゼーション
normalized_audio = librosa.util.normalize(filtered_audio)

# 処理後の音声を保存
output_path = '/***/output_audio_normalized.wav'
sf.write(output_path, normalized_audio, sample_rate)

print("ノイズ除去、ローカットフィルタリング、ノーマライズ処理が完了しました。出力されたファイル:", output_path)
```

**コードの解説**

- **音声ファイルの読み込み**

  - **librosa.load(file\_path, sr=None)**で指定した音声ファイルを読みこみます。sr=Noneはサンプリングレート維持の意味。

- **ノイズセグメントの選択とノイズリダクション**

  - 音声ファイル冒頭の10秒が背景ノイズのみだったので、この10秒をノイズサンプルとして指定します。

- **nr.reduce\_noise**で音声から80%の強度でノイズ削減を指定します

  - （**prop\_decrease=0.80**）。0.80が一番丁度良かったですが、ここはお好みで。

- **ローカットフィルターの適用**

  - **scipy.signal**のハイパスフィルタを利用して、空調や建物の振動音などといった約100Hz以下の低周波ノイズを取り除いています。

- **ノーマライズ**

  - **librosa.util.normalize**を使用して、全体の音量を均一にします。

- **処理後の音声を保存**

  - **soundfile.write**でノイズが除去された音声データを保存します。

## まとめ

本プログラムで職場の講演録音に含まれたノイズをある程度除去できました。当日聴講できなかった、音割れがあって聴講を辞めてしまったなどの理由で後日配信を視聴する職員が多かったと聞いているので、役に立ったようで良かったです。

![]({{ site.baseurl }}/assets/img/2024-12-3-noisereduce/003.png)
<div style="text-align: center;">お礼に連れてっていただいたランチのお刺身</div>