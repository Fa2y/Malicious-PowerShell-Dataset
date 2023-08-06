<#
.SYNOPSIS
Information extraction script for audits on windows computers.

.EXAMPLE
./get-info.ps1

#>

$extractADAdmin = $true
$extractADUser = $true

$tables_list =@(
    # Configuration
	"Win32_Product",
    "Win32_OperatingSystem",
    "Win32_QuickFixEngineering",
    "Win32_LocalTime",
    "Win32_TimeZone",
    # Network
	"Win32_NetworkAdapter",
	"Win32_NetworkAdapterConfiguration",
	"Win32_IP4RouteTable",
    # Disk
	"Win32_LogicalDisk",
    # Process
    "Win32_Service",
    # Autorun
	"Win32_StartupCommand",
    # User
	"Win32_SystemAccount",
	#"Win32_Group",
	#"Win32_GroupUser",
	#"Win32_UserAccount",
    # Other
	"RSOP%"
)
$advence_tables_list =@(
    # Configuration
	"Win32_BootConfiguration",
	"Win32_ServerFeature",
    # log
	"Win32_NTEventlogFile",
    # Network
	"Win32_Share",
	"Win32_NTDomain",
	"Win32_NetworkProtocol",
    # Disk
	"Win32_EncryptableVolume",
    # Environement
	"Win32_Environment",
    # Process
	"Win32_Process",
    # User
    "Win32_Account",
	"Win32_UserInDomain",
    # Log User
	"Win32_LogonSession",
	"Win32_LoggedOnUser",
    "Win32_TSAccount",
    # Other
	"Win32_TerminalServiceSetting",
	"AntiVirusProduct",
	"IIS%",
	"SqlServiceAdvancedProperty"
)

Function New-Zip([string]$zipfilename) {
	<#
	.SYNOPSYS
	Creates a new ZIP file on disk.

	.PARAMETER zipfilename
	The path of the zipfile to create.

	.EXAMPLE
	New-Zip C:\test.zip
	#>
	set-content $zipfilename ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
	(Get-ChildItem $zipfilename).IsReadOnly = $false
}

Function Add-Zip([string]$zipfilename) {
	<#
	.SYNOPSYS
	Add the files piped in the function to th zipfilename.

	.PARAMETER zipfilename
	The zip file to which the files will be added.

	.EXAMPLE
	New-Zip C:\test.zip
	Get-Item C:\test.txt | Add-Zip C:\test.zip

	#>
	if(-not (test-path($zipfilename))) {
		set-content $zipfilename ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
		(Get-ChildItem $zipfilename).IsReadOnly = $false

	}

	$shellApplication = New-Object -com shell.application
	$zipPackage = $shellApplication.NameSpace($zipfilename)

	foreach($file in $input) {
		Write-Host ("    [+] adding " + $file.FullName)
		$zipPackage.CopyHere($file.FullName)
		Start-sleep -milliseconds 500
	}
}

Function ip2int ([Parameter(Mandatory=$True, Position=1)][string]$ip) {
	<#
	.SYNOPSIS
	Converts a string ip to an uint32 integer.

	.PARAMETER ip
	The ip in pointed string representation.

	.EXAMPLE
	ip2int "127.0.0.1"
	#>
	$octets = $ip.split(".")
	return [uint32]([uint32]$octets[0]*16777216 +[uint32]$octets[1]*65536 +[uint32]$octets[2]*256 +[uint32]$octets[3])
}

Function int2ip([Parameter(Mandatory=$True, Position=1)][uint32]$int) {
	<#
	.SYNOPSIS
	Converts a 32 byte unsigned int into a pointed ip string.

	.PARAMETER int
	The int to convert.

	.EXAMPLE
	int2ip 0
	#>
	return (([math]::truncate($int/16777216)).tostring()+"."+([math]::truncate(($int%16777216)/65536)).tostring()+"."+([math]::truncate(($int%65536)/256)).tostring()+"."+([math]::truncate($int%256)).tostring() )
}

Function Write-LogLine([string]$line) {
	$d = Get-Date
    Write-Host $line
	Add-Content "debug.log" "$d : $line"
}

# Requetes WMI
Function Get-Interesting-WMI-Tables([string]$namespace, $tableslist) {
	<#
	.SYNOPSIS
	Returns a list of expanded wmi table names in the given namespace.

	.DESCRIPTION
	The table names expansion is achieved through a wmi request and ORing tablenames specified in tableslist.

	.PARAMETER computer
	The computer on which the expansion request will be performed.

	.PARAMETER namespace
	The namespace in which tablenames will be expanded.

	.PARAMETER tableslist
	The list of tablenames to expand.

	#>
	Write-LogLine ("[+] Requesting table list on namespace " + $namespace)
	$queryTables = "Select * from meta_class where not __Class like '%'"
	$tableslist | ForEach-Object {
		$queryTables += " Or __Class like '" + $_ + "' "
	}
	$out = gwmi -query $queryTables -Namespace $namespace -ErrorAction SilentlyContinue -ErrorVariable gerr
	if ($gerr) {
		Write-LogLine $gerr
	}
	return $out
}

