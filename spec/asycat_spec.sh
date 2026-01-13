CMD="../asycat"

Describe "asycat"
  cat << END > test.asy
unitsize(1cm);
draw(unitcircle);
END
  cat << END > test.mp
beginfig(1);
draw(scale(1cm) * unitcircle);
endfig;
end.
END

  It "shows usage without arguments."
    When run $CMD

    The status should be success
    The error should include "Usage:"
  End

  It "shows usage with '--help' as the first argument."
    When run $CMD --help

    The status should be success
    The error should include "Usage:"
  End

  It "shows version information with '--version' as the first argument."
    When run $CMD --version

    The status should be success
    The error should include "version"
  End

  It "draws figures to the east of code by default."
    When run $CMD test.asy

    The status should be success
    The output should include "asycat-table"
  End

  It "draws figures to the west of code with '-P W'."
    When run $CMD -P W test.asy

    The status should be success
    The output should include "id="
  End

  It "draws figures to the north of code with '-P N'."
    When run $CMD -P N test.asy

    The status should be success
    The output should include "output_first"
  End

  It "adds a page break after each file with '-B'."
    When run $CMD -B test.asy

    The status should be success
    The output should include "break-after:page;"
  End

  It "adds line numbers with '-N'."
    When run $CMD -N test.asy

    The status should be success
    The output should include ".line-numbers"
  End

  It "wraps code with '-W'."
    When run $CMD -W test.asy

    The status should be success
    The output should include \
      "<style> code {white-space: pre-wrap !important;} </style>"
  End

  It "sets the figure width with '--fig-width=WIDTH'."
    When run $CMD --fig-width=50% test.asy

    The status should be success
    The output should include "width:50%;"
  End

  It "sets the level of headings with '--heading=LEVEL'."
    When run $CMD --heading=2 ./test.asy

    The status should be success
    The output should include "## ./test.asy"
  End

  It "strips directories from headings with '--heading=-LEVEL'."
    When run $CMD --heading=-2 ./test.asy

    The status should be success
    The output should include "## test.asy"
  End

  It "turns off headings with '--heading=0'."
    When run $CMD --heading=0 test.asy

    The status should be success
    The output should not include "### test.asy"
  End

  It "sets 'table-layout' to 'fixed' with '--fixed-layout'."
    When run $CMD --fixed-layout test.asy

    The status should be success
    The output should include "table-layout:fixed;"
  End

  It "sets the syntax highlighting language for '*.asy' with '--lang-asy-as=LANG'."
    When run $CMD --lang-asy-as=asy test.asy

    The status should be success
    The output should include '```asy'
  End

  It "sets the syntax highlighting language for '*.mp' with '--lang-mp-as=LANG'."
    When run $CMD --lang-mp-as=mp test.mp

    The status should be success
    The output should include '```mp'
  End

  It "sets default options for asyco using ASYCAT_ASY_OPTS."
    export ASYCAT_ASY_OPTS=--img-zoom=2x
    When run $CMD -f png test.asy

    The status should be success
    The output should include '"--img-zoom=2x", "-f", "png", '
  End

  It "sets default options for mepoco using ASYCAT_MP_OPTS."
    export ASYCAT_MP_OPTS=--img-zoom=2
    When run $CMD -f png test.mp

    The status should be success
    The output should include '"--img-zoom=2", "-f", "png", '
  End

  It "handles multiple files."
    When run $CMD test.asy test.mp

    The status should be success
    The output should include '### test.asy'
    The output should include '### test.mp'
  End

  rm test.asy test.mp
End