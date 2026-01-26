# asyco と mepoco

<style>code { white-space: pre-wrap !important; } </style>

`asyco` を使うと [Asymptote](https://asymptote.sourceforge.io) 言語で書かれた図をマークダウン文書に容易に埋め込めます。図の埋め込みには [Visual Studio Code (VS Code)](https://code.visualstudio.com) の拡張機能である [Markdown Preview Enhanced (MPE)](https://shd101wyy.github.io/markdown-preview-enhanced/#/ja-jp/) の[コードチャンク](https://shd101wyy.github.io/markdown-preview-enhanced/#/ja-jp/code-chunk)を用います。[MetaPost](https://tug.org/metapost.html) 言語で書かれた図には `mepoco` を使います。

![Asymptote で書かれた図の Visual Studio Code でのプレビュー](ISSUES.png "Asymptote で書かれた図の Visual Studio Code でのプレビュー"){width=60% style="display:block;margin:auto;"}

マークダウン文書は、ブラウザや [pandoc](https://www.pandoc.org) を経由することで PDF ファイルに変換できます。`asyco` と `mepoco` は bash スクリプトで、`asy` や `mpost` コマンドが出力する図形ファイルを標準出力に送ります。

![asyco のフロー図](asyco_flow.png "asyco のフロー図"){width=53% style="display:block;margin:auto;"}

## 必要な環境とインストール

[INSTALL.md](./INSTALL.md) を参照してください。

## 使用法

VS Code でマークダウン文書を開き、`asyco` または `mepoco` を呼び出すコードチャンクを書いて実行します。

### コードチャンクの記述

コードチャンクのオプションで：

* 必要に応じて構文強調表示の言語に `cpp`（構文が Asymptote に類似）または `metafont`（構文が MetaPost に類似）を設定
* `cmd` に `env` を設定
* `args` の最初の引数に `asyco` または `mepoco` を設定し、そのオプションを `args` に追加
* `output` に `html` を設定

次の例では `args` に `asyco` のオプション `-M 1mm`（図に 1mm の余白を設定）を追加しています。

````markdown
```cpp {cmd=env args=[asyco -M 1mm] output=html}
draw(scale(1cm) * unitcircle); // Asymptote code here
```
````

MetaPost で書かれた図では `args` の `asyco` を `mepoco` に置き換えます。必要に応じて構文強調表示の言語には `metafont` を設定します。次の例では `mepoco` の `-F` オプション（コードの前後に `beginfig(0);` と `endfig;` を付加）も指定しています。

````markdown
```metafont {cmd=env args=[mepoco -F -M 1mm] output=html}
draw fullcircle scaled 3cm; % MetaPost code here
```
````

### コードチャンクの実行

VS Code の `Open Preview to the Side` でプレビューを表示し、`Run Code Chunk`（ <kbd>▶︎</kbd> ボタン）または `Run All Code Chunks`（ <kbd>ALL</kbd> ボタン）でコードチャンクを実行します。

### PDF ファイルの作成

プレビューのショートカットメニュー（コンテキストメニュー）で `Open in Browser` を実行します。ブラウザで文書を印刷することで PDF ファイルを作成できます。ショートカットメニューの `Export > HTML` で HTML ファイルを作成し、`pandoc` コマンドで HTML ファイルを PDF ファイルに変換することもできます。

## コードチャンクのオプション

MPE のコードチャンクの最初の行は次のような形式です。

````markdown
```lang {cmd=command args=[arg1 arg2 ...] output=format ...}
````

例えば次のようになります。

````markdown
```cpp {cmd=env args=[asyco -f png -render 4] output=html}
````

`args` オプションは次のように設定することもできます

````markdown
```cpp {cmd=env args=["asyco", "-f", "png", "-render", "4"] output=html}
````

コードチャンクの主なオプションを以下に示します：

`lang`
: 構文強調表示の言語を設定します。VS Code と MPE は、Asymptote (`asy`) と MetaPost (`mp`) の構文強調表示に対応していませんが、代わりに構文が似た言語を設定できます。Asymptote では `cpp`、MetaPost では `metafont` を設定します。詳細は [ISSUES.md](ISSUES.md) を参照してください。

`cmd`
: 実行するコマンドを設定します。`env` コマンドを設定します。macOS や Linux では `asyco` や `mepoco` を設定する方法もありますが、Windows との文書の互換性を考慮して `env` を設定することをお勧めします。

`args`
: コマンドの引数を設定します。最初に `asyco` または `mepoco` を設定し、もしあればそのオプションを追加します。

`output`
: MPE がコマンドの出力を扱う形式を設定します。ほとんどの場合に `html` を設定します。実行結果を表示しない場合には `none` を設定します。`text` を設定すると、コマンドの実行結果をテキストで確認できます。省略時値は `text` です。

`hide`
: コードチャンクを隠し、コマンドの実行結果だけを表示します。

`id`
: 他のコードチャンクから参照するための識別子を設定します。例えば `id=Fig-1` のように設定します。これは `#Fig-1` と略せます。

`continue`
: 別の（参照先の）コードチャンクと参照元のコードチャンクのコードを結合し、参照元のコードチャンクのオプションで実行します。例えば `continue=Fig-1` は識別子が `Fig-1` のコードチャンクを参照し、単に `continue` は直前のコードチャンクを参照します。

## オプション

### asyco と mepoco で共通のオプション

`-f {svg|png}`
: 図の出力形式を設定します。対応する形式は SVG（`svg`）と PNG （`png`）だけです。省略時値は `svg` です。

`-o PREFIX`
: 出力ファイルの ディレクトリ名/ファイル名（拡張子なし）を *`PREFIX`* に設定します。`mepoco` では *`PREFIX`* にディレクトリを含められません。出力ファイルは保存されます。

`-A {L|C|R|N}`
: 図の位置揃えを設定します。次の値を設定できます：`L` 左揃え、`C` 中央揃え、`R` 右揃え、`N` 位置揃えなし。CSS (Cascading Style Sheets) の `justify-content` プロパティの値も設定できます。省略時値は `C` です。

`-K`
: 中間ファイルを保持します。

`-M MARGIN`
: 図の周囲に大きさ *`MARGIN`* の余白を設定します。`mepoco` では、コードが `beginfig` と `endfig` を含まず、これらを `-F` オプションで付加する場合にだけ余白を設定できます。省略時値は `0`（余白なし）です。

`--alt=TEXT`
: 図の代替テキストを *`TEXT`* に設定します。

`--cd=DIR`
: 作業ディレクトリを *`DIR`* に設定します。

`--clip-prefix=PREFIX`
: 図を SVG 形式で出力する場合に、`clipPath` の ID の衝突を避けるため、ID の前に文字列 *`PREFIX`* を付加します。省略時値は空文字列です（何も付加しません）。

`--cmd=PATH`
: 場所 *`PATH`* の `asy` や `mpost` を使います。特定のバージョンを使う際などに用います。

`--dothide`
: hide クラス（`.hide`）を定義します。hide クラスは「[MPE のコードチャンクの hide オプションの不具合](https://github.com/shd101wyy/vscode-markdown-preview-enhanced/issues/1893)」を避けるために用います。

`--img-zoom=ZOOM`
: 図を PNG 形式で出力する場合に、図の表示倍率を *`ZOOM`* に設定します。数値の末尾に `x` を付加すると値を 4/3 倍します。SVG 形式と PNG 形式で図の大きさを揃えるため、省略時値は `asyco` では `1x`、`mepoco` では `1` です。

`--no-text`
: 実行結果のテキスト出力を表示しません。

`--silent`
: `asyco` では `asy` コマンドの警告メッセージを表示しません。`mepoco` ではテキスト出力の際に付加される図番やフォントの情報を削除します。

他に、最初の引数でだけ有効な次のオプションがあります：`-h`, `--help`（使用法を表示して終了）、`--version`（バージョンを表示して終了）、`-n`（すぐにコマンドを終了）。

### asyco だけで有効なオプション

`--remote`
: ローカルの `asy` コマンドの代わりに Asymptote http server を使います。

`--server=SERVER`
: Asymptote http server を *`SERVER`* に設定します。省略時値は `asymptote.ualberta.ca:10007` です。

### mepoco だけで有効なオプション

`-F`
: MetaPost のコードの前後に `beginfig(0);` と `endfig;` を付加します。

`-U`
: Unicode ラベルのため `upmpost` と `uplatex` を使用します。

### その他のオプション

その他のオプションは `asy` または `mpost` コマンドに渡されます。このため、短いオプションは結合できません（例えば `-KA N` ではなく `-K -A N`）。また、短いオプションとその引数は結合できません（例えば `-AN` ではなく `-A N`）。

## 環境変数

以下の環境変数はログインシェルの初期設定ファイル（例えば `~/.bash_profile`）で設定します。Windows では「Windows の環境変数」で環境変数を設定する必要があります。

### 初期オプション

次の環境変数で `asyco` や `mepoco` の初期オプションを指定できます。

`ASYCO_OPTS`
: `asyco` の初期オプションを指定します。

`MEPOCO_OPTS`
: `mepoco` の初期オプションを指定します。

環境変数から読み込んだ初期オプションは、使用法の表示（`asyco` または `mepoco` の `--help` オプション）の最後の行で確認できます。コマンド行で指定したオプションは、初期オプションよりも優先されます。

<!--
### PNG 形式での表示倍率

以下の環境変数で、`--img-zoom` オプション（PNG 出力での表示倍率）の省略時値を変更できます。

`ASYCO_ZOOM`
: `asyco` の `--img-zoom` オプションの省略時値（`1x`）を変更します。

`MEPOCO_ZOOM`
: `mepoco` の `--img-zoom` オプションの省略時値（`1`）を変更します。
-->

### テキストの背景色

次の環境変数で `asyco` や `mepoco` から出力されるテキストの背景色を設定できます。変数名は `ASYCO_` で始まりますが、`asyco` と `mepoco` で共通に用いられます。

`ASYCO_OUT_BG_COL`
: 標準出力（`asy` や `mpost` のテキスト出力）の背景色を設定します。

`ASYCO_ERR_BG_COL`
: 標準エラー出力（`asy` や `mpost` の警告メッセージやエラーメッセージ）の背景色を設定します。

<!--
### Asymptote http server

次の環境変数で、`--server` オプションの省略時値を変更できます。

`ASYCO_ASY_SERVER`
: `asyco` の `--server` オプションの省略時値（`asymptote.ualberta.ca:10007`）を変更します。
-->

## クラス

クラスを用いた CSS プロパティの設定はマークダウン文書の全体に適用され、後の設定が優先されます。

以下のクラスは `asyco-` で始まりますが、`asyco` と `mepoco` で共通に用いられます。

`asyco-fig`
: 図の領域に設定されます。図が位置揃えされる（`-A N` が指定されていない）場合に有効です。

`asyco-out`
: 標準出力（`asy` や `mpost` のテキスト出力）の領域に設定されます。

`asyco-err`
: 標準エラー出力（`asy` や `mpost` の警告メッセージやエラーメッセージ）の領域に設定されます。

## 使用例

### Asymptote http server

Asymptote http sever を使えば、ローカルの `asy` コマンドを使えなくても、Asymptote で書かれた図をマークダウン文書に埋め込めます。Asymptote http sever を使うには `asyco` の `--remote` オプションを指定します。サーバを `--server` オプションで設定しなければ、`asymptote.ualberta.ca:10007` がサーバに用いられます。

````markdown
```cpp {cmd=env args=[asyco --remote] output=html}
draw(scale(1cm) * unitcircle); // Asymptote code here
```
````

### PNG 画像

図を PNG 画像として出力するには `asyco` のオプションに `-f png` を指定します。コードチャンクの `output` オプションには `html` を設定します（`png` ではありません）。次の例では、図の解像度と表示倍率を変更し（`-render 4 --img-zoom=0.25x`）、画像を `fig.png` に保存します（`-o fig`）。

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

### テキスト出力

コマンドの実行結果がテキストだけの場合も、コードチャンクの `output` オプションには `html` を設定します（`text` ではありません）。

````markdown
```metafont {cmd=env args=[mepoco] output=html}
x + y = 8;
2x + 4y = 26;
show (x, y); % You will get ">> (3,5)".
```
````

`asy` コマンドの出力がテキストだけであれば `asyco` を経由する必要はありません。

````markdown
```cpp {cmd=asy}
write(inverse((0, 0, 1, 1, 2, 4)) * (8, 26)); // You will get "(3,5)".
```
````

### MetaPost での複数の図

MetaPost で複数の図を 1 つのコードチャンクに含める場合、図は `beginfig` の番号順に出力され、テキストはコード中の出現順に出力されます。複数の図の位置揃えについては [ISSUES.md](ISSUES.md) を参照してください。

````markdown
```metafont {cmd=env args=[mepoco] output=html}
u := 2cm;
beginfig(2);
draw fullcircle xscaled 1u yscaled 2u; % figure shown later
label("2", (0, 0));
show "Fig. 2"; % text shown earlier
endfig;
beginfig(1);
draw fullcircle xscaled 2u yscaled 1u; % figure shown earlier
label("1", (0, 0)); % text shown later
show "Fig. 1";
endfig;
```
````

### 環境変数を用いた設定

ログインシェルの初期設定ファイル（例えば `~/.bash_profile`）で環境変数を設定することで `asyco` の設定を行えます。Windows では「Windows の環境変数」で環境変数を設定する必要があります。

```bash
# ~/.bash_profile
export ASYCO_OPTS="--cmd=/Library/TeX/texbin"
export ASYCO_OUT_BG_COL="#EEF"
```

1 行目で `asy` コマンドの場所を設定します。例えばコマンド検索パス（`PATH`）で `/opt/homebrew/bin/asy` が最初に見つかる環境でも `/Library/TeX/texbin/asy` を実行します。2 行目で標準出力の領域の背景色を薄い青色（`#EEF`）に設定します。

### クラスを用いた設定

次の例では、`asyco` が呼び出す `asy` コマンドのバージョンと環境設定を表示する際に、asyco-err クラス（`.asyco-err`）を用いて出力（標準エラー出力）の背景色を透明（`transparent`）に設定します。`asyco` の設定する薄い赤色（`#FDD`）に優先させるため `!important` を用います。

````markdown
<style> .asyco-err { background-color: transparent !important; } </style>

```cpp {cmd=env args=[asyco -version] output=html}
// args=[asyco -version]
```

```cpp {cmd=env args=[asyco -environment] output=html}
// args=[asyco -environment]
```
````

### ファイルの取り込み

MPE の `@import` で Asymptote や MetaPost のファイルを取り込んで実行できます。

```markdown
### Asymptote

@import "rgb.asy" {as=cpp cmd=env args=[asyco] output=html}

### MetaPost

@import "rgb.mp" {as=metafont cmd=env args=[mepoco] output=html}
```

## 関連項目

* `asycat` を使うと、Asymptote または MetaPost のファイルから、コードと図を横に並べたマークダウンを生成できます。詳細は [asycat.md](asycat.md) を参照してください。
* よくある問題と対処法については [ISSUES.md](ISSUES.md) を参照してください。

## 著作権と利用許諾

(c) 2025-2026 aelata

このソフトウェアは MIT No Attribution (MIT-0) で利用許諾されます。ただし、本許諾は拡張子が .html または .js のファイルには適用されないものとします。
[https://opensource.org/license/mit-0](https://opensource.org/license/mit-0)

---
