$FileZilla_Install = "FileZilla_3.6.0.2_win32-setup"

IF ((Test-Path -Path "C:\Program Files (x86)\FileZilla FTP Client\") -eq $True) {
    $Current_Install     = (Get-Item "C:\Program Files (x86)\FileZilla FTP Client\filezilla.exe").VersionInfo.FileVersion
    $Current_Install     = $Current_Install.Split(",") -replace "\s"
}
$New_Install     = (Get-Item "\\sturgeon\NETLOGON\network_deploy_software\fileZilla\$FileZilla_Install.exe").BaseName -replace "FileZilla_" -replace "_win32-setup"
$New_Install     = $New_Install.Split(".")
$New_Array_Count = $New_Install.Count

Function Update-FileZilla { 
    Param (
        [String]
        $Name
    )
        $Uninstall_Arguments = (
            "/S" #Silent
        )
        &"C:\Program Files (x86)\FileZilla FTP Client\uninstall.exe" $Uninstall_Arguments
        Start-Sleep -Seconds 10
        $Install_Arguments = (
            "/S" #Silent
        )
        &"\\sturgeon\NETLOGON\network_deploy_software\fileZilla\$Name" $Install_Arguments
}
#Is it even installed?
IF ((Test-Path -Path "C:\Program Files (x86)\FileZilla FTP Client") -eq $False) {
        $Install_Arguments = (
            "/S" #Silent
        )
        &"\\sturgeon\NETLOGON\network_deploy_software\fileZilla\$FileZilla_Install.exe" $Install_Arguments
}
ELSE {
    # lt = Less Than
    # le = Less Than / Equal To                    

    IF     ([int]$Current_Install[0] -lt [int]$New_Install[0]) 
             {
               Update-FileZilla -Name $FileZilla_Install
             }
    ELSEIF (
            ([int]$Current_Install[0] -le [int]$New_Install[0]) -and 
            ([int]$Current_Install[1] -lt [int]$New_Install[1])
           ) {
               #Commands Here 
               Update-FileZilla -Name $FileZilla_Install
             }
    ELSEIF (
            ([int]$Current_Install[0] -le [int]$New_Install[0]) -and 
            ([int]$Current_Install[1] -le [int]$New_Install[1]) -and 
            ([int]$Current_Install[2] -lt [int]$New_Install[2])
           ) {
                #Commands Here
    	        Update-FileZilla -Name $FileZilla_Install
             }
    ELSEIF (
            ([int]$Current_Install[0] -le [int]$New_Install[0]) -and 
            ([int]$Current_Install[1] -le [int]$New_Install[1]) -and 
            ([int]$Current_Install[2] -le [int]$New_Install[2]) -and
            ([int]$Current_Install[3] -lt [int]$New_Install[3])
           ) {
                #Commands Here 
                Update-FileZilla -Name $FileZilla_Install
             }
    ELSEIF (
            ([int]$Current_Install[0] -le [int]$New_Install[0]) -and 
            ([int]$Current_Install[1] -le [int]$New_Install[1]) -and 
            ([int]$Current_Install[2] -le [int]$New_Install[2]) -and
            ([int]$Current_Install[3] -le [int]$New_Install[3]) -and
            ([int]$Current_Install[4] -lt [int]$New_Install[4])
           ) {
                #Commands Here 
                Update-FileZilla -Name $FileZilla_Install
             }
    Else     {Exit}
}