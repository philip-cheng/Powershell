# Embedding External Files in PowerShell Scripts
# https://www.loginvsi.com/blog/565-embed-external-files-in-powershell-scripts

$Content = Get-Content -Path C:\AM\AM.dll -Encoding Byte
$Base64 = [System.Convert]::ToBase64String($Content)
$Base64 | Out-File c:\AM\encoded.txt

$Base64 = "TVqQAAMAAAAEAAAA//8AALgAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
..........+DDEAsAA+DDkAsAA+DEEAsAA+DEkAsAA+DFEAsABDDFkAsAA+DGEAsAA+DGkAsAA+DHEAsABIDIEAsABODIkAsAAOAJEA6gYSAJkAAAdTDAkA"
$Content = [System.Convert]::FromBase64String($Base64)
Set-Content -Path $env:temp\AM.dll -Value $Content -Encoding Byte
#Do your things
Remove-Item $env:temp\AM.dll
