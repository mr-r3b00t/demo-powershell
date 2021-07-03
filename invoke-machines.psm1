
#
# This function wraps the session management involved in calling Invoke-Command.
# I read something somewhere about making sure you don't 'leak' PSSessions for security and performance reasons.
# Or maybe I don't like typing ;)
#
# e.g.
# Import-Module Invoke-Machines.psm1
# Invoke-Fleet -ComputerName $Computers -ScriptBlock { $Env:COMPUTERNAME } -Credential (Get-Credential)
#

function Invoke-Machines {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position=0)][String[]] $ComputerName,
        [Parameter(Mandatory, Position=1)][ScriptBlock] $ScriptBlock,
        [Parameter(Mandatory, Position=1)][String] $ScriptFile,
        [Parameter(Mandatory, Position=2)][pscredential] $Credential
    )
    
    begin {
        $Sessions = New-PSSession -ComputerName $ComputerName -Credential $Credential
    }
    
    process {
        try {
            if ($null -ne $ScriptBlock) {
                Invoke-Command -Session $Session -ScriptBlock $ScriptBlock
            }
            if ($null -ne $ScriptFile) {
                Invoke-Command -Session $Session -FilePath $ScriptFile
            }
        }
        catch {
            Write-Error -Exception $_
        }
    }
    
    end {
        if ($null -ne $Sessions) {
            $Sessions | Remove-PSSession
        }
    }
}

Export-ModuleMember -Function Invoke-Machines
