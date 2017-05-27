#!/usr/bin/env bats

setup () {
    PATH=$PATH:"$(readlink -f "$BATS_TEST_DIRNAME/../bin")"
    declare -r maxline=16000
}

@test "Single tab" {
    run detab_f <<< $'\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '    x' ]]
}

@test "Space and tab" {
    run detab_f <<< $' \tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '    x' ]]
}

@test "Four spaces and tab" {
    run detab_f <<< $'    \tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '        x' ]]
}

@test "Space tab tab" {
    run detab_f <<< $' \t\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '        x' ]]
}

@test "Tab and one space" {
    run detab_f <<< $'\t x'
    declare -p output
    (( status == 0 ))
    [[ $output == '     x' ]]
}

@test "Tab and three spaces" {
    run detab_f <<< $'\t   x'
    declare -p output
    (( status == 0 ))
    [[ $output == '       x' ]]
}

@test "Two tabs" {
    run detab_f <<< $'\t\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '        x' ]]
}

@test "A tab and a backspace" {
    run detab_f <<< $'\t\bx'
    declare -p output
    (( status == 0 ))
    [[ $output == $'    \bx' ]]
}

@test "Two backspaces, x tab x" {
    run detab_f <<< $'\b\bx\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\b\bx   x' ]]
}

@test "Tab, x backspace y backspace z tab x" {
    run detab_f <<< $'\tx\by\bz\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == $'    x\by\bz   x' ]]
}

@test "Empty string" {
    run detab_f <<< ""
    declare -p output
    (( status == 0 ))
    [[ $output == '' ]]
}

@test "Tab after last tabstop" {
    printf -v line ' %.0s' {1..15998}
    run detab_f <<< "$line"$'\tx'
    (( status == 0 ))
    [[ $output == "$line  x" ]]
}

@test "Single tab with tabstop declared at 3" {
    run detab_f 3 <<< $'\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '  x' ]]
}

@test "Tabstop arguments in decreasing order" {
    run detab_f 6 3 <<< $'\tx\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '  x  x' ]]
}

@test "One explicit stop, then repeating" {
    run detab_f 5 +4 <<< $'\tx\tx\tx\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '    x   x   x   x' ]]
}

@test "Only repeating stops" {
    run detab_f +4 <<< $'\tx\tx\tx\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '    x   x   x   x' ]]
}

@test "Two explicit stops, then repeating" {
    run detab_f 3 6 +4 <<< $'\tx\tx\tx\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '  x  x   x   x' ]]
}
