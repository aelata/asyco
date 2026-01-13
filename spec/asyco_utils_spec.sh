Describe 'utils'
  Include ../asyco

  Describe 'quit'
    It 'writes a message and exits.'
      When run quit "quit"

      The status should not be success
      The stderr should equal "quit"
    End

    It 'can exit successfully with a message and a exits status.'
      When run quit "quit" 0

      The status should be success
      The stderr should equal "quit"
    End

  End

  Describe 'ncat'
    printf -- '-$L1 &>"`\n'" <L2 \\;'#| \n" > test.txt
    printf -- '-$L1 &>"`\n'" <L2 \\;'#| "  > test-.txt

    It "has the same function as 'cat' if '\n' is at the end of file."
      # xargs to remove trailing spaces
      o1="$(cat  test.txt | od -v -t x1 -An | xargs)"
      o2="$(ncat test.txt | od -v -t x1 -An | xargs)"

      The variable o2 should equal "$o1"
      The variable o2 should end with "0a"
    End

    It "adds '\n' to the end of file if one does not exist."
      # xargs to remove trailing spaces
      o1="$(cat  test-.txt | od -v -t x1 -An | xargs)"
      o2="$(ncat test-.txt | od -v -t x1 -An | xargs)"

      The variable o1 should not end with "0a"
      The variable o2 should end with "0a"
    End

    rm test.txt test-.txt
  End

  Describe 'array_append_file'
    printf -- '-$L1 &>"`\n'" <L2 \\;'#| \n" > test.txt
    printf -- '-$L1 &>"`\n'" <L2 \\;'#| "  > test-.txt

    It "appends lines in a text file."
      o1="$(cat test.txt)"
      o2=()
      array_append_file o2 "test.txt"

      The first line of variable o1 should equal "${o2[0]}"
      The second line of variable o1 should equal "${o2[1]}"
    End

    It "appends lines in a text file without '\n' at the end of files."
      o1="$(cat test-.txt)"
      o2=()
      array_append_file o2 "test-.txt"

      The first line of variable o1 should equal "${o2[0]}"
      The second line of variable o1 should equal "${o2[1]}"
    End

    rm test.txt test-.txt
  End

  Describe 'array_append_str'
    It "appends elements from a string."
      a=()
      array_append_str a "-f png --render 4"

      The value "${#a[@]}" should equal 4
      The variable a[0] should equal "-f"
      The variable a[3] should equal "4"
    End

    It "appends elements with quote."
      a=()
      array_append_str a \
