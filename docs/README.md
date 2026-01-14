# asyco

With `asyco`, you can easily embed figures written in the [Asymptote](https://asymptote.sourceforge.io) language into a Markdown document. Embedding the figures uses the [code chunk](https://shd101wyy.github.io/markdown-preview-enhanced/#/code-chunk) feature of [Markdown Preview Enhanced (MPE)](https://shd101wyy.github.io/markdown-preview-enhanced), an extension for [Visual Studio Code (VS Code)](https://code.visualstudio.com). The Markdown document can be converted to a PDF file through a browser or [pandoc](https://pandoc.org). `asyco` is a bash script that wraps the `asy` command. `asyco` writes a graphics output file from `asy` to the character output (the standard output).

![Preview of the figure in Asymptote on Visual Studio Code](ISSUES.png "Preview of the figure in Asymptote on Visual Studio Code")

## Requirements
`asyco` works on Windows, macOS, and Linux. You need an environment where you can:

* run bash scripts using the `env` command and use basic tools such as `sort` and `awk`
  On Windows, you can run the scripts in the [Git for Windows](https://gitforwindows.org) ([MSYS2](https://www.msys2.org)) environment. The Windows command search path (`Path`) must include the directory where `env.exe` is located, such as `C:\opt\PortableGit\usr\bin` or `C:\Program Files\Git\usr\bin`.
* run code chunks of MPE in VS Code
  In the VS Code settings, `Markdown-preview-enhanced: Enable Script Execution` must be selected; it is not selected by default.

You also need an environment where you can do at least one of the following:

* draw figures in SVG (Scalable Vector Graphics) or PNG (Portable Network Graphics) format with the local `asy` command
* connect to the [Asymptote http server](https://github.com/vectorgraphics/asymptote-http-server) such as `asymptote.ualberta.ca:10007`

## Installation
The installation directory of `asyco`, such as `$HOME/bin` or `/usr/local/bin`, must be included in the bash command search path (`PATH`). On Windows, add the installation directory, such as `%USERPROFILE%\bin` or `C:\opt\PortableGit\usr\local\bin`, to the Windows command search path (`Path`), which will then be included in the bash command search path (`PATH`).

Install `asyco` with the following steps.

1. Copy `asyco` to the installation directory.
2. Give execute permission to `asyco`.

For example, if the installation directory is `$HOME/bin`, run the following commands on the bash command line.

```bash
$ cp asyco ~/bin
$ chmod +x ~/bin/asyco
```

You can also use the `install.sh` script to install `asyco`. See [INSTALL.md](INSTALL.md) for installation details and checking operations.

## Usage
Open a Markdown document in VS Code. Write and run MPE code chunks calling `asyco`.

### Writing a code chunk
In the options of a code chunk:

* Set `cmd` to `env`
* Set `asyco` and its options to `args`
* Set `output` to `html`

In the following example, the option `-M 1mm` is added to `args` to set a 1mm margin around a figure.

````cpp
```asy {cmd=env args=[asyco -M 1mm] output=html}
draw(scale(1cm) * unitcircle); // Asymptote code here
```
````

### Running the code chunk
Preview the document with `Open Preview to the Side` in VS Code. Run the code chunk with `Run Code Chunk` ( <kbd>▶︎</kbd> button) or `Run All Code Chunks` ( <kbd>ALL</kbd> button).

### Creating a PDF file
Choose `Open in Browser` from the shortcut (contextual) menu in the preview. Create a PDF file by printing in the browser. You can also choose `Export > HTML` from the shortcut menu to create an HTML file that can then be converted to a PDF file with the `pandoc` command.

## Examples
### Asymptote http server
With the Asymptote http server, you can embed figures written in Asymptote into a Markdown document without the local `asy` command. Specify the `--remote` option for `asyco`. The default Asymptote http server `asymptote.ualberta.ca:10007` is used if you do not set the server with the `--server` option.

````cpp
```asy {cmd=env args=[asyco --remote] output=html}
draw(scale(1cm) * unitcircle); // Asymptote code here
```
````

### PNG image
Specify the option `-f png` for `asyco` to draw a figure as a PNG image. The value of the code chunk option `output` must be `html`, not `png`. In the following example, image resolution and display magnification are changed with `-render 4 --img-zoom=0.25x` and the image is saved to `fig.png` with `-o fig`.

````cpp
```asy {cmd=env args=[asyco -f png -render 4 --img-zoom=0.25x -o fig] output=html}
draw(scale(1cm) * unitcircle); // Asymptote code here
```
````

### Warning message
With the local `asy` command, warning messages or error messages may appear.

````cpp
```asy {cmd=env args=[asyco] output=html}
size(1cm);
dot("$O$", (0, 0));
```
````

In the above example, the following waning messages appear.

```
: warning [unbounded]: x scaling in picture unbounded
: warning [unbounded]: y scaling in picture unbounded
```

The warning messages can be suppressed with the `--silent` option of `asyco`. The warning messages can also be suppressed individually with the `-nowarn` option of `asy`; use `-nowarn unbounded` for the above example.

With the Asymptote http server, error messages may appear but warning messages will not.

## Options
`-f {svg|png}`
: Set the output format of a figure. You can only use `svg` for SVG format and `png` for PNG format. The default value is `svg`.

`-o PREFIX`
: Set the output directory/file (without extension) to *`PREFIX`*. The output file is saved.

`-A {L|C|R|N}`
: Set the horizontal alignment of a figure. You can use the following values: `L` Left, `C` Center, `R` Right, and `N` No alignment. The default value is `C`.

`-K`
: Keep intermediate files.

`-M MARGIN`
: Add a margin of size *`MARGIN`* around a figure. The default value is `0`, which means no margin.

`--alt=TEXT`
: Set the alternative text of a figure to *`TEXT`*.

`--cd=DIR`
: Set the current directory to *`DIR`*.

`--clip-prefix=PREFIX`
: For the SVG output, add the prefix string *`PREFIX`* before the ID of `clipPath`. The prefix is used to avoid collisions of the ID. The default value is an empty string, which means adding nothing.

`--cmd=PATH`
: Use `asy` located in *`PATH`* for a specific version.

`--dothide`
: Define the hide class (`.hide`), which is used to avoid [the MPE issue of the code chunk hide option](https://github.com/shd101wyy/vscode-markdown-preview-enhanced/issues/1893).

`--img-zoom=ZOOM`
: For the PNG output, set the display magnification of a figure to *`ZOOM`*. Appending `x` to a number multiplies the number by 4/3. The default value is `1x`.

`--no-text`
: Turn off text output.

`--remote`
: Use the Asymptote http server instead of the local `asy` command.

`--server=SERVER`
: Set the Asymptote http server to *`SERVER`*. The default value is `asymptote.ualberta.ca:10007`.

`--silent`
: Suppress warning messages.

Additionally, the following options are available if specified as the first argument: `-h`, `--help` (show usage and exit), `--version` (show version information and exit), and `-n` (exit immediately).

Other options are passed to `asy`. For this behavior, short options cannot be combined (use `-K -A N` instead of `-KA N`, for example). Also, a short option and its argument must be separated by spaces (use `-A N` instead of `-AN`, for example).

## See also
* See [asyco.md](asyco.md) for the details of `asyco`.
* With `mepoco`, you can easily embed figures written in the [MetaPost](https://tug.org/metapost.html) language into a Markdown document. See [asyco.md](asyco.md) for details.
* With `asycat`, you can generate Markdown with code and figures side by side from Asymptote or MetaPost files. See [asycat.md](asycat.md) for details.
* See [INSTALL.md](INSTALL.md) for installation details and checking operations.
* See [ISSUES.md](ISSUES.md) for possible issues and some fixes.

* See [ja/README.md](ja/README.md) for the Japanese documentation.

## Copyright and license
(c) 2025-2026 aelata

This software is licensed under the MIT No attribution (MIT-0) License. However, this License does not apply to any files with the .html or .js extension.
[https://opensource.org/license/mit-0](https://opensource.org/license/mit-0)

---
