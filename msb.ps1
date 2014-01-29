$defaultProjectFileMask = "*.msbuildproj";

function CharIsSwitch([char] $c) 
{
    $switchChars = '-/';
    return $switchChars.Contains($c);
}

function IsProjectParam([string] $param)
{
    $fileExt = [System.IO.Path]::GetExtension($param);
    return (($fileExt) -eq '.sln') -or ($fileExt.EndsWith('proj') -or ($fileExt -eq '.xml'));
}

function IsProjectParamSpecified([string[]] $inputArgs) 
{
    $result = $false;
    $inputArgs |        
        foreach  {
            if (IsProjectParam $_) {$result = $true}
        };
    return $result;
}

function TransformArgs([string[]] $inputArgs) 
{
    return ,($inputArgs |
        foreach {
            if ((charIsSwitch $_[0]) -or (IsProjectParam $_)) {$_} else {"/t:$_"}
        });
}

$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
$msbArgs = TransformArgs $args
if (!(IsProjectParamSpecified $args) -and (Test-Path $defaultProjectFileMask))
{
    $defaultProjectFile = (Get-Item $defaultProjectFileMask)[0].Name;
    $msbArgs = @($defaultProjectFile) + $msbArgs;
}
& $scriptPath\XMSbuild.cmd $msbArgs
exit $LastExitCode;