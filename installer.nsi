;--------------------------------
;Include

  !include "MUI2.nsh"
	!include "FileFunc.nsh"

;--------------------------------
;General

	!define AppName "SharedElectron${ELECTRON_VERSION}"
	!define UninstallRegDir "Software\Microsoft\Windows\CurrentVersion\Uninstall\${AppName}"

	!ifndef ELECTRON_VERSION
		!error "ELECTRON_VERSION is not defined"
	!endif
	!ifndef ARCH
		!error "ARCH is not defined"
	!endif
  ;Name and file
  Name "Shared Electron ${ELECTRON_VERSION} ${ARCH}"
  OutFile "${AppName}-win32-${ARCH}.exe"
  Unicode True

  ;Default installation folder
  InstallDir "$LOCALAPPDATA\${AppName}"

  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\${AppName}" ""

  ;Request application privileges for Windows Vista
  RequestExecutionLevel user

	; SetCompressor lzma

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "electron\${ARCH}\${ELECTRON_VERSION}\LICENSE"
	!insertmacro MUI_PAGE_LICENSE "LICENSE"
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section

  SetOutPath "$INSTDIR"

  ;ADD YOUR OWN FILES HERE...
	File /r "electron\${ARCH}\${ELECTRON_VERSION}\*"

  ;Store installation folder
  WriteRegStr HKCU "Software\${AppName}" "" $INSTDIR

	;Store executable path
	WriteRegStr HKCU "Software\${AppName}" "ExecutablePath" "$INSTDIR\electron.exe"

	WriteRegStr HKCU "${UninstallRegDir}" "DisplayName" "Shared Electron ${ELECTRON_VERSION}"
	WriteRegStr HKCU "${UninstallRegDir}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""

	${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
	IntFmt $0 "0x%08X" $0
 	WriteRegDWORD HKCU "${UninstallRegDir}" "EstimatedSize" "$0"

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall"

	;Delete all files
  nsExec::ExecToLog "del /F/S/Q $INSTDIR"

	;Remove empty folders
  RMDir /r "$INSTDIR"

	;Delete registry data
	DeleteRegValue HKCU "Software\${AppName}" "ExecutablePath"
  DeleteRegKey /ifempty HKCU "Software\${AppName}"
	DeleteRegKey HKCU "${UninstallRegDir}"

SectionEnd
