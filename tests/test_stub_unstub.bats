#!/usr/bin/env bats

load "bats-support/load"
load "bats-assert/all"

function setup()
{
	declare -g WD="$(mktemp -d --tmpdir="${BATS_TMPDIR}")"
}

function teardown()
{
	rm -rf "${WD}"
}

function _stub_env()
{
	stub "$@"
	rv=$?
	command env | command grep -E '_STUB_(END|PLAN|RUN)=' | command sort
	return $rv
}
@test "sanitise variable names" {
	source "${BATS_TEST_DIRNAME}/../src/stub.bash"

	export BATS_MOCK_TMPDIR="${WD}"
	export BATS_MOCK_BINDIR="${WD}/bin"

	program_name="program.name-with_character1"
	expected_prefix="PROGRAM_NAME_WITH_CHARACTER1"
	run _stub_env "${program_name}"
	assert_success
	assert_equal "${expected_prefix}_STUB_END=" "${lines[0]}"
	assert_equal "${expected_prefix}_STUB_PLAN=${WD}/${program_name}-stub-plan" "${lines[1]}"
	assert_equal "${expected_prefix}_STUB_RUN=${WD}/${program_name}-stub-run" "${lines[2]}"

	assert test -d "${WD}/bin"
	assert test -L "${WD}/bin/${program_name}"
	assert_equal "$(cd "${BATS_TEST_DIRNAME}/../src" && pwd -P)/binstub" "$(readlink -f "${WD}/bin/${program_name}")"
}
