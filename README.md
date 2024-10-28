# Shared Electron
An installer and launcher for a shared version of electron. Currently only for windows.

## Why?
To save disk space. There is no need to include 250+ mb of binaries for each electron app when each unique app only actually needs the asar file. The binaries can be shared. Node.JS native addons are included in the .asar file.

<br />

# Windows build instructions

## Shared Electron installer (Instructions are for Electron 33 on x86_64 (x64) Windows. Change them for your target version and architecture if needed)
- Put Electron files in electron/x64/33.
- Run `makensis /DARCH=x64 /DELECTRON_VERSION=33 installer.nsi`
- Installer should be SharedElectron33-win32-x64.exe in the folder.

## Shared Electron launcher instructions
To change the Electron version edit the `versionStr` value in `main.cpp`. It should be at line 10.\
Do not modify the rest of the launcher code unless you know what you are doing.

## How to use
Simply put the exe (can be renamed) and an app.asar file in a folder and it will work if the approporiate version of Shared Electron is installed.
If the proper version of Shared Electron is not installed the launcher will show an error message box upon launch.

### Build Prerequisites
- Recent version of Visual Studio Build Tools or Visual Studio with C++ tools or GCC
- CMake

### Building in Visual Studio Code with the CMake extension
- Open the launcher folder inside of Visual Studio Code.
- Configure CMake to use your desired compiler. (either from the popup on top or the CMake menu on the left)
- Preferrably set it to Release mode.
- Run the `CMake: Build` command/action from the VSCode command bar (Ctrl + Shift + P)
- Assuming the build process succeeded, the executable should be at:
  - Debug - build/Debug/SharedElectronLauncher.exe
  - Release - build/Release/SharedElectronLauncher.exe
