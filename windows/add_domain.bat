@echo off


if "%~1"=="" (
    echo Error: Text to add not provided.
    exit /b 1
)

:isAdmin
:: Check for admin rights
NET SESSION >nul 2>&1
if %errorlevel% == 0 (
    echo protecting the device...
) else (
    echo Requesting administrator permissions...
    :: Re-launch as admin
    PowerShell -Command "Start-Process cmd -ArgumentList '/c %~dpnx0' -Verb RunAs"
    exit /b
)

:: Assign arguments to variables
set "file_path=%SystemRoot%\System32\drivers\etc\hosts"
set "text_to_add=%~1"

:: Check if the file is writable
echo.>>"%file_path%" 2>nul
if %ERRORLEVEL% neq 0 (
    echo Error: File '%file_path%' is not writable.
    exit /b 1
)

:: Check if the text already exists in the file
findstr /x /c:"%text_to_add%" "%file_path%" >nul
if %ERRORLEVEL% equ 0 (
    echo Text '%text_to_add%' already exists in '%file_path%'.
) else (
    :: Append the text to the file
    echo %text_to_add%>>"%file_path%"
    if %ERRORLEVEL% equ 0 (
        echo Text '%text_to_add%' successfully appended to '%file_path%'.
    ) else (
        echo Error: Failed to append text to '%file_path%'.
        exit /b 1
    )
)

exit /b 0
