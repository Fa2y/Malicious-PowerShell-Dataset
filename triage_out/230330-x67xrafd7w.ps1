<# 
--------------------------------------------
This script gets the current date and time, a list of all installed software and their versions, a list of all drivers, and basic system information using the Get-WmiObject cmdlet. It then outputs this information to the CSV file using the Add-Content cmdlet before outputting the file tree and hash list to the same CSV file using the Export-Csv cmdlet.

The system information, installed software, and drivers are output first, followed by the file tree and hash list. The -Append parameter is used with Export-Csv to append the hash list to the end of the CSV file after the system information, installed software, and drivers. 
--------------------------------------------
#>



# Set the path to the root directory of the Windows golden image
$rootDirectory = "C:\"

# Get the current date and time
$date = Get-Date

# Get a list of all installed software and their versions
$software = Get-WmiObject -Class Win32_Product | Select-Object Name, Version

# Get a list of all drivers
$drivers = Get-WmiObject -Class Win32_PnPSignedDriver | Select-Object DeviceName, Manufacturer, DriverVersion, DriverDate

# Get basic system information
$systemInfo = Get-WmiObject -Class Win32_ComputerSystem | Select-Object Name, Manufacturer, Model, TotalPhysicalMemory

# Get all files and folders in the root directory and its subdirectories
$files = Get-ChildItem $rootDirectory -Recurse

# Loop through each file and generate its hash value
$hashList = foreach ($file in $files) {
    $hash = Get-FileHash $file.FullName -Algorithm SHA256
    [PSCustomObject]@{
        FilePath = $file.FullName
        Hash = $hash.Hash
    }
}

# Output the system information, installed software, drivers, file tree, and hash list to a CSV file
$systemInfo | Select-Object Name, Manufacturer, Model, TotalPhysicalMemory | Add-Content -Path "C:\KnownGoodHashList.csv"
$software | Add-Content -Path "C:\KnownGoodHashList.csv"
$drivers | Add-Content -Path "C:\KnownGoodHashList.csv"
$hashList | Export-Csv -Path "C:\KnownGoodHashList.csv" -NoTypeInformation -Append

Write-Host "Execution completed on $date"



