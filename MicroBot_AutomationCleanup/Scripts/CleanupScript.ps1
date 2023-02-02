### ************  RELEASE NOTES BEGINS *******

# ** This script is executed at the begining and the end of automation process to cleanup leftovers fromprevios or at the end of automation **

## @Version: V1 | @author: Amith Gowda | @Date:09/16/2021
## @Features: 
##  1.Kill Chrome for current user, 
##  2.Delete Chrome Browser user data and downloaded files   
##  3.Restore Default Chrome Profile
##  4.Minimize the windows (if any) left open

## @Version: V1.1 | @author: Amith | @Date: 12/06/2021
## @Features:
##  5.Clear Win-Start menu if its open
   
## @Version: V1.2 | @author: Amith | @Date: 12/09/2021
## @Features:
## 6.Removed the feature to Restore Default Chrome Profile - as this will be done outside of the script

## @Version: V1.3 | @author: Amith | @Date: 12/14/2021
## @Features:
## 7.Try catch error handling- Refine Log messages

### ************  RELEASE NOTES ENDS  *******
try {
    Write-Host "Running cleanup script"

    Write-Host "Clear START Menu If its open- by sendign ESC"
   # Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.SendKeys]::SendWait("{ESC}")

    Write-Host "Minimize any open windows."
    $shell = New-Object -ComObject "Shell.Application"
    $shell.MinimizeAll()

    Write-Host "Kill Chrome process for current user: $env:USERNAME"
    TASKKILL /FI "USERNAME eq $($env:USERNAME)" /F /IM chrome.exe

    Start-Sleep -Seconds 1.5

    $Folders = (

        "$env:LOCALAPPDATA\Google\Chrome\User Data\*",
        "$env:USERPROFILE\Downloads\*"
    )

    $Folders.ForEach({ 
            Write-Host "Removing folder: $_"
            Remove-Item -Recurse -Force -Path $_
            "Items count after deleting $_ folder is: " + (Get-ChildItem  -Path $_ | Measure-Object).Count
        })
        
    Write-Host "Completed Running Cleanup script!"
}
catch {
    "Some error in executing CleaupScript: $_"
    Write-Warning "Some error in executing CleaupScript: $_"
}
