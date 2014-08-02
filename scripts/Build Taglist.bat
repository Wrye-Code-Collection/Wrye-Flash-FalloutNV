@echo off
title Wrye Bash Taglist Generator
Copy "C:\BOSS\Fallout 3\masterlist.txt" "..\Mopy\taglist\Fallout 3"
Copy "C:\BOSS\Fallout New Vegas\masterlist.txt" "..\Mopy\taglist\Fallout New Vegas"
Copy "C:\BOSS\Oblivion\masterlist.txt" "..\Mopy\taglist\Oblivion"
Copy "C:\BOSS\Skyrim\masterlist.txt" "..\Mopy\taglist\Skyrim"
echo.
echo.

"C:\Python27\python.exe" "C:\Users\DanoPDX\Documents\GitHub\garybash\scripts\mktaglist.py"

echo.
echo.

echo. All Done!
pause