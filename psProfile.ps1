function prompt            
{    
    $date = Get-Date 
    $dateColored = Write-host "[$date] " -ForegroundColor DarkGray -NoNewline
    $username = Write-Host "$env:username" -ForegroundColor Green -NoNewline
    $atSign = Write-Host "@" -ForegroundColor Gray -NoNewline
    $hostname = $env:COMPUTERNAME
    $hostnameColor = Write-Host "$hostname" -ForegroundColor Red
    "$dateColored" + "$username$atsign$hostnameColor" + " $(get-location)> "             
}

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
function jOpenDir{
    $currentDir = Get-Location
    Start-Process explorer.exe $currentDir
}

function jRemote($computer) {
    $isNodeAlive = Test-Connection $computer -Count 1 -ErrorAction SilentlyContinue

    if($isNodeAlive) {
        #Cleanup sessions first!
        Get-Pssession | Disconnect-Pssession | Out-Null
        Get-Pssession | Remove-Pssession
        ##
        $jRemoteSession = New-Pssession -ComputerName $computer -name jRemote
        $isjRemoteSessionOpen = (Get-PSSession -Name jRemote).State

        if($isjRemoteSessionOpen -eq "Opened") {
            try{
                Invoke-Command $jRemoteSession -ScriptBlock {
                    function prompt            
                    {    
                        $date = Get-Date 
                        $dateColored = Write-host "[$date] " -ForegroundColor DarkGray -NoNewline
                        $username = Write-Host "$env:username" -ForegroundColor Green -NoNewline
                        $atSign = Write-Host "@" -ForegroundColor Gray -NoNewline
                        $hostname = $env:COMPUTERNAME
                        $hostnameColor = Write-Host "$hostname" -ForegroundColor Red
                        "$dateColored" + "$username$atsign$hostnameColor" + " $(get-location)> "             
                    }
                    Set-Location C:\
                    ## Load other remote parts of module here!
                }
            }
            catch{
                Write-Output "[ERROR]  Error changing prompt!"
                Write-Output "[INFO]  Not a dealbreaker though.. But more ugly. Moving on."
            }
            Enter-Pssession $jRemoteSession
        }
    }
    if(!$isNodeAlive) {
        Write-Output "[ERROR]  Node was not online"
    }
}