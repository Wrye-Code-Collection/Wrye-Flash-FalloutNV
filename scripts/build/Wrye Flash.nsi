; Wrye Flash.nsi

;-------------------------------- Includes:
    !include "MUI2.nsh"
    !include "x64.nsh"
    !include "LogicLib.nsh"
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
    VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "Wrye Flash NV"
    VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "Wrye Flash development team"
    VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "© Wrye"
    VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "Installer for ${WB_NAME}"
    VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${WB_FILEVERSION}"
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


;-------------------------------- Install Locations Page
    Function PAGE_INSTALLLOCATIONS
        !insertmacro MUI_HEADER_TEXT $(PAGE_INSTALLLOCATIONS_TITLE) $(PAGE_INSTALLLOCATIONS_SUBTITLE)
        GetFunctionAddress $Function_Browse OnClick_Browse
        GetFunctionAddress $Function_Extra OnClick_Extra
        nsDialogs::Create 1018
            Pop $Dialog

        ${If} $Dialog == error
            Abort
        ${EndIf}

        ${NSD_CreateLabel} 0 0 100% 24u "Select which Game(s)/Extra location(s) which you would like to install Wrye Flash for.$\nAlso select which version(s) to install (Standalone exe (default) and/or Python version)."
            Pop $Label
            IntOp $0 0 + 25
        ${If} $Path_NV != $Empty
            ${NSD_CreateCheckBox} 0 $0u 30% 13u "Install for Oblivion"
                Pop $Check_NV
                ${NSD_SetState} $Check_NV $CheckState_NV
            ${NSD_CreateCheckBox} 30% $0u 40% 13u "Wrye Flash [Standalone]"
                Pop $Check_NV_Exe
                ${NSD_AddStyle} $Check_NV_Exe ${WS_GROUP}
                ${NSD_SetState} $Check_NV_Exe  $CheckState_NV_Exe
            ${NSD_CreateCheckBox} 70% $0u 30% 13u "Wrye Flash [Python]"
                Pop $Check_NV_Py
;                ${NSD_SetState} $Check_NV_Py  $CheckState_NV_Py
            IntOp $0 $0 + 13
            ${NSD_CreateDirRequest} 0 $0u 90% 13u "$Path_NV"
                Pop $PathDialogue_NV
            ${NSD_CreateBrowseButton} -10% $0u 5% 13u "..."
                Pop $Browse_NV
                nsDialogs::OnClick $Browse_NV $Function_Browse
            IntOp $0 $0 + 13
        ${EndIf}
        nsDialogs::Show
    FunctionEnd

    Function PAGE_INSTALLLOCATIONS_Leave
        # in case the user goes back to this page and changes selections
        StrCpy $PythonVersionInstall $Empty
        StrCpy $ExeVersionInstall $Empty

        ; Game paths
        ${NSD_GetText} $PathDialogue_NV $Path_NV

        ; Game states
        ${NSD_GetState} $Check_NV $CheckState_NV

        ; Python states
        ${NSD_GetState} $Check_NV_Py $CheckState_NV_Py
        ${If} $CheckState_NV_Py == ${BST_CHECKED}
        ${AndIf} $CheckState_NV == ${BST_CHECKED}
            StrCpy $PythonVersionInstall $True
        ${Endif}

        ; Standalone states
        ${NSD_GetState} $Check_NV_Exe $CheckState_NV_Exe
        ${If} $CheckState_NV_Exe == ${BST_CHECKED}
        ${AndIf} $CheckState_NV == ${BST_CHECKED}
            StrCpy $ExeVersionInstall $True
        ${Endif}
    FunctionEnd


;-------------------------------- Check Locations Page
    Function PAGE_CHECK_LOCATIONS
        !insertmacro MUI_HEADER_TEXT $(PAGE_CHECK_LOCATIONS_TITLE) $(PAGE_CHECK_LOCATIONS_SUBTITLE)

        ; test for installation in program files
        StrCpy $1 $Empty
        ${If} $CheckState_NV == ${BST_CHECKED}
            ${StrLoc} $0 $Path_NV "$PROGRAMFILES\" ">"
            ${If} "0" == $0
                StrCpy $1 $True
            ${Endif}
        ${Endif}

        ${If} $1 == $Empty
            ; nothing installed in program files: skip this page
            Abort
        ${Endif}

        nsDialogs::Create 1018
            Pop $Dialog
        ${If} $Dialog == error
            Abort
        ${EndIf}

        ${NSD_CreateLabel} 0 0 100% 24u "You are attempting to install Wrye Flash into the Program Files directory."
        Pop $Label
        SetCtlColors $Label "FF0000" "transparent"

        ${NSD_CreateLabel} 0 24 100% 128u "This is a very common cause of problems when using Wrye Flash. Highly recommended that you stop this installation now, reinstall (FalloutNV/Steam) into another directory outside of Program Files, such as C:\Games\FalloutNV, and install Wrye Flash at that location.$\n$\nThe problems with installing in Program Files stem from a feature of Windows that did not exist when Oblivion was released: User Access Controls (UAC).  If you continue with the install into Program Files, you may have trouble starting or using Wrye Flash, as it may not be able to access its own files."
        Pop $Label

        nsDialogs::Show
    FunctionEnd

    Function PAGE_CHECK_LOCATIONS_Leave
    FunctionEnd

;-------------------------------- Finish Page
    Function PAGE_FINISH
        !insertmacro MUI_HEADER_TEXT $(PAGE_FINISH_TITLE) $(PAGE_FINISH_SUBTITLE)

        ReadRegStr $Path_NV HKLM "Software\Wrye Flash" "FalloutNV Path"

        nsDialogs::Create 1018
            Pop $Dialog
        ${If} $Dialog == error
            Abort
        ${EndIf}

        IntOp $0 0 + 0
        ${NSD_CreateLabel} 0 0 100% 16u "Please select which Wrye Flash installation(s), if any, you would like to run right now:"
            Pop $Label
        IntOp $0 0 + 17
        ${If} $Path_NV != $Empty
            ${NSD_CreateCheckBox} 0 $0u 100% 8u "Oblivion"
                Pop $Check_NV
            IntOp $0 $0 + 9
        ${EndIf}
        IntOp $0 $0 + 9
        IntOp $1 0 + 0
        ${NSD_CreateCheckBox} $1% $0u 25% 8u "View Readme"
            Pop $Check_Readme
            ${NSD_SetState} $Check_Readme ${BST_CHECKED}
            IntOp $1 $1 + 25
        ${NSD_CreateCheckBox} $1% $0u 75% 8u "Delete files from old Flash versions"
            Pop $Check_DeleteOldFiles
            ${NSD_SetState} $Check_DeleteOldFiles ${BST_CHECKED}
        nsDialogs::Show
    FunctionEnd

    Function PAGE_FINISH_Leave
        ${NSD_GetState} $Check_NV $CheckState_NV

        ${If} $CheckState_NV == ${BST_CHECKED}
            SetOutPath "$Path_NV\Mopy"
            ${If} $CheckState_NV_Py == ${BST_CHECKED}
                ExecShell "open" '"$Path_NV\Mopy\Wrye Flash Launcher.pyw"'
            ${ElseIf} $CheckState_NV_Exe == ${BST_CHECKED}
                ExecShell "open" "$Path_NV\Mopy\Wrye Flash.exe"
            ${EndIf}
        ${EndIf}
        ${NSD_GetState} $Check_Readme $0
        ${If} $0 == ${BST_CHECKED}
            ${If} $Path_NV != $Empty
                ExecShell "open" "$Path_NV\Mopy\Wrye Flash.html"
            ${EndIf}
        ${EndIf}
        ${NSD_GetState} $Check_DeleteOldFiles $0
        ${If} $0 == ${BST_CHECKED}
            ${If} $Path_NV != $Empty
                Delete "$Path_NV\Data\Bash Patches\Bash_Groups.csv"
            ${EndIf}
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

