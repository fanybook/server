@echo off

:get_admin_permission
CLS
ECHO.
ECHO ================================
ECHO phpCaddy 获取批处理文件管理员权限
ECHO ================================
:init
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion
:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )
:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
rem ECHO.
rem ECHO ********************************
rem ECHO 请求 UAC 权限批准……
rem ECHO ********************************
rem @ping -n 1 127.1>nul
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /B
:gotPrivileges
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)



:check
set suite_home=%~dp0
echo.
echo 正在检查启动结果：
call:checkServer %suite_home%mysql5.7\bin\mysqld.exe    "MySQL Server"  tmp/check/mysql.txt
call:checkServer %suite_home%redis3.2\redis-server.exe  "Redis Server"  tmp/check/redis.txt
call:checkServer %suite_home%php7.1nts\php-cgi.exe      "PHP  FastCGI"  tmp/check/phpcgi.txt
call:checkServer %suite_home%caddy0.10\caddy.exe        "Caddy Server"  tmp/check/caddy.txt
del /f /q /s tmp\*.* > nul


:end
echo.
echo 套件已经启动，按任意键即可关闭该窗口. . .
pause > nul


:checkServer
set serv_name=%2
set "serv_name=%serv_name:"=%"

set serv_path=%1
set "serv_path=%serv_path:\=\\%"
wmic process where "executablepath='%serv_path%'" get executablepath > %3  2>&1
find /i "%1" %3 > nul
if ERRORLEVEL 1 (echo %serv_name% 没有运行) else (echo %serv_name% 正在运行)
goto:eof
