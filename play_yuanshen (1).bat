@echo off
chcp 65001 >nul
title 原神 - 米哈游启动器下载

echo ==========================================
echo     原神（米哈游启动器）自动下载脚本
echo ==========================================
echo.

set "OUTPUT=%USERPROFILE%\Downloads\mihoyo_launcher_setup.exe"
set "URL=https://hyp-webstatic.mihoyo.com/hyp-client/hyp_cn_setup_1.4.5.exe"
set "FALLBACK_URL=https://launcher.mihoyo.com/"

echo [*] 下载地址: %URL%
echo [*] 保存位置: %OUTPUT%
echo.
echo 正在下载米哈游启动器（约 169 MB），请耐心等待...
echo.

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $ProgressPreference = 'Continue'; try { Invoke-WebRequest -Uri '%URL%' -OutFile '%OUTPUT%' } catch { Write-Host 'Download failed, opening official page...'; Start-Process '%FALLBACK_URL%'; exit 1 }"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 下载失败，正在打开官方下载页面...
    start "" "%FALLBACK_URL%"
    pause
    exit /b 1
)

echo.
echo ==========================================
echo        下载完成！
echo ==========================================
echo.
echo 启动器已保存到: %OUTPUT%
echo.
set /p RUN="是否立即安装？(y/n): "

if /i "%RUN%"=="y" (
    echo 正在启动安装程序...
    start "" "%OUTPUT%"
) else (
    echo 你可以稍后双击运行下载目录中的 mihoyo_launcher_setup.exe
)

pause