;-------------------------------- The Installation Sections:

    Section "Prerequisites" Prereq
        SectionIn RO
        ; Both Python and Standalone versions require the MSVC 2013 redist, so check for that and download/install if necessary.
        ; Thanks to the pcsx2 installer for providing this!

        ; Detection made easy: Unlike previous redists, VC2013 now generates a platform
        ; independent key for checking availability.
        ; HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\12.0\VC\Runtimes\x86  for x64 Windows
        ; HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VisualStudio\12.0\VC\Runtimes\x86  for x86 Windows

        ; Download from:
        ; http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x86.exe

        ClearErrors

        ${If} ${RunningX64}
            ReadRegDword $R0 HKLM "SOFTWARE\Wow6432Node\Microsoft\VisualStudio\12.0\VC\Runtimes\x86" "Installed"
        ${Else}
            ReadRegDword $R0 HKLM "SOFTWARE\Microsoft\VisualStudio\12.0\VC\Runtimes\x86" "Installed"
        ${EndIf}

        ${If} $R0 == "1"
            DetailPrint "Visual C++ 2013 Redistributable is already installed; skipping!"
        ${Else}
            DetailPrint "Visual C++ 2013 Redistributable registry key was not found; assumed to be uninstalled."
            DetailPrint "Downloading Visual C++ 2013 Redistributable Setup..."
            SetOutPath $TEMP
            NSISdl::download "http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x86.exe" "vcredist_x86.exe"

            Pop $R0 ;Get the return value
            ${If} $R0 == "success"
                DetailPrint "Running Visual C++ 2013 Redistributable Setup..."
                Sleep 2000
                HideWindow
                ExecWait '"$TEMP\vcredist_x86.exe" /qb'
                BringToFront
                DetailPrint "Finished Visual C++ 2013 SP1 Redistributable Setup"

                Delete "$TEMP\vcredist_x86.exe"
            ${Else}
                DetailPrint "Could not contact Microsoft.com, or the file has been (re)moved!"
            ${EndIf}
        ${EndIf}

        ; Standalone version also requires the MSVC 2008 redist.
        ${If} $ExeVersionInstall == $True
            StrCpy $9 $Empty
            ${If} ${FileExists} "$SYSDIR\MSVCR90.DLL"
            ${OrIf} ${FileExists} "$COMMONFILES\Microsoft Shared\VC\msdia90.dll"
                StrCpy $9 "Installed"
            ${EndIf}
            ${If} $9 == $Empty
                ; MSVC 2008 (x86): http://download.microsoft.com/download/d/d/9/dd9a82d0-52ef-40db-8dab-795376989c03/vcredist_x86.exe
                DetailPrint "Visual C++ 2008 Redistributable was not found; assumed to be uninstalled."
                DetailPrint "Downloading Visual C++ 2008 Redistributable Setup..."
                SetOutPath $TEMP
                NSISdl::download "http://download.microsoft.com/download/d/d/9/dd9a82d0-52ef-40db-8dab-795376989c03/vcredist_x86.exe" "vcredist_x86.exe"

                Pop $R0 ;Get the return value
                ${If} $R0 == "success"
                    DetailPrint "Running Visual C++ 2008 Redistributable Setup..."
                    Sleep 2000
                    HideWindow
                    ExecWait '"$TEMP\vcredist_x86.exe" /qb'
                    BringToFront
                    DetailPrint "Finished Visual C++ 2008 SP1 Redistributable Setup"

                    Delete "$TEMP\vcredist_x86.exe"
                ${Else}
                    DetailPrint "Could not contact Microsoft.com, or the file has been (re)moved!"
                ${EndIf}
            ${Else}
                DetailPrint "Visual C++ 2008 Redistributable is already installed; skipping!"
            ${EndIf}
        ${EndIf}

        ; Python version also requires Python, wxPython, Python Comtypes and PyWin32.
        ${If} $PythonVersionInstall == $True
            ; Look for Python.
            ReadRegStr $Python_Path HKLM "SOFTWARE\Wow6432Node\Python\PythonCore\2.7\InstallPath" ""
            ${If} $Python_Path == $Empty
                ReadRegStr $Python_Path HKLM "SOFTWARE\Python\PythonCore\2.7\InstallPath" ""
            ${EndIf}
            ${If} $Python_Path == $Empty
                ReadRegStr $Python_Path HKCU "SOFTWARE\Wow6432Node\Python\PythonCore\2.7\InstallPath" ""
            ${EndIf}
            ${If} $Python_Path == $Empty
                ReadRegStr $Python_Path HKCU "SOFTWARE\Python\PythonCore\2.7\InstallPath" ""
            ${EndIf}

            ;Detect Python Components:
            ${If} $Python_Path != $Empty
                ;Detect Comtypes:
                ${If} ${FileExists} "$Python_Path\Lib\site-packages\comtypes\__init__.py"
                    FileOpen $2 "$Python_Path\Lib\site-packages\comtypes\__init__.py" r
                    FileRead $2 $1
                    FileRead $2 $1
                    FileRead $2 $1
                    FileRead $2 $1
                    FileRead $2 $1
                    FileRead $2 $1
                    FileClose $2
                    StrCpy $Python_Comtypes $1 5 -8
                    ${VersionConvert} $Python_Comtypes "" $Python_Comtypes
                    ${VersionCompare} $MinVersion_Comtypes $Python_Comtypes $Python_Comtypes
                ${EndIf}

                ; Detect wxPython.
                ReadRegStr $Python_wx HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\wxPython2.8-unicode-py27_is1" "DisplayVersion"
                ${If} $Python_wx == $Empty
                    ReadRegStr $Python_wx HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\wxPython2.8-unicode-py27_is1" "DisplayVersion"
                ${EndIf}
                ; Detect PyWin32.
                ReadRegStr $1         HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\pywin32-py2.7" "DisplayName"
                ${If} $1 == $Empty
                    ReadRegStr $1         HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\pywin32-py2.7" "DisplayName"
                ${EndIf}
                StrCpy $Python_pywin32 $1 3 -3

                ; Compare versions.
                ${VersionCompare} $MinVersion_pywin32 $Python_pywin32 $Python_pywin32
                ${VersionConvert} $Python_wx "+" $Python_wx
                ${VersionCompare} $MinVersion_wx $Python_wx $Python_wx
            ${EndIf}

            ; Download and install missing requirements.
            ${If} $Python_Path == $Empty
                SetOutPath "$TEMP\PythonInstallers"
                DetailPrint "Python 2.7.3 - Downloading..."
                NSISdl::download http://python.org/ftp/python/2.7.3/python-2.7.3.msi "$TEMP\PythonInstallers\python-2.7.3.msi"
                Pop $R0
                ${If} $R0 == "success"
                    DetailPrint "Python 2.7.3 - Installing..."
                    Sleep 2000
                    HideWindow
                    ExecWait '"msiexec" /i "$TEMP\PythonInstallers\python-2.7.3.msi"'
                    BringToFront
                    DetailPrint "Python 2.7.3 - Installed."
                ${Else}
                    DetailPrint "Python 2.7.3 - Download Failed!"
                    MessageBox MB_OK "Python download failed, please try running installer again or manually downloading."
                    Abort
                ${EndIf}
            ${Else}
                DetailPrint "Python 2.7.3 is already installed; skipping!"
            ${EndIf}
            ${If} $Python_wx == "1"
                SetOutPath "$TEMP\PythonInstallers"
                DetailPrint "wxPython 2.8.12.1 - Downloading..."
                NSISdl::download http://downloads.sourceforge.net/wxpython/wxPython2.8-win32-unicode-2.8.12.1-py27.exe "$TEMP\PythonInstallers\wxPython.exe"
                Pop $R0
                ${If} $R0 == "success"
                    DetailPrint "wxPython 2.8.12.1 - Installing..."
                    Sleep 2000
                    HideWindow
                    ExecWait '"$TEMP\PythonInstallers\wxPython.exe"'; /VERYSILENT'
                    BringToFront
                    DetailPrint "wxPython 2.8.12.1 - Installed."
                ${Else}
                    DetailPrint "wxPython 2.8.12.1 - Download Failed!"
                    MessageBox MB_OK "wxPython download failed, please try running installer again or manually downloading."
                    Abort
                ${EndIf}
            ${Else}
                DetailPrint "wxPython 2.8.12.1 is already installed; skipping!"
            ${EndIf}
            ${If} $Python_Comtypes == "1"
                SetOutPath "$TEMP\PythonInstallers"
                DetailPrint "Comtypes 0.6.2 - Downloading..."
                NSISdl::download http://downloads.sourceforge.net/project/comtypes/comtypes/0.6.2/comtypes-0.6.2.win32.exe?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fcomtypes%2F&ts=1291561083&use_mirror=softlayer "$TEMP\PythonInstallers\comtypes.exe"
                Pop $R0
                ${If} $R0 == "success"
                    DetailPrint "Comtypes 0.6.2 - Installing..."
                    Sleep 2000
                    HideWindow
                    ExecWait  '"$TEMP\PythonInstallers\comtypes.exe"'
                    BringToFront
                    DetailPrint "Comtypes 0.6.2 - Installed."
                ${Else}
                    DetailPrint "Comtypes 0.6.2 - Download Failed!"
                    MessageBox MB_OK "Comtypes download failed, please try running installer again or manually downloading: $0."
                    Abort
                ${EndIf}
            ${Else}
                DetailPrint "Comtypes 0.6.2 is already installed; skipping!"
            ${EndIf}
            ${If} $Python_pywin32 == "1"
                SetOutPath "$TEMP\PythonInstallers"
                DetailPrint "PyWin32 - Downloading..."
                NSISdl::download http://downloads.sourceforge.net/project/pywin32/pywin32/Build%20218/pywin32-218.win32-py2.7.exe?r=&ts=1352752073&use_mirror=iweb "$TEMP\PythonInstallers\pywin32.exe"
                Pop $R0
                ${If} $R0 == "success"
                    DetailPrint "PyWin32 - Installing..."
                    Sleep 2000
                    HideWindow
                    ExecWait  '"$TEMP\PythonInstallers\pywin32.exe"'
                    BringToFront
                    DetailPrint "PyWin32 - Installed."
                ${Else}
                    DetailPrint "PyWin32 - Download Failed!"
                    MessageBox MB_OK "PyWin32 download failed, please try running installer again or manually downloading."
                    Abort
                ${EndIf}
            ${Else}
                DetailPrint "PyWin32 is already installed; skipping!"
            ${EndIf}
        ${EndIf}
    SectionEnd

    Section "Wrye Flash" Main
        SectionIn RO

        ${If} $CheckState_NV == ${BST_CHECKED}
            ; Install resources:
            ${If} Path_NV != $Empty
                SetOutPath $Path_NV\Mopy
                File /r /x "*.svn*" /x "*.bat" /x "*.py*" /x "w9xpopen.exe" /x "Wrye Flash.exe" "Mopy\*.*"
                SetOutPath $Path_NV\Data
                ; no archive invalidation exists users should use NMM or FOMM
                ; File /r "Mopy\templates\Oblivion\ArchiveInvalidationInvalidated!.bsa"
                ; taglist for BOSS
                ; do not copy Bash_Groups.csv because it's for oblivion
                SetOutPath "$Path_NV\Data\Bash Patches"
                File /r "Data\Bash Patches\taglist.txt"
                ; empty Bash patches
                SetOutPath "$Path_NV\Mopy\templates"
                File /r "Mopy\templates\*.*"
                ; Documentation aside from the main file in the Mopy folder
                ; TODO Move the main Doc file to the Docs folder
                SetOutPath "$Path_NV\Data\Docs"
                File /r "Data\Docs\*.*"
                ; INI Tweaks
                SetOutPath "$Path_NV\Mopy\INI Tweaks"
                File /r "Mopy\INI Tweaks\*.*"
                ; Write the installation path into the registry
                WriteRegStr HKLM "SOFTWARE\Wrye Flash" "FalloutNV Path" "$Path_NV"
                ${If} $CheckState_NV_Py == ${BST_CHECKED}
                    SetOutPath "$Path_NV\Mopy"
                    File /r "Mopy\*.py" "Mopy\*.pyw" "Mopy\*.bat"
                    ; Write the installation path into the registry
                    WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Oblivion Python Version" "True"
                ${Else}
                    ${If} $Reg_Value_NV_Py == $Empty ; ie don't overwrite it if it is installed but just not being installed that way this time.
                        WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Oblivion Python Version" ""
                    ${EndIf}
                ${EndIf}
                ${If} $CheckState_NV_Exe == ${BST_CHECKED}
                    SetOutPath "$Path_NV\Mopy"
                    File "Mopy\w9xpopen.exe" "Mopy\Wrye Flash.exe"
                    ; Write the installation path into the registry
                    WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Oblivion Standalone Version" "True"
                ${Else}
                    ${If} $Reg_Value_NV_Exe == $Empty ; ie don't overwrite it if it is installed but just not being installed that way this time.
                        WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Oblivion Standalone Version" ""
                    ${EndIf}
                ${EndIf}
            ${EndIf}
        ${EndIf}
        ; Write the uninstall keys for Windows
        SetOutPath "$COMMONFILES\Wrye Flash"
        WriteRegStr HKLM "Software\Wrye Flash" "Installer Path" "$EXEPATH"
        WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Wrye Flash" "DisplayName" "Wrye Flash"
        WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Wrye Flash" "UninstallString" '"$COMMONFILES\Wrye Flash\uninstall.exe"'
        WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Wrye Flash" "URLInfoAbout" 'http://www.nexusmods.com/newvegas/mods/35003'
        WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Wrye Flash" "HelpLink" 'http://forums.bethsoft.com/topic/1234195-relz-wrye-flash-nv/'
        WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Wrye Flash" "Publisher" 'Wrye & Wrye Flash Development Team'
        WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Wrye Flash" "DisplayVersion" '${WB_FILEVERSION}'
        WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Wrye Flash" "NoModify" 1
        WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Wrye Flash" "NoRepair" 1
        CreateDirectory "$COMMONFILES\Wrye Flash"
        WriteUninstaller "$COMMONFILES\Wrye Flash\uninstall.exe"
    SectionEnd

    Section "Start Menu Shortcuts" Shortcuts_SM

        CreateDirectory "$SMPROGRAMS\Wrye Flash"
        CreateShortCut "$SMPROGRAMS\Wrye Flash\Uninstall.lnk" "$COMMONFILES\Wrye Flash\uninstall.exe" "" "$COMMONFILES\Wrye Flash\uninstall.exe" 0

        ${If} $CheckState_NV == ${BST_CHECKED}
            ${If} Path_NV != $Empty
                SetOutPath $Path_NV\Mopy
                ${If} $CheckState_NV_Py == ${BST_CHECKED}
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Oblivion.lnk" "$Path_NV\Mopy\Wrye Flash Launcher.pyw" "" "$Path_NV\Mopy\bash\images\bash_32.ico" 0
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Oblivion (Debug Log).lnk" "$Path_NV\Mopy\Wrye Flash Debug.bat" "" "$Path_NV\Mopy\bash\images\bash_32.ico" 0
                    ${If} $CheckState_NV_Exe == ${BST_CHECKED}
                        CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash (Standalone) - Oblivion.lnk" "$Path_NV\Mopy\Wrye Flash.exe"
                        CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash (Standalone) - Oblivion (Debug Log).lnk" "$Path_NV\Mopy\Wrye Flash.exe" "-d"
                    ${EndIf}
                ${ElseIf} $CheckState_NV_Exe == ${BST_CHECKED}
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Oblivion.lnk" "$Path_NV\Mopy\Wrye Flash.exe"
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Oblivion (Debug Log).lnk" "$Path_NV\Mopy\Wrye Flash.exe" "-d"
                ${EndIf}
            ${EndIf}
        ${EndIf}
    SectionEnd

