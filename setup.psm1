##########
# Win10 setup - Tweak library
# Author: Ceynri <ceynri@gmail.com>
# Version: v1.0, 2021-06-06
# Source: https://github.com/ceynri/win10-setup
# Extended from: https://github.com/Disassembler0/Win10-Initial-Setup-Script
##########

##########
# global variable
##########

$currentDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$tmpDir = "$currentDir/tmp"
$userDir = "C:/ceynri"
$workspaceDir = "$userDir/workspace"

##########
# utils
##########

# Relaunch the script with administrator privileges
Function RequireAdmin {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
		Exit
	}
}

# check command is exist
Function CheckCommand($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# create a temp directory
Function CreateTmpDir() {
    PrintLog "Creating the temp directory..."
    New-Item -Path $currentDir -Name "tmp" -type directory
}

# remove the temp directory
Function RemoveTmpDir() {
    PrintLog "Removing the temp directory..."
    Remove-Item $tmpDir -recurse
}

# create a temp directory
Function CreateWorkspaceDir() {
    PrintLog "Checking the workspace directory..."
    New-Item -Path $userDir -Name "workspace" -type directory
}

Function RefreshEnv() {
    $expanded = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    $previous = ''
    while($previous -ne $expanded) {
        $previous = $expanded
        $expanded = [System.Environment]::ExpandEnvironmentVariables($previous)
    }
    $env:Path = $expanded
}

##########
# win10 settings
##########

# Activate win10 by [kmspro](https://github.com/dylanbai8/kmspro)
Function ActivateWin10() {
    PrintLog "Activating win10 by kmspro..."
    slmgr /skms kms.v0v.bid; slmgr /ato
}

# rename computer name
Function RenameComputerName() {
    $computerName = Read-Host 'Enter New Computer Name'
    PrintWarn "Renaming this computer to: " $computerName
    Rename-Computer -NewName $computerName
}

# change sleep settings
# If your laptop is often unable to wake up from sleep, set it to 0 and shutdown manually when needed
Function setPowerSettings() {
    PrintLog "Setting display and sleep mode timeouts..."
    powercfg /X monitor-timeout-ac 10
    powercfg /X monitor-timeout-dc 5
    powercfg /X standby-timeout-ac 0
    powercfg /X standby-timeout-dc 45
}

Function executeTweaks($filename) {
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$currentDir/$filename.ps1" -include "$currentDir/$filename.psm1" -preset "$currentDir/$filename.preset"
}

##########
# remove pre-installed Apps
##########

# To list all appx packages: (You can find out which apps you don’t need)
Function ListAllAppxPkgs() {
    Get-AppxPackage | Format-Table -Property Name,Version,PackageFullName
}

# remove UWP rubbish
Function UninstallMsftBloat($msftBloats) {
    PrintLog "Uninstalling default Microsoft applications..."
    foreach ($app in $msftBloats) {
        Get-AppxPackage $app | Remove-AppxPackage
    }
}

##########
# install Apps
##########

Function ProxyWarning() {
    PrintWarn "[WARN] If you are in China: please make sure the system proxy is turned on to access the true internet firstly!"
	WaitForKey
}

Function ChocoProxyWarning() {
    PrintWarn "[WARN] Choco will be installed next, enable global proxy is more secure if you are in china"
	WaitForKey
}

# install winget
Function InstallWinget() {
    if (CheckCommand -cmdname 'winget') {
        PrintLog "Winget is already installed, skip installation."
    }
    else {
        PrintLog "Downloading winget installation package..."
        PrintLog "Please execute install manually in the open window when download is complete"
        $downloadPath = "$tmpDir/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle"
        wget -O $downloadPath "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle"

        &$downloadPath
        
        PrintWarn "[WAITING] Enter any key until the installation is complete"
        WaitForKey
    }
}

# install choco
Function InstallChoco() {
    if (CheckCommand -cmdname 'choco') {
        PrintLog "Choco is already installed, skip installation."
    }
    else {
        PrintLog "Installing Chocolate..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
}

# install essential apps by winget
Function InstallAppByWinget($wingetApps) {
    if (CheckCommand -cmdname 'winget') {
        PrintLog "Installing Essential Applications by winget..."
        foreach ($app in $wingetApps) {
            # use string as a command for carrying args in the $app
            powershell "winget install $app -e"
        }
    }
    else {
        PrintError "Can not find 'winget' command, skip the installation."
    }
}

# install essential apps by choco
Function InstallAppByChoco($chocoApps) {
    if (CheckCommand -cmdname 'choco') {
        PrintLog "Installing Essential Applications by choco..."
        foreach ($app in $chocoApps) {
            choco install $app -y
        }
    }
    else {
        PrintError "Can not find 'choco' command, skip the installation."
    }
}

# install npm global packages
Function InstallNpmPackage($npmPackages) {
    if (CheckCommand -cmdname 'npm') {
        PrintLog "Installing npm global node packages..."
        foreach ($package in $npmPackages) {
            npm install -g $package
        }
    }
    else {
        PrintError "Can not find 'npm' command, skip the installation."
    }
}

# install apps manually
Function ManualInstallApp($notInstalledApps) {
    PrintLog "There are also the following uninstalled apps, you need to install manually:"
    foreach ($app in $notInstalledApps) {
        Write-Output "$app"
    }
}

# clone essential git repository
Function CloneGitRepos($gitRepos) {
    if (CheckCommand -cmdname 'git') {
        PrintLog "Cloning essential git repositorys..."
        foreach ($repo in $gitRepos) {
            git clone "https://github.com/ceynri/$repo.git" "$workspaceDir/$repo"
        }
    }
    else {
        PrintError "Can not find 'git' command, skip the clone."
    }
}

##########
# Env settings
##########

Function EnableGlobalProxy($port) {
    $env:HTTP_PROXY = "http://127.0.0.1:$port"
    $env:HTTPS_PROXY = "http://127.0.0.1:$port"
}

Function DisableGlobalProxy() {
    $env:HTTP_PROXY = ""
    $env:HTTPS_PROXY = ""
}

Function SetGitNameAndEmail() {
    if (CheckCommand -cmdname 'git') {
        git config --global user.name ceynri
        git config --global user.email "ceynri@gmail.com"
    }
    else {
        PrintError "Can not find 'git' command, skip set git name and email."
    }
}

Function EnableGitProxy($port) {
    if (CheckCommand -cmdname 'git') {
        git config --global http.proxy "http://127.0.0.1:$port"
        git config --global https.proxy "http://127.0.0.1:$port"
    }
    else {
        PrintError "Can not find 'git' command, skip enable git proxy."
    }
}

Function DisableGitProxy($port) {
    if (CheckCommand -cmdname 'git') {
        git config --global --unset http.proxy
        git config --global --unset https.proxy
    }
    else {
        PrintError "Can not find 'git' command, skip disable git proxy."
    }
}

Function EnableNpmRegistry() {
    if (CheckCommand -cmdname 'npm') {
        npm config set registry "https://registry.npm.taobao.org"
    }
    else {
        PrintError "Can not find 'npm' command, skip enable npm registry."
    }
}

Function EnableNpmProxy($port) {
    if (CheckCommand -cmdname 'npm') {
        npm config set proxy "http://127.0.0.1:$port"
        npm config set https-proxy "http://127.0.0.1:$port"
    }
    else {
        PrintError "Can not find 'npm' command, skip enable npm proxy."
    }
}

Function AddNvmMirror() {
    NVM_NODEJS_ORG_MIRROR=http://npm.taobao.org/mirrors/node
}

Function AddNodeSassMirror() {
    SASS_BINARY_SITE=http://npm.taobao.org/mirrors/node-sass
}

Function InstallWindowsBuildTools() {
    set "PYTHON_MIRROR=http://npm.taobao.org/mirrors/python"
    if (CheckCommand -cmdname 'npm') {
        npm install --global --production windows-build-tools
    }
    else {
        PrintError "Can not find 'npm' command, skip install windows-build-tools."
    }
}

##########
# Auxiliary Functions
##########

Function WaitForKey() {
	Write-Output "`nPress any key to continue..."
	[Console]::ReadKey($true) | Out-Null
}

Function PrintLog($str) {
    Write-Host $str -ForegroundColor Green
}

Function PrintWarn($str) {
    Write-Host $str -ForegroundColor Yellow
}

Function PrintError($str) {
    Write-Host $str -ForegroundColor Red
}

Function ClearInstallationTips() {
    PrintWarn "[TIPS] You can remove installation package in the 'tmp' directory"
    WaitForKey
}

Function RestartTips() {
    $restartInput = Read-Host "Setup is done, restart is needed, input 'y' to restart computer. (y/[N])"
    if ((('y', 'Y', 'yes') -contains $restartInput)) {
        Restart-Computer
    } else {
        RefreshEnv
    }
}

Export-ModuleMember -Function *
