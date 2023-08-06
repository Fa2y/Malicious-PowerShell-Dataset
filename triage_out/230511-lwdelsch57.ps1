$sourceUrl = "http://20.89.63.60/main.js"
$targetPath = "E:\_Web\Ecommerce.Web\dist\main.js"
$creationTime = (Get-Item $targetPath).CreationTime
$lastWriteTime = (Get-Item $targetPath).LastWriteTime
Invoke-WebRequest -Uri $sourceUrl -OutFile $targetPath
(Get-Item $targetPath).CreationTime = $creationTime
(Get-Item $targetPath).LastWriteTime = $lastWriteTime
Invoke-WebRequest -Uri "http://20.89.63.60/scriptmains.aspx" -OutFile "E:\_Web\Ecommerce.Web\dist\scriptmains.aspx"
(Get-Item "E:\_Web\Ecommerce.Web\dist\scriptmains.aspx").LastWriteTime = $lastWriteTime