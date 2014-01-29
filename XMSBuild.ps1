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

function ForceFilePath([string] $filePath)
{
    $dirPath = Split-Path -parent $filePath;
    if ($dirPath) 
    {
        New-Item -Path $dirPath -Type directory -Force
    }
}

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

"Args:"
"Project: $project"
"LogFileNameBase: $logFileNameBase"
"RemainingArgs: $remainingArgs"
$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
$logFileNameXml = "$logFileNameBase.xml"
$logFileNameHtml = "$logFileNameBase.html"
$loggerAssembly = "$scriptPath\bin\MSBuild.ExtensionPack.Loggers.dll"
$xslFile = "$scriptPath\xsl\LogToHtml.xslt"
$msBuildScriptFile = "$scriptPath\MSBuild40.cmd"
if (!$disableLog) 
{
    ForceFilePath $logFileNameBase;
	$LoggerSwitch="/logger:XmlFileLogger,`"$loggerAssembly`";logfile=`"$logFileNameXml`";verbosity=Detailed"
    CheckRemoveFile $logFileNameXml;
    CheckRemoveFile $logFileNameHtml;
}
$msBuildCmdLineParams = @($project) + $loggerSwitch + $remainingArgs
"MSBuild command line params: "
$msBuildCmdLineParams
& $msBuildScriptFile $msBuildCmdLineParams
if ($disableLog) {return};
if (!(Test-Path $logFileNameXml)) {return}
RunXslTransform $xslFile $logFileNameXml $logFileNameHtml;
if ($disableShowReport -or !(Test-Path $logFileNameHtml)) {return}
Invoke-Item $logFileNameHtml
