# rails6-compose

Docker を用いて Rails 6 アプリケーションの開発・学習を始めるための設定ファイル等のセット

## 必要なソフトウェア

* Docker 18 以上
* Git 2.7 以上

## 動作確認済みのOS

* macOS 10.14 Mojave
* Ubuntu 16.04
* Ubuntu 18.04

※ Windowsユーザーの方は [README.win.md](README.win.md) を参照してください。

## 凡例

* この文書（README.md）では、Rails 6 アプリケーション開発の基盤となるふたつのコンテナ（`db` と `web`）を構築、起動、停止、破棄する手順および `web` コンテナにログインする方法を説明します。
* `web` コンテナ上で Rails アプリケーションの骨格を作り、データベースを初期化する手順については [RAILS.md](RAILS.md) を参照してください。
* ターミナルでコマンドを実行することで作業が進んでいきます。
* コマンドを入力する際には、行頭にある `%` 記号を省いてください。

## 設定ファイル等の取得

```
% git clone https://github.com/oiax/rails6-compose.git
% cd rails6-compose
```

## コンテナ群の構築

```
% ./setup.sh
```

## コンテナ群の起動

```
% docker-compose up -d
```

## Web コンテナにログイン

```
% docker-compose exec web bash
```

※ ログアウトするには `exit` コマンドを実行するか、`Ctrl-D` キーを入力してください。

## コンテナ群の停止

```
% docker-compose stop
```

## コンテナ群の破棄

```
% docker-compose down
```
