try {
    $POSTMAN_CLI_PATH = "$Env:USERPROFILE\AppData\Local\Microsoft\WindowsApps"
    New-Item -type directory -path "$POSTMAN_CLI_PATH" -Force | Out-Null
    $client = New-Object System.Net.WebClient
    $client.DownloadFile("https://dl-cli.pstmn.io/download/latest/win64", "$POSTMAN_CLI_PATH\postman-cli.zip")
    Expand-Archive "$POSTMAN_CLI_PATH\postman-cli.zip" "$POSTMAN_CLI_PATH" -Force
    Remove-Item "$POSTMAN_CLI_PATH\postman-cli.zip"
    mv "$POSTMAN_CLI_PATH\postman-cli.exe" "$POSTMAN_CLI_PATH\postman.exe" -Force
    echo "The Postman CLI has been installed"
} catch {
    echo "An error occurred while installing the Postman CLI"
    echo $_.Exception.Message
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", "application/json")

    $body = @{
        level = 'error'
        transaction = 'postman-cli-install'
        tags = @{
            os = 'win64'
        }
        exception = @{
            values = @(
                @{
                    type = 'InstallationError'
                    value = $_.Exception.Message
                }
            )
        }
    } | ConvertTo-Json -Depth 3

    $response = Invoke-RestMethod 'https://o1224273.ingest.sentry.io/api/4504100877828096/store/?sentry_key=0b9fcaeae27d4918b933ed747b1a1047' -Method 'POST' -Headers $headers -Body $body
    exit 1
}
