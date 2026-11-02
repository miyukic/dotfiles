@echo off
color 0E
title Strata 4bit - starting in background (closing this window does NOT stop it)
set STRATA=D:\local-llm\Strata\terminal\current\bin\strata.cmd
netstat -ano | findstr LISTENING | findstr ":8090 " >nul
if %errorlevel%==0 (
  echo Strata is already running. Opening the browser.
  start "" http://127.0.0.1:8090/
  timeout /t 5
  exit /b
)
echo Starting Strata 4bit in the background. This takes a few minutes...
echo To stop it, use the "Strata 4bit STOP" shortcut on the desktop.
call "%STRATA%" runtime start --profile orca-iq4_xs-256k --wait 600
call "%STRATA%" runtime status --profile orca-iq4_xs-256k
start "" http://127.0.0.1:8090/
echo.
echo You can close this window. Strata keeps running.
pause
