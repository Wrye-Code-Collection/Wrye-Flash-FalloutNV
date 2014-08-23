; pages.nsi
; Custom pages for the Wrye Flash NSIS installer / uninstaller


;---------------------------- Install Locations Page
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
            ${NSD_CreateCheckBox} 0 $0u 30% 13u "Install for FalloutNV"
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
            Pop $Check_Extra_Remove
            ${NSD_SetState} $Check_Extra_Remove $CheckState_Extra_Remove
                nsDialogs::OnClick $Check_Extra_Remove $Function_Extra
                IntOp $0 $0 + 13
            ${NSD_CreateCheckBox} 0 $0u 30% 13u "Extra Location #1:"
                Pop $Check_Ex1_Remove
                ${NSD_SetState} $Check_Ex1_Remove $CheckState_Ex1_Remove
                ${NSD_CreateCheckBox} 30% $0u 40% 13u "Wrye Flash [Standalone]"
                    Pop $Check_Ex1_Exe_Remove
                    ${NSD_AddStyle} $Check_Ex1_Exe_Remove ${WS_GROUP}
                    ${NSD_SetState} $Check_Ex1_Exe_Remove  $CheckState_Ex1_Exe_Remove
                ${NSD_CreateCheckBox} 70% $0u 30% 13u "Wrye Flash [Python]"
                    Pop $Check_Ex1_Py_Remove
;                    ${NSD_SetState} $Check_Ex1_Py_Remove  $CheckState_Ex1_Py_Remove
                IntOp $0 $0 + 13
                ${NSD_CreateDirRequest} 0 $0u 90% 13u "$Path_Ex1_Remove"
                    Pop $PathDialogue_Ex1_Remove
                ${NSD_CreateBrowseButton} -10% $0u 5% 13u "..."
                    Pop $Browse_Ex1_Remove
                    nsDialogs::OnClick $Browse_Ex1_Remove $Function_Browse
                IntOp $0 $0 + 13
            ${NSD_CreateCheckBox} 0 $0u 30% 13u "Extra Location #2:"
                Pop $Check_Ex2_Remove
                ${NSD_SetState} $Check_Ex2_Remove $CheckState_Ex2_Remove
                ${NSD_CreateCheckBox} 30% $0u 40% 13u "Wrye Flash [Standalone]"
                    Pop $Check_Ex2_Exe_Remove
                    ${NSD_AddStyle} $Check_Ex2_Exe_Remove ${WS_GROUP}
                    ${NSD_SetState} $Check_Ex2_Exe_Remove  $CheckState_Ex2_Exe_Remove
                ${NSD_CreateCheckBox} 70% $0u 30% 13u "Wrye Flash [Python]"
                    Pop $Check_Ex2_Py_Remove