;-------------------------------- Custom Uninstallation Pages and their Functions:
    Function un.PAGE_SELECT_GAMES
        !insertmacro MUI_HEADER_TEXT $(PAGE_INSTALLLOCATIONS_TITLE) $(unPAGE_SELECT_GAMES_SUBTITLE)
        GetFunctionAddress $unFunction_Browse un.OnClick_Browse

        nsDialogs::Create 1018
            Pop $Dialog
        ${If} $Dialog == error
            Abort
            ${EndIf}

        ${NSD_CreateLabel} 0 0 100% 8u "Please select which game(s)/extra location(s) and version(s) to uninstall Wrye Flash from:"
        Pop $Label

        IntOp $0 0 + 9
        ${If} $Path_NV != $Empty
            ${NSD_CreateCheckBox} 0 $0u 100% 13u "&Oblivion"
                Pop $Check_NV
                ${NSD_SetState} $Check_NV $CheckState_NV
            IntOp $0 $0 + 13
            ${NSD_CreateDirRequest} 0 $0u 90% 13u "$Path_NV"
                Pop $PathDialogue_NV
            ${NSD_CreateBrowseButton} -10% $0u 5% 13u "..."
                Pop $Browse_NV
                nsDialogs::OnClick $Browse_NV $Function_Browse
            IntOp $0 $0 + 13
        ${EndIf}
        ;${NSD_CreateCheckBox} 0 $0u 100% 13u "Uninstall userfiles/Bash data."
        ;    Pop $Check_RemoveUserFiles
        ;    ${NSD_SetState} $Check_RemoveUserFiles ${BST_CHECKED}
        nsDialogs::Show
    FunctionEnd

    Function un.PAGE_SELECT_GAMES_Leave
        ${NSD_GetText} $PathDialogue_NV $Path_NV
        ${NSD_GetState} $Check_NV $CheckState_NV
    FunctionEnd

    Function un.OnClick_Browse
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


