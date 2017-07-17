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

### Base64 - bin file / png
# encode
$InBin = "C:\wk_tmp\abc.exe"
$base64string = [System.Convert]::ToBase64String([IO.File]::ReadAllBytes($InBin))
$base64string.Length
$b64file = $InBin + ".b64forbin"
$base64string | set-content $b64file

#decode
$BinFromB64 = $InBin + ".fromb64"
[IO.File]::WriteAllBytes($BinFromB64 + "", [System.Convert]::FromBase64String($base64string))
