# Asymptote の日本語設定
<style>code { white-space: pre-wrap !important; } </style>

Asymptote は初期設定のままでは日本語を含むラベルを扱えません。

```cpp {cmd=env args=[asyco -autoimport "" --no-text] output=html}
label("こんにちは", (0, 0));
```

ここでは、Asymptote で日本語を含むラベルを扱う方法と、初期設定ファイル（`~/.asy/config.asy`）での日本語設定について説明します。

```cpp {cmd=env args=[asyco] output=html}
// 初期設定ファイルで日本語設定
label("こんにちは", (0, 0));
```

## 日本語を扱うためのパッケージの読み込み
Asymptote で日本語を含むラベルを扱うには、TeX 処理系（`settings.tex`）に合わせて日本語設定のパッケージを読み込む必要があります。TeX 処理系によって日本語の表示結果は微妙に異なります。

### LaTeX と pdfLaTeX
TeX 処理系が `latex` または `pdflatex` では [BXcjkjatype](https://github.com/zr-tex8r/BXcjkjatype) パッケージを用います。

```cpp {cmd=env args=[asyco -autoimport=""] output=html}
import settings;
settings.tex = "latex"; // "pdflatex"
usepackage("bxcjkjatype", "whole");

usepackage("amsmath");
write(settings.tex);
add(pack(align=20S,
  Label("{\sffamily ディリクレの関数}は{\bf 次式}で表される。"),
  Label("$f(x)=\begin{cases} 1 & (x\,\textrm{は}\textsf{有理数})\\ 0 & (x\,は\textbf{無理数}) \end{cases}$")));
```

数式中では一部の文字が化けます。

### XeLaTeX
TeX 処理系が `xelatex` では [ZXjatype](https://github.com/zr-tex8r/ZXjatype) パッケージを用います。さらに [ZXjafont](https://github.com/zr-tex8r/ZXjafont) パッケージでフォントを設定します。
```cpp {cmd=env args=[asyco -autoimport=""] output=html}
import settings;
settings.tex = "xelatex";
usepackage("zxjatype");
usepackage("zxjafont", "haranoaji");

usepackage("amsmath");
write(settings.tex);
add(pack(align=20S,
  Label("{\sffamily ディリクレの関数}は{\bf 次式}で表される。"),
  Label("$f(x)=\begin{cases} 1 & (x\,\textrm{は}\textsf{有理数})\\ 0 & (x\,は\textbf{無理数}) \end{cases}$")));
```

数式中では一部の文字が欠けます。

### LuaLaTeX
TeX 処理系が `lualatex` では [LuaTeX-ja](https://github.com/luatexja/luatexja) パッケージを用います。

```cpp {cmd=env args=[asyco -autoimport=""] output=html}
import settings;
settings.tex = "lualatex";
usepackage("luatexja-fontspec", "match");

usepackage("amsmath");
write(settings.tex);
add(pack(align=20S,
  Label("{\sffamily ディリクレの関数}は{\bf 次式}で表される。"),
  Label("$f(x)=\begin{cases} 1 & (x\,\textrm{は}\textsf{有理数})\\ 0 & (x\,は\textbf{無理数}) \end{cases}$")));
```

数式中でも文字化けなどはありません。

## 初期設定ファイルでの設定
`asy` コマンドの初期設定ファイル（`~/.asy/config.asy`）で、TeX 処理系の設定と、TeX 処理系に合わせた日本語設定を行います。

### TeX 処理系の設定
TeX 処理系（`settings.tex`）は初期設定ファイル（`~/.asy/config.asy`）で、例えば次のように設定できます。
```cpp
// config.asy
import settings;
setttings.tex = "xelatex"; // "latex", "pdflatex", "xelatex", "lualatex"
```

`asy` の `-tex` オプションによる TeX 処理系の設定は、初期設定ファイルでの設定よりも優先されます。Asymptote のコード中での `setttings.tex` による設定は、さらに優先されます。

### 日本語設定
TeX 処理系に合わせて日本語設定のパッケージを読み込む `set_ja.asy` を `~/.asy` の下に置きます。

@import "set_ja.asy" {as=cpp}

`set_ja.asy` は Asymptote のコード中で `import set_ja;` で読み込むこともできますが、初期設定ファイルで自動読み込みファイル（`settings.autoimport`）に設定するとコードが簡潔になります。

次の例では、TeX 処理系が `xelatex` に設定され、自動読み込みファイルの `set_ja.asy` では `xelatex` に合わせたパッケージが読み込まれます。
```cpp
// config.asy
import settings;
setttings.tex = "xelatex"; // "latex", "pdflatex", "xelatex", "lualatex"
setttings.autoimport = "set_ja";
```

もし `asy` のオプション `-tex lualatex` で TeX 処理系を設定すると、初期設定ファイルでの設定よりも優先され、自動読み込みファイルの `set_ja.asy` では `lualatex` に合わせたパッケージが読み込まれます。

`asy` の `-autoimport` オプションによる自動読み込みファイルの設定は、初期設定ファイルでの設定よりも優先されます。例えば `-autoimport ""` で `set_ja.asy` を読み込まなくなります。

---
