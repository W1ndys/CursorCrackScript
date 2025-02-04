@echo off
chcp 65001 >nul

REM 颜色定义
set RED=
set GREEN=
set YELLOW=
set BLUE=
set NC=

REM 配置文件路径
set "STORAGE_FILE=%APPDATA%\Cursor\User\globalStorage\storage.json"
set "BACKUP_DIR=%APPDATA%\Cursor\User\globalStorage\backups"

REM 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 请以管理员身份运行此脚本
    echo 请右键点击脚本，选择'以管理员身份运行'
    pause
    exit /b 1
)

REM 显示 Logo
cls
echo.
echo     ██████╗██╗   ██╗██████╗ ███████╗ ██████╗ ██████╗ 
echo    ██╔════╝██║   ██║██╔══██╗██╔════╝██╔═══██╗██╔══██╗
echo    ██║     ██║   ██║██████╔╝███████╗██║   ██║██████╔╝
echo    ██║     ██║   ██║██╔══██╗╚════██║██║   ██║██╔══██╗
echo    ╚██████╗╚██████╔╝██║  ██║███████║╚██████╔╝██║  ██║
echo     ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
echo.
echo ================================================
echo       Cursor ID 修改工具
echo ================================================
echo.
echo [重要提示] 本工具仅支持 Cursor v0.44.11 及以下版本
echo [重要提示] 最新的 0.45.x 版本暂不支持
echo.

REM 检查并关闭 Cursor 进程
echo [信息] 检查 Cursor 进程...

REM 关闭所有 Cursor 进程
tasklist /FI "IMAGENAME eq Cursor.exe" 2>NUL | find /I /N "Cursor.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo [警告] 发现 Cursor 正在运行
    taskkill /F /IM Cursor.exe
    echo [信息] Cursor 已成功关闭
)

REM 创建备份目录
if not exist "%BACKUP_DIR%" (
    mkdir "%BACKUP_DIR%"
)

REM 备份现有配置
if exist "%STORAGE_FILE%" (
    echo [信息] 正在备份配置文件...
    set "backup_name=storage.json.backup_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
    copy "%STORAGE_FILE%" "%BACKUP_DIR%\%backup_name%"
)

REM 生成新的 ID
echo [信息] 正在生成新的 ID...

REM 生成随机 UUID
for /f "delims=" %%i in ('powershell -Command "[guid]::NewGuid().ToString()"') do set UUID=%%i

REM 更新配置文件
if not exist "%STORAGE_FILE%" (
    echo [错误] 未找到配置文件: %STORAGE_FILE%
    echo [提示] 请先安装并运行一次 Cursor 后再使用此脚本
    pause
    exit /b 1
)

REM 使用 PowerShell 更新 JSON 文件
powershell -Command ^
    "$json = Get-Content -Path '%STORAGE_FILE%' | ConvertFrom-Json; " ^
    "if (-not $json.telemetry) { $json | Add-Member -MemberType NoteProperty -Name 'telemetry' -Value @{} }; " ^
    "$json.telemetry.machineId = '%UUID%'; " ^
    "$json.telemetry.macMachineId = '%UUID%'; " ^
    "$json.telemetry.devDeviceId = '%UUID%'; " ^
    "$json.telemetry.sqmId = '{%UUID%}'; " ^
    "$json | ConvertTo-Json | Set-Content -Path '%STORAGE_FILE%'"

echo [信息] 成功更新配置文件

REM 显示结果
echo.
echo [信息] 已更新配置:
echo [调试] machineId: %UUID%
echo [调试] macMachineId: %UUID%
echo [调试] devDeviceId: %UUID%
echo [调试] sqmId: {%UUID%}

REM 显示文件树结构
echo.
echo [信息] 文件结构:
echo %APPDATA%\Cursor\User
echo ├── globalStorage
echo │   ├── storage.json (已修改)
echo │   └── backups

REM 列出备份文件
for %%f in ("%BACKUP_DIR%\*") do (
    echo │       └── %%~nxf
)


echo.
echo ================================================
echo   Powered by  W1ndys | https://github.com/W1ndys
echo ================================================
echo.
echo [信息] 请重启 Cursor 以应用新的配置
echo.
echo 按任意键退出...
pause >nul
exit /b 0 