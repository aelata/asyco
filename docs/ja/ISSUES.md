# 起こりうる問題と対処法
<style>code { white-space: pre-wrap !important; } </style>

<details open>
<summary>目次</summary>

<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=2 orderedList=true} -->

<!-- code_chunk_output -->

1. [図の縁の欠け](#図の縁の欠け)
2. [Run All Code Chunks での描画の失敗](#run-all-code-chunks-での描画の失敗)
3. [Run Code Chunk の失敗](#run-code-chunk-の失敗)
4. [複数の図での描画の不具合](#複数の図での描画の不具合)
5. [構文強調表示の未対応](#構文強調表示の未対応)
6. [煩雑なコードチャンク入力](#煩雑なコードチャンク入力)
7. [コードと図を横に並べた表示](#コードと図を横に並べた表示)
8. [MetPost での複数の図の位置揃え](#metpost-での複数の図の位置揃え)
9. [asyco の遅さ](#asyco-の遅さ)
10. [asyco をインストールすることの不安](#asyco-をインストールすることの不安)
11. [mepoco での日本語ラベルの不具合](#mepoco-での日本語ラベルの不具合)

<!-- /code_chunk_output -->

</details>

## 図の縁の欠け
文書をブラウザで表示した際などに図の縁が欠けることがあります。欠け方はブラウザによって異なるようです。図の周囲に余白を設定することで欠けを避けられます。

### Asymptote
```cpp {cmd=env args=[asyco] output=html #circ-asy}
draw(scale(2cm, 1cm) * unitcircle);
```

`-M` オプションで余白を設定します。

```cpp {cmd=env args=[asyco -M 1mm] output=html continue=circ-asy}
// args=[asyco -M 1mm]
```

元のコードの最後には次のコードが付加されています。

```cpp
add(bbox(1mm, nullpen));
```

### MetaPost
```metafont {cmd=env args=[mepoco -F] output=html #circ-mp}
u := 3cm;
draw fullcircle xscaled 2u yscaled 1u;
```

`-M` オプションで余白を設定します。コードが `beginfig` と `endfig` を含まず、これらを `-F` オプションで付加する場合にだけ余白を設定できます。

```metafont {cmd=env args=[mepoco -F -M 1mm] output=html continue=circ-mp}
% args=[mepoco -F -M 1mm]
```

元のコードの最後には次のコードが付加されています。

```metafont
bboxmargin := 1mm;
draw bbox currentpicture withpen pencircle scaled 0pt;
```

## Run All Code Chunks での描画の失敗
`Run All Code Chunks` は文書中のコードチャンクを並列に実行し、一部のコードチャンクの描画に失敗することがあります。中間ファイルが競合すると、次のメッセージが表示されます。
```
PostScript error: invalidfileaccess in copypage
```
計算資源が不足して描画に失敗することもあります。描画に失敗したコードチャンクは `Run Code Chunk` で個別に再実行すると描画できます。

## Run Code Chunk の失敗
「[MPE のコードチャンクの hide オプションの不具合](https://github.com/shd101wyy/vscode-markdown-preview-enhanced/issues/1893)」のため、`Run Code Chunk` は `hide` オプションを指定したコードチャンクを実行できません。
````cpp
```asy {cmd=env args=[asyco] output=html hide}
````

この問題を避けるため、`asyco` は `--dothide` オプションを指定すると hide クラス（`.hide`）を定義します。
```html
<style> .hide { display: none; } </style>
```

コードチャンクのオプションで `hide` オプションの代わりに `.hide` を指定します。
````cpp
```asy {cmd=env args=[asyco --dothide] output=html .hide}
````

`Run Code Chunk` は `.hide` を指定したコードチャンクを実行でき、実行するとコードは隠されます。`.hide` は一度定義すると文書の全体で利用できます。MPE が定義する hidden クラス（`.hidden`）を指定したコードチャンクは、実行しなくてもプレビューでコードが隠されますが、ブラウザでは隠されない場合があるようです。

## 複数の図での描画の不具合
文書中の図が 1 つでは正しく描かれるのに、複数になると同じ図が正しく描かれないことがあります。SVG 形式の複数の図を含む文書では、`clipPath` などの SVG 要素の ID が衝突することがあります。これは Asymptote と MetaPost のどちらのコードでも起きる可能性があります。以下に例を示します。

```cpp {cmd=env args=[asyco] output=html id=rgb}
unitsize(2cm);

path[] p = new path[3];
p[0] = shift(0.75, 0) * unitcircle;
p[1] = rotate(120) * p[0];
p[2] = rotate(120) * p[1];
pen[] c = {rgb(1,0,0), rgb(0,1,0), rgb(0,0,1)};

for (int i: sequence(3))
  fill(p[i], c[i]);
for (int i: sequence(3)) {
  picture pic;
  fill(pic, p[i], c[i] + c[(i + 1) % 3]);
  clip(pic, p[(i + 1) % 3]);
  add(pic);
}
picture pic;
fill(pic, p[0], c[0] + c[1] + c[2]);
clip(pic, p[1]);
clip(pic, p[2]);
add(pic);
draw(p);
label("{\sffamily 加法}混色$^1$", (0, -2), fontsize(16pt));
```

```cpp {cmd=env args=[asyco] output=html id=cmyk}
unitsize(2cm);

path[] p = new path[3];
p[0] = rotate(180) * shift(0.75, 0) * unitcircle;
p[1] = rotate(120) * p[0];
p[2] = rotate(120) * p[1];
pen[] c = {cmyk(1,0,0,0), cmyk(0,1,0,0), cmyk(0,0,1,0)};

for (int i: sequence(3))
  fill(p[i], c[i]);
for (int i: sequence(3)) {
  picture pic;
  fill(pic, p[i], c[i] + c[(i + 1) % 3]);
  clip(pic, p[(i + 1) % 3]);
  add(pic);
}
picture pic;
fill(pic, p[0], c[0] + c[1] + c[2]);
clip(pic, p[1]);
clip(pic, p[2]);
add(pic);
draw(p);
label("{\sffamily 減法}混色$^2$", (0, -2), fontsize(16pt));
```

ブラウザや TeX 処理系に依存しますが、上の図は適切に描かれない場合が多いようです。以下に幾つかの対処法を示します。

### --clip-prefix の利用
`clipPath` の ID の衝突を避けるため、`asyco` または `mepoco` の `--clip-prefix` オプションで ID の前に付加する文字列を指定します。
```cpp {cmd=env args=[asyco --clip-prefix=rgb-] output=html continue=rgb}
// args=[asyco --clip-prefix=rgb-]
```

```cpp {cmd=env args=[asyco --clip-prefix=cmyk-] output=html continue=cmyk}
// args=[asyco --clip-prefix=cmyk-]
```

ブラウザによっては、表示と PDF ファイルでの結果が異なり、PDF ファイルでは適切に図が描かれないようです。

### PNG 形式での出力
SVG 形式の代わりに PNG 形式で描画します。

```cpp {cmd=env args=[asyco -f png -render 4 --img-zoom=0.25x] output=html continue=rgb}
// args=[asyco -f png -render 4 --img-zoom=0.25x]
```

```cpp {cmd=env args=[asyco -f png -render 4 --img-zoom=0.25x] output=html continue=cmyk}
// args=[asyco -f png -render 4 --img-zoom=0.25x]
```

PNG 形式と SVG 形式では CMYK の色が異なる場合があります。

### clip の不使用
もし可能であれば `clip` の代わりに `buildcycle` を用いて描画します。

```cpp {cmd=env args=[asyco] output=html}
unitsize(2cm);

path[] p = new path[3];
p[0] = shift(0.75, 0) * unitcircle;
p[1] = rotate(120) * p[0];
p[2] = rotate(120) * p[1];
pen[] c = {rgb(1, 0, 0), rgb(0, 1, 0), rgb(0, 0, 1)};

for (int i: sequence(3))
  fill(p[i], c[i]);
for (int i: sequence(3))
  fill(buildcycle(p[i], p[(i + 1) % 3]), c[i] + c[(i + 1) % 3]);
fill(buildcycle(... p), c[0] + c[1] + c[2]);
draw(p);
label("{\sffamily 加法}混色$^1$", (0, -2), fontsize(16pt));
```

```cpp {cmd=env args=[asyco] output=html}
unitsize(2cm);

path[] p = new path[3];
p[0] = rotate(180) * shift(0.75, 0) * unitcircle;
p[1] = rotate(120) * p[0];
p[2] = rotate(120) * p[1];
pen[] c = {cmyk(1, 0, 0, 0), cmyk(0, 1, 0, 0), cmyk(0, 0, 1, 0)};

for (int i: sequence(3))
  fill(p[i], c[i]);
for (int i: sequence(3))
  fill(buildcycle(p[i], p[(i + 1) % 3]), c[i] + c[(i + 1) % 3]);
fill(buildcycle(... p), c[0] + c[1] + c[2]);
draw(p);
label("{\sffamily 減法}混色$^2$", (0, -2), fontsize(16pt));
```

<!--
## `unknown script name` で停止します
スクリプトは任意の名前に変更できません。スクリプト名を `asyco` から変更する場合、`asyco.` で始まる必要があります。同様に `mepoco` では、`mepoco.` で始まる必要があります。これはスクリプトが名前によって動作を変えるためです。
-->

## 構文強調表示の未対応
VS Code（テキスト）と MPE（プレビュー）は、Asymptote (`asy`) と MetaPost (`mp`) のコードの構文強調表示に対応していません。

Asymptote ではコードチャンクの構文強調表示の言語に `cpp` を設定すると、テキストとプレビューでそれなりに構文強調表示されます。MetaPost では `metafont` を設定すると、プレビューではそれなりに構文強調表示されますが、テキストではされません。`cmd` に値を設定していれば、構文強調表示の言語はコードチャンクの実行に影響しません。

### Asymptote
構文強調表示の言語に `asy` を設定すると、構文強調表示されません。
````asy
```asy {cmd=env args=[asyco] output=html}
unitsize(1cm);
draw(unitcircle);
```
````

構文強調表示の言語に `cpp` を設定すると、テキストとプレビューで構文強調表示されます。
````cpp
```cpp {cmd=env args=[asyco] output=html}
unitsize(1cm);
draw(unitcircle);
```
````

### MetaPost
構文強調表示の言語に `mp` を設定すると、構文強調表示されません。
````mp
```mp {cmd=env args=[mepoco] output=html}
u := 1cm;
beginfig(1);
draw fullcircle scaled 2u;
endfig;
```
````

構文強調表示の言語に `metafont` を設定すると、プレビューでは構文強調表示されますが、テキストではされません。
````metafont
```metafont {cmd=env args=[mepoco] output=html}
u := 1cm;
beginfig(1);
draw fullcircle scaled 2u;
endfig;
```
````

### MPE による書き換え
構文強調表示の言語に `cpp` や `metafont` を指定する代わりに、MPE で `asy` や `mp` を書き換えることもできます。

`.crossnote/Parser.js` の `onWillParseMarkdown` を次のように設定します。

```javascript
  onWillParseMarkdown: async function(markdown) {
    markdown = markdown.replace(/```asy\s/g, "```cpp ");
    markdown = markdown.replace(/```mp\s/g, "```metafont ");
    return markdown;
  },
```

これは、プレビューでは構文強調表示されますが、テキストではされません。とりあえず [PRISM](https://prismjs.com) や MPE が正式に対応するのを待つのがよさそうです。

## 煩雑なコードチャンク入力
VS Code のスニペットを設定することで、煩雑なコードチャンク入力を簡略化できます。

VS Code の `settings.json` に、例えば次のコードを追加します。
```json
    "[markdown]": {
        "editor.quickSuggestions": {
            "other": true,
            "comments": false,
            "strings": false,
        },
        "editor.snippetSuggestions": "top",
        "editor.suggest.showWords": false,
    },
```

マークダウンのスニペット（File > Preferences > Configure Snippets > markdown の `markdown.json`）に、例えば次のコードを追加します。

@import "snippets.json"

必要であればスニペットに選択肢を設定します。

```json
{
    "asy": {
        "prefix": "```asy ",
        "body": [
            "```cpp {cmd=env args=[asyco -f ${1|svg,png|}] output=${2|html,none,text|}}",
            "$0",
            "```",
        ],
        "description": "Asymptote code chunk with choices"
    },
}
```

## コードと図を横に並べた表示
`asycat` を使うと、Asymptote や MetaPost のファイルから、コードと図を横に並べたマークダウンを生成できます。`asycat` は、コードチャンクからは呼び出せず、コマンド行で実行して出力をマークダウン文書に貼り付けます。

**test.asy**
```cpp
draw(scale(1cm) * unitcircle);
```

`asycat test.asy` の出力
````markdown
<!-- This code was generated by 'asycat ...'. -->
<style> .hide { display: none; } </style>

<div class='asycat-block' style='break-inside:avoid-page;'>

### test.asy
<table class='asycat-table' style='display:table;break-inside:avoid-page;'><tr>
<td style='border:none;vertical-align:top;' class='asycat-td-code'>

```cpp {cmd=env args=["asyco", "-n"]  output=none }
draw(scale(1cm) * unitcircle);
```
</td><td style='border:none;vertical-align:top;width:30%;' class='asycat-td-fig'>

```cpp {cmd=env args=["asyco", "-A", "N", "--alt=test"] output=html .hide continue}
// "Run Code Chunk" (Shift + Enter) here.
```
</td></tr></table>
</div>
````

貼り付けたマークダウンで、先（コードの表示部）のコードチャンクのコードや、後（図の表示部）のコードチャンクのオプションなどを適宜編集します。

<style> .hide { display: none; } </style>
<div class='asycat-block' style='break-inside:avoid-page;'>
<table class='asycat-table' style='display:table;break-inside:avoid-page;'><tr>
<td style='border:none;vertical-align:top;' class='asycat-td-code'>

```cpp {cmd=env args=["asyco", "-n"]  output=none }
draw(scale(1cm) * unitcircle);
```
</td><td style='border:none;vertical-align:top;width:30%;' class='asycat-td-fig'>

```cpp {cmd=env args=["asyco", "-A", "N", "--alt=test"] output=html .hide continue}
// "Run Code Chunk" (Shift + Enter) here.
```
</td></tr></table>
</div>

プレビューでは、図の <kbd>▶︎</kbd> ボタンでは描画されますが、コードの <kbd>▶︎</kbd> ボタンでは描画されません。<kbd>ALL</kbd> ボタンでは文書中の全ての図が描画されます。


## MetPost での複数の図の位置揃え
MetaPost では複数の図を 1 つのコードチャンクに含めることができます。
図を水平方向で位置揃えするには、`mepoco` の `-A` オプションで `space-evenly`, `space-around`, `space-between` など CSS (Cascading Style Sheets) の `justify-content` プロパティの値を設定します。

````metafont
```mp {cmd=env args=[mepoco -A "space-around"] output=html}
````

図を垂直方向で位置揃えするには、`mepoco` の `-A` オプションで水平方向の位置揃えの後に、`align-items:` と `start`, `center`, `end` などの値を設定します。

````metafont
```mp {cmd=env args=[mepoco -A "space-evenly;align-items:center"] output=html}
````

```metafont {cmd=env args=[mepoco -A "space-evenly;align-items:center"] output=html}
u := 2cm;
beginfig(1);
draw fullcircle xscaled 2u yscaled 1u;
endfig;
beginfig(2);
draw fullcircle xscaled 1u yscaled 2u;
endfig;
```

文書全体で同じ位置揃えの場合は、asyco-fig クラス（`.asyco-fig`）の `align-items` プロパティを設定することもできます。

```html
<style> .asyco-fig { align-items: center; } </style>
```

## asyco の遅さ
`asyco` の実行時間の大部分は `asy` の実行時間です。実行時間の詳細は [time.md](time.md) を参照してください。

### 実行環境による比較
異なる実行環境での `asyco` の実行時間を以下に示します。Ubuntu は Windows 上の [VirtualBox](https://www.virtualbox.org) で実行しています。Windows と macOS は別の計算機です。TeX 処理系は省略時値の `latex` です。

実行時間 [秒]

| Command | Windows<BR>(TeX Live 2025)| Windows<BR>(SourceForge)| Ubuntu<BR>(TeX Live 2025)| macOS<BR>(MacTeX 2025)
|-|-|-|-|-|
| `asyco ja/rgb.asy` |4.2 |2.7 |1.2 |1.1 |

Windows では、TeX Live の `asy` より [SourceForge](https://sourceforge.net/projects/asymptote/files/) の `asy` のほうが速く、同じ計算機でも Ubuntu ではさらに速いです。

### TeX 処理系による比較
Windows の TeX Live 2025 の `asy` で、TeX 処理系ごとの `asyco` の実行時間を示します。

実行時間 [秒]

|Command |`latex` |`pdflatex` |`xelatex` |`lualatex` |
|-|-|-|-|-|
| `asyco ja/rgb.asy` |4.2 |5.4 |6.6 |8.7 |

`lualatex` では描画できて `latex` では描画できない図もあるため、TeX 処理系は図の内容と実行時間を考慮して選びます。

<!--
TeX 処理系は、`asy` の初期設定ファイル（`~/.asy/config.asy`）で、例えば次のように設定できます。

```cpp
import settings;
settings.tex = "xelatex";
```

`asy` のオプションによる TeX 処理系の設定（例えば `-tex lualatex`）は、初期設定ファイルに優先します。
-->

## asyco をインストールすることの不安
Asymptote http server を使えば `asyco` なしでもマークダウン文書に Asymptote で書かれた図を埋め込めます。例えば次のようにコードチャンクを記述します。

````cpp
```asy {cmd=curl stdin args=[--no-progress-meter --data-binary @- 'asymptote.ualberta.ca:10007?f=svg'] output=html}
draw(scale(1cm) * unitcircle); // Asymptote code here
```
````

`curl` は Windows に標準で含まれ、bash は不要です。コードチャンクの入力は VS Code のスニペット機能を用いれば簡略化できます。

`asyco` は `asy` コマンドが出力する図形ファイルを標準出力に送る bash スクリプトにすぎません。`asy` が標準出力 (`asy -o - ...`) に対応すれば、`asyco` が必要な機会は減るでしょう。

## mepoco での日本語ラベルの不具合
`mepoco` で `-U` オプション（`upmpost` と `uplatex` を使用）を指定しても、PNG 形式では日本語を含むラベルは出力されません。`upmpost` が対応していないようです。また、SVG 形式では日本語を含むラベルは出力されますが書体を選べません。これは、フォントを SVG ファイルに埋め込めないためと考えられます。

```metafont {cmd=env args=[mepoco -U -F] output=html}
label(btex {\sffamily 加法}{\rmfamily 混色}$^1$ etex scaled 2, (0, 0));
```

---
