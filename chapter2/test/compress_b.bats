#!/usr/bin/env bats

setup () {
    PATH=$PATH:"$(readlink -f "$BATS_TEST_DIRNAME/../bin")"
}

@test "First character is repeated" {
    run compress_b <<< $'Axx\nAyy'
    declare -p output
    (( status == 0 ))
    [[ $output == $'Axx\n!yy' ]]
}

@test "First two characters are repeated" {
    run compress_b <<< $'AAxx\nAAyy'
    declare -p output
    (( status == 0 ))
    [[ $output == $'AAxx\n"yy' ]]
}

@test "Single line of input" {
    run compress_b <<< 'AAA'
    declare -p output
    (( status == 0 ))
    [[ $output == 'AAA' ]]
}

@test "No characters repeated" {
    run compress_b <<< $'AAA\nBBB'
    declare -p output
    (( status == 0 ))
    [[ $output == $'AAA\n BBB' ]]
}

@test "Three, then four characters repeated" {
    run compress_b <<< $'AAAA\nAAAB\nAAAB'
    declare -p output
    (( status == 0 ))
    [[ $output == $'AAAA\n#B\n$' ]]
}

@test "94 repeating characters are compressed" {
    run compress_b <<< "$(printf 'A%.0s' {1..94})"$'B\n'"$(printf 'A%.0s' {1..94})C"
    declare -p output
    (( status == 0 ))
    [[ $output == "$(printf 'A%.0s' {1..94})"$'B\n~C' ]]
}

@test "95 repeating characters are compressed up to 94 only" {
    run compress_b <<< "$(printf 'A%.0s' {1..95})"$'B\n'"$(printf 'A%.0s' {1..95})C"
    declare -p output
    (( status == 0 ))
    [[ $output == "$(printf 'A%.0s' {1..95})"$'B\n~AC' ]]
}
