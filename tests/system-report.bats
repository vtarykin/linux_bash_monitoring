#!/usr/bin/env bats

setup() {
    PROJECT_ROOT="$(cd -- "$BATS_TEST_DIRNAME/.." && pwd)"
    REPORT="$PROJECT_ROOT/bin/system-report.sh"
    TEST_TMPDIR="$(mktemp -d)"
}

teardown() {
    rm -rf -- "$TEST_TMPDIR"
}

@test "system report displays system information" {
    run bash "$REPORT" --no-color

    [ "$status" -eq 0 ]
    [[ "$output" == *"HOSTNAME"* ]]
    [[ "$output" == *"OS"* ]]
    [[ "$output" == *"IP_CIDR"* ]]
    [[ "$output" == *"RAM_TOTAL_GIB"* ]]
    [[ "$output" == *"ROOT_TOTAL_GIB"* ]]
}

@test "help option displays usage" {
    run bash "$REPORT" --help

    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage:"* ]]
}

@test "unknown option returns exit code 2" {
    run bash "$REPORT" --unknown

    [ "$status" -eq 2 ]
    [[ "$output" == *"unknown option"* ]]
}

@test "report can be saved without terminal colors" {
    local report_file="$TEST_TMPDIR/report.status"

    run bash "$REPORT" --no-color --output "$report_file"

    [ "$status" -eq 0 ]
    [ -s "$report_file" ]

    run grep -q '^HOSTNAME' "$report_file"
    [ "$status" -eq 0 ]

    run grep -q $'\033' "$report_file"
    [ "$status" -eq 1 ]
}