Function Write-Properties-to-XML([string]$namespace, $tables, [string]$out) {
	if ($tables -eq $null) {
		Write-LogLine "[*] No tables on $computer in $namespace"
		return
	}
	$fullout = ($out + "\wmi__")
	$fullout += ($namespace.split("\")[$namespace.split("\").count - 1])

	Write-LogLine ("[+] Requesting informations from in namespace " + $namespace)
	foreach ($class in $tables) {
        $wmi = gwmi $class.name -Namespace $namespace
		if (($wmi -ne $null) -and (($wmi.properties -ne $null) -or ($wmi.count -gt 0))) {
			Write-LogLine ("    [+] Extracting information from " + $class.name + " to " + $fullout)
			$wmi | Export-Clixml ($fullout + "__" + $class.name + ".xml")
		}
	}
}

Function Invoke-ExecLog() {
    param(
        [Parameter(Mandatory=$true)][string]$name,
        [Parameter(Mandatory=$true)]$block,
        [Parameter(Mandatory=$true)][string]$outpath,
        [Parameter(Mandatory=$false)][string]$progressPropertyName=""
    )
	$fullout = ($outpath + "\stdout\")
    if (-not (Test-Path $fullout)) {
        $_ = New-Item ($fullout) -type directory
    }
	$fullout = $fullout + $name + ".txt"
	Write-LogLine "[+] Gathering $name, storing into $fullout"
	#$out = &$block
	#$out | Export-Clixml ($fullout)
    try {
        if ($progressPropertyName -ne "") {Write-Progress -Status ("Starting ...") -Activity ("Getting " + $name)}
	    &$block |
            ForEach-Object -Begin {$i = 0} -Process {if (($i % 100 -eq 0 -or $true) -and ($progressPropertyName -ne "") -and ($_.$progressPropertyName -ne $null) -and ($_.$progressPropertyName -ne "")) {$i = 0;Write-Progress -Status ($_.$progressPropertyName) -Activity ("Getting " + $name)} $i++; $_} |
            Export-Clixml ($fullout)
    } Catch {
        Write-LogLine "[!] Error"
        Write-LogLine $_
    } finally {
        Write-Progress -Completed -Status ("finishing") -Activity ("Getting " + $name)
    }
}

Function Read-FromComputer($tables_to_query, [string]$outpath) {
	# $out = New-Item ($outpath + "\") -type directory -force

	$tables = Get-Interesting-WMI-Tables "root\cimv2" $tables_to_query
	Write-Properties-to-XML "root\cimv2" $tables $outpath

	$tables = Get-Interesting-WMI-Tables "Root\RSOP\Computer" $tables_to_query
	Write-Properties-to-XML "Root\RSOP\Computer" $tables $outpath

	$tables = Get-Interesting-WMI-Tables "Root\RSOP\User" $tables_to_query
	Write-Properties-to-XML "Root\RSOP\User" $tables $outpath

	$tables = Get-Interesting-WMI-Tables "root\microsoft\sqlserver\computermanagement12" $tables_to_query
	Write-Properties-to-XML "root\microsoft\sqlserver\computermanagement12" $tables $outpath

	$tables = Get-Interesting-WMI-Tables "ROOT\MicrosoftIISv2" $tables_to_query
	Write-Properties-to-XML "Root\MicrosoftIISv2" $tables $outpath
}

# Structure for list open port (udp / tcp), get process information (privilege, sid)
Add-Type -TypeDefinition @"
	using System;
	using System.Diagnostics;
	using System.Runtime.InteropServices;
	using System.Security.Principal;
    using System.Collections.Generic;

    [Flags]
    public enum SID_ATTRIBUTES : uint
    {
        SE_GROUP_MANDATORY = 0x1, // The SID cannot have the SE_GROUP_ENABLED attribute cleared by a call to the AdjustTokenGroups function. However, you can use the CreateRestrictedToken function to convert a mandatory SID to a deny-only SID. 
        SE_GROUP_ENABLED_BY_DEFAULT = 0x2, // The SID is enabled by default. 
        SE_GROUP_ENABLED = 0x4, // The SID is enabled for access checks. When the system performs an access check, it checks for access-allowed and access-denied access control entries (ACEs) that apply to the SID. A SID without this attribute is ignored during an access check unless the SE_GROUP_USE_FOR_DENY_ONLY attribute is set.
        SE_GROUP_OWNER = 0x8, // The SID identifies a group account for which the user of the token is the owner of the group, or the SID can be assigned as the owner of the token or objects. 
        SE_GROUP_USE_FOR_DENY_ONLY = 0x10, // 
        SE_GROUP_RESOURCE = 0x20000000, // The SID identifies a domain-local group.Windows NT:  This value is not supported. 
        SE_GROUP_LOGON_ID = 0xC0000000, // The SID is a logon SID that identifies the logon session associated with an access token. 
    }

    public enum TOKEN_INFORMATION_CLASS : int
    {
        TokenUser = 1,
        TokenGroups,
        TokenPrivileges,
        TokenOwner,
        TokenPrimaryGroup,
        TokenDefaultDacl,
        TokenSource,
        TokenType,
        TokenImpersonationLevel,
        TokenStatistics,
        TokenRestrictedSids,
        TokenSessionId,
        TokenGroupsAndPrivileges,
        TokenSessionReference,
        TokenSandBoxInert,
        TokenAuditPolicy,
        TokenOrigin,
        TokenElevationType,
        TokenLinkedToken,
        TokenElevation,
        TokenHasRestrictions,
        TokenAccessInformation,
        TokenVirtualizationAllowed,
        TokenVirtualizationEnabled,
        TokenIntegrityLevel,
        TokenUIAccess,
        TokenMandatoryPolicy,
        TokenLogonSid,
        TokenIsAppContainer,
        TokenCapabilities,
        TokenAppContainerSid,
        TokenAppContainerNumber,
        TokenUserClaimAttributes,
        TokenDeviceClaimAttributes,
        TokenRestrictedUserClaimAttributes,
        TokenRestrictedDeviceClaimAttributes,
        TokenDeviceGroups,
        TokenRestrictedDeviceGroups,
        TokenSecurityAttributes,
        TokenIsRestricted,
        TokenProcessTrustLevel,
        TokenPrivateNameSpace,
        TokenSingletonAttributes,
        TokenBnoIsolation,
        TokenChildProcessFlags,
        MaxTokenInfoClass,
        TokenIsLessPrivilegedAppContainer
    }

    [StructLayout(LayoutKind.Sequential)]
	public struct PSID
	{
		public IntPtr sid;
	}
	
	[StructLayout(LayoutKind.Sequential)]
	public struct LUID
	{
		public uint LowPart;
		public int HighPart;
	}
	
	[StructLayout(LayoutKind.Sequential)]
	public struct LUID_AND_ATTRIBUTES
	{
		public LUID Luid;
		public UInt32 Attributes;
	}

    [StructLayout(LayoutKind.Sequential)]
	public struct SID_AND_ATTRIBUTES
	{
		public PSID Sid;
		public UInt32 Attributes;
	}

    [StructLayout(LayoutKind.Sequential)]
	public struct TOKEN_USER
	{
		public SID_AND_ATTRIBUTES User;
	}

    [StructLayout(LayoutKind.Sequential)]
	public struct TOKEN_OWNER
	{
		public PSID Owner;
	}

    [StructLayout(LayoutKind.Sequential)]
	public struct TOKEN_APPCONTAINER_INFORMATION
	{
		public SID_AND_ATTRIBUTES TokenAppContainer;
	}
	
	public struct TOKEN_PRIVILEGES
	{
		public UInt32 PrivilegeCount;
		[MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
		public LUID_AND_ATTRIBUTES[] Privileges;
	}

    public struct TOKEN_GROUPS
	{
		public UInt32 GroupCount;
		[MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
		public SID_AND_ATTRIBUTES[] Groups;
	}

    public enum TCP_TABLE_CLASS
    {
        TCP_TABLE_BASIC_LISTENER,
        TCP_TABLE_BASIC_CONNECTIONS,
        TCP_TABLE_BASIC_ALL,
        TCP_TABLE_OWNER_PID_LISTENER,
        TCP_TABLE_OWNER_PID_CONNECTIONS,
        TCP_TABLE_OWNER_PID_ALL,
        TCP_TABLE_OWNER_MODULE_LISTENER,
        TCP_TABLE_OWNER_MODULE_CONNECTIONS,
        TCP_TABLE_OWNER_MODULE_ALL
    }

    public enum UDP_TABLE_CLASS
    {
        UDP_TABLE_BASIC,
        UDP_TABLE_OWNER_PID,
        UDP_OWNER_MODULE
    }

    [Flags]public enum SECURITY_INFORMATION : uint
    {
        OWNER_SECURITY_INFORMATION = 0x1,
        GROUP_SECURITY_INFORMATION = 0x2,
        DACL_SECURITY_INFORMATION = 0x4,
        SACL_SECURITY_INFORMATION = 0x8,
        LABEL_SECURITY_INFORMATION = 0x10,
        ATTRIBUTE_SECURITY_INFORMATION = 0x20,
        SCOPE_SECURITY_INFORMATION = 0x40,
        PROCESS_TRUST_LABEL_SECURITY_INFORMATION = 0x80,
        BACKUP_SECURITY_INFORMATION = 0x00010000,
        UNPROTECTED_SACL_SECURITY_INFORMATION = 0x10000000,
        UNPROTECTED_DACL_SECURITY_INFORMATION = 0x20000000,
        PROTECTED_SACL_SECURITY_INFORMATION = 0x40000000,
        PROTECTED_DACL_SECURITY_INFORMATION = 0x80000000,
    }

    public enum SE_OBJECT_TYPE : uint
    {
        SE_UNKNOW_OBJECT_TYPE = 0x0,
        SE_FILE_OBJECT,
        SE_SERVICE,
        SE_PRINTER,
        SE_REGISTRY_KEY,
        SE_LMSHARE,
        SE_KERNEL_OBJECT,
        SE_WINDOWS_OBJECT,
        SE_DS_OBJECT,
        SE_OBJECT_ALL,
        SE_PROVIDER_DEFINED_OBJECT,
        SE_WMIGUID_OBJECT,
        SE_REGISTRY_WOW64_32KEY,
        SE_REGISTRY_WOW64_64KEY,
    }

    public enum FINDEX_INFO_LEVEL
    {
        FindExInfoStandard = 0,
        FindExInfoBasic = 1,
        FindExInfoMaxInfoLevel = 2
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct MIB_TCPROW_OWNER_PID
    {
        public uint dwState;
        public uint dwLocalAddr;
        public uint dwLocalPort;
        public uint dwRemoteAddr;
        public uint dwRemotePort;
        public uint dwOwningPid;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct MIB_TCP6ROW_OWNER_PID
    {
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 16)]
        public byte[] ucLocalAddr;
        public uint dwLocalScopeId;
        public uint dwLocalPort;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 16)]
        public byte[] ucRemoteAddr;
        public uint dwRemoteScopeId;
        public uint dwRemotePort;
        public uint dwState;
        public uint dwOwningPid;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct MIB_TCPTABLE_OWNER_PID
    {
        public uint dwNumEntries;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
        MIB_TCPROW_OWNER_PID[] table;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct MIB_TCP6TABLE_OWNER_PID
    {
        public uint dwNumEntries;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
        MIB_TCP6ROW_OWNER_PID[] table;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct MIB_UDPROW_OWNER_PID
    {
        public uint dwLocalAddr;
        public uint dwLocalPort;
        public uint dwOwningPid;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct MIB_UDP6ROW_OWNER_PID
    {
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 16)]
        public byte[] ucLocalAddr;
        public uint dwLocalScopeId;
        public uint dwLocalPort;
        public uint dwOwningPid;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct MIB_UDPTABLE_OWNER_PID
    {
        public uint dwNumEntries;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
        MIB_UDPROW_OWNER_PID[] table;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct MIB_UDP6TABLE_OWNER_PID
    {
        public uint dwNumEntries;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
        MIB_UDP6ROW_OWNER_PID[] table;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct FILETIME
    {
        public uint DateTimeLow;
        public uint DateTimeHigh;
    }

    [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)]
    public struct WIN32_FIND_DATA
    {
        public uint dwFileAttributes;
        public FILETIME ftCreationTime;
        public FILETIME ftLastAccessTime;
        public FILETIME ftLastWriteTime;
        public uint nFileSizeHigh;
        public uint nFileSizeSizeLow;
        public uint dwReserved0;
        public uint dwReserved1;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 260)]
        public string cFileName;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 14)]
        public string cAlternateFileName;
        public uint dwFileType;
        public uint dwCreatorType;
    }

    public enum FINDEX_SEARCH_OPS
    {
        FindExSearchNameMatch = 0,
        FindExSearchLimitToDirectory = 1,
        FindExSearchLimitToDevice = 2
    }

	public static class Advapi32
	{
		[DllImport("advapi32.dll", SetLastError=true, CharSet=CharSet.Unicode)]		
		public static extern bool OpenProcessToken(
			IntPtr ProcessHandle,
			uint DesiredAccess,	
			out IntPtr TokenHandle);
	
		[DllImport("advapi32.dll", SetLastError = true)]
		public static extern bool GetTokenInformation(
			IntPtr TokenHandle,
			TOKEN_INFORMATION_CLASS TokenInformationClass,
			IntPtr TokenInformation,
			int TokenInformationLength,
			ref int ReturnLength);
	
		[DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Auto)]
		[return: MarshalAs(UnmanagedType.Bool)]
		public static extern bool LookupPrivilegeName(
			string lpSystemName,
			IntPtr lpLuid,
			System.Text.StringBuilder lpName,
			ref int cchName);

		[DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Auto)]
		public static extern bool ConvertSidToStringSid(
            PSID pSid,
			ref System.Text.StringBuilder pStringSid);

        [DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Auto)]
		public static extern bool LookupAccountSid(
            IntPtr lpSystemName,
            PSID Sid,
			IntPtr Name,
            ref UInt32 cchName,
            IntPtr ReferenceDomainName,
            ref UInt32 cchReferenceDomainName,
            out UInt32 peUse);

        [DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Auto)]
        public static extern bool LookupPrivilegeValue(
			string lpSystemName,
			System.Text.StringBuilder lpName,
			IntPtr lpLuid);

		[DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Auto)]
		public static extern bool AdjustTokenPrivileges(
            IntPtr TokenHandle,
            bool DisableAllPrivileges,
			IntPtr NewState,
            uint BufferLength,
			IntPtr PreviousState,
			ref uint ReturnLengh);

		[DllImport("advapi32.dll", SetLastError=true, CharSet=CharSet.Unicode)]		
		public static extern uint GetNamedSecurityInfo(
			string pObjectName,
			SE_OBJECT_TYPE ObjectType,	
			SECURITY_INFORMATION SecurityInfo,
            ref PSID ppsidOwner,
            ref PSID ppsidGroup,
            ref IntPtr ppDACL,
            ref IntPtr ppSACL,
            ref IntPtr ppSecurityDescriptor);

        [DllImport("advapi32.dll", SetLastError=true, CharSet=CharSet.Unicode)]		
		public static extern bool ConvertSecurityDescriptorToStringSecurityDescriptor(
			IntPtr pSecurityDescriptor,
			uint RequestedStringSDRevision,
			SECURITY_INFORMATION SecurityInfo,
            out IntPtr StringSecurityDescriptor,
            out uint StringSecurityDescriptorLen);
	}
	
	public static class Kernel32
	{
		[DllImport("kernel32.dll")]		
		public static extern IntPtr OpenProcess(		
			int dwDesiredAccess,		
			bool bInheritHandle,		
			int dwProcessId);

		[DllImport("kernel32.dll")]		
		public static extern bool CloseHandle(		
			IntPtr hObject);
	
		[DllImport("kernel32.dll")]
		public static extern uint GetLastError();

        [DllImport("kernel32.dll")]
        public static extern IntPtr GetCurrentProcess();

        [DllImport("Kernel32.dll", SetLastError=true, CharSet=CharSet.Unicode)]		
		public static extern IntPtr LocalFree(IntPtr hMem);
        [DllImport("Kernel32.dll", SetLastError=true, CharSet=CharSet.Unicode)]		
		public static extern IntPtr LocalFree(String hMem);

        [DllImport("Kernel32.dll", SetLastError=true, CharSet=CharSet.Unicode)]		
        public static extern IntPtr FindFirstFileEx(
            String lpFileName,
            FINDEX_INFO_LEVEL fInfoLevelId,
            out WIN32_FIND_DATA lpFindFileData,
            FINDEX_SEARCH_OPS fsearchFilter,
            IntPtr lpSearchFilter,
            uint dwAdditionalFlags);

        [DllImport("Kernel32.dll", SetLastError=true, CharSet=CharSet.Unicode)]		
        public static extern IntPtr FindClose(
            IntPtr hfile);

        [DllImport("Kernel32.dll", SetLastError=true, CharSet=CharSet.Unicode)]		
        public static extern bool FindNextFile(
            IntPtr hfile,
            out WIN32_FIND_DATA lpFindFileData);

        [DllImport("Kernel32.dll", SetLastError=true, CharSet=CharSet.Unicode)]
        public static extern bool Wow64DisableWow64FsRedirection(out IntPtr hfile);
        [DllImport("Kernel32.dll", SetLastError=true, CharSet=CharSet.Unicode)]
        public static extern bool Wow64RevertWow64FsRedirection(IntPtr hfile);
	}

    public static class Iphlpapi
    {
        [DllImport("iphlpapi.dll", SetLastError = true)]
        public static extern uint GetExtendedTcpTable(
            IntPtr pTcpTable,
            ref int dwOutBufLen,
            bool sort,
            int ipVersion,
            TCP_TABLE_CLASS tblCalass,
            int reserved);

        [DllImport("iphlpapi.dll", SetLastError = true)]
        public static extern uint GetExtendedUdpTable(
            IntPtr pUdpTable,
            ref int dwOutBufLen,
            bool sort,
            int ipVersion,
            UDP_TABLE_CLASS tblCalass,
            int reserved);
    }

