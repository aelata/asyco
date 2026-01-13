CMD="../asyco"

Describe "asyco"
  cat << END > test.asy
filldraw(scale(2cm, 1cm) * unitcircle, yellow);
END

  It "shows usage without arguments."
    When run $CMD

    The status should be success
    The error should include "Usage: asyco"
  End

  It "shows usage with '--help' as the first argument."
    When run $CMD --help

    The status should be success
    The error should include "Usage: asyco"
  End

  It "shows version information with '--version' as the first argument."
    When run $CMD --version

    The status should be success
    The error should include "version"
  End

  It "does nothing and exits immediately with '-n' as the first argument."
    When run $CMD -n

    The status should be success
    The length of output should equal 0
    The length of error should equal 0
  End

  It "draws a figure in svg format by default."
    When run $CMD test.asy

    The status should be success
    The output should include "</svg>"
  End

  It "draws a figure in png format with '-f png'."
    When run $CMD -f png test.asy

    The status should be success
    The output should include '<img alt='
    The output should include 'src="data:image/png;charset=utf-8;base64,'
  End

  It "keeps intermediate files with '-K'."
    When run $CMD -K test.asy

    The status should be success
    The output should include "</svg>"
    The contents of file test.svg should include "</svg>"
    The file test.cout should be empty file
    The file test.cerr should be empty file

    rm test.svg test.cout test.cerr
  End

  It "can set the prefix of an output file and keep the file, such as '-o foo'."
    When run $CMD -o foo test.asy

    The status should be success
    The output should include "</svg>"
    The contents of file foo.svg should include "</svg>"

    rm foo.svg
  End

  It "can set the output directory and keep the output file, such as '-o /tmp'."
    ODIR=/tmp # already existing directory

    When run $CMD -o $ODIR test.asy

    The status should be success
    The output should include "</svg>"
    The contents of file $ODIR/test.svg should include "</svg>"

    rm $ODIR/test.svg
  End

  It "can set the prefix including directories and keep the file, such as '-o /tmp/foo'."
    ODIR=/tmp # already existing directory

    When run $CMD -o $ODIR/foo test.asy

    The status should be success
    The output should include "</svg>"
    The contents of file $ODIR/foo.svg should include "</svg>"

    rm $ODIR/foo.svg
  End

  It "sets the current directory with '--cd <dir>'."
    ODIR=tmp_dir
    mkdir $ODIR
    cp test.asy $ODIR

    When run $CMD --cd $ODIR test.asy

    The status should be success
    The output should include "</svg>"

    rm -rf $ODIR
  End

  It "draws a center aligned figure by default."
    When run $CMD test.asy

    The status should be success
    The output should include "justify-content:center;"
  End

  It "draws a left aligned figure with '-A L'."
    When run $CMD -A L test.asy

    The status should be success
    The output should include "justify-content:left;"
  End

  It "draws an unaligned figure with '-A N'."
    When run $CMD -A N test.asy

    The status should be success
    The output should not include "justify-content:"
  End

  It "sets alternative text of an output image with '-f png --alt=*'."
    When run $CMD -f png --alt="Figure of circle" test.asy

    The status should be success
    The output should include "<img alt='Figure of circle'"
  End

  It "sets display magnification to 4/3 (1x) by default with '-f png'."
    When run $CMD -f png test.asy

    The status should be success
    The output should include "<img alt='' style='zoom:1.333333;' src="
  End

  It "sets display magnification to 1 with '-f png --img-zoom=1'."
    When run $CMD -f png --img-zoom=1 test.asy

    The status should be success
    The output should include "<img alt='' style='zoom:1;' src="
  End

  It "sets display magnification to 1/3 with '-f png --img-zoom=0.25x'."
    When run $CMD -f png --img-zoom=0.25x test.asy

    The status should be success
    The output should include "<img alt='' style='zoom:0.333333;' src="
  End

  rm test.asy
End

Describe "asyco"
  cat << END > test.asy
write("Hello");
END

  It "can output text."
    When run $CMD test.asy

    The status should be success
    The output should include "<pre class='asyco-out'"
    The output should include "Hello"
    The lines of output should equal 4
  End

  It "turns off text output with '--no-text'."
    When run $CMD --no-text test.asy

    The status should be success
    The output should not include "<pre class='asyco-out'"
    The output should not include "Hello"
    The lines of output should equal 1
  End

  It "does not define '.hide' by default."
    When run $CMD test.asy

    The status should be success
    The output should not include ".hide"
  End

  It "defines '.hide' with '--dothide'."
    When run $CMD --dothide test.asy

    The status should be success
    The output should include "<style> .hide { display: none; } </style>"
  End

  rm test.asy
End

Describe "asyco"
  cat << END > test.asy
size(1cm);
dot((0, 0));
END

  It "may draw a figure with warnings."
    When run $CMD test.asy

    The status should be success
    The output should include "asyco-err"
    The output should include "asyco-fig"
  End

  It "suppresses warnings with '--silent'."
    When run $CMD --silent test.asy

    The status should be success
    The output should not include "asyco-err"
    The output should include "asyco-fig"
  End

  rm test.asy
End

Describe "asyco"
  cat << END > test
unitsize(1cm);
draw(unitcircle);
END

  It "accepts a filename without extensions."
    When run $CMD test

    The status should be success
    The output should include "</svg>"
  End

  rm test
End

Describe "asyco"
  cat << END > "test 1.asy"
unitsize(1cm);
draw(unitcircle);
END

  It "accepts a filename containing spaces."
    When run $CMD "test 1.asy"

    The status should be success
    The output should include "</svg>"
  End

  rm "test 1.asy"
End

Describe "asyco"
  cat << END > test1.asy
dot((0, 0));
END
  cat << END > test2.asy
dot((0, 1));
END

  It "does not accept multiple files."
    When run $CMD test1.asy test2.asy

    The status should be failure
    The error should include "unable to handle multiple files"
  End

  rm test1.asy test2.asy
End

Describe "asyco"
  cat << END > test.asy
dot((0, 0))
END

  It "stops with error message when error."
    When run $CMD test.asy

    The status should be success
    The output should include "asyco-err"
  End

  rm test.asy
End
