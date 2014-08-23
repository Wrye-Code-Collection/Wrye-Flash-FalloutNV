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
    Var Path_Nehrim_Remove
    Var Path_Skyrim_Remove
    Var Path_Ex1
    Var Path_Ex2

    ;Game specific Data:
    Var Check_NV
    Var Check_Nehrim_Remove
    Var Check_Skyrim_Remove
    Var Check_Extra
    Var Check_Ex1
    Var Check_Ex2
    Var CheckState_NV
    Var CheckState_Nehrim_Remove
    Var CheckState_Skyrim_Remove
    Var CheckState_Extra
    Var CheckState_Ex1
    Var CheckState_Ex2
    Var Check_NV_Py
    Var Check_Nehrim_Py_Remove
    Var Check_Skyrim_Py_Remove
    Var Check_Ex1_Py
    Var Check_Ex2_Py
    Var CheckState_NV_Py
    Var CheckState_Nehrim_Py_Remove
    Var CheckState_Skyrim_Py_Remove
    Var CheckState_Ex1_Py
    Var CheckState_Ex2_Py
    Var Check_NV_Exe
    Var Check_Nehrim_Exe_Remove
    Var Check_Skyrim_Exe_Remove
    Var Check_Ex1_Exe
    Var Check_Ex2_Exe
    Var CheckState_NV_Exe
    Var CheckState_Nehrim_Exe_Remove
    Var CheckState_Skyrim_Exe_Remove
    Var CheckState_Ex1_Exe
    Var CheckState_Ex2_Exe
    Var Reg_Value_NV_Py
    Var Reg_Value_Nehrim_Py_Remove
    Var Reg_Value_Skyrim_Py_Remove
    Var Reg_Value_Ex1_Py
    Var Reg_Value_Ex2_Py
    Var Reg_Value_NV_Exe
    Var Reg_Value_Nehrim_Exe_Remove
    Var Reg_Value_Skyrim_Exe_Remove
    Var Reg_Value_Ex1_Exe
    Var Reg_Value_Ex2_Exe
    Var PathDialogue_NV
    Var PathDialogue_Nehrim_Remove
    Var PathDialogue_Skyrim_Remove
    Var PathDialogue_Ex1
    Var PathDialogue_Ex2
    Var Browse_NV
    Var Browse_Nehrim_Remove
    Var Browse_Skyrim_Remove
    Var Browse_Ex1
    Var Browse_Ex2
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
        ${If} $Path_Nehrim_Remove != $Empty
            ${NSD_CreateCheckBox} 0 $0u 30% 13u "Install for Nehrim"
                Pop $Check_Nehrim_Remove
                ${NSD_SetState} $Check_Nehrim_Remove $CheckState_Nehrim_Remove
            ${NSD_CreateCheckBox} 30% $0u 40% 13u "Wrye Flash [Standalone]"
                Pop $Check_Nehrim_Exe_Remove
                ${NSD_AddStyle} $Check_Nehrim_Exe_Remove ${WS_GROUP}
                ${NSD_SetState} $Check_Nehrim_Exe_Remove  $CheckState_Nehrim_Exe_Remove
            ${NSD_CreateCheckBox} 70% $0u 30% 13u "Wrye Flash [Python]"
                Pop $Check_Nehrim_Py_Remove
;                ${NSD_SetState} $Check_Nehrim_Py_Remove  $CheckState_Nehrim_Py_Remove
            IntOp $0 $0 + 13
            ${NSD_CreateDirRequest} 0 $0u 90% 13u "$Path_Nehrim_Remove"
                Pop $PathDialogue_Nehrim_Remove
            ${NSD_CreateBrowseButton} -10% $0u 5% 13u "..."
                Pop $Browse_Nehrim_Remove
                nsDialogs::OnClick $Browse_Nehrim_Remove $Function_Browse
            IntOp $0 $0 + 13
        ${EndIf}
        ${If} $Path_Skyrim_Remove != $Empty
            ${NSD_CreateCheckBox} 0 $0u 30% 13u "Install for Skyrim"
                Pop $Check_Skyrim_Remove
                ${NSD_SetState} $Check_Skyrim_Remove $CheckState_Skyrim_Remove
            ${NSD_CreateCheckBox} 30% $0u 40% 13u "Wrye Flash [Standalone]"
                Pop $Check_Skyrim_Exe_Remove
                ${NSD_AddStyle} $Check_Skyrim_Exe_Remove ${WS_GROUP}
                ${NSD_SetState} $Check_Skyrim_Exe_Remove $CheckState_Skyrim_Exe_Remove
            ${NSD_CreateCheckBox} 70% $0u 30% 13u "Wrye Flash [Python]"
                Pop $Check_Skyrim_Py_Remove
;                ${NSD_SetState} $Check_Skyrim_Py_Remove $CheckState_Skyrim_Py_Remove
            IntOp $0 $0 + 13
            ${NSD_CreateDirRequest} 0 $0u 90% 13u "$Path_Skyrim_Remove"
                Pop $PathDialogue_Skyrim_Remove
            ${NSD_CreateBrowseButton} -10% $0u 5% 13u "..."
                Pop $Browse_Skyrim_Remove
                nsDialogs::OnClick $Browse_Skyrim_Remove $Function_Browse
            IntOp $0 $0 + 13
        ${EndIf}
        ${NSD_CreateCheckBox} 0 $0u 100% 13u "Install to extra locations"
            Pop $Check_Extra
            ${NSD_SetState} $Check_Extra $CheckState_Extra
                nsDialogs::OnClick $Check_Extra $Function_Extra
                IntOp $0 $0 + 13
            ${NSD_CreateCheckBox} 0 $0u 30% 13u "Extra Location #1:"
                Pop $Check_Ex1
                ${NSD_SetState} $Check_Ex1 $CheckState_Ex1
                ${NSD_CreateCheckBox} 30% $0u 40% 13u "Wrye Flash [Standalone]"
                    Pop $Check_Ex1_Exe
                    ${NSD_AddStyle} $Check_Ex1_Exe ${WS_GROUP}
                    ${NSD_SetState} $Check_Ex1_Exe  $CheckState_Ex1_Exe
                ${NSD_CreateCheckBox} 70% $0u 30% 13u "Wrye Flash [Python]"
                    Pop $Check_Ex1_Py
;                    ${NSD_SetState} $Check_Ex1_Py  $CheckState_Ex1_Py
                IntOp $0 $0 + 13
                ${NSD_CreateDirRequest} 0 $0u 90% 13u "$Path_Ex1"
                    Pop $PathDialogue_Ex1
                ${NSD_CreateBrowseButton} -10% $0u 5% 13u "..."
                    Pop $Browse_Ex1
                    nsDialogs::OnClick $Browse_Ex1 $Function_Browse
                IntOp $0 $0 + 13
            ${NSD_CreateCheckBox} 0 $0u 30% 13u "Extra Location #2:"
                Pop $Check_Ex2
                ${NSD_SetState} $Check_Ex2 $CheckState_Ex2
                ${NSD_CreateCheckBox} 30% $0u 40% 13u "Wrye Flash [Standalone]"
                    Pop $Check_Ex2_Exe
                    ${NSD_AddStyle} $Check_Ex2_Exe ${WS_GROUP}
                    ${NSD_SetState} $Check_Ex2_Exe  $CheckState_Ex2_Exe
                ${NSD_CreateCheckBox} 70% $0u 30% 13u "Wrye Flash [Python]"
                    Pop $Check_Ex2_Py
;                    ${NSD_SetState} $Check_Ex2_Py  $CheckState_Ex2_Py
                IntOp $0 $0 + 13
                ${NSD_CreateDirRequest} 0 $0u 90% 13u "$Path_Ex2"
                    Pop $PathDialogue_Ex2
                ${NSD_CreateBrowseButton} -10% $0u 5% 13u "..."
                    Pop $Browse_Ex2
                    nsDialogs::OnClick $Browse_Ex2 $Function_Browse
        ${If} $CheckState_Extra != ${BST_CHECKED}
            ShowWindow $Check_Ex1 ${SW_HIDE}
            ShowWindow $Check_Ex1_Py ${SW_HIDE}
            ShowWindow $Check_Ex1_Exe ${SW_HIDE}
            ShowWindow $PathDialogue_Ex1 ${SW_HIDE}
            ShowWindow $Browse_Ex1 ${SW_HIDE}
            ShowWindow $Check_Ex2 ${SW_HIDE}
            ShowWindow $Check_Ex2_Py ${SW_HIDE}
            ShowWindow $Check_Ex2_Exe ${SW_HIDE}
            ShowWindow $PathDialogue_Ex2 ${SW_HIDE}
            ShowWindow $Browse_Ex2 ${SW_HIDE}
        ${EndIf}
        nsDialogs::Show
    FunctionEnd

    Function PAGE_INSTALLLOCATIONS_Leave
        # in case the user goes back to this page and changes selections
        StrCpy $PythonVersionInstall $Empty
        StrCpy $ExeVersionInstall $Empty

        ; Game paths
        ${NSD_GetText} $PathDialogue_NV $Path_NV
        ${NSD_GetText} $PathDialogue_Nehrim_Remove $Path_Nehrim_Remove
        ${NSD_GetText} $PathDialogue_Skyrim_Remove $Path_Skyrim_Remove
        ${NSD_GetText} $PathDialogue_Ex1 $Path_Ex1
        ${NSD_GetText} $PathDialogue_Ex2 $Path_Ex2

        ; Game states
        ${NSD_GetState} $Check_NV $CheckState_NV
        ${NSD_GetState} $Check_Nehrim_Remove $CheckState_Nehrim_Remove
        ${NSD_GetState} $Check_Skyrim_Remove $CheckState_Skyrim_Remove
        ${NSD_GetState} $Check_Extra $CheckState_Extra
        ${NSD_GetState} $Check_Ex1 $CheckState_Ex1
        ${NSD_GetState} $Check_Ex2 $CheckState_Ex2

        ; Python states
        ${NSD_GetState} $Check_NV_Py $CheckState_NV_Py
        ${NSD_GetState} $Check_Nehrim_Py_Remove $CheckState_Nehrim_Py_Remove
        ${NSD_GetState} $Check_Skyrim_Py_Remove $CheckState_Skyrim_Py_Remove
        ${NSD_GetState} $Check_Ex1_Py $CheckState_Ex1_Py
        ${NSD_GetState} $Check_Ex2_Py $CheckState_Ex2_Py
        ${If} $CheckState_NV_Py == ${BST_CHECKED}
        ${AndIf} $CheckState_NV == ${BST_CHECKED}
            StrCpy $PythonVersionInstall $True
        ${Endif}
        ${If} $CheckState_Nehrim_Py_Remove == ${BST_CHECKED}
        ${AndIf} $CheckState_Nehrim_Remove == ${BST_CHECKED}
            StrCpy $PythonVersionInstall $True
        ${Endif}
        ${If} $CheckState_Skyrim_Py_Remove == ${BST_CHECKED}
        ${AndIf} $CheckState_Skyrim_Remove == ${BST_CHECKED}
            StrCpy $PythonVersionInstall $True
        ${EndIf}
        ${If} $CheckState_Ex1_Py == ${BST_CHECKED}
        ${AndIf} $CheckState_Extra == ${BST_CHECKED}
        ${AndIf} $CheckState_Ex1 == ${BST_CHECKED}
            StrCpy $PythonVersionInstall $True
        ${Endif}
        ${If} $CheckState_Ex2_Py == ${BST_CHECKED}
        ${AndIf} $CheckState_Extra == ${BST_CHECKED}
        ${AndIf} $CheckState_Ex2 == ${BST_CHECKED}
            StrCpy $PythonVersionInstall $True
        ${Endif}

        ; Standalone states
        ${NSD_GetState} $Check_NV_Exe $CheckState_NV_Exe
        ${NSD_GetState} $Check_Nehrim_Exe_Remove $CheckState_Nehrim_Exe_Remove
        ${NSD_GetState} $Check_Skyrim_Exe_Remove $CheckState_Skyrim_Exe_Remove
        ${NSD_GetState} $Check_Ex1_Exe $CheckState_Ex1_Exe
        ${NSD_GetState} $Check_Ex2_Exe $CheckState_Ex2_Exe
        ${If} $CheckState_NV_Exe == ${BST_CHECKED}
        ${AndIf} $CheckState_NV == ${BST_CHECKED}
            StrCpy $ExeVersionInstall $True
        ${Endif}
        ${If} $CheckState_Nehrim_Exe_Remove == ${BST_CHECKED}
        ${AndIf} $CheckState_Nehrim_Remove == ${BST_CHECKED}
            StrCpy $ExeVersionInstall $True
        ${Endif}
        ${If} $CheckState_Skyrim_Exe_Remove == ${BST_CHECKED}
        ${AndIf} $CheckState_Skyrim_Remove == ${BST_CHECKED}
            StrCpy $ExeVersionInstall $True
        ${EndIf}
        ${If} $CheckState_Ex1_Exe == ${BST_CHECKED}
        ${AndIf} $CheckState_Extra == ${BST_CHECKED}
        ${AndIf} $CheckState_Ex1 == ${BST_CHECKED}
            StrCpy $ExeVersionInstall $True
        ${Endif}
        ${If} $CheckState_Ex2_Exe == ${BST_CHECKED}
        ${AndIf} $CheckState_Extra == ${BST_CHECKED}
        ${AndIf} $CheckState_Ex2 == ${BST_CHECKED}
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
        ${If} $CheckState_Nehrim_Remove == ${BST_CHECKED}
            ${StrLoc} $0 $Path_Nehrim_Remove "$PROGRAMFILES\" ">"
            ${If} "0" == $0
                StrCpy $1 $True
            ${Endif}
        ${Endif}
        ${If} $CheckState_Skyrim_Remove == ${BST_CHECKED}
            ${StrLoc} $0 $Path_Skyrim_Remove "$PROGRAMFILES\" ">"
            ${If} "0" == $0
                StrCpy $1 $True
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Ex1 == ${BST_CHECKED}
            ${StrLoc} $0 $Path_Ex1 "$PROGRAMFILES\" ">"
            ${If} "0" == $0
                StrCpy $1 $True
            ${Endif}
        ${Endif}
        ${If} $CheckState_Ex2 == ${BST_CHECKED}
            ${StrLoc} $0 $Path_Ex2 "$PROGRAMFILES\" ">"
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

        ${NSD_CreateLabel} 0 24 100% 128u "This is a very common cause of problems when using Wrye Flash. Highly recommended that you stop this installation now, reinstall (Oblivion/Skyrim/Steam) into another directory outside of Program Files, such as C:\Games\Oblivion, and install Wrye Flash at that location.$\n$\nThe problems with installing in Program Files stem from a feature of Windows that did not exist when Oblivion was released: User Access Controls (UAC).  If you continue with the install into Program Files, you may have trouble starting or using Wrye Flash, as it may not be able to access its own files."
        Pop $Label

        nsDialogs::Show
    FunctionEnd

    Function PAGE_CHECK_LOCATIONS_Leave
    FunctionEnd

