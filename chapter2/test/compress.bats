#!/usr/bin/env bats

setup () {
    PATH=$PATH:"$(readlink -f "$BATS_TEST_DIRNAME/../bin")"
}

@test "Four characters are compressed" {
    run compress <<< 'AAAA'
    declare -p output
    (( status == 0 ))
    [[ $output == '~DA' ]]
}

@test "Three characters are not compressed" {
    run compress <<< 'AAA'
    declare -p output
    (( status == 0 ))
    [[ $output == 'AAA' ]]
}

@test "Tilde is always compressed" {
    run compress <<< '~'
    declare -p output
    (( status == 0 ))
    [[ $output == '~A~' ]]
}

@test "26 characters are compressed into one encoded sequence" {
    run compress <<< 'AAAAAAAAAAAAAAAAAAAAAAAAAA'
    declare -p output
    (( status == 0 ))
    [[ $output == '~ZA' ]]
}

@test "27 characters are compressed into one encoded sequence plus a single character" {
    run compress <<< 'AAAAAAAAAAAAAAAAAAAAAAAAAAA'
    declare -p output
    (( status == 0 ))
    [[ $output == '~ZAA' ]]
}

@test "30 characters are compressed into two encoded sequences" {
    run compress <<< 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
    declare -p output
    (( status == 0 ))
    [[ $output == '~ZA~DA' ]]
}
