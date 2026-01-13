CMD="../mepoco"

Describe "mepoco"
  cat << END > test.mp
beginfig(1);
draw fullcircle scaled 3cm;
endfig;
end.
END

  It "shows a help message without arguments."
    When run $CMD

    The status should be success
    The error should include "Usage: mepoco"
  End

  It "shows a help message with '--help' as the first argument."
    When run $CMD --help

    The status should be success
    The error should include "Usage: mepoco"
  End

  It "shows a version with '--version' as the first argument."
    When run $CMD --version

    The status should be success
    The error should include "version"
  End

  It "draws a figure in svg format by default."
    When run $CMD test.mp

    The status should be success
    The output should include "</svg>"
  End

  It "draws a figure in png format with '-f png'."
    When run $CMD -f png test.mp

    The status should be success
    The output should include '<img alt='
    The output should include 'src="data:image/png;charset=utf-8;base64,'
  End

  It "sets display magnification to 1 by default with '-f png'."
    When run $CMD -f png test.mp

    The status should be success
    The output should include "<img alt='' style='zoom:1;' src="
  End

  It "sets display magnification to 0.25 with '-f png --img-zoom=0.25'."
    When run $CMD -f png --img-zoom=0.25 test.mp

    The status should be success
    The output should include "<img alt='' style='zoom:0.25;' src="
  End

  It "keeps intermediate files with '-K'."
    When run $CMD -K test.mp

    The status should be success
    The output should include "</svg>"
    The file test_.mp should not be empty file
    The contents of file test.1.svg should include "</svg>"
    The file test_.log should not be empty file

    rm test_.{mp,log,cout,cerr} test.1.svg
  End

  It "can set the prefix of an output file and keeps the file, such as '-o foo'."
    When run $CMD -o foo test.mp

    The status should be success
    The output should include "</svg>"
    The file foo.mp should not be empty file
    The contents of file foo.1.svg should include "</svg>"
    The file foo.log should not be empty file

    rm -f foo.{mp,log,cout,cerr} foo.1.svg
  End

  It "cannot set the output directory, such as -o /tmp."
    ODIR=/tmp # already existing directory

    When run $CMD -o $ODIR test.mp

    The status should be failure
    The error should include "cannot handle directory"
  End

  It "cannot set the prefix including directories, such as '-o /tmp/foo'."
    ODIR=/tmp # already existing directory

    When run $CMD -o $ODIR/foo test.mp

    The status should be failure
    The error should include "cannot handle directory"
  End

  It "sets the current directory with '--cd <dir>'."
    ODIR=tmp_dir
    mkdir $ODIR
    cp test.mp $ODIR

    When run $CMD --cd $ODIR test.mp

    The status should be success
    The output should include "</svg>"

    rm -rf $ODIR
  End

  It "draws a center aligned figure by default."
    When run $CMD test.mp

    The status should be success
    The output should include "justify-content:center;"
  End

  It "draws a left aligned figure with '-A L'."
    When run $CMD -A L test.mp

    The status should be success
    The output should include "justify-content:left;"
  End

  It "draws an unaligned figure with '-A N'."
    When run $CMD -A N test.mp

    The status should be success
    The output should not include "justify-content:"
  End

  rm test.mp
End

Describe "mepoco"
  cat << END > test
beginfig(1);
draw fullcircle scaled 3cm;
endfig;
end.
END

  It "handles files without extensions."
    When run $CMD test

    The status should be success
    The output should include "</svg>"
  End

  rm test
End

Describe "mepoco"
  cat << END > test.mp
u := 1cm;
beginfig(1);
draw fullcircle scaled 2u;
endfig;
beginfig(2);
fill fullcircle scaled 2u withcolor 0.9white;
endfig;
end.
END

  It "draws multiple figures."
    When run $CMD test.mp

    The status should be success
    The output should include "</svg>"
  End

  It "draws aligned multiple figures with '-A space-evenly'."
    When run $CMD -A space-evenly test.mp

    The status should be success
    The output should include "</svg>"
    The output should include "justify-content:space-evenly;"
  End

  It "keeps the intermediate files of multiple figures with '-K'."
    When run $CMD -K test.mp

    The status should be success
    The output should include "</svg>"
    The file test_.mp should not be empty file
    The contents of file test.1.svg should include "</svg>"
    The contents of file test.2.svg should include "</svg>"
    The file test_.log should not be empty file

    rm test_.mp test.1.svg test.2.svg test_.log
  End

  rm test.mp
End

Describe "mepoco"
  cat << END > test.mp
a = 4096.0; % Number is too large
END

  It "stops with error messages when error."
    When run $CMD test.mp

    The status should be success
    The output should include "asyco-err"
  End
End

Describe "mepoco"
  cat << END > test.mp
show "Hello";
END

  It "can output text."
    When run $CMD test.mp

    The status should be success
    The output should include "<pre class='asyco-out'"
    The output should include "Hello"
    The lines of output should equal 4
  End

  It "turns off text output with '--no-text'."
    When run $CMD --no-text test.mp

    The status should be success
    The output should not include "<pre class='asyco-out'"
    The output should not include "Hello"
    The lines of output should equal 1
  End

  It "does not define '.hide' by default."
    When run $CMD test.mp

    The status should be success
    The output should not include ".hide"
  End

  It "defines '.hide' with '--dothide'."
    When run $CMD --dothide test.mp

    The status should be success
    The output should include "<style> .hide { display: none; } </style>"
  End

  rm test.mp
End

Describe "mepoco"
  cat << END > test
beginfig(1);
draw fullcircle scaled 3cm;
endfig;
end.
END

  It "accepts a filename without an extension."
    When run $CMD test

    The status should be success
    The output should include "</svg>"
  End

  rm test
End

Describe "mepoco"
  cat << END > "test 1.mp"
beginfig(1);
draw fullcircle scaled 3cm;
endfig;
end.
END

  It "accepts a filename containing spaces."
    When run $CMD "test 1.mp"

    The status should be success
    The output should include "</svg>"
  End

  rm "test 1.mp"
End

Describe "mepoco"
  cat << END > test1.mp
show "Hello";
END
  cat << END > test2.mp
show "World";
END

  It "does not accept multiple files."
    When run $CMD test1.mp test2.mp

    The status should be failure
    The error should include "unable to handle multiple files"
  End

  rm test1.mp test2.mp
End

Describe "mepoco"
  cat << END > test.mp
draw fullcircle scaled 3cm;
END

  It "adds 'beginfig(0);' and 'endfig;' with '-F'."
    When run $CMD -F test.mp

    The status should be success
    The output should include "</svg>"
  End

  rm test.mp
End
