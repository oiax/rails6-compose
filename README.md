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
* Windows 10 Pro 64bit ※

※ この文章の末尾にある「Windowsユーザーへの注記」を参照してください。

## 凡例

* この文書（README.md）では、Rails 6 アプリケーションの骨格を新規作成し、データベースを初期化するところまでの手順を示します。
* 基本的に、ターミナルでコマンドを実行することで作業が進んでいきます。
* Windows では、コマンドプロンプト（cmd.exe）でコマンドを実行してください。Git for Windows 付属の Git Bash ではうまく行きません。
* コマンドを入力する際には、行頭にある `%` 記号および `$` 記号を省いてください。
* `%` 記号の付いたコマンドは、ホスト OS のターミナルで入力してください。
* `$` 記号の付いたコマンドは、Web コンテナのターミナルで入力してください。

## 設定ファイル等の取得

```
% git clone https://github.com/oiax/rails6-compose.git
% cd rails6-compose
```

## コンテナ群の構築

### macOS または Ubuntu の場合

```
% ./setup.sh
```

### Windows の場合

```
% setup.bat
```

## コンテナ群の起動

### macOS または Ubuntu の場合

```
% docker-compose up -d
```

### Windows の場合

```
% compose.bat up -d
```

## Webコンテナにログイン

### macOS または Ubuntu の場合

```
% docker-compose exec web bash
```

### Windows の場合

```
% compose.bat exec web bash
```

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

## コンテナ群の停止

### macOS または Ubuntu の場合

```
% docker-compose stop
```

### Windows の場合

```
% compose.bat stop
```

## コンテナ群の破棄

### macOS または Ubuntu の場合

```
% docker-compose down
```

### Windows の場合

```
% compose.bat down
```

## Windowsユーザーへの注記

Windows 環境では、[Docker for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows) を使うことになりますが、以下の条件を満たさないと動きません。

* Windows 10 のバージョンが Pro または Enterprise または Education の 64 bit 版である。
* BIOS の仮想化機能が有効に設定されている。

つまり、個人・家庭向けの一般的なパソコンにインストールされている Windows 10 Home で Docker for Windows は動きません。Windows 10 Home では [Docker Toolbox](https://docs.docker.com/toolbox/toolbox_install_windows/) が使えるという情報もありますが、筆者の環境ではうまく動きませんでした。

また、2019年2月現在、Docker for Windows には [docker/for-win#1976](https://github.com/docker/for-win/issues/445) で報告されている問題が残されています。2018年7月に[解決策](https://github.com/docker/for-win/issues/445#issuecomment-405185621)が提案されてこの Issue はクローズされていますが、この提案はあくまで迂回策です。同一のパソコンで複数の Rails 開発プロジェクトを並行して進める場合、さまざまな悩ましい問題が生じるでしょう。

以上のような状況を考えると、稼働条件を満たす Windows パソコンを持っていて、ちょっと Ruby on Rails を試してみたい場合には Docker for Windows が向いているけれども、継続的に Rails の開発・学習を行いたいのであれば別の方法を模索すべきかもしれません。

筆者がお勧めする方法は、[Oracle VM VirtualBox](https://www.virtualbox.org/) を利用して [Ubuntu](http://www.ubuntulinux.jp/) 環境を用意し、その上で Docker を使用するというものです。この方法であれば、Windows 10 Home でも動きます。

ちなみに、Windows パソコンに「デュアルブート」方式で Ubuntu 等をインストールすることも可能ですが、一般的には推奨できません。ハードウェア構成によっては非常に難しい作業を行うことになります。Windows 自体に深刻な悪影響を与える可能性もあります。
