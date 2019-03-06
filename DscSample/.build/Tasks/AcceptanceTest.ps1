task AcceptanceTest {

    if (-not ([System.IO.Path]::IsPathRooted($BuildOutput))) {
        $BuildOutput = Join-Path -Path $ProjectPath -ChildPath $BuildOutput
    }

    if ($env:BHBuildSystem -eq 'AppVeyor') {
        #No acceptance tests applicaable, do support for pull server deployment yet.
    }
    elseif ($env:BUILD_REPOSITORY_PROVIDER -eq 'TfsGit' -and $env:RELEASE_ENVIRONMENTNAME) {
        if (-not (Test-Path -Path $testsPath)) {
            Write-Build Yellow "Path for tests '$testsPath' does not exist"
            return
        }
        $testResultsPath = Join-Path -Path $BuildOutput -ChildPath AcceptanceTestResults.xml
        $testResults = Invoke-Pester -Script $testsPath -PassThru -OutputFile $testResultsPath -OutputFormat NUnitXml -Tag Acceptance
    }
    else {
        #No test applicable, artifacts are made available in the BuildOutput folder
    }

    assert ($testResults.FailedCount -eq 0)

}