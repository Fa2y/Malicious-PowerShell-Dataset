function Invoke-GlasswireExceptions {
<# 

.SYNOPSIS
	Dumps any program exceptions configured in GlassWire Endpoint Protection software.

.PARAMETER Help
	Shows Detailed Help.

.PARAMETER List
	Shows Brief Command Help.

.EXAMPLE 
	PS> Invoke-GlassWireExceptions
	
.NOTES
	Author: Fabrizio Siciliano (@0rbz_)

#>
[CmdletBinding()]
param(
	[Parameter(Position=1)]
	[Switch]$Help,
	[Switch]$List
)

	if ($Help -or $List) {
		Write @"
		
 ### Invoke-GlasswireExceptions Help ###
 ---------------------------------------
 Available Invoke-GlasswireExceptions Commands:
 ----------------------------------------------
 |--------------------------------------------------------------------------------|
 | Invoke-GlasswireExceptions                                                     |
 |--------------------------------------------------------------------------------|

   [*] Description: Dumps any program exceptions configured in GlassWire Endpoint 
       Protection software.

   [*] Usage: Invoke-GlasswireExceptions

 \--------------------------------------------------------------------------------/

"@
	}
	else {
		Write "`nGlassWire Exceptions List"
		Write "-------------------------`n"
		$RegKey = (Get-ItemProperty 'HKLM:\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules')
		$RegKey.PSObject.Properties | ForEach-Object {
		  If($_.Value -like '*Active=TRUE*' -and $_.Value -like '*Allow*' -and $_.Value -like '*Dir=Out|App=*'){
			Write-Output $_.Value | ForEach-Object {$_.split("|")} | Select-String -pattern "^App"
		  }
		}
	}
}