;-------------------------------- Finish Page
    Function PAGE_FINISH
        !insertmacro MUI_HEADER_TEXT $(PAGE_FINISH_TITLE) $(PAGE_FINISH_SUBTITLE)

        ReadRegStr $Path_NV HKLM "Software\Wrye Flash" "FalloutNV Path"
        ReadRegStr $Path_Nehrim_Remove HKLM "Software\Wrye Flash" "Nehrim Path"
        ReadRegStr $Path_Skyrim_Remove HKLM "Software\Wrye Flash" "Skyrim Path"
        ReadRegStr $Path_Ex1 HKLM "Software\Wrye Flash" "Extra Path 1"
        ReadRegStr $Path_Ex2 HKLM "Software\Wrye Flash" "Extra Path 2"

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
        ${If} $Path_Nehrim_Remove != $Empty
            ${NSD_CreateCheckBox} 0 $0u 100% 8u "Nehrim"
                Pop $Check_Nehrim_Remove
            IntOp $0 $0 + 9
        ${EndIf}
        ${If} $Path_Skyrim_Remove != $Empty
            ${NSD_CreateCheckBox} 0 $0u 100% 8u "Skyrim"
                Pop $Check_Skyrim_Remove
            IntOp $0 $0 + 9
        ${EndIf}
        ${If} $Path_Ex1 != $Empty
            ${NSD_CreateCheckBox} 0 $0u 100% 8u $Path_Ex1
                Pop $Check_Ex1
            IntOp $0 $0 + 9
        ${EndIf}
        ${If} $Path_Ex2 != $Empty
            ${NSD_CreateCheckBox} 0 $0u 100% 8u $Path_Ex2
                Pop $Check_Ex2
            IntOp $0 $0 + 9
        ${EndIf}
        IntOp $0 $0 + 9
        IntOp $1 0 + 0
        ${NSD_CreateCheckBox} $1% $0u 25% 8u "View Readme"
            Pop $Check_Readme
            ${NSD_SetState} $Check_Readme ${BST_CHECKED}
            IntOp $1 $1 + 25
        ${NSD_CreateCheckBox} $1% $0u 75% 8u "Delete files from old Bash versions"
            Pop $Check_DeleteOldFiles
            ${NSD_SetState} $Check_DeleteOldFiles ${BST_CHECKED}
        nsDialogs::Show
    FunctionEnd

    Function PAGE_FINISH_Leave
        ${NSD_GetState} $Check_NV $CheckState_NV
        ${NSD_GetState} $Check_Nehrim_Remove $CheckState_Nehrim_Remove
        ${NSD_GetState} $Check_Skyrim_Remove $CheckState_Skyrim_Remove
        ${NSD_GetState} $Check_Ex1 $CheckState_Ex1
        ${NSD_GetState} $Check_Ex2 $CheckState_Ex2

        ${If} $CheckState_NV == ${BST_CHECKED}
            SetOutPath "$Path_NV\Mopy"
            ${If} $CheckState_NV_Py == ${BST_CHECKED}
                ExecShell "open" '"$Path_NV\Mopy\Wrye Flash Launcher.pyw"'
            ${ElseIf} $CheckState_NV_Exe == ${BST_CHECKED}
                ExecShell "open" "$Path_NV\Mopy\Wrye Flash.exe"
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Nehrim_Remove == ${BST_CHECKED}
            SetOutPath "$Path_Nehrim_Remove\Mopy"
            ${If} $CheckState_Nehrim_Py_Remove == ${BST_CHECKED}
                ExecShell "open" '"$Path_Nehrim_Remove\Mopy\Wrye Flash Launcher.pyw"'
            ${ElseIf} $CheckState_Nehrim_Exe_Remove == ${BST_CHECKED}
                ExecShell "open" "$Path_Nehrim_Remove\Mopy\Wrye Flash.exe"
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Skyrim_Remove == ${BST_CHECKED}
            SetOutPath "$Path_Skyrim_Remove\Mopy"
            ${If} $CheckState_Skyrim_Py_Remove == ${BST_CHECKED}
                ExecShell "open" '"%Path_Skyrim_Remove\Mopy\Wrye Flash Launcher.pyw"'
            ${ElseIf} $CheckState_Skyrim_Exe_Remove == ${BST_CHECKED}
                ExecShell "open" "$Path_Skyrim_Remove\Mopy\Wrye Flash.exe"
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Ex1 == ${BST_CHECKED}
            SetOutPath "$Path_Ex1\Mopy"
            ${If} $CheckState_Ex1_Py == ${BST_CHECKED}
                ExecShell "open" '"$Path_Ex1\Mopy\Wrye Flash Launcher.pyw"'
            ${ElseIf} $CheckState_Ex1_Exe == ${BST_CHECKED}
                ExecShell "open" "$Path_Ex1\Mopy\Wrye Flash.exe"
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Ex2 == ${BST_CHECKED}
            SetOutPath "$Path_Ex2\Mopy"
            ${If} $CheckState_Ex2_Py == ${BST_CHECKED}
                ExecShell "open" '"$Path_Ex2\Mopy\Wrye Flash Launcher.pyw"'
            ${ElseIf} $CheckState_Ex2_Exe == ${BST_CHECKED}
                ExecShell "open" "$Path_Ex2\Mopy\Wrye Flash.exe"
            ${EndIf}
        ${EndIf}
        ${NSD_GetState} $Check_Readme $0
        ${If} $0 == ${BST_CHECKED}
            ${If} $Path_NV != $Empty
                ExecShell "open" "$Path_NV\Mopy\Docs\Wrye Flash General Readme.html"
            ${ElseIf} $Path_Nehrim_Remove != $Empty
                ExecShell "open" "$Path_Nehrim_Remove\Mopy\Docs\Wrye Flash General Readme.html"
            ${ElseIf} $Path_Skyrim_Remove != $Empty
                ExecShell "open" "$Path_Skyrim_Remove\Mopy\Docs\Wrye Flash General Readme.html"
            ${ElseIf} $Path_Ex1 != $Empty
                ExecShell "open" "$Path_Ex1\Mopy\Docs\Wrye Flash General Readme.html"
            ${ElseIf} $Path_Ex2 != $Empty
                ExecShell "open" "$Path_Ex2\Mopy\Docs\Wrye Flash General Readme.html"
            ${EndIf}
        ${EndIf}
        ${NSD_GetState} $Check_DeleteOldFiles $0
        ${If} $0 == ${BST_CHECKED}
            ${If} $Path_NV != $Empty
                Delete "$Path_NV\Mopy\Data\Actor Levels\*"
                Delete "$Path_NV\Data\Ini Tweaks\Sound, Enabled.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound, Disabled.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound Card Channels, 96.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound Card Channels, 8.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound Card Channels, 64.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound Card Channels, 48.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound Card Channels, 24.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound Card Channels, 192.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound Card Channels, 16.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound Card Channels, 128.ini"
                Delete "$Path_NV\Data\Ini Tweaks\ShadowMapResolution, 256 [default].ini"
                Delete "$Path_NV\Data\Ini Tweaks\ShadowMapResolution, 1024.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Screenshot, ~ENabled.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Screenshot, ~Disabled.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Save Backups, 5.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Save Backups, 3.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Save Backups, 2.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Save Backups, 1.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Refraction Shader, Disabled.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Refraction Shader, ~Enabled.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Music, Enabled.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Music, Disabled.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Local Map Shader, Disabled.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Local Map Shader, ~Enabled.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Joystick, ~Enabled.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Joystick, ~Disabled.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Intro Movies, Normal.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Intro Movies, Disabled.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Grass, Fade 4k-5k.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Fonts, ~Default.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Fonts 1, ~Default.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Border Regions, Disabled.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Border Regions, ~Enabled.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Autosave, Never.ini"
                Delete "$Path_NV\Data\Ini Tweaks\Autosave, ~Always.ini"
                Delete "$Path_NV\Data\Docs\Bashed Lists.txt"
                Delete "$Path_NV\Data\Docs\Bashed Lists.html"
                Delete "$Path_NV\Data\Bash Patches\PTRoamingNPCs_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\Crowded Roads Revisited_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\Crowded Roads Revisited_Alternate_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\Crowded Roads Revamped_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\Crowded Cities 30_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\Crowded Cities 30_Alternate_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\Crowded Cities 15_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\Crowded Cities 15_Alternate_Names.csv"
                RMDir  "$Path_NV\Mopy\Data\Actor Levels"
                ;As of 294 the below are obsolete locations or files.
                Delete "$Path_NV\Mopy\ScriptParser.p*"
                Delete "$Path_NV\Mopy\lzma.exe"
                Delete "$Path_NV\Mopy\images\*"
                Delete "$Path_NV\Mopy\gpl.txt"
                Delete "$Path_NV\Mopy\Extras\*"
                Delete "$Path_NV\Mopy\DebugLog(Python2.6).bat"
                Delete "$Path_NV\Mopy\Data\Russian.*"
                Delete "$Path_NV\Mopy\Data\pt_opt.*"
                Delete "$Path_NV\Mopy\Data\Oblivion_ids.pkl"
                Delete "$Path_NV\Mopy\Data\Italian.*"
                Delete "$Path_NV\Mopy\Data\de.*"
                Delete "$Path_NV\Mopy\Data\Actor Levels\OOO, 1.23 Uncapped.csv"
                Delete "$Path_NV\Mopy\Data\Actor Levels\OOO, 1.23 Mincapped.csv"
                Delete "$Path_NV\Mopy\cint.p*"
                Delete "$Path_NV\Mopy\CBash.dll"
                Delete "$Path_NV\Mopy\bush.p*"
                Delete "$Path_NV\Mopy\bosh.p*"
                Delete "$Path_NV\Mopy\bolt.p*"
                Delete "$Path_NV\Mopy\bish.p*"
                Delete "$Path_NV\Mopy\belt.p*"
                Delete "$Path_NV\Mopy\bashmon.p*"
                Delete "$Path_NV\Mopy\basher.p*"
                Delete "$Path_NV\Mopy\bash.p*"
                Delete "$Path_NV\Mopy\barg.p*"
                Delete "$Path_NV\Mopy\barb.p*"
                Delete "$Path_NV\Mopy\balt.p*"
                Delete "$Path_NV\Mopy\7z.*"
                RMDir  "$Path_NV\Mopy\images"
                RMDir  "$Path_NV\Mopy\Extras"
                RMDir  "$Path_NV\Mopy\Data\Actor Levels"
                RMDir  "$Path_NV\Mopy\Data"
                ;As of 297 the below are obsolete locations or files.
                Delete "$Path_NV\Mopy\Wrye Flash.txt"
                Delete "$Path_NV\Mopy\Wrye Flash.html"
                ;As of 301 the below are obsolete locations or files.
                Delete "$Path_NV\Mopy\macro\txt\*.txt"
                Delete "$Path_NV\Mopy\macro\py\*.py"
                Delete "$Path_NV\Mopy\macro\py\*.pyc"
                Delete "$Path_NV\Mopy\macro\*.py"
                Delete "$Path_NV\Mopy\macro\*.pyc"
                Delete "$Path_NV\Mopy\bash\installerstabtips.txt"
                Delete "$Path_NV\Mopy\bash\wizSTCo"
                Delete "$Path_NV\Mopy\bash\wizSTC.py"
                Delete "$Path_NV\Mopy\bash\wizSTC.pyc"
                Delete "$Path_NV\Mopy\bash\keywordWIZBAINo"
                Delete "$Path_NV\Mopy\bash\keywordWIZBAIN2o"
                Delete "$Path_NV\Mopy\bash\keywordWIZBAIN2.p*"
                Delete "$Path_NV\Mopy\bash\keywordWIZBAIN.p*"
                Delete "$Path_NV\Mopy\bash\settingsModule.p*"
                Delete "$Path_NV\Mopy\bash\settingsModuleo"
                Delete "$Path_NV\Mopy\bash\images\stc\*.*"
                RMDir  "$Path_NV\Mopy\macro\txt"
                RMDir  "$Path_NV\Mopy\macro\py"
                RMDir  "$Path_NV\Mopy\macro"
                RMDir  "$Path_NV\Mopy\bash\images\stc"
                ; As of 303 the below are obsolete locations or files.
                Delete "$Path_NV\Mopy\templates\Bashed Patch, Skyrim.esp"
                Delete "$Path_NV\Mopy\templates\Bashed Patch, Oblivion.esp"
                Delete "$Path_NV\Mopy\templates\Blank.esp"
            ${EndIf}
            ${If} $Path_Nehrim_Remove != $Empty
                Delete "$Path_Nehrim_Remove\Mopy\Data\Actor Levels\*"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound, Enabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound, Disabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound Card Channels, 96.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound Card Channels, 8.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound Card Channels, 64.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound Card Channels, 48.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound Card Channels, 24.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound Card Channels, 192.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound Card Channels, 16.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound Card Channels, 128.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\ShadowMapResolution, 256 [default].ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\ShadowMapResolution, 1024.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Screenshot, ~ENabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Screenshot, ~Disabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Save Backups, 5.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Save Backups, 3.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Save Backups, 2.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Save Backups, 1.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Refraction Shader, Disabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Refraction Shader, ~Enabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Music, Enabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Music, Disabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Local Map Shader, Disabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Local Map Shader, ~Enabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Joystick, ~Enabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Joystick, ~Disabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Intro Movies, Normal.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Intro Movies, Disabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Grass, Fade 4k-5k.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Fonts, ~Default.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Fonts 1, ~Default.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Border Regions, Disabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Border Regions, ~Enabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Autosave, Never.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Autosave, ~Always.ini"
                Delete "$Path_Nehrim_Remove\Data\Docs\Bashed Lists.txt"
                Delete "$Path_Nehrim_Remove\Data\Docs\Bashed Lists.html"
                Delete "$Path_Nehrim_Remove\Data\Bash Patches\PTRoamingNPCs_Names.csv"
                Delete "$Path_Nehrim_Remove\Data\Bash Patches\Crowded Roads Revisited_Names.csv"
                Delete "$Path_Nehrim_Remove\Data\Bash Patches\Crowded Roads Revisited_Alternate_Names.csv"
                Delete "$Path_Nehrim_Remove\Data\Bash Patches\Crowded Roads Revamped_Names.csv"
                Delete "$Path_Nehrim_Remove\Data\Bash Patches\Crowded Cities 30_Names.csv"
                Delete "$Path_Nehrim_Remove\Data\Bash Patches\Crowded Cities 30_Alternate_Names.csv"
                Delete "$Path_Nehrim_Remove\Data\Bash Patches\Crowded Cities 15_Names.csv"
                Delete "$Path_Nehrim_Remove\Data\Bash Patches\Crowded Cities 15_Alternate_Names.csv"
                RMDir "$Path_Nehrim_Remove\Mopy\Data\Actor Levels"
                ;As of 294 the below are obsolete locations or files.
                Delete "$Path_Nehrim_Remove\Mopy\ScriptParser.p*"
                Delete "$Path_Nehrim_Remove\Mopy\lzma.exe"
                Delete "$Path_Nehrim_Remove\Mopy\images\*"
                Delete "$Path_Nehrim_Remove\Mopy\gpl.txt"
                Delete "$Path_Nehrim_Remove\Mopy\Extras\*"
                Delete "$Path_Nehrim_Remove\Mopy\DebugLog(Python2.6).bat"
                Delete "$Path_Nehrim_Remove\Mopy\Data\Russian.*"
                Delete "$Path_Nehrim_Remove\Mopy\Data\pt_opt.*"
                Delete "$Path_Nehrim_Remove\Mopy\Data\Oblivion_ids.pkl"
                Delete "$Path_Nehrim_Remove\Mopy\Data\Italian.*"
                Delete "$Path_Nehrim_Remove\Mopy\Data\de.*"
                Delete "$Path_Nehrim_Remove\Mopy\Data\Actor Levels\OOO, 1.23 Uncapped.csv"
                Delete "$Path_Nehrim_Remove\Mopy\Data\Actor Levels\OOO, 1.23 Mincapped.csv"
                Delete "$Path_Nehrim_Remove\Mopy\cint.p*"
                Delete "$Path_Nehrim_Remove\Mopy\CBash.dll"
                Delete "$Path_Nehrim_Remove\Mopy\bush.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bosh.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bolt.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bish.p*"
                Delete "$Path_Nehrim_Remove\Mopy\belt.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bashmon.p*"
                Delete "$Path_Nehrim_Remove\Mopy\basher.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash.p*"
                Delete "$Path_Nehrim_Remove\Mopy\barg.p*"
                Delete "$Path_Nehrim_Remove\Mopy\barb.p*"
                Delete "$Path_Nehrim_Remove\Mopy\balt.p*"
                Delete "$Path_Nehrim_Remove\Mopy\7z.*"
                RMDir  "$Path_Nehrim_Remove\Mopy\images"
                RMDir  "$Path_Nehrim_Remove\Mopy\Extras"
                RMDir  "$Path_Nehrim_Remove\Mopy\Data\Actor Levels"
                RMDir  "$Path_Nehrim_Remove\Mopy\Data"
                ;As of 297 the below are obsolete locations or files.
                Delete "$Path_Nehrim_Remove\Mopy\Wrye Flash.txt"
                Delete "$Path_Nehrim_Remove\Mopy\Wrye Flash.html"
                ;As of 301 the below are obsolete locations or files.
                Delete "$Path_Nehrim_Remove\Mopy\macro\txt\*.txt"
                Delete "$Path_Nehrim_Remove\Mopy\macro\py\*.py"
                Delete "$Path_Nehrim_Remove\Mopy\macro\py\*.pyc"
                Delete "$Path_Nehrim_Remove\Mopy\macro\*.py"
                Delete "$Path_Nehrim_Remove\Mopy\macro\*.pyc"
                Delete "$Path_Nehrim_Remove\Mopy\bash\installerstabtips.txt"
                Delete "$Path_Nehrim_Remove\Mopy\bash\wizSTCo"
                Delete "$Path_Nehrim_Remove\Mopy\bash\wizSTC.py"
                Delete "$Path_Nehrim_Remove\Mopy\bash\wizSTC.pyc"
                Delete "$Path_Nehrim_Remove\Mopy\bash\keywordWIZBAINo"
                Delete "$Path_Nehrim_Remove\Mopy\bash\keywordWIZBAIN2o"
                Delete "$Path_Nehrim_Remove\Mopy\bash\keywordWIZBAIN2.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\keywordWIZBAIN.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\settingsModule.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\settingsModuleo"
                Delete "$Path_Nehrim_Remove\Mopy\bash\images\stc\*.*"
                RMDir  "$Path_Nehrim_Remove\Mopy\macro\txt"
                RMDir  "$Path_Nehrim_Remove\Mopy\macro\py"
                RMDir  "$Path_Nehrim_Remove\Mopy\macro"
                RMDir  "$Path_Nehrim_Remove\Mopy\bash\images\stc"
                ; As of 303 the below are obsolete locations or files.
                Delete "$Path_Nehrim_Remove\Mopy\templates\Bashed Patch, Skyrim.esp"
                Delete "$Path_Nehrim_Remove\Mopy\templates\Bashed Patch, Oblivion.esp"
                Delete "$Path_Nehrim_Remove\Mopy\templates\Blank.esp"
            ${EndIf}
            ${If} $Path_Skyrim_Remove != $Empty
                Delete "$Path_Skyrim_Remove\Mopy\Data\Actor Levels\*"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound, Enabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound, Disabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound Card Channels, 96.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound Card Channels, 8.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound Card Channels, 64.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound Card Channels, 48.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound Card Channels, 24.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound Card Channels, 192.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound Card Channels, 16.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound Card Channels, 128.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\ShadowMapResolution, 256 [default].ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\ShadowMapResolution, 1024.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Screenshot, ~ENabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Screenshot, ~Disabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Save Backups, 5.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Save Backups, 3.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Save Backups, 2.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Save Backups, 1.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Refraction Shader, Disabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Refraction Shader, ~Enabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Music, Enabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Music, Disabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Local Map Shader, Disabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Local Map Shader, ~Enabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Joystick, ~Enabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Joystick, ~Disabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Intro Movies, Normal.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Intro Movies, Disabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Grass, Fade 4k-5k.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Fonts, ~Default.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Fonts 1, ~Default.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Border Regions, Disabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Border Regions, ~Enabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Autosave, Never.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Autosave, ~Always.ini"
                Delete "$Path_Skyrim_Remove\Data\Docs\Bashed Lists.txt"
                Delete "$Path_Skyrim_Remove\Data\Docs\Bashed Lists.html"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\PTRoamingNPCs_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Crowded Roads Revisited_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Crowded Roads Revisited_Alternate_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Crowded Roads Revamped_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Crowded Cities 30_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Crowded Cities 30_Alternate_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Crowded Cities 15_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Crowded Cities 15_Alternate_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\ArchiveInvalidationInvalidated!.bsa"
                RMDir  "$Path_Skyrim_Remove\Mopy\Data\Actor Levels"
                ;As of 294 the below are obsolete locations or files.
                Delete "$Path_Skyrim_Remove\Mopy\ScriptParser.p*"
                Delete "$Path_Skyrim_Remove\Mopy\lzma.exe"
                Delete "$Path_Skyrim_Remove\Mopy\images\*"
                Delete "$Path_Skyrim_Remove\Mopy\gpl.txt"
                Delete "$Path_Skyrim_Remove\Mopy\Extras\*"
                Delete "$Path_Skyrim_Remove\Mopy\DebugLog(Python2.6).bat"
                Delete "$Path_Skyrim_Remove\Mopy\Data\Russian.*"
                Delete "$Path_Skyrim_Remove\Mopy\Data\pt_opt.*"
                Delete "$Path_Skyrim_Remove\Mopy\Data\Oblivion_ids.pkl"
                Delete "$Path_Skyrim_Remove\Mopy\Data\Italian.*"
                Delete "$Path_Skyrim_Remove\Mopy\Data\de.*"
                Delete "$Path_Skyrim_Remove\Mopy\Data\Actor Levels\OOO, 1.23 Uncapped.csv"
                Delete "$Path_Skyrim_Remove\Mopy\Data\Actor Levels\OOO, 1.23 Mincapped.csv"
                Delete "$Path_Skyrim_Remove\Mopy\cint.p*"
                Delete "$Path_Skyrim_Remove\Mopy\CBash.dll"
                Delete "$Path_Skyrim_Remove\Mopy\bush.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bosh.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bolt.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bish.p*"
                Delete "$Path_Skyrim_Remove\Mopy\belt.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bashmon.p*"
                Delete "$Path_Skyrim_Remove\Mopy\basher.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash.p*"
                Delete "$Path_Skyrim_Remove\Mopy\barg.p*"
                Delete "$Path_Skyrim_Remove\Mopy\barb.p*"
                Delete "$Path_Skyrim_Remove\Mopy\balt.p*"
                Delete "$Path_Skyrim_Remove\Mopy\7z.*"
                RMDir  "$Path_Skyrim_Remove\Mopy\images"
                RMDir  "$Path_Skyrim_Remove\Mopy\Extras"
                RMDir  "$Path_Skyrim_Remove\Mopy\Data\Actor Levels"
                RMDir  "$Path_Skyrim_Remove\Mopy\Data"
                ;As of 297 the below are obsolete locations or files.
                Delete "$Path_Skyrim_Remove\Mopy\Wrye Flash.txt"
                Delete "$Path_Skyrim_Remove\Mopy\Wrye Flash.html"
                ;As of 301 the below are obsolete locations or files.
                Delete "$Path_Skyrim_Remove\Mopy\macro\txt\*.txt"
                Delete "$Path_Skyrim_Remove\Mopy\macro\py\*.py"
                Delete "$Path_Skyrim_Remove\Mopy\macro\py\*.pyc"
                Delete "$Path_Skyrim_Remove\Mopy\macro\*.py"
                Delete "$Path_Skyrim_Remove\Mopy\macro\*.pyc"
                Delete "$Path_Skyrim_Remove\Mopy\bash\installerstabtips.txt"
                Delete "$Path_Skyrim_Remove\Mopy\bash\wizSTCo"
                Delete "$Path_Skyrim_Remove\Mopy\bash\wizSTC.py"
                Delete "$Path_Skyrim_Remove\Mopy\bash\wizSTC.pyc"
                Delete "$Path_Skyrim_Remove\Mopy\bash\keywordWIZBAINo"
                Delete "$Path_Skyrim_Remove\Mopy\bash\keywordWIZBAIN2o"
                Delete "$Path_Skyrim_Remove\Mopy\bash\keywordWIZBAIN2.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\keywordWIZBAIN.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\settingsModule.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\settingsModuleo"
                Delete "$Path_Skyrim_Remove\Mopy\bash\images\stc\*.*"
                RMDir  "$Path_Skyrim_Remove\Mopy\macro\txt"
                RMDir  "$Path_Skyrim_Remove\Mopy\macro\py"
                RMDir  "$Path_Skyrim_Remove\Mopy\macro"
                RMDir  "$Path_Skyrim_Remove\Mopy\bash\images\stc"
                ; As of 303 the below are obsolete locations or files.
                Delete "$Path_Skyrim_Remove\Mopy\templates\Bashed Patch, Skyrim.esp"
                Delete "$Path_Skyrim_Remove\Mopy\templates\Bashed Patch, Oblivion.esp"
                Delete "$Path_Skyrim_Remove\Mopy\templates\Blank.esp"
            ${EndIf}
            ${If} $Path_Ex1 != $Empty
                Delete "$Path_Ex1\Mopy\Data\Actor Levels\*"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound, Enabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound, Disabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound Card Channels, 96.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound Card Channels, 8.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound Card Channels, 64.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound Card Channels, 48.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound Card Channels, 24.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound Card Channels, 192.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound Card Channels, 16.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound Card Channels, 128.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\ShadowMapResolution, 256 [default].ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\ShadowMapResolution, 1024.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Screenshot, ~ENabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Screenshot, ~Disabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Save Backups, 5.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Save Backups, 3.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Save Backups, 2.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Save Backups, 1.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Refraction Shader, Disabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Refraction Shader, ~Enabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Music, Enabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Music, Disabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Local Map Shader, Disabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Local Map Shader, ~Enabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Joystick, ~Enabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Joystick, ~Disabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Intro Movies, Normal.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Intro Movies, Disabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Grass, Fade 4k-5k.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Fonts, ~Default.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Fonts 1, ~Default.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Border Regions, Disabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Border Regions, ~Enabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Autosave, Never.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Autosave, ~Always.ini"
                Delete "$Path_Ex1\Data\Docs\Bashed Lists.txt"
                Delete "$Path_Ex1\Data\Docs\Bashed Lists.html"
                Delete "$Path_Ex1\Data\Bash Patches\PTRoamingNPCs_Names.csv"
                Delete "$Path_Ex1\Data\Bash Patches\Crowded Roads Revisited_Names.csv"
                Delete "$Path_Ex1\Data\Bash Patches\Crowded Roads Revisited_Alternate_Names.csv"
                Delete "$Path_Ex1\Data\Bash Patches\Crowded Roads Revamped_Names.csv"
                Delete "$Path_Ex1\Data\Bash Patches\Crowded Cities 30_Names.csv"
                Delete "$Path_Ex1\Data\Bash Patches\Crowded Cities 30_Alternate_Names.csv"
                Delete "$Path_Ex1\Data\Bash Patches\Crowded Cities 15_Names.csv"
                Delete "$Path_Ex1\Data\Bash Patches\Crowded Cities 15_Alternate_Names.csv"
                RMDir "$Path_Ex1\Mopy\Data\Actor Levels"
                ;As of 294 the below are obsolete locations or files.
                Delete "$Path_Ex1\Mopy\ScriptParser.p*"
                Delete "$Path_Ex1\Mopy\lzma.exe"
                Delete "$Path_Ex1\Mopy\images\*"
                Delete "$Path_Ex1\Mopy\gpl.txt"
                Delete "$Path_Ex1\Mopy\Extras\*"
                Delete "$Path_Ex1\Mopy\DebugLog(Python2.6).bat"
                Delete "$Path_Ex1\Mopy\Data\Russian.*"
                Delete "$Path_Ex1\Mopy\Data\pt_opt.*"
                Delete "$Path_Ex1\Mopy\Data\Oblivion_ids.pkl"
                Delete "$Path_Ex1\Mopy\Data\Italian.*"
                Delete "$Path_Ex1\Mopy\Data\de.*"
                Delete "$Path_Ex1\Mopy\Data\Actor Levels\OOO, 1.23 Uncapped.csv"
                Delete "$Path_Ex1\Mopy\Data\Actor Levels\OOO, 1.23 Mincapped.csv"
                Delete "$Path_Ex1\Mopy\cint.p*"
                Delete "$Path_Ex1\Mopy\CBash.dll"
                Delete "$Path_Ex1\Mopy\bush.p*"
                Delete "$Path_Ex1\Mopy\bosh.p*"
                Delete "$Path_Ex1\Mopy\bolt.p*"
                Delete "$Path_Ex1\Mopy\bish.p*"
                Delete "$Path_Ex1\Mopy\belt.p*"
                Delete "$Path_Ex1\Mopy\bashmon.p*"
                Delete "$Path_Ex1\Mopy\basher.p*"
                Delete "$Path_Ex1\Mopy\bash.p*"
                Delete "$Path_Ex1\Mopy\barg.p*"
                Delete "$Path_Ex1\Mopy\barb.p*"
                Delete "$Path_Ex1\Mopy\balt.p*"
                Delete "$Path_Ex1\Mopy\7z.*"
                RMDir  "$Path_Ex1\Mopy\images"
                RMDir  "$Path_Ex1\Mopy\Extras"
                RMDir  "$Path_Ex1\Mopy\Data\Actor Levels"
                RMDir  "$Path_Ex1\Mopy\Data"
                ;As of 297 the below are obsolete locations or files.
                Delete "$Path_Ex1\Mopy\Wrye Flash.txt"
                Delete "$Path_Ex1\Mopy\Wrye Flash.html"
                ;As of 301 the below are obsolete locations or files.
                Delete "$Path_Ex1\Mopy\macro\txt\*.txt"
                Delete "$Path_Ex1\Mopy\macro\py\*.py"
                Delete "$Path_Ex1\Mopy\macro\py\*.pyc"
                Delete "$Path_Ex1\Mopy\macro\*.py"
                Delete "$Path_Ex1\Mopy\macro\*.pyc"
                Delete "$Path_Ex1\Mopy\bash\installerstabtips.txt"
                Delete "$Path_Ex1\Mopy\bash\wizSTCo"
                Delete "$Path_Ex1\Mopy\bash\wizSTC.py"
                Delete "$Path_Ex1\Mopy\bash\wizSTC.pyc"
                Delete "$Path_Ex1\Mopy\bash\keywordWIZBAINo"
                Delete "$Path_Ex1\Mopy\bash\keywordWIZBAIN2o"
                Delete "$Path_Ex1\Mopy\bash\keywordWIZBAIN2.p*"
                Delete "$Path_Ex1\Mopy\bash\keywordWIZBAIN.p*"
                Delete "$Path_Ex1\Mopy\bash\settingsModule.p*"
                Delete "$Path_Ex1\Mopy\bash\settingsModuleo"
                Delete "$Path_Ex1\Mopy\bash\images\stc\*.*"
                RMDir  "$Path_Ex1\Mopy\macro\txt"
                RMDir  "$Path_Ex1\Mopy\macro\py"
                RMDir  "$Path_Ex1\Mopy\macro"
                RMDir  "$Path_Ex1\Mopy\bash\images\stc"
                ; As of 303 the below are obsolete locations or files.
                Delete "$Path_Ex1\Mopy\templates\Bashed Patch, Skyrim.esp"
                Delete "$Path_Ex1\Mopy\templates\Bashed Patch, Oblivion.esp"
                Delete "$Path_Ex1\Mopy\templates\Blank.esp"
            ${EndIf}
            ${If} $Path_Ex2 != $Empty
                Delete "$Path_Ex2\Mopy\Data\Actor Levels\*"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound, Enabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound, Disabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels, 96.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels, 8.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels, 64.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels, 48.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels, 24.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels, 192.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels, 16.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels, 128.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels, ~ [Oblivion].ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels,  [Oblivion].ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\ShadowMapResolution, 256 [default].ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\ShadowMapResolution, 1024.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Screenshot, ~ENabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Screenshot, ~Disabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Save Backups, 5.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Save Backups, 3.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Save Backups, 2.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Save Backups, 1.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Refraction Shader, Disabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Refraction Shader, ~Enabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Music, Enabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Music, Disabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Local Map Shader, Disabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Local Map Shader, ~Enabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Joystick, ~Enabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Joystick, ~Disabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Intro Movies, Normal.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Intro Movies, Disabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Grass, Fade 4k-5k.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Fonts, ~Default.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Fonts 1, ~Default.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Border Regions, Disabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Border Regions, ~Enabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Autosave, Never.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Autosave, ~Always.ini"
                Delete "$Path_Ex2\Data\Docs\Bashed Lists.txt"
                Delete "$Path_Ex2\Data\Docs\Bashed Lists.html"
                Delete "$Path_Ex2\Data\Bash Patches\PTRoamingNPCs_Names.csv"
                Delete "$Path_Ex2\Data\Bash Patches\Crowded Roads Revisited_Names.csv"
                Delete "$Path_Ex2\Data\Bash Patches\Crowded Roads Revisited_Alternate_Names.csv"
                Delete "$Path_Ex2\Data\Bash Patches\Crowded Roads Revamped_Names.csv"
                Delete "$Path_Ex2\Data\Bash Patches\Crowded Cities 30_Names.csv"
                Delete "$Path_Ex2\Data\Bash Patches\Crowded Cities 30_Alternate_Names.csv"
                Delete "$Path_Ex2\Data\Bash Patches\Crowded Cities 15_Names.csv"
                Delete "$Path_Ex2\Data\Bash Patches\Crowded Cities 15_Alternate_Names.csv"
                RMDir "$Path_Ex2\Mopy\Data\Actor Levels"
                ;As of 294 the below are obsolete locations or files.
                Delete "$Path_Ex2\Mopy\ScriptParser.p*"
                Delete "$Path_Ex2\Mopy\lzma.exe"
                Delete "$Path_Ex2\Mopy\images\*"
                Delete "$Path_Ex2\Mopy\gpl.txt"
                Delete "$Path_Ex2\Mopy\Extras\*"
                Delete "$Path_Ex2\Mopy\DebugLog(Python2.6).bat"
                Delete "$Path_Ex2\Mopy\Data\Russian.*"
                Delete "$Path_Ex2\Mopy\Data\pt_opt.*"
                Delete "$Path_Ex2\Mopy\Data\Oblivion_ids.pkl"
                Delete "$Path_Ex2\Mopy\Data\Italian.*"
                Delete "$Path_Ex2\Mopy\Data\de.*"
                Delete "$Path_Ex2\Mopy\Data\Actor Levels\OOO, 1.23 Uncapped.csv"
                Delete "$Path_Ex2\Mopy\Data\Actor Levels\OOO, 1.23 Mincapped.csv"
                Delete "$Path_Ex2\Mopy\cint.p*"
                Delete "$Path_Ex2\Mopy\CBash.dll"
                Delete "$Path_Ex2\Mopy\bush.p*"
                Delete "$Path_Ex2\Mopy\bosh.p*"
                Delete "$Path_Ex2\Mopy\bolt.p*"
                Delete "$Path_Ex2\Mopy\bish.p*"
                Delete "$Path_Ex2\Mopy\belt.p*"
                Delete "$Path_Ex2\Mopy\bashmon.p*"
                Delete "$Path_Ex2\Mopy\basher.p*"
                Delete "$Path_Ex2\Mopy\bash.p*"
                Delete "$Path_Ex2\Mopy\barg.p*"
                Delete "$Path_Ex2\Mopy\barb.p*"
                Delete "$Path_Ex2\Mopy\balt.p*"
                Delete "$Path_Ex2\Mopy\7z.*"
                RMDir  "$Path_Ex2\Mopy\images"
                RMDir  "$Path_Ex2\Mopy\Extras"
                RMDir  "$Path_Ex2\Mopy\Data\Actor Levels"
                RMDir  "$Path_Ex2\Mopy\Data"
                ;As of 297 the below are obsolete locations or files.
                Delete "$Path_Ex2\Mopy\Wrye Flash.txt"
                Delete "$Path_Ex2\Mopy\Wrye Flash.html"
                ;As of 301 the below are obsolete locations or files.
                Delete "$Path_Ex2\Mopy\macro\txt\*.txt"
                Delete "$Path_Ex2\Mopy\macro\py\*.py"
                Delete "$Path_Ex2\Mopy\macro\py\*.pyc"
                Delete "$Path_Ex2\Mopy\macro\*.py"
                Delete "$Path_Ex2\Mopy\macro\*.pyc"
                Delete "$Path_Ex2\Mopy\bash\installerstabtips.txt"
                Delete "$Path_Ex2\Mopy\bash\wizSTCo"
                Delete "$Path_Ex2\Mopy\bash\wizSTC.py"
                Delete "$Path_Ex2\Mopy\bash\wizSTC.pyc"
                Delete "$Path_Ex2\Mopy\bash\keywordWIZBAINo"
                Delete "$Path_Ex2\Mopy\bash\keywordWIZBAIN2o"
                Delete "$Path_Ex2\Mopy\bash\keywordWIZBAIN2.p*"
                Delete "$Path_Ex2\Mopy\bash\keywordWIZBAIN.p*"
                Delete "$Path_Ex2\Mopy\bash\settingsModule.p*"
                Delete "$Path_Ex2\Mopy\bash\settingsModuleo"
                Delete "$Path_Ex2\Mopy\bash\images\stc\*.*"
                RMDir  "$Path_Ex2\Mopy\macro\txt"
                RMDir  "$Path_Ex2\Mopy\macro\py"
                RMDir  "$Path_Ex2\Mopy\macro"
                RMDir  "$Path_Ex2\Mopy\bash\images\stc"
                ; As of 303 the below are obsolete locations or files.
                Delete "$Path_Ex2\Mopy\templates\Bashed Patch, Skyrim.esp"
                Delete "$Path_Ex2\Mopy\templates\Bashed Patch, Oblivion.esp"
                Delete "$Path_Ex2\Mopy\templates\Blank.esp"
            ${EndIf}
        ${EndIf}
    FunctionEnd


