#!/usr/bin/env bats

setup () {
    PATH=$PATH:"$(readlink -f "$BATS_TEST_DIRNAME/../bin")"
    declare -r maxline=16000
}

@test "Two characters" {
    run entab_c <<< 'xx'
    declare -p output
    (( status == 0 ))
    [[ $output == 'xx' ]]
}

@test "One character" {
    run entab_c <<< 'x'
    declare -p output
    (( status == 0 ))
    [[ $output == 'x' ]]
}

@test "Empty input file" {
    run entab_c <<< ''
    declare -p output
    (( status == 0 ))
    [[ $output == '' ]]
}

@test "One blank" {
    run entab_c <<< ' x'
    declare -p output
    (( status == 0 ))
    [[ $output == ' x' ]]
}

@test "Two blanks" {
    run entab_c <<<  '  x'
    declare -p output
    (( status == 0 ))
    [[ $output == '  x' ]]
}

@test "Three blanks" {
    run entab_c <<<  '   x'
    declare -p output
    (( status == 0 ))
    [[ $output == '   x' ]]
}

@test "Four blanks" {
    run entab_c <<<  '    x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\tx' ]]
}

@test "Five blanks" {
    run entab_c <<<  '     x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\t x' ]]
}

@test "Six blanks" {
    run entab_c <<<  '      x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\t  x' ]]
}

@test "Seven blanks" {
    run entab_c <<<  '       x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\t   x' ]]
}

@test "Eight blanks" {
    run entab_c <<<  '        x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\t\tx' ]]
}

@test "Nine blanks" {
    run entab_c <<<  '         x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\t\t x' ]]
}

@test "Ten blanks" {
    run entab_c <<<  '          x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\t\t  x' ]]
}

@test "Mixed spaces" {
    run entab_c <<<  '    col 1   2   34  rest'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\tcol\t1\t2\t34\trest' ]]
}

@test "Tab space space space x" {
    run entab_c <<< $'\t   x'
    declare -p output
    cat -A <<< "$output"
    (( status == 0 ))
    [[ $output == $'\t   x' ]]
}

@test "Space space space tab x" {
    run entab_c <<< $'   \tx'
    declare -p output
    cat -A <<< "$output"
    (( status == 0 ))
    [[ $output == $'\tx' ]]
}

@test "Space tab space x tab x" {
    run entab_c <<< $' \t x\tx'
    declare -p output
    cat -A <<< "$output"
    (( status == 0 ))
    [[ $output == $'\t x\tx' ]]
}

@test "Tab tab tab" {
    run entab_c <<< $'\t\t\t'
    declare -p output
    cat -A <<< "$output"
    (( status == 0 ))
    [[ $output == $'\t\t\t' ]]
}

@test "Tab backspace x" {
    run entab_c <<< $'\t\bx'
    declare -p output
    cat -A <<< "$output"
    (( status == 0 ))
    [[ $output == $'\t\bx' ]]
}

@test "Command line arguments" {
    run entab_c 3 5 <<<  '  x x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\tx\tx' ]]
}

@test "Command line arguments in decreasing order" {
    run entab_c 5 3 <<<  '  x x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\tx\tx' ]]
}

@test "One explicit stop, then repeating" {
    run entab_c 5 +4 <<<  '    x   x   x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\tx\tx\tx' ]]
}

@test "Two explicit stops, then repeating" {
    run entab_c 5 7 +4 <<<  '    x x   x   x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\tx\tx\tx\tx' ]]
}

@test "Only repeating stops" {
    run entab_c +4 <<<  '    x   x'
    declare -p output
    (( status == 0 ))
    [[ $output == $'\tx\tx' ]]
}
