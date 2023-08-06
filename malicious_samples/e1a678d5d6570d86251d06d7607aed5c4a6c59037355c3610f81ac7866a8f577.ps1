function Invoke-MitreReference {
<# 

.SYNOPSIS
	Shows a list of Mitre ATT&CK Techniques in use througout the toolkit.

.PARAMETER Help
	Shows Detailed Help.

.PARAMETER List
	Shows Brief Command Help.

.PARAMETER Tid
	Parameter to find in which modules specific Mitre ATT&CK Techniques are in use. Takes a Technique ID number as a value.

.EXAMPLE 
	PS> Invoke-MitreReference -List
	
.EXAMPLE
	PS> Invoke-MitreReference -Tid 1086
	
.NOTES
	Author: Fabrizio Siciliano (@0rbz_)

#>

[CmdletBinding()]
param (
	[Parameter(Position=1)]
	[Switch]$Help,
	[Switch]$List,
	
	[Parameter(Mandatory = $False)]
	[String]$Tid
)
	
	if ($Help -or $List) {
		Write @"

 |------------------------------------------------------------------|
 |           ### MITRE ATT&CK TECHNIQUE REFERENCE ###               |
 |------------------------------------------------------------------|
 | Usage:   Invoke-MitreReference -Tid Tid                          |
 | Example: Invoke-MitreReference -Tid 1043                         |
 |------------------------------------------------------------------|
   
   Module: Invoke-Connect
   ----------------------                                                                
   Mitre ATT&CK Ref: T1043 (Commonly Used Port)
   Mitre ATT&CK Ref: T1352 (C2 Protocol Development)
   

   Module: Invoke-Creds
   --------------------
   Mitre ATT&CK Ref: T1056 (Input Capture)
   Mitre ATT&CK Ref: T1081 (Credentials in Files)
   Mitre ATT&CK Ref: T1003 (Credential Dumping)
   
   
   Module: Invoke-DefenderTools
   ----------------------------
   Mitre ATT&CK Ref: T1211 (Exploitation for Defense Evasion)  
   Mitre ATT&CK Ref: T1089 (Disabling Security Tools)  
   
   
   Module: Invoke-Download
   -----------------------
   Mitre ATT&CK Ref: T1086 (PowerShell)
   Mitre ATT&CK Ref: T1105 (Remote File Copy)   
   
   
   Module: Invoke-Execute
   ----------------------
   Mitre ATT&CK Ref: T1086 (PowerShell)
   Mitre ATT&CK Ref: T1059 (Command-Line Interface)
   Mitre ATT&CK Ref: T1085 (Rundll32)                              
   Mitre ATT&CK Ref: T1047 (Windows Management Instrumentation)    
   Mitre ATT&CK Ref: T1220 (XSL Script Processing)                 
   Mitre ATT&CK Ref: T1028 (Windows Remote Management)             
   Mitre ATT&CK Ref: T1218 (Signed Binary Proxy Execution)
   
   
   Module: Invoke-Exfil
   --------------------
   Mitre ATT&CK Ref: T1132 (Data Encoding)
   Mitre ATT&CK Ref: T1020 (Automated Exfiltration)
   Mitre ATT&CK Ref: T1048 (Exfiltration over Alternative Protocol)
   
                                                                   
   Module: Invoke-Persistence
   --------------------------
   Mitre ATT&CK Ref: T1060 (Registry Run Keys / Startup Folder)
   Mitre ATT&CK Ref: T1090 (Account Manipulation)
   Mitre ATT&CK Ref: T1059 (Command-Line Interface)
   Mitre ATT&CK Ref: T1136 (Create Account)
   Mitre ATT&CK Ref: T1076 (Remote Desktop Protocol)
   
   
   Module: Invoke-PrivEsc
   ----------------------
   Mitre ATT&CK Ref: T1122 (Component Object Model Hijacking)
   Mitre ATT&CK Ref: T1088 (Bypass User Account Control)
   
   
   Module: New-PsDat
   -----------------
   Mitre ATT&CK Ref: T1099 (Timestomp)
   
   
   Module: New-PsTask
   ------------------
   MITRE ATT&CK Ref: T1053 (Scheduled Task)
   
 
   Module: Invoke-Sysinfo
   ----------------------
   Mitre ATT&CK Ref: T1087 (Account Discovery)
   Mitre ATT&CK Ref: T1059 (Command-Line Interface)
   Mitre ATT&CK Ref: T1083 (File and Directory Discovery)
   Mitre ATT&CK Ref: T1069 (Permission Groups Discovery)
   Mitre ATT&CK Ref: T1082 (System Information Discovery)
   Mitre ATT&CK Ref: T1016 (System Network Configuration Discovery)
   Mitre ATT&CK Ref: T1049 (System Network Connections Discovery)
   Mitre ATT&CK Ref: T1007 (System Service Discovery)
   Mitre ATT&CK Ref: T1005 (Data from Local System)
   Mitre ATT&CK Ref: T1033 (System Owner/User Discovery)
   Mitre ATT&CK Ref: T1057 (Process Discovery)
   
   
   Module: Invoke-TimeStomp
   ------------------------
   Mitre ATT&CK Ref: T1099 (Timestomp)
   
                                                                   
   Module: Invoke-TcpScan
   ----------------------
   Mitre ATT&CK Ref: T1423  (Network Service Scanning)              
   Mitre ATT&CK Ref: TA0008 (Lateral Movement)  
   Mitre ATT&CK Ref: T1018  (Remote System Discovery)   
	
"@
	}
	elseif ($Tid -eq "1003") {
	
		Write @"

   Modules using Mitre ATT&CK Ref: T1003 (Credential Dumping):
   
   [+] Module: Invoke-Creds
   
"@
	}
	elseif ($Tid -eq "1005") {
		Write @"
		
   Modules using Mitre ATT&CK Ref: T1005 (Data from Local System):
   
   [+] Module: Invoke-Sysinfo
   
"@
	}
	elseif ($Tid -eq "1007") {
		Write @"
		
   Modules using Mitre ATT&CK Ref: T1007 (System Service Discovery):
   
   [+] Module: Invoke-Sysinfo
   
"@
	}
	elseif ($Tid -eq "1016") {
		Write @"
		
   Modules using Mitre ATT&CK Ref: T1016 (System Network Configuration Discovery):
   
   [+] Module: Invoke-Sysinfo
   
"@
	}
	elseif ($Tid -eq "1018") {
		Write @"
		
   Modules using Mitre ATT&CK Ref: T1018 (Remote System Discovery):
   
   [+] Module: Invoke-TcpScan
   
"@
	}
	elseif ($Tid -eq "1020") {
		Write @"
		
   Modules using Mitre ATT&CK Ref: T1020 (Automated Exfiltration):
   
   [+] Module: Invoke-Exfil
   
"@
	}
	elseif ($Tid -eq "1028") {
		Write @"
		
   Modules using Mitre ATT&CK Ref: T1028 (Windows Remote Management):
   
   [+] Module: Invoke-Execute
   
"@
	}
	elseif ($Tid -eq "1033") {
		Write @"
		
   Modules using Mitre ATT&CK Ref: T1033 (System Owner/User Discovery):
   
   [+] Module: Invoke-Sysinfo
   
"@
	}
	elseif ($Tid -eq "1043") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1043 (Commonly Used Port):
   
   [+] Module: Invoke-Connect
   
"@
	}
	elseif ($Tid -eq "1047") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1047 (Windows Management Instrumentation):
   
   [+] Module: Invoke-Execute
   
