# This script is intended to help organize files within a folder
# Initial functionality will include moving files to a folder matching the file extension.

# Initial Template was taken from https://usefulscripting.network/powershell/powershell-sorting-files/

function Sort_Files {
    param (
        [Parameter(Mandatory=$false)]
        [string]$cwd = (Get-Location).path
    )

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

    if($extensions.Count -gt 0){
        # Start moving files around
        foreach($file in $files){
            try {
                # Status Message to user
                Write-Host "Moving $($file) to folder: $cwd\\$($file.Extension)"

                # If a file already exists in the target location or is in use, Stop so that
                # we can catch the error.
                Move-Item $file.FullName -Destination "$cwd\\$($file.Extension)" -Force -ErrorAction Stop
            }
            catch {
                Write-Warning "Failed to move '$file' to folder '$($file.Extension)'. File already exists or in-use."

            }
        }
        # Summary
        Write-Host " Summary of file sorting operation:"
        $extensions | Group-Object -NoElement | Sort-Object Count -Descending
    }else {
        Write-Host "No files to sort here: $cwd"
    }
}