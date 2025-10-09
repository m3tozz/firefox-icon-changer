@echo off
:: root
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:: --- Icon names ---
set "ICON1=Alecive-Flatwoken-Apps-Firefox-Nightly.ico"
set "ICON2=Ampeross-Ampola-Firefox.ico"
set "ICON3=Ampeross-Qetto.ico"
set "ICON4=Benjigarner-Softdimension-Firefox.ico"
set "ICON5=Blackvariant-Shadow135-System-Safari.ico"
set "ICON6=Bokehlicia-Captiva-Browser-firefox.ico"
set "ICON7=Bokehlicia-Pacifica.ico"
set "ICON8=Carlosjj-Mozilla-Firefox.ico"
set "ICON9=Chrisbanks2-Cold-Fusion-Hd-Safari-rings-black.ico"
set "ICON10=Chrisbanks2-Cold-Fusion-Hd-Safari-rings-green.ico"
set "ICON11=Cornmanthe3rd-Squareplex-Internet-firefox.ico"
set "ICON12=Draseart-Icrea-Safari.ico"
set "ICON13=Flatwoken-Compass.ico"
set "ICON14=Franksouza183-Fs-Apps-firefox.ico"
set "ICON15=Fruityth1ng-Stark-Firefox.ico"
set "ICON16=Guillendesign-Variations.ico"
set "ICON17=Papirus-Team-Papirus-Apps-Firefox-alt.ico"
set "ICON18=Pawelacb-Quilook-dark.ico"
set "ICON19=Pawelacb-Quilook.ico"
set "ICON20=Robsonbillponte-IRob-Misc-Safari.ico"
set "ICON21=Royalflushxx-Browser-Browser-firefox.ico"
set "ICON22=Sora-Meliae-Matrilineare.ico"
set "ICON23=Stalker018-Mmii-Flat-Vol-4-Safari.ico"
set "ICON24=Thebadsaint-My-Mavericks-Part-1-Safari.ico"
set "ICON25=Wineass-Ios7-Redesign-Safari.ico"

:: --- Menu ---
powershell -Command "Write-Host 'Firefox Icon Changer' -ForegroundColor Green"
powershell -Command "Write-Host 'If you have used firefox-icon-changer before in this session, restart your device and run firefox-icon-changer again.' -ForegroundColor Red"
echo [1] %ICON1%
echo [2] %ICON2%
echo [3] %ICON3%
echo [4] %ICON4%
echo [5] %ICON5%
echo [6] %ICON6%
echo [7] %ICON7%
echo [8] %ICON8%
echo [9] %ICON9%
echo [10] %ICON10%
echo [11] %ICON11%
echo [12] %ICON12%
echo [13] %ICON13%
echo [14] %ICON14%
echo [15] %ICON15%
echo [16] %ICON16%
echo [17] %ICON17%
echo [18] %ICON18%
echo [19] %ICON19%
echo [20] %ICON20%
echo [21] %ICON21%
echo [22] %ICON22%
echo [23] %ICON23%
echo [24] %ICON24%
echo [25] %ICON25%

set /P choice=Please make a choice [1-25]: 

:: --- Set the selected icon ---
for /f "tokens=2 delims==" %%I in ('set ICON%choice%') do set "ICON=%%I"

:: --- Firefox EXE check ---
set "EXE=C:\Program Files\Mozilla Firefox\firefox.exe"
if not exist "%EXE%" (
    echo Firefox exe not found: %EXE%
    pause
    exit /b
)

:: --- Tool directory and RCEdit ---
set "TOOLDIR=C:\Tools"
set "RCEDIT=%TOOLDIR%\rcedit-x64.exe"

if not exist "%TOOLDIR%" mkdir "%TOOLDIR%"

:: --- Download RCEdit ---
if not exist "%RCEDIT%" (
    echo rcedit.exe not found, downloading...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/electron/rcedit/releases/latest/download/rcedit-x64.exe' -OutFile '%RCEDIT%'"
)

:: --- Backup ---
if not exist "%EXE%.bak" (
    copy "%EXE%" "%EXE%.bak"
    echo Backup created: %EXE%.bak
)

:: --- Change Firefox icon ---
echo Changing Firefox icon...
"%RCEDIT%" "%EXE%" --set-icon "%~dp0icons\%ICON%"

if %ERRORLEVEL% NEQ 0 echo RCEdit icon change error!

:: --- Clear icon cache ---
echo Resetting Windows icon cache...
taskkill /f /im explorer.exe
del /a /q "%localappdata%\IconCache.db"
start explorer.exe

:: --- Desktop shortcut check and refresh ---
set "DESKTOP=%USERPROFILE%\Desktop"
set "LNK=%DESKTOP%\Firefox.lnk"

if exist "%LNK%" (
    echo Deleting existing shortcut: %LNK%
    del "%LNK%"
)

:: --- Create new shortcut ---
powershell -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%LNK%');$s.TargetPath='%EXE%';$s.IconLocation='%~dp0icons\%ICON%';$s.Save()"

echo Operation completed!
pause