public static class FileSystem
{
    private static SECURITY_INFORMATION query_information = SECURITY_INFORMATION.DACL_SECURITY_INFORMATION | SECURITY_INFORMATION.OWNER_SECURITY_INFORMATION | SECURITY_INFORMATION.GROUP_SECURITY_INFORMATION | SECURITY_INFORMATION.SCOPE_SECURITY_INFORMATION | SECURITY_INFORMATION.LABEL_SECURITY_INFORMATION | SECURITY_INFORMATION.ATTRIBUTE_SECURITY_INFORMATION;

    public static bool GetFileAndPerm(String currentDirectory, string outputfile)
    {
        IntPtr oldvalue = IntPtr.Zero;
        bool wowProcess = true;

        if (Kernel32.Wow64DisableWow64FsRedirection(out oldvalue) == false)
        {
            wowProcess = false;
            if (Kernel32.GetLastError() != 1)
                Console.WriteLine("Error, unable to remove wow fs");
        }

        bool result = false;

        System.IO.FileInfo f = new System.IO.FileInfo(outputfile);
        using (System.IO.StreamWriter file = new System.IO.StreamWriter(f.Open(System.IO.FileMode.Append, System.IO.FileAccess.Write)))
        {
            result = FileSystem.GetFilePerm(currentDirectory + "\\", true, file);
            result &= FileSystem.GetFileAndPermRecure(currentDirectory, file);
        }

        if (wowProcess && Kernel32.Wow64RevertWow64FsRedirection(oldvalue) == false)
        {
            Console.WriteLine("Error, unable to restore wow fs");
            return false;
        }
        return result;
    }

    private static void WritePermLine(String fileName, string fileType, string perm, System.IO.StreamWriter outputfile)
    {
        outputfile.WriteLine("{0}", "*" + fileName + "\n" + fileType + " - " + perm);
    }

    private static bool GetFilePerm(String fileName, bool isDirectory, System.IO.StreamWriter outputfile)
    {
        String perm;
        if (!FileSystem.GetPerm(fileName, out perm))
            perm = "--Error--";
        FileSystem.WritePermLine(fileName, isDirectory?"d":"f", perm, outputfile);

        return true;
    }

    public static bool GetFileAndPermRecure(String currentDirectory, System.IO.StreamWriter outputfile)
    {
        WIN32_FIND_DATA findData;
        List<String> recure_list = new List<String>();

        int i = 0;

        recure_list.Add(currentDirectory);

        while (recure_list.Count != 0)
        {
            currentDirectory = recure_list[0];
            recure_list.RemoveAt(0);

            i++;
            if (i > 10000) {
                Console.Write("current file: {0}\n", currentDirectory);
                i = 0;
            }

            IntPtr hfile = Kernel32.FindFirstFileEx(currentDirectory + "\\*", FINDEX_INFO_LEVEL.FindExInfoBasic, out findData, FINDEX_SEARCH_OPS.FindExSearchNameMatch, IntPtr.Zero, 2);
            if (hfile == new IntPtr(-1))
            {
                int ret = Marshal.GetLastWin32Error();
                String filestr = "-- Error:READ:" + ret + " --";
                FileSystem.WritePermLine(currentDirectory, "-", filestr, outputfile);
            }
            else
            {
                do {
                    if (findData.cFileName == "." || findData.cFileName == "..")
                        continue;

                    String fileName = currentDirectory + "\\" + findData.cFileName;
                    bool isDirectory = (findData.dwFileAttributes & 0x10) != 0;

                    FileSystem.GetFilePerm(fileName, isDirectory, outputfile);

                    if (isDirectory)
                    {
                        recure_list.Add(fileName);
                        //FileSystem.GetFileAndPermRecure(fileName, outputfile);
                    }

                } while (Kernel32.FindNextFile(hfile, out findData));
                Kernel32.FindClose(hfile);
            }
        }

        return true;
    }

    public static bool GetPerm(String filename, out String permstr)
    {
        PSID owner = new PSID();
        PSID group = new PSID();
        owner.sid = IntPtr.Zero;
        group.sid = IntPtr.Zero;

        IntPtr dacl = IntPtr.Zero;
        IntPtr sacl = IntPtr.Zero;
        IntPtr securityDescriptor = IntPtr.Zero;
        uint ret = Advapi32.GetNamedSecurityInfo(filename, SE_OBJECT_TYPE.SE_FILE_OBJECT, query_information,
                ref owner, ref group, ref dacl, ref sacl, ref securityDescriptor);

        if (ret != 0)
        {
            permstr = "-- Error:ACL:" + ret + "," + Marshal.GetLastWin32Error() + " --";
            return ret == 5 || ret == 32;
        }

        IntPtr strbuffer = IntPtr.Zero;
        uint strlen = 0;

        Advapi32.ConvertSecurityDescriptorToStringSecurityDescriptor(securityDescriptor, 1, query_information, out strbuffer, out strlen);
        Kernel32.LocalFree(securityDescriptor);

        permstr = Marshal.PtrToStringUni(strbuffer);

        Kernel32.LocalFree(strbuffer);

        return true;
    }
}
"@

# This part is for get the current working directory of a process
#  The working directory give by WMI look broken
#  The directory is give by reading the PEB
Add-Type -Language CSharp -TypeDefinition @"
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Security.Principal;
using System.Collections.Generic;

public static class ProcessUtilities
{
    public static bool is64bitProcess()
    {
        return IntPtr.Size == 8;
    }

    public static bool is64bitOperatingSystem()
    {
        if (is64bitProcess() == true)
            return true;
        bool retVal = false;
        retVal = IsWow64Process(Process.GetCurrentProcess().Handle, out retVal) && retVal;
        return retVal;
    }

    public static string GetCurrentDirectory(int processId)
    {
        return GetProcessParametersString(processId, is64bitOperatingSystem() ? (ulong)0x38 : (ulong)0x24);
    }

    private static string GetProcessParametersString(int processId, ulong offset)
    {
        IntPtr handle = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, false, processId);

