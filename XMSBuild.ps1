param (
    [Parameter(Position = 0)]
    [string] 
    $project, 
    
    [string] 
    $logFileNameBase = 'Build.log', 
    
    [switch] 
    $disableLog = $false,
    
    [switch] 
    $disableShowReport = $false,
    
    [Parameter(ValueFromRemainingArguments=$true)]
    $remainingArgs
)

function CheckRemoveFile([string] $fileName)
{
    if (Test-Path $fileName)
    {
    	Remove-Item $fileName -Force
    }
}

function RunXslTransform ([string] $xslFile, [string] $inputFile, [string] $outputFile) 
{
    $xslt = New-Object -TypeName Xml.Xsl.XslTransform;
    $xslt.Load($xslFile);
    $xslt.Transform($inputFile, $outputFile);    
}

function LogWrapUp ([string] $logFileNameXml, [string] $logFileNameHtml) 
{
    if (!(Test-Path $logFileNameXml)) {return}
    RunXslTransform $xslFile $logFileNameXml $logFileNameHtml;
    if ($disableShowReport -or !(Test-Path $logFileNameHtml)) {return}
    Invoke-Item $logFileNameHtml
}

"Args:"
"Project: $project"
"LogFileNameBase: $logFileNameBase"
"RemainingArgs: $remainingArgs"
$scriptPath = $PSScriptRoot
$normalizedCurrentPath = $pwd.ToString().replace(':', '')
$baseLogPath = [IO.Path]::Combine($Env:TEMP, "XMSBuildLog", $normalizedCurrentPath)
$logFileNameXml = "$baseLogPath\$logFileNameBase.xml"
$logFileNameHtml = "$baseLogPath\$logFileNameBase.html"
$loggerAssembly = "$scriptPath\bin\MSBuild.ExtensionPack.Loggers.dll"
$xslFile = "$scriptPath\xsl\LogToHtml.xslt"
$msBuildScriptFile = "$scriptPath\MSBuild14.cmd"
if (!$disableLog) 
{
    New-Item -Path $baseLogPath -Type directory -Force
	$LoggerSwitch="/logger:XmlFileLogger,`"$loggerAssembly`";logfile=`"$logFileNameXml`";verbosity=Detailed"
    CheckRemoveFile $logFileNameXml;
    CheckRemoveFile $logFileNameHtml;
}
$msBuildCmdLineParams = @($project) + $loggerSwitch + $remainingArgs
"MSBuild command line params: "
$msBuildCmdLineParams
& $msBuildScriptFile $msBuildCmdLineParams
"LastExitCode:$LastExitCode"
if (!$disableLog) { LogWrapUp $logFileNameXml $logFileNameHtml};
exit $LastExitCode;