"@
	}
	elseif ($Tid -eq "1048") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1048 (Exfiltration over Alternative Protocol):
   
   [+] Module: Invoke-Exfil
   
"@
	}
	elseif ($Tid -eq "1049") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1049 (System Network Connections Discovery):
   
   [+] Module: Invoke-Sysinfo
   
"@
	}
	elseif ($Tid -eq "1053") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1053 (Scheduled Task):
   
   [+] Module: New-PsTask
   
"@
	}
	elseif ($Tid -eq "1056") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1056 (Input Capture):
   
   [+] Module: Invoke-Creds
   
"@
	}
	elseif ($Tid -eq "1057") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1057 (Process Discovery):
   
   [+] Module: Invoke-Sysinfo
   
"@
	}
	elseif ($Tid -eq "1059") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1059 (Command-Line Interface):
   
   [+] Module: Invoke-Sysinfo
   [+] Module: Invoke-Execute
   [+] Module: Invoke-Persistence
   
"@
	}
	elseif ($Tid -eq "1060") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1060 (Registry Run Keys / Startup Folder):
   
   [+] Module: Invoke-Persistence
   
"@
	}
	elseif ($Tid -eq "1069") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1069 (Permission Groups Discovery):
   
   [+] Module: Invoke-Sysinfo
   
