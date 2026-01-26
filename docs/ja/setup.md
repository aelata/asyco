# 使用環境の準備

<style> code { white-space: pre-wrap !important; } </style>

`asyco` と `mepoco` は Windows, macOS, Linux のオペレーティング・システム（OS）で使えます。ここでは OS ごとに使用環境の準備について説明します。

<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=2 orderedList=true} -->

<!-- code_chunk_output -->

1. [Windows 11](#windows-11)
2. [macOS 15](#macos-15)
3. [Linux](#linux)

<!-- /code_chunk_output -->

[Asymptote](https://asymptote.sourceforge.io) で日本語を扱うための設定については [asy_ja.md](asy_ja.md) を参照してください。

`asyco` と `mepoco` の動作は以下の環境で確認しています。

| | Windows 11 Pro 24H2 <br> Git for Windows 2.51.2 | macOS 15.7 | Ubuntu 24.04 |Ubuntu 24.04 |
|-|-|-|-|-|
| `bash` | 5.2.37 | 3.2.57 | 5.2.21 | 5.2.21 |
| TeX | Tex Live 2025 <br> (CTAN) | MacTeX 2025 <br> (Homebrew)| Tex Live 2023 <br> (Ubuntu) | Tex Live 2025 <br> (CTAN) |
| `asy` | 3.04 | 3.04 | 2.87 | 3.04 |
| `mpost` | 2.11 | 2.11 | 2.02 | 2.11 |
| `dvisvgm` | 3.4.3 | 3.4.3 | 3.2.1 | 3.4.3 |
| `gs` | 10.03.0 <br> (TeX Live) | 10.06.0 <br> (Homebrew) | 10.02.1 <br> (Ubuntu) | 10.02.1 <br> (Ubuntu) |

Linux のディストリビューションは [Ubuntu 24.04](https://releases.ubuntu.com/noble/) を用い、Windows または macOS 上の仮想環境（[VirtualBox](https://www.virtualbox.org) 7.2）で実行しています。

ローカルの `asy` コマンドや `mpost` コマンドを使う場合は TeX のインストールが必要です。TeX のディストリビューションは、[Comprehensive TeX Archive Network (CTAN)](https://ctan.org) のパッケージを基にした、[TeX Live](https://www.tug.org/texlive/) または [MacTeX](https://www.tug.org/mactex/) を用います。Ubuntu では、[TeX Live 2023（Ubuntu の texlive-full パッケージ）](https://packages.ubuntu.com/noble/texlive-full)または [TeX Live 2025（CTAN のパッケージ）](https://www.tug.org/texlive/)を用います。

[Visual Studio Code (VS Code)](https://code.visualstudio.com) はバージョン 1.106.3、[Markdown Preview Enhanced (MPE)](https://shd101wyy.github.io/markdown-preview-enhanced) はバージョン 0.8.20 を用いています。

<!--
`asy` コマンドは依存するソフトウェアのバージョンに注意が必要です。
* Ghostscript (`gs`) バージョン 9.56 以上
* `dvisvgm`  バージョン 3.2.1 以上
-->

なお、asyco の開発環境は macOS で、[shellcheck](https://github.com/koalaman/shellcheck) で構文を確認し、[shellspec](https://github.com/shellspec/shellspec) で動作を確認しています。

## Windows 11

あらかじめソフトウェアを展開するフォルダ（例えば `C:\opt`）を作成しておきます。このフォルダは自分の環境に合わせて適当に置き換えてください。

Windows のコマンド検索パス（`Path`）の設定が必要になる場合があります。Windows にはユーザ環境変数の `Path`とシステム環境変数の `Path` があり、システム環境変数の `Path` が先に検索されます。環境変数の編集は、~~Windows の設定から「設定 > システム > バージョン情報 > システムの詳細設定 > 環境変数」で行います~~ `C:\Windows\System32\SystemPropertiesAdvanced.exe` を起動し、下部にある <kbd>環境変数(N)...</kbd> ボタンをクリックします。ユーザ環境変数の `Path` は「...のユーザ環境変数 > 変数 Path > 編集」で、システム環境変数の `Path` は「システム環境変数 > 変数 Path > 編集」で設定します。

エクスプローラでファイルの区別を容易にするため、ファイルの拡張子の表示をお勧めします。拡張子を表示するには「エクスプローラのオプション > 表示 > 詳細設定」で「登録されている拡張子を表示しない」のチェックを外します。

<!--
オフライン環境で「このタスクに使用するアプリケーションをインストールする必要があります。Microsoft Store でアプリを検索しますか？」が表示されプログラムを起動できない場合は「実行ファイルの プロパティ > 全般 > セキュリティ」で「許可する」をチェックします。
-->

### Bash

ここでは、[MSYS2](https://www.msys2.org) を基にした [Git for Windows](https://gitforwindows.org) に含まれる bash (Git Bash) を使います。PortableGit のファイル（例えば `PortableGit-2.51.2-64-bit.7z.exe`）を [GitHub](https://github.com/git-for-windows/git/releases) から ダウンロードして実行し、例えば `C:\opt\PortableGit` に展開します。もちろん、インストーラ（例えば、`Git-2.51.2-64-bit.exe`）でインストールしても構いません。Windows の環境変数 `Path` に `env.exe` のあるフォルダ（例えば `C:\opt\PortableGit\usr\bin` や `C:\Program Files\Git\usr\bin`）を加えます。

### VS Code, MPE

VS Code のインストーラ（例えば `VSCodeUserSetup-x64-1.106.3.exe`）を [Download Visual Studio Code のページ](https://code.visualstudio.com/download)からダウンロードしてインストールします。インストーラではなく `.zip` ファイル（例えば `VSCode-win32-x64-1.106.3.zip`）を用いる場合は、例えば `C:\opt\VSCode` に展開し、Windows の環境変数 `Path` に `C:\opt\VSCode\bin` を加えます。

MPE の `.vsix` ファイル（例えば `markdown-preview-enhanced-0.8.20.vsix`）を [GitHub](https://github.com/shd101wyy/vscode-markdown-preview-enhanced/releases) からダウンロードしてインストールします。

```console
$ code --install-extension ./markdown-preview-enhanced-0.8.20.vsix
```

もちろん VS Code のマーケットプレイス経由でインストールしても構いません。

### TeX Live

下記のページを参考に、ネットワークまたは ISO イメージから TeX Live をインストールします。

* [TeX Wiki - TeX Live/Windows (https://texwiki.texjp.org/?TeX%20Live%2FWindows)](https://texwiki.texjp.org/?TeX%20Live%2FWindows)

インストール先には、例えば `C:\opt\texlive\2025` を用います。

#### ネットワークからインストール

CTAN の `systems/texlive/tlnet` (`http://mirror.ctan.org/systems/texlive/tlnet`) の下から、インストーラ（`install-tl-windows.exe`）をダウンロードして実行します。

#### ISO イメージからインストール

CTAN の `systems/texlive/Images` (`http://mirror.ctan.org/systems/texlive/Images`) の下から、ISO イメージ（例えば `texlive2025-20250308.iso`）をダウンロードし、エクスプローラで ISO イメージを開き、その中のインストーラ（`install-tl-windows.bat`）を実行します。

<!--
インストールの時間を短縮するには、高度な設定で、ドキュメントツリー、ソースツリー、TeXworks のインストールのチェックを外します。
-->

#### パッケージの更新

`tlmgr` が Windows のバッチファイルのため、bash ではなく Windows のコマンドプロンプトで作業します。

TeX Live のパッケージの更新には、次のコマンドを実行します。

```console
C:\...>tlmgr update --self --all
```

<!--
リポジトリを指定した更新は、例えば次のようにします。
```console
C:\...>tlmgr update --self --all --repository https://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/
```
-->
<!--
Asymptote のパッケージだけを更新する場合は、次のコマンドを実行します。
```console
C:\...>tlmgr update asymptote
```
-->

### Asymptote

#### TeX Live の asy

TeX Live の `asy` を用いる場合は、特にインストールの必要はありません。

#### SourceForge の asy

SourceForge の `asy` は、TeX Live の `asy` よりも速く（詳細は [time.md](time.md) を参照）、最新版を使えます。
[SourceForge](https://sourceforge.net/projects/asymptote/files/) から Asymptote のインストーラ（例えば `asymptote-3.05-setup.exe`） をダウンロードしてインストールします。Asymptote のインストール先は、標準では `C:\Program Files\Asymptote` です。コマンド検索パスは自動で設定されないため、Windows の環境変数 `Path` に `C:\Program Files\Asymptote` を加えます。

Ghostscript 関連の設定として、例えば以下を `~/.asy/config.asy` に加えます。

```cpp
import settings;
settings.gs="C:\opt\texlive\2025\tlpkg\tlgs\bin\gswin64c.exe";
settings.libgs="C:\opt\texlive\2025\tlpkg\tlgs\bin\gsdll64.dll";
```

また、Windows の環境変数 `GS_LIB` に `C:\opt\texlive\2025\tlpkg\tlgs\Resource\Init;C:\opt\texlive\2025\tlpkg\tlgs\kanji` を設定します。

`asyco` では `asy` の場所を `--cmd` で指定できます。

* `--cmd=/c/opt/texlive/2025/bin/windows` (TeX Live の `asy`)
* `--cmd="/c/Program Files/Asymptote"` (SourceForge の `asy`)

標準ではない場所、例えば `C:\opt\Asymptote` に Asymptote をインストールした場合は、`asyco` を実行する際に `--sysdir=/c/opt/Asymptote` を指定する必要があります。`config.asy` での `settings.sysdir` の設定は有効ではないようです。`--cmd` オプションと `--sysdir` オプションは Windows の環境変数 `ASYCO_OPTS` でも設定できます。

### MetaPost

MetaPost は TeX Live に含まれています。特にインストールの必要はありません。

### ImageMagick

ImageMagick のファイル（例えば `ImageMagick-7.1.2-11-portable-Q16-HDRI-x64.7z`）を [ImageMagick のページ](https://imagemagick.org/script/download.php) からダウンロードし、例えば `C:\opt\ImageMagick-7` の下に展開し（Windows の tar コマンドで展開できます）、Windows の環境変数 `Path` に `C:\opt\ImageMagick-7` を加えます。

<!--
### shellspec

shellspec のファイル（例えば `shellspec-dist.tar.gz`）を [GitHub](https://github.com/shellspec/shellspec/releases) からダウンロードし、例えば `~/src` の下に展開します。`~/.bash_profile` で `PATH` に `~/src/shelspec` を加えます（`PATH="~/src/shellspec:$PATH"`）。
-->

## macOS 15

### Homebrew

macOS では Homebrew を用いると必要な環境の準備が簡単になります。あらかじめ macOS の Command Line Tools (CLT) をインストールします。

```console
% sudo xcode-select --install
```

Homebrew のインストーラ（例えば `Homebrew-5.0.8.pkg`）を [GitHub](https://github.com/Homebrew/brew/releases) からダウンロードして実行します。以下を `~/.zprofile` に加え、あらためてターミナルを開きます<!--（macOS ではターミナルを開くたびにログインシェルが起動されます）-->。

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```
<!--
Homebrew 自体の更新とパッケージの更新を行います。

```console
% brew update
% brew upgrade
```
-->

### VS Code, MPE

Homebrew で VS Code をインストールします。

```console
% brew install --cask visual-studio-code
```

MPE の `.vsix` ファイル（例えば `markdown-preview-enhanced-0.8.20.vsix`）を [GitHub](https://github.com/shd101wyy/vscode-markdown-preview-enhanced/releases) からダウンロードし、インストールします。

```console
% code --install-extension ./markdown-preview-enhanced-0.8.20.vsix
```

もちろん VS Code のマーケットプレイス経由でインストールしても構いません。

### MacTeX

MacTeX はインストーラ（`MacTeX.pkg`）ではなく Homebrew によるインストールをお勧めします。Asymptote が依存する Ghostscript が同時にインストールされます。

```console
% brew install --cask mactex-no-gui
```

Asymptote の設定ファイル（`~/.asy/config.asy`）で libgs を設定します。

```cpp
import settings;
settings.libgs = "/opt/homebrew/lib/libgs.dylib";
```

#### パッケージの更新

MacTeX のパッケージの検証のため、あらかじめ [GnuPG](https://gnupg.org) をインストールしておきます。

```console
% brew install gnupg
```

MacTeX のパッケージの更新には、次のコマンドを実行します。

```console
% sudo tlmgr update --self --all
```

<!--
リポジトリを指定した更新は、例えば次のようにします。

```console
% sudo tlmgr update --self --all --repository https://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/
```
-->

### Asymptote

Asymptote は MacTeX に含まれています。特にインストールの必要はありません。

Homebrew で最新版の Asymptote (`/opt/homebrew/bin/asy`) もインストールできます。

```console
% brew install asymptote
```

`asyco` では `asy` の場所を `--cmd` で指定できます。

* `--cmd=/Library/TeX/texbin` (MacTeX の `asy`)
* `--cmd=/opt/homebrew/bin` (Homebrew の `asy`)

`--cmd` オプションは環境変数 `ASYCO_OPTS` でも設定できます。

### MetaPost

MetaPost は MacTeX に含まれています。特にインストールの必要はありません。

### ImageMagick

Homebrew で [ImageMagick](https://imagemagick.org/index.php) をインストールします。

```console
% brew install imagemagick
```

ImageMagick-7 がインストールされます。

<!--
### shellcheck と shellspec

シェルスクリプトの開発に shellcheck と shellspec を用います。

```console
% brew install shellcheck
% brew install shellspec
```
-->

## Linux

Linux のディストリビューションとして Ubuntu 24.04 を用います。[VirtualBox](https://www.virtualbox.org) で実行する場合は、ある程度の資源（例えば、複数コアなど）を割り当てます。

### Ubuntu のパッケージの更新

作業の前に Ubuntu のパッケージを更新します。

```console
$ sudo apt update
$ sudo apt upgrade
## $ sudo apt autoremove # as needed
## $ sudo systemctl reboot # as needed
```

### 日本語環境のパッケージ

日本語環境の追加が必要な場合は、パッケージをインストールします。

```console
$ sudo apt install $(check-language-support -l ja)
$ sudo systemctl reboot
```

### VS Code, MPE

VS Code の `.deb` ファイル（例えば `code_1.106.3-1764110892_amd64.deb`）を [Download Visual Studio Code のページ](https://code.visualstudio.com/download)からダウンロードし、インストールします。

```console
$ sudo apt install ./code_1.106.3-1764110892_amd64.deb
```

`Add Microsoft apt repository for Visual Studio Code?` は矢印キーでどちらかを選び <kbd>Enter</kbd> を押します。`N: Download is performed unsandboxed as root ...` のメッセージは無視します。

Markdown Preview Enhanced (MPE) の `.vsix` ファイル（例えば `markdown-preview-enhanced-0.8.20.vsix`）を [GitHub](https://github.com/shd101wyy/vscode-markdown-preview-enhanced/releases) からダウンロードしてインストールします。

```console
$ code --install-extension ./markdown-preview-enhanced-0.8.20.vsix
```

もちろん VS Code のマーケットプレイス経由でインストールしても構いません。

<!--
Git も併せてインストールします。

```bash
$ sudo apt install git
```
-->

### ブラウザ

Ubuntu 24.04 の標準ブラウザは Snap 版の Firefox です。Snap 版の Firefox は `/tmp` の下あるファイルを開けないため、MPE の `Open in Browser` が使えません（`Export > HTML` で作成した HTML ファイルを開くことはできます）。このため Snap 版ではないブラウザをインストールします。

Firefox の[ダウンロードページ](https://www.firefox.com/ja/download/all)でブラウザー、プラットフォーム、言語を選択し、ファイル（例えば `firefox-147.0.1.tar.xz` や `firefox-140.7.0esr.tar.xz`）をダウンロードします。

インストール先（例えば `~/bin`）にファイルを展開します。

```console
$ cd ~/bin
$ tar xf ~/Download/firefox-147.0.1.tar.xz
```

`~/.local/share/applications` の下に、例えば次のファイルを作成します。

The content of `custom-firefox.desktop`:

```ini
[Desktop Entry]
Type=Application
Name=Custom Firefox
Exec=sh -c "$HOME/bin/filefox/firefox %u"
Icon=firefox
Terminal=false
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
```

Ubuntu の Settings > Apps > Default Apps > Web で Custom Firefox を選択し、既定のブラウザに設定します。

<!--
下記の記事を参考にデフォルトブラウザを変更します。

[Snap版Firefoxを使用しないでやり過ごす (https://gihyo.jp/admin/serial/01/ubuntu-recipe/0710)](https://gihyo.jp/admin/serial/01/ubuntu-recipe/0710)

ここでは `firefox-esr` をインストールし、デフォルトブラウザに設定します。

```console
$ sudo add-apt-repository ppa:mozillateam/ppa
$ sudo apt install firefox-esr firefox-esr-locale-ja

$ xdg-settings set default-web-browser firefox-esr.desktop
```
-->

<!--
Firefox の言語（設定 > 一般 > 言語）を日本語に設定しないと、違和感のあるフォントで日本語が表示される場合があります。
-->

### TeX Live

TeX Live は、Ubuntu のパッケージによるインストールが簡単ですが、CTAN から最新の TeX Live をインストールすることもできます。

#### Ubuntu のパッケージによるインストール

Ubuntu の `texlive-full` パッケージを用いて TeX Live をインストールします。

```console
$ sudo apt install texlive-full
```

Ubuntu 24.04 では TeX Live 2023 がインストールされ、`asy` のバージョンは 2.87 になります。

#### CTAN のパッケージによるインストール

あらかじめインストール先のディレクトリを作成します（例えば `sudo mkdir /usr/local/texlive`）。所有者を自分に変更（例えば `sudo chown $USER /usr/local/texlive`）してからインストールすると、`tlmgr` の実行に `sudo` が不要になります。
<!-- 所有者が root のままの場合は、`/etc/sudoers` で `tlmgr` のパス（例えば `/usr/local/texlive/2025/bin/x86_64-linux`）を `secure_path` に加える必要があります。 -->

##### ネットワーク・インストール

CTAN の `systems/texlive/tlnet` (`http://mirror.ctan.org/systems/texlive/tlnet`) の下から、インストーラ（`install-unx.tar.gz`）をダウンロードして展開し、`install-tl` を実行します。

##### ISO イメージからインストール

CTAN の `systems/texlive/Images` (`http://mirror.ctan.org/systems/texlive/Images`) の下から、ISO イメージ（例えば `texlive2025-20250308.iso`）をダウンロードしてマウントし、`install-tl` を実行します。

##### TeX Live の設定

シェルの初期設定ファイル（例えば `~/.bash_profile`）で `PATH` に TeX Live のディレクトリ（例えば `/usr/local/texlive/2025/bin/x86_64-linux`）を加えます。

`asy` を動かすためには、さらに以下を実行する必要があります。

```console
$ sudo apt install freeglut3-dev
$ sudo ln -s /lib/x86_64-linux-gnu/libglut.so.3{.12.0,}
```

##### パッケージの更新

TeX Live のパッケージの更新には、次のコマンドを実行します。

```console
$ tlmgr update --self --all
```

<!--
リポジトリを指定した更新は、例えば次のようにします。

```console
$ tlmgr update --self --all --repository https://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/
```
-->

TeXLive 2025 の ISO イメージの `asy` のバージョンは 3.01 ですが、tlmgr でパッケージを更新すると、`asy` のバージョン 3.04 になります。

### Asymptote

Asymptote は TeX Live に含まれています。特にインストールの必要はありません。

最新版の Asymptote を使いたい場合は、ソース・コードからビルドします。詳細は割愛しますが、以下を参考にしてください。

<!--
```console
$ wget https://github.com/ivmai/bdwgc/releases/download/v8.2.4/gc-8.2.4.tar.gz
$ wget https://github.com/ivmai/libatomic_ops/releases/download/v7.6.12/libatomic_ops-7.6.12.tar.gz
```
-->

```console
$ sudo apt install build-essential autoconf bison flex libtool pkg-config libz-dev freeglut3-dev libtirpc-dev libglm-dev libreadline-dev libcurl4-openssl-dev libboost-filesystem-dev libgsl-dev libfftw3-dev libsigsegv-dev python3-pyqt5 qttools5-dev

$ cd ~/src
$ tar xf ~/Download/asymptote-3.05.tar.gz
$ cd asymptote-3.05

$ ./autogen.sh
$ ./configure --prefix=/opt/Asymptote --disable-lsp
$ make
$ make check
$ make install
```

### MetaPost

MetaPost は TeX Live に含まれています。特にインストールの必要はありません。

### ImageMagick

ImageMagick をインストールします。

```console
$ sudo apt install imagemagick
```

ImageMagick-6 がインストールされます。Asymptote 2.92 以後は ImageMagick-7 の `magick` コマンドを期待します。TeX Live 2025 の `asy` を使う場合は、`~/.asy/config.asy` に `settings.convert = "convert";` を加えます。

<!--
### shellspec

```console
$ cd ~/src
$ tar xf ~/Download/shellspec-dist.tar.gz
$ cd ~/bin
$ ln -s ~/src/shellspec/shellspec .
```
-->

---
