##########
# Win10 setup script
# Author: Ceynri <ceynri@gmail.com>
# Version: v1.0, 2021-06-06
# Source: https://github.com/ceynri/win10-setup
##########

##########
# App list
##########

$msftBloats = @(
    "Microsoft.Wallet",
    "Microsoft.Messaging",
    "Microsoft.YourPhone",
    "Microsoft.People",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",

    "Microsoft.SkypeApp",
    "Microsoft.BingNews",
    "Microsoft.BingMaps",
    "Microsoft.BingSports",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Microsoft.MicrosoftStickyNotes",

    "Microsoft.Print3D",
    "Microsoft.3DBuilder",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.OneConnect",
    "Microsoft.WindowsMaps",
    "Microsoft.Windows.Cortana",
    "Microsoft.MixedReality.Portal",
    "Microsoft.MicrosoftSolitaireCollection",

    "Microsoft.WindowsFeedbackHub",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.Office.OneNote"
    "microsoft.windowscommunicationsapps",
    "Microsoft.Advertising.Xaml"
)
$wingetApps = @(
    "Qv2ray.Qv2ray",
    # "7zip.7zip",
    "Bandisoft.Bandizip -v 6.29", # the old version without ads
    # "Bandisoft.Honeyview",
    "nomacs.nomacs",

    "Microsoft.VisualStudioCode",
    "Microsoft.Edge",

    "Tencent.QQ",
    "Tencent.WeChat",
    "utools.utools",

    "Git.Git",
    "OpenJS.NodeJSLTS",
    "Lexikos.AutoHotkey",

    "agalwood.Motrix",
    "Netease.CloudMusic",
    "VideoLAN.VLC", # seems that the download is slow, and easy to report errors？
    # "OBSProject.OBSStudio",

    "SyncTrayzor.SyncTrayzor",
    "NickeManarin.ScreenToGif",

    "Microsoft.WindowsTerminal",
    "Google.Chrome",
    "Logitech.Options",
    "Anaconda.Miniconda3"
)
$chocoApps = @(
    "v2ray",
    "traffic-monitor",
    "nvm.portable"
    # "aria2"
    # "ffmpeg",
    # "freefilesync",
    # "setpoint",
)
$npmPackages = @(
    "whistle"
)
$gitRepos = @(
    "awesome-ahk"
)

$notInstalledApps = @(
    "Snipaste: https://dl.snipaste.com/win-x64-beta-cn",
    "WGestures: https://www.yingdev.com/Content/Projects/WGestures/Release/1.8.4.0/Install%20WGestures%201.8.4.0.zip",

    "Office 365",
    "Office Tool Plus",
    "PhotoShop",
    "Premiere",

    "WSL",

    "BaiduNetDisk: https://pan.baidu.com/download"
)

##########
# Command list
##########

# import .psm1 module
Import-Module -Name "./setup.psm1" -ErrorAction Stop

# system settings
RequireAdmin
CreateTmpDir
ActivateWin10
RenameComputerName
setPowerSettings
executeTweaks("Tweaks")

# application management
UninstallMsftBloat($msftBloats)

# install by winget
ProxyWarning
InstallWinget
InstallAppByWinget($wingetApps)
RefreshEnv

# install by choco
ChocoProxyWarning
InstallChoco
InstallAppByChoco($chocoApps)
RefreshEnv

# others
ManualInstallApp($notInstalledApps)
WaitForKey

# environment settings
SetGitNameAndEmail
EnableGitProxy(10809)
EnableNpmRegistry
# InstallWindowsBuildTools

# others download
InstallNpmPackage($npmPackages)
CreateWorkspaceDir
CloneGitRepos($gitRepos)

# end
RemoveTmpDir
RestartTips
