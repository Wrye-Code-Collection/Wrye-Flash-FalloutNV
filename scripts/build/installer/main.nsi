; Wrye Flash.nsi
Unicode true

;-------------------------------- Includes:
    !addincludedir "scripts\build\installer"
    !include "MUI2.nsh"
    !include "x64.nsh"
    !include "LogicLib.nsh"
    !include "WinVer.nsh"
    !include "nsDialogs.nsh"
    !include "WordFunc.nsh"
    !include "StrFunc.nsh"
    ; declare used functions
    ${StrLoc}

    ; Variables are defined by the packaging script; just define failsafe values
    !ifndef WB_NAME
        !define WB_NAME "Wrye Flash (version unknown)"
    !endif
    !ifndef WB_FILEVERSION
        !define WB_FILEVERSION "0.0.0.0"
    !endif


;-------------------------------- Basic Installer Info:
    Name "${WB_NAME}"
    OutFile "scripts\dist\${WB_NAME} - Installer.exe"
    ; Request application privileges for Windows Vista
    RequestExecutionLevel admin
    VIProductVersion ${WB_FILEVERSION}
    VIAddVersionKey /LANG=1033 "ProductName" "Wrye Flash"
    VIAddVersionKey /LANG=1033 "CompanyName" "Wrye Flash development team"
    VIAddVersionKey /LANG=1033 "LegalCopyright" "© Wrye"
    VIAddVersionKey /LANG=1033 "FileDescription" "Installer for ${WB_NAME}"
    VIAddVersionKey /LANG=1033 "FileVersion" "${WB_FILEVERSION}"
    SetCompressor /SOLID lzma


;-------------------------------- Variables:
    Var Dialog
    Var Label
    Var Empty
    Var True
    Var Path_NV

    ;Game specific Data:
    Var Check_NV
    Var CheckState_NV
    Var Check_NV_Py
    Var CheckState_NV_Py
    Var Check_NV_Exe
    Var CheckState_NV_Exe
    Var Reg_Value_NV_Py
    Var Reg_Value_NV_Exe
    Var PathDialogue_NV
    Var Browse_NV
    Var Check_Readme
    Var Check_DeleteOldFiles
    Var Function_Browse
    Var Function_Extra
    Var Function_DirPrompt
    Var unFunction_Browse
    Var Python_Path
    Var Python_Comtypes
    Var Python_pywin32
    Var Python_wx
    Var PythonVersionInstall
    Var ExeVersionInstall
    Var MinVersion_Comtypes
    Var MinVersion_wx
    Var MinVersion_pywin32


;-------------------------------- Page List:
    !define MUI_HEADERIMAGE
    !define MUI_HEADERIMAGE_BITMAP "Mopy\bash\images\nsis\wrye_monkey_150x57.bmp"
    !define MUI_HEADERIMAGE_RIGHT
    !define MUI_WELCOMEFINISHPAGE_BITMAP "Mopy\bash\images\nsis\wrye_monkey_164x314.bmp"
    !define MUI_UNWELCOMEFINISHPAGE_BITMAP "Mopy\bash\images\nsis\wrye_monkey_164x314.bmp"
    !insertmacro MUI_PAGE_WELCOME
    Page custom PAGE_INSTALLLOCATIONS PAGE_INSTALLLOCATIONS_Leave
    Page custom PAGE_CHECK_LOCATIONS PAGE_CHECK_LOCATIONS_Leave
    !insertmacro MUI_PAGE_COMPONENTS
    !insertmacro MUI_PAGE_INSTFILES
    Page custom PAGE_FINISH PAGE_FINISH_Leave

    !insertmacro MUI_UNPAGE_WELCOME
    UninstPage custom un.PAGE_SELECT_GAMES un.PAGE_SELECT_GAMES_Leave
    !insertmacro MUI_UNPAGE_INSTFILES


