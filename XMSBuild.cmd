@echo off
set DefaultLogfileName=Build.log
set ToolsPath=%~dp0\tools
set MsxslToolPath=%ToolsPath%\msxsl.exe
if not defined LogFileName set LogFileName=%DefaultLogfileName%
set Logger=%ToolsPath%\MSBuild.ExtensionPack.Loggers.dll
set LogXslFile=%~dp0\xsl\LogToHtml.xslt
if not "%DisableLog%" == "true" (
	call :ForceLogPath %LogFileName%
	set LoggerSwitch=/logger:XmlFileLogger,"%Logger%";logfile="%LogFileName%.xml";verbosity=Detailed
	if exist "%LogFileName%.xml" del /Q "%LogFileName%.xml"
	if exist "%LogFileName%.html" del /Q "%LogFileName%.html"
) else (
	set LoggerSwitch=
)
set MSBuildCmdLineParams=%LoggerSwitch% %*
echo MSBuild command line params: %MSBuildCmdLineParams%
call %~dp0\MSBuild40.cmd %MSBuildCmdLineParams%
set BuildErrorLevel=%ErrorLevel%
if exist "%LogFileName%.xml" if not "%DisableLog%" == "true" %MsxslToolPath% "%LogFileName%.xml" %LogXslFile% -o "%LogFileName%.html"
if exist "%LogFileName%.html" if not "%DisableLog%" == "true" if not "%DisableShowReport%" == "true" start %LogFileName%.html
call :SetErrorLevel %BuildErrorLevel%
goto :EOF

:ForceLogPath
if not exist %~dp1 md %~dp1
goto :EOF

:SetErrorLevel
if "%~1" == "" goto :EOF
exit /b %~1