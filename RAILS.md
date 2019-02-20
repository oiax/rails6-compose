# RAILS.md

[oiax/rails6-compose](https://github.com/oiax/rails6-compose) をベースに Rails 6 アプリケーションの開発・学習を始める手順を解説します。

## アプリケーション開発の方針

* データベース管理システム（DBMS）には PostgreSQL を使用する。
* Sprockets を使わない。
* Webpacker を使う。

## 凡例

* 基本的に、ターミナルでコマンドを実行することで作業が進んでいきます。
* コマンドを入力する際には、行頭にある `%` 記号および `$` 記号を省いてください。
* `%` 記号の付いたコマンドは、ホスト OS のターミナル（Windows の場合は、コマンドプロンプト）で入力してください。
* `$` 記号の付いたコマンドは、Web コンテナのターミナルで入力してください。

## Railsアプリケーションの骨格を作る

Web コンテナにログインして以下のコマンド群を実行します。

```
$ cd /apps
$ rails new myapp -BJS -d postgresql
```

※ `myapp` の部分は適宜置き換えてください。ここに指定された文字列がアプリケーション名となります。

### 指定されたオプションの説明

* `-B`: `bundle install` の実行を後回しにする。
* `-J`: JavaScriptファイル群を生成しない。
* `-S`: Sprocketsファイル群を生成しない。
* `-d`: 選択されたデータベース管理システム（PostgreSQL）用の設定ファイルを生成する

※ Webpacker は後で導入します。

## Webコンテナからログアウト

```
$ exit
```

## ソースコードの編集

* ホスト OS 側のテキストエディタで Rails アプリケーションのソースコードを編集します。
* ソースコードは `rails6-compose/apps/myapp` フォルダにあります。

### `Gemfile` の編集

テキストエディタで `Gemfile` を開き、次のような記述を見つけてください。

```
gem 'bootsnap', '>= 1.1.0', require: false
```

この直後に、次の記述を挿入してください。

```
gem 'webpacker'
```

`Gemfile` 末尾にある次の記述を削除してください。

```
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
```

### `config/database.yml` の編集

テキストエディタで `config` ディレクトリにある `database.yml` を開き、次のような記述を見つけてください。

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
  username: postgres
  password:
```

※ 各行の先頭に半角スペースを 2 個置いてください。

## Rails アプリケーションのセットアップ

Web コンテナにログインして以下のコマンド群を実行します。

```
$ cd /apps/myapp
$ bundle
$ bin/rails webpacker:install
$ bin/rails db:create
```

※ `myapp` の部分は適宜置き換えてください。

## スタイルシートの移設

引き続き、Web コンテナで以下のコマンド群を実行します。

```
$ mkdir app/javascript/stylesheets
$ cp app/assets/stylesheets/scaffold.css app/javascript/stylesheets
$ rm -rf app/assets
```

テキストエディタで `app/javascript/packs/application.js` を開き、内容をすべて削除してから、次の内容を書き加えます。

```
import "../stylesheets/scaffold.css";
```

## レイアウトテンプレートの書き換え

テキストエディタで `app/javascript/packs/application.js` を開き、次のような記述を見つけてください。

```
    <%= stylesheet_link_tag    'application', media: 'all' %>
```

この部分を次のように書き換えてください。

```
    <%= stylesheet_pack_tag    'application', media: 'all' %>
```

## Scaffold の作成

ここまでの作業がうまく進んでいることを確認するため、簡単なユーザー管理をする Scaffold を作ります。

Web コンテナで以下のコマンド群を実行します。

```
$ bin/rails g scaffold user name:string
$ bin/rails db:migrate
```

2 番目のコマンドを実行した結果、ターミナルに次のように表示されれば OK です。ただし、数字の部分は異なります。

```
== 20190219014032 CreateUsers: migrating ======================================
-- create_table(:users)
   -> 0.0092s
== 20190219014032 CreateUsers: migrated (0.0093s) =============================
```

## Rails アプリケーションの起動

ホスト OS で別のターミナルを開き、Web コンテナにログインして以下のコマンド群を実行します。

```
$ cd /apps/myapp
$ bin/webpack-dev-server
```

ホスト OS でさらに別のターミナルを開き、Web コンテナにログインして以下のコマンド群を実行します。

```
$ cd /apps/myapp
$ bin/rails s
```

## ブラウザで動作確認

ホスト OS 側のブラウザで http://localhost:3000/users を開き、「Users」というタイトルのページが開くことを確認します。そして、ユーザーの追加、編集、削除ができることを確認します。

## Scaffold の破棄

動作検証のために作った Scaffold を破棄するため、Web コンテナで以下のコマンド群を実行してください。

```
$ bin/rails db:rollback
$ bin/rails d scaffold user
```

## Rails アプリケーションの停止

Rails アプリケーション起動のために開いたふたつのターミナルでそれぞれ `Ctrl-C` キーを押すと、Rails アプリケーションが停止します。

## コンテナ群の停止

開発作業を終えてパソコンの電源を切る前に DB コンテナと Web コンテナを停止します。

```
% docker-compose stop
```

ソースコードやデータベースの中身は保存されているので、ホスト OS を起動しなおしても `docker-compose up -d` コマンドでコンテナ群を起動すれば、前回の状態から開発作業を続行できます。

## トラブル・シューティング

### OCI runtime create failed: container with id exists

症状: `docker-compose up -d` 実行時に次のようなエラーが出てコンテナ群が起動しない。

```
ERROR: for db  Cannot start service db:
OCI runtime create failed: container with id exists:
54337133f5c4e8a0e25730ec5d5fe73a369053f7cb86801d1d235228426c9581: unknown
```

コンテナ群を停止し、ホスト OS からログアウトしてから、再びホスト OS にログインしてコンテナ群を起動しようとするときに、この症状が出ることがあります。根本的な解決策はまだ見つかっていません。

とりあえずの回避策は、エラーメッセージに含まれるコンテナの `id` を指定してコンテナを削除することです。上記の例では `54337` で始まる 64 桁の 16 進数がコンテナの `id` ですので、次のコマンドを実行すればコンテナ群を起動できるようになります。

```
% docker rm 54337133f5c4e8a0e25730ec5d5fe73a369053f7cb86801d1d235228426c9581
```

このコマンドの実行により DB コンテナが削除されますが、PostgreSQL のデータを格納しているボリュームはそのまま残されているため、コンテナ群を起動すればデータベースの内容は元通りです。

しかし、単に `docker compose up -d` コマンドを実行すると Web コンテナが再構築されてしまうので、前回までの開発作業で Web コンテナにログインして行った操作の結果（例えば、`bundle install` による Gem パッケージ群のインストール）が消えてしまいます。

Web コンテナを再構築せずにそのまま起動するには、次のように `--no-recreate` オプションを加えてください。

```
% docker-compose up -d --no-recreate
```
