Describe 'utils'
  Include ../asycat

  Describe 'warn'
    It 'outputs a warning message to the standard error.'
      When call warn "File not found."

      The status should be success
      The error should equal "WARNING: File not found."
    End

    It 'can output a message with a specified heading.'
      When call warn "File not found." ""

      The status should be success
      The error should equal "File not found."
    End
  End

  Describe 'rep'
    Parameters:value 1 3 5

    It "repeats a character '=' $1 times."
      When call rep = $1

      The status should be success
      The length of output should equal "$1"
    End
  End

  Describe 'rep'
    Parameters:value '$' '%' '#' '-' '`' '"' "'"

    It "repeats a character '$1' 5 times."
      When call rep $1 5

      The status should be success
      The length of output should equal 5
      The output should start with "$1"
      The output should end with "$1"
    End
  End

  Describe 'rep'
    Parameters:value '=~' '＝〜'

    It "repeats a string '$1' 5 times."
      When call rep $1 5

      The status should be success
      The length of output should equal 10
      The output should start with "$1"
      The output should end with "$1"
    End
  End

  Describe 'rep'
    It "gives an empty string with no arguments."
      When call rep

      The status should be success
      The length of output should equal 0
    End
  End

  Describe 'rep'
    Parameters:value -1 0 n

    It "gives an empty string with arguments: '=' '$1'."
      When call rep = $1

      The status should be failure
      The length of output should equal 0
    End
  End
End