        ulong processParametersOffset = is64bitOperatingSystem() ? (ulong)0x20 : (ulong)0x10;
        try
        {
            if (is64bitOperatingSystem() && !is64bitProcess()) // are we running in WOW?
            {
                PROCESS_BASIC_INFORMATION_WOW64 pbi = new PROCESS_BASIC_INFORMATION_WOW64();
                if (NtWow64QueryInformationProcess64(handle, 0, ref pbi, Marshal.SizeOf(pbi), IntPtr.Zero) != 0)
                    return null;

                ulong pp = 0;
                if (NtWow64ReadVirtualMemory64(handle, (ulong)(pbi.PebBaseAddress) + processParametersOffset, ref pp, Marshal.SizeOf(pp), IntPtr.Zero) != 0)
                    return null;

                UNICODE_STRING_WOW64 us = new UNICODE_STRING_WOW64();
                if (NtWow64ReadVirtualMemory64(handle, pp + offset, ref us, Marshal.SizeOf(us), IntPtr.Zero) != 0)
                    return null;

                if ((us.Buffer == 0) || (us.Length == 0))
                    return null;

                string s = new string('\0', us.Length / 2);

                if (NtWow64ReadVirtualMemory64(handle, (ulong)us.Buffer, s, us.Length, IntPtr.Zero) != 0)
                    return null;

                return s;
            }
            else // we are running with the same bitness as the OS, 32 or 64
            {
                PROCESS_BASIC_INFORMATION pbi = new PROCESS_BASIC_INFORMATION();
                if (NtQueryInformationProcess(handle, 0, ref pbi, Marshal.SizeOf(pbi), IntPtr.Zero) != 0)
                    return null;

                IntPtr pp_size = IntPtr.Zero;
                if (ReadProcessMemory(handle, (IntPtr)((ulong)pbi.PebBaseAddress + processParametersOffset), ref pp_size, new IntPtr(Marshal.SizeOf(pp_size)), IntPtr.Zero) == 0)
                    return null;
                ulong pp = (ulong)pp_size;

                UNICODE_STRING us = new UNICODE_STRING();
                if (ReadProcessMemory(handle, (IntPtr)(pp + offset), ref us, new IntPtr(Marshal.SizeOf(us)), IntPtr.Zero) == 0)
                    return null;

                if ((us.Buffer == IntPtr.Zero) || (us.Length == 0))
                    return null;

                string s = new string('\0', us.Length / 2);
                if (ReadProcessMemory(handle, (IntPtr)us.Buffer, s, new IntPtr(us.Length), IntPtr.Zero) == 0)
                    return null;
                    
                return s;
            }
        }
        finally
        {
            CloseHandle(handle);
        }
    }

    public static List<string> GetEnvironement(int processId)
    {
        return GetProcessEnvString(processId, is64bitOperatingSystem() ? (ulong)0x80 : (ulong)0x48);
    }

    private static List<string> GetProcessEnvString(int processId, ulong offset)
    {
        IntPtr handle = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, false, processId);

        ulong processParametersOffset = is64bitOperatingSystem() ? (ulong)0x20 : (ulong)0x10;
        try
        {
            if (is64bitOperatingSystem() && !is64bitProcess()) // are we running in WOW?
            {
                PROCESS_BASIC_INFORMATION_WOW64 pbi = new PROCESS_BASIC_INFORMATION_WOW64();
                if (NtWow64QueryInformationProcess64(handle, 0, ref pbi, Marshal.SizeOf(pbi), IntPtr.Zero) != 0)
                    return null;

                ulong pp = 0;
                if (NtWow64ReadVirtualMemory64(handle, (ulong)(pbi.PebBaseAddress) + processParametersOffset, ref pp, Marshal.SizeOf(pp), IntPtr.Zero) != 0)
                    return null;

                ulong envPtr = 0;
                if (NtWow64ReadVirtualMemory64(handle, pp + offset, ref envPtr, Marshal.SizeOf(envPtr), IntPtr.Zero) != 0)
                    return null;

                if (envPtr == 0)
                    return null;

                ulong j = 0;
                List<string> ret = new List<string>();

                while (true)
                {
                    string currentStrEnv = String.Empty;
                    while (true)
                    {
                        char ansi_char = '\0';
                        if (NtWow64ReadVirtualMemory64(handle, envPtr + j, ref ansi_char, 2, IntPtr.Zero) != 0)
                            return null;
                        j = j + 2;
                        if (ansi_char == 0)
                            break;
                        currentStrEnv += new string(ansi_char, 1);
                    }

                    if (String.IsNullOrEmpty(currentStrEnv))
                        break;

                    ret.Add(currentStrEnv);
                }
                    
                return ret;
            }
            else
            {
                PROCESS_BASIC_INFORMATION pbi = new PROCESS_BASIC_INFORMATION();
                if (NtQueryInformationProcess(handle, 0, ref pbi, Marshal.SizeOf(pbi), IntPtr.Zero) != 0)
                    return null;

                IntPtr pp_size = IntPtr.Zero;
                if (ReadProcessMemory(handle, (IntPtr)((ulong)pbi.PebBaseAddress + processParametersOffset), ref pp_size, new IntPtr(Marshal.SizeOf(pp_size)), IntPtr.Zero) == 0)
                    return null;
                ulong pp = (ulong)pp_size;

                IntPtr envPtr_size = IntPtr.Zero;
                if (ReadProcessMemory(handle, (IntPtr)(pp + offset), ref envPtr_size, new IntPtr(Marshal.SizeOf(envPtr_size)), IntPtr.Zero) == 0)
                    return null;
                ulong envPtr = (ulong)envPtr_size;

                if (envPtr == 0)
                    return null;

                ulong j = 0;
                List<string> ret = new List<string>();

                while (true)
                {
                    string currentStrEnv = String.Empty;
                    while (true)
                    {
                        char ansi_char = '\0';
                        if (ReadProcessMemory(handle, (IntPtr)(envPtr + j), ref ansi_char, new IntPtr(2), IntPtr.Zero) == 0)
                            return null;
                        j = j + 2;
                        if (ansi_char == 0)
                            break;
                        currentStrEnv += new string(ansi_char, 1);
                    }

                    if (String.IsNullOrEmpty(currentStrEnv))
                        break;

                    ret.Add(currentStrEnv);
                }
                    
                return ret;
            }
        }
        finally
        {
            CloseHandle(handle);
        }
    }

    public class HandleInfo
    {
        public HandleInfo(ulong processId, ushort creatorBackTraceIndex, ushort objectTypeIndex, uint handleAttributes,
                ulong handleValue, ulong objectAddr, uint grantedAccess)
        {
            ProcessId = processId;
            CreatorBackTraceIndex = creatorBackTraceIndex;
            ObjectTypeIndex = objectTypeIndex;
            HandleAttributes = handleAttributes;
            HandleValue = handleValue;
            Object = objectAddr;
            GrantedAccess = grantedAccess;
        }

        public ulong ProcessId;
        public ushort CreatorBackTraceIndex;
        public ushort ObjectTypeIndex;
        public uint HandleAttributes;
        public ulong HandleValue; // the handle id
        public ulong Object;
        public uint GrantedAccess;
    }

    public static List<HandleInfo> GetProcessHandle(List<String> TypeName)
    {
        try
        {
            IntPtr Length = new IntPtr(4096);
            IntPtr handleInfo = IntPtr.Zero;
            List<HandleInfo> retObj = new List<HandleInfo>();

            while (true)
            {
                handleInfo = System.Runtime.InteropServices.Marshal.AllocHGlobal(Length);
                uint status = NtQuerySystemInformation(SYSTEM_INFORMATION_CLASS.SystemExtendedHandleInformation, handleInfo, Length, ref Length);
                if (status == 0)
                    break;
                if (status != 3221225476)
                    return null;
                System.Runtime.InteropServices.Marshal.FreeHGlobal(handleInfo);
            }

            if (is64bitProcess())
            {
                SYSTEM_HANDLE_INFORMATION_EX64 Cast = (SYSTEM_HANDLE_INFORMATION_EX64)System.Runtime.InteropServices.Marshal.PtrToStructure(handleInfo, typeof(SYSTEM_HANDLE_INFORMATION_EX64));

                ulong currentHandle = (ulong)handleInfo + (ulong)System.Runtime.InteropServices.Marshal.SizeOf(Cast);

                for (ulong i = 0; i < Cast.NumberOfHandles; i++)
                {
                    SYSTEM_HANDLE_TABLE_ENTRY_INFO_EX64 handle = (SYSTEM_HANDLE_TABLE_ENTRY_INFO_EX64)System.Runtime.InteropServices.Marshal.PtrToStructure((IntPtr)currentHandle, typeof(SYSTEM_HANDLE_TABLE_ENTRY_INFO_EX64));
                    retObj.Add(new HandleInfo(handle.UniqueProcessId, handle.CreatorBackTraceIndex, handle.ObjectTypeIndex,
                            handle.HandleAttributes, handle.HandleValue, handle.Object, handle.GrantedAccess));
                    currentHandle += (ulong)System.Runtime.InteropServices.Marshal.SizeOf(handle);
                }
            }
            else
            {
                SYSTEM_HANDLE_INFORMATION_EX32 Cast = (SYSTEM_HANDLE_INFORMATION_EX32)System.Runtime.InteropServices.Marshal.PtrToStructure(handleInfo, typeof(SYSTEM_HANDLE_INFORMATION_EX32));

                ulong currentHandle = (ulong)handleInfo + (ulong)System.Runtime.InteropServices.Marshal.SizeOf(Cast);;

                for (ulong i = 0; i < Cast.NumberOfHandles; i++)
                {
                    SYSTEM_HANDLE_TABLE_ENTRY_INFO_EX32 handle = (SYSTEM_HANDLE_TABLE_ENTRY_INFO_EX32)System.Runtime.InteropServices.Marshal.PtrToStructure((IntPtr)currentHandle, typeof(SYSTEM_HANDLE_TABLE_ENTRY_INFO_EX32));
                    retObj.Add(new HandleInfo(handle.UniqueProcessId, handle.CreatorBackTraceIndex, handle.ObjectTypeIndex,
                            handle.HandleAttributes, handle.HandleValue, handle.Object, handle.GrantedAccess));
                    currentHandle += (ulong)System.Runtime.InteropServices.Marshal.SizeOf(handle);
                }
            }

            System.Runtime.InteropServices.Marshal.FreeHGlobal(handleInfo);
            return retObj;
        }
        finally
        {
            
        }
    }

    public static List<String> GetHandleTypes()
    {
        IntPtr Length = new IntPtr(4096);
        IntPtr ObjectAllInfo = IntPtr.Zero;
        List<String> ret = new List<String>();

        while (true)
        {
            // The lenght return by NtQueryObject can be wrong
            ObjectAllInfo = System.Runtime.InteropServices.Marshal.AllocHGlobal((IntPtr)((ulong)Length + 64));
            uint status = NtQueryObject(IntPtr.Zero, OBJECT_INFORMATION_CLASS.ObjectAllTypeInformation, ObjectAllInfo, Length, ref Length);
            if (status == 0)
                break;
            if (status != 3221225476)
                return null;
            System.Runtime.InteropServices.Marshal.FreeHGlobal(ObjectAllInfo);
        }

        if (is64bitProcess())
        {
            OBJECT_ALL_TYPE_INFORMATION_64 Cast = (OBJECT_ALL_TYPE_INFORMATION_64)System.Runtime.InteropServices.Marshal.PtrToStructure(ObjectAllInfo, typeof(OBJECT_ALL_TYPE_INFORMATION_64));

            ulong currentHandle = (ulong)ObjectAllInfo + (ulong)System.Runtime.InteropServices.Marshal.SizeOf(Cast);
            for (ulong i = 0; i < Cast.NumberOfTypes && currentHandle < (ulong)ObjectAllInfo + (ulong)Length; i++)
            {
                OBJECT_TYPE_INFORMATION handle = (OBJECT_TYPE_INFORMATION)System.Runtime.InteropServices.Marshal.PtrToStructure((IntPtr)currentHandle, typeof(OBJECT_TYPE_INFORMATION));
                ret.Add(System.Runtime.InteropServices.Marshal.PtrToStringUni(handle.TypeName.Buffer));

                // The start of the next object is given with the end of the string
                ulong EndObject = (ulong)handle.TypeName.Buffer + (ulong)handle.TypeName.MaximumLength;
                // We have to aligns the pointer
                currentHandle = (EndObject + 7) & ~(ulong)7;
            }
        }
        else
        {
            OBJECT_ALL_TYPE_INFORMATION_32 Cast = (OBJECT_ALL_TYPE_INFORMATION_32)System.Runtime.InteropServices.Marshal.PtrToStructure(ObjectAllInfo, typeof(OBJECT_ALL_TYPE_INFORMATION_32));
            ulong currentHandle = (ulong)ObjectAllInfo + (ulong)System.Runtime.InteropServices.Marshal.SizeOf(Cast);
            for (ulong i = 0; i < Cast.NumberOfTypes && currentHandle < (ulong)ObjectAllInfo + (ulong)Length; i++)
            {
                OBJECT_TYPE_INFORMATION handle = (OBJECT_TYPE_INFORMATION)System.Runtime.InteropServices.Marshal.PtrToStructure((IntPtr)currentHandle, typeof(OBJECT_TYPE_INFORMATION));
                ret.Add(System.Runtime.InteropServices.Marshal.PtrToStringUni(handle.TypeName.Buffer));

                // The start of the next object is given with the end of the string
                ulong EndObject = (ulong)handle.TypeName.Buffer + (ulong)handle.TypeName.MaximumLength;
                // We have to aligns the pointer
                currentHandle = (EndObject + 3) & ~(ulong)3;
            }
        }

        System.Runtime.InteropServices.Marshal.FreeHGlobal(ObjectAllInfo);

        return ret;
    }

    private const int PROCESS_QUERY_INFORMATION = 0x400;
    private const int PROCESS_VM_READ = 0x10;

    [StructLayout(LayoutKind.Sequential)]
    private struct PROCESS_BASIC_INFORMATION
    {
        public IntPtr Reserved1;
        public IntPtr PebBaseAddress;
        public IntPtr Reserved2_0;
        public IntPtr Reserved2_1;
        public IntPtr UniqueProcessId;
        public IntPtr Reserved3;
    }

    [StructLayout(LayoutKind.Sequential)]
    private struct UNICODE_STRING
    {
        public ushort Length;
        public ushort MaximumLength;
        public IntPtr Buffer;
    }

    [StructLayout(LayoutKind.Sequential)]
    private struct MEMORY_BASIC_INFORMATION
    {
        public uint BaseAddress;
        public uint AllocationBase;
        public uint AllocationProtect;
        public uint RegionSize;
        public uint State;
        public uint Protect;
        public uint Type;
    }

    // for 32-bit process in a 64-bit OS only
    [StructLayout(LayoutKind.Sequential)]
    private struct PROCESS_BASIC_INFORMATION_WOW64
    {
        public long Reserved1;
        public long PebBaseAddress;
        public long Reserved2_0;
        public long Reserved2_1;
        public long UniqueProcessId;
        public long Reserved3;
    }

    // for 32-bit process in a 64-bit OS only
    [StructLayout(LayoutKind.Sequential)]
    private struct UNICODE_STRING_WOW64
    {
        public short Length;
        public short MaximumLength;
        public long Buffer;
    }

    [StructLayout(LayoutKind.Sequential)]
    private struct SYSTEM_HANDLE_TABLE_ENTRY_INFO_EX32
    {
        public uint Object;
        public uint UniqueProcessId;
        public uint HandleValue;
        public uint GrantedAccess;
        public ushort CreatorBackTraceIndex;
        public ushort ObjectTypeIndex;
        public uint HandleAttributes;
        public uint Reserved;
    }

    [StructLayout(LayoutKind.Sequential)]
    private struct SYSTEM_HANDLE_INFORMATION_EX32
    {
        public uint NumberOfHandles;
        public uint Reserved;
    }

    [StructLayout(LayoutKind.Sequential)]
    private struct SYSTEM_HANDLE_TABLE_ENTRY_INFO_EX64
    {
        public ulong Object;
        public ulong UniqueProcessId;
        public ulong HandleValue;
        public uint GrantedAccess;
        public ushort CreatorBackTraceIndex;
        public ushort ObjectTypeIndex;
        public uint HandleAttributes;
        public uint Reserved;
    }

    [StructLayout(LayoutKind.Sequential)]
    private struct SYSTEM_HANDLE_INFORMATION_EX64
    {
        public ulong NumberOfHandles;
        public ulong Reserved;
    }

    [StructLayout(LayoutKind.Sequential)]
    private struct OBJECT_ALL_TYPE_INFORMATION_64
    {
        public uint NumberOfTypes;
        public uint Undocumented;
    }

    [StructLayout(LayoutKind.Sequential)]
    private struct OBJECT_ALL_TYPE_INFORMATION_32
    {
        public uint NumberOfTypes;
    }

    [StructLayout(LayoutKind.Sequential)]
    private struct ACCESS_MASK
    {
        public uint AccessMask;
    }

    [StructLayout(LayoutKind.Sequential)]
    private struct GENERIC_MAPPING
    {
        public ACCESS_MASK GenericRead;
        public ACCESS_MASK GenericWrite;
        public ACCESS_MASK GenericExecute;
        public ACCESS_MASK GenericAll;
    }

    /*[StructLayout(LayoutKind.Sequential)]
    private struct OBJECT_TYPE_INFORMATION
    {
        public UNICODE_STRING TypeName;
        public ulong TotalNumberOfObjects;
        public ulong TotalNumberOfHandles;
        public ulong TotalPagedPoolUsage;
        public ulong TotalNonPagedPollUsage;
        public ulong TotalNamePoolUsage;
        public ulong TotalHandleTableUsage;
        public ulong HighWaterNumberOfObject;
        public ulong HighWaterNumberOfHandles;
        public ulong HighWaterPagedPoolUsage;
        public ulong HighWaterNonPagedPoolUsage;
        public ulong HighWaterNamePoolUsage;
        public ulong HighWaterHandleTableUsage;
        public ulong InvalidAttributes;
        public GENERIC_MAPPING GenericMapping;
        public ulong ValidAccessMask;
        public int SecurityRequired;
        public int MaintainHandleCount;
        public byte TypeIndex;
        public sbyte ReserveByte;
        public ulong DefaultPagedPoolCharge;
        public ulong DefaultNonPagedPoolCharge;
    }*/
    [StructLayout(LayoutKind.Sequential)]
    private struct OBJECT_TYPE_INFORMATION
    {
        public UNICODE_STRING TypeName;
        public int TotalNumberOfObjects;
        public int TotalNumberOfHandles;
        public int TotalPagedPoolUsage;
        public int TotalNonPagedPollUsage;
        public int TotalNamePoolUsage;
        public int TotalHandleTableUsage;
        public int HighWaterNumberOfObject;
        public int HighWaterNumberOfHandles;
        public int HighWaterPagedPoolUsage;
        public int HighWaterNonPagedPoolUsage;
        public int HighWaterNamePoolUsage;
        public int HighWaterHandleTableUsage;
        public int InvalidAttributes;
        public GENERIC_MAPPING GenericMapping;
        public int ValidAccessMask;
        public byte SecurityRequired;
        public byte MaintainHandleCount;
        public int PoolType;
        public int DefaultPagedPoolCharge;
        public int DefaultNonPagedPoolCharge;
    }

    [DllImport("kernel32.dll")]
	private static extern uint GetLastError();

    [DllImport("kernel32.dll")]
    private static extern bool IsWow64Process(IntPtr hProcess, out bool retVal);

    [DllImport("ntdll.dll")]
    private static extern uint NtQuerySystemInformation(SYSTEM_INFORMATION_CLASS QueryType, IntPtr data, IntPtr Length, ref IntPtr ReturnLength);

    [DllImport("ntdll.dll")]
    private static extern int NtQueryInformationProcess(IntPtr ProcessHandle, int ProcessInformationClass, ref PROCESS_BASIC_INFORMATION ProcessInformation, int ProcessInformationLength, IntPtr ReturnLength);

    [DllImport("ntdll.dll")]
    private static extern uint NtQueryObject(IntPtr Handle, OBJECT_INFORMATION_CLASS ProcessInformationClass, IntPtr data, IntPtr ProcessInformationLength, ref IntPtr ReturnLength);

    [DllImport("kernel32.dll", SetLastError = true)]
    private static extern int ReadProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, ref ulong lpBuffer, IntPtr dwSize, IntPtr lpNumberOfBytesRead);

    [DllImport("kernel32.dll", SetLastError = true)]
    private static extern int ReadProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, ref IntPtr lpBuffer, IntPtr dwSize, IntPtr lpNumberOfBytesRead);

    [DllImport("kernel32.dll", SetLastError = true)]
    private static extern int ReadProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, ref char lpBuffer, IntPtr dwSize, IntPtr lpNumberOfBytesRead);
    
    [DllImport("kernel32.dll", SetLastError = true)]
    private static extern int ReadProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, ref UNICODE_STRING lpBuffer, IntPtr dwSize, IntPtr lpNumberOfBytesRead);

    [DllImport("kernel32.dll", SetLastError = true)]
    private static extern int ReadProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, [MarshalAs(UnmanagedType.LPWStr)] string lpBuffer, IntPtr dwSize, IntPtr lpNumberOfBytesRead);

    [DllImport("kernel32.dll", SetLastError = true)]
    private static extern IntPtr OpenProcess(int dwDesiredAccess, bool bInheritHandle, int dwProcessId);

    [DllImport("kernel32.dll")]
    private static extern bool CloseHandle(IntPtr hObject);

    // for 32-bit process in a 64-bit OS only
    [DllImport("ntdll.dll")]
    private static extern int NtWow64QueryInformationProcess64(IntPtr ProcessHandle, int ProcessInformationClass, ref PROCESS_BASIC_INFORMATION_WOW64 ProcessInformation, int ProcessInformationLength, IntPtr ReturnLength);

    [DllImport("ntdll.dll")]
    private static extern int NtWow64ReadVirtualMemory64(IntPtr hProcess, ulong lpBaseAddress, ref long lpBuffer, long dwSize, IntPtr lpNumberOfBytesRead);

    [DllImport("ntdll.dll")]
    private static extern int NtWow64ReadVirtualMemory64(IntPtr hProcess, ulong lpBaseAddress, ref ulong lpBuffer, long dwSize, IntPtr lpNumberOfBytesRead);

    [DllImport("ntdll.dll")]
    private static extern int NtWow64ReadVirtualMemory64(IntPtr hProcess, ulong lpBaseAddress, ref char lpBuffer, long dwSize, IntPtr lpNumberOfBytesRead);

    [DllImport("ntdll.dll")]
    private static extern int NtWow64ReadVirtualMemory64(IntPtr hProcess, ulong lpBaseAddress, ref UNICODE_STRING_WOW64 lpBuffer, long dwSize, IntPtr lpNumberOfBytesRead);

    [DllImport("ntdll.dll")]
    private static extern int NtWow64ReadVirtualMemory64(IntPtr hProcess, ulong lpBaseAddress, [MarshalAs(UnmanagedType.LPWStr)] string lpBuffer, long dwSize, IntPtr lpNumberOfBytesRead);

    private enum OBJECT_INFORMATION_CLASS : int
    {
        ObjectBasicInformation,
        ObjectNameInformation,
        ObjectTypeInformation,
        ObjectAllTypeInformation,
        ObjectHandleInformation,
    }

    private enum SYSTEM_INFORMATION_CLASS : int
    {
        SystemBasicInformation,
        SystemProcessorInformation,
        SystemPerformanceInformation,
        SystemTimeOfDayInformation,
        SystemPathInformation,
        SystemProcessInformation,
        SystemCallCountInformation,
        SystemDeviceInformation,
        SystemProcessorPerformanceInformation,
        SystemFlagsInformation,
        SystemCallTimeInformation,
        SystemModuleInformation,
        SystemLocksInformation,
        SystemStackTraceInformation,
        SystemPagedPoolInformation,
        SystemNonPagedPoolInformation,
        SystemHandleInformation,
        SystemObjectInformation,
        SystemPageFileInformation,
        SystemVdmInstemulInformation,
        SystemVdmBopInformation,
        SystemFileCacheInformation,
        SystemPoolTagInformation,
        SystemInterruptInformation,
        SystemDpcBehaviorInformation,
        SystemFullMemoryInformation,
        SystemLoadGdiDriverInformation,
        SystemUnloadGdiDriverInformation,
        SystemTimeAdjustmentInformation,
        SystemSummaryMemoryInformation,
        SystemNextEventIdInformation,
        SystemEventIdsInformation,
        SystemCrashDumpInformation,
        SystemExceptionInformation,
        SystemCrashDumpStateInformation,
        SystemKernelDebuggerInformation,
        SystemContextSwitchInformation,
        SystemRegistryQuotaInformation,
        SystemExtendServiceTableInformation,
        SystemPrioritySeperation,
        SystemPlugPlayBusInformation,
        SystemDockInformation,
        SystemPowerInformation,
        SystemProcessorSpeedInformation,
        SystemCurrentTimeZoneInformation,
        SystemLookasideInformation,

        SystemExtendedHandleInformation = 0x40
    }
}
"@