;-------------------------------- The Uninstallation Code:
    Section "Uninstall"
        ; Remove files and Directories - Directories are only deleted if empty.
        ${If} $CheckState_NV == ${BST_CHECKED}
            ${If} $Path_NV != $Empty
                DeleteRegValue HKLM "SOFTWARE\Wrye Flash" "FalloutNV Path"
                DeleteRegValue HKLM "SOFTWARE\Wrye Flash" "FalloutNV Python Version"
                DeleteRegValue HKLM "SOFTWARE\Wrye Flash" "FalloutNV Standalone Version"
                ;First delete OLD version files:
                Delete "$Path_NV\Data\Bash Patches\Bash_Groups.csv"
                ;Current files:
                Delete "$Path_NV\Data\Bash Patches\taglist.txt"
                RMDir  "$Path_NV\Data\Bash Patches"
                Delete "$Path_NV\Data\Docs\Bash Readme Template.html"
                Delete "$Path_NV\Data\Docs\Bash Readme Template.txt"
                Delete "$Path_NV\Data\Docs\Bashed Lists.html"
                Delete "$Path_NV\Data\Docs\Bashed Lists.txt"
                Delete "$Path_NV\Data\Docs\wtxt_sand_small.css"
                Delete "$Path_NV\Data\Docs\wtxt_teal.css"
                RMDir  "$Path_NV\Data\Docs"
                Delete "$Path_NV\Data\INI Tweaks\bInvalidateOlderFiles, ~Default.ini"
                Delete "$Path_NV\Data\INI Tweaks\bInvalidateOlderFiles, ~Enabled.ini"
                Delete "$Path_NV\Data\INI Tweaks\Border Regions, ~Enabled.ini"
                Delete "$Path_NV\Data\INI Tweaks\Border Regions, Disabled.ini"
                Delete "$Path_NV\Data\INI Tweaks\Fonts 1, ~Default.ini"
                Delete "$Path_NV\Data\INI Tweaks\Grass, Fade 4k-5k.ini"
                Delete "$Path_NV\Data\INI Tweaks\iConsoleTextXPos, ~Fixed.ini"
                Delete "$Path_NV\Data\INI Tweaks\iConsoleTextXPos, Default.ini"
                Delete "$Path_NV\Data\INI Tweaks\Mouse Acceleration, ~Fixed.ini"
                Delete "$Path_NV\Data\INI Tweaks\Mouse Acceleration, Default.ini"
                Delete "$Path_NV\Data\INI Tweaks\Refraction Shader, ~Enabled.ini"
                Delete "$Path_NV\Data\INI Tweaks\Refraction Shader, Disabled.ini"
                Delete "$Path_NV\Data\INI Tweaks\Save Backups, 1.ini"
                Delete "$Path_NV\Data\INI Tweaks\Save Backups, 2.ini"
                Delete "$Path_NV\Data\INI Tweaks\Save Backups, 3.ini"
                Delete "$Path_NV\Data\INI Tweaks\Save Backups, 5.ini"
                RMDir  "$Path_NV\Data\INI Tweaks"
                RMDir  "$Path_NV\Mopy\bash"
                Delete "$Path_NV\Mopy\bash\__init__.py"
                Delete "$Path_NV\Mopy\bash\balt.py"
                Delete "$Path_NV\Mopy\bash\bapi.py"
                Delete "$Path_NV\Mopy\bash\barb.py"
                Delete "$Path_NV\Mopy\bash\bash.py"
                Delete "$Path_NV\Mopy\bash\basher.py"
                Delete "$Path_NV\Mopy\bash\bashmon.py"
                Delete "$Path_NV\Mopy\bash\belt.py"
                Delete "$Path_NV\Mopy\bash\bish.py"
                Delete "$Path_NV\Mopy\bash\bolt.py"
                Delete "$Path_NV\Mopy\bash\bosh.py"
                Delete "$Path_NV\Mopy\bash\bush.py"
                Delete "$Path_NV\Mopy\bash\cint.py"
                Delete "$Path_NV\Mopy\bash\compiled"
                Delete "$Path_NV\Mopy\bash\compiled\7z.dll"
                Delete "$Path_NV\Mopy\bash\compiled\7z.exe"
                Delete "$Path_NV\Mopy\bash\compiled\7zUnicode.exe"
                Delete "$Path_NV\Mopy\bash\compiled\boss32.dll"
                Delete "$Path_NV\Mopy\bash\compiled\boss64.dll"
                Delete "$Path_NV\Mopy\bash\compiled\lzma.exe"
                Delete "$Path_NV\Mopy\bash\db"
                Delete "$Path_NV\Mopy\bash\db\FalloutNV_ids.pkl"
                Delete "$Path_NV\Mopy\bash\images"
                Delete "$Path_NV\Mopy\bash\images\3dsmax16.png"
                Delete "$Path_NV\Mopy\bash\images\3dsmax24.png"
                Delete "$Path_NV\Mopy\bash\images\3dsmax32.png"
                Delete "$Path_NV\Mopy\bash\images\abcamberaudioconverter16.png"
                Delete "$Path_NV\Mopy\bash\images\abcamberaudioconverter24.png"
                Delete "$Path_NV\Mopy\bash\images\abcamberaudioconverter32.png"
                Delete "$Path_NV\Mopy\bash\images\anifx16.png"
                Delete "$Path_NV\Mopy\bash\images\anifx24.png"
                Delete "$Path_NV\Mopy\bash\images\anifx32.png"
                Delete "$Path_NV\Mopy\bash\images\artofillusion16.png"
                Delete "$Path_NV\Mopy\bash\images\artofillusion24.png"
                Delete "$Path_NV\Mopy\bash\images\artofillusion32.png"
                Delete "$Path_NV\Mopy\bash\images\artweaver16.png"
                Delete "$Path_NV\Mopy\bash\images\artweaver24.png"
                Delete "$Path_NV\Mopy\bash\images\artweaver32.png"
                Delete "$Path_NV\Mopy\bash\images\audacity16.png"
                Delete "$Path_NV\Mopy\bash\images\audacity24.png"
                Delete "$Path_NV\Mopy\bash\images\audacity32.png"
                Delete "$Path_NV\Mopy\bash\images\autocad16.png"
                Delete "$Path_NV\Mopy\bash\images\autocad24.png"
                Delete "$Path_NV\Mopy\bash\images\autocad32.png"
                Delete "$Path_NV\Mopy\bash\images\bash_16.png"
                Delete "$Path_NV\Mopy\bash\images\bash_16_blue.png"
                Delete "$Path_NV\Mopy\bash\images\bash_24.png"
                Delete "$Path_NV\Mopy\bash\images\bash_24_blue.png"
                Delete "$Path_NV\Mopy\bash\images\bash_32.ico"
                Delete "$Path_NV\Mopy\bash\images\bash_32.png"
                Delete "$Path_NV\Mopy\bash\images\bash_32_2.png"
                Delete "$Path_NV\Mopy\bash\images\bash_32_blue.png"
                Delete "$Path_NV\Mopy\bash\images\bashmon16.png"
                Delete "$Path_NV\Mopy\bash\images\bashmon24.png"
                Delete "$Path_NV\Mopy\bash\images\bashmon32.png"
                Delete "$Path_NV\Mopy\bash\images\blender16.png"
                Delete "$Path_NV\Mopy\bash\images\blender24.png"
                Delete "$Path_NV\Mopy\bash\images\blender32.png"
                Delete "$Path_NV\Mopy\bash\images\boss16.png"
                Delete "$Path_NV\Mopy\bash\images\boss24.png"
                Delete "$Path_NV\Mopy\bash\images\boss32.png"
                Delete "$Path_NV\Mopy\bash\images\brick_edit16.png"
                Delete "$Path_NV\Mopy\bash\images\brick_edit24.png"
                Delete "$Path_NV\Mopy\bash\images\brick_edit32.png"
                Delete "$Path_NV\Mopy\bash\images\brick_error16.png"
                Delete "$Path_NV\Mopy\bash\images\brick_error24.png"
                Delete "$Path_NV\Mopy\bash\images\brick_error32.png"
                Delete "$Path_NV\Mopy\bash\images\brick_go16.png"
                Delete "$Path_NV\Mopy\bash\images\brick_go24.png"
                Delete "$Path_NV\Mopy\bash\images\brick_go32.png"
                Delete "$Path_NV\Mopy\bash\images\brick16.png"
                Delete "$Path_NV\Mopy\bash\images\brick24.png"
                Delete "$Path_NV\Mopy\bash\images\brick32.png"
                Delete "$Path_NV\Mopy\bash\images\bsacommander16.png"
                Delete "$Path_NV\Mopy\bash\images\bsacommander24.png"
                Delete "$Path_NV\Mopy\bash\images\bsacommander32.png"
                Delete "$Path_NV\Mopy\bash\images\cancel.png"
                Delete "$Path_NV\Mopy\bash\images\check.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_blue_imp.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_blue_inc.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_blue_off.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_blue_on.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_blue_on_24.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_blue_on_32.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_green_imp.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_green_inc.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_green_inc_wiz.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_green_off.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_green_off_24.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_green_off_32.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_green_off_wiz.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_green_on.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_green_on_24.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_green_on_32.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_grey_inc.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_grey_off.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_grey_on.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_orange_imp.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_orange_inc.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_orange_inc_wiz.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_orange_off.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_orange_off_wiz.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_orange_on.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_purple_imp.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_purple_inc.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_purple_off.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_purple_on.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_red_imp.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_red_inc.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_red_inc_wiz.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_red_off.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_red_off_24.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_red_off_32.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_red_off_wiz.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_red_on.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_red_x.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_red_x_24.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_red_x_32.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_white_inc.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_white_inc_wiz.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_white_off.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_white_off_wiz.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_white_on.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_yellow_imp.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_yellow_inc.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_yellow_inc_wiz.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_yellow_off.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_yellow_off_wiz.png"
                Delete "$Path_NV\Mopy\bash\images\checkbox_yellow_on.png"
                Delete "$Path_NV\Mopy\bash\images\crazybump16.png"
                Delete "$Path_NV\Mopy\bash\images\crazybump24.png"
                Delete "$Path_NV\Mopy\bash\images\crazybump32.png"
                Delete "$Path_NV\Mopy\bash\images\database_connect16.png"
                Delete "$Path_NV\Mopy\bash\images\database_connect24.png"
                Delete "$Path_NV\Mopy\bash\images\database_connect32.png"
                Delete "$Path_NV\Mopy\bash\images\ddsconverter16.png"
                Delete "$Path_NV\Mopy\bash\images\ddsconverter24.png"
                Delete "$Path_NV\Mopy\bash\images\ddsconverter32.png"
                Delete "$Path_NV\Mopy\bash\images\deeppaint16.png"
                Delete "$Path_NV\Mopy\bash\images\deeppaint24.png"
                Delete "$Path_NV\Mopy\bash\images\deeppaint32.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_green_inc.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_green_inc_wiz.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_green_off.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_green_off_wiz.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_grey_inc.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_grey_off.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_orange_inc.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_orange_inc_wiz.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_orange_off.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_orange_off_wiz.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_red_inc.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_red_inc_wiz.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_red_off.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_red_off_wiz.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_white_inc.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_white_off.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_white_off_wiz.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_yellow_inc.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_yellow_inc_wiz.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_yellow_off.png"
                Delete "$Path_NV\Mopy\bash\images\diamond_yellow_off_wiz.png"
                Delete "$Path_NV\Mopy\bash\images\doc_on.png"
                Delete "$Path_NV\Mopy\bash\images\docbrowser16.png"
                Delete "$Path_NV\Mopy\bash\images\docbrowser24.png"
                Delete "$Path_NV\Mopy\bash\images\docbrowser32.png"
                Delete "$Path_NV\Mopy\bash\images\dogwaffle16.png"
                Delete "$Path_NV\Mopy\bash\images\dogwaffle24.png"
                Delete "$Path_NV\Mopy\bash\images\dogwaffle32.png"
                Delete "$Path_NV\Mopy\bash\images\dos.png"
                Delete "$Path_NV\Mopy\bash\images\eggtranslator16.png"
                Delete "$Path_NV\Mopy\bash\images\eggtranslator24.png"
                Delete "$Path_NV\Mopy\bash\images\eggtranslator32.png"
                Delete "$Path_NV\Mopy\bash\images\error.jpg"
                Delete "$Path_NV\Mopy\bash\images\evgaprecision16.png"
                Delete "$Path_NV\Mopy\bash\images\evgaprecision24.png"
                Delete "$Path_NV\Mopy\bash\images\evgaprecision32.png"
                Delete "$Path_NV\Mopy\bash\images\exclamation.png"
                Delete "$Path_NV\Mopy\bash\images\fallout316.png"
                Delete "$Path_NV\Mopy\bash\images\fallout324.png"
                Delete "$Path_NV\Mopy\bash\images\fallout332.png"
                Delete "$Path_NV\Mopy\bash\images\falloutnv16.png"
                Delete "$Path_NV\Mopy\bash\images\falloutnv24.png"
                Delete "$Path_NV\Mopy\bash\images\falloutnv32.png"
                Delete "$Path_NV\Mopy\bash\images\faststoneimageviewer16.png"
                Delete "$Path_NV\Mopy\bash\images\faststoneimageviewer24.png"
                Delete "$Path_NV\Mopy\bash\images\faststoneimageviewer32.png"
                Delete "$Path_NV\Mopy\bash\images\filezilla16.png"
                Delete "$Path_NV\Mopy\bash\images\filezilla24.png"
                Delete "$Path_NV\Mopy\bash\images\filezilla32.png"
                Delete "$Path_NV\Mopy\bash\images\finish.png"
                Delete "$Path_NV\Mopy\bash\images\fnv4gb16.png"
                Delete "$Path_NV\Mopy\bash\images\fnv4gb24.png"
                Delete "$Path_NV\Mopy\bash\images\fnv4gb32.png"
                Delete "$Path_NV\Mopy\bash\images\fnvedit16.png"
                Delete "$Path_NV\Mopy\bash\images\fnvedit24.png"
                Delete "$Path_NV\Mopy\bash\images\fnvedit32.png"
                Delete "$Path_NV\Mopy\bash\images\fnvmasterrestore16.png"
                Delete "$Path_NV\Mopy\bash\images\fnvmasterrestore24.png"
                Delete "$Path_NV\Mopy\bash\images\fnvmasterrestore32.png"
                Delete "$Path_NV\Mopy\bash\images\fnvmasterupdate16.png"
                Delete "$Path_NV\Mopy\bash\images\fnvmasterupdate24.png"
                Delete "$Path_NV\Mopy\bash\images\fnvmasterupdate32.png"
                Delete "$Path_NV\Mopy\bash\images\fo3edit16.png"
                Delete "$Path_NV\Mopy\bash\images\fo3edit24.png"
                Delete "$Path_NV\Mopy\bash\images\fo3edit32.png"
                Delete "$Path_NV\Mopy\bash\images\fo3masterrestore16.png"
                Delete "$Path_NV\Mopy\bash\images\fo3masterrestore24.png"
                Delete "$Path_NV\Mopy\bash\images\fo3masterrestore32.png"
                Delete "$Path_NV\Mopy\bash\images\fo3masterupdate16.png"
                Delete "$Path_NV\Mopy\bash\images\fo3masterupdate24.png"
                Delete "$Path_NV\Mopy\bash\images\fo3masterupdate32.png"
                Delete "$Path_NV\Mopy\bash\images\fomm16.png"
                Delete "$Path_NV\Mopy\bash\images\fomm24.png"
                Delete "$Path_NV\Mopy\bash\images\fomm32.png"
                Delete "$Path_NV\Mopy\bash\images\fraps16.png"
                Delete "$Path_NV\Mopy\bash\images\fraps24.png"
                Delete "$Path_NV\Mopy\bash\images\fraps32.png"
                Delete "$Path_NV\Mopy\bash\images\freemind16.png"
                Delete "$Path_NV\Mopy\bash\images\freemind24.png"
                Delete "$Path_NV\Mopy\bash\images\freemind32.png"
                Delete "$Path_NV\Mopy\bash\images\freemind8.1custom_32.png"
                Delete "$Path_NV\Mopy\bash\images\freeplane16.png"
                Delete "$Path_NV\Mopy\bash\images\freeplane24.png"
                Delete "$Path_NV\Mopy\bash\images\freeplane32.png"
                Delete "$Path_NV\Mopy\bash\images\geck16.png"
                Delete "$Path_NV\Mopy\bash\images\geck24.png"
                Delete "$Path_NV\Mopy\bash\images\geck32.png"
                Delete "$Path_NV\Mopy\bash\images\genetica16.png"
                Delete "$Path_NV\Mopy\bash\images\genetica24.png"
                Delete "$Path_NV\Mopy\bash\images\genetica32.png"
                Delete "$Path_NV\Mopy\bash\images\geneticaviewer16.png"
                Delete "$Path_NV\Mopy\bash\images\geneticaviewer24.png"
                Delete "$Path_NV\Mopy\bash\images\geneticaviewer32.png"
                Delete "$Path_NV\Mopy\bash\images\gimp16.png"
                Delete "$Path_NV\Mopy\bash\images\gimp24.png"
                Delete "$Path_NV\Mopy\bash\images\gimp32.png"
                Delete "$Path_NV\Mopy\bash\images\gimpshop16.png"
                Delete "$Path_NV\Mopy\bash\images\gimpshop24.png"
                Delete "$Path_NV\Mopy\bash\images\gimpshop32.png"
                Delete "$Path_NV\Mopy\bash\images\gmax16.png"
                Delete "$Path_NV\Mopy\bash\images\gmax24.png"
                Delete "$Path_NV\Mopy\bash\images\gmax32.png"
                Delete "$Path_NV\Mopy\bash\images\group_gear16.png"
                Delete "$Path_NV\Mopy\bash\images\group_gear24.png"
                Delete "$Path_NV\Mopy\bash\images\group_gear32.png"
                Delete "$Path_NV\Mopy\bash\images\help16.png"
                Delete "$Path_NV\Mopy\bash\images\help24.png"
                Delete "$Path_NV\Mopy\bash\images\help32.png"
                Delete "$Path_NV\Mopy\bash\images\icofx16.png"
                Delete "$Path_NV\Mopy\bash\images\icofx24.png"
                Delete "$Path_NV\Mopy\bash\images\icofx32.png"
                Delete "$Path_NV\Mopy\bash\images\ini-all natural.png"
                Delete "$Path_NV\Mopy\bash\images\ini-oblivion.png"
                Delete "$Path_NV\Mopy\bash\images\inkscape16.png"
                Delete "$Path_NV\Mopy\bash\images\inkscape24.png"
                Delete "$Path_NV\Mopy\bash\images\inkscape32.png"
                Delete "$Path_NV\Mopy\bash\images\insanity'sreadmegenerator16.png"
                Delete "$Path_NV\Mopy\bash\images\insanity'sreadmegenerator24.png"
                Delete "$Path_NV\Mopy\bash\images\insanity'sreadmegenerator32.png"
                Delete "$Path_NV\Mopy\bash\images\insanity'srng16.png"
                Delete "$Path_NV\Mopy\bash\images\insanity'srng24.png"
                Delete "$Path_NV\Mopy\bash\images\insanity'srng32.png"
                Delete "$Path_NV\Mopy\bash\images\interactivemapofcyrodiil16.png"
                Delete "$Path_NV\Mopy\bash\images\interactivemapofcyrodiil24.png"
                Delete "$Path_NV\Mopy\bash\images\interactivemapofcyrodiil32.png"
                Delete "$Path_NV\Mopy\bash\images\irfanview16.png"
                Delete "$Path_NV\Mopy\bash\images\irfanview24.png"
                Delete "$Path_NV\Mopy\bash\images\irfanview32.png"
                Delete "$Path_NV\Mopy\bash\images\isobl16.png"
                Delete "$Path_NV\Mopy\bash\images\isobl24.png"
                Delete "$Path_NV\Mopy\bash\images\isobl32.png"
                Delete "$Path_NV\Mopy\bash\images\logitechkeyboard16.png"
                Delete "$Path_NV\Mopy\bash\images\logitechkeyboard24.png"
                Delete "$Path_NV\Mopy\bash\images\logitechkeyboard32.png"
                Delete "$Path_NV\Mopy\bash\images\mapzone16.png"
                Delete "$Path_NV\Mopy\bash\images\mapzone24.png"
                Delete "$Path_NV\Mopy\bash\images\mapzone32.png"
                Delete "$Path_NV\Mopy\bash\images\masterrestore16.png"
                Delete "$Path_NV\Mopy\bash\images\masterrestore24.png"
                Delete "$Path_NV\Mopy\bash\images\masterrestore32.png"
                Delete "$Path_NV\Mopy\bash\images\masterupdate16.png"
                Delete "$Path_NV\Mopy\bash\images\masterupdate24.png"
                Delete "$Path_NV\Mopy\bash\images\masterupdate32.png"
                Delete "$Path_NV\Mopy\bash\images\maya16.png"
                Delete "$Path_NV\Mopy\bash\images\maya24.png"
                Delete "$Path_NV\Mopy\bash\images\maya32.png"
                Delete "$Path_NV\Mopy\bash\images\mcowavi32.png"
                Delete "$Path_NV\Mopy\bash\images\mediamonkey16.png"
                Delete "$Path_NV\Mopy\bash\images\mediamonkey24.png"
                Delete "$Path_NV\Mopy\bash\images\mediamonkey32.png"
                Delete "$Path_NV\Mopy\bash\images\milkshape3d16.png"
                Delete "$Path_NV\Mopy\bash\images\milkshape3d24.png"
                Delete "$Path_NV\Mopy\bash\images\milkshape3d32.png"
                Delete "$Path_NV\Mopy\bash\images\modchecker16.png"
                Delete "$Path_NV\Mopy\bash\images\modchecker24.png"
                Delete "$Path_NV\Mopy\bash\images\modchecker32.png"
                Delete "$Path_NV\Mopy\bash\images\modlistgenerator16.png"
                Delete "$Path_NV\Mopy\bash\images\modlistgenerator24.png"
                Delete "$Path_NV\Mopy\bash\images\modlistgenerator32.png"
                Delete "$Path_NV\Mopy\bash\images\mudbox16.png"
                Delete "$Path_NV\Mopy\bash\images\mudbox24.png"
                Delete "$Path_NV\Mopy\bash\images\mudbox32.png"
                Delete "$Path_NV\Mopy\bash\images\mypaint16.png"
                Delete "$Path_NV\Mopy\bash\images\mypaint24.png"
                Delete "$Path_NV\Mopy\bash\images\mypaint32.png"
                Delete "$Path_NV\Mopy\bash\images\nifskope16.png"
                Delete "$Path_NV\Mopy\bash\images\nifskope24.png"
                Delete "$Path_NV\Mopy\bash\images\nifskope32.png"
                Delete "$Path_NV\Mopy\bash\images\notepad++16.png"
                Delete "$Path_NV\Mopy\bash\images\notepad++24.png"
                Delete "$Path_NV\Mopy\bash\images\notepad++32.png"
                Delete "$Path_NV\Mopy\bash\images\nvidiamelody16.png"
                Delete "$Path_NV\Mopy\bash\images\nvidiamelody24.png"
                Delete "$Path_NV\Mopy\bash\images\nvidiamelody32.png"
                Delete "$Path_NV\Mopy\bash\images\oblivion16.png"
                Delete "$Path_NV\Mopy\bash\images\oblivion24.png"
                Delete "$Path_NV\Mopy\bash\images\oblivion32.png"
                Delete "$Path_NV\Mopy\bash\images\oblivionbookcreator16.png"
                Delete "$Path_NV\Mopy\bash\images\oblivionbookcreator24.png"
                Delete "$Path_NV\Mopy\bash\images\oblivionbookcreator32.png"
                Delete "$Path_NV\Mopy\bash\images\oblivionfaceexchangerlite16.png"
                Delete "$Path_NV\Mopy\bash\images\oblivionfaceexchangerlite24.png"
                Delete "$Path_NV\Mopy\bash\images\oblivionfaceexchangerlite32.png"
                Delete "$Path_NV\Mopy\bash\images\obmm16.png"
                Delete "$Path_NV\Mopy\bash\images\obmm24.png"
                Delete "$Path_NV\Mopy\bash\images\obmm32.png"
                Delete "$Path_NV\Mopy\bash\images\page_find16.png"
                Delete "$Path_NV\Mopy\bash\images\page_find24.png"
                Delete "$Path_NV\Mopy\bash\images\page_find32.png"
                Delete "$Path_NV\Mopy\bash\images\paint.net16.png"
                Delete "$Path_NV\Mopy\bash\images\paint.net24.png"
                Delete "$Path_NV\Mopy\bash\images\paint.net32.png"
                Delete "$Path_NV\Mopy\bash\images\paintshopprox316.png"
                Delete "$Path_NV\Mopy\bash\images\paintshopprox324.png"
                Delete "$Path_NV\Mopy\bash\images\paintshopprox332.png"
                Delete "$Path_NV\Mopy\bash\images\photobie16.png"
                Delete "$Path_NV\Mopy\bash\images\photobie24.png"
                Delete "$Path_NV\Mopy\bash\images\photobie32.png"
                Delete "$Path_NV\Mopy\bash\images\photofiltre16.png"
                Delete "$Path_NV\Mopy\bash\images\photofiltre24.png"
                Delete "$Path_NV\Mopy\bash\images\photofiltre32.png"
                Delete "$Path_NV\Mopy\bash\images\photoscape16.png"
                Delete "$Path_NV\Mopy\bash\images\photoscape24.png"
                Delete "$Path_NV\Mopy\bash\images\photoscape32.png"
                Delete "$Path_NV\Mopy\bash\images\photoseam16.png"
                Delete "$Path_NV\Mopy\bash\images\photoseam24.png"
                Delete "$Path_NV\Mopy\bash\images\photoseam32.png"
                Delete "$Path_NV\Mopy\bash\images\photoshop16.png"
                Delete "$Path_NV\Mopy\bash\images\photoshop24.png"
                Delete "$Path_NV\Mopy\bash\images\photoshop32.png"
                Delete "$Path_NV\Mopy\bash\images\pixelstudiopro16.png"
                Delete "$Path_NV\Mopy\bash\images\pixelstudiopro24.png"
                Delete "$Path_NV\Mopy\bash\images\pixelstudiopro32.png"
                Delete "$Path_NV\Mopy\bash\images\pixia16.png"
                Delete "$Path_NV\Mopy\bash\images\pixia24.png"
                Delete "$Path_NV\Mopy\bash\images\pixia32.png"
                Delete "$Path_NV\Mopy\bash\images\radvideotools16.png"
                Delete "$Path_NV\Mopy\bash\images\radvideotools24.png"
                Delete "$Path_NV\Mopy\bash\images\radvideotools32.png"
                Delete "$Path_NV\Mopy\bash\images\randomnpc16.png"
                Delete "$Path_NV\Mopy\bash\images\randomnpc24.png"
                Delete "$Path_NV\Mopy\bash\images\randomnpc32.png"
                Delete "$Path_NV\Mopy\bash\images\red_x.png"
                Delete "$Path_NV\Mopy\bash\images\save_off.png"
                Delete "$Path_NV\Mopy\bash\images\save_on.png"
                Delete "$Path_NV\Mopy\bash\images\sculptris16.png"
                Delete "$Path_NV\Mopy\bash\images\sculptris24.png"
                Delete "$Path_NV\Mopy\bash\images\sculptris32.png"
                Delete "$Path_NV\Mopy\bash\images\selectmany.jpg"
                Delete "$Path_NV\Mopy\bash\images\selectone.jpg"
                Delete "$Path_NV\Mopy\bash\images\softimagemodtool16.png"
                Delete "$Path_NV\Mopy\bash\images\softimagemodtool24.png"
                Delete "$Path_NV\Mopy\bash\images\softimagemodtool32.png"
                Delete "$Path_NV\Mopy\bash\images\speedtree16.png"
                Delete "$Path_NV\Mopy\bash\images\speedtree24.png"
                Delete "$Path_NV\Mopy\bash\images\speedtree32.png"
                Delete "$Path_NV\Mopy\bash\images\steam16.png"
                Delete "$Path_NV\Mopy\bash\images\steam24.png"
                Delete "$Path_NV\Mopy\bash\images\steam32.png"
                Delete "$Path_NV\Mopy\bash\images\switch16.png"
                Delete "$Path_NV\Mopy\bash\images\switch24.png"
                Delete "$Path_NV\Mopy\bash\images\switch32.png"
                Delete "$Path_NV\Mopy\bash\images\table_error16.png"
                Delete "$Path_NV\Mopy\bash\images\table_error24.png"
                Delete "$Path_NV\Mopy\bash\images\table_error32.png"
                Delete "$Path_NV\Mopy\bash\images\tabula16.png"
                Delete "$Path_NV\Mopy\bash\images\tabula24.png"
                Delete "$Path_NV\Mopy\bash\images\tabula32.png"
                Delete "$Path_NV\Mopy\bash\images\tes4edit16.png"
                Delete "$Path_NV\Mopy\bash\images\tes4edit24.png"
                Delete "$Path_NV\Mopy\bash\images\tes4edit32.png"
                Delete "$Path_NV\Mopy\bash\images\tes4files16.png"
                Delete "$Path_NV\Mopy\bash\images\tes4files24.png"
                Delete "$Path_NV\Mopy\bash\images\tes4files32.png"
                Delete "$Path_NV\Mopy\bash\images\tes4gecko16.png"
                Delete "$Path_NV\Mopy\bash\images\tes4gecko24.png"
                Delete "$Path_NV\Mopy\bash\images\tes4gecko32.png"
                Delete "$Path_NV\Mopy\bash\images\tes4lodgen16.png"
                Delete "$Path_NV\Mopy\bash\images\tes4lodgen24.png"
                Delete "$Path_NV\Mopy\bash\images\tes4lodgen32.png"
                Delete "$Path_NV\Mopy\bash\images\tes4trans16.png"
                Delete "$Path_NV\Mopy\bash\images\tes4trans24.png"
                Delete "$Path_NV\Mopy\bash\images\tes4trans32.png"
                Delete "$Path_NV\Mopy\bash\images\tes4view16.png"
                Delete "$Path_NV\Mopy\bash\images\tes4view24.png"
                Delete "$Path_NV\Mopy\bash\images\tes4view32.png"
                Delete "$Path_NV\Mopy\bash\images\tescs16.png"
                Delete "$Path_NV\Mopy\bash\images\tescs24.png"
                Delete "$Path_NV\Mopy\bash\images\tescs32.png"
                Delete "$Path_NV\Mopy\bash\images\texturemaker16.png"
                Delete "$Path_NV\Mopy\bash\images\texturemaker24.png"
                Delete "$Path_NV\Mopy\bash\images\texturemaker32.png"
                Delete "$Path_NV\Mopy\bash\images\treed16.png"
                Delete "$Path_NV\Mopy\bash\images\treed24.png"
                Delete "$Path_NV\Mopy\bash\images\treed32.png"
                Delete "$Path_NV\Mopy\bash\images\twistedbrush16.png"
                Delete "$Path_NV\Mopy\bash\images\twistedbrush24.png"
                Delete "$Path_NV\Mopy\bash\images\twistedbrush32.png"
                Delete "$Path_NV\Mopy\bash\images\versions.png"
                Delete "$Path_NV\Mopy\bash\images\wings3d16.png"
                Delete "$Path_NV\Mopy\bash\images\wings3d24.png"
                Delete "$Path_NV\Mopy\bash\images\wings3d32.png"
                Delete "$Path_NV\Mopy\bash\images\winmerge16.png"
                Delete "$Path_NV\Mopy\bash\images\winmerge24.png"
                Delete "$Path_NV\Mopy\bash\images\winmerge32.png"
                Delete "$Path_NV\Mopy\bash\images\winsnap16.png"
                Delete "$Path_NV\Mopy\bash\images\winsnap24.png"
                Delete "$Path_NV\Mopy\bash\images\winsnap32.png"
                Delete "$Path_NV\Mopy\bash\images\wizard.png"
                Delete "$Path_NV\Mopy\bash\images\wizardscripthighlighter.jpg"
                Delete "$Path_NV\Mopy\bash\images\wrye_monkey_87.jpg"
                Delete "$Path_NV\Mopy\bash\images\wryebash_01.png"
                Delete "$Path_NV\Mopy\bash\images\wryebash_02.png"
                Delete "$Path_NV\Mopy\bash\images\wryebash_03.png"
                Delete "$Path_NV\Mopy\bash\images\wryebash_04.png"
                Delete "$Path_NV\Mopy\bash\images\wryebash_05.png"
                Delete "$Path_NV\Mopy\bash\images\wryebash_06.png"
                Delete "$Path_NV\Mopy\bash\images\wryebash_07.png"
                Delete "$Path_NV\Mopy\bash\images\wryebash_08.png"
                Delete "$Path_NV\Mopy\bash\images\wryebash_docbrowser.png"
                Delete "$Path_NV\Mopy\bash\images\wryebash_peopletab.png"
                Delete "$Path_NV\Mopy\bash\images\wryemonkey16.jpg"
                Delete "$Path_NV\Mopy\bash\images\wtv16.png"
                Delete "$Path_NV\Mopy\bash\images\wtv24.png"
                Delete "$Path_NV\Mopy\bash\images\wtv32.png"
                Delete "$Path_NV\Mopy\bash\images\x.png"
                Delete "$Path_NV\Mopy\bash\images\xnormal16.png"
                Delete "$Path_NV\Mopy\bash\images\xnormal24.png"
                Delete "$Path_NV\Mopy\bash\images\xnormal32.png"
                Delete "$Path_NV\Mopy\bash\images\xnview16.png"
                Delete "$Path_NV\Mopy\bash\images\xnview24.png"
                Delete "$Path_NV\Mopy\bash\images\xnview32.png"
                Delete "$Path_NV\Mopy\bash\images\zoom_on.png"
                Delete "$Path_NV\Mopy\bash\l10n"
                Delete "$Path_NV\Mopy\bash\l10n\de.txt"
                Delete "$Path_NV\Mopy\bash\l10n\Italian.txt"
                Delete "$Path_NV\Mopy\bash\l10n\Japanese.txt"
                Delete "$Path_NV\Mopy\bash\l10n\pt_opt.txt"
                Delete "$Path_NV\Mopy\bash\l10n\Russian.txt"
                Delete "$Path_NV\Mopy\bash\ScriptParser.py"
                Delete "$Path_NV\Mopy\bash_default.ini"
                Delete "$Path_NV\Mopy\license.txt"
                Delete "$Path_NV\Mopy\templates"
                Delete "$Path_NV\Mopy\templates\Bashed Patch, 0.esp"
                Delete "$Path_NV\Mopy\templates\Blank.esp"
                Delete "$Path_NV\Mopy\Wizard Images"
                Delete "$Path_NV\Mopy\Wizard Images\EnglishUSA.jpg"
                Delete "$Path_NV\Mopy\Wizard Images\French.jpg"
                Delete "$Path_NV\Mopy\Wizard Images\German.jpg"
                Delete "$Path_NV\Mopy\Wizard Images\Italian.jpg"
                Delete "$Path_NV\Mopy\Wizard Images\No.jpg"
                Delete "$Path_NV\Mopy\Wizard Images\Yes.jpg"
                Delete "$Path_NV\Mopy\WizardDocs.txt"
                Delete "$Path_NV\Mopy\wizards.html"
                Delete "$Path_NV\Mopy\wizards.txt"
                Delete "$Path_NV\Mopy\Wrye Bash Debug.bat"
                Delete "$Path_NV\Mopy\Wrye Bash Launcher.pyw"
                Delete "$Path_NV\Mopy\Wrye Bash.html"
                Delete "$Path_NV\Mopy\Wrye Bash.txt"
                Delete "$Path_NV\Mopy\Wrye Flash.txt"
                RMDir  "$Path_NV\Mopy"
                Delete "$SMPROGRAMS\Wrye Flash\*oblivion*"
            ${EndIf}
        ${EndIf}

        ;If it is a complete uninstall remove the shared data:
        ReadRegStr $Path_NV HKLM "Software\Wrye Flash" "FalloutNV Path"
        ${If} $Path_NV == $Empty
            DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Wrye Flash"
            ReadRegStr $0 HKLM "Software\Wrye Flash" "Installer Path"
            DeleteRegKey HKLM "SOFTWARE\Wrye Flash"
            ;Delete stupid Windows created registry keys:
            DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\App Management\ARPCache\Wrye Flash"
            DeleteRegValue HKCR "Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "$COMMONFILES\Wrye Flash\Uninstall.exe"
            DeleteRegValue HKCU "Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "$COMMONFILES\Wrye Flash\Uninstall.exe"
            DeleteRegValue HKCU "Software\Microsoft\Windows\ShellNoRoam\MuiCache" "$COMMONFILES\Wrye Flash\Uninstall.exe"
            DeleteRegValue HKCR "Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "$0"
            DeleteRegValue HKCU "Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "$0"
            DeleteRegValue HKCU "Software\Microsoft\Windows\ShellNoRoam\MuiCache" "$0"
            Delete "$SMPROGRAMS\Wrye Flash\*.*"
            RMDir "$SMPROGRAMS\Wrye Flash"
            Delete "$COMMONFILES\Wrye Flash\*.*"
            RMDir "$COMMONFILES\Wrye Flash"
        ${EndIf}
        SectionEnd

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
