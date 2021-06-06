# Windows 10 Setup Scripts

Windows 10 setup scripts for fresh installs

## Prerequisites

- A fresh install of Windows 10.
- If in China: prepare proxy software to access the true internet.

## Usage

Fork or download this repo, **MODIFY** the scripts and execute `setup.cmd` in your fresh installed computer.

**Run it as Administrator** to ensure that the script can run normally.

> The script has not been fully tested after each modification, please be careful if you are using it.
>
> You’d better understand what the scripts do if you run them. Some functions lower security, hide controls or uninstall applications. You'll most likely need to modify the scripts.

## Structure

### File

#### setup.cmd

Execute `setup.ps1` bypassing the default setting that does not allow `.ps1` scripts to be executed in Win10.

#### setup.ps1

Contains the main flow of the script, which calls functions in `setup.psm1`

#### setup.psm1

Some wrapped atomic operations are called by setup.ps1

#### tweaks.\*

Transplant from [Disassembler0/Win10-Initial-Setup-Script](https://github.com/Disassembler0/Win10-Initial-Setup-Script), a very comprehensive Win10 Initial Setup Script.

`tweaks.preset` is my custom preset. You'd better write a preset yourself compared with the original project.

#### Add_PS1_Run_as_administrator.reg

An **optional** registry. Import it to your registry can enable context menu on the powershell files to run as Administrator.

### Script content

- Modify system config
  - Activate win10 by [kmspro](https://github.com/dylanbai8/kmspro)
  - Set a new computer name
  - Set power settings
  - Excute Tweaks from [Disassembler0/Win10-Initial-Setup-Script](https://github.com/Disassembler0/Win10-Initial-Setup-Script)
    - Disable Cortana, AdvertisingID, UpdateRestart...
    - Set DeveloperMode, DarkMode, SmallTaskbarIcons...
    - Hide LibraryMenu, RecentShortcuts...
    - Uninstall OneDrive, Xbox...
- Remove pre-installed apps
  - Skype
  - YourPhone
  - Print3D
  - GetHelp
  - ...
- Install software by winget
  - Visual Studio Code
  - QQ, WeChat
  - Git, NodeJS, Miniconda
  - ...
- Install softwave by chocolaty (that can't be installed from Winget)
  - v2ray
  - ffmpeg
  - traffic-monitor
  - ...
- Show other commonly used app tips that have not been downloaded
  - Snipaste
  - WGestures
  - ...
- Configure the environment
  - Set git name and email
  - Enable git proxy
  - Enable npm taobao registry
- Install npm global packages
  - whistle
- Clone my own repos
  - awesome-ahk
- Restart computer

## Thanks

- [Disassembler0/Win10-Initial-Setup-Script](https://github.com/Disassembler0/Win10-Initial-Setup-Script)
- [EdiWang/EnvSetup](https://github.com/EdiWang/EnvSetup)
- [dylanbai8/kmspro](https://github.com/dylanbai8/kmspro)
- [winget](https://github.com/microsoft/winget-cli)
- [choco](https://github.com/chocolatey/choco)

## License

MIT
