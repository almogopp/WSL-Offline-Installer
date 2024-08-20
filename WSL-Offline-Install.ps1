# Prompt for the Linux distribution installation path from the user
$LinuxDistroPath = Read-Host "Please provide the path to the Linux distribution Appx file (e.g., Ubuntu.appx)"

# Identify the operating system
$osInfo = Get-WmiObject -Class Win32_OperatingSystem
$osCaption = $osInfo.Caption

if ($osCaption -match "Windows Server 2019") {
    Write-Host "Detected OS: Windows Server 2019"
    # Install WSL on Windows Server 2019
    Install-WindowsFeature -Name Microsoft-Windows-Subsystem-Linux
    Install-WindowsFeature -Name VirtualMachinePlatform -IncludeManagementTools
} elseif ($osCaption -match "Windows Server 2022") {
    Write-Host "Detected OS: Windows Server 2022"
    # Install WSL on Windows Server 2022
    Install-WindowsFeature -Name Microsoft-Windows-Subsystem-Linux
    Install-WindowsFeature -Name VirtualMachinePlatform -IncludeManagementTools
} elseif ($osCaption -match "Windows 10") {
    Write-Host "Detected OS: Windows 10"
    # Install WSL on Windows 10
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
} elseif ($osCaption -match "Windows 11") {
    Write-Host "Detected OS: Windows 11"
    # Install WSL on Windows 11
    wsl --install
} else {
    Write-Host "This script supports only Windows Server 2019, Windows Server 2022, Windows 10, or Windows 11."
    exit
}

# Save paths to a temporary file so the script can continue after a reboot
$TempFile = "$env:TEMP\wsl_install_temp.ps1"
$script = @"
param (
    [string]`$LinuxDistroPath
)

# Install the Linux distribution
Add-AppxPackage -Path `$LinuxDistroPath

# Check if the distribution supports WSL 2 and upgrade accordingly
\$distroName = (Get-AppxPackage -Name * | Where-Object { \$_ -match `(Get-FileNameWithoutExtension `$LinuxDistroPath) }).Name

if (\$distroName -match "Ubuntu" -or \$distroName -match "Debian" -or \$distroName -match "Kali" -or \$distroName -match "openSUSE" -or \$distroName -match "SLES") {
    Write-Host "Upgrading to WSL 2 for this distribution..."
    wsl --set-version \$distroName 2
} else {
    Write-Host "This distribution does not support WSL 2 or WSL 2 is not available for this distribution."
}

# Set WSL 2 as the default version for new distributions (optional)
wsl --set-default-version 2

# Remove the scheduled task and the temporary file
Unregister-ScheduledTask -TaskName "WSLInstallTask" -Confirm:$false
Remove-Item `$TempFile

Write-Host "Installation complete! WSL setup is done."
"@

$script | Out-File -FilePath $TempFile -Encoding UTF8

# Create a scheduled task to run the script after system restart
$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-ExecutionPolicy Bypass -File `"$TempFile`" -LinuxDistroPath `"$LinuxDistroPath`""
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$taskname = "WSLInstallTask"

Register-ScheduledTask -TaskName $taskname -Action $action -Trigger $trigger -Principal $principal

# Restart the system
Write-Host "The system will restart in 10 seconds..."
Start-Sleep -Seconds 10
Restart-Computer
