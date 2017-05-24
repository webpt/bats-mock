#!/usr/bin/env bats

load "bats-support/load"
load "bats-assert/load"

function setup()
{
	declare -g WD="$(mktemp -d --tmpdir="${BATS_TMPDIR}")"
}

function teardown()
{
	rm -rf "${WD}"
}

@test "sanitise variable names" {
	source "${BATS_TEST_DIRNAME}/../src/stub.bash"

	export BATS_MOCK_TMPDIR="${WD}"
	export BATS_MOCK_BINDIR="${WD}/bin"

	program_name="program.name-with_character1"
	expected_prefix="PROGRAM_NAME_WITH_CHARACTER_"
	run stub "${program_name}" \; env \| grep -E '_STUB_{PLAN,RUN,END}=' \| sort
	assert_success
	assert_line --index=0 "${expected_prefix}_STUB_END="
	assert_line --index=1 "${expected_prefix}_STUB_PLAN=${WD}/${program_name}-stub-plan"
	assert_line --index=2 "${expected_prefix}_STUB_RUN=${WD}/${program_name}-stub-run"

	assert_true test -d "${WD}/bin"
	assert_true test -l "${WD}/bin/${program_name}"
	assert_equal "$(cd "${BATS_TEST_DIRNAME}/../src" && pwd -P)/binstub" "$(readlink -f "${WD}/bin/${program_name}")"
}
