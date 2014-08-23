; macros.nsh
; Install/Uninstall macros for Wrye Flash NSIS installer.


; Prevent redefining the macro if included multiple times
!ifmacrondef InstallBashFiles
    !macro InstallBashFiles GameName GameTemplate GameDir RegValuePy RegValueExe RegPath DoPython DoExe DoAII
        ; Parameters:
        ;  GameName - name of the game files are being installed for.  This is used for registry entries
        ;  GameTemplate - name of the game that the template files are coming from (for example, Nehrim uses FalloutNV files for templates)
        ;  GameDir - base directory for the game (one folder up from the Data directory)
        ;  RegValuePy - Registry value for the python version (Usually of the form $Reg_Value_NV_Py)
        ;  RegValueExe - Registry value for the standalone version
        ;  RegPath - Name of the registry string that will hold the path installing to
        ;  DoPython - Install python version of Wrye Flash (should be {BST_CHECKED} for true - this allows you to simple pass the state of the checkbox)
        ;  DoExe - Install the standalone version of Wrye Flash (should be {BST_CHECKED} for true)
        ;  IsExtra - true or false: if false, template files are not installed (since we don't know which type of game it is)
        ;  DoAII - true or false: if true, installs the ArchiveInvalidationInvalidated files (FalloutNV based games)

        ; Install common files
        SetOutPath "${GameDir}\Mopy"
        File /r /x "*.bat" /x "*.py*" /x "w9xpopen.exe" /x "Wrye Flash.exe" "Mopy\*.*"
        ${If} ${DoAII} == true
            ; Some games don't use ArchiveInvalidationInvalidated
            SetOutPath "${GameDir}\Data"
            ; ArchiveInvalidationInvalidated!.bsa not included
            ; TODO copy one from NMM or FOMM
            ; File /r "Mopy\templates\FalloutNV\ArchiveInvalidationInvalidated!.bsa"
        ${EndIf}
        WriteRegStr HKLM "SOFTWARE\Wrye FlashNV" "${RegPath}" "${GameDir}"
        ${If} ${DoPython} == ${BST_CHECKED}
            ; Install Python only files
            SetOutPath "${GameDir}\Mopy"
            File /r "Mopy\*.py" "Mopy\*.pyw" "Mopy\*.bat"
            ; Write the installation path into the registry
            WriteRegStr HKLM "SOFTWARE\Wrye FlashNV" "${GameName} Python Version" "True"
        ${ElseIf} ${RegValuePy} == $Empty
            ; Only write this entry if it's never been installed before
            WriteRegStr HKLM "SOFTWARE\Wrye FlashNV" "${GameName} Python Version" ""
        ${EndIf}
        ${If} ${DoExe} == ${BST_CHECKED}
            ; Install the standalone only files
            SetOutPath "${GameDir}\Mopy"
            File "Mopy\Wrye Flash.exe"
            ${IfNot} ${AtLeastWinXP}
                # Running earlier than WinXP, need w9xpopen
                File "Mopy\w9xpopen.exe"
            ${EndIf}
            ; Write the installation path into the registry
            WriteRegStr HKLM "SOFTWARE\Wrye FlashNV" "${GameName} Standalone Version" "True"
        ${ElseIf} ${RegValueExe} == $Empty
            ; Only write this entry if it's never been installed before
            WriteRegStr HKLM "SOFTWARE\Wrye FlashNV" "${GameName} Standalone Version" ""
        ${EndIf}
    !macroend


    !macro RemoveRegistryEntries GameName
        ; Paramters:
        ;  GameName -  name of the game to remove registry entries for
        
        DeleteRegValue HKLM "SOFTWARE\Wrye FlashNV" "${GameName} Path"
        DeleteRegValue HKLM "SOFTWARE\Wrye FlashNV" "${GameName} Python Version"
        DeleteRegValue HKLM "SOFTWARE\Wrye FlashNV" "${GameName} Standalone Version"
    !macroend


    !macro RemoveOldFiles Path
        ; Old files with the name Wrye Bash
        Delete "${Path}\Mopy\Wrye Bash Debug.bat"
        Delete "${Path}\Mopy\Wrye Bash Launcher.pyw"
        Delete "${Path}\Mopy\Wrye Bash.html"
        ; Oblivion specific files not used with Wrye Flash
        Delete "${Path}\Data\Bash Patches\Bash_Groups.csv"
        ${If} ${AtLeastWinXP}
            # Running XP or later, w9xpopen is only for 95/98/ME
            Delete "${Path}\Mopy\w9xpopen.exe"
        ${EndIf}
    !macroend


    !macro RemoveCurrentFiles Path
        ; Remove files belonging to current build
        RMDir /r "${Path}\Mopy"
        ; Do not remove ArchiveInvalidationInvalidated!, because if it's registeredDelete
        ; in the users INI file, this will cause problems
        ; Delete "${Path}\Data\ArchiveInvalidationInvalidated!.bsa"
        RMDir "${Path}\Data\INI Tweaks"
        RMDir "${Path}\Data\Docs"
        RMDir "${Path}\Data\Bash Patches"
        ; No idea what this really does
        Delete "$SMPROGRAMS\Wrye FlashNV\*falloutnv*"
    !macroend

    !macro UninstallFlash GamePath GameName
        !insertmacro RemoveOldFiles "${GamePath}"
        !insertmacro RemoveCurrentFiles "${GamePath}"
        !insertmacro RemoveRegistryEntries "${GameName}"
    !macroend
!endif
