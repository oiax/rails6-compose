# rails6-compose (for Windows)

Docker for Windows を用いて Rails 6 アプリケーションの開発・学習を始めるための設定ファイル等のセット

## 必要なソフトウェア

* Docker for Windows 18 以上
* Git for Windows 2.20 以上

## 動作確認済みのOS

* Windows 10 64bit: Pro/Enterprise/Education

※ この文章の末尾にある「Windowsユーザーへの注記」を参照してください。

## 凡例

* この文書（README.md）では、Rails 6 アプリケーション開発の基盤となるふたつのコンテナ（`db` と `web`）を構築、起動、停止、破棄する手順および `web` コンテナにログインする方法を説明します。
* `web` コンテナ上で Rails アプリケーションの骨格を作り、データベースを初期化する手順については [RAILS.md](RAILS.md) を参照してください。
* コマンドプロンプト（cmd.exe）でコマンドを実行してください。Git for Windows 付属の Git Bash ではうまく行きません。
* コマンドを入力する際には、行頭にある `>` 記号を省いてください。

## 設定ファイル等の取得

```
> git clone https://github.com/oiax/rails6-compose.git
> cd rails6-compose
```

## コンテナ群の構築

```
> setup.bat
```

## コンテナ群の起動

```
> compose.bat up -d
```

## Web コンテナにログイン

```
> compose.bat exec web bash
```

※ ログアウトするには `exit` コマンドを実行するか、`Ctrl-D` キーを入力してください。

## コンテナ群の停止

```
> compose.bat stop
```

## コンテナ群の破棄

```
> compose.bat down
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
