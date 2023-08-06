$Browsers = Get-ChildItem "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\History",
             "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\History",
             "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles*.default\places.sqlite"

ForEach ($Browser in $Browsers) {
    If (Test-Path $Browser) {
        $ConnectionString = "Data Source={0}" -f $Browser.FullName
        $Connection = New-Object -TypeName System.Data.SQLite.SQLiteConnection($ConnectionString)
        $Connection.Open()
        $Command = $Connection.CreateCommand()
        $Command.CommandText = "DELETE FROM urls"
        $Command.ExecuteNonQuery()
        $Connection.Close()
    }
}