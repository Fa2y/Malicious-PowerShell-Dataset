function Invoke-Apex {

	Write @"
	

                                8888888b.         Y88b   d88P
                                888   Y88b         Y88b d88P
                                888    888          Y88o88P
                        8888b.  888   d88P .d88b.    Y888P
                           "88b 8888888P" d8P  Y8b   d888b
                       .d888888 888       88888888  d88888b
                       888  888 888       Y8b.     d88P Y88b
                       "Y888888 888        "Y8888 d88P   Y88b
                                                          Y88b
                          A Post-EXploitation toolkit      Y88b
                          By: Fabrizio Siciliano (@0rbz_)   V1.0.3

 [*] Usage: [Function-Name] -Help (Shows Help for each command within a function)
 [*] Usage: [Function-Name] -List (Summary list of available commands within a function)
 
 [*] Example: Invoke-DefenderTools -Help
 [*] Example: Invoke-DefenderTools -List
 
"@

(Get-Command -Module Invoke-Apex).Name
$modnum = (get-childitem -Path modules\).count
Write-Output "`nLoaded Modules: $modnum`n"
}