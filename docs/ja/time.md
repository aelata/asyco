# 実行時間

## 実行環境

実行時間の測定に用いた環境を示します。

| Environment | OS | CPU | RAM |
|-|-|-|-|
| Windows | Windows 11 Pro 24H2 | Intel Core i9-9900K, 8 Core, 3.6GHz | 64 GB |
| Ubuntu on Windows | Ubuntu 24.04 | amd64, 4 Core | 8 GB |
| macOS | macOS 15.7 | Apple M1 Pro, 8 Core, 3.2 GHz | 16 GB |
| Ubuntu on macOS | Ubuntu 24.04 | arm64, 4 Core | 8 GB |

Ubuntu は、Windows または macOS の [VirtualBox](https://www.virtualbox.org) 7.2 で実行しています。

実行時間はシェルのコマンド行で time コマンドを用いて測定しています。[Visual Studio Code (VS Code)](https://code.visualstudio.com) と [Markdown Preview Enhanced (MPE)](https://shd101wyy.github.io/markdown-preview-enhanced/#/ja-jp/) の実行時間は含みません。

コマンドは `docs/color` ディレクトリで実行しています。

## asyco のオーバーヘッド

ラップしているスクリプト（`asyco` と `mepoco`）と、ラップされているコマンド（`asy` と `mpost`）の実行時間を比較します。Windows ([TeX Live](https://tug.org/texlive/) 2025) と macOS ([MacTeX](https://www.tug.org/mactex/) 2025) は別の計算機のため、これらの比較にはあまり意味がありません。

実行時間 [秒]

|Command |Windows |macOS |
|-|-|-|
|`asyco ja/rgb.asy` |4.2 |1.1 |
|`asy -noV -f svg ja/rgb.asy` |3.9 |1.0 |
|`mepoco -U ja/rgb.mp` |2.1 |0.4 |
|`upmpost -tex=uplatex rgb_.mp` |1.0 |0.3 |

`rgb_.mp` は `mepoco -U -K ja/rgb.mp` で保存した中間ファイルです。

`asyco` の実行時間の大部分は `asy` の実行時間です。Windows の `mepoco` は中間ファイルの扱いに時間を要するようです。

## 実行環境による比較

異なる実行環境での `asyco ja/rgb.asy` と `mepoco -U ja/rgb.mp` の実行時間を示します。Windows では [SourceForge の asy](https://sourceforge.net/projects/asymptote/files)、macOS では [Homebrew の asy](https://formulae.brew.sh/formula/asymptote) も比較に含めます。`asy` のTeX 処理系は省略時値の `latex` です。

実行時間 [秒]

|Environment|asy|asyco|mpost|mepoco|
|-|-|-|-|-|
|Windows|TeX Live 2025<br>asy 3.04           |4.2|TeX Live 2025<br>mpost 2.11 |2.1|
|Windows|SourceForge<br>asy 3.05             |2.7| | |
|Ubuntu on Windows|TeX Live 2023<br>asy 2.87 |1.1|TeX Live 2023<br>mpost 2.02 |0.8|
|Ubuntu on Windows|TeX Live 2025<br>asy 3.04 |1.2|TeX Live 2025<br>mpost 2.11 |0.7|
|macOS|MacTeX 2025<br>asy 3.04               |1.1|MacTeX 2025<br>mpost 2.11   |0.4 |
|macOS|Homebrew<br>asy 3.05                  |0.9| | |
|Ubuntu on macOS|TeX Live 2023<br>asy 2.87   |0.7|TeX Live 2023<br>mpost 2.02 |0.5|
|Ubuntu on macOS|TeX Live 2025<br>asy 3.04   |1.1|TeX Live 2025<br>mpost 2.11 |0.5|

Windows では、TeX Live の `asy` より SourceForge の `asy` のほうが速く、同じ計算機でも Ubuntu on Windows ではさらに速いです。Ubuntu では、[TeX Live 2023（Ubuntu の texlive-full パッケージ）](https://packages.ubuntu.com/noble/texlive-full)の `asy` のほうが [TeX Live 2025（CTAN のパッケージ）](https://ctan.org/pkg/asymptote)よりも少し速いようです。

## asy の TeX 処理系による比較

`asyco -tex {latex|pdflatex|xelatex|lualatex} ja/rgb.asy` の実行時間を示します。

実行時間 [秒]

|Environment| asy|`latex` |`pdflatex` |`xelatex` |`lualatex` |
|-|-|-|-|-|-|
|Windows|TeX Live 2025<br>asy 3.04           |4.2 |5.4* |6.6 |8.7* |
|Windows|SourceForge<br>asy 3.05             |2.7 |3.9* |5.1 |7.1* |
|Ubuntu on Windows|TeX Live 2023<br>asy 2.87 |1.1 |1.3  |2.3 |3.8  |
|Ubuntu on Windows|TeX Live 2025<br>asy 3.04 |1.2 |1.5* |2.3 |3.9* |
|macOS|MacTeX 2025<br>asy 3.04               |1.1 |1.3* |1.6 |2.6* |
|macOS|Homebrew<br>asy 3.05                  |0.9 |1.1* |1.5 |2.4* |
|Ubuntu on macOS|TeX Live 2023<br>asy 2.87   |0.7 |0.7  |1.3 |2.4  |
|Ubuntu on macOS|TeX Live 2025<br>asy 3.04   |1.1 |1.1* |1.6 |2.6* |

実行時間は大まかに `latex` $\le$ `pdflatex` $<$ `xelatex` $<$ `lualatex` です。表中のアスタリスク ( * ) は、SVG 形式でも、ベクタ画像ではなく `<IMAGE>` タグを用いたラスタ画像が出力されることを示します。

---
