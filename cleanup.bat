:: checkvar
@echo off
:: Check if running with admin privileges
:: If not, re-run as administrator
openfiles >nul 2>&1
if '%errorlevel%' NEQ '0' (
    echo Requesting elevation...
    powershell -Command "Start-Process cmd.exe -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

:: Download the latest version of this script
echo Updating script...
curl -o "%~f0" https://raw.githubusercontent.com/Spid3rishere/cleanup-pc/main/cleanup.bat
echo Script updated. Restarting...

:: Re-run the updated script
"%~f0"
exit /b

:: Your original script starts here
setlocal EnableDelayedExpansion

:: Get computer name
set COMPUTERNAME=%COMPUTERNAME%

:: Delete Temp files and folders
echo Deleting temporary files and folders in Temp folder...
set fileCount=0
set folderCount=0

for /d %%d in (C:\Users\%USERNAME%\AppData\Local\Temp\*) do (
    rd /s /q "%%d" >nul 2>&1
    if not exist "%%d" (
        set /a folderCount+=1
    )
)

for %%f in (C:\Users\%USERNAME%\AppData\Local\Temp\*.*) do (
    del /f /q "%%f" >nul 2>&1
    if not exist "%%f" (
        set /a fileCount+=1
    )
)
echo %fileCount% files and %folderCount% folders deleted from Temp.

:: Delete Prefetch files and folders
echo Deleting files and folders in Prefetch folder...
set pfileCount=0
set pfolderCount=0

for /d %%d in (C:\Windows\Prefetch\*) do (
    rd /s /q "%%d" >nul 2>&1
    if not exist "%%d" (
        set /a pfolderCount+=1
    )
)

for %%f in (C:\Windows\Prefetch\*.*) do (
    del /f /q "%%f" >nul 2>&1
    if not exist "%%f" (
        set /a pfileCount+=1
    )
)
echo %pfileCount% files and %pfolderCount% folders deleted from Prefetch.

:: Send notification to Discord webhook with embedded message
curl --ssl-no-revoke -H "Content-Type: application/json" -X POST -d "{\"embeds\": [{\"title\": \"Cleanup Report\",\"description\": \"Cleanup completed on %COMPUTERNAME%:\n\n- %fileCount% files and %folderCount% folders deleted from Temp\n- %pfileCount% files and %pfolderCount% folders deleted from Prefetch.\",\"color\": 65280}]}" "https://discord.com/api/webhooks/1274202676782960660/y1TqAY_-9L4YM7MYnmN1NPpJS8FmxH6DgMTZ5JpMxP4DQeKrvvTcZA7SVSddJ4R6d5AI"

echo Cleaning process completed.
pause
