#!/usr/bin/env bats

setup () {
    PATH=$PATH:"$(readlink -f "$BATS_TEST_DIRNAME/../bin")"
}

teardown () {
    PATH=${PATH%:*}
}

@test "Underline x" {
    run overstrike_b <<< $'x\b_'
    declare -p output
    (( status == 0 ))
    [[ $output == $' x\n+_' ]]
}

@test "Backspace to before beginning of line" {
    run overstrike_b <<< $'x\b\b\b___'
    declare -p output
    (( status == 0 ))
    [[ $output == $' x__\n+_' ]]
}

@test "Underline in middle of line" {
    run overstrike_b <<< $'xxxxx\b\b\b_'
    declare -p output
    (( status == 0 ))
    [[ $output == $' xxxxx\n+  _' ]]
}

@test "Empty overstrike line" {
    run overstrike_b <<< $'xxx\b'
    declare -p output
    (( status == 0 ))
    [[ $output == $' xxx' ]]
}

@test "Overstrike for each character separate" {
    run overstrike_b <<< $'x\b_x\b_x\b_'
    declare -p output
    (( status == 0 ))
    [[ $output == $' xxx\n+___' ]]
}

@test "Overstrike same character twice" {
    run overstrike_b <<< $'x\b_\b_'
    declare -p output
    (( status == 0 ))
    [[ $output == $' x\n+_\n+_' ]]
}
