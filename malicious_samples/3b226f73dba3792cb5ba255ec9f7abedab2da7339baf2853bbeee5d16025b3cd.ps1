Set-ExecutionPolicy Unrestricted -Force
$WshShell = New-Object -comObject WScript.Shell
$WshShell.Popup("Your computer has been infected with a virus. Please contact the system administrator for assistance.",0,"Warning",0x1)