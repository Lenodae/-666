@echo off
chcp 65001 >nul
title 原神 — 一键下载安装

echo ==========================================
echo   原神 — 一键下载安装米哈游启动器
echo ==========================================
echo.

:: === 配置 ===
set "OUTPUT=%USERPROFILE%\Downloads\mihoyo_launcher_setup.exe"
set "URL=https://hyp-webstatic.mihoyo.com/hyp-client/hyp_cn_setup_1.4.5.exe"
set "FALLBACK_URL=https://launcher.mihoyo.com/"
set "LAUNCHER_PATH=C:\Program Files\miHoYo Launcher\launcher.exe"

:: === 检查是否已安装 ===
if exist "%LAUNCHER_PATH%" (
    echo [!] 检测到米哈游启动器已安装
    echo     路径: %LAUNCHER_PATH%
    echo.
    set /p SKIP="启动器已存在，是否直接打开？(y/n): "
    if /i "%SKIP%"=="y" (
        echo 正在打开启动器...
        start "" "%LAUNCHER_PATH%"
        goto :DONE
    )
    echo 将重新下载安装...
    echo.
)

:: === 下载启动器 ===
echo [*] 下载地址: %URL%
echo [*] 保存位置: %OUTPUT%
echo [*] 文件大小: 约 169 MB
echo.
echo 正在下载米哈游启动器，请耐心等待...
echo.

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $ProgressPreference = 'Continue'; try { Invoke-WebRequest -Uri '%URL%' -OutFile '%OUTPUT%' } catch { Write-Host 'FAILED'; exit 1 }"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 直接下载失败，正在打开官网备用...
    start "" "%FALLBACK_URL%"
    pause
    exit /b 1
)

echo.
echo ==========================================
echo   下载完成，正在静默安装启动器...
echo ==========================================
echo.

:: === 静默安装（NSIS /S）===
echo [*] 正在安装（请勿关闭此窗口）...
"%OUTPUT%" /S

:: 等待安装完成（最多等 60 秒）
set /a COUNT=0
:WAIT_LOOP
timeout /t 2 /nobreak >nul
set /a COUNT+=2
if exist "%LAUNCHER_PATH%" goto :INSTALL_DONE
if %COUNT% LSS 60 goto :WAIT_LOOP

:INSTALL_DONE
if exist "%LAUNCHER_PATH%" (
    echo [√] 安装成功！
    echo     路径: %LAUNCHER_PATH%
    echo.
    echo ==========================================
    echo   正在打开米哈游启动器...
    echo ==========================================
    echo.
    echo 请在启动器中：
    echo   1. 登录你的米哈游账号
    echo   2. 在原神右侧点击「下载」
    echo   3. 等待游戏下载完成（约 70GB+）
    echo.
    start "" "%LAUNCHER_PATH%"
) else (
    echo [X] 安装可能未完成，但启动器可能已安装到其他位置。
    echo     请检查开始菜单中的「米哈游启动器」。
    echo.
    start "" "%LAUNCHER_PATH%"
)

:: === 清理 ===
echo [!] 是否删除安装包以释放空间？
set /p DEL="删除下载的安装包？(y/n): "
if /i "%DEL%"=="y" (
    del "%OUTPUT%"
    echo [√] 已删除安装包
)

:DONE
echo.
echo 全部完成！原神下载将在启动器内进行。
pause
