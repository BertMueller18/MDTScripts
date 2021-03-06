#Change Path to correct UNC
    $Font_Folder  = "\\burbot\datafolders\Data Folders\Echo Fonts\win7 fonts for all\*"
###########################

#####################################################################################################
    $Local_Folder = New-Item -Path "C:\Windows\ECHO\Font" -type Directory -ErrorAction Silentlycontinue
    $Font_Copy    = Copy-Item -Path $Font_Folder -Destination "C:\Windows\ECHO\Font\" -recurse
######################################################################################################
    
    $Font_Folder = Get-ChildItem -Path "C:\Windows\ECHO\Font\" -recurse |  Select FullName
 
 
$Font_Object  = New-Object -ComObject Shell.Application
$Font_Install = $Font_Object.Namespace(0x14)


FOREACH ($Font in $Font_Folder) { 
    $Font_Install.CopyHere($Font)
}


#Clean Up
Remove-Item "C:\Windows\ECHO\Font" -Recurse -Force
