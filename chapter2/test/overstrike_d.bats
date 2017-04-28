#!/usr/bin/env bats

setup () {
    PATH=$PATH:"$(readlink -f "$BATS_TEST_DIRNAME/../bin")"
}

@test "Underline xxx" {
    run overstrike_d <<< $'xxx\b\b\b___'
    declare -p output
    (( status == 0 ))
    [[ $output == $' xxx\n+___' ]]
}

@test "Backspace to before beginning of line" {
    run overstrike_d <<< $'x\b\b\b___'
    declare -p output
    (( status == 0 ))
    [[ $output == $' x\n+___' ]]
}

@test "Underline in middle of line" {
    run overstrike_d <<< $'xxxxx\b\b\b_'
    declare -p output
    (( status == 0 ))
    [[ $output == $' xxxxx\n+  _' ]]
}

@test "One backspace at a time" {
    run overstrike_d <<< $'a\b_b\b_c\b_'
    declare -p output
    (( status == 0 ))
    [[ $output == $' a\n+_b\n+ _c\n+  _' ]]
}

@test "Overstrike with carriage return" {
    run overstrike_d <<< $'xxx\r___'
    declare -p output
    (( status == 0 ))
    [[ $output == $' xxx\n+___' ]]
}
