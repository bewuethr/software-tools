#!/usr/bin/env bats

setup () {
    PATH=$PATH:$PWD/bin
    declare -r maxline=16000
}

teardown () {
    PATH=${PATH%:*}
}

@test "Single tab" {
    run detab_b <<< $'\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '    x' ]]
}

@test "Space and tab" {
    run detab_b <<< $' \tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '    x' ]]
}

@test "Four spaces and tab" {
    run detab_b <<< $'    \tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '        x' ]]
}

@test "Space tab tab" {
    run detab_b <<< $' \t\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '        x' ]]
}

@test "Tab and one space" {
    run detab_b <<< $'\t x'
    declare -p output
    (( status == 0 ))
    [[ $output == '     x' ]]
}

@test "Tab and three spaces" {
    run detab_b <<< $'\t   x'
    declare -p output
    (( status == 0 ))
    [[ $output == '       x' ]]
}

@test "Two tabs" {
    run detab_b <<< $'\t\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == '        x' ]]
}

@test "A tab and a backspace" {
    run detab_b <<< $'\t\bx'
    declare -p output
    (( status == 0 ))
    [[ $output == $'    \bx' ]]
}

@test "Two backspaces, x tab x" {
    run detab_b <<< $'\b\bx\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\b\bx   x' ]]
}

@test "Tab, x backspace y backspace z tab x" {
    run detab_b <<< $'\tx\by\bz\tx'
    declare -p output
    (( status == 0 ))
    [[ $output == $'    x\by\bz   x' ]]
}

@test "Empty string" {
    run detab_b <<< ""
    declare -p output
    (( status == 0 ))
    [[ $output == '' ]]
}

@test "Tab after last tabstop" {
    printf -v line ' %.0s' {1..15998}
    run detab_b <<< "$line"$'\tx'
    (( status == 0 ))
    [[ $output == "$line  x" ]]
}
