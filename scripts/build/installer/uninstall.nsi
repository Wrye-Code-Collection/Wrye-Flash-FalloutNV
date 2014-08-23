; uninstall.nsi
; Uninstallation script for Wrye Flash NSIS uninstaller.

; !include 'macro_uninstall.nsh' ; Already included from pages.nsi

;-------------------------------- The Uninstallation Code:
    Section "Uninstall"
        ; Remove files and Directories - Directories are only deleted if empty.
        ${If} $CheckState_OB == ${BST_CHECKED}
            ${If} $Path_OB != $Empty
                !insertmacro UninstallBash $Path_OB "Oblivion"
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Nehrim == ${BST_CHECKED}
            ${If} $Path_Nehrim != $Empty
                !insertmacro UninstallBash $Path_Nehrim "Nehrim"
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Skyrim == ${BST_CHECKED}
            ${If} $Path_Skyrim != $Empty
                !insertmacro UninstallBash $Path_Skyrim "Skyrim"
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Ex1 == ${BST_CHECKED}
            ${If} $Path_Ex1 != $Empty
                !insertmacro UninstallBash $Path_Ex1 "Extra Path 1"
            ${EndIf}
        ${EndIf}
        ${If} $CheckState_Ex2 == ${BST_CHECKED}
            ${If} $Path_Ex2 != $Empty
                !insertmacro UninstallBash $Path_Ex2 "Extra Path 2"
            ${EndIf}
        ${EndIf}


        ;If it is a complete uninstall remove the shared data:
        ReadRegStr $Path_OB HKLM "Software\Wrye Flash" "Oblivion Path"
        ReadRegStr $Path_Nehrim HKLM "Software\Wrye Flash" "Nehrim Path"
        ReadRegStr $Path_Skyrim HKLM "Software\Wrye Flash" "Skyrim Path"
        ReadRegStr $Path_Ex1 HKLM "Software\Wrye Flash" "Extra Path 1"
        ReadRegStr $Path_Ex2 HKLM "Software\Wrye Flash" "Extra Path 2"
        ${If} $Path_OB == $Empty
            ${AndIf} $Path_Nehrim == $Empty
            ${AndIf} $Path_Skyrim == $Empty
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