function Get-ProcessGroupsSid {
    <#
	.SYNOPSYS
	Get sid groups of a process

	.PARAMETER
	The handle on processus token

	.EXAMPLE
	Get-ProcessGroupsSid $hToken
	#>

	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)]
		[int]$hToken
	)

	# Call GetTokenInformation to get TokenGroups
	[int]$Length = 0
	$CallResult = [Advapi32]::GetTokenInformation($hToken, [TOKEN_INFORMATION_CLASS]::TokenGroups, [IntPtr]::Zero, $Length, [ref]$Length)
	
	[IntPtr]$TokenInformation = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($Length)
	$CallResult = [Advapi32]::GetTokenInformation($hToken, [TOKEN_INFORMATION_CLASS]::TokenGroups, $TokenInformation, $Length, [ref]$Length)
    if ($CallResult -eq $false) {
        [System.Runtime.InteropServices.Marshal]::FreeHGlobal($TokenInformation)
        # Write-Error "[!] Unable to access process Privilege.`n"
        return $null
    }

	# Read dword at $TokenInformation to get privilege count
	$BuffOffset = $TokenInformation.ToInt64()
	$SidCount = [System.Runtime.InteropServices.Marshal]::ReadInt32($BuffOffset)
	$BuffOffset = $BuffOffset + [IntPtr]::Size # Offset privilege count

	# Create LUID and attributes object
	$SID_AND_ATTRIBUTES = New-Object SID_AND_ATTRIBUTES
	$SID_AND_ATTRIBUTES_Size = [System.Runtime.InteropServices.Marshal]::SizeOf($SID_AND_ATTRIBUTES)
	$SID_AND_ATTRIBUTES = $SID_AND_ATTRIBUTES.GetType()

	# Loop with $BuffOffset on all groups sid
	$SidArray = @()
	for ($i=0; $i -lt $SidCount; $i++) {

		# Cast IntPtr to SID_AND_ATTRIBUTES
		$SidPointer = New-Object System.Intptr -ArgumentList $BuffOffset
		$Cast = [system.runtime.interopservices.marshal]::PtrToStructure($SidPointer,[type]$SID_AND_ATTRIBUTES)

        $sid = Convert-BinarySidToString $Cast.Sid
        if ($sid -eq $null) {
            Write-LogLine "[!] Unable to Convert SID.`n"
        }

		# Create result object
		$SidArray += New-Object PSObject -Property @{
			SID = $sid
            AttributesRaw = $Cast.Attributes
		}

		$BuffOffset = $BuffOffset + $SID_AND_ATTRIBUTES_Size

	}

	# Free $TokenInformation
	[System.Runtime.InteropServices.Marshal]::FreeHGlobal($TokenInformation)

    return $SidArray
}

