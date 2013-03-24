Import-Module "\\RedHorse\DeploymentShare$\Scripts\MDTDB.psm1"

$Database = @{
    Instance  = "SQLExpress"
    SQLServer = "RedHorse"
    Database  = "MDT"
}
    Connect-MDTDatabase @Database 
    $Test_Computer = Get-MDTComputer -serialNumber (Get-WMIObject Win32_BIOS).SerialNumber
    IF ($Test_Computer -eq $null) {
        #Gets the OU for the computer
        $Find_OU = [adsisearcher]"objectcategory=computer"
        $Find_OU.Filter="cn=$ENV:ComputerName"
        $Found_OU = $Find_OU.FindOne().Properties.distinguishedname -replace "CN=$ENV:ComputerName," | out-string

        $Computer = @{
            MACAddress   = (Get-WmiObject Win32_NetworkadapterConfiguration | where{$_.IpEnabled -match $True -and $_.DHCPEnabled -eq $True}).MacAddress
            SerialNumber = (Get-WMIObject Win32_BIOS).SerialNumber
            Description  = "$ENV:ComputerName"
            Settings     = @{
                                OSDComputerName = "$ENV:ComputerName"
                                MachineObjectOU = $Found_OU
                            }
        }
        New-MDTComputer @Computer
    }
    Elseif ($Test_Computer.OSDComputerName -ne $ENV:Computername) {
        Get-MDTComputer -serialNumber (Get-WMIObject Win32_BIOS).SerialNumber | Remove-MDTComputer 
        #Gets the OU for the computer
        $Find_OU = [adsisearcher]"objectcategory=computer"
        $Find_OU.Filter="cn=$ENV:ComputerName"
        $Found_OU = $Find_OU.FindOne().Properties.distinguishedname -replace "CN=$ENV:ComputerName," | out-string

        $Computer = @{
            MACAddress   = (Get-WmiObject Win32_NetworkadapterConfiguration | where{$_.IpEnabled -match $True -and $_.DHCPEnabled -eq $True}).MacAddress
            SerialNumber = (Get-WMIObject Win32_BIOS).SerialNumber
            Description  = "$ENV:ComputerName"
            Settings     = @{
                                OSDComputerName = "$ENV:ComputerName"
                                MachineObjectOU = $Found_OU
                            }
        }
        New-MDTComputer @Computer
        
    }
    Else {
        Exit
    }