"@
	}
	elseif ($Tid -eq "1076") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1076 (Remote Desktop Protocol):
   
   [+] Module: Invoke-Persistence
   
"@
	}
	elseif ($Tid -eq "1081") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1081 (Credentials in Files):
   
   [+] Module: Invoke-Creds
   
"@
	}
	elseif ($Tid -eq "1082") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1082 (System Information Discovery):
   
   [+] Module: Invoke-Sysinfo
   
"@
	}
	elseif ($Tid -eq "1083") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1083 (File and Directory Discovery):
   
   [+] Module: Invoke-Sysinfo
   
"@
	}
	elseif ($Tid -eq "1085") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1085 (Rundll32):
   
   [+] Module: Invoke-Execute
   
"@
	}
	elseif ($Tid -eq "1086") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1086 (PowerShell):
   
   [+] Module: Invoke-Download
   [+] Module: Invoke-Execute
   
"@
	}
	elseif ($Tid -eq "1087") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1087 (Account Discovery):
   
   [+] Module: Invoke-Sysinfo
   
"@
	}
	elseif ($Tid -eq "1088") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1088 (Bypass User Account Control):
   
   [+] Module: Invoke-PrivEsc
   
"@
	}
	elseif ($Tid -eq "1089") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1089 (Disabling Security Tools):
   
   [+] Module: Invoke-DefenderTools
   
"@
	}
	elseif ($Tid -eq "1090") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1090 (Account Manipulation):
   
   [+] Module: Invoke-Persistence
   
"@
	}
	elseif ($Tid -eq "1099") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1099 (Timestomp):
   
   [+] Module: Invoke-TimeStomp
   [+] Module: New-PsDat
   
"@
	}
	elseif ($Tid -eq "1105") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1105 (Remote File Copy):
   
   [+] Module: Invoke-Download
   
"@
	}
	elseif ($Tid -eq "1122") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1122 (Component Object Model Hijacking):
   
   [+] Module: Invoke-PrivEsc
   
"@
	}
	elseif ($Tid -eq "1132") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1132 (Data Encoding):
   
   [+] Module: Invoke-Exfil
   
"@
	}
	elseif ($Tid -eq "1136") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1136 (Create Account):
   
   [+] Module: Invoke-Persistence
   
"@
	}
	elseif ($Tid -eq "1211") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1211 (Exploitation for Defense Evasion):
   
   [+] Module: Invoke-DefenderTools
   
"@
	}
	elseif ($Tid -eq "1218") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1218 (Signed Binary Proxy Execution):
   
   [+] Module: Invoke-Execute
   
"@
	}
	elseif ($Tid -eq "1220") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1220 (XSL Script Processing):
   
   [+] Module: Invoke-Execute
   
"@
	}
	elseif ($Tid -eq "1352") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1352 (C2 Protocol Development):
   
   [+] Module: Invoke-Connect
   
"@
	}
	elseif ($Tid -eq "1423") {
		Write @"

   Modules using Mitre ATT&CK Ref: T1423  (Network Service Scanning):
   
   [+] Module: Invoke-TcpScan
   
"@
	}
}

