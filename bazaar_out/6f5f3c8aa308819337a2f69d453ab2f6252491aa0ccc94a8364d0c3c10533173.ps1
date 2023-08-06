#Software hide duplicate	=IF(AND(A2=A1, B2=B1),"hide","show")
#Disk Size summ				=IF(A2=A1,C2+C1,C2)
#Disk Busy summ				=IF(B2=B1,D2+D1,D2)
#Disk duplicate hide		=IF(A2=A1,"hide","show")
param ([String[]]$GrubType)
$compsfile= "./comps*"
if ((Get-ChildItem) -match 'result'){Remove-Item -Force -Recurse ./result*}
New-Item -path .\ -type directory -name result

function Test-LHosts{
$erroractionpreference = "SilentlyContinue"
$testcomputers = Get-Content -Path $compsfile -ReadCount 0
$test_computer_count = $testcomputers.Length
$x = 0
write-host -foregroundcolor cyan ""
write-host -foregroundcolor cyan "Testing $test_computer_count computers."
foreach ($computer in $testcomputers) {
	if (Test-Connection -ComputerName $computer -Quiet -count 2 -BufferSize 4 ){
		Add-Content -value $computer -path .\result\livePCs.txt
		}else{
		Add-Content -value $computer -path .\result\deadPCs.txt
		}
    $testcomputer_progress = [int][Math]::Ceiling((($x / $test_computer_count) * 100))
	# Progress bar
    Write-Progress  "Testing Connections" -PercentComplete $testcomputer_progress -Status "Percent Complete - $testcomputer_progress%" -Id 1;
	Sleep(1);
    $x++;
 
}  
 
write-host -foregroundcolor cyan ""
write-host -foregroundcolor cyan "Testing Connection complete"
write-host -foregroundcolor cyan ""}
function Get-Diskinfo{
$computername = Get-Content ".\result\livePCs.txt" -ReadCount 0
$ErrorActionPreference = "Stop"
$computers = $computername.Length
$x = 0;
write-host -foregroundcolor cyan "Grubbing Disk.info complete"
write-host -foregroundcolor cyan "Testing $computers computers, this may take a while."
foreach ($computer in $computername)
	{
		if (Test-Connection -ComputerName $computer -Quiet -count 2 -BufferSize 4 -Delay 1){
			Try{Get-WmiObject Win32_LogicalDisk -filter "DriveType=3" -computer $computer | Select SystemName,DeviceID,@{Name="Size(GB)";Expression={"{0:N1}" -f($_.size/1gb)}},@{Name="Busy(GB)";Expression={"{0:N1}" -f(($_.size - $_.freespace)/1gb)}}} 
Catch {Add-Content "$computer is not reachable" -path .\result\error.txt}
$testcomputer_progress = [int][Math]::Ceiling((($x / $computers) * 100))
# Progress bar
	Write-Progress  "Grubbin Disk Info" -PercentComplete $testcomputer_progress -Status "Percent Complete - $testcomputer_progress%" -Id 1;
	Sleep(1);
	$x++; 
}else{Add-Content "$computer is not reachable" -path .\result\error.txt}
}
write-host -foregroundcolor cyan "Grubbing Disk.info complete"}
function Get-Software{
<#Variables#>

$av_list = @("Traps", "threat", "Sentinel", "Defence", "Defender", "Endpoint", "AV", "AntiVirus", "BitDefender", "Kaspersky", "Norton", "Avast", "WebRoo", "AVG", "ESET", "Malware", "Defender", "Sophos", "Trend", "Symantec Endpoint Protection", "Security")
$backup_list = @("Veeam", "Backup", "Recovery", "Synology", "C2", "Cloud", "Dropbox", "Acronis", "Cobian", "EaseUS", "Paragon", "IDrive" )
$exclude_list = @("KONICA", "UltraVnc", "Update", "Hitachi Storage Navigator Modular", ".NET", "Office", "Adobe", "Word", "Excel", "Outlook", "PowerPoint", "Publisher", "Java", "Office", "Learning", "Support", "done")
$computername = Get-Content ".\result\livePCs.txt" -ReadCount 0  
$ErrorActionPreference = "Stop"
$Branch = "LocalMachine"
$SubBranch = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall"
$SubBranch64 = "SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall"
$tabName = "SampleTable"
$table = New-Object system.Data.DataTable $table_name
$col1 = New-Object system.Data.DataColumn SystemName,([string])
$col2 = New-Object system.Data.DataColumn Type,([string])
$col3 = New-Object system.Data.DataColumn Name,([string])
$col4 = New-Object system.Data.DataColumn Hide,([string])
$table.columns.add($col1)
$table.columns.add($col2)
$table.columns.add($col3)
$table.columns.add($col4)
$computers = $computername.Length
$x = 0
write-host -foregroundcolor cyan "Grubbing Software.info"
write-host -foregroundcolor cyan "Testing $computers computers, this may take a while."

foreach ($computer in $computername)  
{
if (Test-Connection -ComputerName $computer -Quiet -count 2 -BufferSize 4 -Delay 1){
        Try{
            $registry=[microsoft.win32.registrykey]::OpenRemoteBaseKey($Branch,$computer)
			$registrykey=$registry.OpenSubKey($Subbranch)
            $SubKeys=$registrykey.GetSubKeyNames()
            Foreach ($key in $subkeys){
                                       $exactkey=$key  
                                       $NewSubKey=$SubBranch+"\\"+$exactkey  
                                       $ReadUninstall=$registry.OpenSubKey($NewSubKey)  
                                       $Value=$ReadUninstall.GetValue("DisplayName") 
									   foreach($exclude in $exclude_list){
									   if($Value -notmatch $exclude){
									   foreach($Av in $av_list){
									   if($Value -match $Av){
									   $row = $table.NewRow()
									   $row.SystemName = $computer
									   $row.Type = "AV"
									   $row.Name = $Value
									   $table.Rows.Add($row)
									   }}
									   foreach($backup in $backup_list){
									   if($Value -match $backup){
									   $row = $table.NewRow()
									   $row.SystemName = $computer
									   $row.Type = "Backup"
									   $row.Name = $Value
									   #$row.Hide = '=IF(AND(A2=A1, B2=B1),"hide","show")'
									   $table.Rows.Add($row)
									   }}
             }}}}Catch{Add-Content "$registry" -path .\result\error.txt}
         Try{
            $registry=[microsoft.win32.registrykey]::OpenRemoteBaseKey($Branch,$computer)
            $registrykey=$registry.OpenSubKey($Subbranch64)
            $SubKeys=$registrykey.GetSubKeyNames()
            Foreach ($key in $subkeys){
                                       $exactkey=$key  
                                       $NewSubKey=$SubBranch+"\\"+$exactkey  
                                       $ReadUninstall=$registry.OpenSubKey($NewSubKey)  
                                       $Value=$ReadUninstall.GetValue("DisplayName") 
									   foreach($exclude in $exclude_list){
									   if($Value -notmatch $exclude){ 
									   foreach($Av in $av_list){
									   if($Value -match $Av){
									   $row = $table.NewRow()
									   $row.SystemName = $computer
									   $row.Type = "AV"
									   $row.Name = $Value
									   $table.Rows.Add($row)
									   }}
									   foreach($backup in $backup_list){
									   if($Value -match $backup){
									   $row = $table.NewRow()
									   $row.SystemName = $computer
									   $row.Type = "Backup"
									   $row.Name = $Value
									   #$row.Hide = '=IF(AND(A2=A1, B2=B1),"hide","show")'
									   $table.Rows.Add($row)
									   }}
									   }}}
			}Catch{Add-Content "$registry" -path .\result\error.txt}
$testcomputer_progress = [int][Math]::Ceiling((($x / $computers) * 100))
# Progress bar
	Write-Progress  "Grubbing Software.info" -PercentComplete $testcomputer_progress -Status "Percent Complete - $testcomputer_progress%" -Id 1;
	Sleep(1);
	$x++; 
	}}
	write-host -foregroundcolor cyan "Grubbing Software.info complete"
	$tabCsv = $table | export-csv .\result\Software.csv -noType }
