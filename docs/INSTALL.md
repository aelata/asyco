# Installation
<style>code { white-space: pre-wrap !important; } </style>

`asyco`, `asycat`, and `mepoco` are bash scripts that work on Windows, macOS, and Linux. Installing the scripts becomes easier with the `install.sh` script.

## Requirements
You need an environment where you can:

* run bash scripts using the `env` command and use basic tools such as `sort` and `awk`

    On Windows, you can run the scripts in the [Git for Windows](https://gitforwindows.org) ([MSYS2](https://www.msys2.org)) environment. The Windows command search path (`Path`) must include the directory where `env.exe` is located, such as `C:\opt\PortableGit\usr\bin` or `C:\Program Files\Git\usr\bin`.

* run code chunks of [Markdown Preview Enhanced (MPE)](https://shd101wyy.github.io/markdown-preview-enhanced) in [Visual Studio Code (VS Code)](https://code.visualstudio.com)

    In the VS Code settings, `Markdown-preview-enhanced: Enable Script Execution` must be selected; it is not selected by default.

For `asyco`, you also need an environment where you can do at least one of the following:

* draw figures in SVG (Scalable Vector Graphics) or PNG (Portable Network Graphics) format with the local `asy` command
* connect to the [Asymptote http server](https://github.com/vectorgraphics/asymptote-http-server) such as `asymptote.ualberta.ca:10007`

For `mepoco`, you also need an environment where you can:

* draw figures in SVG or PNG format with the local `mpost` command

## Installation
The installation directory of the scripts, such as `$HOME/bin` or `/usr/local/bin`, must be included in the bash command search path (`PATH`). On Windows, add the installation directory, such as `%USERPROFILE%\bin` or `C:\opt\PortableGit\usr\local\bin`, to the Windows command search path (`Path`), which will then be included in the bash command search path (`PATH`).

Install the scripts using either of the methods below.

### Installation with install.sh
Run `install.sh` with the installation directory as an argument, such as `~/bin`. On Windows, run `install.sh` on the bash (Git Bash) command line.

```bash
$ bash install.sh ~/bin
```

On Windows, running `install.sh` at the command prompt is also possible.
```
C:\...>bash install.sh %USERPROFILE%\bin
```

`install.sh` copies `asyco` and `asycat` to the installation directory and gives execute permission to them. The options below are available.

`-m`
: Create a symbolic link from `asyco` to `mepoco`.

`-n`
: Show the installation commands to run without executing them (dry run).

`-l`
: Create symbolic links from `asyco` and `asycat` in the current directory to the installation directory instead of copying files.

### Installation without install.sh
Copy `asyco` and `asycat` to the installation directory and give execute permission to them. Create a symbolic link from `asyco` to `mepoco` as needed. For example, run the following commands.

```bash
$ cp asyco asycat ~/bin
$ cd ~/bin
$ chmod +x asyco asycat
$ rm -f mepoco
$ ln -s asyco mepoco
```

## Uninstallation
On Windows, remove the installation directory from the Windows command search path (`Path`) as needed.

Uninstall the scripts using either of the methods below.

### Uninstallation with uninstall.sh
Run `uninstall.sh` with the installation directory as an argument, such as `~/bin`.

```bash
$ bash uninstall.sh ~/bin
```

`uninstall.sh` removes `asyco`, `asycat`, and `mepoco` from the installation directory. `uninstall.sh` removes `mepoco` even if the `-m` option is not specified. The option below is available.

`-n`
: Show the uninstallation commands to run without executing them (dry run).

### Uninstallation without uninstall.sh
Remove `asyco`, `asycat`, and `mepoco` from the the installation directory, such as `~/bin`.

```bash
$ cd ~/bin
$ rm -f asyco asycat mepoco
```

---

<div style="break-after:page;"></div>

## Checking requirements
Beforehand, change to the `tests` directory, which contains the files used for checking requirements.

### VS Code, MPE
Verify that a bash script can be executed from the code chunk of MPE in VS Code.

1. Open the Markdown file `test_pre.md` in VS Code.

    **test_pre.md**

    ````markdown
    ``` {cmd=curl args=[--version]}
    Code chunk 1
    ```

    ``` {cmd=env args=[./test.sh]}
    Code chunk 2
    ```
    ````

2. Preview the file with `Open Preview to the Side`.

3. Run "Code chunk 1" with `Run Code Chunk`.

    Verify that the version of `curl` appears. If the version does not appear, confirm that `Markdown-preview-enhanced: Enable Script Execution` is selected in the VS Code settings; it is not selected by default.

    !!! danger
        If `Enable Script Execution` is selected, malicious code in code chunks may be executed. You have to check the contents of code chunks carefully before you run them.

4. Run "Code chunk 2" with `Run Code Chunk`.
    "Code chunk 2" will then execute `./test.sh` using the `env` command.

    **test.sh**

    ```bash
    #!/bin/bash
    echo "OSTYPE: $OSTYPE"
    ```

    Verify that the line starting with `OSTYPE:` appears. If the line does not appear on Windows, confirm that the Windows command search path (`Path`) includes the directory where `env.exe` is located, such as `C:\opt\PortableGit\usr\bin` or `C:\Program Files\Git\usr\bin`.

### Asymptote
Verify the following based on the format of your figures and the Asymptote engine, where appropriate.

#### SVG output with asy
If you will draw figures in SVG format with the local `asy` command, run `asy` as follows. Verify that the output file `test.svg` is in SVG format.

```bash
$ rm -f test.svg
$ asy -noV -f svg test.asy
$ file test.svg
test.svg: SVG Scalable Vector Graphics image
$ rm test.svg
```

#### PNG output with asy
If you will draw figures in PNG format with the local `asy` command, run `asy` as follows. Verify that the output file `test.png` is in PNG format.

```bash
$ rm -f test.png
$ asy -noV -f png test.asy
$ file test.png
test.png: PNG image data, 151 x 150, 8-bit/color RGBA, non-interlaced
$ rm test.png
```

#### SVG output with the Asymptote http server
If you will draw figures in SVG format with the Asymptote http server, run `curl` as follows for example. Verify that the output file `test.svg` is in SVG format.

```bash
$ rm -f test.svg
$ curl --data-binary @test.asy 'asymptote.ualberta.ca:10007?f=svg' -o test.svg
$ file test.svg
test.svg: SVG Scalable Vector Graphics image
$ rm test.svg
```

#### PNG output with the Asymptote http server
If you will draw figures in PNG format with the Asymptote http server, run `curl` as follows for example. Verify that the output file `test.png` is in PNG format.

```bash
$ rm -f test.png
$ curl --data-binary @test.asy 'asymptote.ualberta.ca:10007?f=png' -o test.png
$ file test.png
test.png: PNG image data, 57 x 57, 8-bit/color RGBA, non-interlaced
$ rm test.png
```

### MetaPost
Verify the following based on the format of your figures, where appropriate.

#### SVG output
If you will draw figures in SVG format, run `mpost` as follows and verify that the output file `test.1.svg` is in SVG format.

```bash
$ rm -f test.1.svg
$ mpost -s 'outputformat="svg"' -s 'outputtemplate="test.%c.svg"' test.mp
$ file test.1.svg
test.1.svg: SVG Scalable Vector Graphics image
$ rm test.1.svg test.log
```

#### PNG output
If you will draw figures in PNG format, run `mpost` as follows and verify that the output file `test.1.png` is in PNG format.

```bash
$ rm -f test.1.png
$ mpost -s 'outputformat="png"' -s 'outputtemplate="test.%c.png"' test.mp
$ file test.1.png
test.1.png: PNG image data, 86 x 86, 8-bit/color RGBA, non-interlaced
$ rm test.1.png test.log
```

## Checking operations
Beforehand, change to the `tests` directory, which contains the files used for checking operations.

### VS Code, MPE
Verify that `asyco` or `mepoco` can be executed from the code chunk of MPE in VS Code.

1. Open the Markdown file `test_post.md` in VS Code.

    **test_post.md**

    ````markdown
    ``` {cmd=env args=[asyco --version]}
    Code chunk 1 (for asyco)
    ```

    ``` {cmd=env args=[mepoco --version]}
    Code chunk 2 (for mepoco)
    ```
    ````

2. Preview the file with `Open Preview to the Side`.
3. Run "Code Chunk 1" or "Code Chunk 2 " with `Run Code Chunk`.

    Verify that the version of `asyco` or `mepoco` appears. If the version does not appear, confirm that the bash command search path (`PATH`) includes the installation directory, such as `$HOME\bin`. On Windows, confirm that the Windows command search path (`Path`) includes the installation directory, such as `%USERPROFILE%\bin`.

### asyco
Verify the following based on the format of your figures and the Asymptote engine, where appropriate.

#### SVG output with asy
If you will draw figures in SVG format with the local `asy` command, run `asyco` as follows and verify that the output ends with `</svg></div><br>`.

```bash
$ asyco test.asy
...
</svg>
</div><br>
```

#### PNG output with asy
If you will draw figures in PNG format with the local `asy` command, run `asyco` as follows and verify that the output ends with `"></div><br>`.

```bash
$ asyco -f png test.asy
...
">
</div><br>
```

#### SVG output with the Asymptote http server
If you will draw figures in SVG format with the Asymptote http server, run `asyco` as follows and verify that the output ends with `</svg></div><br>`.

```bash
$ asyco --remote test.asy
...
</svg>
</div><br>
```

#### PNG output with the Asymptote http server
If you will draw figures in PNG format with the Asymptote http server, run `asyco` as follows and verify that the output ends with `"></div><br>`.

```bash
$ asyco --remote -f png test.asy
...
</svg>
</div><br>
```

### mepoco
Verify the following based on the format of your figures, where appropriate.

#### SVG output
If you will draw figures in SVG format, run `mepoco` as follows and verify that the output ends with `</svg></div><br>`.

```bash
$ mepoco test.mp
...
</svg>
</div><br>
```

#### PNG output
If you will draw figures in PNG format, run `mepoco` as follows and verify that the output ends with `"></div><br>`.

```bash
$ mepoco -f png test.mp
...
">
</div><br>
```

### asycat
Run `asycat` as follows and verify that the output ends with `</td></tr></table></div>`.

```bash
$ asycat test.asy test.mp
...
</td></tr></table>
</div>
```

---
