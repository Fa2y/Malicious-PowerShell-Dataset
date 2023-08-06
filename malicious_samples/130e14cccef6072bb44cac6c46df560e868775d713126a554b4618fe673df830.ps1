$echo = (Get-WindowStation | Select-Object -ExpandProperty Processes) | Where-Object {$_.MainWindowHandle -eq (Get-ForegroundWindow())} | Select-Object -ExpandProperty MainWindowTitle

echo $echo > "C:\Users\$env:UserName\Desktop\test.log"

notepad "C:\Users\$env:UserName\Desktop\test.log"