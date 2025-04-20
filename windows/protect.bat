@echo off

:isAdmin
:: Check for admin rights
NET SESSION >nul 2>&1
if %errorLevel% == 0 (
    echo protecting the device...
) else (
    echo Requesting administrator permissions...
    :: Re-launch as admin
    PowerShell -Command "Start-Process cmd -ArgumentList '/c %~dpnx0' -Verb RunAs"
    exit /b
)

:netshScript
for /f "tokens=5 delims= " %%i in ('netsh interface ip show interfaces ^| findstr "connected"') do (

    @rem setting primary dns
    netsh interface ip set dns %%i static {{primary-dns}}

    @rem setting secondary dns
    netsh interface ip add dns name="%%i" {{secondary-dns}} index=2

    echo a new interface is protected!!
)

echo everything is ok now! you can exit
pause