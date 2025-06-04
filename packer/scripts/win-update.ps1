$ProgressPreference = "SilentlyContinue"
$ErrorActionPreference = "Stop"

Write-Output "***** Starting Windows Update Process"

try {
    Set-Service WinRM -StartupType Automatic
    Start-Service WinRM
    Write-Output "***** WinRM service started"
} catch {
    Write-Output "***** Warning: Could not start WinRM service"
}

Write-Output "***** Installing PSWindowsUpdate module"
try {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope AllUsers
    Install-Module -Name PSWindowsUpdate -Force -Scope AllUsers -AllowClobber
    Import-Module PSWindowsUpdate -Force
    Write-Output "***** PSWindowsUpdate module installed successfully"
} catch {
    Write-Error "***** Failed to install PSWindowsUpdate: $($_.Exception.Message)"
    exit 1
}

Write-Output "***** Checking for available updates"
try {
    $Updates = Get-WUList -MicrosoftUpdate
    if ($Updates.Count -eq 0) {
        Write-Output "***** No updates available"
        exit 0
    }
    
    Write-Output "***** Found $($Updates.Count) updates to install"
    foreach ($Update in $Updates) {
        Write-Output "  - $($Update.Title)"
    }
} catch {
    Write-Output "***** Error checking for updates: $($_.Exception.Message)"
    exit 1
}

Write-Output "***** Installing updates (IgnoreReboot)"
try {
    $InstallResult = Get-WUInstall -MicrosoftUpdate -AcceptAll -Install -IgnoreReboot -Verbose
    
    if ($InstallResult) {
        Write-Output "***** Updates installed successfully"
        foreach ($Result in $InstallResult) {
            Write-Output "  - $($Result.Title): $($Result.Result)"
        }
    } else {
        Write-Output "***** No updates were installed"
    }
} catch {
    Write-Output "***** Error during update installation: $($_.Exception.Message)"
}

Write-Output "***** Checking if reboot is required"
try {
    $RebootRequired = Get-WURebootStatus -Silent
    if ($RebootRequired) {
        Write-Output "***** Reboot is required after updates"
    } else {
        Write-Output "***** No reboot required"
    }
} catch {
    Write-Output "***** Could not determine reboot status"
}

try {
    Set-Service WinRM -StartupType Automatic
    Write-Output "***** WinRM set to start automatically"
} catch {
    Write-Output "***** Warning: Could not set WinRM startup type"
}

Write-Output "***** Windows Update process completed"
