function renameFile() {
    $baseFolder = "D:\musb"
    $md5_filename = "$baseFolder\name2name.txt"
    $targetFolder = "$baseFolder\target"
    $backupFolder = "$baseFolder\backup"
    $chksum = "$baseFolder\utils\md5sum.exe"
    
    $dt = Get-Date -Format 'yyyyMMdd_hhmmss'
    $newFN = "name2name_" + $dt + ".txt"
    Rename-Item -Path $md5_filename -NewName $newFN
    Move-Item "$baseFolder\$newFN" $backupFolder
    
    # copy target to backup
    Get-ChildItem $targetFolder | Foreach-Object {
        $arg = $_.FullName
        Copy-Item $arg $backupFolder
    }
    
    # run md5sum.exe to get mapping file of filename and its md5
    # https://social.technet.microsoft.com/wiki/contents/articles/7703.powershell-running-executables.aspx
    # http://stackoverflow.com/questions/24222088/powershell-capture-program-stdout-and-stderr-to-separate-variables
    Get-ChildItem $targetFolder | Foreach-Object {
        $arg = $_.FullName
        & $chksum $arg 1>> $md5_filename
    }

    # Get key-value pairs from name2name file.
    $sContent = [String](Get-Content $md5_filename -Raw)
    Write-Host "Read file in first time: [$sContent]"
    
    # Get first 6 digits of md5 as the new filename
    # http://stackoverflow.com/questions/4192072/how-to-process-a-file-in-powershell-line-by-line-as-a-stream
    # https://technet.microsoft.com/en-us/library/ee692804.aspx
    # http://ss64.com/ps/split.html
    # https://blogs.technet.microsoft.com/heyscriptingguy/2014/07/17/using-the-split-method-in-powershell/
    $reader = [System.IO.File]::OpenText($md5_filename)
    while($null -ne ($line = $reader.ReadLine())) {
        $md5value = $line.Split()[0]
        $fname = $line.Split()[2]
        $md5_6 = $md5value.Substring(0,6)
        $fn = Split-Path $fname -Leaf
        $md5value
        $md5_6
        $fn
        Rename-Item -Path $fname -NewName $md5_6
        write-host "====="
    }
}

function split2Volumn() {
    $baseFolder = "D:\musb"
    $targetFolder = "$baseFolder\target"
    $queueFolder = "$baseFolder\queue"
    
    $cmd = "C:\Program Files\7-Zip\7z.exe"
    $arg1 = "a"
    $arg2 = "-t7z"
    $arg3 = "-mx=0"
    $arg4 = "-v19m"
    
    Get-ChildItem $targetFolder | Foreach-Object {
        $fn = $_.Name
        $volName = "$fn.7z"
        & $cmd $arg1 $arg2 $arg3 $arg4 $queueFolder\$volName $targetFolder\$fn
    }
}

function encVol001() {
    $baseFolder = "D:\musb"
    $queueFolder = "$baseFolder\queue"
    $backupFolder = "$baseFolder\backup"
    
    $cmd = "C:\Program Files (x86)\GNU\GnuPG\pub\gpg.exe"
    $arg_r = "-r"
    $arg_rval = "your_public_key_id"
    $arg_o = "-o"
    $arg_e = "-e"
    
    # http://www.computerperformance.co.uk/powershell/powershell_file_gci_filter.htm
    Get-ChildItem $queueFolder -Filter "*.001" | Foreach-Object {
        $fn = $_.Name
        $encName = "$fn.bin"
        & $cmd $arg_r $arg_rval $arg_o $queueFolder\$encName $arg_e $queueFolder\$fn
        Move-Item $queueFolder\$fn $backupFolder\$fn
    }
}

function sendAttachment() {
    $baseFolder = "D:\musb"
    $queueFolder = "$baseFolder\queue"
    
    Add-Type -assembly "Microsoft.Office.Interop.Outlook"
    $outlook = New-Object -ComObject Outlook.Application
    
    Get-ChildItem $queueFolder | Foreach-Object {
        $message = $outlook.CreateItem(0)
        $message.Recipients.Add("your_mailbox_address")
        $message.Body = ""
        $message.Subject = $_.PSChildName
        $message.Attachments.Add($_.FullName)
        $message.send()
    }
}

function getFilename() {
    $baseFolder = "D:\musb"
    $md5_filename = "$baseFolder\nmid.txt"
    $reader = [System.IO.File]::OpenText($md5_filename)
    while($null -ne ($line = $reader.ReadLine())) {
        $md5_6 = $line.Split()[0].Substring(0,6)
        $fname = $line.Split()[2]
        # $fn = Split-Path $fname -Leaf
        $fn = $fname.Split("/")[-1]
        $md5_6 = "DriveName:\FolderFullPath\" + $md5_6
        $md5_6
        $fn
        #$fn.GetType()
        Rename-Item -Path $md5_6 -NewName $fn
        write-host "====="
    }
}

function main_proc() {
    renameFile
    split2Volumn
    encVol001
    sendAttachment
}

main_proc
