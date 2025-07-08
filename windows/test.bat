@echo off

echo %*
pause

NET SESSION >nul 2>&1
if %errorlevel% == 0 (
    echo running protect...
) else (
    echo Requesting administrator permissions...
    :: Re-launch as admin
    PowerShell -Command "Start-Process cmd -ArgumentList '/c %~dpnx0 %*' -Verb RunAs"
    exit /b
)