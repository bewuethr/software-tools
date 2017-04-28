#!/usr/bin/env bats

setup () {
    PATH=$PATH:"$(readlink -f "$BATS_TEST_DIRNAME/../bin")"
    declare -r maxline=16000
}

@test "Two characters" {
    run entab_a <<< 'xx'
    declare -p output
    (( status == 0 ))
    [[ $output == 'xx' ]]
}

@test "One character" {
    run entab_a <<< 'x'
    declare -p output
    (( status == 0 ))
    [[ $output == 'x' ]]
}

@test "Empty input file" {
    run entab_a <<< ''
    declare -p output
    (( status == 0 ))
    [[ $output == '' ]]
}

@test "One blank" {
    run entab_a <<< ' x'
    declare -p output
    (( status == 0 ))
    [[ $output == ' x' ]]
}

@test "Two blanks" {
    run entab_a <<<  '  x'
    declare -p output
    (( status == 0 ))
    [[ $output == '  x' ]]
}

@test "Three blanks" {
    run entab_a <<<  '   x'
    declare -p output
    (( status == 0 ))
    [[ $output == '   x' ]]
}

@test "Four blanks" {
    run entab_a <<<  '    x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\tx' ]]
}

@test "Five blanks" {
    run entab_a <<<  '     x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\t x' ]]
}

@test "Six blanks" {
    run entab_a <<<  '      x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\t  x' ]]
}

@test "Seven blanks" {
    run entab_a <<<  '       x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\t   x' ]]
}

@test "Eight blanks" {
    run entab_a <<<  '        x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\t\tx' ]]
}

@test "Nine blanks" {
    run entab_a <<<  '         x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\t\t x' ]]
}

@test "Ten blanks" {
    run entab_a <<<  '          x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\t\t  x' ]]
}

@test "Mixed spaces" {
    run entab_a <<<  '    col 1   2   34  rest'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\tcol\t1\t2\t34\trest' ]]
}

@test "Tab space space space x" {
    run entab_a <<< $'\t   x'
    declare -p output
    cat -A <<< "$output"
    (( status == 0 ))
    [[ $output == $'\t   x' ]]
}

@test "Space space space tab x" {
    run entab_a <<< $'   \tx'
    declare -p output
    cat -A <<< "$output"
    (( status == 0 ))
    [[ $output == $'\tx' ]]
}

@test "Space tab space x tab x" {
    run entab_a <<< $' \t x\tx'
    declare -p output
    cat -A <<< "$output"
    (( status == 0 ))
    [[ $output == $'\t x\tx' ]]
}

@test "Tab tab tab" {
    run entab_a <<< $'\t\t\t'
    declare -p output
    cat -A <<< "$output"
    (( status == 0 ))
    [[ $output == $'\t\t\t' ]]
}

@test "Tab backspace x" {
    run entab_a <<< $'\t\bx'
    declare -p output
    cat -A <<< "$output"
    (( status == 0 ))
    [[ $output == $'   x' ]]
}

@test "Tab bs bs bs bs x" {
    run entab_a <<< $'\t\b\b\b\bx'
    declare -p output
    cat -A <<< "$output"
    (( status == 0 ))
    [[ $output == x ]]
}

@test "Backspace x" {
    run entab_a <<< $'\bx'
    declare -p output
    cat -A <<< "$output"
    (( status == 0 ))
    [[ $output == x ]]
}

@test "x space bs bs space x" {
    run entab_a <<< $'x \b\b x'
    declare -p output
    cat -A <<< "$output"
    (( status == 0 ))
    [[ $output == $'xx' ]]
}
