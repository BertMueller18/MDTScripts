#Shared Folder
$Itunes_Share    = "\\Sturgeon\Itunes"
$QuickTime_Share = "\\Sturgeon\QuickTime"
#MSI Paths
$Itunes_Install_MSIs = "AppleApplicationSupport.msi",
					   "AppleMobileDeviceSupport64.msi",
					   "AppleSoftwareUpdate.msi",
                       "BonJour64.msi",
					   "iTunes64.msi",
					   "QuickTime.msi"
                      
Function Update-Itunes {
    Param(
    [Object]
    $Name
    )
    Get-WmiObject Win32_Product | Where {$_.InstallSource -eq "\\Sturgeon\Itunes\" -or $_.InstallSource -eq "\\Sturgeon\QuickTime\"} | ForEach-Object {
    $String = $_.IdentifyingNumber
    $Uninstall = [Diagnostics.Process]::Start("msiexec.exe", "/X$String /qn")
    $Uninstall.WaitForExit() 
    }
    Foreach ($MSI in $Itunes_Install_MSIs) {
        $Path = IF ($MSI -eq $Itunes_Install_MSIs[5]) {"$QuickTime_Share\$MSI"} ELSE {"$Itunes_Share\$MSI"}
        $Install = [Diagnostics.Process]::Start($Path, "/qn")
        $Install.WaitForExit() 
    }

}
Function Get-MsiDatabaseVersion {
    param (
        [IO.FileInfo] $FilePath
    )
    try {
        $windowsInstaller = New-Object -com WindowsInstaller.Installer

        $database = $windowsInstaller.GetType().InvokeMember(
                "OpenDatabase", "InvokeMethod", $Null, 
                $windowsInstaller, @($FilePath.FullName, 0)
            )

        $q = "SELECT Value FROM Property WHERE Property = 'ProductVersion'"
        $View = $database.GetType().InvokeMember(
                "OpenView", "InvokeMethod", $Null, $database, ($q)
            )

        $View.GetType().InvokeMember("Execute", "InvokeMethod", $Null, $View, $Null)

        $record = $View.GetType().InvokeMember(
                "Fetch", "InvokeMethod", $Null, $View, $Null
            )

        $productVersion = $record.GetType().InvokeMember(
                "StringData", "GetProperty", $Null, $record, 1
            )

        return $productVersion

    } catch {
        throw "Failed to get MSI file version the error was: {0}." -f $_
    }
}
                    
#Current Install/Version
IF ((Test-Path -Path "C:\Program Files (x86)\iTunes\iTunes.exe") -eq $True) { 
    $Current_Install = (Get-Item "C:\Program Files (x86)\iTunes\iTunes.exe").VersionInfo.FileVersion
    $Current_Install = $Current_Install.Split(".") -replace "\s"
}                      
#Check New Install
    $New_Install = Get-MsiDatabaseVersion "\\Sturgeon\Itunes\itunes64.msi" | out-string
    $New_Install = $New_Install.Split(".")

                    
IF ((Test-Path -Path "C:\Program Files (x86)\iTunes\iTunes.exe") -eq $False) {                           
		Foreach ($MSI in $Itunes_Install_MSIs) {
        $Path = IF ($MSI -eq $Itunes_Install_MSIs[5]) {"$QuickTime_Share\$MSI"} ELSE {"$Itunes_Share\$MSI"}
        $Install = [Diagnostics.Process]::Start($Path, "/qn")
        $Install.WaitForExit() 
    }
    #Turn off Automatic Updates thingy
    New-ItemProperty -Path "HKLM:\SOFTWARE\Apple Computer, Inc.\iTunes\Parental Controls\Default" -Name "AdminFlags" -Value "00000101" -PropertyType "DWord" -erroraction silentlycontinue
}
ELSE {
    # lt = Less Than
    # le = Less Than / Equal To                    

    IF     ([int]$Current_Install[0] -lt [int]$New_Install[0]) 
             {
              #Commands Here 
              Update-Itunes -Name $Itunes_Install_MSIs
             }
    ELSEIF (
            ([int]$Current_Install[0] -le [int]$New_Install[0]) -and 
            ([int]$Current_Install[1] -lt [int]$New_Install[1])
           ) {
               #Commands Here 
               Update-Itunes -Name $Itunes_Install_MSIs
             }
    ELSEIF (
            ([int]$Current_Install[0] -le [int]$New_Install[0]) -and 
            ([int]$Current_Install[1] -le [int]$New_Install[1]) -and 
            ([int]$Current_Install[2] -lt [int]$New_Install[2])
           ) {
                #Commands Here
    	        Update-Itunes -Name $Itunes_Install_MSIs
             }
    ELSEIF (
            ([int]$Current_Install[0] -le [int]$New_Install[0]) -and 
            ([int]$Current_Install[1] -le [int]$New_Install[1]) -and 
            ([int]$Current_Install[2] -le [int]$New_Install[2]) -and
            ([int]$Current_Install[3] -lt [int]$New_Install[3])
           ) {
                #Commands Here 
                Update-Itunes -Name $Itunes_Install_MSIs
             }
    ELSEIF (
            ([int]$Current_Install[0] -le [int]$New_Install[0]) -and 
            ([int]$Current_Install[1] -le [int]$New_Install[1]) -and 
            ([int]$Current_Install[2] -le [int]$New_Install[2]) -and
            ([int]$Current_Install[3] -le [int]$New_Install[3]) -and
            ([int]$Current_Install[4] -lt [int]$New_Install[4])
           ) {
                #Commands Here 
                Update-Itunes -Name $Itunes_Install_MSIs
             }
    ELSEIF (
            ([int]$Current_Install[0] -le [int]$New_Install[0]) -and 
            ([int]$Current_Install[1] -le [int]$New_Install[1]) -and 
            ([int]$Current_Install[2] -le [int]$New_Install[2]) -and
            ([int]$Current_Install[3] -le [int]$New_Install[3]) -and
            ([int]$Current_Install[4] -le [int]$New_Install[4]) -and
            ([int]$Current_Install[5] -lt [int]$New_Install[5])
           ) {
                #Commands Here 
                Update-Itunes -Name $Itunes_Install_MSIs             
             }
    Else     {Exit}
}