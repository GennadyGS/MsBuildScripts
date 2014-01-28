@echo off
if /I "%Processor_Architecture%"=="x86" (
	set NETFrameworkDir=Framework
) else (
	set NETFrameworkDir=Framework64
)
%windir%\Microsoft.NET\%NETFrameworkDir%\v4.0.30319\MSBuild.exe /toolsversion:4.0 %*
