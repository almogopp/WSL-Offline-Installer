# WSL Offline Installation Script

This script automates the offline installation of Windows Subsystem for Linux (WSL) on various Windows operating systems, including Windows Server 2019, Windows Server 2022, Windows 10, and Windows 11. It allows you to install a Linux distribution from an Appx file and, if supported, upgrade it to WSL 2. This is particularly useful in environments where internet access is limited or unavailable.

## Features

- **Offline Installation**: No internet connection is required during the script execution, making it ideal for isolated environments.
- **Automatic OS Detection**: The script automatically detects your operating system and installs the appropriate WSL components.
- **Linux Distribution Installation**: Installs a Linux distribution of your choice from a pre-downloaded Appx file.
- **WSL 2 Upgrade**: Checks if the distribution supports WSL 2 and upgrades it if possible.
- **Post-Installation Cleanup**: Automatically cleans up temporary files and tasks after installation.

## Prerequisites

- **Linux Distribution Appx File**: Before running the script, download the Linux distribution you wish to install as an Appx file. You can find these files at the following link:

  [Download WSL Linux Distributions](https://aka.ms/wslstorepage)

  Available distributions include:
  - Ubuntu
  - Debian
  - Kali Linux
  - openSUSE
  - SUSE Linux Enterprise Server (SLES)
  
  Make sure to download the correct version for your system and save it in a known location on your computer.

## Script Usage

### Step 1: Download the Linux Distribution

1. Visit the [WSL Linux Distributions Download Page](https://aka.ms/wslstorepage).
2. Download the desired Linux distribution as an Appx file.
3. Save the file on your local machine in a directory that is easy to access.

### Step 2: Run the Script

1. **Open PowerShell as Administrator**:
   - Right-click on the Start menu and select "Windows PowerShell (Admin)".
   
2. **Execute the Script**:
   - Navigate to the directory where the script (`WSL-Offline-Install.ps1`) is located.
   - Run the script using the following command:
   ```powershell
   .\WSL-Offline-Install.ps1
   
## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.   
