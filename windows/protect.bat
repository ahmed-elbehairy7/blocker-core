@echo off

:: Main script for managing blocker functionalities

:start

    if "%~1"=="" (
        goto :show_usage
    ) else if /i "%~1"=="add_domain" (
        goto :isAdmin
    ) else if /i "%~1"=="apply" (
        goto :isAdmin
    ) else if /i "%~1"=="deactivate" (
        goto :isAdmin
    ) else if /i "%~1"=="enable_youtube" (
        goto :isAdmin
    ) else (
        echo Error: Invalid subcommand "%~1"
        goto :show_usage
    )

:: --- show usage ---
:show_usage
    echo.
    echo Usage: %~nx0 [subcommand]
    echo.
    echo Available subcommands:
    echo   add_domain [domain]        - Adds a domain to the hosts file
    echo   deactivate                 - Deactivates protection (removes hosts entries, resets DNS)
    echo   apply [level] [youtube]    - Applies protection with specified settings:
    echo                                level: high^|low 
    echo                                youtube: true^|false
    echo.
    goto :eof

:: --- check for admin permissions ---
:isAdmin

    :: Check for admin rights
    NET SESSION >nul 2>&1
    if %errorlevel% == 0 (
        echo running protect...
    ) else (
        echo Requesting administrator permissions...
        :: Re-launch as admin
        PowerShell -Command "Start-Process cmd -ArgumentList '/c %~dpnx0 %*' -Verb RunAs"
        exit /b
    )

    set "subcommand=%~1"
    shift

    if /i "%subcommand%"=="add_domain" (
        call :add_domain_func %*
    ) else if /i "%subcommand%"=="deactivate" (
        call :deactivate_func %*
    ) else if /i "%subcommand%"=="apply" (
        call :apply_func %*
    ) else if /i "%subcommand%"=="enable_youtube" (
        call :enable_youtube_func %*
    ) else (
        echo Error: Unknown subcommand "%subcommand%".
        echo Type %~nx0 for usage.
    )

    goto :eof

:: --- Subcommand Functions ---

:: --- add domain subcommand ---
:add_domain_func

    
    if "%~2"=="" (
        echo Error: Text to add not provided.
        exit /b 1
    )

    :: Assign arguments to variables
    set "file_path=%SystemRoot%\System32\drivers\etc\hosts"
    set "text_to_add=%~2 %~3"

    echo adding %text_to_add%
    :: Check if the text already exists in the file
    findstr /x /c:"%text_to_add%" "%file_path%" >nul
    if %ERRORLEVEL% equ 0 (
        echo line '%text_to_add%' already exists in the hosts file.
        exit /b 1
    ) else (
        :: Append the text to the file
        echo %text_to_add%>>"%file_path%"
    )
    
    exit /b 0

:: --- deactivate subcommand ---
:deactivate_func

    set "DnsOverHttps=family-filter-dns.cleanbrowsing.org"
    set "primaryAddress=185.228.168.168"
    set "secondaryAddress=185.228.169.168"
    set "act=removing"
    set "past_act=removed"

    call :apply_dns

    exit /b 0

:: --- apply protection subommand ---
:apply_func
  
    set /a layer=1

    @rem hosts file script

    if /i not "%~2"=="high" if /i not "%~2"=="low" (
        echo Error: Level must be either "high" or "low"
        exit /b 1
    )

    if /i not "%~3"=="true" if /i not "%~3"=="false" (
        echo Error: YouTube setting must be either "true" or "false"
        exit /b 1
    )

    set "level=%~2"
    set "youtube=%~3"

    set "DnsOverHttps=%level%-dns.mafazaa.com"

    if /i "%level%"=="high" (
        set "primaryAddress=15.184.147.40"
        set "secondaryAddress=15.184.182.221"
    ) else (
        set "primaryAddress=16.24.111.209"
        set "secondaryAddress=16.24.202.94"
    )

    set "act=applying"
    set "past_act=applied"

    call :apply_dns

    call :hostsFileScript

    exit /b 0

:: --- common used functions ---