function Get-ProcessAppContainerSid {
    <#
	.SYNOPSYS
	Get the string app container sid of a process

	.PARAMETER
	The handle on processus token

	.EXAMPLE
	Get-ProcessAppContainerSid $hToken
	#>

	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)]
		[int]$hToken
	)

	# Call GetTokenInformation with TokenInformationClass = TokenUser to get the binary sid
	[int]$Length = 0
	$CallResult = [Advapi32]::GetTokenInformation($hToken, [TOKEN_INFORMATION_CLASS]::TokenAppContainerSid, [IntPtr]::Zero, $Length, [ref]$Length)
	[IntPtr]$TokenAppContainer = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($Length)
	$CallResult = [Advapi32]::GetTokenInformation($hToken, [TOKEN_INFORMATION_CLASS]::TokenAppContainerSid, $TokenAppContainer, $Length, [ref]$Length)
    if ($CallResult -eq $false) {
        [System.Runtime.InteropServices.Marshal]::FreeHGlobal($TokenAppContainer)
        $ErrorCode = [Kernel32]::GetLastError();
        if ($ErrorCode -ne 87) {
            # Error 87 is ERROR_INVALIDE_PARAMETER
            # This code is return whene windows do not know what app container is
            # This append for exemple whis windows 7
            Write-LogLine "[!] Unable to access process TOKEN_APP_CONTAINER.`n"
        }
        return $null
    }

    $TOKEN_APPCONTAINER_INFORMATION = New-Object TOKEN_APPCONTAINER_INFORMATION
	$TOKEN_APPCONTAINER_INFORMATION = $TOKEN_APPCONTAINER_INFORMATION.GetType()
    $Cast = [system.runtime.interopservices.marshal]::PtrToStructure($TokenAppContainer, [type]$TOKEN_APPCONTAINER_INFORMATION)

    $ret = Convert-BinarySidToString $Cast.TokenAppContainer.Sid

    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($TokenAppContainer)
    return $ret
}

function Get-ProcessBinarySid {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)]
		[int]$hToken
	)

	# Call GetTokenInformation with TokenInformationClass = TokenUser to get the binary sid
	[int]$Length = 0
	$CallResult = [Advapi32]::GetTokenInformation($hToken, [TOKEN_INFORMATION_CLASS]::TokenUser, [IntPtr]::Zero, $Length, [ref]$Length)
	[IntPtr]$TokenUser = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($Length)
	$CallResult = [Advapi32]::GetTokenInformation($hToken, [TOKEN_INFORMATION_CLASS]::TokenUser, $TokenUser, $Length, [ref]$Length)
    if ($CallResult -eq $false) {
        [System.Runtime.InteropServices.Marshal]::FreeHGlobal($TokenUser)
        Write-LogLine "[!] Unable to access process TOKEN_USER.`n"
        return $null
    }

    return $TokenUser
}

function Convert-BinarySidToString
{
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)]$BinarySid
	)

    # Convert the sid to sid-string
    $sid = [string]::Empty
    $CallResult = [Advapi32]::ConvertSidToStringSid($BinarySid, [ref]$sid)
    if ($CallResult -eq $false) {
        return $null
    }

    return $sid.ToString()
}

function Convert-BinarySidToAccountName
{
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)]
		$BinarySid
	)

    # Call LookupAccountSid to get domaine\username of the binary sid
    [int]$NameLen = 0
    [int]$DomaineLen = 0
    [int]$PeUse = 0
    $CallResult = [Advapi32]::LookupAccountSid([IntPtr]::Zero, $BinarySid, [IntPtr]::Zero, [ref]$NameLen, [IntPtr]::Zero, [ref]$DomaineLen, [ref]$PeUse)

	[IntPtr]$UserName = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($NameLen * 2)
	[IntPtr]$DomaineName = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($DomaineLen * 2)

    $CallResult = [Advapi32]::LookupAccountSid([IntPtr]::Zero, $Cast.User.Sid, $UserName, [ref]$NameLen, $DomaineName, [ref]$DomaineLen, [ref]$PeUse)
    if ($CallResult -eq $true) {
        $ret = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($DomaineName) + "\" + [System.Runtime.InteropServices.Marshal]::PtrToStringUni($UserName)
    }
    
	[System.Runtime.InteropServices.Marshal]::FreeHGlobal($UserName)
	[System.Runtime.InteropServices.Marshal]::FreeHGlobal($DomaineName)

    return $ret
}

function Get-ProcessSid {
    <#
	.SYNOPSYS
	Get the string sid of a process

	.PARAMETER
	The handle on processus token

	.EXAMPLE
	Get-ProcessSid $hToken
	#>

	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)]
		[int]$hToken,
        [bool]$ResolveAccountName = $false
	)

    $TokenUser = Get-ProcessBinarySid $hToken
    if ($TokenUser -eq $null) {
        Write-LogLine "[!] Unable to access process SID.`n"
        return $null
    }

    $TOKEN_USER = New-Object TOKEN_USER
	$TOKEN_USER = $TOKEN_USER.GetType()
    $Cast = [system.runtime.interopservices.marshal]::PtrToStructure($TokenUser, [type]$TOKEN_USER)

    if ($ResolveAccountName) {
        $ret = Convert-BinarySidToAccountName $Cast.User.Sid
        if ($ret -eq $null) {
            Write-LogLine "[!] Unable to Convert SID.`n"
        }
    }else {
        $ret = Convert-BinarySidToString $Cast.User.Sid
        if ($ret -eq $null) {
            Write-LogLine "[!] Unable to Convert SID.`n"
        }
    }

    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($TokenUser)
    return $ret
}

function Get-ProcessPrivilege {
    <#
	.SYNOPSYS
	Get Privilege of a process

	.PARAMETER
	The handle on processus token

	.EXAMPLE
	Get-ProcessPrivilege $hToken
	#>

	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)]
		[int]$hToken
	)

	# Call GetTokenInformation to get TokenPrivileges
	[int]$Length = 0
	$CallResult = [Advapi32]::GetTokenInformation($hToken, [TOKEN_INFORMATION_CLASS]::TokenPrivileges, [IntPtr]::Zero, $Length, [ref]$Length)
	
	[IntPtr]$TokenInformation = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($Length)
	$CallResult = [Advapi32]::GetTokenInformation($hToken, [TOKEN_INFORMATION_CLASS]::TokenPrivileges, $TokenInformation, $Length, [ref]$Length)
    if ($CallResult -eq $false) {
        [System.Runtime.InteropServices.Marshal]::FreeHGlobal($TokenInformation)
        Write-LogLine "[!] Unable to access process Privilege.`n"
        return $null
    }

	# Read dword at $TokenInformation to get privilege count
	$BuffOffset = $TokenInformation.ToInt64()
	$PrivCount = [System.Runtime.InteropServices.Marshal]::ReadInt32($BuffOffset)
	$BuffOffset = $BuffOffset + 4 # Offset privilege count
	
	# Create LUID and attributes object
	$LUID_AND_ATTRIBUTES = New-Object LUID_AND_ATTRIBUTES
	$LUID_AND_ATTRIBUTES_Size = [System.Runtime.InteropServices.Marshal]::SizeOf($LUID_AND_ATTRIBUTES)
	$LUID_AND_ATTRIBUTES = $LUID_AND_ATTRIBUTES.GetType()
	
	# Loop with $BuffOffset on all LUID, when query the privilege name of the LUID with LookupPrivilegeName
	$LuidPrivilegeArray = @()
	for ($i=0; $i -lt $PrivCount; $i++) {

		# Cast IntPtr to LUID_AND_ATTRIBUTES
		$PrivPointer = New-Object System.Intptr -ArgumentList $BuffOffset
		$Cast = [system.runtime.interopservices.marshal]::PtrToStructure($PrivPointer,[type]$LUID_AND_ATTRIBUTES)

		# Cast LUID sub-struct back to IntPtr
		$LuidSize = [System.Runtime.InteropServices.Marshal]::SizeOf($Cast.Luid)
		[IntPtr]$lpLuid = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($LuidSize)
		[system.runtime.interopservices.marshal]::StructureToPtr($Cast.Luid, $lpLuid, $true)

		# Call to get lpName length, create System.Text.StringBuilder object & call again
		[int]$Length = 0
		$CallResult = [Advapi32]::LookupPrivilegeName($null, $lpLuid, $null, [ref]$Length)
		$lpName = New-Object -TypeName System.Text.StringBuilder
		$lpName.EnsureCapacity($Length+1) | Out-Null
		$CallResult = [Advapi32]::LookupPrivilegeName($null, $lpLuid, $lpName, [ref]$Length)
        if ($CallResult -eq $false) {
            [System.Runtime.InteropServices.Marshal]::FreeHGlobal($lpLuid)
            [System.Runtime.InteropServices.Marshal]::FreeHGlobal($TokenInformation)
            Write-LogLine "[!] Unable to access process Privilege.`n"
            return $null
        }

		# Create result object
		$LuidPrivilegeArray += New-Object PSObject -Property @{
			LUID = $Cast.Luid.LowPart
			Privilege = $lpName.ToString()
		}
		
		# Free $LuidSize & increment $BuffOffset
		[System.Runtime.InteropServices.Marshal]::FreeHGlobal($lpLuid)
		$BuffOffset = $BuffOffset + $LUID_AND_ATTRIBUTES_Size

	}

	# Free $TokenInformation
	[System.Runtime.InteropServices.Marshal]::FreeHGlobal($TokenInformation)

    return $LuidPrivilegeArray
}

function Escape-WmiParameter {
    [CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)][string]$Str
	)
    $Str -replace '([\\''"])','\$1'
}

function Get-AccountSid {
    [CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)]
		[string]$AccountCaption
	)

    $AccountCaptionSplit = @($AccountCaption -split '\\')
    if ($AccountCaptionSplit.Count -eq 1) {
        $AccountName = $AccountCaptionSplit[0]
        $AccountDomain = (Get-WmiObject Win32_ComputerSystem).Name
    } elseif ($AccountCaptionSplit.Count -eq 2) {
        $AccountName = $AccountCaptionSplit[1]
        $AccountDomain = $AccountCaptionSplit[0]
    } else {
        Write-LogLine "[!] Error: username can not containe mutiple backslash. $AccountCaption `n"
        return $null
    }

    $account = Get-UserInfoFromAccountName ($AccountDomain + '\' + $AccountName)
    if ($account) {
        $account.SID
    } else {
        $null
    }
}

function Get-LocalAdministrorsCaption {

    [CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)]
		[string]$GroupSid = 'S-1-5-32-544'
	)

    $AdministratorsGroup = Get-WmiObject -Class Win32_Group -Filter "SID='$GroupSid' AND localaccount='True'"
    $AdministratorsGroup.Caption
}

function Get-LocalAdministrorsCaption {

    [CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)]
		[string]$GroupSid = 'S-1-5-32-544'
	)

    $AdministratorsGroup = Get-WmiObject -Class Win32_Group -Filter "SID='$GroupSid' AND localaccount='True'"
    $AdministratorsGroup.Caption
}