$Source=".\result\*"
$destination=".\result.zip"
$typearchiv="-tzip"
$CompressionLevel="-mx=9"
$includeBaseDir=$true
function Compress-Result{

  Invoke-Expression "& '.\7z.exe' a '$typearchiv' '$destination' '$CompressionLevel' -aoa '$Source'"
	$findzip= Get-ChildItem .\
	if($findzip -match "result.zip"){Remove-Item -Force -Recurse .\result}
}
Switch($GrubType){
'all' {Test-LHosts; Get-Diskinfo | Export-Csv -Path .\result\Disk.csv -NoTypeInformation; Get-Software; Compress-Result}
'ping' {Test-LHosts; Compress-Result}
'disk' {Test-LHosts; Get-Diskinfo | Export-Csv -Path .\result\Disk.csv -NoTypeInformation; Compress-Result}
'soft' {Test-LHosts; Get-Software; Compress-Result}
'noping' {Get-Diskinfo | Export-Csv -Path .\result\Disk.csv -NoTypeInformation; Get-Software; Compress-Result}
'nocompress' {Test-LHosts; Get-Diskinfo | Export-Csv -Path .\result\Disk.csv -NoTypeInformation; Get-Software}
default {Test-LHosts; Get-Diskinfo | Export-Csv -Path .\result\Disk.csv -NoTypeInformation; Get-Software; Compress-Result}
}