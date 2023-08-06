function Invoke-Privesc {
<# 

.SYNOPSIS
	Commands for either elevating to a higher integrity-level or elevating privileges via other means.

.PARAMETER Help
	Shows Detailed Help.

.PARAMETER List
	Shows Brief Command Help.
	
.PARAMETER UnquotedPaths
	Checks for auto start services configured without quotes, useful for identifying services vulnerable to unquoted service paths exploitation. 

.EXAMPLE 
	PS> Invoke-Privesc -UnquotedPaths
	
.NOTES
	Author: Fabrizio Siciliano (@0rbz_)

#>

[CmdletBinding()]
param (
	[Parameter(Position=1)]
	[Switch]$Help,
	[switch]$List,
	
	[Parameter(Mandatory = $False)]
	[Switch]$UnquotedPaths
)
	
	if ($Help -eq $True) {
		
		Write @"
	
 ### Invoke-Privesc Help ###
 ---------------------------
 Available Invoke-Privesc Commands:
 ----------------------------------
 |-----------------------------------------------------------------------------|
 | -UnquotedPaths                                                              |
 |-----------------------------------------------------------------------------|

   [?] Checks for auto start services configured without quotes, useful for 
       identifying services vulnerable to unquoted service paths exploitation.
                                                                              
   [?] Usage: Invoke-Privesc -UnquotedPaths
   
 \-----------------------------------------------------------------------------/

"@
	}
	elseif ($List -eq $True) {
		Write @"
		
 Invoke-Privesc Brief Command Usage:
 -----------------------------------
 Invoke-Privesc -UnquotedPaths
 
"@
	}
	elseif ($UnquotedPaths) {
		
		Get-WmiObject win32_service | select PSConfiguration | Where {$_.PathName -notlike '*svchost*' -and $_.PathName -NotLike '*system32*' -and $_.StartMode -Like "Auto" -and $_.PathName -notmatch '"' -and $_.PathName -match ' '}
		
		Get-WmiObject win32_service | select PSConfiguration | Where {$_.PathName -notlike '*svchost*' -and $_.PathName -NotLike '*system32*' -and $_.StartMode -Like "Manual" -and $_.PathName -notmatch '"' -and $_.PathName -match ' '}
		
		Get-WmiObject win32_service | select PSConfiguration | Where {$_.PathName -notlike '*svchost*' -and $_.PathName -NotLike '*system32*' -and $_.StartMode -Like "Disabled" -and $_.PathName -notmatch '"' -and $_.PathName -match ' '}
		
		
		
	}
}