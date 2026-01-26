# asyco

`asyco` を使うと [Asymptote](https://asymptote.sourceforge.io) 言語で書かれた図をマークダウン文書に容易に埋め込めます。図の埋め込みには [Visual Studio Code (VS Code)](https://code.visualstudio.com) の拡張機能である [Markdown Preview Enhanced (MPE)](https://shd101wyy.github.io/markdown-preview-enhanced/#/ja-jp/) の[コードチャンク](https://shd101wyy.github.io/markdown-preview-enhanced/#/ja-jp/code-chunk)を用います。マークダウン文書は、ブラウザや [pandoc](https://pandoc.org) を経由することで PDF ファイルに変換できます。`asyco` は `asy` コマンドを包む bash スクリプトで、`asy` が出力する図形ファイルを標準出力に送ります。

![Asymptote で書かれた図の Visual Studio Code でのプレビュー](ISSUES.png "Asymptote で書かれた図の Visual Studio Code でのプレビュー")

## 必要な環境

`asyco` は Windows, macOS, Linux で使えます。次の環境が必要です：

* `env` コマンドで bash スクリプトを実行でき、`sort`, `awk` などの基本ツールを使える

    Windows では [Git for Windows](https://gitforwindows.org) ([MSYS2](https://www.msys2.org)) の環境で bash スクリプトを実行できます。`env.exe` のあるディレクトリ（例えば `C:\opt\PortableGit\usr\bin`）が Windows のコマンド検索パス（`Path`）に含まれている必要があります。

* VS Code で MPE のコードチャンクを実行できる

    VS Code の設定で `Markdown-preview-enhanced: Enable Script Execution` が選択されている必要があります（初期設定では選択されていません）。

さらに次のいずれかの環境が必要です：

* ローカルの `asy` コマンドで SVG (Scalable Vector Graphics) または PNG (Portable Network Graphics) 形式の図を出力できる

* [Asymptote http server](https://github.com/vectorgraphics/asymptote-http-server)（例えば `asymptote.ualberta.ca:10007`）に接続できる

必要な環境の準備については [setup.md](setup.md) を参照してください。

## インストール

`asyco` のインストール先（例えば `$HOME/bin` や `/usr/local/bin`）はシェルのコマンド検索パス（`PATH`）に含まれている必要があります。Windows では、あらかじめ `asyco` のインストール先（例えば `%USERPROFILE%\bin` や `C:\opt\PortableGit\usr\local\bin`）を Windows のコマンド検索パス（`Path`）に追加します。`Path` の値はシェルのコマンド検索パス（`PATH`）に取り込まれます。

以下の手順で `asyco` をインストールします。

1. `asyco` をインストール先にコピーします。
2. `asyco` に実行権限を付与します。

例えばインストール先が `$HOME/bin` の場合、bash などのシェルのコマンド行で以下を実行します。

```console
$ cp asyco ~/bin
$ chmod +x ~/bin/asyco
```

`asyco` のインストールには `install.sh` スクリプトも利用できます。インストールの詳細と動作確認については [INSTALL.md](INSTALL.md) を参照してください。

## 使用法

VS Code でマークダウン文書を開き、`asyco` を呼び出すコードチャンクを書いて実行します。

### コードチャンクの記述

コードチャンクのオプションで：

* 必要に応じて構文強調表示の言語に `cpp`（構文が Asymptote に類似）を設定
* `cmd` に `env` を設定
* `args` に `asyco` とそのオプションを設定
* `output` に `html` を設定

次の例では `args` に `asyco` のオプション `-M 1mm`（図に 1mm の余白を設定）を追加しています。

````markdown
```cpp {cmd=env args=[asyco -M 1mm] output=html}
draw(scale(1cm) * unitcircle); // Asymptote code here
```
````

### コードチャンクの実行

VS Code の `Open Preview to the Side` でプレビューを表示し、`Run Code Chunk`（ <kbd>▶︎</kbd> ボタン）または `Run All Code Chunks`（ <kbd>ALL</kbd> ボタン）でコードチャンクを実行します。

### PDF ファイルの作成

プレビューのショートカットメニュー（コンテキストメニュー）で `Open in Browser` を実行します。ブラウザで文書を印刷することで PDF ファイルを作成できます。ショートカットメニューの `Export > HTML` で HTML ファイルを作成し、`pandoc` コマンドで HTML ファイルを PDF ファイルに変換することもできます。

## 使用例

### Asymptote http server

Asymptote http sever を使えば、ローカルの `asy` コマンドを使えなくても、Asymptote で書かれた図をマークダウン文書に埋め込めます。Asymptote http sever を使うには `asyco` の `--remote` オプションを指定します。サーバを `--server` オプションで設定しなければ、`asymptote.ualberta.ca:10007` がサーバに用いられます。

````markdown
```cpp {cmd=env args=[asyco --remote] output=html}
draw(scale(1cm) * unitcircle); // Asymptote code here
```
````

### PNG 画像

図を PNG 画像として出力するには `asyco` のオプションに `-f png` を指定します。コードチャンクの `output` オプションには `html` を設定します（`png` ではありません）。次の例では、画像の解像度と表示倍率を変更し（`-render 4 --img-zoom=0.25x`）、画像を `fig.png` に保存します（`-o fig`）。

````markdown
```cpp {cmd=env args=[asyco -f png -render 4 --img-zoom=0.25x -o fig] output=html}
draw(scale(1cm) * unitcircle); // Asymptote code here
```
````

### 警告メッセージ

ローカルの `asy` コマンドを用いる場合、警告メッセージやエラーメッセージが表示されることがあります。

````markdown
```cpp {cmd=env args=[asyco --silent] output=html}
size(1cm);
dot("$O$", (0, 0));
```
````

上の例では、次のメッセージが表示されます。

```console
: warning [unbounded]: x scaling in picture unbounded
: warning [unbounded]: y scaling in picture unbounded
```

警告メッセージは `asyco` の `--silent` オプションで抑制できます。警告メッセージは `asy` の `-nowarn` オプションでも個別に抑制でき、上のメッセージは `-nowarn unbounded` で抑制できます。

Asymptote http server を用いる場合、エラーメッセージは表示されますが警告メッセージは表示されません。

## オプション

`-f {svg|png}`
: 図の出力形式を設定します。対応する形式は SVG（`svg`）と PNG（`png`）だけです。省略時値は `svg` です。

`-o PREFIX`
: 出力ファイルの ディレクトリ名 / ファイル名（拡張子なし）を *`PREFIX`* に設定します。出力ファイルは保存されます。

`-A {L|C|R|N}`
: 図の位置揃えを設定します。次の値を設定できます：`L` 左揃え、`C` 中央揃え、`R` 右揃え、`N` 位置揃えなし。省略時値は `C` です。

`-K`
: 中間ファイルを保持します。

`-M MARGIN`
: 図の周囲に大きさ *`MARGIN`* の余白を設定します。省略時値は `0`（余白なし）です。

`--alt=TEXT`
: 図の代替テキストを *`TEXT`* に設定します。

`--cd=DIR`
: 作業ディレクトリを *`DIR`* に設定します。

`--clip-prefix=PREFIX`
: 図を SVG 形式で出力する場合に、`clipPath` の ID の衝突を避けるため、ID の前に文字列 *`PREFIX`* を付加します。省略時値は空文字列です（何も付加しません）。

`--cmd=PATH`
: 場所 *`PATH`* の `asy` を使います。特定のバージョンを使う際などに用います。

`--dothide`
: hide クラス（`.hide`）を定義します。hide クラスは「[MPE のコードチャンクの hide オプションの不具合](https://github.com/shd101wyy/vscode-markdown-preview-enhanced/issues/1893)」を避けるために用います。

`--img-zoom=ZOOM`
: 図を PNG 形式で出力する場合に、図の表示倍率を *`ZOOM`* に設定します。数値の末尾に `x` を付加すると値を 4/3 倍します。省略時値は `1x` です。

`--no-text`
: 実行結果のテキスト出力を表示しません。

`--remote`
: ローカルの `asy` コマンドの代わりに Asymptote http server を使います。

`--server=SERVER`
: Asymptote http server を *`SERVER`* に設定します。省略時値は `asymptote.ualberta.ca:10007` です。

`--silent`
: 警告メッセージを表示しません。

他に、最初の引数でだけ有効な次のオプションがあります：`-h`, `--help`（使用法を表示して終了）、`--version`（バージョンを表示して終了）、`-n`（すぐにコマンドを終了）。

その他のオプションは `asy` コマンドに渡されます。このため、短いオプションは結合できません（例えば `-KA N` ではなく `-K -A N`）。また、短いオプションとその引数は結合できません（例えば `-AN` ではなく `-A N`）。

## 関連項目

* `asyco` の詳細は [asyco.md](asyco.md) を参照してください。
* `mepoco` を使うと [MetaPost](https://tug.org/metapost.html) 言語で書かれた図をマークダウン文書に容易に埋め込めます。詳細は [asyco.md](asyco.md) を参照してください。
* `asycat` を使うと、Asymptote または MetaPost のファイルから、コードと図を横に並べたマークダウンを生成できます。詳細は [asycat.md](asycat.md) を参照してください。
* よくある問題と対処法については [ISSUES.md](ISSUES.md) を参照してください。

## 著作権と利用許諾

(c) 2025-2026 aelata

このソフトウェアは MIT No Attribution (MIT-0) で利用許諾されます。ただし、本許諾は拡張子が .html または .js のファイルには適用されないものとします。
[https://opensource.org/license/mit-0](https://opensource.org/license/mit-0)

---
