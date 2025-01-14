#!/usr/bin/env shellspec

set -euo pipefail

Describe 'yq'

  BeforeAll 'fixture=$(load_fixture "static-app")'

  Describe 'write and read'
    It 'can write a new node'
      When call yq --inplace '.applications[0].env.SOME_KEY = "some value"' "$fixture/manifest.yml"
      The status should be success
    End

    It 'can read a new node'
      When call yq '.applications[0].env.SOME_KEY' "$fixture/manifest.yml"
      The status should be success
      The output should equal "some value"
    End
  End

  It 'can read single quoted flow scalar'
    When call yq '.applications[0].env.SINGLE_QUOTED' "$fixture/manifest.yml"
    The status should be success
    The output should equal "Several lines of text, containing 'single quotes'. Escapes (like \n) don't do anything.
Newlines can be added by leaving a blank line. Leading whitespace on lines is ignored."
  End

  It 'can read double quoted flow scalar'
    When call yq '.applications[0].env.DOUBLE_QUOTED' "$fixture/manifest.yml"
    The status should be success
    The output should equal "Several lines of text, containing \"double quotes\". Escapes (like \n) work.
In addition, newlines can be escaped to prevent them from being converted to a space.
Newlines can also be added by leaving a blank line. Leading whitespace on lines is ignored."
  End

  It 'can read plain flow scalar'
    When call yq '.applications[0].env.PLAIN' "$fixture/manifest.yml"
    The status should be success
    The output should equal "Several lines of text, with some \"quotes\" of various 'types'. Escapes (like \n) don't do anything.
Newlines can be added by leaving a blank line. Additional leading whitespace is ignored."
  End

  It 'can read block folded scalar'
    When call yq '.applications[0].env.BLOCK_FOLDED' "$fixture/manifest.yml"
    The status should be success
    # internal use of command substitution — $() — strips trailing newlines, so we won't actually have "another line at the end"
    The output should equal "Several lines of text, with some \"quotes\" of various 'types', and also a blank line:
plus another line at the end."
  End

  It 'can read block literal scalar'
    When call yq '.applications[0].env.BLOCK_LITERAL' "$fixture/manifest.yml"
    The status should be success
    # internal use of command substitution — $() — strips trailing newlines, so we won't actually have "another line at the end"
    The output should equal "Several lines of text,
with some \"quotes\" of various 'types',
and also a blank line:

plus another line at the end."
  End

  It 'can read hyphenated string'
    When call yq '.applications[0].env.HYPHENATED_STRING' "$fixture/manifest.yml"
    The status should be success
    The output should equal "- strings that start with a hyphen should be quoted"
  End

  It 'can read json as string'
    When call yq '.applications[0].env.JSON_AS_STRING' "$fixture/manifest.yml"
    The status should be success
    The output should equal "{ jre: { version: 11.+ }, memory_calculator: { stack_threads: 25 } }"
  End

  It 'can read array as string'
    When call yq '.applications[0].env.ARRAY_AS_STRING' "$fixture/manifest.yml"
    The status should be success
    The output should equal '[ list, of, things ]'
  End
End
