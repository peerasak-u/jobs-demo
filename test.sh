#!/bin/bash

# Function to generate random test result (pass/fail)
generate_test_result() {
    local test_name=$1
    if [ $((RANDOM % 2)) -eq 0 ]; then
        echo "$test_name:PASS"
    else
        echo "$test_name:FAIL"
    fi
}

# Generate test results
TEST_RESULTS=(
    $(generate_test_result "Login_Test")
    $(generate_test_result "Database_Connection_Test")
    $(generate_test_result "API_Integration_Test")
    $(generate_test_result "Performance_Test")
    $(generate_test_result "Security_Test")
)

# Output results to a file
echo "${TEST_RESULTS[@]}" > test_results.txt

# Calculate pass/fail counts
PASS_COUNT=0
FAIL_COUNT=0

for result in "${TEST_RESULTS[@]}"; do
    if [[ $result == *":PASS" ]]; then
        ((PASS_COUNT++))
    else
        ((FAIL_COUNT++))
    fi
done

TOTAL_COUNT=$((PASS_COUNT + FAIL_COUNT))
PASS_RATE=$((PASS_COUNT * 100 / TOTAL_COUNT))

# Only output the required data in the format expected by the workflow
echo "$TOTAL_COUNT:$PASS_COUNT:$FAIL_COUNT:$PASS_RATE"

# Write summary to a separate file for logging
{
    echo "Test Summary:"
    echo "Total Tests: $TOTAL_COUNT"
    echo "Passed: $PASS_COUNT"
    echo "Failed: $FAIL_COUNT"
    echo "Pass Rate: $PASS_RATE%"
} > test_summary.txt
