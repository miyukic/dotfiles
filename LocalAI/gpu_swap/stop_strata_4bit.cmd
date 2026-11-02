@echo off
color 0C
title Strata 4bit - STOP
set STRATA=D:\local-llm\Strata\terminal\current\bin\strata.cmd
echo Stopping Strata 4bit...
call "%STRATA%" runtime stop --profile orca-iq4_xs-256k --wait 300
call "%STRATA%" runtime status --profile orca-iq4_xs-256k
pause
