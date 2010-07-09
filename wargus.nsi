;
;    stratagus.nsi - Windows NSIS Installer for Stratragus
;    Copyright (C) 2010  Pali Rohár <pali.rohar@gmail.com>
;
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
;

!include "MUI.nsh"

;--------------------------------

!define NAME "Wargus"
!define VERSION "2.2.5.1"

;--------------------------------

!define ICON "contrib/wargus.ico"
!define WARGUS "wargus.exe"
!define WARTOOL "wartool.exe"
!define PUDCONVERT "pudconvert.exe"
!define CDDA2WAV "cdda2wav.exe"
!define FFMPEG2THEORA "ffmpeg2theora.exe"
!define UNINSTALL "uninstall.exe"
!define INSTALLER "${NAME}-${VERSION}.exe"
!define INSTALLDIR "$PROGRAMFILES\${NAME}\"

!ifdef AMD64
!undef INSTALLER
!define INSTALLER "${NAME}-${VERSION}-x86_64.exe"
!undef INSTALLDIR
!define INSTALLDIR "$PROGRAMFILES64\${NAME}\"
!undef NAME
!define NAME "Wargus (64 bit)"
!endif

!define REGKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}"
!define LANGUAGE "English"

!ifdef AMD64
!define STRATAGUS_REGKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\Stratagus (64 bit)"
!else
!define STRATAGUS_REGKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\Stratagus"
!endif

;--------------------------------

LangString NO_STRATAGUS ${LANG_ENGLISH} "Stratagus is not installed. You need Stratagus to run Wargus! First install Stratagus, then Wargus."

LangString REMOVEPREVIOUS ${LANG_ENGLISH} "Removing previous installation"
LangString REMOVECONFIGURATION ${LANG_ENGLISH} "Removing configuration and data files:"

LangString EXTRACTDATA_FILES ${LANG_ENGLISH} "Extracting Warcraft II data files..."
LangString EXTRACTDATA_RIP_AUDIO ${LANG_ENGLISH} "Ripping Warcraft II audio tracks..."
LangString EXTRACTDATA_COPY_AUDIO ${LANG_ENGLISH} "Coping Warcraft II audio tracks..."
LangString EXTRACTDATA_CONVERT_AUDIO ${LANG_ENGLISH} "Converting Warcraft II audio tracks..."
LangString EXTRACTDATA_CONVERT_VIDEOS ${LANG_ENGLISH} "Converting Warcraft II video files..."

LangString EXTRACTDATA_FILES_FAILED ${LANG_ENGLISH} "Extracting Warcraft II data files failed."
LangString EXTRACTDATA_RIP_AUDIO_FAILED ${LANG_ENGLISH} "Ripping Warcraft II audio tracks failed."
LangString EXTRACTDATA_COPY_AUDIO_FAILED ${LANG_ENGLISH} "Coping Warcraft II audio tracks failed."
LangString EXTRACTDATA_CONVERT_AUDIO_FAILED ${LANG_ENGLISH} "Converting Warcraft II audio tracks failed."
LangString EXTRACTDATA_CONVERT_VIDEOS_FAILED ${LANG_ENGLISH} "Converting Warcraft II video files failed."

LangString EXTRACTDATA_PAGE_HEADER_TEXT ${LANG_ENGLISH} "Choose Warcraft II Location"
LangString EXTRACTDATA_PAGE_HEADER_SUBTEXT ${LANG_ENGLISH} "Choose the folder in which are Warcraft II data files."
LangString EXTRACTDATA_PAGE_TEXT_TOP ${LANG_ENGLISH} "Setup will extract Warcraft II data files from the following folder. You can specify location of CD or install location of Warcraft II data files. Note that you need the original Warcraft II CD Dos version (Battle.net edition does not work) to extract the game data files."
LangString EXTRACTDATA_PAGE_TEXT_DESTINATION ${LANG_ENGLISH} "Source Folder"
LangString EXTRACTDATA_PAGE_NOT_VALID ${LANG_ENGLISH} "This is not valid Warcraft II data directory. File $DATADIRdata\rezdat.war does not exist."

LangString DESC_REMOVEEXE ${LANG_ENGLISH} "Remove ${NAME} binary executables"
LangString DESC_REMOVECONF ${LANG_ENGLISH} "Remove all other configuration and extracted data files and directories in ${NAME} install directory created by user or ${NAME}"

!ifdef AMD64
LangString AMD64ONLY ${LANG_ENGLISH} "This version is for 64 bits computers only."
!endif

;--------------------------------

