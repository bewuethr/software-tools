#!/usr/bin/env bats

setup () {
    PATH=$PATH:"$(readlink -f "$BATS_TEST_DIRNAME/../bin")"
}

@test "Four characters are compressed" {
    run compress_a <<< 'AAAA'
    declare -p output
    (( status == 0 ))
    [[ $output == '~#A' ]]
}

@test "Three characters are not compressed" {
    run compress_a <<< 'AAA'
    declare -p output
    (( status == 0 ))
    [[ $output == 'AAA' ]]
}

@test "Tilde is always compressed" {
    run compress_a <<< '~'
    declare -p output
    (( status == 0 ))
    [[ $output == '~ ~' ]]
}

@test "95 characters are compressed into one encoded sequence" {
    run compress_a <<< "$(printf 'A%.0s' {1..95})"
    declare -p output
    (( status == 0 ))
    [[ $output == '~~A' ]]
}

@test "96 characters are compressed into one encoded sequence plus a single character" {
    run compress_a <<< "$(printf 'A%.0s' {1..96})"
    declare -p output
    (( status == 0 ))
    [[ $output == '~~AA' ]]
}

@test "99 characters are compressed into two encoded sequences" {
    run compress_a <<< "$(printf 'A%.0s' {1..99})"
    declare -p output
    (( status == 0 ))
    [[ $output == '~~A~#A' ]]
}
