@echo off
setlocal enabledelayedexpansion
title Hema Cam - PC Launcher
cd /d "%~dp0"

echo ============================================
echo           Hema Cam - Windows Launcher
echo   (runs inside WSL - Linux on Windows)
echo ============================================
echo.

rem ---------------- 1. WSL exists? ----------------
where wsl >nul 2>nul
if errorlevel 1 goto :nowsl

rem ---------------- 2. Any Linux distro? ----------------
wsl -e sh -lc "echo ok" >nul 2>nul
if errorlevel 1 goto :nodistro

rem ---------------- 3. Convert this folder to WSL path ----------------
for /f "usebackq delims=" %%i in (`powershell -NoProfile -Command "$p=(Get-Location).Path; $p -replace '\\','/' -replace '^([A-Za-z]):','/mnt/$1'"`) do set "WSLPATH=%%i"

rem ---------------- 4. First-time setup (once) ----------------
wsl -e sh -lc "test -f ~/.hema_cam_ready" >nul 2>nul
if errorlevel 1 (
    echo.
    echo First-time setup: installing php, curl, wget, unzip, git, procps...
    echo If it asks for a password, type it here and press Enter.
    echo.
    wsl -e bash -lc "export DEBIAN_FRONTEND=noninteractive; sudo apt-get update -y && sudo apt-get install -y php-cli curl wget unzip git procps && touch ~/.hema_cam_ready"
    if errorlevel 1 (
        echo.
        echo Setup failed. Check your internet connection and try again.
        pause
        exit /b 1
    )
)

rem ---------------- 5. Fix line endings and launch ----------------
echo.
echo Starting Hema Cam...
echo Press Ctrl+C inside the tool to exit.
echo.
wsl -e bash -lc "cd '%WSLPATH%' && sed -i 's/\r$//' hema.sh && bash hema.sh"

echo.
echo Hema Cam closed. Press any key to exit.
pause
exit /b 0

:nowsl
echo.
echo WSL is NOT installed on this PC.
echo.
echo To install it, open "Windows PowerShell" as Administrator and run:
echo.
echo     wsl --install -d Ubuntu
echo.
echo Then RESTART your PC and double-click this file again.
echo.
pause
exit /b 1

:nodistro
echo.
echo WSL is enabled but has no Linux distribution (Ubuntu) installed.
echo.
echo To install it, open "Windows PowerShell" as Administrator and run:
echo.
echo     wsl --install -d Ubuntu
echo.
echo Then RESTART your PC and double-click this file again.
echo.
pause
exit /b 1