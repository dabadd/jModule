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
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER computer
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    
    foreach($computer in $computer) {
        Write-Output "[INFO]  Trying ping.."
        $isNodeAlive = Test-Connection -ComputerName $computer -Count 1 -ErrorAction SilentlyContinue
        if($isNodeAlive) {
            Write-Output "[INFO]  $computer responded to ping."
            Write-Output "[INFO]  $computer is online."
        }
        if(!($isNodeAlive)) {
            Write-Output "[WARN]  $computer did not respond to ping."
            Write-Output "[INFO]  Trying SMB port"
            $testSMB = Test-NetConnection -ComputerName $computer -CommonTCPPort SMB -ErrorAction SilentlyContinue

            if(!($testSMB.TcpTestSucceeded)) {
                Write-Output "[WARN]  $computer was unable to be reached on SMB port"
            }
            if($testSMB.TcpTestSucceeded) {
                Write-Output "[INFO]  $computer was reached on SMB port!"
                Write-Output "[INFO]  $computer is online."
            }
        }
    }
}

function jDump2File($data, $filename) {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER data
    Parameter description
    
    .PARAMETER filename
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    
    #@todo: Should use params to verify that input exists!
    if(!(Test-Path .\$filename)) {
        Write-Output "$data" | Out-File .\$filename
    }
    if(Test-Path .\$filename) {
        Write-Output "$data" | Out-File .\$filename -Append
    }
}


function jExecuteAndLog($_cmd) {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER _cmd
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    
    #@todo: Should use params to verify command!
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
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER computername
    Parameter description
    
    .PARAMETER _rcmd
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    
    #@todo: Should use params to verify computername and command!
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

function jExecuteRemote($computername, $_rcmd) {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER computername
    Parameter description
    
    .PARAMETER _rcmd
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    
    #@todo: Should have params to verify computername and command!
    try{
        Invoke-Command -ComputerName $computername -ScriptBlock {$_rcmd}
    }
    catch {
        Write-Output "[ERROR]  Exception while executing $_rcmd"
        Write-Output $_.Exception.Message
    }
}

## JUST FOR REFERENCE, Below code won't work.
function jReport {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    
    $report = New-Object psobject
    $report | Add-Member -MemberType NoteProperty -Name Nodename -Value $computer
    $report | Add-Member -MemberType NoteProperty -Name RecoveryKey -Value $recoveryKey
    $report | export-csv .\BitlockerKeys.csv -NoTypeInformation -Append
}

## Profile part, specific for module to be loaded from start

function jTitle($title) {
    if($title){
        $host.ui.RawUI.WindowTitle = "$title"
    }
    if(!$title){
        $x = Read-host "Please provide a title"
        if($x){
            $host.ui.RawUI.WindowTitle = "$x"
        }
        if(!$x){
            Write-Output "I cannot change what I do not know. No title provided."
            break
        }
    }
}
function prompt            
{    
#    $jPS = Write-host "jPS " -ForegroundColor Yellow -NoNewline
    $date = Get-Date 
    $dateColored = Write-host "[$date]" -ForegroundColor Red -NoNewline
    $username = Write-Host "$env:username" -ForegroundColor Green -NoNewline
    $atSign = Write-Host "@" -ForegroundColor Gray -NoNewline
    $hostname = hostname
    $hostnameColor = Write-Host "$hostname " -ForegroundColor Red -NoNewline
    "$dateColored "+ "$username$atsign$hostnameColor " + "$(get-location)> "             
}
