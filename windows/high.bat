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

:regEditChromeScript
echo protecting chrome...
set k=HKLM\SOFTWARE\Policies\Google\Chrome
reg query "%k%" >nul 2>&1 || (
    reg add "%k%" /f
)
reg add "%k%" /v "DnsOverHttpsMode" /t REG_SZ /d "automatic" /f
reg add "%k%" /v "DnsOverHttpsTemplates" /t REG_SZ /d "https://high-dns.mafazaa.com" /f
echo finished protecting chrome successfully

:regEditBraveScript
echo protecting brave...
set k=HKLM\Software\Policies\BraveSoftware\Brave
reg query "%k%" >nul 2>&1 || (
    reg add "%k%" /f
)
reg add "%k%" /v "DnsOverHttpsMode" /t REG_SZ /d "automatic" /f
reg add "%k%" /v "DnsOverHttpsTemplates" /t REG_SZ /d "https://high-dns.mafazaa.com" /f
echo finished protecting brave successfully

:netshScript
for /f "tokens=5 delims= " %%i in ('netsh interface ip show interfaces ^| findstr "connected"') do (

    @rem setting primary dns
    netsh interface ip set dns %%i static 15.184.147.40

    @rem setting secondary dns
    netsh interface ip add dns name="%%i" 15.184.182.221 index=2

    echo a new interface is protected!!
)



echo everything is ok now! you can exit
pause