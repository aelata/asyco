# インストール

<style>code { white-space: pre-wrap !important; } </style>

`asyco`, `asycat`, `mepoco` は bash スクリプトで Windows, macOS, Linux で使えます。これらのスクリプトのインストールは `install.sh` スクリプトを用いると簡単になります。

## 必要な環境

あらかじめ次の環境が必要です：

* `env` コマンドで bash スクリプトを実行でき、`sort`, `awk` などの基本ツールを使える

    Windows では [Git for Windows](https://gitforwindows.org) ([MSYS2](https://www.msys2.org)) の環境で bash スクリプトを実行できます。`env.exe` のあるディレクトリ（例えば `C:\opt\PortableGit\usr\bin`）が Windows のコマンド検索パス（`Path`）に含まれている必要があります。

* [Visual Studio Code (VS Code)](https://code.visualstudio.com) で [Markdown Preview Enhanced (MPE)](https://shd101wyy.github.io/markdown-preview-enhanced/#/ja-jp/) のコードチャンクを実行できる

    VS Code の設定で `Markdown-preview-enhanced: Enable Script Execution` が選択されている必要があります（初期設定では選択されていません）。

`asyco` では、さらに次のいずれかの環境が必要です：

* ローカルの `asy` コマンドで SVG (Scalable Vector Graphics) または PNG (Portable Network Graphics) 形式の図を出力できる

* [Asymptote http server](https://github.com/vectorgraphics/asymptote-http-server)（例えば `asymptote.ualberta.ca:10007`）に接続できる

`mepoco` では、さらに次の環境が必要です：

* ローカルの `mpost` コマンドで SVG または PNG 形式の図を出力できる

必要な環境の準備については [setup.md](setup.md) を参照してください。

## インストール

スクリプトのインストール先（例えば `$HOME/bin` や `/usr/local/bin`）は、シェルのコマンド検索パス（`PATH`）に含まれている必要があります。Windows では、あらかじめスクリプトのインストール先（例えば `%USERPROFILE%\bin` や `C:\opt\PortableGit\usr\local\bin`）を Windows のコマンド検索パス（`Path`）に加えます。`Path` の値はシェルのコマンド検索パス（`PATH`）に取り込まれます。

以下のどちらかの方法でインストールします。

### install.sh を使う方法

インストール先を引数に指定して `install.sh` を実行します。例えばインストール先が `$HOME/bin` の場合、bash などのシェルのコマンド行で以下を実行します。

```console
$ bash install.sh ~/bin
```

Windows ではコマンドプロンプトで `install.sh` を実行することもできます。

```console
C:\...>bash install.sh %USERPROFILE%\bin
```

`install.sh` はインストール先に `asyco` と `asycat` のファイルをコピーし、実行権限を付与します。以下のオプションが使えます。

`-m`
: インストール先に `asyco` から `mepoco` へのシンボリック・リンクを作成します。

`-n`
: インストールの際に実行されるコマンドを表示するだけで、実際にはインストールしません。

`-l`
: `asyco` と `asycat` のファイルをコピーするのではなく、作業ディレクトリのファイルからインストール先へのシンボリック・リンクを作成します。

### install.sh を使わない方法

`asyco` と `asycat` のファイルをインストール先にコピーし、実行権限を付与します。必要に応じて `asyco` から `mepoco` へのシンボリックリンクを作成します。例えば以下のコマンドを実行します。

```console
$ cp asyco asycat ~/bin
$ cd ~/bin
$ chmod +x asyco asycat
$ rm -f mepoco
$ ln -s asyco mepoco
```

## アンインストール

以下のどちらかの方法でアンインストールします。Windows では、アンインストール後に、必要に応じてスクリプトのインストール先を Windows のコマンド検索パス（`Path`）から削除します。

### uninstall.sh を使う方法

インストール先を引数に指定して `uninstall.sh` を実行します。例えばインストール先が `$HOME/bin` の場合、bash などのシェルのコマンド行で以下を実行します。

```console
$ bash uninstall.sh ~/bin
```

`uninstall.sh` はインストール先から `asyco`, `asycat`, `mepoco` を削除します。`uninstall.sh` は `-m` オプションを指定しなくても `mepoco` を削除します。以下のオプションが使えます。

`-n`
: アンインストールの際に実行されるコマンドを表示するだけで、実際にはアンインストールしません。

### uninstall.sh を使わない方法

インストール先（例えば `~/bin`）から `asyco`, `asycat`, `mepoco` を削除します

```console
$ cd ~/bin
$ rm -f asyco asycat mepoco
```

---

<div style="break-after:page;"></div>

## 必要な環境の確認

あらかじめ、必要な環境の確認のためのファイルがある、`tests` ディレクトリに移動します。

### VS Code, MPE

VS Code で　MPE のコードチャンクから bash スクリプトを実行できることを確認します。

1. VS Code で `test_pre.md` を開きます。
    <br>

    ````markdown
    # test_pre.md

    ``` {cmd=curl args=[--version]}
    Code chunk 1
    ```

    ``` {cmd=env args=[./test.sh]}
    Code chunk 2
    ```
    ````

2. `Open Preview to the Side` でプレビューを表示します。

3. `Run Code Chunk` で Code chunk 1 を実行します。

    `curl` コマンドのバージョンが表示されることを確認します。もし表示されなければ、VS Code の設定で `Markdown-preview-enhanced: Enable Script Execution` が選択されていることを確認します（初期設定では選択されていません）。

    !!! danger 危険
        `Enable Script Execution` が選択された状態では、コードチャンクに含まれる悪意のあるコードが実行される危険性があります。コードチャンクを実行する前に、その内容を十分に確認する必要があります。

4. `Run Code Chunk` で Code chunk 2 を実行します。
    Code chunk 2 は `env` コマンドで次の `./test.sh` スクリプトを実行します。
    <br>

    ```bash
    #!/bin/bash
    echo "OSTYPE: $OSTYPE"
    ```

    `OSTYPE:` で始まる行が表示されることを確認します。もし表示されなければ、Windows では `env.exe` のあるディレクトリ（例えば `C:\opt\PortableGit\usr\bin` や `C:\Program Files\Git\usr\bin`）が Windows のコマンド検索パス（`Path`）に含まれることを確認します。

### Asymptote

Asymptote の処理系と図の出力形式に合わせて以下を確認します。

#### asy で SVG 形式

ローカルの `asy` コマンドで SVG 形式の図を出力する場合、次のように `asy` を実行し、出力されるファイル `test.svg` が SVG 形式であることを確認します。

```console
$ rm -f test.svg
$ asy -noV -f svg test.asy
$ file test.svg
test.svg: SVG Scalable Vector Graphics image
$ rm test.svg
```

#### asy で PNG 形式の図

ローカルの `asy` コマンドで PNG 形式の図を出力する場合、次のように `asy` を実行し、出力されるファイル `test.png` が PNG 形式であることを確認します。

```console
$ rm -f test.png
$ asy -noV -f png test.asy
$ file test.png
test.png: PNG image data, 57 x 57, 8-bit/color RGBA, non-interlaced
$ rm test.png
```

#### Asymptote http server で SVG 形式

Asymptote http server で SVG 形式の図を出力する場合、例えば次のように `curl` を実行し、出力されるファイル `test.svg` が SVG 形式であることを確認します。

```console
$ rm -f test.svg
$ curl --data-binary @test.asy 'asymptote.ualberta.ca:10007?f=svg' -o test.svg
$ file test.svg
test.svg: SVG Scalable Vector Graphics image
$ rm test.svg
```

#### Asymptote http server で PNG 形式

Asymptote http server で PNG 形式の図を出力する場合、例えば次のように `curl` を実行し、出力されるファイル `test.png` が PNG 形式であることを確認します。

```console
$ rm -f test.png
$ curl --data-binary @test.asy 'asymptote.ualberta.ca:10007?f=png' -o test.png
$ file test.png
test.png: PNG image data, 57 x 57, 8-bit/color RGBA, non-interlaced
$ rm test.png
```

### MetaPost

図の出力形式に合わせて以下を確認します。

#### SVG 形式

SVG  形式の図を出力する場合、次のように `mpost` を実行し、出力されるファイル `test.1.svg` が SVG 形式であることを確認します。

```console
$ rm -f test.1.svg
$ mpost -s 'outputformat="svg"' -s 'outputtemplate="test.%c.svg"' test.mp
$ file test.1.svg
test.1.svg: SVG Scalable Vector Graphics image
$ rm test.1.svg test.log
```

#### PNG 形式

PNG 形式の図を出力する場合、次のように `mpost` を実行し、出力されるファイル `test.1.png` が PNG 形式であることを確認します。

```console
$ rm -f test.1.png
$ mpost -s 'outputformat="png"' -s 'outputtemplate="test.%c.png"' test.mp
$ file test.1.png
test.1.png: PNG image data, 86 x 86, 8-bit/color RGBA, non-interlaced
$ rm test.1.png test.log
```

## 動作確認

あらかじめ、動作確認のためのファイルがある、`tests` ディレクトリに移動します。

### VS Code, MPE

VS Code のコードチャンクから `asyco` または `mepoco` を実行できることを確認します。

1. VS Code で `test_post.md` を開きます。
   <br>

    ````markdown
    # test_post.md

    ``` {cmd=env args=[asyco --version]}
    Code chunk 1 (for asyco)
    ```

    ``` {cmd=env args=[mepoco --version]}
    Code chunk 2 (for mepoco)
    ```
    ````

2. `Open Preview to the Side` でプレビューを表示します。
3. `Run Code Chunk` で Code chunk 1 または Code chunk 2 を実行します。

    `asyco` または `mepoco` のバージョンが表示されることを確認します。もし表示されなければ、インストール先（例えば `$HOME/bin`）がシェルのコマンド検索パス（`PATH`）に含まれることを確認します。Windows ではインストール先（例えば `%USERPROFILE%\bin`）が Windows のコマンド検索パス（`Path`）に含まれることを確認します。

### asyco

Asymptote の処理系と図の出力形式に合わせて以下を確認します。

#### asy で SVG 形式

ローカルの `asy` コマンドで SVG 形式の図を出力する場合、次のように `asyco` を実行し、最後に `</svg></div><br>` が出力されることを確認します。

```bash
$ asyco test.asy
...
</svg>
</div><br>
```

#### asy で PNG 形式

ローカルの `asy` コマンドで PNG 形式の図を出力する場合、次のように `asyco` を実行し、最後に `"></div><br>` が出力されることを確認します。

```console
$ asyco -f png test.asy
...
">
</div><br>
```

#### Asymptote http server で SVG 形式

Asymptote http server で SVG 形式の図を出力する場合、次のように `asyco` を実行し、最後に `</svg></div><br>` が出力されることを確認します。

```console
$ asyco --remote test.asy
...
</svg>
</div><br>
```

#### Asymptote http server で PNG 形式

Asymptote http server で PNG 形式の図を出力する場合、次のように `asyco` を実行し、最後に `"></div><br>` が出力されることを確認します。

```console
$ asyco --remote -f png test.asy
...
">
</div><br>
```

### mepoco

図の出力形式に合わせて以下を確認します。

#### SVG 形式

SVG 形式の図を出力する場合、次のように `mepoco` を実行し、最後に `</svg></div><br>` が出力されることを確認します。

```console
$ mepoco test.mp
...
</svg>
</div><br>
```

#### PNG 形式

PNG 形式の図を出力する場合、次のように `mepoco` を実行し、最後に `"></div><br>` が出力されることを確認します。

```console
$ mepoco -f png test.mp
...
">
</div><br>
```

### asycat

次のように `asycat` を実行し、最後に `</td></tr></table></div>` が出力されることを確認します。

```bash
$ asycat test.asy test.mp
...
</td></tr></table>
</div>
```

---
