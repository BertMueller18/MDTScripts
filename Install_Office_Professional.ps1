#Professional
$Office_Install = "\\sturgeon\office\Office 2010 Professional\setup.exe"
IF (
    ((Test-Path -Path "C:\Program Files\Microsoft Office\Office14") -eq $False) -or
    ((Test-Path -Path "C:\Program Files (x86)\Microsoft Office\Office14") -eq $False)
    ) {
        $Install = [Diagnostics.Process]::Start($Office_Install)
        $Install.WaitForExit()    
      }
