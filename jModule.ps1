function jDate {
    $jCurrentDate = Get-Date -Format "yyyy-m-d HH:mm"
    $jCurrentDate
}

function jLogIt($data) {
    Write-Host ">> $jCurrentDate > $data" | Out-File $env:temp\jLog.log
}

function jError($errorMsg) {
    Write-Host "[ERROR] $errorMsg"
    jLogIt "[ERROR] $errorMsg"
}
function jInfo($infoMsg) {
    Write-Host "[INFO] $infoMsg"
    jLogIt "[INFO] $infoMsg"
}

function jCreateReport {


}

function jIsNodeAlive($computer) {
    $isNodeAlive = Test-Connection -ComputerName $computer -Count 1 -ErrorAction SilentlyContinue

}

function jDump2File($data, $filename) {
    if(!(Test-Path .\$filename)) {
        Write-Output "$data" | Out-File .\$filename
    }
    if(Test-Path .\$filename) {
        Write-Output "$data" | Out-File .\$filename -Append
    }
}


function jExecuteAndLog($_cmd) {
    try {
        jLogIt "Executing: $_cmd"
        $CmdOutput = Invoke-Expression $_cmd | Out-String
        jLogIt "Output: $CmdOutput"
    }
    catch {
        jLogIt "Exception while executing $_cmd"
        jLogIt $_.Exception.Message 
    }
}

function jExecuteAndLogRemote($computername, $_rcmd) {
    try{
        jLogIt "Executing: $_rcmd on $computername"
        $CmdOutput = Invoke-Command -ComputerName $computername -ScriptBlock {$_rcmd} | Out-String
        jlogIt "Output: $CmdOutput"
    }
    catch {
        jLogit "Exception while executing $_rcmd"
        jlogIt $_.Exception.Message
    }
}

## JUST FOR REFERENCE, Below code won't work.
function jReport {
    $report = New-Object psobject
    $report | Add-Member -MemberType NoteProperty -Name Nodename -Value $computer
    $report | Add-Member -MemberType NoteProperty -Name RecoveryKey -Value $recoveryKey
    $report | export-csv .\BitlockerKeys.csv -NoTypeInformation -Append
}

