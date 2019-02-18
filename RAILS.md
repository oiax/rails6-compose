# RAILS.md

[oiax/rails6-compose](https://github.com/oiax/rails6-compose) をベースに Rails 6 アプリケーションの開発・学習を始める手順を解説します。

## 凡例

* 基本的に、ターミナルでコマンドを実行することで作業が進んでいきます。
* コマンドを入力する際には、行頭にある `%` 記号および `$` 記号を省いてください。
* `%` 記号の付いたコマンドは、ホスト OS のターミナル（Windows の場合は、コマンドプロンプト）で入力してください。
* `$` 記号の付いたコマンドは、Web コンテナのターミナルで入力してください。

## Railsアプリケーションの骨格を作る

Webコンテナにログインして以下のコマンド群を実行します。

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

## Webコンテナからログアウト

```
$ exit
```

## ソースコードの編集

* ホスト OS 側のテキストエディタで Rails アプリケーションのソースコードを編集します。
* ソースコードは `rails6-compose/apps/myapp` フォルダにあります。

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
  username: postgres
  password:
```

※ 各行の先頭に半角スペースを2個置いてください。

## Rails アプリケーションのセットアップ

Web コンテナにログインして以下のコマンド群を実行します。

```
$ cd /apps/myapp
$ bundle
$ bin/rails db:create
```

※ `myapp` の部分は適宜置き換えてください。

## Rails アプリケーションの起動

引き続き、Web コンテナで次のコマンドを実行します。

```
$ bin/rails s
```

## ブラウザで動作確認

ホスト OS 側のブラウザで http://localhost:3000 を開き、「Yay! You're on Rails!」と書かれたページが表示されることを確認します。

## Railsアプリケーションの停止

Web コンテナ上で `Ctrl-C` キーを押すと、Rails アプリケーションが停止します。
