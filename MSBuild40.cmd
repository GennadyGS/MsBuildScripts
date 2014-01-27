@echo off
if /I "%Processor_Architecture%"=="x86" (
	set NETFramework=Framework
) else (
	set NETFramework=Framework64
)
set DOTNETDIR=%windir%\Microsoft.NET\%NETFramework%\v4.0.30319
echo DOTNETDIR=%DOTNETDIR%
%DOTNETDIR%\MSBuild.exe /toolsversion:4.0 %*
