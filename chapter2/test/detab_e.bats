#!/usr/bin/env bats

setup () {
    PATH=$PATH:"$(readlink -f "$BATS_TEST_DIRNAME/../bin")"
    declare -r maxline=16000
}

@test "Single tab" {
    run detab_e <<< $'\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '    x' ]]
}

@test "Space and tab" {
    run detab_e <<< $' \tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '    x' ]]
}

@test "Four spaces and tab" {
    run detab_e <<< $'    \tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '        x' ]]
}

@test "Space tab tab" {
    run detab_e <<< $' \t\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '        x' ]]
}

@test "Tab and one space" {
    run detab_e <<< $'\t x'
    declare -p output
    (( status == 0 ))
    [[ $output == '     x' ]]
}

@test "Tab and three spaces" {
    run detab_e <<< $'\t   x'
    declare -p output
    (( status == 0 ))
    [[ $output == '       x' ]]
}

@test "Two tabs" {
    run detab_e <<< $'\t\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '        x' ]]
}

@test "A tab and a backspace" {
    run detab_e <<< $'\t\bx'
    declare -p output
    (( status == 0 ))
    [[ $output == $'    \bx' ]]
}

@test "Two backspaces, x tab x" {
    run detab_e <<< $'\b\bx\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\b\bx   x' ]]
}

@test "Tab, x backspace y backspace z tab x" {
    run detab_e <<< $'\tx\by\bz\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == $'    x\by\bz   x' ]]
}

@test "Empty string" {
    run detab_e <<< ""
    declare -p output
    (( status == 0 ))
    [[ $output == '' ]]
}

@test "Tab after last tabstop" {
    printf -v line ' %.0s' {1..15998}
    run detab_e <<< "$line"$'\tx'
    (( status == 0 ))
    [[ $output == "$line  x" ]]
}

@test "Single tab with tabstop declared at 3" {
    run detab_e 3 <<< $'\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '  x' ]]
}

@test "Tabstop arguments in decreasing order" {
    run detab_e 6 3 <<< $'\tx\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '  x  x' ]]
}
