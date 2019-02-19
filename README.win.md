# rails6-compose (for Windows)

Docker for Windows を用いて Rails 6 アプリケーションの開発・学習を始めるための設定ファイル等のセット

## 必要なソフトウェア

* Docker Desktop for Windows 18 以上
* Git for Windows 2.20 以上

## 動作確認済みのOS

* Windows 10 64bit: Pro/Enterprise/Education

※ この文章の末尾にある「Windows 10 Home ユーザーへの注記」を参照してください。

## 凡例

* この文書（README.md）では、Rails 6 アプリケーション開発の基盤となるふたつのコンテナ（`db` と `web`）を構築、起動、停止、破棄する手順および `web` コンテナにログインする方法を説明します。
* `web` コンテナ上で Rails アプリケーションの骨格を作り、データベースを初期化する手順については [RAILS.md](RAILS.md) を参照してください。
* コマンドプロンプト（cmd.exe）でコマンドを実行してください。Git for Windows 付属の Git Bash ではうまく行きません。
* コマンドを入力する際には、行頭にある `>` 記号を省いてください。

## 設定ファイル等の取得

```
> git clone https://github.com/oiax/rails6-compose.git
> cd rails6-compose
> cp docker-compose.win.yml docker-compose.override.yml
```

## ボリュームの作成

```
> docker volume create --name pgdata
```

### ボリュームの作成に関する注記

* 複数の Rails アプリケーション開発プロジェクトを並行して進める場合、上記コマンドの `pgdata` の部分をそれぞれ別の名前、例えば `pgdata1` と `pgdata2` で置き換える必要があります。
* その場合、テキストエディタで `docker-compose.override.yml` を開き、`pgdata` と書かれている箇所を `pgdate1` あるいは `pgdate2` で書き換えてください。
* macOS や Ubuntu での手順と異なり、Windows では明示的にボリュームを作成する必要があります。これは、[docker/for-win#1976](https://github.com/docker/for-win/issues/445) で報告されている問題を回避するためです。2018年7月に[解決策](https://github.com/docker/for-win/issues/445#issuecomment-405185621)が提案されて当該 Issue はクローズされていますが、いまだ根本的な解決には至っていません。

## コンテナ群の構築

```
> docker pull oiax/rails6-deps:latest
> docker-compose build
```

## コンテナ群の起動

```
> docker-compose up -d
```

## Web コンテナにログイン

```
> docker-compose exec web bash
```

※ ログアウトするには `exit` コマンドを実行するか、`Ctrl-D` キーを入力してください。

## コンテナ群の停止

```
> docker-compose stop
```

## コンテナ群の破棄

```
> docker-compose down
```

## ボリュームの破棄

```
> docker volume rm pgdata
```

## Windows 10 Home ユーザーへの注記

[Docker for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows) は、以下の条件を満たさないと動きません。

* Windows 10 のバージョンが Pro または Enterprise または Education の 64 bit 版である。
* BIOS の仮想化機能が有効に設定されている。

つまり、個人・家庭向けの一般的なパソコンにインストールされている Windows 10 Home で Docker for Windows は動きません。追加の費用を支払って Windows 10 Home を Windows 10 Pro にアップグレードする必要があります。

そこで、Windows 10 Home ユーザーには [Oracle VM VirtualBox](https://www.virtualbox.org/) の利用をお勧めします。

VirtualBox をインストールして、仮想マシン上に適当な Linux 系の OS（例えば、[Ubuntu](http://www.ubuntulinux.jp/)）をインストールします。そして、その上で Docker を使用するのです。

VirtualBox 上の仮想マシンは 1 台ですが、その上で複数のコンテナを起動できるので、複数の Rails 開発プロジェクトを並行して進めたり、多数のコンテナから構成される複雑なシステムを組んだりできます。

ちなみに、Windows パソコンに「デュアルブート」方式で Ubuntu 等をインストールすることも可能ですが、一般的には推奨できません。ハードウェア構成によっては非常に難しい作業を行うことになります。Windows 自体に深刻な悪影響を与える可能性もあります。

### Docker Toolbox について

Windows 10 Home では [Docker Toolbox](https://docs.docker.com/toolbox/toolbox_install_windows/) が使えるという情報もありますが、筆者の環境ではうまく動きませんでした。
