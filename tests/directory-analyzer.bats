#!/usr/bin/env bats

setup() {
    PROJECT_ROOT="$(cd -- "$BATS_TEST_DIRNAME/.." && pwd)"
    ANALYZER="$PROJECT_ROOT/bin/directory-analyzer.sh"

    TEST_TMPDIR="$(mktemp -d)"
    TARGET_DIR="$TEST_TMPDIR/input dir"

    mkdir -p "$TARGET_DIR/nested dir"

    printf 'sample text\n' \
        > "$TARGET_DIR/file with spaces.txt"

    printf 'setting=value\n' \
        > "$TARGET_DIR/app.conf"

    printf 'sample log entry\n' \
        > "$TARGET_DIR/nested dir/another file.log"

    printf '#!/bin/sh\nexit 0\n' \
        > "$TARGET_DIR/run-me.sh"

    chmod +x "$TARGET_DIR/run-me.sh"
}

teardown() {
    rm -rf -- "$TEST_TMPDIR"
}

@test "analyzer counts files and recognizes extensions" {
    run bash "$ANALYZER" "$TARGET_DIR"

    [ "$status" -eq 0 ]
    [[ "$output" == *"Files: 4"* ]]
    [[ "$output" == *"Configuration files (.conf): 1"* ]]
    [[ "$output" == *"Text files (.txt): 1"* ]]
    [[ "$output" == *"Executable files: 1"* ]]
    [[ "$output" == *"Log files (.log): 1"* ]]
}

@test "analyzer supports paths containing spaces" {
    run bash "$ANALYZER" "$TARGET_DIR"

    [ "$status" -eq 0 ]
    [[ "$output" == *'file\ with\ spaces.txt'* ]]
    [[ "$output" == *'another\ file.log'* ]]
}

@test "analyzer reports execution time" {
    run bash "$ANALYZER" "$TARGET_DIR"

    [ "$status" -eq 0 ]
    [[ "$output" == *"Execution time:"* ]]
}

@test "missing directory returns exit code 2" {
    run bash "$ANALYZER" "$TEST_TMPDIR/missing"

    [ "$status" -eq 2 ]
    [[ "$output" == *"directory does not exist"* ]]
}

@test "root directory is rejected" {
    run bash "$ANALYZER" /

    [ "$status" -eq 2 ]
    [[ "$output" == *"root directory is disabled"* ]]
}

@test "missing argument returns exit code 2" {
    run bash "$ANALYZER"

    [ "$status" -eq 2 ]
    [[ "$output" == *"Usage:"* ]]
}

@test "help option returns exit code 0" {
    run bash "$ANALYZER" --help

    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage:"* ]]
}
