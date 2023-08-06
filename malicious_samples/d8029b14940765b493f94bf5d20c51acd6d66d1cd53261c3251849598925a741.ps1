function Invoke-Sysinfo {
<# 

.SYNOPSIS
	Obtains information about the system, its users, software and other functions.

.PARAMETER Help
	Shows Detailed Help.

.PARAMETER List
	Shows Brief Command Help.

.PARAMETER Os
	Retrieves basic operating system information.
	
.PARAMETER Env
	Retrieves environment variable information.
	
.PARAMETER Arch
	Retrieves system architecture. 
	
.PARAMETER Drives
	Retrieves any drives on the system.
	
.PARAMETER Users
	Retrieves a list of local users.
	
.PARAMETER LocalAdmins
	Retrieves a list of local administrators.
	
.PARAMETER DomainAdmins
	If connected to an Active Directory domain, will retrieve a list of Domain Administrators.
	
.PARAMETER Privs
	Displays the current users' privileges.
	
.PARAMETER HotFixes
	Retrieves a list of hotfixes installed on the system.
	
.PARAMETER CheckElevated
	Checks if current users' PowerShell process is elevated.
	
.PARAMETER Shares
	Displays Shares

.PARAMETER LoggedOn

	Displays current interactively logged-on users.

.PARAMETER Apps

	Displays all installed applications.

.PARAMETER Procs

	Displays running processes.

.PARAMETER Services

	Displays services.

.PARAMETER Tasks
	Displays scheduled tasks.

.PARAMETER Av

	Displays currently installed Antivirus software.

.PARAMETER LangMode
	Checks current PowerShell language mode.

.PARAMETER PsVersion
	Checks PowerShell version for the current session.

.PARAMETER DnsCache
	Dumps local client DNS Cache.

.PARAMETER PsHistory
	Obtains the PowerShell history from the ConsoleHost_history.txt file.
	
.PARAMETER ClipBoard
	Dumps current clipboard contents.
	
.PARAMETER RecentDocs
	Dumps recently accessed documents.
	
.PARAMETER IpConfig
	Displays network interfaces information.

.PARAMETER NetStat
	Displays all active network connections.
	
.PARAMETER IEFavorites
	Dumps Internet Explorer Favorites / URLS

.PARAMETER DumpAll
	Dumps all of the above modules into a sysinfo.txt file.

.EXAMPLE 
	PS> Invoke-Sysinfo -Av
	
.EXAMPLE
	PS> Invoke-Sysinfo -PsHistory | Select-String "password"
	
.EXAMPLE 
	PS> Invoke-Sysinfo -Os | Out-File C:\temp\os.txt

.NOTES
	Author: Fabrizio Siciliano (@0rbz_)

#>

[CmdletBinding()]
param (
	[Switch]$Help,
	[Switch]$List,
	[Switch]$Os,
	[Switch]$Env,
	[Switch]$Arch,
	[Switch]$Drives,
	[Switch]$Users,
	[Switch]$LocalAdmins,
	[Switch]$DomainAdmins,
	[Switch]$Privs,
	[Switch]$Hotfixes,
	[Switch]$CheckElevated,
	[Switch]$Shares,
	[Switch]$LoggedOn,
	[Switch]$Apps,
	[Switch]$Procs,
	[Switch]$Services,
	[Switch]$Tasks,
	[Switch]$Av,
	[Switch]$LangMode,
	[Switch]$PsVersion,
	[Switch]$DnsCache,
	[Switch]$PsHistory,
	[Switch]$ClipBoard,
	[Switch]$RecentDocs,
	[Switch]$IpConfig,
	[Switch]$NetStat,
	[Switch]$IEFavorites,
	[Switch]$DumpAll
)

	if ($Help -eq $true -or $List -eq $True) {
	
		Write @"

 ### Invoke-Sysinfo Help ###
 ---------------------------
 
 Invoke-Sysinfo [-command]
 
 Example: Invoke-Sysinfo -Os
 Example: Invoke-Sysinfo -Os | Out-File C:\temp\os.txt
 Example: Invoke-Sysinfo -Env
 Example: Invoke-Sysinfo -LangMode
 Example: Invoke-Sysinfo -PsHistory |Select-String "password"
 
 SYSINFO Command List:
 ---------------------
 |---------------------------------------------------------------------|
 
  -Os             (Displays Basic Operating System Information)       
  -Env            (Displays Environment Variables Information)
  -Arch           (Displays system architecture)  
  -Drives         (Displays current drives)                           
  -Users          (Displays Users)                                    
  -LocalAdmins    (Displays local admins)                             
  -DomainAdmins   (Displays Domain Admins)                            
  -Privs          (Displays current user privileges)                  
  -HotFixes       (Displays installed hotfixes)                       
  -CheckElevated  (Checks if current user PS process is elevated)     
  -Shares         (Displays shared drives on the system)              
  -LoggedOn       (Displays currently interactively logged-on users)  
  -Apps           (Retrieves installed applications)                  
  -Procs          (Displays current running processes)                
  -Services       (Displays current running and stopped services)     
  -Tasks          (Displays non-Microsoft scheduled tasks)            
  -Av             (Retrieves installed AntiVirus software information)
  -LangMode       (Checks powershell current language mode)           
  -PsVersion      (Displays PowerShell version)                       
  -DnsCache       (Dumps DNS Cache)                                   
  -PsHistory      (Dumps PowerShell Commandline History)              
  -ClipBoard      (Dumps Clipboard Contents)      
  -RecentDocs     (Dumps recently accessed files)
  -IpConfig       (Dumps Network Interface Information)               
  -NetStat        (Dumps Active Network Connection information)  
  -IEFavorites    (Dumps Internet Explorer Favorites/Bookmarks)
  -DumpAll        (Dumps all of the above modules information into    
                   %appdata%\sysinfo.txt)                             
				   
 \---------------------------------------------------------------------/
 
"@
	}
	
	elseif ($Os) {
		$h = "`n### Invoke-Sysinfo(Os) ###`n"
		$h
		get-wmiobject win32_operatingsystem | Select-Object Caption, Version, OSArchitecture, ServicePackMajorVersion, ServicePackMinorVersion, MUILanguages, LastBootUpTime, LocalDateTime, NumberOfUsers, SystemDirectory
		$h
	}
	elseif ($Env) {
		$h = "`n### Invoke-Sysinfo(Env) ###`n"
		$h
		Get-ChildItem Env: | ft Key,Value
		$h
	}
	elseif ($Arch) {
		if ($(Get-WmiObject -Query "SELECT * FROM Win32_Processor WHERE AddressWidth='64'")) {
			Write "`n [+] x64 Architecture detected.`n"
		}
		else {
			Write "`n [+] Likely x86.`n"
		}
	}
	elseif ($Drives) {
		$h = "`n### Invoke-Sysinfo(Drives) ###`n"
		$h
		Get-PSDrive | where {$_.Provider -like 'Microsoft.PowerShell.Core\FileSystem'} | ft Name,Root
		$h
	}
	elseif ($Users) {
		$h = "`n### Invoke-Sysinfo(Users) ###`n"
		$h
		Get-WmiObject -Class Win32_UserAccount -Filter  "LocalAccount='True'" | select name, fullname
		$h 
	}
	elseif ($LocalAdmins) {
		$h = "`n### Invoke-Sysinfo(LocalAdmins) ###`n"
		$h
		(get-wmiobject win32_group -filter "name='Administrators'").GetRelated("win32_useraccount")
		$h
	}
	
	elseif ($DomainAdmins) {
		$h = "`n### Invoke-Sysinfo(DomainAdmins) ###`n"
		$h
		(C:\??*?\*3?\n?t.?x? group "Domain Admins" /domain)
		$h
	}
	
	elseif ($Privs) {
		$h = "`n### Invoke-Sysinfo(Privs) ###`n"
		$h
		(C:\??*?\*3?\wh??m?.?x? /priv)
		$h
	}
	
	elseif ($HotFixes) {
		$h = "`n### Invoke-Sysinfo(HotFixes) ###`n"
		$h
		(Get-Hotfix | Sort-Object -Descending)
		$h
	}
	
	elseif ($CheckElevated) {
		$h = "`n### Invoke-Sysinfo(CheckElevated) ###`n"
		$check = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
		if ($check -eq $true) {
			$h
			Write " [+] We're running as an elevated process."
			$h
		}
		if ($check -eq $false) {
			$h
			Write " [-] Not Elevated."
			$h
		}
	}
	
	elseif ($Shares) {
		$h = "`n### Invoke-Sysinfo(Shares) ###`n"
		$h
		Get-WmiObject Win32_Share
		$h
	}
	
	elseif ($LoggedOn) {
	# https://social.technet.microsoft.com/Forums/forefront/en-US/6bf4194e-36d4-4fd1-96d6-40ebb9498424/powershell-script-list-all-remote-users-connected-via-rdp-with-details-like-remote-workstation
		$h = "`n### Invoke-Sysinfo(LoggedOn) ###`n"
		$Explorer = (Get-WmiObject -Query "select * from Win32_Process where Name='explorer.exe'")
	
		if (!$Explorer) {
		$h
		Write " [-] No users currently interactively logged on."
		$h
		}
			else {
				foreach ($p in $Explorer) {
				$Username = $p.GetOwner().User
				$Domain = $p.GetOwner().Domain
				$h
				Write " User: $Domain\$Username`n Logon Time: $($p.ConvertToDateTime($p.CreationDate))"
				$h
			}
		}
	}
	
	elseif ($Apps) {
		$h = "`n### Invoke-Sysinfo(Apps) ###`n"
		$h
		Get-ChildItem 'C:\Program Files', 'C:\Program Files (x86)' | Format-Table Parent,Name,LastWriteTime
		$h
	}
	
	elseif ($Procs) {
		$h = "`n### Invoke-Sysinfo(Procs) ###`n"
		$h
		Get-WmiObject -Query 'Select * from Win32_Process' | where {$_.Name -notlike 'svchost*'} | Select Name, Handle, @{Label='Owner';Expression={$_.GetOwner().User}} | Format-Table -AutoSize
		$h
	}
	
	elseif ($Services) {
		$h = "`n### Invoke-Sysinfo(Services) ###`n"
		$h
		Get-WmiObject win32_service | Select-Object Name, DisplayName, @{Name="Path"; Expression={$_.PathName.split('"')[1]}}, State | Format-List
		$h
	}
	
	elseif ($Tasks) {
		$h = "`n### Invoke-Sysinfo(Tasks) ###`n"
		$h
		(Get-ChildItem C:\windows\system32\tasks |fl -Property Name,FullName)
		$h
	}
	
	elseif ($Av) {
	# https://stackoverflow.com/questions/33649043/powershell-how-to-get-antivirus-product-details#37842942
	[parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
	[Alias('name')]
	$computername=$env:computername
	$AntiVirusProducts = Get-WmiObject -Namespace "root\SecurityCenter2" -Class AntiVirusProduct  -ComputerName $computername

		$ret = @()
		foreach($AntiVirusProduct in $AntiVirusProducts){
			switch ($AntiVirusProduct.productState) {
			"262144" {$defstatus = "Up to date" ;$rtstatus = "Disabled"}
			"262160" {$defstatus = "Out of date" ;$rtstatus = "Disabled"}
			"266240" {$defstatus = "Up to date" ;$rtstatus = "Enabled"}
			"266256" {$defstatus = "Out of date" ;$rtstatus = "Enabled"}
			"393216" {$defstatus = "Up to date" ;$rtstatus = "Disabled"}
			"393232" {$defstatus = "Out of date" ;$rtstatus = "Disabled"}
			"393488" {$defstatus = "Out of date" ;$rtstatus = "Disabled"}
			"397312" {$defstatus = "Up to date" ;$rtstatus = "Enabled"}
			"397328" {$defstatus = "Out of date" ;$rtstatus = "Enabled"}
			"397584" {$defstatus = "Out of date" ;$rtstatus = "Enabled"}
			default {$defstatus = "Unknown" ;$rtstatus = "Unknown"}
			}
			#Create hash-table for each computer
			$ht = @{}
			$ht.Computername = $computername
			$ht.Name = $AntiVirusProduct.displayName
			$ht.'Product GUID' = $AntiVirusProduct.instanceGuid
			$ht.'Product Executable' = $AntiVirusProduct.pathToSignedProductExe
			$ht.'Reporting Exe' = $AntiVirusProduct.pathToSignedReportingExe
			$ht.'Definition Status' = $defstatus
			$ht.'Real-time Protection Status' = $rtstatus

			#Create a new object for each computer
			$ret += New-Object -TypeName PSObject -Property $ht
		}
		Write "`n### Invoke-Sysinfo(Av) ###"
		Return $ret
	}
	
	elseif ($LangMode) {
		$h = "`n### Invoke-Sysinfo(LangMode) ###`n"
		$h
		$ExecutionContext.SessionState.LanguageMode
		$h
	}
	
	elseif ($PsVersion) {
		$h = "`n### Invoke-Sysinfo(PsVersion) ###`n"
		$h
		Write $psversiontable
		$h
	}
	
	elseif ($DnsCache) {
		$h = "`n### Invoke-Sysinfo(DnsCache) ###`n"
		if ($PSVersionTable.PSVersion.Major -eq "2") {
			$h
			Write " [!] This function requires PowerShell version greater than 2.0."
			$h
			return
		}
		else {
			$h
			Get-DnsClientCache
			$h
		}
	}
	elseif ($PsHistory) {
	# https://twitter.com/mattifestation/status/740242366754226176
		$h = "`n### Invoke-Sysinfo(PsHistory) ###`n"
		$h
		(Get-Content "$env:appdata\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt")
		$h
	}
	elseif ($ClipBoard) {
		$h = "`n### Invoke-Sysinfo(ClipBoard) ###`n"
		$h
		Get-ClipBoard -Raw
		$h
	}
	elseif ($RecentDocs) {
	
		(Get-ChildItem $env:appdata\Microsoft\Windows\Recent\)
		
	}
	elseif ($IpConfig) {
		(ipconfig /all)
	}
	elseif ($NetStat) {
		(netstat -an)
	}
	elseif ($IEFavorites) {
		
		$Favorites = [Environment]::GetFolderPath('Favorites')
		$UrlFiles = (Get-ChildItem -Recurse -File $Favorites).FullName
		$h = "`n### Invoke-Sysinfo(IEFavorites) ###`n"
		$h
		foreach ($Url in $UrlFiles) {
			$Urlx = Get-Content $Url | Select-String -Pattern "URL"
			$Urlx -replace "URL="
		}	
		Write-Output "`n"
	}
	elseif ($DumpAll) {
		$h = "`n### Invoke-Sysinfo(DumpAll) ###`n"
		$h
		(Invoke-Sysinfo -Os | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -Env | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -Arch | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -Drives | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -Users | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -LocalAdmins | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -DomainAdmins | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -Privs | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -HotFixes | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -CheckElevated | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -Shares | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -LoggedOn | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -Apps | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -Procs | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -Services | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -Tasks | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -Av | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -LangMode | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -PsVersion | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -DnsCache | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -PsHistory | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -ClipBoard | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -RecentDocs | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -IpConfig | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -NetStat | out-file $env:temp\sysinfo.txt -Append)
		(Invoke-Sysinfo -IEFavorites | out-file $env:temp\sysinfo.txt -Append)
    
		Write "All modules dumped to $env:temp\sysinfo.txt"
		$h	
	}
}