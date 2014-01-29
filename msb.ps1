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

function TransformArgs([string[]] $inputArgs) 
{
    return ,($inputArgs |
        foreach {
            if ((charIsSwitch $_[0]) -or (IsProjectParam $_)) {$_} else {"/t:$_"}
        });
}

$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
$msbArgs = TransformArgs $args
& $scriptPath\XMSbuild.cmd $msbArgs
