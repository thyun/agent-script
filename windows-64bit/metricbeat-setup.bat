@if "%DEBUG%" == "" @echo off

@rem Set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" setlocal

set DOWNLOAD_BASE_HOME=http://downloads.jmsight.com
set DOWNLOAD_BASE_NAME=metricbeat-6.7.2-windows-x86_64
set DOWNLOAD_BASE_FILE=%DOWNLOAD_BASE_NAME%.zip
set DOWNLOAD_BASE_URL=%DOWNLOAD_BASE_HOME%/downloads/%DOWNLOAD_BASE_FILE%
set DOWNLOAD_EXT_HOME=http://downloads.jmsight.com
set DOWNLOAD_EXT_FILE=metricbeat-ext.zip
set DOWNLOAD_EXT_URL=%DOWNLOAD_BASE_HOME%/downloads/%DOWNLOAD_EXT_FILE%

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.
set SETUP_BASE_NAME=%~n0
set SETUP_HOME=%DIRNAME%
set PROGRAM=metricbeat
set PROGRAM_HOME=%SETUP_HOME%%PROGRAM%\
set PROGRAM_SCRIPT=%PROGRAM%.bat

@rem Add default JVM options here. You can also use JAVA_OPTS and GRADLE_OPTS to pass JVM options to this script.
set DEFAULT_JVM_OPTS=

@rem Find java.exe
if defined JAVA_HOME goto findJavaFromJavaHome

set JAVA_EXE=java.exe
%JAVA_EXE% -version >NUL 2>&1
if "%ERRORLEVEL%" == "0" goto init

echo.
echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:findJavaFromJavaHome
set JAVA_HOME=%JAVA_HOME:"=%
set JAVA_EXE=%JAVA_HOME%/bin/java.exe

if exist "%JAVA_EXE%" goto init

echo.
echo ERROR: JAVA_HOME is set to an invalid directory: %JAVA_HOME%
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail



:init
@rem Get command-line arguments, handling Windows variants
echo SETUP_HOME=%SETUP_HOME%
echo PROGRAM_HOME=%PROGRAM_HOME%
if not "%OS%" == "Windows_NT" goto win9xME_args

:win9xME_args
@rem Slurp the command line arguments.
set CMD_LINE_ARGS=
set _SKIP=2

:win9xME_args_slurp
if "x%~1" == "x" goto execute

set CMD_LINE_ARGS=%*

:execute
echo Installing %PROGRAM%:
if NOT EXIST %PROGRAM_HOME% goto continue_execute

:move_dir
echo Previously installed directory exist, moving
call "%PROGRAM_HOME%%PROGRAM_SCRIPT%" stop
MOVE %PROGRAM% %PROGRAM%-%date:~0,4%%date:~5,2%%date:~8,2%-%time:~0,2%%time:~3,2%%time:~6,2%

:continue_execute
PowerShell -Command "(new-object System.Net.WebClient).DownloadFile(\"%DOWNLOAD_BASE_URL%\", \".\%DOWNLOAD_BASE_FILE%\")"
if NOT "%ERRORLEVEL%"=="0" goto fail
PowerShell -Command "$ProgressPreference=\"SilentlyContinue\"; Expand-Archive %DOWNLOAD_BASE_FILE% ."
MOVE %DOWNLOAD_BASE_NAME% %PROGRAM%

PowerShell -Command "(new-object System.Net.WebClient).DownloadFile(\"%DOWNLOAD_EXT_URL%\", \".\%DOWNLOAD_EXT_FILE%\")"
if NOT "%ERRORLEVEL%"=="0" goto fail
PowerShell -Command "$ProgressPreference=\"SilentlyContinue\"; Expand-Archive -Force %DOWNLOAD_EXT_FILE% ."

"%PROGRAM_HOME%%PROGRAM_SCRIPT%" start
if NOT "%ERRORLEVEL%"=="0" goto fail

:end
@rem End local scope for the variables with windows NT shell
if "%ERRORLEVEL%"=="0" goto mainEnd

:fail
echo metricbeat-setup failed
exit /b 1

:mainEnd
if "%OS%"=="Windows_NT" endlocal

