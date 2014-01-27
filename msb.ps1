$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$proj = Get-Item .\* -include ('*.sln', '*.csproj')
if ($proj) {
    $scriptArgs = @($proj[0].Name) + $args;
    $scriptFile = $scriptPath + '\XMSBuild.cmd'
    Start-Process $scriptFile -ArgumentList $scriptArgs
}
