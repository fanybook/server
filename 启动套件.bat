@echo off

:get_admin_permission
CLS
ECHO.
ECHO ================================
ECHO phpCaddy ��ȡ�������ļ�����ԱȨ��
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
rem ECHO ���� UAC Ȩ����׼����
rem ECHO ********************************
rem @ping -n 3 127.1>nul
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



:start
set suite_home=%~dp0
echo �������� MySQL Server...
RunHiddenConsole %suite_home%mysql5.7\bin\mysqld.exe --defaults-file="%suite_home%mysql5.7\my.ini"
echo �������� Redis Server...
RunHiddenConsole %suite_home%redis3.2\redis-server.exe %suite_home%redis3.2\redis.windows.conf
echo �������� PHP FastCGI...
RunHiddenConsole %suite_home%php7.1nts\php-cgi.exe -b 127.0.0.1:9000
echo �������� Caddy Server...
RunHiddenConsole %suite_home%caddy0.10\caddy.exe -conf %suite_home%caddy0.10\Caddyfile
rem echo �������� Apach Server...
rem RunHiddenConsole %suite_home%apache2.4\bin\httpd.exe


:check
echo.
echo ���ڼ�����������
@ping -n 3 127.1>nul
call:checkServer %suite_home%mysql5.7\bin\mysqld.exe    "MySQL Server"  tmp/check/mysql.txt
call:checkServer %suite_home%redis3.2\redis-server.exe  "Redis Server"  tmp/check/redis.txt
call:checkServer %suite_home%php7.1nts\php-cgi.exe      "PHP  FastCGI"  tmp/check/phpcgi.txt
call:checkServer %suite_home%caddy0.10\caddy.exe        "Caddy Server"  tmp/check/caddy.txt
del /f /q /s tmp\check\*.* > nul

echo.
echo.
echo Caddy Ĭ��վ http://127.0.0.1
echo Apach Ĭ��վ http://127.0.0.1:8080


:end
echo.
echo �׼��Ѿ�����������������ɹرոô���. . .
pause > nul

:checkServer
set serv_name=%2
set "serv_name=%serv_name:"=%"

set serv_path=%1
set "serv_path=%serv_path:\=\\%"
wmic process where "executablepath='%serv_path%'" get executablepath > %3  2>&1
find /i "%1" %3 > nul
if ERRORLEVEL 1 (echo %serv_name% ����ʧ��) else (echo %serv_name% �����ɹ�)
goto:eof
