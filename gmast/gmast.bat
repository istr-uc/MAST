@echo off
set PATH=.\bin;%PATH%
start /b /wait gmast_analysis.exe
IF %ERRORLEVEL% NEQ 0 goto was_cancelled_or_did_not_worked
rem start /b /wait %comspec% /c mast_command
@type mast_command > mast_command.bat
@call .\mast_command>report.txt

IF %ERRORLEVEL% NEQ 0 goto dont_view_results

@type mast_results_command > mast_results_command.bat
@call .\mast_results_command
@del mast_command.bat
@del mast_results_command.bat
echo Mast analysis completed
goto the_end

:dont_view_results
@del mast_command.bat
goto the_end

:was_cancelled_or_did_not_worked
echo cancelled

:the_end
pause
exit
