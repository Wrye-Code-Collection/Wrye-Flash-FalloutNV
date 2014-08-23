; uninstall.nsi
; Uninstallation script for Wrye Flash NSIS uninstaller.

; !include 'macro_uninstall.nsh' ; Already included from pages.nsi

;-------------------------------- The Uninstallation Code:
    Section "Uninstall"
        ; Remove files and Directories - Directories are only deleted if empty.
        ${If} $CheckState_NV == ${BST_CHECKED}
            ${If} $Path_NV != $Empty
                !insertmacro UninstallBash $Path_NV "FalloutNV"
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Nehrim_Remove == ${BST_CHECKED}
            ${If} $Path_Nehrim_Remove != $Empty
                !insertmacro UninstallBash $Path_Nehrim_Remove "Nehrim"
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Skyrim_Remove == ${BST_CHECKED}
            ${If} $Path_Skyrim_Remove != $Empty
                !insertmacro UninstallBash $Path_Skyrim_Remove "Skyrim"
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Ex1_Remove == ${BST_CHECKED}
            ${If} $Path_Ex1_Remove != $Empty
                !insertmacro UninstallBash $Path_Ex1_Remove "Extra Path 1"
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Ex2_Remove == ${BST_CHECKED}
            ${If} $Path_Ex2_Remove != $Empty
                !insertmacro UninstallBash $Path_Ex2_Remove "Extra Path 2"
            ${EndIf}
        ${EndIf}


        ;If it is a complete uninstall remove the shared data:
        ReadRegStr $Path_NV HKLM "Software\Wrye Flash" "FalloutNV Path"
        ReadRegStr $Path_Nehrim_Remove HKLM "Software\Wrye Flash" "Nehrim Path"
        ReadRegStr $Path_Skyrim_Remove HKLM "Software\Wrye Flash" "Skyrim Path"
        ReadRegStr $Path_Ex1_Remove HKLM "Software\Wrye Flash" "Extra Path 1"
        ReadRegStr $Path_Ex2_Remove HKLM "Software\Wrye Flash" "Extra Path 2"
        ${If} $Path_NV == $Empty
            ${AndIf} $Path_Nehrim_Remove == $Empty
            ${AndIf} $Path_Skyrim_Remove == $Empty
            ${AndIf} $Path_Ex1_Remove == $Empty
            ${AndIf} $Path_Ex2_Remove == $Empty
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
