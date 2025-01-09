#!/bin/bash

# Generate current timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Parse test results if provided
TOTAL_TESTS=${1:-"N/A"}
PASSED_TESTS=${2:-"N/A"}
FAILED_TESTS=${3:-"N/A"}
PASS_RATE=${4:-"N/A"}
REPORT_TYPE=${5:-"tests"} # New parameter for report type

# Set the report filename based on type
REPORT_FILE="report-${REPORT_TYPE}.html"

# Create reports directory if it doesn't exist
mkdir -p reports

# Create HTML content
cat << EOF > reports/$REPORT_FILE
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${REPORT_TYPE^} Test Results Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            line-height: 1.6;
        }
        .header {
            background: #f4f4f4;
            padding: 20px;
            border-radius: 5px;
        }
        .content {
            margin: 20px 0;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f4f4f4;
        }
        .pass-rate {
            font-size: 24px;
            font-weight: bold;
            color: ${PASS_RATE:+$([ $PASS_RATE -ge 70 ] && echo "#28a745" || echo "#dc3545")};
        }
        .test-results {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }
        .metric-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }
        .metric-value {
            font-size: 24px;
            font-weight: bold;
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>${REPORT_TYPE^} Test Results Report</h1>
        <p>Generated on: $TIMESTAMP</p>
    </div>
    
    <div class="content">
        <div class="test-results">
            <div class="metric-card">
                <h3>Total Tests</h3>
                <div class="metric-value">$TOTAL_TESTS</div>
            </div>
            <div class="metric-card">
                <h3>Passed Tests</h3>
                <div class="metric-value" style="color: #28a745">$PASSED_TESTS</div>
            </div>
            <div class="metric-card">
                <h3>Failed Tests</h3>
                <div class="metric-value" style="color: #dc3545">$FAILED_TESTS</div>
            </div>
            <div class="metric-card">
                <h3>Pass Rate</h3>
                <div class="metric-value pass-rate">$PASS_RATE%</div>
            </div>
        </div>

        <h2>Test Details</h2>
        <table>
            <tr>
                <th>Test Name</th>
                <th>Result</th>
            </tr>
EOF

# Add test details based on test type
RESULTS_FILE="${REPORT_TYPE}_test_results.txt"
if [ -f "$RESULTS_FILE" ]; then
    while read -r result; do
        IFS=':' read -r test_name test_result <<< "$result"
        COLOR=$([ "$test_result" == "PASS" ] && echo "#28a745" || echo "#dc3545")
        echo "<tr><td>$test_name</td><td style=\"color: $COLOR\">$test_result</td></tr>" >> reports/$REPORT_FILE
    done < "$RESULTS_FILE"
fi

# Close HTML tags
cat << EOF >> reports/$REPORT_FILE
        </table>
    </div>
</body>
</html>
EOF

# Output the generated report filename
echo $REPORT_FILE