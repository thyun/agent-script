@if "%DEBUG%" == "" @echo off

@rem Set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" setlocal

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.
echo "DIRNAME=%DIRNAME%"

set PROGRAM=metricbeat.exe
set METRICBEAT_HOME=%DIRNAME%
cd %METRICBEAT_HOME%

if "%1"=="start" goto start
if "%1"=="stop" goto stop
echo Usage: %0 {start stop}
goto end



:init
@rem Get command-line arguments, handling Windows variants
echo %SETUP_BASE_NAME%
echo %SETUP_HOME%
echo %PROGRAM_SCRIPT%
if not "%OS%" == "Windows_NT" goto win9xME_args

:win9xME_args
@rem Slurp the command line arguments.
set CMD_LINE_ARGS=
set _SKIP=2

:win9xME_args_slurp
if "x%~1" == "x" goto execute

set CMD_LINE_ARGS=%*

:start
echo Starting %PROGRAM%:
start "%PROGRAM%" /b "%METRICBEAT_HOME%\%PROGRAM%" -e -c metricbeat.yml
goto end

:stop
echo Stopping %PROGRAM%:
taskkill /f /im "%PROGRAM%"
goto end

:end
@rem End local scope for the variables with windows NT shell
if "%ERRORLEVEL%"=="0" goto mainEnd

:fail
exit /b 1

:mainEnd
if "%OS%"=="Windows_NT" endlocal

