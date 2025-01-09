#!/bin/bash

# Generate current timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Create HTML content
cat << EOF > reports/report.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mock Report</title>
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
    </style>
</head>
<body>
    <div class="header">
        <h1>System Status Report</h1>
        <p>Generated on: $TIMESTAMP</p>
    </div>
    
    <div class="content">
        <h2>System Information</h2>
        <table>
            <tr>
                <th>Metric</th>
                <th>Value</th>
            </tr>
            <tr>
                <td>Hostname</td>
                <td>$(hostname)</td>
            </tr>
            <tr>
                <td>Kernel Version</td>
                <td>$(uname -r)</td>
            </tr>
            <tr>
                <td>CPU Usage</td>
                <td>$(top -l 1 | grep "CPU usage" | awk '{print $3}')</td>
            </tr>
            <tr>
                <td>Memory Usage</td>
                <td>$(top -l 1 | grep "PhysMem" | awk '{print $2}')</td>
            </tr>
        </table>

        <h2>Disk Usage</h2>
        <table>
            <tr>
                <th>Filesystem</th>
                <th>Size</th>
                <th>Used</th>
                <th>Available</th>
            </tr>
            $(df -h | grep -v "Filesystem" | awk '{print "<tr><td>" $1 "</td><td>" $2 "</td><td>" $3 "</td><td>" $4 "</td></tr>"}')
        </table>
    </div>
</body>
</html>
EOF

echo "Report has been generated as report.html"