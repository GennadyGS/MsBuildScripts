function CharIsSwitch([char] $c) 
{
    $switchChars = '-/';
    return $switchChars.Contains($c);
}

$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
$proj = Get-Item .\* -include ('*.sln', '*.csproj')
if ($proj) 
{
    $msbArgs = $args |
        foreach {if (charIsSwitch $_.ToString()[0]) {$_} else {"/t:$_"}};
    $scriptArgs = @($proj[0].Name) + $msbArgs;
    & $scriptPath\XMSbuild.cmd $scriptArgs
}