function Get-UserInfoFromDirectoryEntry {
    [CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)][DirectoryServices.DirectoryEntry]$obj
	)
    # Remove the domain before computer name
    $userPath = ($obj.Path -replace '/','\').Substring(8).Split('\')[-2, -1] -join '\'
    $groupType = $obj.groupType.value
    return @{
        SID = (New-Object System.Security.Principal.SecurityIdentifier($obj.objectSid.value, 0)).Value
        groupType = if ($groupType -is [Int32]) { [Int32]$groupType } else { 0 }
        Name = $userPath
        isGroup = $groupType -is [Int32]
    }
}

function Get-DirectoryEntryFromAccountName {
    [CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)][String]$Name
	)

    [DirectoryServices.DirectoryEntry]([ADSI]("WinNT://" + ($Name -replace '\\', '/')))
}

function Get-UserInfoFromAccountName {
    [CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)][String]$Name
	)

    try {
        Get-UserInfoFromDirectoryEntry (Get-DirectoryEntryFromAccountName $Name)
    } Catch [System.Management.Automation.MethodInvocationException] {
        $null
    }
}

function Get-LocalGroupMember {
    [CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)][string]$Path = $null
	)

    $original = Get-UserInfoFromAccountName $Path

    New-Object PSObject -Property $original
    [System.Collections.ArrayList]$expandGroup = @($original.Name)
    $already_get = @{$original.sid = $true}

    while (0 -lt $expandGroup.Count) {
        $currentGroupName = $expandGroup[0]
        $expandGroup.RemoveAt(0)
        $groupMember = Get-DirectoryEntryFromAccountName $currentGroupName
        $groupMember_invoke = @($groupMember.Invoke("Members"))
        $i = 0
        while ($i -lt $groupMember_invoke.Count) {
            Try {
                $objuser = Get-UserInfoFromDirectoryEntry $groupMember_invoke[$i]
                if (-not $already_get.ContainsKey($objuser.sid)) {
                    $already_get[$objuser.sid] = $true
                    $objuser['parent'] = $currentGroupName
                    if ($newret.isGroup -and ($extractADAdmin -or $newret.groupType -eq 4)) {
                        $_ = $expandGroup.Add($objuser.Name)
                    }
                    New-Object PSObject -Property $objuser
                }
            } Catch [System.Management.Automation.ExtendedTypeSystemException] {
                Write-LogLine ("[!] Error failed to get member of " + $currentGroupName + "`n")
            }
            $i++
        }
    }
}

function Get-ProcessNetworkTCP {
    [CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)]
		[bool]$IsIpv6
	)

    if ($IsIpv6) {
        $Protocol = "TCPv6"
        $ipversion = 23 # AF_INET6
        $MIB_TCPROW_OWNER_PID = New-Object MIB_TCP6ROW_OWNER_PID
        $MIB_TCPROW_OWNER_PID_SIZE = [System.Runtime.InteropServices.Marshal]::SizeOf($MIB_TCPROW_OWNER_PID)
        $MIB_TCPROW_OWNER_PID = $MIB_TCPROW_OWNER_PID.GetType()
    } else {
        $Protocol = "TCP"
        $ipversion = 2 # AF_INET
        $MIB_TCPROW_OWNER_PID = New-Object MIB_TCPROW_OWNER_PID
        $MIB_TCPROW_OWNER_PID_SIZE = [System.Runtime.InteropServices.Marshal]::SizeOf($MIB_TCPROW_OWNER_PID)
        $MIB_TCPROW_OWNER_PID = $MIB_TCPROW_OWNER_PID.GetType()
    }
    $Length = 0
    $CallResult = [Iphlpapi]::GetExtendedTcpTable([IntPtr]::Zero, [ref]$Length, $true, $ipversion, [TCP_TABLE_CLASS]::TCP_TABLE_OWNER_PID_ALL, 0)
    [IntPtr]$TCPInformation = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($Length)
    $CallResult = [Iphlpapi]::GetExtendedTcpTable($TCPInformation, [ref]$Length, $true, $ipversion, [TCP_TABLE_CLASS]::TCP_TABLE_OWNER_PID_ALL, 0)
    if ($CallResult -ne 0) {
        [System.Runtime.InteropServices.Marshal]::FreeHGlobal($TCPInformation)
        Write-LogLine "[!] Unable to get Tcp table.`n"
        return $null
    }

    # GetExtendedTcpTable give you a struct. The structre containe a number and an array of MIB_TCPROW_OWNER_PID. The number is the size of the array.
    # Get the size of the array
	$BuffOffset = $TCPInformation.ToInt64()
	$TableCount = [System.Runtime.InteropServices.Marshal]::ReadInt32($BuffOffset)
	$BuffOffset = $BuffOffset + 4

    # loop with $BuffOffset to get all MIB_TCPROW_OWNER_PID
    $result = @()
	for ($i=0; $i -lt $TableCount; $i++) {

		$TablePointer = New-Object System.Intptr -ArgumentList $BuffOffset
		$Cast = [system.runtime.interopservices.marshal]::PtrToStructure($TablePointer,[type]$MIB_TCPROW_OWNER_PID)

        if ($IsIpv6) {
            $LocalAddr = New-Object IPAddress -ArgumentList $Cast.ucLocalAddr, $Cast.dwLocalScopeId
            $RemoteAddr = New-Object IPAddress -ArgumentList $Cast.ucRemoteAddr, $Cast.dwRemoteScopeId
        } else {
            $LocalAddr = New-Object IPAddress -ArgumentList $Cast.dwLocalAddr
            $RemoteAddr = New-Object IPAddress -ArgumentList $Cast.dwRemoteAddr
        }

        try {
            $LocalAddr = [String]$LocalAddr
        } catch {
            $LocalAddr = ""
        }
        try {
            $RemoteAddr = [String]$RemoteAddr
        } catch {
            $RemoteAddr = ""
        }

        # Extract all require data of MIB_TCPROW_OWNER_PID
        $result += New-Object PSObject -Property @{
            Protocol = $Protocol
            PID = $Cast.dwOwningPid
            State = $Cast.dwState
            LocalAddr = $LocalAddr
            LocalPort = $Cast.dwLocalPort
            RemoteAddr = $RemoteAddr
            RemotePort = $Cast.dwRemotePort
        }

        $BuffOffset += $MIB_TCPROW_OWNER_PID_SIZE
	}

    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($TCPInformation)

    return $result
}

function Get-ProcessNetworkUDP {
    [CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)]
		[bool]$IsIpv6
	)

    if ($IsIpv6) {
        $Protocol = "UDPv6"
        $ipversion = 23 # AF_INET6
        $MIB_UDPROW_OWNER_PID = New-Object MIB_UDP6ROW_OWNER_PID
        $MIB_UDPROW_OWNER_PID_SIZE = [System.Runtime.InteropServices.Marshal]::SizeOf($MIB_UDPROW_OWNER_PID)
        $MIB_UDPROW_OWNER_PID = $MIB_UDPROW_OWNER_PID.GetType()
    } else {
        $Protocol = "UDP"
        $ipversion = 2 # AF_INET
        $MIB_UDPROW_OWNER_PID = New-Object MIB_UDPROW_OWNER_PID
        $MIB_UDPROW_OWNER_PID_SIZE = [System.Runtime.InteropServices.Marshal]::SizeOf($MIB_UDPROW_OWNER_PID)
        $MIB_UDPROW_OWNER_PID = $MIB_UDPROW_OWNER_PID.GetType()
    }

    # Call GetExtendedUdpTable with AF_INET(2) to query all tcp ipv6 connection
    $Length = 0
    $CallResult = [Iphlpapi]::GetExtendedUdpTable([IntPtr]::Zero, [ref]$Length, $true, $ipversion, [UDP_TABLE_CLASS]::UDP_TABLE_OWNER_PID, 0)
    [IntPtr]$TCPInformation = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($Length)
    $CallResult = [Iphlpapi]::GetExtendedUdpTable($TCPInformation, [ref]$Length, $true, $ipversion, [UDP_TABLE_CLASS]::UDP_TABLE_OWNER_PID, 0)
    if ($CallResult -ne 0) {
        [System.Runtime.InteropServices.Marshal]::FreeHGlobal($TCPInformation)
        Write-LogLine "[!] Unable to get Udp table.`n"
        return $null
    }

    # GetExtendedTcpTable give you a struct. The structre containe a number and an array of MIB_UDPROW_OWNER_PID. The number is the size of the array.
    # Get the size of the array
	$BuffOffset = $TCPInformation.ToInt64()
	$TableCount = [System.Runtime.InteropServices.Marshal]::ReadInt32($BuffOffset)
	$BuffOffset = $BuffOffset + 4

    # loop with $BuffOffset to get all MIB_UDPROW_OWNER_PID
    $result = @()
	for ($i=0; $i -lt $TableCount; $i++) {

		$TablePointer = New-Object System.Intptr -ArgumentList $BuffOffset
		$Cast = [system.runtime.interopservices.marshal]::PtrToStructure($TablePointer,[type]$MIB_UDPROW_OWNER_PID)

        if ($IsIpv6) {
            $LocalAddr = New-Object IPAddress -ArgumentList $Cast.ucLocalAddr, $Cast.dwLocalScopeId
        } else {
            $LocalAddr = New-Object IPAddress -ArgumentList $Cast.dwLocalAddr
        }

        try {
            $LocalAddr = [String]$LocalAddr
        } catch {
            $LocalAddr = ""
        }

        # Extract all require data of MIB_UDPROW_OWNER_PID
        $result += New-Object PSObject -Property @{
            Protocol = $Protocol
            PID = $Cast.dwOwningPid
            LocalAddr = $LocalAddr
            LocalPort = $Cast.dwLocalPort
        }

        $BuffOffset += $MIB_UDPROW_OWNER_PID_SIZE
	}

    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($TCPInformation)

    return $result
}

function Get-ProcessNetwork {
    <#
	.SYNOPSYS
	Get All port open (udp/tcp ipv4/ipv6) and associate programe PID

	.PARAMETER
	no parameter

	.EXAMPLE
	Get-ProcessNetwork
	#>
    Get-ProcessNetworkTCP -IsIpv6 $false
    Get-ProcessNetworkTCP -IsIpv6 $true
    Get-ProcessNetworkUDP -IsIpv6 $false
    Get-ProcessNetworkUDP -IsIpv6 $true
}

function Get-ProcessHandles {
    <#
	.SYNOPSYS
	Get handles of a process given in parameter with sysinternal handle.exe / handle64.exe

	.PARAMETER
	PID of process to list handles

	.EXAMPLE
	Get-ProcessHandles ((Get-Process explorer).id)
	#>

	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)]$ProcessId,
        [Parameter(Mandatory = $True)]$handle_path
	)

    $HandleOutput = & $handle_path -a -p $ProcessId -nobanner /accepteula

    If ($HandleOutput -like "No matching handles found.*") {
        return $null
    }

    $result = @()
    ForEach ($line in $HandleOutput -split "`n`r") {
        if ($line -eq "") {
            continue
        }
        $Data = $line.split(" ", 2, [System.StringSplitOptions]::RemoveEmptyEntries)

        $Id = [convert]::ToInt64($Data[0] -replace ":", 16)
        if ($Data[1][13] -eq " ") {
            $Path = $Data[1].SubString(14)
            $Type = $Data[1].SubString(0, 13).Trim()
        } Elseif ($Data[1][14] -eq " ") {
            $Path = $Data[1].SubString(15)
            $Type = $Data[1].SubString(0, 14).Trim()
        } Else {
            $Type = $Data[1]
            $Path = ""
        }

        $result += New-Object PSObject -Property @{
            Id = [String]$Id
            Type = [String]$Type
            Path = [String]$Path
        }
    }
    return $result
}

