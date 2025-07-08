@echo off

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

set /a layer=1

@rem hosts file script

:hostsFileScript
echo applying layer %layer% protection
set file=C:\Windows\System32\drivers\etc\hosts

findstr /i /c:"#mafazaa-hosts-start" "%file%" >nul
if %errorlevel% equ 0 (
    
    echo protection layer %layer% already exists

    goto regEditChromeScript
) else (    
    :: Create a temporary file
    set temp_file=%file%.tmp

    :: Read the hosts file line by line
    set "skip_lines=false"
    for /f "usebackq delims=" %%L in ("%file%") do (
        if "%%L" equ "#mafazaa-hosts-start" (
            set "skip_lines=true"
        ) else if "%%L" equ "#mafazaa-hosts-end" (
            set "skip_lines=false"
        ) else (
            if "!skip_lines!" equ "false" (
                echo %%L >> "%temp_file%"
            )
        )
    )

    :: Replace the original hosts file with the temporary file
    move /Y "%temp_file%" "%file%"

    echo protection layer %layer% is removed successfully

    goto regEditChromeScript

)


@rem chrome script from the registry editor
:regEditChromeScript
set /a layer=%layer%+1

echo applying layer %layer% protection
set k=HKLM\SOFTWARE\Policies\Google\Chrome
reg query "%k%" >nul 2>&1 || (
    reg add "%k%" /f
)
reg add "%k%" /v "DnsOverHttpsMode" /t REG_SZ /d "automatic" /f
reg add "%k%" /v "DnsOverHttpsTemplates" /t REG_SZ /d "https://family-filter-dns.cleanbrowsing.org" /f
echo protection layer %layer% is applied successfully


@rem brave script from the registry editor
:regEditBraveScript
set /a layer=%layer%+1

echo applying layer %layer% protection
set k=HKLM\Software\Policies\BraveSoftware\Brave
reg query "%k%" >nul 2>&1 || (
    reg add "%k%" /f
)
reg add "%k%" /v "DnsOverHttpsMode" /t REG_SZ /d "automatic" /f
reg add "%k%" /v "DnsOverHttpsTemplates" /t REG_SZ /d "https://family-filter-dns.cleanbrowsing.org" /f
echo protection layer %layer% is applied successfully


@rem netsh script
:netshScript
setlocal enableDelayedExpansion


for /f "tokens=5 delims= " %%i in ('netsh interface ip show interfaces ^| findstr "connected"') do (

    call set /a layer=layer+1
    
    netsh interface ip set dns %%i static 185.228.168.168

    netsh interface ip add dns name="%%i" 185.228.169.168 index=2

    echo layer !layer! is applied successfully
)
echo.
echo.
echo %layer% layers of protection are applied on the device successfully! you can now exit
pause