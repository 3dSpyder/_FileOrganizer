# This script is intended to help organize files within a folder
# Initial functionality will include moving files to a folder matching the file extension.

# Initial Template was taken from https://usefulscripting.network/powershell/powershell-sorting-files/

function Sort_Files {
    param (
        [Parameter(Mandatory=$false)]
        [string]$cwd = (Get)
    )
}

# Collect the extensions of the files in the folder path
$ext_container = Get-ChildItem $cwd -File | Select-Object Extension

# Collect of the files in the folder path
$files = Get-ChildItem $cwd -File

# Inititialize a new list of file extensions
$extensions = New-Object Collections.Generic.List[String]

# Status Message for user
Write-Host "Getting files and creating subfolders..."

# Loop to create directory for each type of extension found in folder
foreach($folder in $ext_container){
    # Create directory if not already created
    [System.IO.Directory]::CreateDirectory("$cwd\\$($folder.Extension)") | Out-Null

    $extensions.Add($folder.Extension)
}