Write-Host "TempleOS Win Auto Installer
Version 1.0 | xzntrc.xyz
"
Start-Sleep -Seconds 0.1

Function Exists
{
    param (
        [string[]]$command
    )
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    if($command -eq "scoop"){
        try {if(Get-Command "scoop"){Write-Host "Scoop found. moving onto QEMU!"}}
        Catch {Write-Host "Scoop is needed to install QEMU, Installing now..."; Set-ExecutionPolicy RemoteSigned -Scope CurrentUse; irm get.scoop.sh | iex; Write-Host "Installed Scoop"}
        Finally {$ErrorActionPreference=$oldPreference}
    }  ElseIf ($command -eq "qemu"){
        try {if(Get-Command "qemu-img"){Write-Host "QEMU found. Proceeding"}}
        Catch {Write-Host "QEMU not found."; Exists -command "scoop"; scoop install qemu; Write-Host "Proceeding"}
        Finally {$ErrorActionPreference=$oldPreference}

    }
} 
Exists -command "qemu";

# Downloading Portion
## Code downloads a preinstalled version of TempleOS (qcow2) thus saving install speed. Additionally GitHub (host) has nodes, and download is fasster.
## Powershell's curl is not actually curl, it's a alias to another command that requires Internet Explorer; otherwise is incredibly slow. So I'm routing it to CMD.
Write-Host "Downloading TempleOS ISO"
New-Item -ItemType Directory -Force -Path ~/TempleOS | out-null
cmd /c 'curl https://raw.githubusercontent.com/TempleOS-Simplified/ISOs/main/temple >> %HOMEPATH%/TempleOS/temple' # cmd doesn't support `~`.
Write-Host "Downloaded. Proceeding with VM Setup."
# Your sys:
$yRam = [math]::Round((Get-WmiObject -Class Win32_physicalmemory).capacity/1024/1024,2) # This is a mess
$yCpu = $env:NUMBER_OF_PROCESSORS # Eh just shortening

Write-Host "VM Settings"
Write-Host "Don't enter 'GB' or 'MB'; just the number."
$ram = Read-Host -Prompt "Max RAM (MB: 512-$yRam)"
$cpu = Read-Host -Prompt "Processors (1-$yCpu)"

chdir ~/TempleOS
# Boot time :D
Write-Host "
Success! TempleOS should now boot.
Whenever you want to launch TempleOS in future, run the script:
$home\TempleOS\launch.ps1
"
echo "qemu-system-x86_64 -m $ram -smp $cpu -drive file=temple" | Out-File ~/TempleOS/launch.ps1
qemu-system-x86_64 -m $ram -smp $cpu -drive file=temple
Read-Host -Prompt "Press any key to exit"