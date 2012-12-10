Import-Module MDTDB




$Database = @{
    Instance  = "SQLExpress"
    SQLServer = "RedHorse"
    Database  = "MDT"
}
    Connect-MDTDatabase @Database 

Import-Csv -Path $Path | ForEach-Object {
    $Computer = @{
        MACAddress   = "$_.MacAddress"
        SerialNumber = "$_.SerialName"
        Description  = "$_.ComputerName"
        Settings     = @{
                            OSInstall       = "YES"
                            OSDComputerName = "$_.ComputerName"
                        }
        }
            New-MDTComputer @Computer 

}