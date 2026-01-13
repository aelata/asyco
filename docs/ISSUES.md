# Possible issues and some fixes
<style>code { white-space: pre-wrap !important; } </style>

<details open>
<summary>Table of contents</summary>

<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=2 orderedList=true} -->

<!-- code_chunk_output -->

1. [Missing figure edges](#missing-figure-edges)
2. [Failure of Run All Code Chunks](#failure-of-run-all-code-chunks)
3. [Failure of Run Code Chunk](#failure-of-run-code-chunk)
4. [Incorrect drawing of multiple figures](#incorrect-drawing-of-multiple-figures)
5. [Unsupported syntax highlighting](#unsupported-syntax-highlighting)
6. [Annoying input of code chunks](#annoying-input-of-code-chunks)
7. [Code and a figure side by side](#code-and-a-figure-side-by-side)
8. [Aligning multiple figures with MetaPost](#aligning-multiple-figures-with-metapost)
9. [Slow execution of asyco](#slow-execution-of-asyco)
10. [Anxiety about installing asyco](#anxiety-about-installing-asyco)

<!-- /code_chunk_output -->

</details>

## Missing figure edges
The edges of a figure may be missing when you view a document in a browser. The extent of the missing appears to depend on your browser. Setting a margin around the figure will prevent the missing edge.

### Asymptote
```cpp {cmd=env args=[asyco] output=html #circ-asy}
draw(scale(2cm, 1cm) * unitcircle);
```

Set a margin with the `-M` option.

```cpp {cmd=env args=[asyco -M 1mm] output=html continue=circ-asy}
// args=[asyco -M 1mm]
```

The following code is appended to the original code.

```cpp
add(bbox(1mm, nullpen));
```

### MetaPost
```metafont {cmd=env args=[mepoco -F] output=html #circ-mp}
u := 3cm;
draw fullcircle xscaled 2u yscaled 1u;
```

Set a margin with the `-M` option. You can set a margin only when the code does not contain `beginfig` and `endfig`, which are added with the `-F` option.

```metafont {cmd=env args=[mepoco -F -M 1mm] output=html continue=circ-mp}
% args=[mepoco -F -M 1mm]
```

The following code is appended to the original code.

```metafont
bboxmargin := 1mm;
draw bbox currentpicture withpen pencircle scaled 0pt;
```

## Failure of Run All Code Chunks
`Run All Code Chunks` runs code chunks in a document in parallel and may fail to draw some of figures. Intermediate files may conflict with the following message.

```
PostScript error: invalidfileaccess in copypage
...
```

Drawing may also fail because of insufficient computing resources. Executing `Run Code Chunk` for each failed code chunk one by one will draw the figure.

## Failure of Run Code Chunk
Because of [the MPE issue of the code chunk hide option ](https://github.com/shd101wyy/vscode-markdown-preview-enhanced/issues/1893), `Run Code Chunk` cannot run the code chunk with the `hide` option.
````cpp
```asy {cmd=env args=[asyco] output=html hide}
````

To avoid the issue, `asyco` defines the hide class (`.hide`) if the `--dothide` option is specified.
```html
<style> .hide { display: none; } </style>
```

Set `.hide` instead of the `hide` option in the code chunk option.
````cpp
```asy {cmd=env args=[asyco --dothide] output=html .hide}
````

`Run Code Chunk` can run the code chunk with `.hide` and will hide the code. The hide class can be used throughout a document once defined. The hidden class (`.hidden`), which is defined by MPE, hides the code in a preview but may not in a browser.

## Incorrect drawing of multiple figures
Multiple figures in a document may be drawn incorrectly, even if each figure is drawn correctly on its own. In a document containing multiple figures in SVG format, the IDs of SVG elements such as `clipPath` may conflict. This can happen with both Asymptote and MetaPost code. The example is shown below.

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
label("{\sffamily Additive} color mixing$^1$", (0, -2), fontsize(16pt));
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
label("{\sffamily Subtractive} color mixing$^2$", (0, -2), fontsize(16pt));
```

Depending on your browser and TeX engine, the figures above are often not drawn correctly. Some workarounds are suggested below.

### Using --clip-prefix
To avoid the ID conflict of `clipPath`, set the prefix string of the ID using the `--clip-prefix` option for `asyco` or `mepoco`.
```cpp {cmd=env args=[asyco --clip-prefix=rgb-] output=html continue=rgb}
// args=[asyco --clip-prefix=rgb-]
```

```cpp {cmd=env args=[asyco --clip-prefix=cmyk-] output=html continue=cmyk}
// args=[asyco --clip-prefix=cmyk-]
```

The figures may be drawn differently between the screen and the PDF file, depending on your browser. The figures in the PDF file may be drawn incorrectly.

### Drawing in PNG format
The figures below are drawn in PNG format instead of SVG format.

```cpp {cmd=env args=[asyco -f png -render 4 --img-zoom=0.25x] output=html continue=rgb}
// args=[asyco -f png -render 4 --img-zoom=0.25x]
```

```cpp {cmd=env args=[asyco -f png -render 4 --img-zoom=0.25x] output=html continue=cmyk}
// args=[asyco -f png -render 4 --img-zoom=0.25x]
```

The CMYK colors may vary between SVG and PNG format.

### Avoiding clip
Draw figures using `buildcycle` instead of `clip` if possible.

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
label("{\sffamily Additive} color mixing$^1$", (0, -2), fontsize(16pt));
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
label("{\sffamily Subtractive} color mixing$^2$", (0, -2), fontsize(16pt));
```

## Unsupported syntax highlighting
VS Code (text pane) and MPE (preview pane) do not provide the syntax highlighting of Asymptote (`asy`) and MetaPost (`mp`) code.

If you set the syntax highlighting language of a code chunk to `cpp` for Asymptote, you will get somehow tolerable syntax highlighting both in a text pane and a preview pane. If you set `metafont` for MetaPost, you will get somehow tolerable syntax highlighting in a preview pane but not in a text pane. The syntax highlighting language does not affect the code chunk execution if you set the value of `cmd`.

### Asymptote
If you set the syntax highlighting language to `asy`, no syntax highlighting is available.
````asy
```asy {cmd=env args=[asyco] output=html}
unitsize(1cm);
draw(unitcircle);
```
````

If you set the syntax highlighting language to `cpp`, syntax highlighting is available both in a text pane and a preview pane.
````cpp
```cpp {cmd=env args=[asyco] output=html}
unitsize(1cm);
draw(unitcircle);
```
````

### MetaPost
If you set the syntax highlighting language to `mp`, no syntax highlighting is available.
````mp
```mp {cmd=env args=[mepoco] output=html}
u := 1cm;
beginfig(1);
draw fullcircle scaled 2u;
endfig;
```
````

If you set the syntax highlighting language to `metafont`, syntax highlighting is available only in a preview pane but not in a text pane.
````metafont
```metafont {cmd=env args=[mepoco] output=html}
u := 1cm;
beginfig(1);
draw fullcircle scaled 2u;
endfig;
```
````

### Rewriting by MPE
Instead of setting the syntax highlighting language to `cpp` or `metafont`, MPE can rewrite `asy` or `mp` to them.

Set `onWillParseMarkdown` in `.crossnote/Parser.js` as follows.

```javascript
  onWillParseMarkdown: async function(markdown) {
    markdown = markdown.replace(/```asy\s/g, "```cpp ");
    markdown = markdown.replace(/```mp\s/g, "```metafont ");
    return markdown;
  },
```

In this case, syntax highlighting is available only in the preview pane but not in the text pane. For now, it seems better to wait for the official support of the syntax highlighting by [PRISM](https://prismjs.com) or MPE.

## Annoying input of code chunks
You can simplify the annoying input of code chunks using the snippet feature of VS Code.

Add the following code to `settings.json` in VS Code, for example.
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

Add the following code to the snippet of Markdown (`markdown.json` of File > Preferences > Configure Snippets > markdown) in VS Code, for example.

@import "snippets.json"

Set choices in the snippet as needed.

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

## Code and a figure side by side
`asycat` can generate Markdown with code and figures side by side from Asymptote or MetaPost files. You cannot run `asycat` from code chunks. Run `asycat` from the command line and paste the output into a Markdown document.

**test.asy**
```cpp
draw(scale(1cm) * unitcircle);
```

The output of `asycat test.asy`:
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

In the pasted Markdown, edit the code in the first code chunk (the code part) or the options in the second code chunk (the figure part) as needed.

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

In a preview pane, clicking the <kbd>▶︎</kbd> button of a figure draws the figure but the <kbd>▶︎</kbd> button of code does not. Clicking the <kbd>ALL</kbd> button draws all figures in a document.

## Aligning multiple figures with MetaPost
You can put multiple figures written in MetaPost in one code chunk.
To align figures horizontally, specify the `-A` option for `mepoco` and the value of the CSS `justify-content` property, such as `space-evenly`, `space-around`, or `space-between`.

````metafont
```mp {cmd=env args=[mepoco -A "space-around"] output=html}
````

To align figures vertically, you must set the horizontal alignment as above and add `;align-items:` and its value, such as `start`, `center`, or `end`.

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

You can also set the `align-items` property of the asyco-fig class (`.asyco-fig`) if the same alignment is used throughout a document.

```html
<style> .asyco-fig { align-items: center; } </style>
```

## Slow execution of asyco
Most of the execution time of `asyco` is spent on `asy`. See [time.md](time.html) for the details of the execution time.

### Execution time by environment
The typical execution times of `asyco` for each execution environment are shown below. Ubuntu runs in [VirtualBox](https://www.virtualbox.org) on Windows. Windows and macOS run on different computers. The TeX engine is `latex` (default).

Execution time [s]

| Command | Windows<BR>(TeX Live 2025)| Windows<BR>(SourceForge)| Ubuntu<BR>(TeX Live 2025)| macOS<BR>(MacTeX 2025)
|-|-|-|-|-|
| `asyco rgb.asy` |4.0 |2.5 |1.1 |1.0 |

On Windows, the `asy` of [SourceForge](https://sourceforge.net/projects/asymptote/files/) is faster than the `asy` of TeX Live. The `asy` on Ubuntu is even faster on the same computer.

### Execution time by TeX engine
With `asy` of TeX Live 2025 on Windows, the typical execution times of `asyco` for each TeX engine are shown below.

Execution time [s]

|Command |`latex` |`pdflatex` |`xelatex` |`lualatex` |
|-|-|-|-|-|
| `asyco rgb.asy` |4.0 |5.3 |5.7 |6.3 |

There are figures which can be drawn with `lualatex` but not with `latex` as the TeX engine. Select the TeX engine considering the content of a figure and the execution time.

<!--
The TeX engine can be set in the initial configuration file of `asy` (`~/.asy/config.asy`) as follows, for example.

```cpp
import settings;
settings.tex = "xelatex";
```

The setting with the option such as `-tex lualatex` overrides the setting in the initial configuration file.
-->

## Anxiety about installing asyco
With the Asymptote http server, you can embed figures written in Asymptote into a Markdown document without `asyco`. An example code chunk is as follows.

````cpp
```asy {cmd=curl stdin args=[--no-progress-meter --data-binary @- 'asymptote.ualberta.ca:10007?f=svg'] output=html}
draw(scale(1cm) * unitcircle); // Asymptote code here
```
````

`curl` is included in Windows by default and bash is not required. You can simplify the input of code chunks using the snippet feature of VS Code.

`asyco` is merely a bash script that write a graphics output file from `asy` to the standard output. You will use `asyco` less often if `asy` supports writing to the standard output (`asy -o - ...`).

---
