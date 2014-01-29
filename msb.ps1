function CharIsSwitch([char] $c) 
{
    $switchChars = '-/';
    return $switchChars.Contains($c);
}

function IsProjectParam([string] $param)
{
    $fileExt = [System.IO.Path]::GetExtension($param);
    $res = (($fileExt) -eq '.sln') -or ($fileExt.EndsWith('proj'))
    Write-Host "IsProjectParam($param) returns $res"
    return $res;
}

$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
$msbArgs = $args |
    foreach {
        if ((charIsSwitch $_[0]) -or (IsProjectParam $_)) {$_} else {"/t:$_"}
    };
& $scriptPath\XMSbuild.cmd $msbArgs
