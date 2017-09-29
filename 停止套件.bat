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



:stop
set suite_home=%~dp0
rem echo 正在关闭 Apache Server...
rem taskkill /F /IM httpd.exe > nul
call:stopServer %suite_home%caddy0.10\caddy.exe         "Caddy Server"
call:stopServer %suite_home%php7.1nts\php-cgi.exe       "PHP  FastCGI"
call:stopServer %suite_home%redis3.2\redis-server.exe   "Redis Server"
call:stopServer %suite_home%mysql5.7\bin\mysqld.exe     "MySQL Server"


:end
echo.
echo 套件已经停止，按任意键即可关闭该窗口. . .
pause > nul


:stopServer
echo.
set serv_name=%2
set "serv_name=%serv_name:"=%"
echo 正在关闭 %serv_name%...

set serv_path=%1
set "serv_path=%serv_path:\=\\%"
wmic process where "executablepath='%serv_path%'" delete > nul
echo 已关闭
goto:eof