:: --- hosts file script ---
:hostsFileScript
    echo %act% layer %layer% protection
    set file=C:\Windows\System32\drivers\etc\hosts

    findstr /i /c:"#mafazaa-hosts-start" "%file%" >nul
    if %errorlevel% equ 0 (
        echo protection layer %layer% already exists
    ) else (
        echo #mafazaa-hosts-start >> %file%

        call :add_domain_func add_domain "216.239.38.120" "www.google.com"
        
        echo 216.239.38.120 www.google.ad >> %file%
        echo 216.239.38.120 www.google.ae >> %file%
        echo 216.239.38.120 www.google.com.af >> %file%
        echo 216.239.38.120 www.google.com.ag >> %file%
        echo 216.239.38.120 www.google.al >> %file%
        echo 216.239.38.120 www.google.am >> %file%
        echo 216.239.38.120 www.google.co.ao >> %file%
        echo 216.239.38.120 www.google.com.ar >> %file%
        echo 216.239.38.120 www.google.as >> %file%
        echo 216.239.38.120 www.google.at >> %file%
        echo 216.239.38.120 www.google.com.au >> %file%
        echo 216.239.38.120 www.google.az >> %file%
        echo 216.239.38.120 www.google.ba >> %file%
        echo 216.239.38.120 www.google.com.bd >> %file%
        echo 216.239.38.120 www.google.be >> %file%
        echo 216.239.38.120 www.google.bf >> %file%
        echo 216.239.38.120 www.google.bg >> %file%
        echo 216.239.38.120 www.google.com.bh >> %file%
        echo 216.239.38.120 www.google.bi >> %file%
        echo 216.239.38.120 www.google.bj >> %file%
        echo 216.239.38.120 www.google.com.bn >> %file%
        echo 216.239.38.120 www.google.com.bo >> %file%
        echo 216.239.38.120 www.google.com.br >> %file%
        echo 216.239.38.120 www.google.bs >> %file%
        echo 216.239.38.120 www.google.bt >> %file%
        echo 216.239.38.120 www.google.co.bw >> %file%
        echo 216.239.38.120 www.google.by >> %file%
        echo 216.239.38.120 www.google.com.bz >> %file%
        echo 216.239.38.120 www.google.ca >> %file%
        echo 216.239.38.120 www.google.cd >> %file%
        echo 216.239.38.120 www.google.cf >> %file%
        echo 216.239.38.120 www.google.cg >> %file%
        echo 216.239.38.120 www.google.ch >> %file%
        echo 216.239.38.120 www.google.ci >> %file%
        echo 216.239.38.120 www.google.co.ck >> %file%
        echo 216.239.38.120 www.google.cl >> %file%
        echo 216.239.38.120 www.google.cm >> %file%
        echo 216.239.38.120 www.google.cn >> %file%
        echo 216.239.38.120 www.google.com.co >> %file%
        echo 216.239.38.120 www.google.co.cr >> %file%
        echo 216.239.38.120 www.google.com.cu >> %file%
        echo 216.239.38.120 www.google.cv >> %file%
        echo 216.239.38.120 www.google.com.cy >> %file%
        echo 216.239.38.120 www.google.cz >> %file%
        echo 216.239.38.120 www.google.de >> %file%
        echo 216.239.38.120 www.google.dj >> %file%
        echo 216.239.38.120 www.google.dk >> %file%
        echo 216.239.38.120 www.google.dm >> %file%
        echo 216.239.38.120 www.google.com.do >> %file%
        echo 216.239.38.120 www.google.dz >> %file%
        echo 216.239.38.120 www.google.com.ec >> %file%
        echo 216.239.38.120 www.google.ee >> %file%
        echo 216.239.38.120 www.google.com.eg >> %file%
        echo 216.239.38.120 www.google.es >> %file%
        echo 216.239.38.120 www.google.com.et >> %file%
        echo 216.239.38.120 www.google.fi >> %file%
        echo 216.239.38.120 www.google.com.fj >> %file%
        echo 216.239.38.120 www.google.fm >> %file%
        echo 216.239.38.120 www.google.fr >> %file%
        echo 216.239.38.120 www.google.ga >> %file%
        echo 216.239.38.120 www.google.ge >> %file%
        echo 216.239.38.120 www.google.gg >> %file%
        echo 216.239.38.120 www.google.com.gh >> %file%
        echo 216.239.38.120 www.google.com.gi >> %file%
        echo 216.239.38.120 www.google.gl >> %file%
        echo 216.239.38.120 www.google.gm >> %file%
        echo 216.239.38.120 www.google.gr >> %file%
        echo 216.239.38.120 www.google.com.gt >> %file%
        echo 216.239.38.120 www.google.gy >> %file%
        echo 216.239.38.120 www.google.com.hk >> %file%
        echo 216.239.38.120 www.google.hn >> %file%
        echo 216.239.38.120 www.google.hr >> %file%
        echo 216.239.38.120 www.google.ht >> %file%
        echo 216.239.38.120 www.google.hu >> %file%
        echo 216.239.38.120 www.google.co.id >> %file%
        echo 216.239.38.120 www.google.ie >> %file%
        echo 216.239.38.120 www.google.co.il >> %file%
        echo 216.239.38.120 www.google.im >> %file%
        echo 216.239.38.120 www.google.co.in >> %file%
        echo 216.239.38.120 www.google.iq >> %file%
        echo 216.239.38.120 www.google.is >> %file%
        echo 216.239.38.120 www.google.it >> %file%
        echo 216.239.38.120 www.google.je >> %file%
        echo 216.239.38.120 www.google.com.jm >> %file%
        echo 216.239.38.120 www.google.jo >> %file%
        echo 216.239.38.120 www.google.co.jp >> %file%
        echo 216.239.38.120 www.google.co.ke >> %file%
        echo 216.239.38.120 www.google.com.kh >> %file%
        echo 216.239.38.120 www.google.ki >> %file%
        echo 216.239.38.120 www.google.kg >> %file%
        echo 216.239.38.120 www.google.co.kr >> %file%
        echo 216.239.38.120 www.google.com.kw >> %file%
        echo 216.239.38.120 www.google.kz >> %file%
        echo 216.239.38.120 www.google.la >> %file%
        echo 216.239.38.120 www.google.com.lb >> %file%
        echo 216.239.38.120 www.google.li >> %file%
        echo 216.239.38.120 www.google.lk >> %file%
        echo 216.239.38.120 www.google.co.ls >> %file%
        echo 216.239.38.120 www.google.lt >> %file%
        echo 216.239.38.120 www.google.lu >> %file%
        echo 216.239.38.120 www.google.lv >> %file%
        echo 216.239.38.120 www.google.com.ly >> %file%
        echo 216.239.38.120 www.google.co.ma >> %file%
        echo 216.239.38.120 www.google.md >> %file%
        echo 216.239.38.120 www.google.me >> %file%
        echo 216.239.38.120 www.google.mg >> %file%
        echo 216.239.38.120 www.google.mk >> %file%
        echo 216.239.38.120 www.google.ml >> %file%
        echo 216.239.38.120 www.google.com.mm >> %file%
        echo 216.239.38.120 www.google.mn >> %file%
        echo 216.239.38.120 www.google.com.mt >> %file%
        echo 216.239.38.120 www.google.mu >> %file%
        echo 216.239.38.120 www.google.mv >> %file%
        echo 216.239.38.120 www.google.mw >> %file%
        echo 216.239.38.120 www.google.com.mx >> %file%
        echo 216.239.38.120 www.google.com.my >> %file%
        echo 216.239.38.120 www.google.co.mz >> %file%
        echo 216.239.38.120 www.google.com.na >> %file%
        echo 216.239.38.120 www.google.com.ng >> %file%
        echo 216.239.38.120 www.google.com.ni >> %file%
        echo 216.239.38.120 www.google.ne >> %file%
        echo 216.239.38.120 www.google.nl >> %file%
        echo 216.239.38.120 www.google.no >> %file%
        echo 216.239.38.120 www.google.com.np >> %file%
        echo 216.239.38.120 www.google.nr >> %file%
        echo 216.239.38.120 www.google.nu >> %file%
        echo 216.239.38.120 www.google.co.nz >> %file%
        echo 216.239.38.120 www.google.com.om >> %file%
        echo 216.239.38.120 www.google.com.pa >> %file%
        echo 216.239.38.120 www.google.com.pe >> %file%
        echo 216.239.38.120 www.google.com.pg >> %file%
        echo 216.239.38.120 www.google.com.ph >> %file%
        echo 216.239.38.120 www.google.com.pk >> %file%
        echo 216.239.38.120 www.google.pl >> %file%
        echo 216.239.38.120 www.google.pn >> %file%
        echo 216.239.38.120 www.google.com.pr >> %file%
        echo 216.239.38.120 www.google.ps >> %file%
        echo 216.239.38.120 www.google.pt >> %file%
        echo 216.239.38.120 www.google.com.py >> %file%
        echo 216.239.38.120 www.google.com.qa >> %file%
        echo 216.239.38.120 www.google.ro >> %file%
        echo 216.239.38.120 www.google.ru >> %file%
        echo 216.239.38.120 www.google.rw >> %file%
        echo 216.239.38.120 www.google.com.sa >> %file%
        echo 216.239.38.120 www.google.com.sb >> %file%
        echo 216.239.38.120 www.google.sc >> %file%
        echo 216.239.38.120 www.google.se >> %file%
        echo 216.239.38.120 www.google.com.sg >> %file%
        echo 216.239.38.120 www.google.sh >> %file%
        echo 216.239.38.120 www.google.si >> %file%
        echo 216.239.38.120 www.google.sk >> %file%
        echo 216.239.38.120 www.google.com.sl >> %file%
        echo 216.239.38.120 www.google.sn >> %file%
        echo 216.239.38.120 www.google.so >> %file%
        echo 216.239.38.120 www.google.sm >> %file%
        echo 216.239.38.120 www.google.sr >> %file%
        echo 216.239.38.120 www.google.st >> %file%
        echo 216.239.38.120 www.google.com.sv >> %file%
        echo 216.239.38.120 www.google.td >> %file%
        echo 216.239.38.120 www.google.tg >> %file%
        echo 216.239.38.120 www.google.co.th >> %file%
        echo 216.239.38.120 www.google.com.tj >> %file%
        echo 216.239.38.120 www.google.tl >> %file%
        echo 216.239.38.120 www.google.tm >> %file%
        echo 216.239.38.120 www.google.tn >> %file%
        echo 216.239.38.120 www.google.to >> %file%
        echo 216.239.38.120 www.google.com.tr >> %file%
        echo 216.239.38.120 www.google.tt >> %file%
        echo 216.239.38.120 www.google.com.tw >> %file%
        echo 216.239.38.120 www.google.co.tz >> %file%
        echo 216.239.38.120 www.google.com.ua >> %file%
        echo 216.239.38.120 www.google.co.ug >> %file%
        echo 216.239.38.120 www.google.co.uk >> %file%
        echo 216.239.38.120 www.google.com.uy >> %file%
        echo 216.239.38.120 www.google.co.uz >> %file%
        echo 216.239.38.120 www.google.com.vc >> %file%
        echo 216.239.38.120 www.google.co.ve >> %file%
        echo 216.239.38.120 www.google.co.vi >> %file%
        echo 216.239.38.120 www.google.com.vn >> %file%
        echo 216.239.38.120 www.google.vu >> %file%
        echo 216.239.38.120 www.google.ws >> %file%
        echo 216.239.38.120 www.google.rs >> %file%
        echo 216.239.38.120 www.google.co.za >> %file%
        echo 216.239.38.120 www.google.co.zm >> %file%
        echo 216.239.38.120 www.google.co.zw >> %file%
        echo 216.239.38.120 www.google.cat >> %file%
        echo 20.207.72.188 duckduckgo.com >> %file%
        echo 204.79.197.220 www.bing.com bing.com >> %file%
        echo 204.79.197.220 www2.bing.com >> %file%
        echo 204.79.197.220 www3.bing.com >> %file%


        if /i "%youtube%"=="true" (
            echo 172.217.19.142	www.youtube.com >> %file%
            echo 142.250.200.238 m.youtube.com >> %file%
            echo 172.217.21.10 youtubei.googleapis.com >> %file%
            echo 172.217.21.10 youtube.googleapis.com >> %file%
            echo 142.250.201.46 www.youtube-nocookie.com >> %file%
        )

        echo #mafazaa-hosts-end >> %file%

        echo protection layer %layer% is %past_act% successfully
    )

    exit /b 0

