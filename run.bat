@echo off
setlocal enabledelayedexpansion
set CONDA_VERBOSITY=0

echo READING CONFIG.INI .............................................................................
:: Read variables from .config file :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
for /f "tokens=1,2 delims==" %%a in (setup\config.ini) do (
if %%a==venv_name set venv_name=%%b
if %%a==python_version set python_version=%%b
if %%a==conda_path set conda_path=%%b
)

:: Check variables ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if "%venv_name%"=="" (
    echo venv_name is not set. Please, modify the config.ini file. Script will now exit.
    pause
    goto end
) else (
    echo venv_name is set to %venv_name%
)

echo ACTIVATING VIRTUAL ENVIRONMENT .................................................................
:: Set Conda path :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if not "%conda_path%"=="" (
    if exist "%conda_path%\Scripts\conda.exe" (
    goto create_env
    ) else (
        goto look_for_conda
    )
) else (
    goto look_for_conda
)

:: Find Conda path ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:look_for_conda
set "paths=C:\Users\%USERNAME%\Anaconda3;C:\Anaconda3;C:\ProgramData\Anaconda3"
set "conda_found=false"

for %%i in (%paths%) do (
    if exist "%%i\Scripts\conda.exe" (
        set conda_path=%%i
        set conda_found=true
        goto create_env
    )
)

if not %conda_found%==true (
    echo Anaconda not found, please provide conda_path in the config.ini file.
    goto end
)

:: Activate Virtual Environment ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:create_env
call "%conda_path%\Scripts\activate.bat"
call conda activate %venv_name%

echo RUN APP ........................................................................................
python app.py

:end
pause
endlocal
