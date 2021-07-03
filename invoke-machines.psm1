
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
