# rails6-compose

Docker Compose を用いて Rails 6 アプリケーションの開発・学習を始めるための設定ファイル等のセット

## 必要なソフトウェア

* Docker 18 以上
* Docker Compose 1.13 以上
* Git 2.7 以上

## 動作確認済みのOS

* macOS 10.14 Mojave
* Ubuntu 16.04
* Ubuntu 18.04

### その他のOSに関する注記

* Windows 10 Pro 64bit に関しては、[docker/for-win#1976](https://github.com/docker/for-win/issues/1976) で報告されている問題が未解決。
* Windows 10 Home は Docker 自体が対応していない。
* バージョン 10.13 High Sierra より古い macOS に関しては、おそらく動作すると思われるが、まだ動作確認を行なっていない。

## 凡例

* この文書（README.md）では、Rails 6 アプリケーションの骨格を新規作成し、データベースを初期化するところまでの手順を示します。
* 基本的に、ターミナルでコマンドを実行することで作業が進んでいきます。
* コマンドの行頭にある `%` 記号および `$` 記号は、コマンドプロンプトを示します。ターミナルにコマンドを入力する際には、これらの記号を省いてください。
* `%` 記号の付いたコマンドは、ホストOSのターミナルで入力してください。
* `$` 記号の付いたコマンドは、Webコンテナのターミナルで入力してください。

## コンテナ群の構築

```
% git clone https://github.com/oiax/rails6-compose.git example
% cd example
% ./setup.sh
```

※ `example` の部分は適宜置き換えてください。

## コンテナ群の起動

```
% docker-compose up -d
```

## Webコンテナにログイン

```
% docker-compose exec web bash
```

## Railsアプリケーションの骨格を作る

Webコンテナにログインして以下のコマンド群を実行します。

```
$ cd /apps
$ rails new myapp -BJS -d postgresql
```

※ `myapp` の部分は適宜置き換えてください。

### 指定されたオプションの説明

* `-B`: `bundle install` の実行を後回しにする。
* `-J`: JavaScriptファイル群を生成しない。
* `-S`: Sprocketsファイル群を生成しない。
* `-d`: 選択されたデータベース管理システム（PostgreSQL）用の設定ファイルを生成する

## ソースコードの編集

* ホストOS側のテキストエディタでRailsアプリケーションのソースコードを編集します。
* ソースコードは `example/apps/myapp` フォルダにあります。

### `Gemfile` の編集

`Gemfile` の末尾にある次の記述を削除してください。

```
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
```

### `config/database.yml` の編集

`config` ディレクトリにある `database.yml` の中にある次のような記述を見つけてください。

```
default: &default
  adapter: postgresql
  encoding: unicode
  # For details on connection pooling, see Rails configuration guide
  # https://guides.rubyonrails.org/configuring.html#database-pooling
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
```

この直後に、次の記述を挿入してください。

```
  host: db
  user: postgres
  password:
```

※ 各行の先頭に半角スペースを2個置いてください。

## Railsアプリケーションのセットアップ

Webコンテナにログインして以下のコマンド群を実行します。

```
$ cd /apps/myapp
$ bundle
$ bin/rails db:create
```

## Railsアプリケーションの起動

引き続き、Webコンテナで次のコマンドを実行します。

```
$ bin/rails s
```

## ブラウザで動作確認

ホストOS側のブラウザで http://localhost:3000 を開き、「Yay! You're on Rails!」と書かれたページが表示されることを確認します。

## Railsアプリケーションの停止

Webコンテナ上で `Ctrl-C` キーを押すと、Railsアプリケーションが停止します。

## コンテナ群の停止

```
% docker-compose stop
```

※ 類似のコマンド `docker-compose down` はコンテナ群を破棄してしまいますので、注意してください。
