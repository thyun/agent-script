@if "%DEBUG%" == "" @echo off

@rem Set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" setlocal

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.
set SETUP_BASE_NAME=%~n0
set SETUP_HOME=%DIRNAME%
set PROGRAM=metricbeat
set PROGRAM_HOME=%SETUP_HOME%%PROGRAM%\
set PROGRAM_SCRIPT=%PROGRAM%.bat
set DOWNLOAD_FILE=metricbeat.zip

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
echo %SETUP_BASE_NAME%
echo %SETUP_HOME%
echo %PROGRAM_HOME%
echo %PROGRAM_SCRIPT%
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
rem curl http://localhost/downloads/%DOWNLOAD_FILE% -o %DOWNLOAD_FILE%
PowerShell -Command "$ProgressPreference=\"SilentlyContinue\"; Expand-Archive %DOWNLOAD_FILE% ."
rem PowerShell -Command "Expand-Archive %DOWNLOAD_FILE% ."
"%PROGRAM_HOME%%PROGRAM_SCRIPT%" start

:end
@rem End local scope for the variables with windows NT shell
if "%ERRORLEVEL%"=="0" goto mainEnd

:fail
exit /b 1

:mainEnd
if "%OS%"=="Windows_NT" endlocal

