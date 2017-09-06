#!/usr/bin/env bats

setup () {
    PATH=$PATH:"$(readlink -f "$BATS_TEST_DIRNAME/../bin")"
}

@test "One character in from and to" {
    run translit a b <<< 'a'
    declare -p output
    (( status == 0 ))
    [[ $output == 'b' ]]
}

@test "Character doesn't match from and is untouched" {
    run translit a b <<< 'x'
    declare -p output
    (( status == 0 ))
    [[ $output == 'x' ]]
}

@test "Map some characters, but not all" {
    run translit a X <<< 'abc'
    declare -p output
    (( status == 0 ))
    [[ $output == 'Xbc' ]]
}

@test "One range to another range" {
    run translit a-c d-f <<< 'abcABC'
    declare -p output
    (( status == 0 ))
    [[ $output == 'defABC' ]]
}

@test "Map two characters to one" {
    run translit ab X <<< 'abc'
    declare -p output
    (( status == 0 ))
    [[ $output == 'Xc' ]]
}

@test "Map range to one character" {
    run translit 0-9 9 <<< 'abc123456789'
    declare -p output
    (( status == 0 ))
    [[ $output == 'abc9' ]]
}

@test "Upper case to lower" {
    run translit A-Z a-z <<< 'UPPER'
    declare -p output
    (( status == 0 ))
    [[ $output == 'upper' ]]
}

@test "Discard punctuation and isolate words by spaces" {
    run translit ^a-zA-Z@n ' ' <<< 'This is a simple-minded test, i.e., a test of translit.'
    declare -p output
    (( status == 0 ))
    [[ $output == 'This is a simple minded test i e a test of translit ' ]]
}
