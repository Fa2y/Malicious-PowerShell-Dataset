Get-WMIObject Win32_ClassicCOMClassSetting | 
Where-Object { $_.InprocServer32 -ne $null -and -not (Test-Path $_.InprocServer32 -ErrorAction SilentlyContinue) } |
Select-Object ComponentID,InprocServer32 |
ForEach-Object { [System.Environment]::ExpandEnvironmentVariables($_.InprocServer32) + ',' + $_.ComponentID } |
Where-Object { $_.Length -gt 2 -and $_.Substring(0,2) -eq 'c:' } |
Get-Unique
