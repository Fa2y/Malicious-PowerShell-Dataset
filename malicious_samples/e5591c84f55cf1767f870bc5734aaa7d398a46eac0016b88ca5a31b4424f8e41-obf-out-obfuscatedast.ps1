function Get-TargetInfo($Session) {
    Set-Variable -Name tmpDir -Value ("$env:TEMP\")
    Set-Variable -Name isElevated -Value ($false)
    Set-Variable -Name targetHostname -Value (hostname)
    Set-Variable -Name targetUser -Value (whoami)
    if ($Session) {
        $targetPlatform, $isElevated, $tmpDir, $targetHostname, $targetUser = invoke-command -Session $Session -ScriptBlock {
            $targetPlatform = "windows"
            $tmpDir = "/tmp/"
            $targetHostname = hostname
            $targetUser = whoami
            if ($IsLinux) { $targetPlatform = "linux" }
            elseif ($IsMacOS) { $targetPlatform =  "macos" }
            else {  # windows
                $tmpDir = "$env:TEMP\"
                $isElevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
            }
            if ($IsLinux -or $IsMacOS) {
                $isElevated = $false
                $privid = id -u                
                if ($privid -eq 0) { $isElevated = $true }
            }
            $targetPlatform, $isElevated, $tmpDir, $targetHostname, $targetUser
        } # end ScriptBlock for remote session
    }
    else {
        Set-Variable -Name targetPlatform -Value ("linux")
        if ($IsLinux -or $IsMacOS) {
            $tmpDir = "/tmp/"
            $isElevated = $false
            $privid = id -u                
            if ($privid -eq 0) { $isElevated = $true }
            if ($IsMacOS) { $targetPlatform = "macos" }
        }
        else {
            Set-Variable -Name targetPlatform -Value ("windows")
            Set-Variable -Name isElevated -Value (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
        }
      
    }
    $targetPlatform, $isElevated, $tmpDir, $targetHostname, $targetUser
} 