;                    ${NSD_SetState} $Check_Ex2_Py_Remove  $CheckState_Ex2_Py_Remove
                IntOp $0 $0 + 13
                ${NSD_CreateDirRequest} 0 $0u 90% 13u "$Path_Ex2_Remove"
                    Pop $PathDialogue_Ex2_Remove
                ${NSD_CreateBrowseButton} -10% $0u 5% 13u "..."
                    Pop $Browse_Ex2_Remove
                    nsDialogs::OnClick $Browse_Ex2_Remove $Function_Browse
        ${If} $CheckState_Extra_Remove != ${BST_CHECKED}
            ShowWindow $Check_Ex1_Remove ${SW_HIDE}
            ShowWindow $Check_Ex1_Py_Remove ${SW_HIDE}
            ShowWindow $Check_Ex1_Exe_Remove ${SW_HIDE}
            ShowWindow $PathDialogue_Ex1_Remove ${SW_HIDE}
            ShowWindow $Browse_Ex1_Remove ${SW_HIDE}
            ShowWindow $Check_Ex2_Remove ${SW_HIDE}
            ShowWindow $Check_Ex2_Py_Remove ${SW_HIDE}
            ShowWindow $Check_Ex2_Exe_Remove ${SW_HIDE}
            ShowWindow $PathDialogue_Ex2_Remove ${SW_HIDE}
            ShowWindow $Browse_Ex2_Remove ${SW_HIDE}
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
        ${NSD_GetText} $PathDialogue_Ex1_Remove $Path_Ex1_Remove
        ${NSD_GetText} $PathDialogue_Ex2_Remove $Path_Ex2_Remove

        ; Game states
        ${NSD_GetState} $Check_NV $CheckState_NV
        ${NSD_GetState} $Check_Nehrim_Remove $CheckState_Nehrim_Remove
        ${NSD_GetState} $Check_Skyrim_Remove $CheckState_Skyrim_Remove
        ${NSD_GetState} $Check_Extra_Remove $CheckState_Extra_Remove
        ${NSD_GetState} $Check_Ex1_Remove $CheckState_Ex1_Remove
        ${NSD_GetState} $Check_Ex2_Remove $CheckState_Ex2_Remove

        ; Python states
        ${NSD_GetState} $Check_NV_Py $CheckState_NV_Py
        ${NSD_GetState} $Check_Nehrim_Py_Remove $CheckState_Nehrim_Py_Remove
        ${NSD_GetState} $Check_Skyrim_Py_Remove $CheckState_Skyrim_Py_Remove
        ${NSD_GetState} $Check_Ex1_Py_Remove $CheckState_Ex1_Py_Remove
        ${NSD_GetState} $Check_Ex2_Py_Remove $CheckState_Ex2_Py_Remove
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
        ${If} $CheckState_Ex1_Py_Remove == ${BST_CHECKED}
        ${AndIf} $CheckState_Extra_Remove == ${BST_CHECKED}
        ${AndIf} $CheckState_Ex1_Remove == ${BST_CHECKED}
            StrCpy $PythonVersionInstall $True
        ${Endif}
        ${If} $CheckState_Ex2_Py_Remove == ${BST_CHECKED}
        ${AndIf} $CheckState_Extra_Remove == ${BST_CHECKED}
        ${AndIf} $CheckState_Ex2_Remove == ${BST_CHECKED}
            StrCpy $PythonVersionInstall $True
        ${Endif}

        ; Standalone states
        ${NSD_GetState} $Check_NV_Exe $CheckState_NV_Exe
        ${NSD_GetState} $Check_Nehrim_Exe_Remove $CheckState_Nehrim_Exe_Remove
        ${NSD_GetState} $Check_Skyrim_Exe_Remove $CheckState_Skyrim_Exe_Remove
        ${NSD_GetState} $Check_Ex1_Exe_Remove $CheckState_Ex1_Exe_Remove
        ${NSD_GetState} $Check_Ex2_Exe_Remove $CheckState_Ex2_Exe_Remove
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
        ${If} $CheckState_Ex1_Exe_Remove == ${BST_CHECKED}
        ${AndIf} $CheckState_Extra_Remove == ${BST_CHECKED}
        ${AndIf} $CheckState_Ex1_Remove == ${BST_CHECKED}
            StrCpy $ExeVersionInstall $True
        ${Endif}
        ${If} $CheckState_Ex2_Exe_Remove == ${BST_CHECKED}
        ${AndIf} $CheckState_Extra_Remove == ${BST_CHECKED}
        ${AndIf} $CheckState_Ex2_Remove == ${BST_CHECKED}
            StrCpy $ExeVersionInstall $True
        ${Endif}
    FunctionEnd


;---------------------------- Check Locations Page
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
        ${If} $CheckState_Ex1_Remove == ${BST_CHECKED}
            ${StrLoc} $0 $Path_Ex1_Remove "$PROGRAMFILES\" ">"
            ${If} "0" == $0
                StrCpy $1 $True
            ${Endif}
        ${Endif}
        ${If} $CheckState_Ex2_Remove == ${BST_CHECKED}
            ${StrLoc} $0 $Path_Ex2_Remove "$PROGRAMFILES\" ">"
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

        ${NSD_CreateLabel} 0 24 100% 128u "This is a very common cause of problems when using Wrye Flash. Highly recommended that you stop this installation now, reinstall (FalloutNV/Skyrim/Steam) into another directory outside of Program Files, such as C:\Games\FalloutNV, and install Wrye Flash at that location.$\n$\nThe problems with installing in Program Files stem from a feature of Windows that did not exist when FalloutNV was released: User Access Controls (UAC).  If you continue with the install into Program Files, you may have trouble starting or using Wrye Flash, as it may not be able to access its own files."
        Pop $Label

        nsDialogs::Show
    FunctionEnd

    Function PAGE_CHECK_LOCATIONS_Leave
    FunctionEnd


