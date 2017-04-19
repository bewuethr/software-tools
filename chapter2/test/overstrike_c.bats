#!/usr/bin/env bats

setup () {
    PATH=$PATH:"$(readlink -f "$BATS_TEST_DIRNAME/../bin")"
}

teardown () {
    PATH=${PATH%:*}
}

@test "Underline xxx" {
    run overstrike_c <<< $'xxx\b\b\b___'
    declare -p output
    (( status == 0 ))
    [[ $output == $' xxx\n+___' ]]
}

@test "Backspace to before beginning of line" {
    run overstrike_c <<< $'x\b\b\b___'
    declare -p output
    (( status == 0 ))
    [[ $output == $' x\n+___' ]]
}

@test "Underline in middle of line" {
    run overstrike_c <<< $'xxxxx\b\b\b_'
    declare -p output
    (( status == 0 ))
    [[ $output == $' xxxxx\n+  _' ]]
}

@test "One backspace at a time" {
    run overstrike_c <<< $'a\b_b\b_c\b_'
    declare -p output
    (( status == 0 ))
    [[ $output == $' a\n+_b\n+ _c\n+  _' ]]
}

@test "Form feed in middle of line" {
    run overstrike_c <<< $'xxx\fxxx'
    declare -p output
    (( status == 0 ))
    [[ $output == $' xxx\n1\n xxx' ]]
}

@test "Form feed at end of line" {
    run overstrike_c <<< $'xxx\f'
    declare -p output
    (( status == 0 ))
    [[ $output == $' xxx\n1\n ' ]]
}

@test "Just form feed" {
    run overstrike_c <<< $'\f'
    declare -p output
    (( status == 0 ))
    [[ $output == $'1\n ' ]]
}

@test "Two successive form feeds" {
    run overstrike_c <<< $'\f\f'
    declare -p output
    (( status == 0 ))
    [[ $output == $'1\n1\n ' ]]
}
