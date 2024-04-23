@echo off
setlocal enabledelayedexpansion
set CONDA_VERBOSITY=0

echo READING CONFIG.INI .............................................................................
:: Read variables from .config file :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
for /f "tokens=1,2 delims==" %%a in (config.ini) do (
if %%a==venv_name set venv_name=%%b
if %%a==python_version set python_version=%%b
)

:: Check variables ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if "!venv_name!"=="" (
    echo venv_name is not set in the config.ini file.
    set /p venv_name=Enter a name for the new virtual environment: 
    if "!venv_name!"=="" (
        echo venv_name cannot be empty, exiting.
        goto end 
    )   
) else ( 
    echo venv_name is set to !venv_name! 
)

echo MAKING VIRTUAL ENVIRONMENT .....................................................................
:: Set Conda path :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if not "%conda_path%"=="" (
    if exist "%conda_path%\Scripts\conda.exe" (
        goto write_config
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

        goto write_config
    )
)

if not %conda_found%==true (
    echo Anaconda not found, please provide the path to conda in config.ini
    goto end
)

:: Overwrite config.ini :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:write_config
( 
echo venv_name=!venv_name!
echo python_version=!python_version!
echo conda_path=!conda_path! 
) > config.ini

:: Make Virtual Environment :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:create_env
call "%conda_path%\Scripts\activate.bat"
call conda create -q -y -n %venv_name% python=%python_version% 
call conda activate %venv_name%

echo INSTALLING PAGKAGES ............................................................................
:: Install required packages ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pip install -q ghhops_server flask 

:: Install additional packages ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if exist "requirements.txt" (
    echo found additional packages in requirements.txt
    pip install -q -r requirements.txt
)

echo SETUP COMPLETED ................................................................................
:end
pause
endlocal