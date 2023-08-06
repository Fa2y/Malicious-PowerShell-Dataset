Start-Process notepad.exe -WindowStyle Minimized
Start-Sleep -Seconds 5
$foregroundWindow = Get-ForegroundWindow
if ($foregroundWindow) {
    $echo = (Get-WindowStation | Select-Object -ExpandProperty Processes | Where-Object {$_.MainWindowHandle -eq $foregroundWindow} | Select-Object -ExpandProperty MainWindowTitle)
    echo $echo > "C:\Users\$env:UserName\Desktop\test.log"
    notepad "C:\Users\$env:UserName\Desktop\test.log"
}
