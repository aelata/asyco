# asyco and mepoco

<style>code { white-space: pre-wrap !important; } </style>

With `asyco`, you can easily embed figures written in the [Asymptote](https://asymptote.sourceforge.io) language into a Markdown document. Embedding the figures uses the [code chunk](https://shd101wyy.github.io/markdown-preview-enhanced/#/code-chunk) feature of [Markdown Preview Enhanced (MPE)](https://shd101wyy.github.io/markdown-preview-enhanced), an extension for [Visual Studio Code (VS Code)](https://code.visualstudio.com). Use `mepoco` for figures written in the [MetaPost](https://tug.org/metapost.html) language.

![Preview of the figure in Asymptote on Visual Studio Code](ISSUES.png "Preview of the figure in Asymptote on Visual Studio Code"){width=60% style="display:block;margin:auto;"}

The Markdown document can be converted to a PDF file through a browser or [pandoc](https://pandoc.org). `asyco` and `mepoco` are wrapper bash scripts that write a graphics output file from `asy` or `mpost` to the character output (the standard output).

![Flow diagram of asyco](asyco_flow.png "Flow diagram of asyco"){width=53% style="display:block;margin:auto;"}

## Requirements and installation

See [INSTALL.md](INSTALL.md).

## Usage

Open a Markdown document in VS Code. Write and run MPE code chunks calling `asyco` or `mepoco`.

### Writing a code chunk

In the options of a code chunk:

* Set the syntax highlighting language to `cpp` (which has syntax similar to Asymptote) or to `metafont` (which has syntax similar to MetaPost) as needed
* Set `cmd` to `env`
* Set the first argument of `args` to `asyco` or `mepoco` and add their options, if any, to `args`
* Set `output` to `html`

In the following example, the option `-M 1mm` for `asyco` is added to `args` to set a 1mm margin around a figure.

````markdown
```cpp {cmd=env args=[asyco -M 1mm] output=html}
draw(scale(1cm) * unitcircle); // Asymptote code here
```
````

Replace `asyco` in `args` with `mepoco` for figures in MetaPost. Set the syntax highlighting language to `metafont` as needed. In the following example, the `-F` option for `mepoco` is also specified to add `beginfig(0);` and `endfig;` before and after MetaPost code.

````markdown
```metafont {cmd=env args=[mepoco -F -M 1mm] output=html}
draw fullcircle scaled 3cm; % MetaPost code here
```
````

### Running the code chunk

Preview the document with `Open Preview to the Side` in VS Code. Run the code chunk with `Run Code Chunk` ( <kbd>▶︎</kbd> button) or `Run All Code Chunks` ( <kbd>ALL</kbd> button).

### Creating a PDF file

Choose `Open in Browser` from the shortcut (contextual) menu in the preview. Create a PDF file by printing in the browser. You can also choose `Export > HTML` from the shortcut menu to create an HTML file that can then be converted to a PDF file with the `pandoc` command.

## Code chunk options

The first line of an MPE code chunk has the following format.

````markdown
```lang {cmd=command args=[arg1 arg2 ...] output=format ...}
````

For example, it will be as follows.

````markdown
```cpp {cmd=env args=[asyco -f png --render 4] output=html}
````

You can also set `args` as follows.

````markdown
```cpp {cmd=env args=["asyco", "-f", "png", "--render", "4"] output=html}
````

The main options of a code chunk are described below:

`lang`
: Set the language for syntax highlighting. The syntax highlighting of Asymptote (`asy`) and MetaPost (`mp`) is not available in VS Code and MPE. However, you can set the language that has similar syntax. Use `cpp` for Asymptote and `metafont` for MetaPost. See [ISSUES.md](ISSUES.md) for details.

`cmd`
: Set the command to be executed. Set the `env` command. Setting `env` is recommended considering document compatibility with Windows, even if `asyco` or `mepoco` can be used on macOS or Linux.

`args`
: Set the arguments of the command. Set `asyco` or `mepoco` as the first argument and add their options if any.

`output`
: Set the format how MPE renders the command output. Use `html` in most cases. Use `none` to hide the output. Use `text` to check the output. The default value is `text`.

`hide`
: Hide the code chunk itself and only display the output from the command.

`id`
: Set the identifier of the code chunk, which is referenced from other code chunks. For example, set an identifier such as `id=Fig-1`, which can be abbreviated as `#Fig-1`.

`continue`
: Merge the code of another (the referenced) code chunk with the code of the referencing code chunk; then execute the merged code with the options of the referencing code chunk. For example, `continue=Fig-1` references the code chunk whose identifier is `Fig-1`, and simple `continue` references the last code chunk.

## Options

### Common options for asyco and mepoco

`-f {svg|png}`
: Set the output format of a figure. You can only use `svg` for SVG format and `png` for PNG format. The default value is `svg`.

`-o PREFIX`
: Set the output directory/file (without extension) to *`PREFIX`*. `mepoco` does not allow you to include directories in *`PREFIX`*. The output file is saved.

`-A {L|C|R|N}`
: Set the horizontal alignment of a figure. You can use the following values: `L` Left, `C` Center, `R` Right, and `N` No alignment. You can also use the value of the `justify-content` property in CSS (Cascading Style Sheets). The default value is `C`.

`-K`
: Keep intermediate files.

`-M MARGIN`
: Add a margin of size *`MARGIN`* around a figure. With `mepoco`, you can add a margin only when the code does not contain `beginfig` and `endfig`, which are added with the `-F` option. The default value is `0`, which means no margin.

`--alt=TEXT`
: Set the alternative text of a figure to *`TEXT`*.

`--cd=DIR`
: Set the current directory to *`DIR`*.

`--clip-prefix=PREFIX`
: For the SVG output, add the prefix string *`PREFIX`* before the ID of `clipPath`. The prefix is used to avoid collisions of the ID. The default value is an empty string, which means adding nothing.

`--cmd=PATH`
: Use `asy` or `mpost` located in *`PATH`* for a specific version.

`--dothide`
: Define the hide class (`.hide`), which is used to avoid [the MPE issue of the code chunk hide option](https://github.com/shd101wyy/vscode-markdown-preview-enhanced/issues/1893).

`--img-zoom=ZOOM`
: For the PNG output, set the display magnification of a figure to *`ZOOM`*. Appending `x` to a number multiplies the number by 4/3. The default value is `1x` for `asyco` and `1` for `mepoco` to align the size of figures in SVG format and in PNG format.

`--no-text`
: Turn off text output.

`--silent`
: Suppress warning messages for `asyco`. Remove figure numbers and font information from text output for `mepoco`.

Additionally, the following options are available if specified as the first argument: `-h`, `--help` (show usage and exit), `--version` (show version information and exit), and `-n` (exit immediately).

### Options only for asyco

`--remote`
: Use the Asymptote http server instead of the local `asy` command.

`--server=SERVER`
: Set the Asymptote http server to *`SERVER`*. The default value is `asymptote.ualberta.ca:10007`.

### Options only for mepoco

`-F`
: Add `beginfig(0);` and `endfig;` before and after MetaPost code.

`-U`
: Use `upmpost` and `uplatex` for Unicode labels.

### Other options

Other options are passed to `asy` or `mpost`. For this behavior, short options cannot be combined (use `-K -A N` instead of `-KA N`, for example). Also, a short option and its argument must be separated by spaces (use `-A N` instead of `-AN`, for example).

## Environment variables

You can set the environment variables below in the initialization file of your login shell, such as `~/.bash_profile`. On Windows, you must set the variables in the Windows environment variables.

### Default options

You can set default options for `asyco` or `mepoco` with the following variables.

`ASYCO_OPTS`
: Set default options for `asyco`.

`MEPOCO_OPTS`
: Set default options for `mepoco`.

Default options can be confirmed at the last line of the usage (by the `--help` option of `asyco` or `mepoco`). Command line options will override the default options.

### Background color of text

You can set the background color of text output from `asyco` or `mepoco` with the following variables. The variables are used in common for `asyco` and `mepoco`, even if the variable names start with `ASYCO_`.

`ASYCO_OUT_BG_COL`
: Set the background color of the standard output (text output from `asy` or `mpost`).

`ASYCO_ERR_BG_COL`
: Set the background color of the standard error (warning messages or error messages from `asy` or `mpost`).

## Classes

Settings of CSS properties by classes are effective throughout a document. Later settings override earlier ones.

The classes below are used in common for `asyco` and `mepoco`, even if the class names start with `asyco-`.

`asyco-fig`
: Used for the figure output. Valid only when the figure is aligned (`-A N` is not specified).

`asyco-out`
: Used for the standard output (text output from `asy` or `mpost`).

`asyco-err`
: Used for the standard error (warning messages and error messages from `asy` or `mpost`).

## Examples

### Asymptote http server

With the Asymptote http server, you can embed figures written in Asymptote into a Markdown document without the local `asy` command. Specify the `--remote` option for `asyco`. The default Asymptote http server `asymptote.ualberta.ca:10007` is used if you do not set the server with the `--server` option.

````markdown
```cpp {cmd=env args=[asyco --remote] output=html}
draw(scale(1cm) * unitcircle); // Asymptote code here
```
````

### PNG image

Specify the option `-f png` for `asyco` to draw a figure as a PNG image. The value of the code chunk option `output` must be `html`, not `png`. In the following example, image resolution and display magnification are changed with `-render 4 --img-zoom=0.25x` and the image is saved to `fig.png` with `-o fig`.

````markdown
```cpp {cmd=env args=[asyco -f png -render 4 --img-zoom=0.25x -o fig] output=html}
draw(scale(1cm) * unitcircle); // Asymptote code here
```
````

### File importing

You can include and execute files of Asymptote or MetaPost with `@import` of MPE.

```markdown
### Asymptote

@import "rgb.asy" {as=cpp cmd=env args=[asyco] output=html}

### MetaPost

@import "rgb.mp" {as=metafont cmd=env args=[mepoco] output=html}
```

### Warning message

With the local `asy` command, warning messages or error messages may appear.

````markdown
```cpp {cmd=env args=[asyco] output=html}
size(1cm);
dot("$O$", (0, 0));
```
````

In the above example, the following waning messages appear.

```console
: warning [unbounded]: x scaling in picture unbounded
: warning [unbounded]: y scaling in picture unbounded
```

The warning messages can be suppressed with the `--silent` option of `asyco`. The warning messages can also be suppressed individually with the `-nowarn` option of `asy`; use `-nowarn unbounded` for the above example.

With the Asymptote http server, error messages may appear but warning messages will not.

### Text output

Even if the output of the command is text only, the value of the code chunk option `output` must be `html`, not `text`.

````markdown
```metafont {cmd=env args=[mepoco] output=html}
x + y = 8;
2x + 4y = 26;
show (x, y); % You will get ">> (3,5)".
```
````

If the output from `asy` is text only, `asyco` is not required.

````markdown
```cpp {cmd=asy}
write(inverse((0, 0, 1, 1, 2, 4)) * (8, 26)); // You will get "(3,5)".
```
````

### Multiple figures in MetaPost

If you put multiple figures written in MetaPost in one code chunk, the figure output is in the order of the argument of `beginfig`. However, the text output is in the order of the appearance in the code. See [ISSUES](ISSUES.md) for the alignment of multiple figures.

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

### Settings by environment variables

You can configure `asyco` by setting environment variables in the initialization file of your login shell, such as `~/.bash_profile`. On Windows, you must set the variables in the Windows environment variables.

```bash
# ~/.bash_profile
export ASYCO_OPTS="--cmd /Library/TeX/texbin/"
export ASYCO_OUT_BG_COL="#EEF"
```

The first line sets the path of `asy`. For example, `/Library/TeX/texbin/asy` is used even if `/opt/homebrew/bin/asy` is found first in the command search path (`PATH`). The second line sets the background color of the text output to light blue (`#EEF`).

### Settings by classes

In the following example, the background color of the output (the standard error) is set to `transparent` using the asyco-err class (`.asyco-err`) when showing the version and environment settings of `asy`, which is called from `asyco`. To override the light red (`#FDD`) setting by `asyco`, `!important` is used.

````markdown
<style> .asyco-err { background-color: transparent !important; } </style>

```cpp {cmd=env args=[asyco -version] output=html}
// args=[asyco -version]
```

```cpp {cmd=env args=[asyco -environment] output=html}
// args=[asyco -environment]
```
````

## See also

* With `asycat`, you can generate Markdown with code and figures side by side from Asymptote or MetaPost files. See [asycat.md](asycat.md) for details.
* See [ISSUES.md](ISSUES.md) for frequent issues and some fixes.

## Copyright and license

(c) 2025-2026 aelata

This software is licensed under the MIT No attribution (MIT-0) License. However, this License does not apply to any files with the .html or .js extension.
[https://opensource.org/license/mit-0](https://opensource.org/license/mit-0)

---
