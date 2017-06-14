$services = @{
                "Browser"   = "Computer Browser";
                "msiserver" = "Windows Installer";
                "CcmExec"   = "SMS Agent Host";
                "BITS"      = "Background intelligence Transfer service";
                "Winmgmt"   = "Windows Management Instrumentation"
             }

$result = New-Object -TypeName PSObject
Add-Member -InputObject $result -MemberType NoteProperty -Name Name -Value ""
Add-Member -InputObject $result -MemberType NoteProperty -Name Status -Value ""
Add-Member -InputObject $result -MemberType NoteProperty -Name State -Value ""
Add-Member -InputObject $result -MemberType NoteProperty -Name StartMode -Value ""
Add-Member -InputObject $result -MemberType NoteProperty -Name DisplayName -Value ""

$output_format = @{Expression = {$_.Name};        Label = "Service Name";         width = 10}, `
                 @{Expression = {$_.Status};      Label = "Service Status";       width = 10}, `
                 @{Expression = {$_.State};       Label = "Service State";        width = 10}, `
                 @{Expression = {$_.StartMode};   Label = "Service Start Mode";   width = 10}, `
                 @{Expression = {$_.DisplayName}; Label = "Service Display Name"; width = 45}

foreach($service in $services.Keys){
    $service_status = Get-WmiObject -Class Win32_Service -Filter "Name='$service'"

    $result.Name        = $service_status.Name
    $result.Status      = $service_status.Status
    $result.State       = $service_status.State
    $result.StartMode   = $service_status.StartMode
    $result.DisplayName = $services[$service]

    $result | Format-Table $output_format
}
