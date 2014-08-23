; install.nsi
; Installation script for Wrye Flash NSIS installer.


;-------------------------------- The Installation Sections:

    Section "Prerequisites" Prereq
        SectionIn RO

        ClearErrors
        
        ; Python version requires Python, wxPython, Python Comtypes and PyWin32.
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
                DetailPrint "Python 2.7.8 - Downloading..."
                inetc::get /NOCANCEL /RESUME "" "https://www.python.org/ftp/python/2.7.8/python-2.7.8.msi" "$TEMP\PythonInstallers\python-2.7.8.msi"
                Pop $R0
                ${If} $R0 == "OK"
                    DetailPrint "Python 2.7.8 - Installing..."
                    Sleep 2000
                    HideWindow
                    ExecWait '"msiexec" /i "$TEMP\PythonInstallers\python-2.7.8.msi"'
                    BringToFront
                    DetailPrint "Python 2.7.8 - Installed."
                ${Else}
                    DetailPrint "Python 2.7.8 - Download Failed!"
                    MessageBox MB_OK "Python download failed, please try running installer again or manually downloading."
                    Abort
                ${EndIf}
            ${Else}
                DetailPrint "Python 2.7 is already installed; skipping!"
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
                NSISdl::download http://downloads.sourceforge.net/project/comtypes/comtypes/0.6.2/comtypes-0.6.2.win32.exe "$TEMP\PythonInstallers\comtypes.exe"
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
                NSISdl::download http://downloads.sourceforge.net/project/pywin32/pywin32/Build%20218/pywin32-218.win32-py2.7.exe "$TEMP\PythonInstallers\pywin32.exe"
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
                !insertmacro InstallBashFiles "FalloutNV" "FalloutNV" "$Path_NV" $Reg_Value_NV_Py $Reg_Value_NV_Exe "FalloutNV Path" $CheckState_NV_Py $CheckState_NV_Exe true
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Nehrim_Remove == ${BST_CHECKED}
            ; Install resources:
            ${If} Path_Nehrim_Remove != $Empty
                !insertmacro InstallBashFiles "Nehrim" "FalloutNV" "$Path_Nehrim_Remove" $Reg_Value_Nehrim_Py_Remove $Reg_Value_Nehrim_Exe_Remove "Nehrim Path" $CheckState_Nehrim_Py_Remove $CheckState_Nehrim_Exe_Remove true
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Skyrim_Remove == ${BST_CHECKED}
            ; Install resources:
            ${If} Path_Skyrim_Remove != $Empty
                !insertmacro InstallBashFiles "Skyrim" "Skyrim" "$Path_Skyrim_Remove" $Reg_Value_Skyrim_Py_Remove $Reg_Value_Skyrim_Exe_Remove "Skyrim Path" $CheckState_Skyrim_Py_Remove $CheckState_Skyrim_Exe_Remove false
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Ex1_Remove == ${BST_CHECKED}
            ; Install resources:
            ${If} Path_Ex1_Remove != $Empty
                !insertmacro InstallBashFiles "Extra Path 1" "" $Path_Ex1_Remove $Reg_Value_Ex1_Py_Remove $Reg_Value_Ex1_Exe_Remove "Extra Path 1" $CheckState_Ex1_Py_Remove $CheckState_Ex1_Exe_Remove false
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Ex2_Remove == ${BST_CHECKED}
            ; Install resources:
            ${If} Path_Ex2_Remove != $Empty
                !insertmacro InstallBashFiles "Extra Path 2" "" $Path_Ex2_Remove $Reg_Value_Ex2_Py_Remove $Reg_Value_Ex2_Exe_Remove "Extra Path 2" $CheckState_Ex2_Py_Remove $CheckState_Ex2_Exe_Remove false
            ${EndIf}
        ${EndIf}
        ; Write the uninstall keys for Windows
        SetOutPath "$COMMONFILES\Wrye Flash"
        WriteRegStr HKLM "Software\Wrye Flash" "Installer Path" "$EXEPATH"
        WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Wrye Flash" "DisplayName" "Wrye Flash"
        WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Wrye Flash" "UninstallString" '"$COMMONFILES\Wrye Flash\uninstall.exe"'
        WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Wrye Flash" "URLInfoAbout" 'http://www.nexusmods.com/newvegas/mods/35003'
        WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Wrye Flash" "HelpLink" 'http://forums.bethsoft.com/topic/1376871-rel-wrye-bash/'
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
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - FalloutNV.lnk" "$Path_NV\Mopy\Wrye Flash Launcher.pyw" "" "$Path_NV\Mopy\bash\images\bash_32.ico" 0
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - FalloutNV (Debug Log).lnk" "$Path_NV\Mopy\Wrye Flash Debug.bat" "" "$Path_NV\Mopy\bash\images\bash_32.ico" 0
                    ${If} $CheckState_NV_Exe == ${BST_CHECKED}
                        CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash (Standalone) - FalloutNV.lnk" "$Path_NV\Mopy\Wrye Flash.exe"
                        CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash (Standalone) - FalloutNV (Debug Log).lnk" "$Path_NV\Mopy\Wrye Flash.exe" "-d"
                    ${EndIf}
                ${ElseIf} $CheckState_NV_Exe == ${BST_CHECKED}
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - FalloutNV.lnk" "$Path_NV\Mopy\Wrye Flash.exe"
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - FalloutNV (Debug Log).lnk" "$Path_NV\Mopy\Wrye Flash.exe" "-d"
                ${EndIf}
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Nehrim_Remove == ${BST_CHECKED}
            ${If} Path_Nehrim_Remove != $Empty
                SetOutPath $Path_Nehrim_Remove\Mopy
                ${If} $CheckState_Nehrim_Py_Remove == ${BST_CHECKED}
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Nehrim.lnk" "$Path_Nehrim_Remove\Mopy\Wrye Flash Launcher.pyw" "" "$Path_Nehrim_Remove\Mopy\bash\images\bash_32.ico" 0
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Nehrim (Debug Log).lnk" "$Path_Nehrim_Remove\Mopy\Wrye Flash Debug.bat" "" "$Path_Nehrim_Remove\Mopy\bash\images\bash_32.ico" 0
                    ${If} $CheckState_Nehrim_Exe_Remove == ${BST_CHECKED}
                        CreateShortCut "$SMPROGRAMS\Wyre Bash\Wrye Flash (Standalone) - Nehrim.lnk" "$Path_Nehrim_Remove\Mopy\Wrye Flash.exe"
                        CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash (Standalone) - Nehrim (Debug Log).lnk" "$Path_Nehrim_Remove\Mopy\Wrye Flash.exe" "-d"
                    ${EndIf}
                ${ElseIf} $CheckState_Nehrim_Exe_Remove == ${BST_CHECKED}
                    CreateShortCut "$SMPROGRAMS\Wyre Bash\Wrye Flash - Nehrim.lnk" "$Path_Nehrim_Remove\Mopy\Wrye Flash.exe"
                    CreateShortCut "$SMPROGRAMS\Wyre Bash\Wrye Flash - Nehrim (Debug Log).lnk" "$Path_Nehrim_Remove\Mopy\Wrye Flash.exe" "-d"
                ${EndIf}
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Skyrim_Remove == ${BST_CHECKED}
            ${If} Path_Skyrim_Remove != $Empty
                SetOutPath $Path_Skyrim_Remove\Mopy
                ${If} $CheckState_Skyrim_Py_Remove == ${BST_CHECKED}
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Skyrim.lnk" "$Path_Skyrim_Remove\Mopy\Wrye Flash Launcher.pyw" "" "$Path_Skyrim_Remove\Mopy\bash\images\bash_32.ico" 0
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Skyrim (Debug Log).lnk" "$Path_Skyrim_Remove\Mopy\Wrye Flash Debug.bat" "" "$Path_Skyrim_Remove\Mopy\bash\images\bash_32.ico" 0
                    ${If} $CheckState_Skyrim_Exe_Remove == ${BST_CHECKED}
                        CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash (Standalone) - Skyrim.lnk" "$Path_Skyrim_Remove\Mopy\Wrye Flash.exe"
                        CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash (Standalone) - Skyrim (Debug Log).lnk" "$Path_Skyrim_Remove\Mopy\Wrye Flash.exe" "-d"
                    ${EndIf}
                ${ElseIf} $CheckState_Skyrim_Exe_Remove == ${BST_CHECKED}
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Skyrim.lnk" "$Path_Skyrim_Remove\Mopy\Wrye Flash.exe"
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Skyrim (Debug Log).lnk" "$Path_Skyrim_Remove\Mopy\Wrye Flash.exe" "-d"
                ${EndIf}
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Ex1_Remove == ${BST_CHECKED}
            ${If} Path_Ex1_Remove != $Empty
                SetOutPath $Path_Ex1_Remove\Mopy
                ${If} $CheckState_Ex1_Py_Remove == ${BST_CHECKED}
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Extra 1.lnk" "$Path_Ex1_Remove\Mopy\Wrye Flash Launcher.pyw" "" "$Path_Ex1_Remove\Mopy\bash\images\bash_32.ico" 0
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Extra 1 (Debug Log).lnk" "$Path_Ex1_Remove\Mopy\Wrye Flash Debug.bat" "" "$Path_Ex1_Remove\Mopy\bash\images\bash_32.ico" 0
                    ${If} $CheckState_Ex1_Exe_Remove == ${BST_CHECKED}
                        CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash (Standalone) - Extra 1.lnk" "$Path_Ex1_Remove\Mopy\Wrye Flash.exe"
                        CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash (Standalone) - Extra 1 (Debug Log).lnk" "$Path_Ex1_Remove\Mopy\Wrye Flash.exe" "-d"
                    ${EndIf}
                ${ElseIf} $CheckState_Ex1_Exe_Remove == ${BST_CHECKED}
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Extra 1.lnk" "$Path_Ex1_Remove\Mopy\Wrye Flash.exe"
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Extra 1 (Debug Log).lnk" "$Path_Ex1_Remove\Mopy\Wrye Flash.exe" "-d"
                ${EndIf}
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Ex2_Remove == ${BST_CHECKED}
            ${If} Path_Ex2_Remove != $Empty
                SetOutPath $Path_Ex2_Remove\Mopy
                ${If} $CheckState_Ex2_Py_Remove == ${BST_CHECKED}
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Extra 2.lnk" "$Path_Ex2_Remove\Mopy\Wrye Flash Launcher.pyw" "" "$Path_Ex2_Remove\Mopy\bash\images\bash_32.ico" 0
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Extra 2 (Debug Log).lnk" "$Path_Ex2_Remove\Mopy\Wrye Flash Debug.bat" "" "$Path_Ex2_Remove\Mopy\bash\images\bash_32.ico" 0
                    ${If} $CheckState_Ex2_Exe_Remove == ${BST_CHECKED}
                        CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash (Standalone) - Extra 2.lnk" "$Path_Ex2_Remove\Mopy\Wrye Flash.exe"
                        CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash (Standalone) - Extra 2 (Debug Log).lnk" "$Path_Ex2_Remove\Mopy\Wrye Flash.exe" "-d"
                    ${EndIf}
                ${ElseIf} $CheckState_Ex2_Exe_Remove == ${BST_CHECKED}
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Extra 2.lnk" "$Path_Ex2_Remove\Mopy\Wrye Flash.exe"
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Extra 2 (Debug Log).lnk" "$Path_Ex2_Remove\Mopy\Wrye Flash.exe" "-d"
                ${EndIf}
            ${EndIf}
        ${EndIf}
    SectionEnd