function Get-ProcessInfo {
    <#

    .SYNOPSIS
    This script is like a super Get-Process with more information (Permition / Open port / open handle)

    .EXAMPLE
    Get-Process powershell | Get-InfoProcess

    #>

    $HandleType = [ProcessUtilities]::GetHandleTypes()
    $HandlePerm = [ProcessUtilities]::GetProcessHandle($HandleType)

    $handle_path = $null
    If ([ProcessUtilities]::Is64BitOperatingSystem() -eq $true) {
        If ((Test-Path -Path .\handle64.exe) -eq $false) {
            Write-LogLine ("[!] binary .\handle64.exe not found.`n")
        } else {
            $handle_path = ".\handle64.exe"
        }
    } Else {
        If ((Test-Path -Path .\handle.exe) -eq $false) {
                Write-LogLine ("[!] binary .\handle.exe not found.`n")
            return $null
        } else {
            $handle_path = ".\handle.exe"
        }
    }

    $result = @()
    foreach ($p in $input) {

        $ProcessId = $p.id

        $Process = Get-Process -Id $ProcessId
        $ProcessResult = @{
            PID = $p.id
            ProcessName = $Process.ProcessName
            SessionId = $Process.Id
            Modules = @($Process.Modules | Select-Object -Property FileName,ModuleName)
            Path = $Process.Path
            Product = $Process.Product
            ProductVersion = $Process.ProductVersion
            FileVersion = $Process.FileVersion
            Description = $Process.Description
            Company = $Process.Company
            InstallDate = $Process.InstallDate
            Environment = @([ProcessUtilities]::GetEnvironement($ProcessId))
        }

        $ProcessWmi = Get-WmiObject Win32_Process -Filter ("ProcessId = " + $ProcessId)
        $ProcessResult += @{
            ParentProcessId = $ProcessWmi.ParentProcessId
            CommandLine = $ProcessWmi.CommandLine
        }

        $ProcessHandlePerm = @()
        foreach ($h in $HandlePerm) {
            if ($h.ProcessId -eq $ProcessId) {
                $perm = Convert-ObjectToArray $h
                $perm = @{
                    CreatorBackTraceIndex = $h.CreatorBackTraceIndex
                    ObjectTypeIndex = $h.ObjectTypeIndex
                    HandleAttributes = $h.HandleAttributes
                    HandleValue = $h.HandleValue
                    Object = $h.Object
                    GrantedAccess = $h.GrantedAccess
                }
                $ProcessHandlePerm += New-Object PSObject -Property $perm
            }
        }

        $process_handle = $null
        if ($handle_path -ne $null) {
            $process_handle = Get-ProcessHandles $ProcessId $handle_path
        }

        $ProcessResult += @{
            Handles = $process_handle
            HandlesPerm = @($ProcessHandlePerm)
            CurrentDirectory = [ProcessUtilities]::GetCurrentDirectory($ProcessId)
        }

	    # Get handle to the process
	    $ProcHandle = [Kernel32]::OpenProcess(0x0410, $false, $ProcessId)
	    if ($ProcHandle -eq 0) {
            $CallResult =  [kernel32]::CloseHandle($ProcHandle)
	    } Else {

	        # Get handle to the process token
	        $hToken = 0
	        $CallResult = [Advapi32]::OpenProcessToken($ProcHandle, 0x00000008, [ref]$hToken)
	        if ($CallResult -eq 0) {
                $CallResult = [kernel32]::CloseHandle($hToken)
	        } Else {

                $Sid = Get-ProcessSid $hToken
                $SidAccountName = Get-ProcessSid -ResolveAccountName $true $hToken
                $LuidPrivilegeArray = @(Get-ProcessPrivilege $hToken)
                $AppContainerSid = Get-ProcessAppContainerSid $hToken
                $GroupsSid = @(Get-ProcessGroupsSid $hToken)

                $CallResult = [kernel32]::CloseHandle($hToken)
                $CallResult =  [kernel32]::CloseHandle($ProcHandle)

                $ProcessResult += @{
                    LUID = $LuidPrivilegeArray
                    SID = $Sid
                    AccountName = $SidAccountName
                    AppContainerSid = $AppContainerSid
                    GroupsSid = $GroupsSid
                }
            }
        }

        New-Object PSObject -Property $ProcessResult
    }
}

function Convert-ObjectToArray {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)]
		$Obj
	)

    $ret = @{}
    foreach ($property in $Obj.psobject.properties) {
        $propertyName = $property.Name
        $ret[$propertyName] = $Obj.$propertyName
    }
    return $ret
}

function Get-ScheduledTask-WithUserSID {
    $TasksReturn = @()
    $Tasks = @(Get-ScheduledTask)

    foreach ($Task in $Tasks) {
        $TaskReturn = Convert-ObjectToArray $Task
        if ($TaskReturn.State -ne $null) {
            $TaskReturn.State = $TaskReturn.State.ToString()
        }
        if ($Task.Principal.UserId -ne $null) {
            $TaskReturn += @{
                SID = Get-AccountSid $Task.Principal.UserId
            }
        }
        $TasksReturn += New-Object PSObject -Property $TaskReturn
    }
    $TasksReturn
}

function Get-Service-WithUserSID {
    Get-WmiObject Win32_Service | %{
        $Service = $_
        #$ServiceReturn = Convert-ObjectToArray $Service
        if ($Service.StartName -ne $null) {
            $ServiceReturn = @{
                StartName = $Service.StartName
                Started = $Service.Started
                StartMode = $Service.StartMode
                PathName = $Service.PathName
                Name = $Service.Name
                Description = $Service.Description
                SID = Get-AccountSid $Service.StartName
            }
        }
        New-Object PSObject -Property $ServiceReturn
    }
}

#We don not want to run with process in wow
if ([ProcessUtilities]::Is64BitOperatingSystem() -eq $true) {
    if ([ProcessUtilities]::is64bitProcess() -eq $false) {
        Write-LogLine "[!] Process is not run with sysnative powershell`n"
    }
}


# Main
$outpath = "synacktiv-$env:computerName-out-" + (Get-Date -f dd-MM-yyyy-hh-mm-ss)
$_ = New-Item ($outpath) -type directory -force
$outpath = (Resolve-Path $outpath).Path
$outpath_tag = $outpath + '\tag'
$_ = New-Item ($outpath_tag) -type directory -force
$_ = New-Item ($outpath + "\stdout") -type directory -force


try {
    # Retrieve registry hives
    Write-LogLine "[+] Storing register hive"
    reg save HKLM\SOFTWARE "$outpath_tag\registry__software.hiv"

    Invoke-ExecLog "tasks_old" {schtasks.exe /query /xml} $outpath
    Invoke-ExecLog "network" {Get-ProcessNetwork} $outpath
    Invoke-ExecLog "services" {Get-Service-WithUserSID} $outpath "Name"

    # Export all administrator member
    # SID of 'Administrators' group
    $adminCaption = Get-LocalAdministrorsCaption 'S-1-5-32-544'
    Invoke-ExecLog "admins" {Get-LocalGroupMember $adminCaption} $outpath "SID"

    # Gather Many informations through WMI
    Read-FromComputer $tables_list $outpath_tag
    # Gather Many informations through WMI
#    Read-FromComputer $advence_tables_list $outpath_tag

    Invoke-ExecLog "process" {Get-Process | Get-ProcessInfo} $outpath "ProcessName"

    # Gather informations through command execution
    Invoke-ExecLog "smbconfiguration" {Invoke-WmiMethod -Namespace "root\Microsoft\Windows\SMB" -Class "MSFT_SmbServerConfiguration" "GetConfiguration"| ForEach-Object {$_.output}} $outpath
    Invoke-ExecLog "missing_updates" {(new-object -com Microsoft.Update.Session).CreateUpdateSearcher().Search("IsInstalled=0")} $outpath

    # Retrieve registry reg
    Write-LogLine "[+] Storing register hklm"
    reg export HKLM "$outpath_tag\registry__hklm.reg"
    Write-LogLine "[+] Storing register hku"
    reg export HKU "$outpath_tag\registry__hku.reg"
    Write-LogLine "[+] Storing register hkcc"
    reg export HKCC "$outpath_tag\registry__hkcc.reg"

    # Get information on drive
    $drive = Get-WmiObject Win32_LogicalDisk
    Invoke-ExecLog "drives" {$drive} $outpath

    # Get acl on local file
    # With Get-ScheduledTask, we can leaks some task file
    # type 4 is for network drive
    $drive | Where-Object {$_.DriveType -ne 4} | %{
        Write-LogLine ("[+] Storing acl of " + $_.DeviceId + " to " + $outpath + "\stdout\acl.txt")
        $ret = [FileSystem]::GetFileAndPerm($_.DeviceId, $outpath + "\stdout\acl.txt")
    }
    $ret = [FileSystem]::GetFileAndPerm('\\.\pipe', $outpath + "\stdout\acl.txt")

    if (Get-Command 'Get-ScheduledTask' -ErrorAction SilentlyContinue) {
        Invoke-ExecLog "tasks" {Get-ScheduledTask-WithUserSID} $outpath
    }

    if ($extractADUser -and (Get-Command 'Get-ADObject' -ErrorAction SilentlyContinue)) {
        Invoke-ExecLog "ADUser" {Get-ADUser -LDAPFilter '(&(objectClass=user))' -Properties * |
            Select-Object -Property @{Name='SID'; Expression={$_.SID.ToString()}},@{Name='AdminCount'; Expression={$_.AdminCount}},@{Name='sAMAccountName'; Expression={$_.sAMAccountName}},'Deleted','Enabled','PasswordNotRequired','PasswordNeverExpires','CanonicalName','PasswordLastSet','LastLogonDate','AllowReversiblePasswordEncryption','whenCreated'} $outpath "SID"
        Write-Progress -Completed "Getting AD user"
        Invoke-ExecLog "ADGPO" {Get-ADObject -LDAPFilter '(&(objectClass=groupPolicyContainer))' -Properties nTSecurityDescriptor,DisplayName,ObjectGUID} $outpath
    }

    # Retrieve tasks
    # C:\Windows\Tasks (task manager v1, avec des fichiers .job)
    Write-LogLine "[+] get system32 tasks"
    cp -Recurse C:\Windows\system32\Tasks "$outpath\tasks\system32"
    Write-LogLine "[+] get wow64 tasks"
    cp -Recurse C:\Windows\SysWOW64\Tasks "$outpath\tasks\syswow64"

    Write-LogLine "[+] get local account"
    Get-WmiObject "Win32_UserAccount" -Namespace "Root/cimv2" -Filter "localaccount='True'" | Export-Clixml ($outpath_tag + "\wmi__cimv2__Win32_UserAccount__local.xml")

    Write-LogLine "[+] End of extraction, finishing"
}
finally {
    Write-LogLine "Storing debug.log"
    Move-Item "debug.log" "$outpath\debug.log"

    # Write-Host "[+] Creating zip output"
    # $_ = New-Item ($outpath + ".zip") -type file
    # $zipout = (Get-Item ($outpath + ".zip")).fullname
}
