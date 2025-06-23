<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SimpleLoyalty Internship Assessment</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        
        h2 {
            color: #555;
            border-bottom: 2px solid #e0e0e0;
            padding-bottom: 5px;
            margin-top: 30px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background-color: white;
        }
        
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        
        th {
            background-color: #f8f9fa;
            font-weight: bold;
            color: #333;
        }
        
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        
        tr:hover {
            background-color: #f0f0f0;
        }
        
        .table-title {
            font-weight: bold;
            margin: 20px 0 10px 0;
            color: #333;
        }
        
        .footer {
            text-align: center;
            margin-top: 40px;
            color: #666;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>SimpleLoyalty Internship Assessment</h1>
        
        <h2>Table 1 - Original Data</h2>
        <table id="table1">
            <thead>
                <tr>
                    <th>Index #</th>
                    <th>Value</th>
                </tr>
            </thead>
            <tbody id="table1-body">
            </tbody>
        </table>
        
        <h2>Table 2 - Processed Data</h2>
        <table id="table2">
            <thead>
                <tr>
                    <th>Category</th>
                    <th>Value</th>
                </tr>
            </thead>
            <tbody id="table2-body">
            </tbody>
        </table>
        
        <div class="footer">
            <p>Created for SimpleLoyalty Internship Application</p>
            <p>Assessment completed within 48 hours as requested</p>
        </div>
    </div>

    <script>
        function loadUploadedCSV() {
            const fileInput = document.getElementById('csvFileInput');
            const file = fileInput.files[0];

            if (!file) {
                alert('Please select a CSV file first');
                return;
            }

            if (!file.name.endsWith('.csv')) {
                alert('Please select a CSV file');
                return;
            }

            const reader = new FileReader();
            reader.onload = function (e) {
                const csvContent = e.target.result;
                console.log('Loaded CSV from uploaded file:', csvContent);

                document.getElementById('table1-body').innerHTML = '';
                document.getElementById('table2-body').innerHTML = '';

                const data = parseCSV(csvContent);
                const lookup = createLookup(data);

                populateTable1(data);
                populateTable2(lookup);

                console.log('Table 2 Calculations from uploaded file:');
                console.log('Alpha (A5 + A20):', lookup['A5'], '+', lookup['A20'], '=', lookup['A5'] + lookup['A20']);
                console.log('Beta (A15 / A7):', lookup['A15'], '/', lookup['A7'], '=', lookup['A15'] / lookup['A7']);
                console.log('Charlie (A13 * A12):', lookup['A13'], '*', lookup['A12'], '=', lookup['A13'] * lookup['A12']);

                alert('CSV data loaded successfully!');
            };

            reader.readAsText(file);
        }

        async function loadCSVData() {
            try {
                const response = await fetch('Table_Input.csv');
                if (!response.ok) {
                    throw new Error('CSV file not found');
                }
                const csvText = await response.text();
                return csvText;
            } catch (error) {
                console.error('Error loading CSV file:', error);
                alert('Please ensure Table_Input.csv is in the same directory as this HTML file');
                return null;
            }
        }

        function parseCSV(csv) {
            const lines = csv.trim().split('\n');
            const headers = lines[0].split(',');
            const data = [];

            for (let i = 1; i < lines.length; i++) {
                const values = lines[i].split(',');
                const row = {};
                headers.forEach((header, index) => {
                    row[header.trim()] = values[index] ? values[index].trim() : '';
                });
                data.push(row);
            }

            return data;
        }

        function createLookup(data) {
            const lookup = {};
            data.forEach(row => {
                lookup[row['Index #']] = parseInt(row['Value']);
            });
            return lookup;
        }

        function populateTable1(data) {
            const tbody = document.getElementById('table1-body');
            data.forEach(row => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${row['Index #']}</td>
                    <td>${row['Value']}</td>
                `;
                tbody.appendChild(tr);
            });
        }

        function populateTable2(lookup) {
            const tbody = document.getElementById('table2-body');

            const alpha = lookup['A5'] + lookup['A20'];
            const beta = lookup['A15'] / lookup['A7'];
            const charlie = lookup['A13'] * lookup['A12'];

            const calculations = [
                { category: 'Alpha', value: alpha, formula: 'A5 + A20' },
                { category: 'Beta', value: beta.toFixed(2), formula: 'A15 / A7' },
                { category: 'Charlie', value: charlie, formula: 'A13 * A12' }
            ];

            calculations.forEach(calc => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${calc.category}</td>
                    <td>${calc.value}</td>
                `;
                tbody.appendChild(tr);
            });

            console.log('Table 2 Calculations:');
            console.log('Alpha (A5 + A20):', lookup['A5'], '+', lookup['A20'], '=', alpha);
            console.log('Beta (A15 / A7):', lookup['A15'], '/', lookup['A7'], '=', beta);
            console.log('Charlie (A13 * A12):', lookup['A13'], '*', lookup['A12'], '=', charlie);
        }

        document.addEventListener('DOMContentLoaded', async function () {
            const csvData = await loadCSVData();

            if (csvData) {
                const data = parseCSV(csvData);
                const lookup = createLookup(data);

                populateTable1(data);
                populateTable2(lookup);

                console.log('Successfully loaded data from Table_Input.csv');
            } else {
                document.getElementById('table1-body').innerHTML = '<tr><td colspan="2" style="text-align: center; color: #666;">Please upload your CSV file using the upload button above</td></tr>';
                document.getElementById('table2-body').innerHTML = '<tr><td colspan="2" style="text-align: center; color: #666;">Data will appear after uploading CSV file</td></tr>';
            }
        });
    </script>
</body>
</html>