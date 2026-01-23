@echo off
set PATH=.\bin;%PATH%
start /b /wait gmasteditor.exe %1
IF %ERRORLEVEL% NEQ 0 goto did_not_work
goto the_end

:did_not_work
pause

:the_end
exit