!ifndef NO_DOWNLOAD
!system "wget http://v2v.cc/~j/ffmpeg2theora/ffmpeg2theora-0.27.exe -O ffmpeg2theora.exe"
!system "wget http://smithii.com/files/cdrtools-2.01-bootcd.ru-w32.zip -O cdrtools.zip"
!system "unzip -o cdrtools.zip cdda2wav.exe"
!endif

;--------------------------------

Var STARTMENUDIR
Var DATADIR

!define MUI_ICON "${ICON}"
!define MUI_UNICON "${ICON}"

!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_FINISHPAGE_NOREBOOTSUPPORT
!define MUI_FINISHPAGE_RUN "$INSTDIR\${WARGUS}"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_UNFINISHPAGE_NOREBOOTSUPPORT
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKLM"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${REGKEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "StartMenu"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "COPYING"
!insertmacro MUI_PAGE_LICENSE "COPYING-3rd"
!insertmacro MUI_PAGE_DIRECTORY

!define MUI_PAGE_HEADER_TEXT "$(EXTRACTDATA_PAGE_HEADER_TEXT)"
!define MUI_PAGE_HEADER_SUBTEXT "$(EXTRACTDATA_PAGE_HEADER_SUBTEXT)"
!define MUI_DIRECTORYPAGE_TEXT_TOP "$(EXTRACTDATA_PAGE_TEXT_TOP)"
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "$(EXTRACTDATA_PAGE_TEXT_DESTINATION)"
!define MUI_DIRECTORYPAGE_VARIABLE $DATADIR
!define MUI_DIRECTORYPAGE_VERIFYONLEAVE
!define MUI_PAGE_CUSTOMFUNCTION_SHOW PageExtractDataShow
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE PageExtractDataLeave
!insertmacro MUI_PAGE_DIRECTORY

!insertmacro MUI_PAGE_STARTMENU Application $STARTMENUDIR
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_COMPONENTS
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "${LANGUAGE}"

;--------------------------------

Name "${NAME}"
Icon "${ICON}"
OutFile "${INSTALLER}"
InstallDir "${INSTALLDIR}"
InstallDirRegKey HKLM "${REGKEY}" "InstallLocation"

BrandingText " "
ShowInstDetails Show
ShowUnInstDetails Show
XPStyle on
RequestExecutionLevel admin

;--------------------------------

Function .onInit

!ifdef AMD64

	System::Call "kernel32::GetCurrentProcess() i .s"
	System::Call "kernel32::IsWow64Process(i s, *i .r0)"
	IntCmp $0 0 0 0 endcheck

	MessageBox MB_OK|MB_ICONSTOP "$(AMD64ONLY)"
	Abort

endcheck:

!endif

	ReadRegStr $R0 HKLM "${STRATAGUS_REGKEY}" "InstallLocation"
	StrCmp $R0 "" 0 datadir

	MessageBox MB_OK|MB_ICONSTOP "$(NO_STRATAGUS)"
	Abort

datadir:

	ReadRegStr $DATADIR HKLM "${REGKEY}" "DataDir"
	StrCmp $DATADIR "" 0 end

	StrCpy $DATADIR "D:\"

end:

FunctionEnd

;--------------------------------

Function PageExtractDataShow

	FindWindow $0 "#32770" "" $HWNDPARENT
	GetDlgItem $1 $0 1023
	ShowWindow $1 0

FunctionEnd

Function PageExtractDataLeave

	IfFileExists "$DATADIR\data\rezdat.war" end

	MessageBox MB_OK|MB_ICONSTOP "$(EXTRACTDATA_PAGE_NOT_VALID)"
	Abort

end:

FunctionEnd

;--------------------------------

Section "-${NAME}" UninstallPrevious

        SectionIn RO

	ReadRegStr $R0 HKLM "${REGKEY}" "InstallLocation"
	StrCmp $R0 "" end

	DetailPrint "$(REMOVEPREVIOUS)"
	SetDetailsPrint none
	ExecWait "$R0\${UNINSTALL} /S _?=$R0"
	Delete "$R0\${UNINSTALL}"
	RMDir $R0
	SetDetailsPrint lastused

end:

SectionEnd

