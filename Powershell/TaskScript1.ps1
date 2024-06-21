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

# Main logic
switch ($Action) {
    "Move" {
        if (-not $Destination) {
            Write-Output "Destination is required for Move action. Please provide a destination path."
            $Destination = Read-Host "Enter Destination Path"
            if (-not $Destination) {
                Write-Output "Destination path not provided. Exiting."
                exit
            }
        }
        Move-Files -Source $Source -Destination $Destination -Files $Files
    }
    "Copy" {
        if (-not $Destination) {
            Write-Output "Destination is required for Copy action. Please provide a destination path."
            $Destination = Read-Host "Enter Destination Path"
            if (-not $Destination) {
                Write-Output "Destination path not provided. Exiting."
                exit
            }
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
