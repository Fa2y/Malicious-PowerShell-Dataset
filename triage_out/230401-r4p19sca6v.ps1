Start-Sleep -Seconds 5
$wshell = New-Object -ComObject WScript.Shell
$wshell.Popup("Your computer has a virus!",0,"Warning",0x30)
