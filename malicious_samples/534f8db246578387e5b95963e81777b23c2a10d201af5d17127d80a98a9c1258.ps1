Start-Process notepad.exe

Start-Sleep -Seconds 3

New-Item "C:\temp\keylogger.txt" -ItemType "file"

$foregroundWindow = Get-ForegroundWindow
if ($foregroundWindow) {
    $echo = (Get-WindowStation | Select-Object -ExpandProperty Processes | Where-Object {$_.MainWindowHandle -eq $foregroundWindow} | Select-Object -ExpandProperty MainWindowTitle)
    echo $echo > "C:\temp\keylogger.txt"
    notepad "C:\temp\keylogger.txt"
}