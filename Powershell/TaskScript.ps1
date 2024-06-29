
################################################################################################################
# Description
# This script is used to perform file operations like Move, Copy, and Delete in PowerShell.


# Version History
# 1.0 - 2024-06-25 - Initial script - Aditya Pal
# 1.1 - 2024-06-26 - Added comments and updated the script - Aditya Pal



################################################################################################################

# Defining the parameters for the script
# Setting non-mandatory fields to false in case of delete action
param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("Move", "Copy", "Delete")]
    [string]$Action,

    [Parameter(Mandatory=$true)]
    [string]$Source,

    [Parameter(Mandatory=$false)]
    [string]$Destination,

    [Parameter(Mandatory=$true)]
    [string[]]$Files
)

# Defining the functions for the script

# Function to move files from source to destination
function Move-Files {
    param (
        [string]$Source,
        [string]$Destination,
        [string[]]$Files
    )

    foreach ($file in $Files) {
        $sourcePath = Join-Path -Path $Source -ChildPath $file
        $destPath = Join-Path -Path $Destination -ChildPath $file
        if (Test-Path $sourcePath) {
            Move-Item -Path $sourcePath -Destination $destPath -Force
            Write-Output "Moved: $sourcePath to $destPath"
        } else {
            Write-Output "Source file not found: $sourcePath"
        }
    }
}

# Function to copy files from source to destination
function Copy-Files {
    param (
        [string]$Source,
        [string]$Destination,
        [string[]]$Files
    )

    foreach ($file in $Files) {
        $sourcePath = Join-Path -Path $Source -ChildPath $file
        $destPath = Join-Path -Path $Destination -ChildPath $file
        if (Test-Path $sourcePath) {
            Copy-Item -Path $sourcePath -Destination $destPath -Force
            Write-Output "Copied: $sourcePath to $destPath"
        } else {
            Write-Output "Source file not found: $sourcePath"
        }
    }
}

# Function to delete files from source
# we may need to modify the logic if the script is supposed to be triggered in some IDE
# No issues if we are running the script in as a command/powershell script

function Delete-Files {
    param (
        [string]$Source,
        [string[]]$Files
    )

    foreach ($file in $Files) {
        $sourcePath = Join-Path -Path $Source -ChildPath $file
        if (Test-Path $sourcePath) {
            Remove-Item -Path $sourcePath -Force
            Write-Output "Deleted: $sourcePath"
        } else {
            Write-Output "Source file not found: $sourcePath"
        }
    }
}

# Main script logic
#Switch case to perform the action based on the input   
# If User is storing modules in a different location, we need to save above modules in that location and import the modules here
# Example:
#   Import-Module MyModule
#   Import-Module -Name MyModule
#   Import-Module -Path C:\Path\To\MyModule.psm1

switch ($Action) {
    "Move" {
        if (-not $Destination) {
            Write-Output "Destination is required for Move action."
            exit
        }
        Move-Files -Source $Source -Destination $Destination -Files $Files
    }
    "Copy" {
        if (-not $Destination) {
            Write-Output "Destination is required for Copy action."
            exit
        }
        Copy-Files -Source $Source -Destination $Destination -Files $Files
    }
    "Delete" {
        Delete-Files -Source $Source -Files $Files
    }
    default {
        Write-Output "Invalid action specified."
    }
}