:: --- apply dns ---
:apply_dns

    @rem chrome script from the registry editor
    :regEditChromeScript
    set /a layer=1

    echo %primaryAddress% %secondaryAddress% %DnsOverHttps%

    echo applying layer %layer% protection
    set k=HKLM\SOFTWARE\Policies\Google\Chrome
    reg query "%k%" >nul 2>&1 || (
        reg add "%k%" /f
    )
    reg add "%k%" /v "DnsOverHttpsMode" /t REG_SZ /d "automatic" /f
    reg add "%k%" /v "DnsOverHttpsTemplates" /t REG_SZ /d "https://%DnsOverHttps%" /f
    echo protection layer %layer% is %past_act% successfully


    @rem brave script from the registry editor
    :regEditBraveScript
    set /a layer=%layer%+1

    echo %act% layer %layer% protection
    set k=HKLM\Software\Policies\BraveSoftware\Brave
    reg query "%k%" >nul 2>&1 || (
        reg add "%k%" /f
    )
    reg add "%k%" /v "DnsOverHttpsMode" /t REG_SZ /d "automatic" /f
    reg add "%k%" /v "DnsOverHttpsTemplates" /t REG_SZ /d "https://%DnsOverHttps%" /f
    echo protection layer %layer% is %past_act% successfully


    @rem netsh script
    :netshScript
    setlocal enableDelayedExpansion


    for /f "tokens=5 delims= " %%i in ('netsh interface ip show interfaces ^| findstr "connected"') do (

        call set /a layer=layer+1
        
        netsh interface ip set dns %%i static %primaryAddress%

        netsh interface ip add dns name="%%i" %secondaryAddress% index=2

        echo layer !layer! is %past_act% successfully
    )
    echo.
    echo.
    echo %layer% layers of protection are %past_act% on the device successfully!

    exit /b 0
:: --- finish functions ---
