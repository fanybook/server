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
ECHO.
ECHO ********************************
ECHO ���� UAC Ȩ����׼����
ECHO ********************************
@ping -n 3 127.1>nul
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



:install
echo.
set suite_home=%~dp0

if exist %~dpnx0.lock (
    echo �Ѿ���װ�����׼���
    echo mysql/data �� ϵͳ��������Ӧ���Ѵ���
    echo ������ٴΰ�װ����ɾ��������� .lock�ļ�
    goto end
)

echo.
echo ���ڳ�ʼ�� MySQL Server...
set /p custom_user=�������û�������Ĭ��Ϊ root����
set /p custom_pswd=���������루����Ĭ��Ϊ root123����
if "%custom_user%" == "" (
    set custom_user=root
)
if "%custom_pswd%" == "" (
    set custom_pswd=root123
)
%suite_home%mysql5.7\bin\mysqld.exe --initialize-insecure --user=%custom_user%
%suite_home%RunHiddenConsole %suite_home%mysql5.7\bin\mysqld.exe  --defaults-file="%suite_home%mysql5.7\my.ini"
@ping -n 3 127.1>nul

%suite_home%mysql5.7\bin\mysqladmin.exe -u %custom_user% password %custom_pswd%
taskkill /F /IM mysqld.exe > nul
echo MySQL�û���%custom_user%
echo MySQL���룺%custom_pswd%
@ping -n 2 127.1>nul

echo.
echo �������û�������...
wmic ENVIRONMENT where "name='path' and username='<system>'" set VariableValue="%suite_home%php7.1nts;%suite_home%mysql5.7\bin;%suite_home%hugo0.27;%path%"
setx path "%path%"

rem echo.
rem echo �����滻�����ļ��е�·��...

echo.
echo �������ɰ�װ���ļ�...
echo > %~dpnx0.lock
echo %~dpnx0.lock ������

echo.
echo �׼���װ�ɹ�������ͨ��:
echo �����׼�.bat   ���������׼�
echo ֹͣ�׼�.bat   ����ֹͣ�׼�
echo �����׼�.bat   ���������׼�


:end
echo.
echo ����������ɹرոô���. . .
pause > nul
