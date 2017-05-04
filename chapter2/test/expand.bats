#!/usr/bin/env bats

setup () {
    PATH=$(readlink -f "$BATS_TEST_DIRNAME/../bin"):$PATH
}

@test "Expand four characters" {
    run expand <<< '~DA'
    declare -p output
    (( status == 0 ))
    [[ $output == 'AAAA' ]]
}

@test "Expand single warning sign" {
    run expand <<< '~A~'
    declare -p output
    (( status == 0 ))
    [[ $output == '~' ]]
}

@test "Multiple values including warning sign on two lines" {
    run expand <<< $'Item~D Name~I Value\n1~G car~J ~A~$7,000.00'
    declare -p output
    (( status == 0 ))
    [[ $output == $'Item    Name         Value\n1       car          ~$7,000.00' ]]
}

@test "Ends in warning sign" {
    run expand <<< 'A~'
    declare -p output
    (( status == 0 ))
    [[ $output == 'A~' ]]
}

@test "Warning sign followed by character other than uppercase letter" {
    run expand <<< '~9A'
    declare -p output
    (( status == 0 ))
    [[ $output == '~9A' ]]
}

@test "Input ends after counter" {
    # Needs need shell because of pipe
    # Needs pipe to prevent newline from being added
    run bash -c "printf '~D' | expand"
    declare -p output
    (( status == 0 ))
    [[ $output == '~D' ]]
}
