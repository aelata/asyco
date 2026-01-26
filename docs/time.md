# Execution time comparison

## Execution environment

Environments for execution time measurements are as follows.

| Environment | OS | CPU | RAM |
|-|-|-|-|
| Windows | Windows 11 Pro 24H2 | Intel Core i9-9900K, 8 Core, 3.6GHz | 64 GB |
| Ubuntu on Windows | Ubuntu 24.04 | amd64, 4 Core | 8 GB |
| macOS | macOS 15.7 | Apple M1 Pro, 8 Core, 3.2 GHz | 16 GB |
| Ubuntu on macOS | Ubuntu 24.04 | arm64, 4 Core | 8 GB |

Ubuntu runs in [VirtualBox](https://www.virtualbox.org) 7.2 on Windows or macOS.

Execution times are measured using the `time` command on the shell command line. The overhead of [Visual Studio Code (VS Code)](https://code.visualstudio.com) and [Markdown Preview Enhanced (MPE)](https://shd101wyy.github.io/markdown-preview-enhanced/) are not included.

Commands are executed in the `docs/color` directory.

## Overhead of asyco

Typical execution times are compared between wrapper scripts (`asyco` and `mepoco`) and wrapped commands (`asy` and `mpost`). Windows ([TeX Live](https://tug.org/texlive/) 2025) and macOS ([MacTeX](https://www.tug.org/mactex/) 2025) run on different computers and the comparison between them is not very meaningful.

Execution time [s]

|Command |Windows |macOS |
|-|-|-|
|`asyco rgb.asy` |4.0 |1.0 |
|`asy -noV -f svg rgb.asy` |3.7 |1.0 |
|`mepoco rgb.mp` |2.0 |0.4 |
|`mpost -s 'outputformat="svg"' -s 'prologues=3' rgb.mp` |0.9 |0.3 |

Most of the execution time of `asyco` is spent on `asy`. On Windows, `mepoco` appears to take additional time for handling intermediate files.

## Execution time by environment

The typical execution times of `asyco rgb.asy` and `mepoco rgb.mp` for each execution environment are shown below. The `asy` of [SourceForge](https://sourceforge.net/projects/asymptote/files) on Windows and the `asy` of [Homebrew](https://formulae.brew.sh/formula/asymptote) on macOS are also included in the comparison. The TeX engine of `asy` is `latex` (default).

Execution time [s]

|Environment|asy|asyco|mpost|mepoco|
|-|-|-|-|-|
|Windows|TeX Live 2025<br>asy 3.04           |4.0 |TeX Live 2025<br>mpost 2.11 |2.0 |
|Windows|SourceForge<br>asy 3.05             |2.5 | | |
|Ubuntu on Windows|TeX Live 2023<br>asy 2.87 |1.0 |TeX Live 2023<br>mpost 2.02 |0.7 |
|Ubuntu on Windows|TeX Live 2025<br>asy 3.04 |1.1 |TeX Live 2025<br>mpost 2.11 |0.6 |
|macOS|MacTeX 2025<br>asy 3.04               |1.0 |MacTeX 2025<br>mpost 2.11   |0.4 |
|macOS|Homebrew<br>asy 3.05                  |0.8 | | |
|Ubuntu on macOS|TeX Live 2023<br>asy 2.87   |0.6 |TeX Live 2023<br>mpost 2.02 |0.4 |
|Ubuntu on macOS|TeX Live 2025<br>asy 3.04   |1.0 |TeX Live 2025<br>mpost 2.11 |0.5 |

On Windows, the `asy` of SourceForge is faster than the `asy` of TeX Live. The `asy` on Ubuntu is even faster. On Ubuntu, the `asy` of [TeX Live 2023 (Ubuntu "texlive-full" package)](https://packages.ubuntu.com/noble/texlive-full) appears slightly faster than the `asy` of [TeX Live 2025 (CTAN package)](https://ctan.org/pkg/asymptote).

## Execution time by TeX engine

The typical execution times of `asyco -tex {latex|pdflatex|xelatex|lualatex} rgb.asy` are shown below.

Execution time [s]

|Environment| asy|`latex` |`pdflatex` |`xelatex` |`lualatex` |
|-|-|-|-|-|-|
|Windows|TeX Live 2025<br>asy 3.04           |4.0 |5.3* |5.7 |6.3* |
|Windows|SourceForge<br>asy 3.05             |2.5 |3.8* |4.2 |4.8* |
|Ubuntu on Windows|TeX Live 2023<br>asy 2.87 |1.0 |1.1  |1.5 |1.9  |
|Ubuntu on Windows|TeX Live 2025<br>asy 3.04 |1.1 |1.4* |1.4 |2.1* |
|macOS|MacTeX 2025<br>asy 3.04               |1.0 |1.2* |1.1 |1.5* |
|macOS|Homebrew<br>asy 3.05                  |0.8 |1.0* |0.9 |1.4* |
|Ubuntu on macOS|TeX Live 2023<br>asy 2.87   |0.6 |0.6  |0.9 |1.2  |
|Ubuntu on macOS|TeX Live 2025<br>asy 3.04   |1.0 |1.0* |1.1 |1.5* |

The execution times are roughly as follows: `latex` $\le$ `pdflatex` $<$ `xelatex` $<$ `lualatex`. The asterisks in the table indicate that `asy` writes raster images using `<IMAGE>` tags even in SVG format.

---
