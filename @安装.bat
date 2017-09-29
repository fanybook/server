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
ECHO.
ECHO ********************************
ECHO 请求 UAC 权限批准……
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
    echo 已经安装过了套件了
    echo mysql/data 和 系统环境变量应该已存在
    echo 如果想再次安装，请删除上面两项及 .lock文件
    goto end
)

echo.
echo 正在初始化 MySQL Server...
set /p custom_user=请输入用户（留空默认为 root）：
set /p custom_pswd=请输入密码（留空默认为 root123）：
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
echo MySQL用户：%custom_user%
echo MySQL密码：%custom_pswd%
@ping -n 2 127.1>nul

echo.
echo 正在设置环境变量...
wmic ENVIRONMENT where "name='path' and username='<system>'" set VariableValue="%suite_home%php7.1nts;%suite_home%mysql5.7\bin;%suite_home%hugo0.27;%path%"
setx path "%path%"

rem echo.
rem echo 正在替换配置文件中的路径...

echo.
echo 正在生成安装锁文件...
echo > %~dpnx0.lock
echo %~dpnx0.lock 被创建

echo.
echo 套件安装成功，可以通过:
echo 启动套件.bat   用于启动套件
echo 停止套件.bat   用于停止套件
echo 重启套件.bat   用于重启套件


:end
echo.
echo 按任意键即可关闭该窗口. . .
pause > nul
