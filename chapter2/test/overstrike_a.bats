#!/usr/bin/env bats

setup () {
    PATH=$PATH:"$(readlink -f "$BATS_TEST_DIRNAME/../bin")"
}

teardown () {
    PATH=${PATH%:*}
}

@test "Underline xxx" {
    run overstrike_a <<< $'xxx\b\b\b___'
    declare -p output
    (( status == 0 ))
    [[ $output == $' xxx\n+___' ]]
}

@test "Backspace to before beginning of line" {
    run overstrike_a <<< $'x\b\b\b___'
    declare -p output
    (( status == 0 ))
    [[ $output == $' x\n+_' ]]
}

@test "Underline in middle of line" {
    run overstrike_a <<< $'xxxxx\b\b\b_'
    declare -p output
    (( status == 0 ))
    [[ $output == $' xxxxx\n+  _' ]]
}

@test "One backspace at a time" {
    run overstrike_a <<< $'a\b_b\b_c\b_'
    declare -p output
    (( status == 0 ))
    [[ $output == $' a\n+_b\n+ _c\n+  _' ]]
}
