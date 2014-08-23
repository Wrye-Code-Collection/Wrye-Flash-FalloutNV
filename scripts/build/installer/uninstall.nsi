; uninstall.nsi
; Uninstallation script for Wrye Flash NSIS uninstaller.

; !include 'macro_uninstall.nsh' ; Already included from pages.nsi

;-------------------------------- The Uninstallation Code:
    Section "Uninstall"
        ; Remove files and Directories - Directories are only deleted if empty.
        ${If} $CheckState_NV == ${BST_CHECKED}
            ${If} $Path_NV != $Empty
                !insertmacro UninstallFlash $Path_NV "FalloutNV"
            ${EndIf}
        ${EndIf}


        ;If it is a complete uninstall remove the shared data:
        ReadRegStr $Path_NV HKLM "Software\Wrye FlashNV" "FalloutNV Path"
        ${If} $Path_NV == $Empty
            DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Wrye FlashNV"
            ReadRegStr $0 HKLM "Software\Wrye FlashNV" "Installer Path"
            DeleteRegKey HKLM "SOFTWARE\Wrye FlashNV"
            ;Delete stupid Windows created registry keys:
            DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\App Management\ARPCache\Wrye FlashNV"
            DeleteRegValue HKCR "Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "$COMMONFILES\Wrye FlashNV\Uninstall.exe"
            DeleteRegValue HKCU "Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "$COMMONFILES\Wrye FlashNV\Uninstall.exe"
            DeleteRegValue HKCU "Software\Microsoft\Windows\ShellNoRoam\MuiCache" "$COMMONFILES\Wrye FlashNV\Uninstall.exe"
            DeleteRegValue HKCR "Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "$0"
            DeleteRegValue HKCU "Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "$0"
            DeleteRegValue HKCU "Software\Microsoft\Windows\ShellNoRoam\MuiCache" "$0"
            Delete "$SMPROGRAMS\Wrye FlashNV\*.*"
            RMDir "$SMPROGRAMS\Wrye FlashNV"
            Delete "$COMMONFILES\Wrye FlashNV\*.*"
            RMDir "$COMMONFILES\Wrye FlashNV"
        ${EndIf}
        SectionEnd
