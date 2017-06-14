function Set-WindowStyle {
param(
    [Parameter()]
    [ValidateSet('FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE', 
                 'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED', 
                 'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL')]
    $Style = 'SHOW',
    [Parameter()]
    $MainWindowHandle = (Get-Process -Id $pid).MainWindowHandle
)
    $WindowStates = @{
        FORCEMINIMIZE   = 11; HIDE            = 0
        MAXIMIZE        = 3;  MINIMIZE        = 6
        RESTORE         = 9;  SHOW            = 5
        SHOWDEFAULT     = 10; SHOWMAXIMIZED   = 3
        SHOWMINIMIZED   = 2;  SHOWMINNOACTIVE = 7
        SHOWNA          = 8;  SHOWNOACTIVATE  = 4
        SHOWNORMAL      = 1
    }
    Write-Verbose ("Set Window Style {1} on handle {0}" -f $MainWindowHandle, $($WindowStates[$style]))

    $Win32ShowWindowAsync = Add-Type -memberDefinition @" 
    [DllImport("user32.dll")] 
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
"@ -name "Win32ShowWindowAsync" -namespace Win32Functions -passThru

    $Win32ShowWindowAsync::ShowWindowAsync($MainWindowHandle, $WindowStates[$Style]) | Out-Null
}

# Define your variables
# Interval: seconds
$my_interval = 3

# Application: process name
$my_app1 = "notepad"
$my_app2 = "EXCEL"
$my_app3 = "BCompare"


# MAXIMIZE window size one by one
# One loop takes 1 minute (60 seconds), 1440 = 24 hours * 60 minutes
for($i = 0; $i -lt 1440; $i++){
    (Get-Process -Name $my_app1).MainWindowHandle | foreach { Set-WindowStyle SHOWMAXIMIZED $_ }
    (Get-Process -Name $my_app2).MainWindowHandle | foreach { Set-WindowStyle MINIMIZE $_ }
    (Get-Process -Name $my_app3).MainWindowHandle | foreach { Set-WindowStyle MINIMIZE $_ }

    sleep($my_interval)

    (Get-Process -Name $my_app1).MainWindowHandle | foreach { Set-WindowStyle MINIMIZE $_ }
    (Get-Process -Name $my_app2).MainWindowHandle | foreach { Set-WindowStyle SHOWMAXIMIZED $_ }
    (Get-Process -Name $my_app3).MainWindowHandle | foreach { Set-WindowStyle MINIMIZE $_ }

    sleep($my_interval)

    (Get-Process -Name $my_app1).MainWindowHandle | foreach { Set-WindowStyle MINIMIZE $_ }
    (Get-Process -Name $my_app2).MainWindowHandle | foreach { Set-WindowStyle MINIMIZE $_ }
    (Get-Process -Name $my_app3).MainWindowHandle | foreach { Set-WindowStyle SHOWMAXIMIZED $_ }

    sleep($my_interval)
}