'--cmd="/c/Program Files/Asymptote" --sysdir "/c/Program Files/Asymptote"'

      The value "${#a[@]}" should equal 3
      The variable a[0] should equal "--cmd=/c/Program Files/Asymptote"
      The variable a[2] should equal "/c/Program Files/Asymptote"
    End
  End

  Describe 'array_append_glob'
    It "appends files that match patterns to a global array."
      FILES="d.{1,2,10} b.{1,2,10} c.{1..3} 'a 1.txt'"
      eval touch $FILES
      a=()
      p=("b.1*" "c.{2,4}" "d.[12]" "'a 1'.*" "b*")
      array_append_glob a "${p[@]}"

      The variable a[*] should equal "a 1.txt b.1 b.2 b.10 c.2 d.1 d.2"
      The variable a[0] should equal "a 1.txt"
      The variable a[6] should equal "d.2"

      eval rm -rf "$FILES"
    End

    It "appends unique and sorted existing files."
      FILES="a.2 a.3 a.4 a.11"
      eval touch $FILES
      p=(a.11 a.2 a.3 a.2 a.5)
      a=()
      array_append_glob a "${p[@]}"

      The variable a[*] should equal "a.2 a.3 a.11"
      The variable a[0] should equal "a.2"
      The variable a[2] should equal "a.11"
      The variable a[3] should be undefined

      eval rm -rf "$FILES"
    End

    It "appends files with wildcard expansion."
      FILES="a.2 a.3 a.4 a.5 a.11 b.{9..11} c.2 d.11"
      eval touch $FILES
      p=("?.2" "*.11" "a.[45]")
      a=()
      array_append_glob a "${p[@]}"

      The variable a[*] should equal "a.2 a.4 a.5 a.11 b.11 c.2 d.11"
      The variable a[0] should equal "a.2"
      The variable a[6] should equal "d.11"
      The variable a[7] should be undefined

      eval rm -rf "$FILES"
    End

    It "appends files with brace expansion."
      FILES="a.2 b.{1..9} c.3"
      eval touch $FILES
      p=("b.{7,9}" "b.{2..4}")
      a=()
      array_append_glob a "${p[@]}"

      The variable a[*] should equal "b.2 b.3 b.4 b.7 b.9"
      The variable a[0] should equal "b.2"
      The variable a[4] should equal "b.9"
      The variable a[5] should be undefined

      eval rm -rf "$FILES"
    End

    It "appends files with spaces in their names."
      FILES="'a b'.{11,1,2,3} 'b c'.{11,1,2,3}"
      eval touch $FILES
      p=("'a b'.?" "*.3")
      a=()
      array_append_glob a "${p[@]}"

      The variable a[*] should equal "a b.1 a b.2 a b.3 b c.3"
      The variable a[0] should equal "a b.1"
      The variable a[3] should equal "b c.3"
      The variable a[4] should be undefined

      eval rm -rf $FILES
    End

    It "appends files in directories with spaces in their names."
      TMP_DIR="tmp dir_$$"
      mkdir "$TMP_DIR"
      FILES="'$TMP_DIR'/a.{2,9,11..13}"

      eval touch $FILES
      p=("'$TMP_DIR'/*.?")
      a=()
      array_append_glob a "${p[@]}"

      The variable a[*] should equal "$TMP_DIR/a.2 $TMP_DIR/a.9"
      The variable a[0] should equal "$TMP_DIR/a.2"
      The variable a[1] should equal "$TMP_DIR/a.9"
      The variable a[2] should be undefined

      rm -rf "$TMP_DIR"
    End

    It "appends files with Unicode names."
      FILES="あい.1 あい.2 あう.1 あう.2"
      eval touch $FILES
      p=("あ*.2")
      a=()
      array_append_glob a "${p[@]}"

      The variable a[*] should equal "あい.2 あう.2"
      The variable a[0] should equal "あい.2"
      The variable a[1] should equal "あう.2"
      The variable a[2] should be undefined

      eval rm -rf "$FILES"
    End
  End

  Describe 'html_echo'
    It "escapes HTML special characters in an argument."
      When run html_echo '<SCRIPT>document.write("v=" + (1 & 2));</SCRIPT>'

      The status should be success
      The output should equal \
"&lt;SCRIPT&gt;document.write(&quot;v=&quot; + (1 &amp; 2));&lt;/SCRIPT&gt;"
    End

    It "escapes HTML special characters in arguments."
      When run html_echo \
'<SCRIPT>' 'document.write("v=" + (1 & 2));' '</SCRIPT>'

      The status should be success
      The output should equal \
"&lt;SCRIPT&gt; document.write(&quot;v=&quot; + (1 &amp; 2)); &lt;/SCRIPT&gt;"
    End
  End

  Describe 'html_echoln'
    It "escapes HTML special characters in an array."
      a=('<SCRIPT>' 'document.write("v=" + (1 & 2));' '</SCRIPT>')
      When run html_echoln "${a[@]}"

      The status should be success
      The line 1 of output should equal "&lt;SCRIPT&gt;"
      The line 2 of output should equal \
"document.write(&quot;v=&quot; + (1 &amp; 2));"
      The line 3 of output should equal "&lt;/SCRIPT&gt;"
    End
  End
End
