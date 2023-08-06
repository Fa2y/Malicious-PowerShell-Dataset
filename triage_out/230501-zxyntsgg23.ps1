$file = "C:\Users\Ralty\Downloads\bitwarden_export_20230501200522.csv"
$duplicates = @()
$seen = @{}

# Read the first line of the file to get the column names
$columns = (Get-Content $file -First 1).Split(',')

# Read the CSV file
$csv = Import-Csv $file

# Check for duplicate rows
foreach ($line in $csv) {
    $key = ""
    foreach ($col in $columns) {
        $key += $line.$col + ","
    }
    
    $key = $key.TrimEnd(",")

    if ($seen.ContainsKey($key)) {
    $duplicates += $line
    } else {
        $seen.Add($key, $null)
    }
}

# Remove the duplicate rows from the CSV
$csv = $csv | Where-Object { $duplicates -notcontains $_ }
$csv | Export-Csv $file -NoTypeInformation