Section "${NAME}"

	SectionIn RO

	SetOutPath "$INSTDIR"
	File "${WARGUS}"
	File "${WARTOOL}"
	File "${PUDCONVERT}"
	File "${CDDA2WAV}"
	File "${FFMPEG2THEORA}"

	SetOutPath "$INSTDIR\maps"
	File /r /x .svn /x *.pud* "maps\"
	SetOutPath "$INSTDIR\scripts"
	File /r /x .svn "scripts\"
	SetOutPath "$INSTDIR\campaigns"
	File /r /x .svn "campaigns\"
	SetOutPath "$INSTDIR"

	CreateDirectory "$INSTDIR\music"
	CreateDirectory "$INSTDIR\graphics"
	CreateDirectory "$INSTDIR\graphics\ui"
	CreateDirectory "$INSTDIR\graphics\ui\cursors"
	CreateDirectory "$INSTDIR\graphics\missiles"
	File "/oname=graphics\ui\cursors\cross.png" "contrib\cross.png"
	File "/oname=graphics\missiles\red_cross.png" "contrib\red_cross.png"
	File "/oname=graphics\ui\mana.png" "contrib\mana.png"
	File "/oname=graphics\ui\mana2.png" "contrib\mana2.png"
	File "/oname=graphics\ui\health.png" "contrib\health.png"
	File "/oname=graphics\ui\health2.png" "contrib\health2.png"
	File "/oname=graphics\ui\food.png" "contrib\food.png"
	File "/oname=graphics\ui\score.png" "contrib\score.png"
	File "/oname=graphics\ui\ore,stone,coal.png" "contrib\ore,stone,coal.png"
	File "/oname=music\Orc Briefing.ogg.gz" "contrib\toccata.mod.gz"

	!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
	CreateDirectory "$SMPROGRAMS\$STARTMENUDIR"
	CreateShortCut "$SMPROGRAMS\$STARTMENUDIR\${NAME}.lnk" "$INSTDIR\${WARGUS}"
	CreateShortCut "$SMPROGRAMS\$STARTMENUDIR\Uninstall.lnk" "$INSTDIR\${UNINSTALL}"
	CreateShortcut "$DESKTOP\${NAME}.lnk" "$INSTDIR\${WARGUS}"
	!insertmacro MUI_STARTMENU_WRITE_END

	WriteRegStr HKLM "${REGKEY}" "DisplayName" "${NAME}"
	WriteRegStr HKLM "${REGKEY}" "UninstallString" "$\"$INSTDIR\${UNINSTALL}$\""
	WriteRegStr HKLM "${REGKEY}" "QuietUninstallString" "$\"$INSTDIR\${UNINSTALL}$\" /S"
	WriteRegStr HKLM "${REGKEY}" "InstallLocation" "$INSTDIR"
	WriteRegStr HKLM "${REGKEY}" "DisplayIcon" "$\"$INSTDIR\${WARGUS}$\",0"
	WriteRegStr HKLM "${REGKEY}" "DisplayVersion" "${VERSION}"
	WriteRegDWORD HKLM "${REGKEY}" "NoModify" 1
	WriteRegDWORD HKLM "${REGKEY}" "NoRepair" 1
	WriteRegStr HKLM "${REGKEY}" "DataDir" "$DATADIR"

	WriteUninstaller "$INSTDIR\${UNINSTALL}"

SectionEnd

Section "${NAME}" ExtractData

	DetailPrint "$(EXTRACTDATA_FILES)"
	SetDetailsPrint none
	ExecWait "$\"$INSTDIR\${WARTOOL}$\" -v $\"$DATADIR\data$\" $\"$INSTDIR$\"" $0
	SetDetailsPrint lastused
	IntCmp $0 0 audio

	MessageBox MB_OK|MB_ICONSTOP "$(EXTRACTDATA_FILES_FAILED)"
	Abort

audio:

	IfFileExists "$DATADIR\data\music\*.*" copy_audio rip_audio

rip_audio:

	DetailPrint "$(EXTRACTDATA_RIP_AUDIO)"
	SetDetailsPrint none

	Var /global i
	${For} $i 2 17

		ExecWait "${CDDA2WAV} -D SPTI:1,2,0 -t $i $\"$INSTDIR\music\$i.wav$\"" $0
		IntCmp $0 0 next

		MessageBox MB_OK|MB_ICONSTOP "$(EXTRACTDATA_RIP_AUDIO_FAILED)"
		goto abord