;---------------------------- Finish Page
    Function PAGE_FINISH
        !insertmacro MUI_HEADER_TEXT $(PAGE_FINISH_TITLE) $(PAGE_FINISH_SUBTITLE)

        ReadRegStr $Path_NV HKLM "Software\Wrye Flash" "FalloutNV Path"
        ReadRegStr $Path_Nehrim_Remove HKLM "Software\Wrye Flash" "Nehrim Path"
        ReadRegStr $Path_Skyrim_Remove HKLM "Software\Wrye Flash" "Skyrim Path"
        ReadRegStr $Path_Ex1_Remove HKLM "Software\Wrye Flash" "Extra Path 1"
        ReadRegStr $Path_Ex2_Remove HKLM "Software\Wrye Flash" "Extra Path 2"

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
            ${NSD_CreateCheckBox} 0 $0u 100% 8u "FalloutNV"
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
        ${If} $Path_Ex1_Remove != $Empty
            ${NSD_CreateCheckBox} 0 $0u 100% 8u $Path_Ex1_Remove
                Pop $Check_Ex1_Remove
            IntOp $0 $0 + 9
        ${EndIf}
        ${If} $Path_Ex2_Remove != $Empty
            ${NSD_CreateCheckBox} 0 $0u 100% 8u $Path_Ex2_Remove
                Pop $Check_Ex2_Remove
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
        ${NSD_GetState} $Check_Ex1_Remove $CheckState_Ex1_Remove
        ${NSD_GetState} $Check_Ex2_Remove $CheckState_Ex2_Remove

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
        ${If} $CheckState_Ex1_Remove == ${BST_CHECKED}
            SetOutPath "$Path_Ex1_Remove\Mopy"
            ${If} $CheckState_Ex1_Py_Remove == ${BST_CHECKED}
                ExecShell "open" '"$Path_Ex1_Remove\Mopy\Wrye Flash Launcher.pyw"'
            ${ElseIf} $CheckState_Ex1_Exe_Remove == ${BST_CHECKED}
                ExecShell "open" "$Path_Ex1_Remove\Mopy\Wrye Flash.exe"
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Ex2_Remove == ${BST_CHECKED}
            SetOutPath "$Path_Ex2_Remove\Mopy"
            ${If} $CheckState_Ex2_Py_Remove == ${BST_CHECKED}
                ExecShell "open" '"$Path_Ex2_Remove\Mopy\Wrye Flash Launcher.pyw"'
            ${ElseIf} $CheckState_Ex2_Exe_Remove == ${BST_CHECKED}
                ExecShell "open" "$Path_Ex2_Remove\Mopy\Wrye Flash.exe"
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
            ${ElseIf} $Path_Ex1_Remove != $Empty
                ExecShell "open" "$Path_Ex1_Remove\Mopy\Docs\Wrye Flash General Readme.html"
            ${ElseIf} $Path_Ex2_Remove != $Empty
                ExecShell "open" "$Path_Ex2_Remove\Mopy\Docs\Wrye Flash General Readme.html"
            ${EndIf}
        ${EndIf}
        ${NSD_GetState} $Check_DeleteOldFiles $0
        ${If} $0 == ${BST_CHECKED}
            ${If} $Path_NV != $Empty
                !insertmacro RemoveOldFiles "$Path_NV"
            ${EndIf}
            ${If} $Path_Nehrim_Remove != $Empty
                !insertmacro RemoveOldFiles "$Path_Nehrim_Remove"
            ${EndIf}
            ${If} $Path_Skyrim_Remove != $Empty
                !insertmacro RemoveOldFiles "$Path_Skyrim_Remove"
            ${EndIf}
            ${If} $Path_Ex1_Remove != $Empty
                !insertmacro RemoveOldFiles "$Path_Ex1_Remove"
            ${EndIf}
            ${If} $Path_Ex2_Remove != $Empty
                !insertmacro RemoveOldFiles "$Path_Ex2_Remove"
                ${EndIf}
        ${EndIf}
    FunctionEnd


;----------------------------- Custom Uninstallation Pages and their Functions:
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
            ${NSD_CreateCheckBox} 0 $0u 100% 13u "&FalloutNV"
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
        ${If} $Path_Ex1_Remove != $Empty
            ${NSD_CreateCheckBox} 0 $0u 100% 13u "Extra Location 1"
                Pop $Check_Ex1_Remove
                ${NSD_SetState} $Check_Ex1_Remove $CheckState_Ex1_Remove
            IntOp $0 $0 + 13
            ${NSD_CreateDirRequest} 0 $0u 90% 13u "$Path_Ex1_Remove"
                Pop $PathDialogue_Ex1_Remove
            ${NSD_CreateBrowseButton} -10% $0u 5% 13u "..."
                Pop $Browse_Ex1_Remove
                nsDialogs::OnClick $Browse_Ex1_Remove $Function_Browse
            IntOp $0 $0 + 13
        ${EndIf}
        ${If} $Path_Ex2_Remove != $Empty
            ${NSD_CreateCheckBox} 0 $0u 100% 13u "Extra Location 2"
                Pop $Check_Ex2_Remove
                ${NSD_SetState} $Check_Ex2_Remove $CheckState_Ex2_Remove
            IntOp $0 $0 + 13
            ${NSD_CreateDirRequest} 0 $0u 90% 13u "$Path_Ex2_Remove"
                Pop $PathDialogue_Ex2_Remove
            ${NSD_CreateBrowseButton} -10% $0u 5% 13u "..."
                Pop $Browse_Ex2_Remove
                nsDialogs::OnClick $Browse_Ex2_Remove $Function_Browse
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
        ${NSD_GetText} $PathDialogue_Ex1_Remove $Path_Ex1_Remove
        ${NSD_GetText} $PathDialogue_Ex2_Remove $Path_Ex2_Remove
        ${NSD_GetState} $Check_NV $CheckState_NV
        ${NSD_GetState} $Check_Nehrim_Remove $CheckState_Nehrim_Remove
        ${NSD_GetState} $Check_Skyrim_Remove $CheckState_Skyrim_Remove
        ${NSD_GetState} $Check_Extra_Remove $CheckState_Extra_Remove
        ${NSD_GetState} $Check_Ex1_Remove $CheckState_Ex1_Remove
        ${NSD_GetState} $Check_Ex2_Remove $CheckState_Ex2_Remove
    FunctionEnd
