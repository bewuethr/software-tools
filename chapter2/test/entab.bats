#!/usr/bin/env bats

setup () {
    PATH=$PATH:"$(readlink -f "$BATS_TEST_DIRNAME/../bin")"
    declare -r maxline=16000
}

teardown () {
    PATH=${PATH%:*}
}

@test "Two characters" {
    run entab <<< 'xx'
    declare -p output
    (( status == 0 ))
    [[ $output == 'xx' ]]
}

@test "One character" {
    run entab <<< 'x'
    declare -p output
    (( status == 0 ))
    [[ $output == 'x' ]]
}

@test "Empty input file" {
    run entab <<< ''
    declare -p output
    (( status == 0 ))
    [[ $output == '' ]]
}

@test "One blank" {
    run entab <<< ' x'
    declare -p output
    (( status == 0 ))
    [[ $output == ' x' ]]
}

@test "Two blanks" {
    run entab <<<  '  x'
    declare -p output
    (( status == 0 ))
    [[ $output == '  x' ]]
}

@test "Three blanks" {
    run entab <<<  '   x'
    declare -p output
    (( status == 0 ))
    [[ $output == '   x' ]]
}

@test "Four blanks" {
    run entab <<<  '    x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\tx' ]]
}

@test "Five blanks" {
    run entab <<<  '     x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\t x' ]]
}

@test "Six blanks" {
    run entab <<<  '      x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\t  x' ]]
}

@test "Seven blanks" {
    run entab <<<  '       x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\t   x' ]]
}

@test "Eight blanks" {
    run entab <<<  '        x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\t\tx' ]]
}

@test "Nine blanks" {
    run entab <<<  '         x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\t\t x' ]]
}

@test "Ten blanks" {
    run entab <<<  '          x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\t\t  x' ]]
}

@test "Mixed spaces" {
    run entab <<<  '    col 1   2   34  rest'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\tcol\t1\t2\t34\trest' ]]
}

@test "Tab space space space x" {
    run entab <<< $'\t   x'
    declare -p output
    cat -A <<< "$output"
    (( status == 0 ))
    [[ $output == $'\t   x' ]]
}

@test "Space space space tab x" {
    run entab <<< $'   \tx'
    declare -p output
    cat -A <<< "$output"
    (( status == 0 ))
    [[ $output == $'\tx' ]]
}

@test "Space tab space x tab x" {
    run entab <<< $' \t x\tx'
    declare -p output
    cat -A <<< "$output"
    (( status == 0 ))
    [[ $output == $'\t x\tx' ]]
}

@test "Tab tab tab" {
    run entab <<< $'\t\t\t'
    declare -p output
    cat -A <<< "$output"
    (( status == 0 ))
    [[ $output == $'\t\t\t' ]]
}

@test "Tab backspace x" {
    run entab <<< $'\t\bx'
    declare -p output
    cat -A <<< "$output"
    (( status == 0 ))
    [[ $output == $'\t\bx' ]]
}
