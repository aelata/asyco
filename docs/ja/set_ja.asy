// set_ja.asy - read packages for Japanese typesetting according to each TeX engine

import settings;

if (settings.tex == "latex" || settings.tex == "pdflatex") {
  usepackage("bxcjkjatype", "whole");
} else if (settings.tex == "xelatex") {
  usepackage("zxjatype");
  usepackage("zxjafont", "haranoaji");
} else if (settings.tex == "lualatex") {
  usepackage("luatexja-fontspec", "match");
}
