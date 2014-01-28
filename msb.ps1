function charIsSwitch([char] $c) {
    $switchChars = '-/';
    return $switchChars.Contains($c);
}

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$proj = Get-Item .\* -include ('*.sln', '*.csproj')
if ($proj) {
    $msbArgs = $args | foreach {if (charIsSwitch($_.ToString()[0])) {$_} else {"/t:$_"}};
    $scriptArgs = @($proj[0].Name) + $msbArgs;
    $scriptFile = $scriptPath + '\XMSBuild.cmd'
    Start-Process $scriptFile -ArgumentList $scriptArgs
}
