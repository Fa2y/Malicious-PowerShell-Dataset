#Progress bar
$TotalTasks = 184
$CurrentTask = 0

foreach ($Task in $Tasks) {
    $CurrentTask++
    $PercentComplete = ($CurrentTask / $TotalTasks) * 100
    Write-Progress -Activity "Performing tasks..." -Status "Task $CurrentTask of $TotalTasks" -PercentComplete $PercentComplete

    # perform task here...

    Start-Sleep -Milliseconds 100 # add 100ms delay between tasks
}


# Create a system restore point
Checkpoint-Computer -Description "Pre-configuration"

# Disable notifications
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" -Name "NOC_GLOBAL_SETTING_TOASTS_ENABLED" -Value 0

# Disable focus assist
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\FocusAssist" -Name "FocusAssistState" -Value 0

# Disable tablet mode
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "TabletMode" -Value 0

# Turn off projection
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Connect" -Name "AllowProjectionToThisDevice" -Value 0

# Turn off shared experiences
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" -Name "CdpSessionUserAuthzPolicy" -Value 0

# Disable remote desktop
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 1

# Disable offline maps
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Maps" -Name "AllowDownloadingAndUpdatingMaps" -Value 0

# Disable game bar
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0

# Turn off game DVR
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Name "AllowGameDVR" -Value 0

# Enable game mode
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Name "GameModeEnabled" -Value 1

# Disable TruePlay
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name "TruePlayEnabled" -Value 0

# Disable privacy settings
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Globalization" -Name "EnableDefaultLanguageDetection" -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Value 0
# Sends basic diagnostic data
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 1

# Disables inking and typing recognition
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Value 1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Value 1

# Disables tailored experiences
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Value 0

# Disables diagnostic data viewer and deletes all diagnostic data
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowUserControl" -Value 0
Get-ChildItem -Path "$env:ProgramData\Microsoft\Diagnosis" -Recurse | Remove-Item -Recurse -Force

# Disables location sharing
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableLocation" -Value 1

# Disables access to camera
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableCamera" -Value 0

# Changes visual effects in system properties
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewShadow" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewAlphaSelect" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewShadowText" -Value 1

# Adjusts processor scheduling to be best performance for programs
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 2

# Disable all start-up programs in Task Manager except for Windows Defender Notification and Realtek HD Audio Manager
Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" | Where-Object {$_.name -ne "WindowsDefenderNotificationIcon" -and $_.name -ne "RtHDVBg"} | Set-ItemProperty -Name "startupapproved" -Value 0
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" | Where-Object {$_.name -ne "WindowsDefenderNotificationIcon" -and $_.name -ne "RtHDVBg"} | Set-ItemProperty -Name "startupapproved" -Value 0

# Change the amount of processors in System Configuration to the maximum number of CPUs
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration" -Name "NumProc" -Value ([System.Environment]::ProcessorCount)

# Enable No GUI boot in System Configuration
bcdedit /set bootux standard
bcdedit /set quietboot on

# Check if script is running as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Restart script as administrator
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Run powercfg.exe command to set the active power scheme
Start-Process -FilePath "powercfg.exe" -ArgumentList "/setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c" -Verb RunAs

# Define registry key paths and values
$networkThrottlingKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\NetworkThrottlingIndex"
$networkThrottlingValue = "ffffffff"
$systemResponsivenessKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\SystemResponsiveness"
$systemResponsivenessValue = "0"

# Set NetworkThrottlingIndex value
Set-ItemProperty -Path $networkThrottlingKey -Name "NetworkThrottlingIndex" -Value $networkThrottlingValue

# Set SystemResponsiveness value
Set-ItemProperty -Path $systemResponsivenessKey -Name "SystemResponsiveness" -Value $systemResponsivenessValue

# Define registry key paths and values
$gpuPriorityKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
$gpuPriorityValue = "8"
$schedulingCategoryKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
$schedulingCategoryValue = "High"

# Set GPU Priority value
Set-ItemProperty -Path $gpuPriorityKey -Name "GPU Priority" -Value $gpuPriorityValue

# Set Scheduling Category value
Set-ItemProperty -Path $schedulingCategoryKey -Name "Scheduling Category" -Value $schedulingCategoryValue

# Check and optimize all drives
Optimize-Volume -DriveLetter (Get-Volume | Where-Object { $_.DriveType -eq 'Fixed' }).DriveLetter -Defrag -Verbose

# Run DISM to restore health
Start-Process -FilePath "cmd.exe" -ArgumentList "/c DISM /Online /Cleanup-image /Restorehealth" -Verb RunAs

# Set Ethernet advanced settings
$ethernetAdapter = Get-NetAdapter | Where-Object { $_.InterfaceDescription -Match "Ethernet" }

if ($ethernetAdapter) {
    Set-NetAdapterAdvancedProperty -Name $ethernetAdapter.Name -RegistryKeyword "*FlowControl" -RegistryValue 0 -Confirm:$false
    Set-NetAdapterAdvancedProperty -Name $ethernetAdapter.Name -RegistryKeyword "*EnergyEfficientEthernet" -RegistryValue 0 -Confirm:$false
    Set-NetAdapterAdvancedProperty -Name $ethernetAdapter.Name -RegistryKeyword "*GreenEthernet" -RegistryValue 0 -Confirm:$false
    Set-NetAdapterAdvancedProperty -Name $ethernetAdapter.Name -RegistryKeyword "*WakeOnMagicPacket" -RegistryValue 0 -Confirm:$false
}
else {
    Write-Warning "No Ethernet adapter found."
}
# Disable power saving on Ethernet adapters
Get-NetAdapterPowerManagement | Where-Object { $_.Name -like "*Ethernet*" } | Set-NetAdapterPowerManagement -Enabled $false

# Set bandwidth limit to 100%
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched" -Name sfc"NonBestEffortLimit" -Value 0

# Flush and register DNS, release and renew IP addresses, and reset Winsock
Start-Process -FilePath "cmd.exe" -ArgumentList "/c ipconfig /flushdns & ipconfig /registerdns & ipconfig /release & ipconfig /renew & netsh winsock reset" -Verb RunAs

# Delete files in prefetch folder
Remove-Item -Path "$env:SystemRoot\Prefetch\*" -Force -Recurse -Verbose

# Disable High Precision Event Timer
$hpets = Get-WmiObject -Class Win32_PnPEntity | Where-Object { $_.Name -like "*High Precision Event Timer*" }

if ($hpets) {
    $hpets | ForEach-Object { Disable-PnpDevice -InstanceId $_.DeviceID -Confirm:$false }
}

# Run SFC scan
Start-Process -FilePath "cmd.exe" -ArgumentList "/c sfc /scannow" -Verb RunAs
