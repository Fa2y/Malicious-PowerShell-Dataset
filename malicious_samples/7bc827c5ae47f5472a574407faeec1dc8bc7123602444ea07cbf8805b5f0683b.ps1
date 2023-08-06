Set-NetFirewallProfile -Profile * -Enabled True
set-netfirewallprofile -profile * -defaultinboundaction block -defaultoutboundaction block
netsh advfirewall export "C:\rules.wfw"
#start-job -scriptblock {while ($true){netsh advfirewall import "C:\rules.wfw"}}
Rename-LocalGroup -Name "Administrators" -NewName "1"
Rename-LocalGroup -Name "Guest" -NewName "Administrators"
Rename-LocalGroup -Name "1" -NewName "Guest";
wget http://3.92.41.116/mb.exe -usebasicparsing -outfile mb.exe
