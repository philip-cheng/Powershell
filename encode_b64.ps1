### Base64 - string
# encode
$Text = "This is a secret and should be hidden"
$Bytes = [System.Text.Encoding]::Unicode.GetBytes($Text)
$EncodedText =[System.Convert]::ToBase64String($Bytes)
$EncodedText

# decode
# $EncodedText = "VABoAGkAcwAgAGkAcwAgAGEAIABzAGUAYwByAGUAdAAgAGEAbgBkACAAcwBoAG8AdQBsAGQAIABiAGUAIABoAGkAZABkAGUAbgA="
$DecodedText = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($EncodedText))
$DecodedText

### Base64 - text file (file content shouldn't be empty, otherwise NullPoint)
# encode
$fileName = "C:\wk_tmp\fortest.txt"
$fileContent = get-content $fileName
$fileContentBytes = [System.Text.Encoding]::UTF8.GetBytes($fileContent)
$fileContentEncoded = [System.Convert]::ToBase64String($fileContentBytes)
$fileContentEncoded | set-content ($fileName + ".b64fortxt")

# decode
####### TODO


### Base64 - bin file / png
# encode
$InBin = "C:\wk_tmp\abc.exe"
$base64string = [System.Convert]::ToBase64String([IO.File]::ReadAllBytes($InBin))
$base64string.Length
$b64file = $InBin + ".b64forbin"
$base64string | set-content $b64file

#decode
$BinFromB64 = $InBin + ".fromb64"
[IO.File]::WriteAllBytes($BinFromB64, [System.Convert]::FromBase64String($base64string))

### Validate if Base64 encoded
$re = "^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$"
# ^([A-Za-z0-9+/]{4})* means the string starts with 0 or more base64 groups.
# ([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$ means the string ends in one of three forms: [A-Za-z0-9+/]{4}, [A-Za-z0-9+/]{3}= or [A-Za-z0-9+/]{2}==.

$base64 -match $re

If ($base64 –notmatch $re) {
  Write-Error "Invalid input."
}

If ($base64 –match $re) {
  Write-Host "Good match."
}