;-------------------------------- Auxilliary Functions
    Function OnClick_Browse
        Pop $0
        ${If} $0 == $Browse_NV
            StrCpy $1 $PathDialogue_NV
        ${ElseIf} $0 == $Browse_Nehrim_Remove
            StrCpy $1 $PathDialogue_Nehrim_Remove
        ${ElseIf} $0 == $Browse_Skyrim_Remove
            StrCpy $1 $PathDialogue_Skyrim_Remove
        ${ElseIf} $0 == $Browse_Ex1
            StrCpy $1 $PathDialogue_Ex1
        ${ElseIf} $0 == $Browse_Ex2
            StrCpy $1 $PathDialogue_Ex2
        ${EndIf}
        ${NSD_GetText} $1 $Function_DirPrompt
        nsDialogs::SelectFolderDialog /NOUNLOAD "Please select a target directory" $Function_DirPrompt
        Pop $0

        ${If} $0 == error
            Abort
        ${EndIf}

        ${NSD_SetText} $1 $0
    FunctionEnd

    Function OnClick_Extra
        Pop $0
        ${NSD_GetState} $0 $CheckState_Extra
        ${If} $CheckState_Extra == ${BST_UNCHECKED}
            ShowWindow $Check_Ex1 ${SW_HIDE}
            ShowWindow $Check_Ex1_Py ${SW_HIDE}
            ShowWindow $Check_Ex1_Exe ${SW_HIDE}
            ShowWindow $PathDialogue_Ex1 ${SW_HIDE}
            ShowWindow $Browse_Ex1 ${SW_HIDE}
            ShowWindow $Check_Ex2 ${SW_HIDE}
            ShowWindow $Check_Ex2_Py ${SW_HIDE}
            ShowWindow $Check_Ex2_Exe ${SW_HIDE}
            ShowWindow $PathDialogue_Ex2 ${SW_HIDE}
            ShowWindow $Browse_Ex2 ${SW_HIDE}
        ${Else}
            ShowWindow $Check_Ex1 ${SW_SHOW}
            ShowWindow $Check_Ex1_Py ${SW_SHOW}
            ShowWindow $Check_Ex1_Exe ${SW_SHOW}
            ShowWindow $PathDialogue_Ex1 ${SW_SHOW}
            ShowWindow $Browse_Ex1 ${SW_SHOW}
            ShowWindow $Check_Ex2 ${SW_SHOW}
            ShowWindow $Check_Ex2_Py ${SW_SHOW}
            ShowWindow $Check_Ex2_Exe ${SW_SHOW}
            ShowWindow $PathDialogue_Ex2 ${SW_SHOW}
            ShowWindow $Browse_Ex2 ${SW_SHOW}
        ${EndIf}
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
                File /r "Mopy\templates\Oblivion\ArchiveInvalidationInvalidated!.bsa"
                SetOutPath "$Path_NV\Mopy\Bash Patches\Oblivion"
                File /r "Mopy\Bash Patches\Oblivion\*.*"
                SetOutPath $Path_NV\Data\Docs
                SetOutPath "$Path_NV\Mopy\INI Tweaks\Oblivion"
                File /r "Mopy\INI Tweaks\Oblivion\*.*"
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
        ${If} $CheckState_Nehrim_Remove == ${BST_CHECKED}
            ; Install resources:
            ${If} Path_Nehrim_Remove != $Empty
                SetOutPath $Path_Nehrim_Remove\Mopy
                File /r /x "*.svn*" /x "*.bat" /x "*.py*" /x "w9xpopen.exe" /x "Wrye Flash.exe" "Mopy\*.*"
                SetOutPath $Path_Nehrim_Remove\Data
                File /r "Mopy\templates\Oblivion\ArchiveInvalidationInvalidated!.bsa"
                SetOutPath "$Path_Nehrim_Remove\Mopy\Bash Patches\Oblivion"
                File /r "Mopy\Bash Patches\Oblivion\*.*"
                SetOutPath $Path_Nehrim_Remove\Data\Docs
                SetOutPath "$Path_Nehrim_Remove\Mopy\INI Tweaks\Oblivion"
                File /r "Mopy\INI Tweaks\Oblivion\*.*"
                ; Write the installation path into the registry
                WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Nehrim Path" "$Path_Nehrim_Remove"
                ${If} $CheckState_Nehrim_Py_Remove == ${BST_CHECKED}
                    SetOutPath "$Path_Nehrim_Remove\Mopy"
                    File /r "Mopy\*.py" "Mopy\*.pyw" "Mopy\*.bat"
                    ; Write the installation path into the registry
                    WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Nehrim Python Version" "True"
                ${Else}
                    ${If} $Reg_Value_Nehrim_Py_Remove == $Empty ; ie don't overwrite it if it is installed but just not being installed that way this time.
                        WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Nehrim Python Version" ""
                    ${EndIf}
                ${EndIf}
                ${If} $CheckState_Nehrim_Exe_Remove == ${BST_CHECKED}
                    SetOutPath "$Path_Nehrim_Remove\Mopy"
                    File "Mopy\w9xpopen.exe" "Mopy\Wrye Flash.exe"
                    ; Write the installation path into the registry
                    WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Nehrim Standalone Version" "True"
                ${Else}
                    ${If} $Reg_Value_Nehrim_Exe_Remove == $Empty ; ie don't overwrite it if it is installed but just not being installed that way this time.
                        WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Nehrim Standalone Version" ""
                    ${EndIf}
                ${EndIf}
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Skyrim_Remove == ${BST_CHECKED}
            ; Install resources:
            ${If} Path_Skyrim_Remove != $Empty
                SetOutPath $Path_Skyrim_Remove\Mopy
                File /r /x "*.svn*" /x "*.bat" /x "*.py*" /x "w9xpopen.exe" /x "Wrye Flash.exe" "Mopy\*.*"
                SetOutPath "$Path_Skyrim_Remove\Mopy\Bash Patches\Skyrim"
                File /r "Mopy\Bash Patches\Skyrim\*.*"
                SetOutPath $Path_Skyrim_Remove\Data\Docs
                SetOutPath "$Path_Skyrim_Remove\Mopy\INI Tweaks\Skyrim"
                File /r "Mopy\INI Tweaks\Skyrim\*.*"
                ; Write the installation path into the registry
                WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Skyrim Path" "$Path_Skyrim_Remove"
                ${If} $CheckState_Skyrim_Remove == ${BST_CHECKED}
                    SetOutPath "$Path_Skyrim_Remove\Mopy"
                    File /r "Mopy\*.py" "Mopy\*.pyw" "Mopy\*.bat"
                    ; Write the installation path into the registry
                    WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Skyrim Python Version" "True"
                ${ElseIf} $Reg_Value_Skyrim_Py_Remove == $Empty ; id don't overwrite it if it is installed but just not being installed that way this time.
                    WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Skyrim Python Version" ""
                ${EndIf}
                ${If} $CheckState_Skyrim_Exe_Remove == ${BST_CHECKED}
                    SetOutPath "$Path_Skyrim_Remove\Mopy"
                    File "Mopy\w9xpopen.exe" "Mopy\Wrye Flash.exe"
                    ; Write the installation path into the registry
                    WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Skyrim Standalone Version" "True"
                ${ElseIf} $Reg_Value_Skyrim_Exe_Remove == $Empty ; ie don't overwrite it if it is installed but just not being installed that way this time.
                    WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Skyrim Standalond Version" ""
                ${EndIf}
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Ex1 == ${BST_CHECKED}
            ; Install resources:
            ${If} Path_Ex1 != $Empty
                SetOutPath $Path_Ex1\Mopy
                File /r /x "*.svn*" /x "*.bat" /x "*.py*" /x "w9xpopen.exe" /x "Wrye Flash.exe" "Mopy\*.*"
                ; Write the installation path into the registry
                WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Extra Path 1" "$Path_Ex1"
                ${If} $CheckState_Ex1_Py == ${BST_CHECKED}
                    SetOutPath "$Path_Ex1\Mopy"
                    File /r "Mopy\*.py" "Mopy\*.pyw" "Mopy\*.bat"
                    ; Write the installation path into the registry
                    WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Extra Path 1 Python Version" "True"
                ${Else}
                    ${If} $Reg_Value_Ex1_Py == $Empty ; ie don't overwrite it if it is installed but just not being installed that way this time.
                        WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Extra Path 1 Python Version" ""
                    ${EndIf}
                ${EndIf}
                ${If} $CheckState_Ex1_Exe == ${BST_CHECKED}
                    SetOutPath "$Path_Ex1\Mopy"
                    File "Mopy\w9xpopen.exe" "Mopy\Wrye Flash.exe"
                    ; Write the installation path into the registry
                    WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Extra Path 1 Standalone Version" "True"
                ${Else}
                    ${If} $Reg_Value_Ex1_Exe == $Empty ; ie don't overwrite it if it is installed but just not being installed that way this time.
                        WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Extra Path 1 Standalone Version" ""
                    ${EndIf}
                ${EndIf}
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Ex2 == ${BST_CHECKED}
            ; Install resources:
            ${If} Path_Ex2 != $Empty
                SetOutPath $Path_Ex2\Mopy
                File /r /x "*.svn*" /x "*.bat" /x "*.py*" /x "w9xpopen.exe" /x "Wrye Flash.exe" "Mopy\*.*"
                ; Write the installation path into the registry
                WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Extra Path 2" "$Path_Ex2"
                ${If} $CheckState_Ex2_Py == ${BST_CHECKED}
                    SetOutPath "$Path_Ex2\Mopy"
                    File /r "Mopy\*.py" "Mopy\*.pyw" "Mopy\*.bat"
                    ; Write the installation path into the registry
                    WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Extra Path 2 Python Version" "True"
                ${Else}
                    ${If} $Reg_Value_Ex2_Py == $Empty ; ie don't overwrite it if it is installed but just not being installed that way this time.
                        WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Extra Path 2 Python Version" ""
                    ${EndIf}
                ${EndIf}
                ${If} $CheckState_Ex2_Exe == ${BST_CHECKED}
                    SetOutPath "$Path_Ex2\Mopy"
                    File "Mopy\w9xpopen.exe" "Mopy\Wrye Flash.exe"
                    ; Write the installation path into the registry
                    WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Extra Path 2 Standalone Version" "True"
                ${Else}
                    ${If} $Reg_Value_Ex2_Exe == $Empty ; ie don't overwrite it if it is installed but just not being installed that way this time.
                        WriteRegStr HKLM "SOFTWARE\Wrye Flash" "Extra Path 2 Standalone Version" ""
                    ${EndIf}
                ${EndIf}
            ${EndIf}
        ${EndIf}
        ; Write the uninstall keys for Windows
        SetOutPath "$COMMONFILES\Wrye Flash"
        WriteRegStr HKLM "Software\Wrye Flash" "Installer Path" "$EXEPATH"
        WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Wrye Flash" "DisplayName" "Wrye Flash"
        WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Wrye Flash" "UninstallString" '"$COMMONFILES\Wrye Flash\uninstall.exe"'
        WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Wrye Flash" "URLInfoAbout" 'http://oblivion.nexusmods.com/mods/22368'
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
        ${If} $CheckState_Ex1 == ${BST_CHECKED}
            ${If} Path_Ex1 != $Empty
                SetOutPath $Path_Ex1\Mopy
                ${If} $CheckState_Ex1_Py == ${BST_CHECKED}
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Extra 1.lnk" "$Path_Ex1\Mopy\Wrye Flash Launcher.pyw" "" "$Path_Ex1\Mopy\bash\images\bash_32.ico" 0
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Extra 1 (Debug Log).lnk" "$Path_Ex1\Mopy\Wrye Flash Debug.bat" "" "$Path_Ex1\Mopy\bash\images\bash_32.ico" 0
                    ${If} $CheckState_Ex1_Exe == ${BST_CHECKED}
                        CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash (Standalone) - Extra 1.lnk" "$Path_Ex1\Mopy\Wrye Flash.exe"
                        CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash (Standalone) - Extra 1 (Debug Log).lnk" "$Path_Ex1\Mopy\Wrye Flash.exe" "-d"
                    ${EndIf}
                ${ElseIf} $CheckState_Ex1_Exe == ${BST_CHECKED}
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Extra 1.lnk" "$Path_Ex1\Mopy\Wrye Flash.exe"
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Extra 1 (Debug Log).lnk" "$Path_Ex1\Mopy\Wrye Flash.exe" "-d"
                ${EndIf}
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Ex2 == ${BST_CHECKED}
            ${If} Path_Ex2 != $Empty
                SetOutPath $Path_Ex2\Mopy
                ${If} $CheckState_Ex2_Py == ${BST_CHECKED}
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Extra 2.lnk" "$Path_Ex2\Mopy\Wrye Flash Launcher.pyw" "" "$Path_Ex2\Mopy\bash\images\bash_32.ico" 0
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Extra 2 (Debug Log).lnk" "$Path_Ex2\Mopy\Wrye Flash Debug.bat" "" "$Path_Ex2\Mopy\bash\images\bash_32.ico" 0
                    ${If} $CheckState_Ex2_Exe == ${BST_CHECKED}
                        CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash (Standalone) - Extra 2.lnk" "$Path_Ex2\Mopy\Wrye Flash.exe"
                        CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash (Standalone) - Extra 2 (Debug Log).lnk" "$Path_Ex2\Mopy\Wrye Flash.exe" "-d"
                    ${EndIf}
                ${ElseIf} $CheckState_Ex2_Exe == ${BST_CHECKED}
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Extra 2.lnk" "$Path_Ex2\Mopy\Wrye Flash.exe"
                    CreateShortCut "$SMPROGRAMS\Wrye Flash\Wrye Flash - Extra 2 (Debug Log).lnk" "$Path_Ex2\Mopy\Wrye Flash.exe" "-d"
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
        ${If} $Path_Nehrim_Remove != $Empty
            ${NSD_CreateCheckBox} 0 $0u 100% 13u "Nehrim"
                Pop $Check_Nehrim_Remove
                ${NSD_SetState} $Check_Nehrim_Remove $CheckState_Nehrim_Remove
            IntOp $0 $0 + 13
            ${NSD_CreateDirRequest} 0 $0u 90% 13u "$Path_Nehrim_Remove"
                Pop $PathDialogue_Nehrim_Remove
            ${NSD_CreateBrowseButton} -10% $0u 5% 13u "..."
                Pop $Browse_Nehrim_Remove
                nsDialogs::OnClick $Browse_Nehrim_Remove $Function_Browse
            IntOp $0 $0 + 13
        ${EndIf}
        ${If} $Path_Skyrim_Remove != $Empty
            ${NSD_CreateCheckBox} 0 $0u 100% 13u "&Skyrim"
                Pop $Check_Skyrim_Remove
                ${NSD_SetState} $Check_Skyrim_Remove $CheckState_Skyrim_Remove
            IntOp $0 $0 + 13
            ${NSD_CreateDirRequest} 0 $0u 90% 13u "$Path_Skyrim_Remove"
                Pop $PathDialogue_Skyrim_Remove
            ${NSD_CreateBrowseButton} -10% %0u 5% 13u "..."
                Pop $Browse_Skyrim_Remove
                nsDialogs::OnClick $Browse_Skyrim_Remove $Function_Browse
            IntOp $0 $0 + 13
        ${EndIf}
        ${If} $Path_Ex1 != $Empty
            ${NSD_CreateCheckBox} 0 $0u 100% 13u "Extra Location 1"
                Pop $Check_Ex1
                ${NSD_SetState} $Check_Ex1 $CheckState_Ex1
            IntOp $0 $0 + 13
            ${NSD_CreateDirRequest} 0 $0u 90% 13u "$Path_Ex1"
                Pop $PathDialogue_Ex1
            ${NSD_CreateBrowseButton} -10% $0u 5% 13u "..."
                Pop $Browse_Ex1
                nsDialogs::OnClick $Browse_Ex1 $Function_Browse
            IntOp $0 $0 + 13
        ${EndIf}
        ${If} $Path_Ex2 != $Empty
            ${NSD_CreateCheckBox} 0 $0u 100% 13u "Extra Location 2"
                Pop $Check_Ex2
                ${NSD_SetState} $Check_Ex2 $CheckState_Ex2
            IntOp $0 $0 + 13
            ${NSD_CreateDirRequest} 0 $0u 90% 13u "$Path_Ex2"
                Pop $PathDialogue_Ex2
            ${NSD_CreateBrowseButton} -10% $0u 5% 13u "..."
                Pop $Browse_Ex2
                nsDialogs::OnClick $Browse_Ex2 $Function_Browse
            IntOp $0 $0 + 13
        ${EndIf}
        ;${NSD_CreateCheckBox} 0 $0u 100% 13u "Uninstall userfiles/Bash data."
        ;    Pop $Check_RemoveUserFiles
        ;    ${NSD_SetState} $Check_RemoveUserFiles ${BST_CHECKED}
        nsDialogs::Show
    FunctionEnd

    Function un.PAGE_SELECT_GAMES_Leave
        ${NSD_GetText} $PathDialogue_NV $Path_NV
        ${NSD_GetText} $PathDialogue_Nehrim_Remove $Path_Nehrim_Remove
        ${NSD_GetText} $PathDialogue_Skyrim_Remove $Path_Skyrim_Remove
        ${NSD_GetText} $PathDialogue_Ex1 $Path_Ex1
        ${NSD_GetText} $PathDialogue_Ex2 $Path_Ex2
        ${NSD_GetState} $Check_NV $CheckState_NV
        ${NSD_GetState} $Check_Nehrim_Remove $CheckState_Nehrim_Remove
        ${NSD_GetState} $Check_Skyrim_Remove $CheckState_Skyrim_Remove
        ${NSD_GetState} $Check_Extra $CheckState_Extra
        ${NSD_GetState} $Check_Ex1 $CheckState_Ex1
        ${NSD_GetState} $Check_Ex2 $CheckState_Ex2
    FunctionEnd

    Function un.OnClick_Browse
        Pop $0
        ${If} $0 == $Browse_NV
            StrCpy $1 $PathDialogue_NV
        ${ElseIf} $0 == $Browse_Nehrim_Remove
            StrCpy $1 $PathDialogue_Nehrim_Remove
        ${ElseIf} $0 == $Browse_Skyrim_Remove
            StrCpy $1 $PathDialogue_Skyrim_Remove
        ${ElseIf} $0 == $Browse_Ex1
            StrCpy $1 $PathDialogue_Ex1
        ${ElseIf} $0 == $Browse_Ex2
            StrCpy $1 $PathDialogue_Ex2
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
                DeleteRegValue HKLM "SOFTWARE\Wrye Flash" "Oblivion Python Version"
                DeleteRegValue HKLM "SOFTWARE\Wrye Flash" "Oblivion Standalone Version"
                ;First delete OLD version files:
                Delete "$Path_NV\Data\Docs\Bashed Lists.txt"
                Delete "$Path_NV\Data\Docs\Bashed Lists.html"
                Delete "$Path_NV\Mopy\uninstall.exe"
                Delete "$Path_NV\Data\Ini Tweaks\Autosave, Never [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Autosave, ~Always [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Border Regions, Disabled [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Border Regions, ~Enabled [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Fonts 1, ~Default [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Fonts, ~Default [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Grass, Fade 4k-5k [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Grass, ~Fade 2k-3k [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Intro Movies, Disabled [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Intro Movies, ~Normal [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Joystick, Disabled [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Joystick, ~Enabled [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Local Map Shader, Disabled [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Local Map Shader, ~Enabled [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Music, Disabled [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Music, ~Enabled [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Refraction Shader, Disabled [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Refraction Shader, ~Enabled [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Save Backups, 1 [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Save Backups, 2 [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Save Backups, 3 [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Save Backups, 5 [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Screenshot, Enabled [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Screenshot, ~Disabled [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\ShadowMapResolution, 10 [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\ShadowMapResolution, ~256 [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\ShadowMapResolution, 1024 [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound Card Channels, 24 [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound Card Channels, ~32 [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound Card Channels, 128 [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound Card Channels, 16 [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound Card Channels, 192 [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound Card Channels, 48 [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound Card Channels, 64 [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound Card Channels, 8 [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound Card Channels, 96 [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound, Disabled [Oblivion].ini"
                Delete "$Path_NV\Data\Ini Tweaks\Sound, ~Enabled [Oblivion].ini"
                Delete "$Path_NV\Data\Bash Patches\Assorted to Cobl.csv"
                Delete "$Path_NV\Data\Bash Patches\Assorted_Exhaust.csv"
                Delete "$Path_NV\Data\Bash Patches\Bash_Groups.csv"
                Delete "$Path_NV\Data\Bash Patches\Bash_MFact.csv"
                Delete "$Path_NV\Data\Bash Patches\ShiveringIsleTravellers_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\TamrielTravellers_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\Guard_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\Kmacg94_Exhaust.csv"
                Delete "$Path_NV\Data\Bash Patches\P1DCandles_Formids.csv"
                Delete "$Path_NV\Data\Bash Patches\OOO_Potion_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\Random_NPC_Alternate_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\Random_NPC_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\Rational_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\TI to Cobl_Formids.csv"
                Delete "$Path_NV\Data\Bash Patches\taglist.txt"
                Delete "$Path_NV\Data\Bash Patches\OOO, 1.23 Mincapped_NPC_Levels.csv"
                Delete "$Path_NV\Data\Bash Patches\OOO, 1.23 Uncapped_NPC_Levels.csv"
                Delete "$Path_NV\Data\Bash Patches\Crowded Cities 15_Alternate_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\Crowded Cities 15_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\Crowded Cities 30_Alternate_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\Crowded Cities 30_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\Crowded Roads Revamped_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\Crowded Roads Revisited_Alternate_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\Crowded Roads Revisited_Names.csv"
                Delete "$Path_NV\Data\Bash Patches\PTRoamingNPCs_Names.csv"
                Delete "$Path_NV\Mopy\Wrye Flash Advanced Readme.html"
                Delete "$Path_NV\Mopy\Wrye Flash General Readme.html"
                Delete "$Path_NV\Mopy\Wrye Flash Technical Readme.html"
                Delete "$Path_NV\Mopy\Wrye Flash Version History.html"
                ;As of 294 the below are obselete locations or files.
                Delete "$Path_NV\Mopy\7z.*"
                Delete "$Path_NV\Mopy\CBash.dll"
                Delete "$Path_NV\Mopy\Data\Italian.*"
                Delete "$Path_NV\Mopy\Data\Oblivion_ids.pkl"
                Delete "$Path_NV\Mopy\Data\Russian.*"
                Delete "$Path_NV\Mopy\Data\de.*"
                Delete "$Path_NV\Mopy\Data\pt_opt.*"
                Delete "$Path_NV\Mopy\Data\Actor Levels\OOO, 1.23 Mincapped.csv"
                Delete "$Path_NV\Mopy\Data\Actor Levels\OOO, 1.23 Uncapped.csv"
                RMDir  "$Path_NV\Mopy\Data\Actor Levels"
                RMDir  "$Path_NV\Mopy\Data"
                Delete "$Path_NV\Mopy\DebugLog(Python2.6).bat"
                Delete "$Path_NV\Mopy\Extras\*"
                Delete "$Path_NV\Mopy\ScriptParser.p*"
                Delete "$Path_NV\Mopy\balt.p*"
                Delete "$Path_NV\Mopy\barb.p*"
                Delete "$Path_NV\Mopy\barg.p*"
                Delete "$Path_NV\Mopy\bash.p*"
                Delete "$Path_NV\Mopy\basher.p*"
                Delete "$Path_NV\Mopy\bashmon.p*"
                Delete "$Path_NV\Mopy\belt.p*"
                Delete "$Path_NV\Mopy\bish.p*"
                Delete "$Path_NV\Mopy\bolt.p*"
                Delete "$Path_NV\Mopy\bosh.p*"
                Delete "$Path_NV\Mopy\bush.p*"
                Delete "$Path_NV\Mopy\cint.p*"
                Delete "$Path_NV\Mopy\gpl.txt"
                Delete "$Path_NV\Mopy\images\*"
                RMDir  "$Path_NV\Mopy\images"
                Delete "$Path_NV\Mopy\lzma.exe"
                ;Current files:
                Delete "$Path_NV\Mopy\Wrye Flash.txt"
                Delete "$Path_NV\Mopy\Wrye Flash.html"
                Delete "$Path_NV\Mopy\Wrye Flash.exe"
                Delete "$Path_NV\Mopy\Wrye Flash.exe.log"
                Delete "$Path_NV\Mopy\Wrye Flash Launcher.p*"
                Delete "$Path_NV\Mopy\Wrye Flash Debug.p*"
                Delete "$Path_NV\Mopy\wizards.txt"
                Delete "$Path_NV\Mopy\wizards.html"
                Delete "$Path_NV\Mopy\Wizard Images\*.*"
                Delete "$Path_NV\Mopy\w9xpopen.exe"
                Delete "$Path_NV\Mopy\templates\skyrim\*.*"
                Delete "$Path_NV\Mopy\templates\oblivion\*.*"
                Delete "$Path_NV\Mopy\templates\*.*"
                Delete "$Path_NV\Mopy\templates\*"
                Delete "$Path_NV\Mopy\patch_option_reference.txt"
                Delete "$Path_NV\Mopy\patch_option_reference.html"
                Delete "$Path_NV\Mopy\license.txt"
                Delete "$Path_NV\Mopy\Ini Tweaks\Skyrim\*.*"
                Delete "$Path_NV\Mopy\Ini Tweaks\Oblivion\*.*"
                Delete "$Path_NV\Mopy\Docs\Wrye Flash Version History.html"
                Delete "$Path_NV\Mopy\Docs\Wrye Flash Technical Readme.html"
                Delete "$Path_NV\Mopy\Docs\Wrye Flash General Readme.html"
                Delete "$Path_NV\Mopy\Docs\Wrye Flash Advanced Readme.html"
                Delete "$Path_NV\Mopy\Docs\Bash Readme Template.txt"
                Delete "$Path_NV\Mopy\Docs\Bash Readme Template.html"
                Delete "$Path_NV\Mopy\Docs\wtxt_teal.css"
                Delete "$Path_NV\Mopy\Docs\wtxt_sand_small.css"
                Delete "$Path_NV\Mopy\bash\windows.pyo"
                Delete "$Path_NV\Mopy\bash\ScriptParsero"
                Delete "$Path_NV\Mopy\bash\ScriptParsero.py"
                Delete "$Path_NV\Mopy\bash\ScriptParser.p*"
                Delete "$Path_NV\Mopy\bash\Rename_CBash.dll"
                Delete "$Path_NV\Mopy\bash\l10n\Russian.*"
                Delete "$Path_NV\Mopy\bash\l10n\pt_opt.*"
                Delete "$Path_NV\Mopy\bash\l10n\Italian.*"
                Delete "$Path_NV\Mopy\bash\l10n\de.*"
                Delete "$Path_NV\Mopy\bash\l10n\Chinese*.*"
                Delete "$Path_NV\Mopy\bash\liblo.pyo"
                Delete "$Path_NV\Mopy\bash\libbsa.pyo"
                Delete "$Path_NV\Mopy\bash\libbsa.py"
                Delete "$Path_NV\Mopy\bash\images\tools\*.*"
                Delete "$Path_NV\Mopy\bash\images\readme\*.*"
                Delete "$Path_NV\Mopy\bash\images\nsis\*.*"
                Delete "$Path_NV\Mopy\bash\images\*"
                Delete "$Path_NV\Mopy\bash\gpl.txt"
                Delete "$Path_NV\Mopy\bash\game\*"
                Delete "$Path_NV\Mopy\bash\db\Skyrim_ids.pkl"
                Delete "$Path_NV\Mopy\bash\db\Oblivion_ids.pkl"
                Delete "$Path_NV\Mopy\bash\compiled\Microsoft.VC80.CRT\*"
                Delete "$Path_NV\Mopy\bash\compiled\*"
                Delete "$Path_NV\Mopy\bash\windowso"
                Delete "$Path_NV\Mopy\bash\libbsao"
                Delete "$Path_NV\Mopy\bash\cinto"
                Delete "$Path_NV\Mopy\bash\cint.p*"
                Delete "$Path_NV\Mopy\bash\chardet\*"
                Delete "$Path_NV\Mopy\bash\bwebo"
                Delete "$Path_NV\Mopy\bash\bweb.p*"
                Delete "$Path_NV\Mopy\bash\busho"
                Delete "$Path_NV\Mopy\bash\bush.p*"
                Delete "$Path_NV\Mopy\bash\breco"
                Delete "$Path_NV\Mopy\bash\brec.p*"
                Delete "$Path_NV\Mopy\bash\bosho"
                Delete "$Path_NV\Mopy\bash\bosh.p*"
                Delete "$Path_NV\Mopy\bash\Bolto"
                Delete "$Path_NV\Mopy\bash\bolt.p*"
                Delete "$Path_NV\Mopy\bash\bish.p*"
                Delete "$Path_NV\Mopy\bash\belto"
                Delete "$Path_NV\Mopy\bash\belt.p*"
                Delete "$Path_NV\Mopy\bash\basso"
                Delete "$Path_NV\Mopy\bash\bass.p*"
                Delete "$Path_NV\Mopy\bash\basho"
                Delete "$Path_NV\Mopy\bash\bashmon.p*"
                Delete "$Path_NV\Mopy\bash\bashero"
                Delete "$Path_NV\Mopy\bash\basher.p*"
                Delete "$Path_NV\Mopy\bash\bash.p*"
                Delete "$Path_NV\Mopy\bash\bargo"
                Delete "$Path_NV\Mopy\bash\barg.p*"
                Delete "$Path_NV\Mopy\bash\barbo"
                Delete "$Path_NV\Mopy\bash\barb.p*"
                Delete "$Path_NV\Mopy\bash\bapio"
                Delete "$Path_NV\Mopy\bash\bapi.p*"
                Delete "$Path_NV\Mopy\bash\balto"
                Delete "$Path_NV\Mopy\bash\balt.p*"
                Delete "$Path_NV\Mopy\bash\*.pyc"
                Delete "$Path_NV\Mopy\bash\*.py"
                Delete "$Path_NV\Mopy\bash\*.bat"
                Delete "$Path_NV\Mopy\bash\__init__.p*"
                Delete "$Path_NV\Mopy\bash.ini"
                Delete "$Path_NV\Mopy\bash_default.ini"
                Delete "$Path_NV\Mopy\bash_default_Russian.ini"
                Delete "$Path_NV\Mopy\Bash Patches\Skyrim\*.*"
                Delete "$Path_NV\Mopy\Bash Patches\Oblivion\*.*"
                Delete "$Path_NV\Mopy\*.log"
                Delete "$Path_NV\Mopy\*.bat"
                Delete "$Path_NV\Mopy\bash.ico"
                Delete "$Path_NV\Data\Docs\Bashed patch*.*"
                Delete "$Path_NV\Data\ArchiveInvalidationInvalidated!.bsa"
                RMDir  "$Path_NV\Mopy\Wizard Images"
                RMDir  "$Path_NV\Mopy\templates\skyrim"
                RMDir  "$Path_NV\Mopy\templates\oblivion"
                RMDir  "$Path_NV\Mopy\templates"
                RMDir  "$Path_NV\Mopy\Ini Tweaks\Skyrim"
                RMDir  "$Path_NV\Mopy\Ini Tweaks\Oblivion"
                RMDir  "$Path_NV\Mopy\Ini Tweaks"
                RMDir  "$Path_NV\Mopy\Docs"
                RMDir  "$Path_NV\Mopy\bash\l10n"
                RMDir  "$Path_NV\Mopy\bash\images\tools"
                RMDir  "$Path_NV\Mopy\bash\images\readme"
                RMDir  "$Path_NV\Mopy\bash\images\nsis"
                RMDir  "$Path_NV\Mopy\bash\images"
                RMDir  "$Path_NV\Mopy\bash\game"
                RMDir  "$Path_NV\Mopy\bash\db"
                RMDir  "$Path_NV\Mopy\bash\compiled\Microsoft.VC80.CRT"
                RMDir  "$Path_NV\Mopy\bash\compiled"
                RMDir  "$Path_NV\Mopy\bash\chardet"
                RMDir  "$Path_NV\Mopy\bash"
                RMDir  "$Path_NV\Mopy\Bash Patches\Skyrim"
                RMDir  "$Path_NV\Mopy\Bash Patches\Oblivion"
                RMDir  "$Path_NV\Mopy\Bash Patches"
                RMDir  "$Path_NV\Mopy\Apps"
                RMDir  "$Path_NV\Mopy"
                RMDir  "$Path_NV\Data\Ini Tweaks"
                RMDir  "$Path_NV\Data\Docs"
                RMDir  "$Path_NV\Data\Bash Patches"
                Delete "$SMPROGRAMS\Wrye Flash\*oblivion*"
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Nehrim_Remove == ${BST_CHECKED}
            ${If} $Path_Nehrim_Remove != $Empty
                DeleteRegValue HKLM "SOFTWARE\Wrye Flash" "Nehrim Path"
                DeleteRegValue HKLM "SOFTWARE\Wrye Flash" "Nehrim Python Version"
                DeleteRegValue HKLM "SOFTWARE\Wrye Flash" "Nehrim Standalone Version"
                ;First delete OLD version files:
                Delete "$Path_Nehrim_Remove\Data\Docs\Bashed Lists.txt"
                Delete "$Path_Nehrim_Remove\Data\Docs\Bashed Lists.html"
                Delete "$Path_Nehrim_Remove\Mopy\uninstall.exe"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Autosave, Never.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Autosave, ~Always.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Border Regions, Disabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Border Regions, ~Enabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Fonts 1, ~Default.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Fonts, ~Default.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Grass, Fade 4k-5k.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Intro Movies, Disabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Intro Movies, Normal.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Joystick, ~Disabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Joystick, ~Enabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Local Map Shader, Disabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Local Map Shader, ~Enabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Music, Disabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Music, Enabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Refraction Shader, Disabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Refraction Shader, ~Enabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Save Backups, 1.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Save Backups, 2.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Save Backups, 3.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Save Backups, 5.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Screenshot, ~Disabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Screenshot, ~ENabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\ShadowMapResolution, 1024.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\ShadowMapResolution, 256 [default].ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound Card Channels, 8.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound Card Channels, 16.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound Card Channels, 24.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound Card Channels, 48.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound Card Channels, 64.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound Card Channels, 96.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound Card Channels, 128.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound Card Channels, 192.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound Card Channels, ~ [Oblivion].ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound Card Channels,  [Oblivion].ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound, Disabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Ini Tweaks\Sound, Enabled.ini"
                Delete "$Path_Nehrim_Remove\Data\Bash Patches\Crowded Cities 15_Alternate_Names.csv"
                Delete "$Path_Nehrim_Remove\Data\Bash Patches\Crowded Cities 15_Names.csv"
                Delete "$Path_Nehrim_Remove\Data\Bash Patches\Crowded Cities 30_Alternate_Names.csv"
                Delete "$Path_Nehrim_Remove\Data\Bash Patches\Crowded Cities 30_Names.csv"
                Delete "$Path_Nehrim_Remove\Data\Bash Patches\Crowded Roads Revamped_Names.csv"
                Delete "$Path_Nehrim_Remove\Data\Bash Patches\Crowded Roads Revisited_Alternate_Names.csv"
                Delete "$Path_Nehrim_Remove\Data\Bash Patches\Crowded Roads Revisited_Names.csv"
                Delete "$Path_Nehrim_Remove\Data\Bash Patches\PTRoamingNPCs_Names.csv"
                Delete "$Path_Nehrim_Remove\Mopy\Wrye Flash Advanced Readme.html"
                Delete "$Path_Nehrim_Remove\Mopy\Wrye Flash General Readme.html"
                Delete "$Path_Nehrim_Remove\Mopy\Wrye Flash Technical Readme.html"
                Delete "$Path_Nehrim_Remove\Mopy\Wrye Flash Version History.html"
                ;As of 294 the below are obselete locations or files.
                Delete "$Path_Nehrim_Remove\Mopy\7z.*"
                Delete "$Path_Nehrim_Remove\Mopy\CBash.dll"
                Delete "$Path_Nehrim_Remove\Mopy\Data\Italian.*"
                Delete "$Path_Nehrim_Remove\Mopy\Data\Oblivion_ids.pkl"
                Delete "$Path_Nehrim_Remove\Mopy\Data\Russian.*"
                Delete "$Path_Nehrim_Remove\Mopy\Data\de.*"
                Delete "$Path_Nehrim_Remove\Mopy\Data\pt_opt.*"
                Delete "$Path_Nehrim_Remove\Mopy\Data\Actor Levels\OOO, 1.23 Mincapped.csv"
                Delete "$Path_Nehrim_Remove\Mopy\Data\Actor Levels\OOO, 1.23 Uncapped.csv"
                RMDir  "$Path_Nehrim_Remove\Mopy\Data\Actor Levels"
                RMDir  "$Path_Nehrim_Remove\Mopy\Data"
                Delete "$Path_Nehrim_Remove\Mopy\DebugLog(Python2.6).bat"
                Delete "$Path_Nehrim_Remove\Mopy\Extras\*"
                Delete "$Path_Nehrim_Remove\Mopy\ScriptParser.p*"
                Delete "$Path_Nehrim_Remove\Mopy\balt.p*"
                Delete "$Path_Nehrim_Remove\Mopy\barb.p*"
                Delete "$Path_Nehrim_Remove\Mopy\barg.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash.p*"
                Delete "$Path_Nehrim_Remove\Mopy\basher.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bashmon.p*"
                Delete "$Path_Nehrim_Remove\Mopy\belt.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bish.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bolt.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bosh.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bush.p*"
                Delete "$Path_Nehrim_Remove\Mopy\cint.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\keywordWIZBAIN.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\keywordWIZBAIN2.p*"
                Delete "$Path_Nehrim_Remove\Mopy\gpl.txt"
                Delete "$Path_Nehrim_Remove\Mopy\images\*"
                RMDir  "$Path_Nehrim_Remove\Mopy\images"
                Delete "$Path_Nehrim_Remove\Mopy\lzma.exe"
                ;Current files:
                Delete "$Path_Nehrim_Remove\Mopy\Wrye Flash.txt"
                Delete "$Path_Nehrim_Remove\Mopy\Wrye Flash.html"
                Delete "$Path_Nehrim_Remove\Mopy\Wrye Flash.exe"
                Delete "$Path_Nehrim_Remove\Mopy\Wrye Flash.exe.log"
                Delete "$Path_Nehrim_Remove\Mopy\Wrye Flash Launcher.p*"
                Delete "$Path_Nehrim_Remove\Mopy\Wrye Flash Debug.p*"
                Delete "$Path_Nehrim_Remove\Mopy\wizards.txt"
                Delete "$Path_Nehrim_Remove\Mopy\wizards.html"
                Delete "$Path_Nehrim_Remove\Mopy\Wizard Images\*.*"
                Delete "$Path_Nehrim_Remove\Mopy\w9xpopen.exe"
                Delete "$Path_Nehrim_Remove\Mopy\templates\skyrim\*.*"
                Delete "$Path_Nehrim_Remove\Mopy\templates\oblivion\*.*"
                Delete "$Path_Nehrim_Remove\Mopy\templates\*.*"
                Delete "$Path_Nehrim_Remove\Mopy\templates\*"
                Delete "$Path_Nehrim_Remove\Mopy\patch_option_reference.txt"
                Delete "$Path_Nehrim_Remove\Mopy\patch_option_reference.html"
                Delete "$Path_Nehrim_Remove\Mopy\license.txt"
                Delete "$Path_Nehrim_Remove\Mopy\Ini Tweaks\Skyrim\*.*"
                Delete "$Path_Nehrim_Remove\Mopy\Ini Tweaks\Oblivion\*.*"
                Delete "$Path_Nehrim_Remove\Mopy\Docs\Wrye Flash Version History.html"
                Delete "$Path_Nehrim_Remove\Mopy\Docs\Wrye Flash Technical Readme.html"
                Delete "$Path_Nehrim_Remove\Mopy\Docs\Wrye Flash General Readme.html"
                Delete "$Path_Nehrim_Remove\Mopy\Docs\Wrye Flash Advanced Readme.html"
                Delete "$Path_Nehrim_Remove\Mopy\Docs\wtxt_teal.css"
                Delete "$Path_Nehrim_Remove\Mopy\Docs\wtxt_sand_small.css"
                Delete "$Path_Nehrim_Remove\Mopy\Docs\Bash Readme Template.txt"
                Delete "$Path_Nehrim_Remove\Mopy\Docs\Bash Readme Template.html"
                Delete "$Path_Nehrim_Remove\Mopy\bash\windows.pyo"
                Delete "$Path_Nehrim_Remove\Mopy\bash\ScriptParsero"
                Delete "$Path_Nehrim_Remove\Mopy\bash\ScriptParsero.py"
                Delete "$Path_Nehrim_Remove\Mopy\bash\ScriptParser.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\Rename_CBash.dll"
                Delete "$Path_Nehrim_Remove\Mopy\bash\l10n\Russian.*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\l10n\pt_opt.*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\l10n\Italian.*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\l10n\de.*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\l10n\Chinese*.*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\liblo.pyo"
                Delete "$Path_Nehrim_Remove\Mopy\bash\libbsa.pyo"
                Delete "$Path_Nehrim_Remove\Mopy\bash\libbsa.py"
                Delete "$Path_Nehrim_Remove\Mopy\bash\images\tools\*.*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\images\readme\*.*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\images\nsis\*.*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\images\*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\gpl.txt"
                Delete "$Path_Nehrim_Remove\Mopy\bash\game\*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\db\Skyrim_ids.pkl"
                Delete "$Path_Nehrim_Remove\Mopy\bash\db\Oblivion_ids.pkl"
                Delete "$Path_Nehrim_Remove\Mopy\bash\compiled\Microsoft.VC80.CRT\*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\compiled\*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\windowso"
                Delete "$Path_Nehrim_Remove\Mopy\bash\libbsao"
                Delete "$Path_Nehrim_Remove\Mopy\bash\cinto"
                Delete "$Path_Nehrim_Remove\Mopy\bash\cint.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\chardet\*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\bwebo"
                Delete "$Path_Nehrim_Remove\Mopy\bash\bweb.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\busho"
                Delete "$Path_Nehrim_Remove\Mopy\bash\bush.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\breco"
                Delete "$Path_Nehrim_Remove\Mopy\bash\brec.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\bosho"
                Delete "$Path_Nehrim_Remove\Mopy\bash\bosh.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\Bolto"
                Delete "$Path_Nehrim_Remove\Mopy\bash\bolt.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\bish.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\belto"
                Delete "$Path_Nehrim_Remove\Mopy\bash\belt.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\basso"
                Delete "$Path_Nehrim_Remove\Mopy\bash\bass.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\basho"
                Delete "$Path_Nehrim_Remove\Mopy\bash\bashmon.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\bashero"
                Delete "$Path_Nehrim_Remove\Mopy\bash\basher.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\bash.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\bargo"
                Delete "$Path_Nehrim_Remove\Mopy\bash\barg.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\barbo"
                Delete "$Path_Nehrim_Remove\Mopy\bash\barb.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\bapio"
                Delete "$Path_Nehrim_Remove\Mopy\bash\bapi.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\balto"
                Delete "$Path_Nehrim_Remove\Mopy\bash\balt.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash\*.pyc"
                Delete "$Path_Nehrim_Remove\Mopy\bash\*.py"
                Delete "$Path_Nehrim_Remove\Mopy\bash\*.bat"
                Delete "$Path_Nehrim_Remove\Mopy\bash\__init__.p*"
                Delete "$Path_Nehrim_Remove\Mopy\bash.ini"
                Delete "$Path_Nehrim_Remove\Mopy\bash_default.ini"
                Delete "$Path_Nehrim_Remove\Mopy\bash_default_Russian.ini"
                Delete "$Path_Nehrim_Remove\Mopy\Bash Patches\Skyrim\*.*"
                Delete "$Path_Nehrim_Remove\Mopy\Bash Patches\Oblivion\*.*"
                Delete "$Path_Nehrim_Remove\Mopy\*.log"
                Delete "$Path_Nehrim_Remove\Mopy\*.bat"
                Delete "$Path_Nehrim_Remove\Mopy\bash.ico"
                Delete "$Path_Nehrim_Remove\Data\Docs\Bashed patch*.*"
                Delete "$Path_Nehrim_Remove\Data\ArchiveInvalidationInvalidated!.bsa"
                RMDir  "$Path_Nehrim_Remove\Mopy\Wizard Images"
                RMDir  "$Path_Nehrim_Remove\Mopy\templates\skyrim"
                RMDir  "$Path_Nehrim_Remove\Mopy\templates\oblivion"
                RMDir  "$Path_Nehrim_Remove\Mopy\templates"
                RMDir  "$Path_Nehrim_Remove\Mopy\Ini Tweaks\Skyrim"
                RMDir  "$Path_Nehrim_Remove\Mopy\Ini Tweaks\Oblivion"
                RMDir  "$Path_Nehrim_Remove\Mopy\Ini Tweaks"
                RMDir  "$Path_Nehrim_Remove\Mopy\Docs"
                RMDir  "$Path_Nehrim_Remove\Mopy\bash\l10n"
                RMDir  "$Path_Nehrim_Remove\Mopy\bash\images\tools"
                RMDir  "$Path_Nehrim_Remove\Mopy\bash\images\readme"
                RMDir  "$Path_Nehrim_Remove\Mopy\bash\images\nsis"
                RMDir  "$Path_Nehrim_Remove\Mopy\bash\images"
                RMDir  "$Path_Nehrim_Remove\Mopy\bash\game"
                RMDir  "$Path_Nehrim_Remove\Mopy\bash\db"
                RMDir  "$Path_Nehrim_Remove\Mopy\bash\compiled\Microsoft.VC80.CRT"
                RMDir  "$Path_Nehrim_Remove\Mopy\bash\compiled"
                RMDir  "$Path_Nehrim_Remove\Mopy\bash\chardet"
                RMDir  "$Path_Nehrim_Remove\Mopy\bash"
                RMDir  "$Path_Nehrim_Remove\Mopy\Bash Patches\Skyrim"
                RMDir  "$Path_Nehrim_Remove\Mopy\Bash Patches\Oblivion"
                RMDir  "$Path_Nehrim_Remove\Mopy\Bash Patches"
                RMDir  "$Path_Nehrim_Remove\Mopy\Apps"
                RMDir  "$Path_Nehrim_Remove\Mopy"
                RMDir  "$Path_Nehrim_Remove\Data\Ini Tweaks"
                RMDir  "$Path_Nehrim_Remove\Data\Docs"
                RMDir  "$Path_Nehrim_Remove\Data\Bash Patches"
                Delete "$SMPROGRAMS\Wrye Flash\*Nehrim*"
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Skyrim_Remove == ${BST_CHECKED}
            ${If} $Path_Skyrim_Remove != $Empty
                DeleteRegValue HKLM "SOFTWARE\Wrye Flash" "Skyrim Path"
                DeleteRegValue HKLM "SOFTWARE\Wrye Flash" "Skyrim Python Version"
                DeleteRegValue HKLM "SOFTWARE\Wrye Flash" "Skyrim Standalone Version"
                ;First delete OLD version files:
                Delete "$Path_Skyrim_Remove\Data\Docs\Bashed Lists.txt"
                Delete "$Path_Skyrim_Remove\Data\Docs\Bashed Lists.html"
                Delete "$Path_Skyrim_Remove\Mopy\uninstall.exe"
                Delete "$Path_Skyrim_Remove\Data\ArchiveInvalidationInvalidated!.bsa"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Assorted to Cobl.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Assorted_Exhaust.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Bash_Groups.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Bash_MFact.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\ShiveringIsleTravellers_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\TamrielTravellers_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Guard_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Kmacg94_Exhaust.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\P1DCandles_Formids.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\OOO_Potion_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Random_NPC_Alternate_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Random_NPC_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Rational_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\TI to Cobl_Formids.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\taglist.txt"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\OOO, 1.23 Mincapped_NPC_Levels.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\OOO, 1.23 Uncapped_NPC_Levels.csv"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Autosave, Never.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Autosave, ~Always.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Border Regions, Disabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Border Regions, ~Enabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Fonts 1, ~Default.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Fonts, ~Default.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Grass, Fade 4k-5k.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Intro Movies, Disabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Intro Movies, Normal.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Joystick, ~Disabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Joystick, ~Enabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Local Map Shader, Disabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Local Map Shader, ~Enabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Music, Disabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Music, Enabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Refraction Shader, Disabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Refraction Shader, ~Enabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Save Backups, 1.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Save Backups, 2.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Save Backups, 3.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Save Backups, 5.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Screenshot, ~Disabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Screenshot, ~ENabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\ShadowMapResolution, 1024.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\ShadowMapResolution, 256 [default].ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound Card Channels, 8.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound Card Channels, 16.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound Card Channels, 24.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound Card Channels, 48.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound Card Channels, 64.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound Card Channels, 96.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound Card Channels, 128.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound Card Channels, 192.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound Card Channels, ~ [Oblivion].ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound Card Channels,  [Oblivion].ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound, Disabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Ini Tweaks\Sound, Enabled.ini"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Crowded Cities 15_Alternate_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Crowded Cities 15_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Crowded Cities 30_Alternate_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Crowded Cities 30_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Crowded Roads Revamped_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Crowded Roads Revisited_Alternate_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\Crowded Roads Revisited_Names.csv"
                Delete "$Path_Skyrim_Remove\Data\Bash Patches\PTRoamingNPCs_Names.csv"
                Delete "$Path_Skyrim_Remove\Mopy\Wrye Flash Advanced Readme.html"
                Delete "$Path_Skyrim_Remove\Mopy\Wrye Flash General Readme.html"
                Delete "$Path_Skyrim_Remove\Mopy\Wrye Flash Technical Readme.html"
                Delete "$Path_Skyrim_Remove\Mopy\Wrye Flash Version History.html"
                ;As of 294 the below are obselete locations or files.
                Delete "$Path_Skyrim_Remove\Mopy\7z.*"
                Delete "$Path_Skyrim_Remove\Mopy\CBash.dll"
                Delete "$Path_Skyrim_Remove\Mopy\Data\Italian.*"
                Delete "$Path_Skyrim_Remove\Mopy\Data\Oblivion_ids.pkl"
                Delete "$Path_Skyrim_Remove\Mopy\Data\Russian.*"
                Delete "$Path_Skyrim_Remove\Mopy\Data\de.*"
                Delete "$Path_Skyrim_Remove\Mopy\Data\pt_opt.*"
                Delete "$Path_Skyrim_Remove\Mopy\Data\Actor Levels\OOO, 1.23 Mincapped.csv"
                Delete "$Path_Skyrim_Remove\Mopy\Data\Actor Levels\OOO, 1.23 Uncapped.csv"
                RMDir  "$Path_Skyrim_Remove\Mopy\Data\Actor Levels"
                RMDir  "$Path_Skyrim_Remove\Mopy\Data"
                Delete "$Path_Skyrim_Remove\Mopy\DebugLog(Python2.6).bat"
                Delete "$Path_Skyrim_Remove\Mopy\Extras\*"
                Delete "$Path_Skyrim_Remove\Mopy\ScriptParser.p*"
                Delete "$Path_Skyrim_Remove\Mopy\balt.p*"
                Delete "$Path_Skyrim_Remove\Mopy\barb.p*"
                Delete "$Path_Skyrim_Remove\Mopy\barg.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash.p*"
                Delete "$Path_Skyrim_Remove\Mopy\basher.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bashmon.p*"
                Delete "$Path_Skyrim_Remove\Mopy\belt.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bish.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bolt.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bosh.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bush.p*"
                Delete "$Path_Skyrim_Remove\Mopy\cint.p*"
                Delete "$Path_Skyrim_Remove\Mopy\gpl.txt"
                Delete "$Path_Skyrim_Remove\Mopy\images\*"
                RMDir  "$Path_Skyrim_Remove\Mopy\images"
                Delete "$Path_Skyrim_Remove\Mopy\lzma.exe"
                ;Current files:
                Delete "$Path_Skyrim_Remove\Mopy\Wrye Flash.txt"
                Delete "$Path_Skyrim_Remove\Mopy\Wrye Flash.html"
                Delete "$Path_Skyrim_Remove\Mopy\Wrye Flash.exe"
                Delete "$Path_Skyrim_Remove\Mopy\Wrye Flash.exe.log"
                Delete "$Path_Skyrim_Remove\Mopy\Wrye Flash Launcher.p*"
                Delete "$Path_Skyrim_Remove\Mopy\Wrye Flash Debug.p*"
                Delete "$Path_Skyrim_Remove\Mopy\wizards.txt"
                Delete "$Path_Skyrim_Remove\Mopy\wizards.html"
                Delete "$Path_Skyrim_Remove\Mopy\Wizard Images\*.*"
                Delete "$Path_Skyrim_Remove\Mopy\w9xpopen.exe"
                Delete "$Path_Skyrim_Remove\Mopy\templates\skyrim\*.*"
                Delete "$Path_Skyrim_Remove\Mopy\templates\oblivion\*.*"
                Delete "$Path_Skyrim_Remove\Mopy\templates\*.*"
                Delete "$Path_Skyrim_Remove\Mopy\templates\*"
                Delete "$Path_Skyrim_Remove\Mopy\patch_option_reference.txt"
                Delete "$Path_Skyrim_Remove\Mopy\patch_option_reference.html"
                Delete "$Path_Skyrim_Remove\Mopy\license.txt"
                Delete "$Path_Skyrim_Remove\Mopy\Ini Tweaks\Skyrim\*.*"
                Delete "$Path_Skyrim_Remove\Mopy\Ini Tweaks\Oblivion\*.*"
                Delete "$Path_Skyrim_Remove\Mopy\Docs\Wrye Flash Version History.html"
                Delete "$Path_Skyrim_Remove\Mopy\Docs\Wrye Flash Technical Readme.html"
                Delete "$Path_Skyrim_Remove\Mopy\Docs\Wrye Flash General Readme.html"
                Delete "$Path_Skyrim_Remove\Mopy\Docs\Wrye Flash Advanced Readme.html"
                Delete "$Path_Skyrim_Remove\Mopy\Docs\wtxt_teal.css"
                Delete "$Path_Skyrim_Remove\Mopy\Docs\wtxt_sand_small.css"
                Delete "$Path_Skyrim_Remove\Mopy\Docs\Bash Readme Template.txt"
                Delete "$Path_Skyrim_Remove\Mopy\Docs\Bash Readme Template.html"
                Delete "$Path_Skyrim_Remove\Mopy\bash\windows.pyo"
                Delete "$Path_Skyrim_Remove\Mopy\bash\ScriptParsero"
                Delete "$Path_Skyrim_Remove\Mopy\bash\ScriptParsero.py"
                Delete "$Path_Skyrim_Remove\Mopy\bash\ScriptParser.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\Rename_CBash.dll"
                Delete "$Path_Skyrim_Remove\Mopy\bash\l10n\Russian.*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\l10n\pt_opt.*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\l10n\Italian.*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\l10n\de.*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\l10n\Chinese*.*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\liblo.pyo"
                Delete "$Path_Skyrim_Remove\Mopy\bash\libbsa.pyo"
                Delete "$Path_Skyrim_Remove\Mopy\bash\libbsa.py"
                Delete "$Path_Skyrim_Remove\Mopy\bash\images\tools\*.*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\images\readme\*.*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\images\nsis\*.*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\images\*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\gpl.txt"
                Delete "$Path_Skyrim_Remove\Mopy\bash\game\*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\db\Skyrim_ids.pkl"
                Delete "$Path_Skyrim_Remove\Mopy\bash\db\Oblivion_ids.pkl"
                Delete "$Path_Skyrim_Remove\Mopy\bash\compiled\Microsoft.VC80.CRT\*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\compiled\*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\windowso"
                Delete "$Path_Skyrim_Remove\Mopy\bash\libbsao"
                Delete "$Path_Skyrim_Remove\Mopy\bash\cinto"
                Delete "$Path_Skyrim_Remove\Mopy\bash\cint.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\chardet\*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\bwebo"
                Delete "$Path_Skyrim_Remove\Mopy\bash\bweb.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\busho"
                Delete "$Path_Skyrim_Remove\Mopy\bash\bush.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\breco"
                Delete "$Path_Skyrim_Remove\Mopy\bash\brec.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\bosho"
                Delete "$Path_Skyrim_Remove\Mopy\bash\bosh.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\Bolto"
                Delete "$Path_Skyrim_Remove\Mopy\bash\bolt.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\bish.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\belto"
                Delete "$Path_Skyrim_Remove\Mopy\bash\belt.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\basso"
                Delete "$Path_Skyrim_Remove\Mopy\bash\bass.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\basho"
                Delete "$Path_Skyrim_Remove\Mopy\bash\bashmon.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\bashero"
                Delete "$Path_Skyrim_Remove\Mopy\bash\basher.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\bash.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\bargo"
                Delete "$Path_Skyrim_Remove\Mopy\bash\barg.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\barbo"
                Delete "$Path_Skyrim_Remove\Mopy\bash\barb.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\bapio"
                Delete "$Path_Skyrim_Remove\Mopy\bash\bapi.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\balto"
                Delete "$Path_Skyrim_Remove\Mopy\bash\balt.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash\*.pyc"
                Delete "$Path_Skyrim_Remove\Mopy\bash\*.py"
                Delete "$Path_Skyrim_Remove\Mopy\bash\*.bat"
                Delete "$Path_Skyrim_Remove\Mopy\bash\__init__.p*"
                Delete "$Path_Skyrim_Remove\Mopy\bash.ini"
                Delete "$Path_Skyrim_Remove\Mopy\bash_default.ini"
                Delete "$Path_Skyrim_Remove\Mopy\bash_default_Russian.ini"
                Delete "$Path_Skyrim_Remove\Mopy\Bash Patches\Skyrim\*.*"
                Delete "$Path_Skyrim_Remove\Mopy\Bash Patches\Oblivion\*.*"
                Delete "$Path_Skyrim_Remove\Mopy\*.log"
                Delete "$Path_Skyrim_Remove\Mopy\*.bat"
                Delete "$Path_Skyrim_Remove\Mopy\bash.ico"
                Delete "$Path_Skyrim_Remove\Data\Docs\Bashed patch*.*"
                Delete "$Path_Skyrim_Remove\Data\ArchiveInvalidationInvalidated!.bsa"
                RMDir  "$Path_Skyrim_Remove\Mopy\Wizard Images"
                RMDir  "$Path_Skyrim_Remove\Mopy\templates\skyrim"
                RMDir  "$Path_Skyrim_Remove\Mopy\templates\oblivion"
                RMDir  "$Path_Skyrim_Remove\Mopy\templates"
                RMDir  "$Path_Skyrim_Remove\Mopy\Ini Tweaks\Skyrim"
                RMDir  "$Path_Skyrim_Remove\Mopy\Ini Tweaks\Oblivion"
                RMDir  "$Path_Skyrim_Remove\Mopy\Ini Tweaks"
                RMDir  "$Path_Skyrim_Remove\Mopy\Docs"
                RMDir  "$Path_Skyrim_Remove\Mopy\bash\l10n"
                RMDir  "$Path_Skyrim_Remove\Mopy\bash\images\tools"
                RMDir  "$Path_Skyrim_Remove\Mopy\bash\images\readme"
                RMDir  "$Path_Skyrim_Remove\Mopy\bash\images\nsis"
                RMDir  "$Path_Skyrim_Remove\Mopy\bash\images"
                RMDir  "$Path_Skyrim_Remove\Mopy\bash\game"
                RMDir  "$Path_Skyrim_Remove\Mopy\bash\db"
                RMDir  "$Path_Skyrim_Remove\Mopy\bash\compiled\Microsoft.VC80.CRT"
                RMDir  "$Path_Skyrim_Remove\Mopy\bash\compiled"
                RMDir  "$Path_Skyrim_Remove\Mopy\bash\chardet"
                RMDir  "$Path_Skyrim_Remove\Mopy\bash"
                RMDir  "$Path_Skyrim_Remove\Mopy\Bash Patches\Skyrim"
                RMDir  "$Path_Skyrim_Remove\Mopy\Bash Patches\Oblivion"
                RMDir  "$Path_Skyrim_Remove\Mopy\Bash Patches"
                RMDir  "$Path_Skyrim_Remove\Mopy\Apps"
                RMDir  "$Path_Skyrim_Remove\Mopy"
                RMDir  "$Path_Skyrim_Remove\Data\Ini Tweaks"
                RMDir  "$Path_Skyrim_Remove\Data\Docs"
                RMDir  "$Path_Skyrim_Remove\Data\Bash Patches"
                Delete "$SMPROGRAMS\Wrye Flash\*Skyrim*"
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Ex1 == ${BST_CHECKED}
            ${If} $Path_Ex1 != $Empty
                DeleteRegValue HKLM "SOFTWARE\Wrye Flash" "Extra Path 1"
                DeleteRegValue HKLM "SOFTWARE\Wrye Flash" "Extra Path 1 Python Version"
                DeleteRegValue HKLM "SOFTWARE\Wrye Flash" "Extra Path 1 Standalone Version"
                ;First delete OLD version files:
                Delete "$Path_Ex1\Data\Docs\Bashed Lists.txt"
                Delete "$Path_Ex1\Data\Docs\Bashed Lists.html"
                Delete "$Path_Ex1\Mopy\uninstall.exe"
                Delete "$Path_Ex1\Data\Ini Tweaks\Autosave, Never.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Autosave, ~Always.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Border Regions, Disabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Border Regions, ~Enabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Fonts 1, ~Default.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Fonts, ~Default.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Grass, Fade 4k-5k.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Intro Movies, Disabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Intro Movies, Normal.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Joystick, ~Disabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Joystick, ~Enabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Local Map Shader, Disabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Local Map Shader, ~Enabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Music, Disabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Music, Enabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Refraction Shader, Disabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Refraction Shader, ~Enabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Save Backups, 1.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Save Backups, 2.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Save Backups, 3.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Save Backups, 5.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Screenshot, ~Disabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Screenshot, ~ENabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\ShadowMapResolution, 1024.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\ShadowMapResolution, 256 [default].ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound Card Channels, 8.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound Card Channels, 16.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound Card Channels, 24.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound Card Channels, 48.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound Card Channels, 64.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound Card Channels, 96.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound Card Channels, 128.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound Card Channels, 192.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound Card Channels, ~ [Oblivion].ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound Card Channels,  [Oblivion].ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound, Disabled.ini"
                Delete "$Path_Ex1\Data\Ini Tweaks\Sound, Enabled.ini"
                Delete "$Path_Ex1\Data\Bash Patches\Crowded Cities 15_Alternate_Names.csv"
                Delete "$Path_Ex1\Data\Bash Patches\Crowded Cities 15_Names.csv"
                Delete "$Path_Ex1\Data\Bash Patches\Crowded Cities 30_Alternate_Names.csv"
                Delete "$Path_Ex1\Data\Bash Patches\Crowded Cities 30_Names.csv"
                Delete "$Path_Ex1\Data\Bash Patches\Crowded Roads Revamped_Names.csv"
                Delete "$Path_Ex1\Data\Bash Patches\Crowded Roads Revisited_Alternate_Names.csv"
                Delete "$Path_Ex1\Data\Bash Patches\Crowded Roads Revisited_Names.csv"
                Delete "$Path_Ex1\Data\Bash Patches\PTRoamingNPCs_Names.csv"
                Delete "$Path_Ex1\Mopy\Wrye Flash Advanced Readme.html"
                Delete "$Path_Ex1\Mopy\Wrye Flash General Readme.html"
                Delete "$Path_Ex1\Mopy\Wrye Flash Technical Readme.html"
                Delete "$Path_Ex1\Mopy\Wrye Flash Version History.html"
                ;As of 294 the below are obselete locations or files.
                Delete "$Path_Ex1\Mopy\7z.*"
                Delete "$Path_Ex1\Mopy\CBash.dll"
                Delete "$Path_Ex1\Mopy\Data\Italian.*"
                Delete "$Path_Ex1\Mopy\Data\Oblivion_ids.pkl"
                Delete "$Path_Ex1\Mopy\Data\Russian.*"
                Delete "$Path_Ex1\Mopy\Data\de.*"
                Delete "$Path_Ex1\Mopy\Data\pt_opt.*"
                Delete "$Path_Ex1\Mopy\Data\Actor Levels\OOO, 1.23 Mincapped.csv"
                Delete "$Path_Ex1\Mopy\Data\Actor Levels\OOO, 1.23 Uncapped.csv"
                RMDir  "$Path_Ex1\Mopy\Data\Actor Levels"
                RMDir  "$Path_Ex1\Mopy\Data"
                Delete "$Path_Ex1\Mopy\DebugLog(Python2.6).bat"
                Delete "$Path_Ex1\Mopy\Extras\*"
                Delete "$Path_Ex1\Mopy\ScriptParser.p*"
                Delete "$Path_Ex1\Mopy\balt.p*"
                Delete "$Path_Ex1\Mopy\barb.p*"
                Delete "$Path_Ex1\Mopy\barg.p*"
                Delete "$Path_Ex1\Mopy\bash.p*"
                Delete "$Path_Ex1\Mopy\basher.p*"
                Delete "$Path_Ex1\Mopy\bashmon.p*"
                Delete "$Path_Ex1\Mopy\belt.p*"
                Delete "$Path_Ex1\Mopy\bish.p*"
                Delete "$Path_Ex1\Mopy\bolt.p*"
                Delete "$Path_Ex1\Mopy\bosh.p*"
                Delete "$Path_Ex1\Mopy\bush.p*"
                Delete "$Path_Ex1\Mopy\cint.p*"
                Delete "$Path_Ex1\Mopy\gpl.txt"
                Delete "$Path_Ex1\Mopy\images\*"
                RMDir  "$Path_Ex1\Mopy\images"
                Delete "$Path_Ex1\Mopy\lzma.exe"
                ;Current files:
                Delete "$Path_Ex1\Mopy\Wrye Flash.txt"
                Delete "$Path_Ex1\Mopy\Wrye Flash.html"
                Delete "$Path_Ex1\Mopy\Wrye Flash.exe"
                Delete "$Path_Ex1\Mopy\Wrye Flash.exe.log"
                Delete "$Path_Ex1\Mopy\Wrye Flash Launcher.p*"
                Delete "$Path_Ex1\Mopy\Wrye Flash Debug.p*"
                Delete "$Path_Ex1\Mopy\wizards.txt"
                Delete "$Path_Ex1\Mopy\wizards.html"
                Delete "$Path_Ex1\Mopy\Wizard Images\*.*"
                Delete "$Path_Ex1\Mopy\w9xpopen.exe"
                Delete "$Path_Ex1\Mopy\templates\skyrim\*.*"
                Delete "$Path_Ex1\Mopy\templates\oblivion\*.*"
                Delete "$Path_Ex1\Mopy\templates\*.*"
                Delete "$Path_Ex1\Mopy\templates\*"
                Delete "$Path_Ex1\Mopy\patch_option_reference.txt"
                Delete "$Path_Ex1\Mopy\patch_option_reference.html"
                Delete "$Path_Ex1\Mopy\license.txt"
                Delete "$Path_Ex1\Mopy\Ini Tweaks\Skyrim\*.*"
                Delete "$Path_Ex1\Mopy\Ini Tweaks\Oblivion\*.*"
                Delete "$Path_Ex1\Mopy\Docs\Wrye Flash Version History.html"
                Delete "$Path_Ex1\Mopy\Docs\Wrye Flash Technical Readme.html"
                Delete "$Path_Ex1\Mopy\Docs\Wrye Flash General Readme.html"
                Delete "$Path_Ex1\Mopy\Docs\Wrye Flash Advanced Readme.html"
                Delete "$Path_Ex1\Mopy\Docs\wtxt_teal.css"
                Delete "$Path_Ex1\Mopy\Docs\wtxt_sand_small.css"
                Delete "$Path_Ex1\Mopy\Docs\Bash Readme Template.txt"
                Delete "$Path_Ex1\Mopy\Docs\Bash Readme Template.html"
                Delete "$Path_Ex1\Mopy\bash\windows.pyo"
                Delete "$Path_Ex1\Mopy\bash\ScriptParsero"
                Delete "$Path_Ex1\Mopy\bash\ScriptParsero.py"
                Delete "$Path_Ex1\Mopy\bash\ScriptParser.p*"
                Delete "$Path_Ex1\Mopy\bash\Rename_CBash.dll"
                Delete "$Path_Ex1\Mopy\bash\l10n\Russian.*"
                Delete "$Path_Ex1\Mopy\bash\l10n\pt_opt.*"
                Delete "$Path_Ex1\Mopy\bash\l10n\Italian.*"
                Delete "$Path_Ex1\Mopy\bash\l10n\de.*"
                Delete "$Path_Ex1\Mopy\bash\l10n\Chinese*.*"
                Delete "$Path_Ex1\Mopy\bash\liblo.pyo"
                Delete "$Path_Ex1\Mopy\bash\libbsa.pyo"
                Delete "$Path_Ex1\Mopy\bash\libbsa.py"
                Delete "$Path_Ex1\Mopy\bash\images\tools\*.*"
                Delete "$Path_Ex1\Mopy\bash\images\readme\*.*"
                Delete "$Path_Ex1\Mopy\bash\images\nsis\*.*"
                Delete "$Path_Ex1\Mopy\bash\images\*"
                Delete "$Path_Ex1\Mopy\bash\gpl.txt"
                Delete "$Path_Ex1\Mopy\bash\game\*"
                Delete "$Path_Ex1\Mopy\bash\db\Skyrim_ids.pkl"
                Delete "$Path_Ex1\Mopy\bash\db\Oblivion_ids.pkl"
                Delete "$Path_Ex1\Mopy\bash\compiled\Microsoft.VC80.CRT\*"
                Delete "$Path_Ex1\Mopy\bash\compiled\*"
                Delete "$Path_Ex1\Mopy\bash\windowso"
                Delete "$Path_Ex1\Mopy\bash\libbsao"
                Delete "$Path_Ex1\Mopy\bash\cinto"
                Delete "$Path_Ex1\Mopy\bash\cint.p*"
                Delete "$Path_Ex1\Mopy\bash\chardet\*"
                Delete "$Path_Ex1\Mopy\bash\bwebo"
                Delete "$Path_Ex1\Mopy\bash\bweb.p*"
                Delete "$Path_Ex1\Mopy\bash\busho"
                Delete "$Path_Ex1\Mopy\bash\bush.p*"
                Delete "$Path_Ex1\Mopy\bash\breco"
                Delete "$Path_Ex1\Mopy\bash\brec.p*"
                Delete "$Path_Ex1\Mopy\bash\bosho"
                Delete "$Path_Ex1\Mopy\bash\bosh.p*"
                Delete "$Path_Ex1\Mopy\bash\Bolto"
                Delete "$Path_Ex1\Mopy\bash\bolt.p*"
                Delete "$Path_Ex1\Mopy\bash\bish.p*"
                Delete "$Path_Ex1\Mopy\bash\belto"
                Delete "$Path_Ex1\Mopy\bash\belt.p*"
                Delete "$Path_Ex1\Mopy\bash\basso"
                Delete "$Path_Ex1\Mopy\bash\bass.p*"
                Delete "$Path_Ex1\Mopy\bash\basho"
                Delete "$Path_Ex1\Mopy\bash\bashmon.p*"
                Delete "$Path_Ex1\Mopy\bash\bashero"
                Delete "$Path_Ex1\Mopy\bash\basher.p*"
                Delete "$Path_Ex1\Mopy\bash\bash.p*"
                Delete "$Path_Ex1\Mopy\bash\bargo"
                Delete "$Path_Ex1\Mopy\bash\barg.p*"
                Delete "$Path_Ex1\Mopy\bash\barbo"
                Delete "$Path_Ex1\Mopy\bash\barb.p*"
                Delete "$Path_Ex1\Mopy\bash\bapio"
                Delete "$Path_Ex1\Mopy\bash\bapi.p*"
                Delete "$Path_Ex1\Mopy\bash\balto"
                Delete "$Path_Ex1\Mopy\bash\balt.p*"
                Delete "$Path_Ex1\Mopy\bash\*.pyc"
                Delete "$Path_Ex1\Mopy\bash\*.py"
                Delete "$Path_Ex1\Mopy\bash\*.bat"
                Delete "$Path_Ex1\Mopy\bash\__init__.p*"
                Delete "$Path_Ex1\Mopy\bash.ini"
                Delete "$Path_Ex1\Mopy\bash_default.ini"
                Delete "$Path_Ex1\Mopy\bash_default_Russian.ini"
                Delete "$Path_Ex1\Mopy\Bash Patches\Skyrim\*.*"
                Delete "$Path_Ex1\Mopy\Bash Patches\Oblivion\*.*"
                Delete "$Path_Ex1\Mopy\*.log"
                Delete "$Path_Ex1\Mopy\*.bat"
                Delete "$Path_Ex1\Mopy\bash.ico"
                Delete "$Path_Ex1\Data\Docs\Bashed patch*.*"
                Delete "$Path_Ex1\Data\ArchiveInvalidationInvalidated!.bsa"
                RMDir  "$Path_Ex1\Mopy\Wizard Images"
                RMDir  "$Path_Ex1\Mopy\templates\skyrim"
                RMDir  "$Path_Ex1\Mopy\templates\oblivion"
                RMDir  "$Path_Ex1\Mopy\templates"
                RMDir  "$Path_Ex1\Mopy\Ini Tweaks\Skyrim"
                RMDir  "$Path_Ex1\Mopy\Ini Tweaks\Oblivion"
                RMDir  "$Path_Ex1\Mopy\Ini Tweaks"
                RMDir  "$Path_Ex1\Mopy\Docs"
                RMDir  "$Path_Ex1\Mopy\bash\l10n"
                RMDir  "$Path_Ex1\Mopy\bash\images\tools"
                RMDir  "$Path_Ex1\Mopy\bash\images\readme"
                RMDir  "$Path_Ex1\Mopy\bash\images\nsis"
                RMDir  "$Path_Ex1\Mopy\bash\images"
                RMDir  "$Path_Ex1\Mopy\bash\game"
                RMDir  "$Path_Ex1\Mopy\bash\db"
                RMDir  "$Path_Ex1\Mopy\bash\compiled\Microsoft.VC80.CRT"
                RMDir  "$Path_Ex1\Mopy\bash\compiled"
                RMDir  "$Path_Ex1\Mopy\bash\chardet"
                RMDir  "$Path_Ex1\Mopy\bash"
                RMDir  "$Path_Ex1\Mopy\Bash Patches\Skyrim"
                RMDir  "$Path_Ex1\Mopy\Bash Patches\Oblivion"
                RMDir  "$Path_Ex1\Mopy\Bash Patches"
                RMDir  "$Path_Ex1\Mopy\Apps"
                RMDir  "$Path_Ex1\Mopy"
                RMDir  "$Path_Ex1\Data\Ini Tweaks"
                RMDir  "$Path_Ex1\Data\Docs"
                RMDir  "$Path_Ex1\Data\Bash Patches"
                Delete "$SMPROGRAMS\Wrye Flash\*Extra 1*"
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Ex2 == ${BST_CHECKED}
            ${If} $Path_Ex2 != $Empty
                DeleteRegValue HKLM "SOFTWARE\Wrye Flash" "Extra Path 2"
                DeleteRegValue HKLM "SOFTWARE\Wrye Flash" "Extra Path 2 Python Version"
                DeleteRegValue HKLM "SOFTWARE\Wrye Flash" "Extra Path 2 Standalone Version"
                ;First delete OLD version files:
                Delete "$Path_Ex2\Data\Docs\Bashed Lists.txt"
                Delete "$Path_Ex2\Data\Docs\Bashed Lists.html"
                Delete "$Path_Ex2\Mopy\uninstall.exe"
                Delete "$Path_Ex2\Data\Ini Tweaks\Autosave, Never.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Autosave, ~Always.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Border Regions, Disabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Border Regions, ~Enabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Fonts 1, ~Default.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Fonts, ~Default.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Grass, Fade 4k-5k.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Intro Movies, Disabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Intro Movies, Normal.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Joystick, ~Disabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Joystick, ~Enabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Local Map Shader, Disabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Local Map Shader, ~Enabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Music, Disabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Music, Enabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Refraction Shader, Disabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Refraction Shader, ~Enabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Save Backups, 1.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Save Backups, 2.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Save Backups, 3.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Save Backups, 5.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Screenshot, ~Disabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Screenshot, ~ENabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\ShadowMapResolution, 1024.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\ShadowMapResolution, 256 [default].ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels, 8.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels, 16.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels, 24.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels, 48.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels, 64.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels, 96.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels, 128.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels, 192.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels, ~ [Oblivion].ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound Card Channels,  [Oblivion].ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound, Disabled.ini"
                Delete "$Path_Ex2\Data\Ini Tweaks\Sound, Enabled.ini"
                Delete "$Path_Ex2\Data\Bash Patches\Crowded Cities 15_Alternate_Names.csv"
                Delete "$Path_Ex2\Data\Bash Patches\Crowded Cities 15_Names.csv"
                Delete "$Path_Ex2\Data\Bash Patches\Crowded Cities 30_Alternate_Names.csv"
                Delete "$Path_Ex2\Data\Bash Patches\Crowded Cities 30_Names.csv"
                Delete "$Path_Ex2\Data\Bash Patches\Crowded Roads Revamped_Names.csv"
                Delete "$Path_Ex2\Data\Bash Patches\Crowded Roads Revisited_Alternate_Names.csv"
                Delete "$Path_Ex2\Data\Bash Patches\Crowded Roads Revisited_Names.csv"
                Delete "$Path_Ex2\Data\Bash Patches\PTRoamingNPCs_Names.csv"
                Delete "$Path_Ex2\Mopy\Wrye Flash Advanced Readme.html"
                Delete "$Path_Ex2\Mopy\Wrye Flash General Readme.html"
                Delete "$Path_Ex2\Mopy\Wrye Flash Technical Readme.html"
                Delete "$Path_Ex2\Mopy\Wrye Flash Version History.html"
                ;As of 294 the below are obselete locations or files.
                Delete "$Path_Ex2\Mopy\7z.*"
                Delete "$Path_Ex2\Mopy\CBash.dll"
                Delete "$Path_Ex2\Mopy\Data\Italian.*"
                Delete "$Path_Ex2\Mopy\Data\Oblivion_ids.pkl"
                Delete "$Path_Ex2\Mopy\Data\Russian.*"
                Delete "$Path_Ex2\Mopy\Data\de.*"
                Delete "$Path_Ex2\Mopy\Data\pt_opt.*"
                Delete "$Path_Ex2\Mopy\Data\Actor Levels\OOO, 1.23 Mincapped.csv"
                Delete "$Path_Ex2\Mopy\Data\Actor Levels\OOO, 1.23 Uncapped.csv"
                RMDir  "$Path_Ex2\Mopy\Data\Actor Levels"
                RMDir  "$Path_Ex2\Mopy\Data"
                Delete "$Path_Ex2\Mopy\DebugLog(Python2.6).bat"
                Delete "$Path_Ex2\Mopy\Extras\*"
                Delete "$Path_Ex2\Mopy\ScriptParser.p*"
                Delete "$Path_Ex2\Mopy\balt.p*"
                Delete "$Path_Ex2\Mopy\barb.p*"
                Delete "$Path_Ex2\Mopy\barg.p*"
                Delete "$Path_Ex2\Mopy\bash.p*"
                Delete "$Path_Ex2\Mopy\basher.p*"
                Delete "$Path_Ex2\Mopy\bashmon.p*"
                Delete "$Path_Ex2\Mopy\belt.p*"
                Delete "$Path_Ex2\Mopy\bish.p*"
                Delete "$Path_Ex2\Mopy\bolt.p*"
                Delete "$Path_Ex2\Mopy\bosh.p*"
                Delete "$Path_Ex2\Mopy\bush.p*"
                Delete "$Path_Ex2\Mopy\cint.p*"
                Delete "$Path_Ex2\Mopy\gpl.txt"
                Delete "$Path_Ex2\Mopy\images\*"
                RMDir  "$Path_Ex2\Mopy\images"
                Delete "$Path_Ex2\Mopy\lzma.exe"
                ;Current files:
                Delete "$Path_Ex2\Mopy\Wrye Flash.txt"
                Delete "$Path_Ex2\Mopy\Wrye Flash.html"
                Delete "$Path_Ex2\Mopy\Wrye Flash.exe"
                Delete "$Path_Ex2\Mopy\Wrye Flash.exe.log"
                Delete "$Path_Ex2\Mopy\Wrye Flash Launcher.p*"
                Delete "$Path_Ex2\Mopy\Wrye Flash Debug.p*"
                Delete "$Path_Ex2\Mopy\wizards.txt"
                Delete "$Path_Ex2\Mopy\wizards.html"
                Delete "$Path_Ex2\Mopy\Wizard Images\*.*"
                Delete "$Path_Ex2\Mopy\w9xpopen.exe"
                Delete "$Path_Ex2\Mopy\templates\skyrim\*.*"
                Delete "$Path_Ex2\Mopy\templates\oblivion\*.*"
                Delete "$Path_Ex2\Mopy\templates\*.*"
                Delete "$Path_Ex2\Mopy\templates\*"
                Delete "$Path_Ex2\Mopy\patch_option_reference.txt"
                Delete "$Path_Ex2\Mopy\patch_option_reference.html"
                Delete "$Path_Ex2\Mopy\license.txt"
                Delete "$Path_Ex2\Mopy\Ini Tweaks\Skyrim\*.*"
                Delete "$Path_Ex2\Mopy\Ini Tweaks\Oblivion\*.*"
                Delete "$Path_Ex2\Mopy\Docs\Wrye Flash Version History.html"
                Delete "$Path_Ex2\Mopy\Docs\Wrye Flash Technical Readme.html"
                Delete "$Path_Ex2\Mopy\Docs\Wrye Flash General Readme.html"
                Delete "$Path_Ex2\Mopy\Docs\Wrye Flash Advanced Readme.html"
                Delete "$Path_Ex2\Mopy\Docs\wtxt_teal.css"
                Delete "$Path_Ex2\Mopy\Docs\wtxt_sand_small.css"
                Delete "$Path_Ex2\Mopy\Docs\Bash Readme Template.txt"
                Delete "$Path_Ex2\Mopy\Docs\Bash Readme Template.html"
                Delete "$Path_Ex2\Mopy\bash\windows.pyo"
                Delete "$Path_Ex2\Mopy\bash\ScriptParsero"
                Delete "$Path_Ex2\Mopy\bash\ScriptParsero.py"
                Delete "$Path_Ex2\Mopy\bash\ScriptParser.p*"
                Delete "$Path_Ex2\Mopy\bash\Rename_CBash.dll"
                Delete "$Path_Ex2\Mopy\bash\l10n\Russian.*"
                Delete "$Path_Ex2\Mopy\bash\l10n\pt_opt.*"
                Delete "$Path_Ex2\Mopy\bash\l10n\Italian.*"
                Delete "$Path_Ex2\Mopy\bash\l10n\de.*"
                Delete "$Path_Ex2\Mopy\bash\l10n\Chinese*.*"
                Delete "$Path_Ex2\Mopy\bash\liblo.pyo"
                Delete "$Path_Ex2\Mopy\bash\libbsa.pyo"
                Delete "$Path_Ex2\Mopy\bash\libbsa.py"
                Delete "$Path_Ex2\Mopy\bash\images\tools\*.*"
                Delete "$Path_Ex2\Mopy\bash\images\readme\*.*"
                Delete "$Path_Ex2\Mopy\bash\images\nsis\*.*"
                Delete "$Path_Ex2\Mopy\bash\images\*"
                Delete "$Path_Ex2\Mopy\bash\gpl.txt"
                Delete "$Path_Ex2\Mopy\bash\game\*"
                Delete "$Path_Ex2\Mopy\bash\db\Skyrim_ids.pkl"
                Delete "$Path_Ex2\Mopy\bash\db\Oblivion_ids.pkl"
                Delete "$Path_Ex2\Mopy\bash\compiled\Microsoft.VC80.CRT\*"
                Delete "$Path_Ex2\Mopy\bash\compiled\*"
                Delete "$Path_Ex2\Mopy\bash\windowso"
                Delete "$Path_Ex2\Mopy\bash\libbsao"
                Delete "$Path_Ex2\Mopy\bash\cinto"
                Delete "$Path_Ex2\Mopy\bash\cint.p*"
                Delete "$Path_Ex2\Mopy\bash\chardet\*"
                Delete "$Path_Ex2\Mopy\bash\bwebo"
                Delete "$Path_Ex2\Mopy\bash\bweb.p*"
                Delete "$Path_Ex2\Mopy\bash\busho"
                Delete "$Path_Ex2\Mopy\bash\bush.p*"
                Delete "$Path_Ex2\Mopy\bash\breco"
                Delete "$Path_Ex2\Mopy\bash\brec.p*"
                Delete "$Path_Ex2\Mopy\bash\bosho"
                Delete "$Path_Ex2\Mopy\bash\bosh.p*"
                Delete "$Path_Ex2\Mopy\bash\Bolto"
                Delete "$Path_Ex2\Mopy\bash\bolt.p*"
                Delete "$Path_Ex2\Mopy\bash\bish.p*"
                Delete "$Path_Ex2\Mopy\bash\belto"
                Delete "$Path_Ex2\Mopy\bash\belt.p*"
                Delete "$Path_Ex2\Mopy\bash\basso"
                Delete "$Path_Ex2\Mopy\bash\bass.p*"
                Delete "$Path_Ex2\Mopy\bash\basho"
                Delete "$Path_Ex2\Mopy\bash\bashmon.p*"
                Delete "$Path_Ex2\Mopy\bash\bashero"
                Delete "$Path_Ex2\Mopy\bash\basher.p*"
                Delete "$Path_Ex2\Mopy\bash\bash.p*"
                Delete "$Path_Ex2\Mopy\bash\bargo"
                Delete "$Path_Ex2\Mopy\bash\barg.p*"
                Delete "$Path_Ex2\Mopy\bash\barbo"
                Delete "$Path_Ex2\Mopy\bash\barb.p*"
                Delete "$Path_Ex2\Mopy\bash\bapio"
                Delete "$Path_Ex2\Mopy\bash\bapi.p*"
                Delete "$Path_Ex2\Mopy\bash\balto"
                Delete "$Path_Ex2\Mopy\bash\balt.p*"
                Delete "$Path_Ex2\Mopy\bash\*.pyc"
                Delete "$Path_Ex2\Mopy\bash\*.py"
                Delete "$Path_Ex2\Mopy\bash\*.bat"
                Delete "$Path_Ex2\Mopy\bash\__init__.p*"
                Delete "$Path_Ex2\Mopy\bash.ini"
                Delete "$Path_Ex2\Mopy\bash_default.ini"
                Delete "$Path_Ex2\Mopy\bash_default_Russian.ini"
                Delete "$Path_Ex2\Mopy\Bash Patches\Skyrim\*.*"
                Delete "$Path_Ex2\Mopy\Bash Patches\Oblivion\*.*"
                Delete "$Path_Ex2\Mopy\*.log"
                Delete "$Path_Ex2\Mopy\*.bat"
                Delete "$Path_Ex2\Mopy\bash.ico"
                Delete "$Path_Ex2\Data\Docs\Bashed patch*.*"
                Delete "$Path_Ex2\Data\ArchiveInvalidationInvalidated!.bsa"
                RMDir  "$Path_Ex2\Mopy\Wizard Images"
                RMDir  "$Path_Ex2\Mopy\templates\skyrim"
                RMDir  "$Path_Ex2\Mopy\templates\oblivion"
                RMDir  "$Path_Ex2\Mopy\templates"
                RMDir  "$Path_Ex2\Mopy\Ini Tweaks\Skyrim"
                RMDir  "$Path_Ex2\Mopy\Ini Tweaks\Oblivion"
                RMDir  "$Path_Ex2\Mopy\Ini Tweaks"
                RMDir  "$Path_Ex2\Mopy\Docs"
                RMDir  "$Path_Ex2\Mopy\bash\l10n"
                RMDir  "$Path_Ex2\Mopy\bash\images\tools"
                RMDir  "$Path_Ex2\Mopy\bash\images\readme"
                RMDir  "$Path_Ex2\Mopy\bash\images\nsis"
                RMDir  "$Path_Ex2\Mopy\bash\images"
                RMDir  "$Path_Ex2\Mopy\bash\game"
                RMDir  "$Path_Ex2\Mopy\bash\db"
                RMDir  "$Path_Ex2\Mopy\bash\compiled\Microsoft.VC80.CRT"
                RMDir  "$Path_Ex2\Mopy\bash\compiled"
                RMDir  "$Path_Ex2\Mopy\bash\chardet"
                RMDir  "$Path_Ex2\Mopy\bash"
                RMDir  "$Path_Ex2\Mopy\Bash Patches\Skyrim"
                RMDir  "$Path_Ex2\Mopy\Bash Patches\Oblivion"
                RMDir  "$Path_Ex2\Mopy\Bash Patches"
                RMDir  "$Path_Ex2\Mopy\Apps"
                RMDir  "$Path_Ex2\Mopy"
                RMDir  "$Path_Ex2\Data\Ini Tweaks"
                RMDir  "$Path_Ex2\Data\Docs"
                RMDir  "$Path_Ex2\Data\Bash Patches"
                Delete "$SMPROGRAMS\Wrye Flash\*Extra 2*"
            ${EndIf}
        ${EndIf}


        ;If it is a complete uninstall remove the shared data:
        ReadRegStr $Path_NV HKLM "Software\Wrye Flash" "FalloutNV Path"
        ReadRegStr $Path_Nehrim_Remove HKLM "Software\Wrye Flash" "Nehrim Path"
        ReadRegStr $Path_Skyrim_Remove HKLM "Software\Wrye Flash" "Skyrim Path"
        ReadRegStr $Path_Ex1 HKLM "Software\Wrye Flash" "Extra Path 1"
        ReadRegStr $Path_Ex2 HKLM "Software\Wrye Flash" "Extra Path 2"
        ${If} $Path_NV == $Empty
            ${AndIf} $Path_Nehrim_Remove == $Empty
            ${AndIf} $Path_Skyrim_Remove == $Empty
            ${AndIf} $Path_Ex1 == $Empty
            ${AndIf} $Path_Ex2 == $Empty
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
