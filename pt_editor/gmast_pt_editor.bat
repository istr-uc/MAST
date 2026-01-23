@echo off
set PATH=.\bin;%PATH%
start /b /wait gmast_pt_editor.exe %*
IF %ERRORLEVEL% NEQ 0 goto did_not_work
goto the_end

:did_not_work
pause

:the_end
exit