;-------------------------------- Initialize Variables as required:
    Function un.onInit
        StrCpy $Empty ""
        StrCpy $True "True"
        ReadRegStr $Path_NV              HKLM "Software\Wrye Flash" "FalloutNV Path"
        ReadRegStr $Reg_Value_NV_Py      HKLM "Software\Wrye Flash" "FalloutNV Python Version"
        ReadRegStr $Reg_Value_NV_Exe     HKLM "Software\Wrye Flash" "FalloutNV Standalone Version"
    FunctionEnd

    Function .onInit
        StrCpy $Empty ""
        StrCpy $True "True"
        ReadRegStr $Path_NV              HKLM "Software\Wrye Flash" "FalloutNV Path"
        ReadRegStr $Reg_Value_NV_Py      HKLM "Software\Wrye Flash" "FalloutNV Python Version"
        ReadRegStr $Reg_Value_NV_Exe     HKLM "Software\Wrye Flash" "FalloutNV Standalone Version"

        StrCpy $MinVersion_Comtypes '0.6.2'
        StrCpy $MinVersion_wx '2.8.12'
        StrCpy $MinVersion_pywin32 '217'
        StrCpy $Python_Comtypes "1"
        StrCpy $Python_wx "1"
        StrCpy $Python_pywin32 "1"

        ${If} $Path_NV == $Empty
            ReadRegStr $Path_NV HKLM "Software\Bethesda Softworks\FalloutNV" "Installed Path"
            ${If} $Path_NV == $Empty
                ReadRegStr $Path_NV HKLM "SOFTWARE\Wow6432Node\Bethesda Softworks\FalloutNV" "Installed Path"
            ${EndIf}
        ${EndIf}
        ${If} $Path_NV != $Empty
            StrCpy $CheckState_NV ${BST_CHECKED}
        ${EndIf}

        ${If} $Reg_Value_NV_Exe == $True
        ${OrIf} $Reg_Value_NV_Py != $True
            StrCpy $CheckState_NV_Exe ${BST_CHECKED}
        ${EndIf}
        ${If} $Reg_Value_NV_Py == $True
            StrCpy $CheckState_NV_Py ${BST_CHECKED}
        ${EndIf}

    FunctionEnd


;-------------------------------- Auxilliary Functions
    Function OnClick_Browse
        Pop $0
        ${If} $0 == $Browse_NV
            StrCpy $1 $PathDialogue_NV
        ${EndIf}
        ${NSD_GetText} $1 $Function_DirPrompt
        nsDialogs::SelectFolderDialog /NOUNLOAD "Please select a target directory" $Function_DirPrompt
        Pop $0

        ${If} $0 == error
            Abort
        ${EndIf}

        ${NSD_SetText} $1 $0
    FunctionEnd

    Function un.OnClick_Browse
        Pop $0
        ${If} $0 == $Browse_NV
            StrCpy $1 $PathDialogue_NV
        ${ElseIf} $0 == $Browse_Nehrim_Remove
            StrCpy $1 $PathDialogue_Nehrim_Remove
        ${ElseIf} $0 == $Browse_Skyrim_Remove
            StrCpy $1 $PathDialogue_Skyrim_Remove
        ${ElseIf} $0 == $Browse_Ex1_Remove
            StrCpy $1 $PathDialogue_Ex1_Remove
        ${ElseIf} $0 == $Browse_Ex2_Remove
            StrCpy $1 $PathDialogue_Ex2_Remove
        ${EndIf}
        ${NSD_GetText} $1 $Function_DirPrompt
        nsDialogs::SelectFolderDialog /NOUNLOAD "Please select a target directory" $Function_DirPrompt
        Pop $0

        ${If} $0 == error
            Abort
        ${EndIf}

        ${NSD_SetText} $1 $0
    FunctionEnd

;-------------------------------- Include Local Script Files

    !include "macros.nsh"
    !include "pages.nsi"
    !include "install.nsi"
    !include "uninstall.nsi"

;-------------------------------- Descriptions/Subtitles/Language Strings:
  ;Language strings
  !insertmacro MUI_LANGUAGE "English"
  LangString DESC_Main ${LANG_ENGLISH} "The main Wrye Flash files."
  LangString DESC_Shortcuts_SM ${LANG_ENGLISH} "Start Menu shortcuts for the uninstaller and each launcher."
  LangString DESC_Prereq ${LANG_ENGLISH} "The files that Wrye Flash requires to run."
  LangString PAGE_INSTALLLOCATIONS_TITLE ${LANG_ENGLISH} "Installation Location(s)"
  LangString PAGE_INSTALLLOCATIONS_SUBTITLE ${LANG_ENGLISH} "Please select main installation path for Wrye Flash and, if desired, extra locations in which to install Wrye Flash."
  LangString PAGE_CHECK_LOCATIONS_TITLE ${LANG_ENGLISH} "Installation Location Check"
  LangString PAGE_CHECK_LOCATIONS_SUBTITLE ${LANG_ENGLISH} "A risky installation location has been detected."
  LangString PAGE_REQUIREMENTS_TITLE ${LANG_ENGLISH} "Installation Prerequisites"
  LangString PAGE_REQUIREMENTS_SUBTITLE ${LANG_ENGLISH} "Checking for requirements"
  LangString unPAGE_SELECT_GAMES_SUBTITLE ${LANG_ENGLISH} "Please select which locations you want to uninstall Wrye Flash from."
  LangString PAGE_FINISH_TITLE ${LANG_ENGLISH} "Finished installing ${WB_NAME}"
  LangString PAGE_FINISH_SUBTITLE ${LANG_ENGLISH} "Please select post-install tasks."

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
        !insertmacro MUI_DESCRIPTION_TEXT ${Main} $(DESC_Main)
        !insertmacro MUI_DESCRIPTION_TEXT ${Shortcuts_SM} $(DESC_Shortcuts_SM)
        !insertmacro MUI_DESCRIPTION_TEXT ${Prereq} $(DESC_Prereq)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END
