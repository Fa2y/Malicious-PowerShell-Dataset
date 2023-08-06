Get-WmiObject Win32_Service | 
Where-Object { -not [System.String]::IsNullOrEmpty($_.PathName) } |
Where-Object { $_.PathName.Contains(' ') -and -not $_.PathName.Contains('"') } |
Where-Object { -not ($_.PathName.ToUpper().Contains("SYSTEM32") -or $_.PathName.ToUpper().Contains("SYSWOW64")) } |
Select-Object Name,StartMode,State,PathName