next:

	${Next}

	Delete "$INSTDIR\music\audio.*"
	Delete "$INSTDIR\music\*.inf"

	Rename "$INSTDIR\music\2.wav" "$INSTDIR\music\Human Battle 1.wav"
	Rename "$INSTDIR\music\3.wav" "$INSTDIR\music\Human Battle 2.wav"
	Rename "$INSTDIR\music\4.wav" "$INSTDIR\music\Human Battle 3.wav"
	Rename "$INSTDIR\music\5.wav" "$INSTDIR\music\Human Battle 4.wav"
	Rename "$INSTDIR\music\6.wav" "$INSTDIR\music\Human Battle 5.wav"
	Rename "$INSTDIR\music\7.wav" "$INSTDIR\music\Human Briefing.wav"
	Rename "$INSTDIR\music\8.wav" "$INSTDIR\music\Human Victory.wav"
	Rename "$INSTDIR\music\9.wav" "$INSTDIR\music\Human Defeat.wav"
	Rename "$INSTDIR\music\10.wav" "$INSTDIR\music\Orc Battle 1.wav"
	Rename "$INSTDIR\music\11.wav" "$INSTDIR\music\Orc Battle 2.wav"
	Rename "$INSTDIR\music\12.wav" "$INSTDIR\music\Orc Battle 3.wav"
	Rename "$INSTDIR\music\13.wav" "$INSTDIR\music\Orc Battle 4.wav"
	Rename "$INSTDIR\music\14.wav" "$INSTDIR\music\Orc Battle 5.wav"
	Rename "$INSTDIR\music\15.wav" "$INSTDIR\music\Orc Briefing.wav"
	Rename "$INSTDIR\music\16.wav" "$INSTDIR\music\Orc Victory.wav"
	Rename "$INSTDIR\music\17.wav" "$INSTDIR\music\Orc Defeat.wav"

abord:

	SetDetailsPrint lastused
	goto convert_audio

copy_audio:

	DetailPrint "$(EXTRACTDATA_COPY_AUDIO)"
	SetDetailsPrint none
	CopyFiles "$DATADIR\data\music\*.*" "$INSTDIR\music\"
	SetDetailsPrint lastused
	IntCmp $0 0 convert_audio

	MessageBox MB_OK|MB_ICONSTOP "$(EXTRACTDATA_COPY_AUDIO_FAILED)"
	Abort

convert_audio:

	IfFileExists "$DATADIR\data\music\*.wav" 0 convert_videos

	DetailPrint "$(EXTRACTDATA_CONVERT_AUDIO)"
	SetDetailsPrint none
	SetOutPath "$INSTDIR\music"
	ExecWait "cmd /c $\"@echo off && for %f in (*.wav) do ..\${FFMPEG2THEORA} --optimize %f && del /q %f$\"" $0
	SetOutPath "$INSTDIR"
	SetDetailsPrint lastused
	IntCmp $0 0 convert_videos

	MessageBox MB_OK|MB_ICONSTOP "$(EXTRACTDATA_CONVERT_AUDIO_FAILED)"
	Abort

convert_videos:

	DetailPrint "$(EXTRACTDATA_CONVERT_VIDEOS)"
	SetDetailsPrint none
	SetOutPath "$INSTDIR\videos"
	ExecWait "cmd /c $\"@echo off && for %f in (*.smk) do ..\${FFMPEG2THEORA} --optimize %f && del /q %f$\"" $0
	SetOutPath "$INSTDIR"
	SetDetailsPrint lastused
	IntCmp $0 0 end

	MessageBox MB_OK|MB_ICONSTOP "$(EXTRACTDATA_CONVERT_VIDEOS_FAILED)"
	Abort

end:

SectionEnd

;--------------------------------

Section "un.${NAME}" Executable

	SectionIn RO

	Delete "$INSTDIR\${WARGUS}"
	Delete "$INSTDIR\${WARTOOL}"
	Delete "$INSTDIR\${PUDCONVERT}"
	Delete "$INSTDIR\${CDDA2WAV}"
	Delete "$INSTDIR\${FFMPEG2THEORA}"
	Delete "$INSTDIR\${UNINSTALL}"
	RMDir "$INSTDIR"

	!insertmacro MUI_STARTMENU_GETFOLDER Application $STARTMENUDIR
	Delete "$SMPROGRAMS\$STARTMENUDIR\${NAME}.lnk"
	Delete "$SMPROGRAMS\$STARTMENUDIR\Uninstall.lnk"
	RMDir "$SMPROGRAMS\$STARTMENUDIR"
	Delete "$DESKTOP\${NAME}.lnk"

	DeleteRegKey /ifempty HKLM "${REGKEY}"

SectionEnd

Section /o "un.Configuration" Configuration

	DetailPrint "$(REMOVECONFIGURATION)"
	RMDir /r "$INSTDIR"

SectionEnd

!insertmacro MUI_UNFUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT "${Executable}" "$(DESC_REMOVEEXE)"
!insertmacro MUI_DESCRIPTION_TEXT "${Configuration}" "$(DESC_REMOVECONF)"
!insertmacro MUI_UNFUNCTION_DESCRIPTION_END

;--------------------------------

!ifndef NO_DOWNLOAD
!system "rm -f ffmpeg2theora.exe cdda2wav.exe cdrtools.zip || del /q ffmpeg2theora.exe cdda2wav.exe cdrtools.zip"
!endif

;--------------------------------
