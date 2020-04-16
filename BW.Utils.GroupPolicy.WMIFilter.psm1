using namespace System.DirectoryServices.ActiveDirectory
using namespace System.DirectoryServices
using namespace System.Security.Principal
using namespace System.Collections


# NOTE: WmiFilterObject.ps1 needs to load before WmiFilterList.ps1 as the object class needs to already be defined when the list class is loaded.
#. "$PSScriptRoot\classes\WmiFilterObject.ps1"
#. "$PSScriptRoot\classes\WmiFilterList.ps1"


<#
.SYNOPSIS
 Create a new WmiFilterObject for use in WMI filters.

.DESCRIPTION
 Create a new WmiFilterObject for use in WMI filters.

.PARAMETER Filter
 The WMI filter. The pattern 'SELECT <something> FROM <somewhere> WHERE <sometest>' is enforced.

.PARAMETER NameSpace
 The namespace to use when executing the query. Defaults to 'root\CIMv2'.

.PARAMETER Language
 The query language to use. Current versions of Windows only support WQL, which is the default.

.EXAMPLE
 New-WmiFilterObject 'SELECT * FROM Win32_OperatingSystem WHERE ProductType = 2 OR ProductType = 3'

 This example would create a filter that selects computers where the product type is Domain Controller (2) or Server (3).
#>
function New-WmiFilterListObject {

    [OutputType([WmiFilterList])]
    param (

        [Parameter(Mandatory, Position=1)]
        [ValidatePattern('^SELECT.*FROM.*WHERE.*$')]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Filter,

        [ValidateNotNullOrEmpty()]
        [string]
        $NameSpace = 'root\CIMv2',

        [ValidateSet('WQL')]
        [string]
        $Language = 'WQL'

    )

    $WmiFilterList = [WmiFilterList]::new()

    $Filter | ForEach-Object {

        $WmiFilterList.Add([WmiFilterObject]@{
            Filter      = $Filter
            NameSpace   = $NameSpace
            Language    = $Language
        }) > $null

    }

    # note that the comma is important so PowerShell doesn't convert to an Array
    return , $WmiFilterList

}


<#
.SYNOPSIS
 Get WMI filters from Active Directory.

.DESCRIPTION
 Get WMI filters from Active Directory and parse them into objects.

.PARAMETER Name
 The Name of the WMI filter to return.

.PARAMETER GUID
 The GUID of the WMI filter to return.

.PARAMETER DomainName
 The domain to search for WMI filters.

.EXAMPLE
 Get-GPWmiFilter

 Will return a list of all WMI filters in the current user's domain.

.EXAMPLE
 Get-GPWmiFilter -Name '*Server*' -DomainName 'contoso.com' -Credential (Get-Credential CONTOSO\Administrator)

 Will return a list of all WMI filters with 'Server' in the name from the domain
 contoso.com using the CONTOSO Administrator account.

.EXAMPLE
 Get-GPWmiFilter -GUID '6a3a8a8d-2072-4596-8b5b-b24bcf0486ce'

 Will return the WMI filter with the GUID '6a3a8a8d-2072-4596-8b5b-b24bcf0486ce'
 from the current user's domain.
#>
function Get-GPWmiFilter {

    [CmdletBinding(DefaultParameterSetName='Name')]
    param(

        [Parameter(Position=1, ParameterSetName='Name')]
        [SupportsWildcards()]
        [string]
        $Name = '*',

        [Parameter(Position=1, ParameterSetName='GUID')]
        [guid]
        $GUID,

        [Alias('DnsDomain')]
        [string]
        $DomainName = $env:USERDNSDOMAIN,

        [pscredential]
        $Credential,

        [Parameter(ValueFromRemainingArguments, DontShow)]
        $UnboundArguments
        
    )

    $PSBoundParameters.Remove( 'UnboundArguments' ) > $null

    $DomainParams = _GetDomainParams @PSBoundParameters

    $NamingContext = _GetNamingContext @DomainParams -ErrorAction Stop

    $Searcher = _GetSearcher -SearchBase "CN=SOM,CN=WMIPolicy,CN=System,$NamingContext" -SearchFilter '(objectclass=msWMI-Som)' @DomainParams -ErrorAction Stop
    
    $Searcher.FindAll().ForEach({ $_.Properties }) |
        Select-Object `
            @{ N='DistinguishedName'    ; E={ $_.distinguishedname }},
            @{ N='Name'                 ; E={ $_.'mswmi-name' }},
            @{ N='GUID'                 ; E={ [guid][string]$_.'mswmi-id' }},
            @{ N='Description'          ; E={ $_.'mswmi-parm1' }},
            @{ N='Author'               ; E={ $_.'mswmi-author' }},
            @{ N='Filters'              ; E={ , [WmiFilterList][string]$_.'mswmi-parm2' }} |
        Where-Object {
            ( $PSCmdlet.ParameterSetName -eq 'Name' -and $_.Name -like $Name ) -or
            ( $PSCmdlet.ParameterSetName -eq 'GUID' -and $_.GUID -eq $GUID )
        }

    $Searcher.Dispose()

}


<#
.SYNOPSIS
 Create a new WMI filter in Active Directory.

.DESCRIPTION
 Create a new WMI filter object in Active Directory.

.PARAMETER Name
 The Name of the WMI filter to create. Must be unique.

.PARAMETER Description
 An optional description of what the WMI filter does.

.PARAMETER GUID
 Allows you to optionally specify the GUID of the WMI filter. This is useful
 for restoring WMI filters from backup. Defaults to a random GUID.

.PARAMETER Filter
 Either string filter(s) or WMI filter object(s) returned by New-WmiFilterObject.

.PARAMETER DomainName
 The destination domain.

.EXAMPLE
 New-GPWmiFilter -Name 'Servers Only' -Description 'Selects computers where the product type is Domain Controller (2) or Server (3)' -Filter 'SELECT * FROM Win32_OperatingSystem WHERE ProductType = 2 OR ProductType = 3'

 This example would create a filter that selects computers where the product type is Domain Controller (2) or Server (3).
#>
function New-GPWmiFilter {

    param(

        [Parameter(Mandatory, Position=1)]
        [string]
        $Name,

        [string]
        $Description,

        [guid]
        $GUID = ( [guid]::NewGuid() ),

        [Parameter(Mandatory)]
        [WmiFilterObject[]]
        $Filter,

        [Alias('DnsDomain')]
        [string]
        $DomainName = $env:USERDNSDOMAIN,

        [pscredential]
        $Credential
        
    )

    $DomainParams = _GetDomainParams @PSBoundParameters

    if ( $Credential ) {

        $Author = $Credential.UserName
    
    } else {

        $Author = [WindowsIdentity]::GetCurrent().Name

    }

    # verify that the WMI filter doesn't already exist
    if ( $PSCmdlet.ParameterSetName -eq 'Name' -and ( Get-GPWmiFilter -Name $Name @DomainParams ) ) {
        
        Write-Error ( 'WMI filter ''{0}'' already exists in domain {1}!' -f $Name, $DomainName )

        return

    } elseif ( $PSCmdlet.ParameterSetName -eq 'GUID' -and ( Get-GPWmiFilter -GUID $GUID @DomainParams ) ) {

        Write-Error ( 'WMI filter with GUID ''{0}'' already exists in domain {1}!' -f $GUID.ToString('B'), $DomainName )
        
        return

    }

    $NamingContext = _GetNamingContext @DomainParams -ErrorAction Stop

    # get the container where the WMI filters are stored
    $SOMContainer = [adsi]"LDAP://CN=SOM,CN=WMIPolicy,CN=System,$NamingContext"

    if ( $Credential ) {

        $SOMContainer.PSBase.Username = $Credential.UserName
        $SOMContainer.PSBase.Password = $Credential.GetNetworkCredential().Password

    }

    # create a time stamp
    $Created = [datetime]::UtcNow.ToString('yyyyMMddHHmmss.ffffff-000')

    try {
        
        $WmiFilter = $SOMContainer.Create( 'msWMI-Som', "CN=$($GUID.ToString('B'))" )

        $WmiFilter.Put( 'msWMI-Name',               $Name                                           )
        $WmiFilter.Put( 'msWMI-Parm1',              $Description                                    )
        $WmiFilter.Put( 'msWMI-Parm2',              [WmiFilterList]::new($Filter).ToString()        )
        $WmiFilter.Put( 'msWMI-Author',             $Author                                         )
        $WmiFilter.Put( 'msWMI-ID',                 $GUID.ToString('B')                             )
        $WmiFilter.Put( 'instanceType',             4                                               )
        $WmiFilter.Put( 'showInAdvancedViewOnly',   'TRUE'                                          )
        $WmiFilter.Put( 'distinguishedname',        "CN=$($GUID.ToString('B')),$SOMContainer"       )
        $WmiFilter.Put( 'msWMI-ChangeDate',         $Created                                        )
        $WmiFilter.Put( 'msWMI-CreationDate',       $Created                                        )

        $WmiFilter.SetInfo()

    } catch {

        Write-Error ( 'Failed to create WMI filter ''{0}'' in domain {1}. You may need to first enable ''Allow System Only Change'' for the domain. You can use the Set-ADSystemOnlyChange cmdlet to make this change.' -f $Name, $DomainName )
    
    }

}


<#
.SYNOPSIS
 Updates an exising WMI filter in Active Directory.

.DESCRIPTION
 Updates an exising WMI filter in Active Directory.

.PARAMETER Name
 The Name of the WMI filter to update.

.PARAMETER GUID
 The GUID of the WMI filter to update.

.PARAMETER NewName
 The new name if renaming the WMI filter.

.PARAMETER Description
 A description of what the WMI filter does.

.PARAMETER Filter
 Either string filter(s) or WMI filter object(s) returned by New-WmiFilterObject.

.PARAMETER DomainName
 The destination domain.

.EXAMPLE
 Set-GPWmiFilter -Name 'Servers Only' -Description 'Selects computers where the product type is Domain Controller (2) or Server (3)'

 This example would update the description of the WMI filter with the name 'Servers Only'.
 #>
function Set-GPWmiFilter {

    [CmdletBinding(DefaultParameterSetName='Name', SupportsShouldProcess, ConfirmImpact='Medium')]
    param(

        [Parameter(Mandatory, Position=1, ParameterSetName='Name')]
        [string]
        $Name,

        [Parameter(Mandatory, Position=1, ParameterSetName='GUID')]
        [guid]
        $GUID,

        [string]
        $NewName,

        [string]
        $Description,

        [WmiFilterObject[]]
        $Filter,

        [Alias('DnsDomain')]
        [string]
        $DomainName = $env:USERDNSDOMAIN,

        [pscredential]
        $Credential
        
    )

    $DomainParams = _GetDomainParams @PSBoundParameters

    # verify that the WMI filter exists
    if ( $PSCmdlet.ParameterSetName -eq 'Name' -and -not( $WmiFilterObject = Get-GPWmiFilter -Name $Name @DomainParams ) ) {
        
        Write-Error ( 'WMI filter ''{0}'' could not be found in domain {1}!' -f $Name, $DomainName )

        return

    } elseif ( $PSCmdlet.ParameterSetName -eq 'GUID' -and -not( $WmiFilterObject = Get-GPWmiFilter -GUID $GUID @DomainParams ) ) {

        Write-Error ( 'WMI filter with GUID ''{0}'' could not be found in domain {1}!' -f $GUID.ToString('B'), $DomainName )
        
        return

    }

    $WmiFilter = [adsi]"LDAP://$($WmiFilterObject.DistinguishedName)"

    if ( $Credential ) {

        $WmiFilter.PSBase.Username = $Credential.UserName
        $WmiFilter.PSBase.Password = $Credential.GetNetworkCredential().Password

    }

    $IsUpdated = $false

    if ( $NewName ) {

        $WmiFilter.'msWMI-Name' = $NewName
        $IsUpdated = $true

    }

    if ( $Description ) {

        $WmiFilter.'msWMI-Parm1' = $Description
        $IsUpdated = $true

    }

    if ( $Filter ) {

        $WmiFilter.'msWMI-Parm2' = [WmiFilterList]::new( $Filter ).ToString()
        $IsUpdated = $true

    }

    if ( $IsUpdated ) {

        if ( $PSCmdlet.ShouldProcess( $WmiFilterObject.Name, 'update' ) ) {

            try {

                $WmiFilter.'msWMI-ChangeDate' = [datetime]::UtcNow.ToString('yyyyMMddHHmmss.ffffff-000')

                $WmiFilter.CommitChanges()

            } catch {

                Write-Error ( 'Failed to update WMI filter ''{0}'' in domain {1}. You may need to first enable ''Allow System Only Change'' for the domain. You can use the Set-ADSystemOnlyChange cmdlet to make this change.' -f $Name, $DomainName )

            }

        }
    
    } else {

        Write-Warning ( 'No changes made to WMI filter ''{0}'' in domain {1}.' -f $WmiFilterObject.Name, $DomainName )

    }

}


function Remove-GPWmiFilter {

    [CmdletBinding(DefaultParameterSetName='Name', SupportsShouldProcess, ConfirmImpact='High')]
    param(

        [Parameter(Mandatory, Position=1, ParameterSetName='Name')]
        [string]
        $Name,

        [Parameter(Mandatory, Position=1, ParameterSetName='GUID')]
        [guid]
        $GUID,

        [Alias('DnsDomain')]
        [string]
        $DomainName = $env:USERDNSDOMAIN,

        [pscredential]
        $Credential
        
    )

    $DomainParams = _GetDomainParams @PSBoundParameters

    # verify that the WMI filter exists
    if ( $PSCmdlet.ParameterSetName -eq 'Name' -and -not( $WmiFilterObject = Get-GPWmiFilter -Name $Name @DomainParams ) ) {
        
        Write-Error ( 'WMI filter ''{0}'' could not be found in domain {1}!' -f $Name, $DomainName )

        return

    } elseif ( $PSCmdlet.ParameterSetName -eq 'GUID' -and -not( $WmiFilterObject = Get-GPWmiFilter -GUID $GUID @DomainParams ) ) {

        Write-Error ( 'WMI filter with GUID ''{0}'' could not be found in domain {1}!' -f $GUID.ToString('B'), $DomainName )
        
        return

    }

    $NamingContext = _GetNamingContext @DomainParams -ErrorAction Stop

    # verify this WMI filter isn't in use
    $Searcher = _GetSearcher -SearchBase "CN=Policies,CN=System,$NamingContext" -SearchFilter "(&(objectclass=groupPolicyContainer)(gPCWQLFilter=*$($WmiFilterObject.GUID.ToString('B'))*))" @DomainParams -ErrorAction Stop

    $LinkedGPOs = $Searcher.FindAll().ForEach({ $_.Properties }) |
        Select-Object `
            @{ N='Name'     ; E={ $_['displayName'] }},
            @{ N='GUID'     ; E={ [guid][string]$_['name'] }}

    $Searcher.Dispose();

    if ( $LinkedGPOs.Count -gt 0 ) {

        Write-Verbose 'Linked Group Policies:'
        Write-Verbose ''
        Write-Verbose 'GUID                                   | NAME'
        Write-Verbose '---------------------------------------|----------------------------------------'

        $LinkedGPOs |
            ForEach-Object {

                Write-Verbose ( '{1} | {0}' -f $_.Name, $_.GUID.ToString('B') )

            }

        if ( $PSCmdlet.ParameterSetName -eq 'Name' ) {

            Write-Error ( 'WMI filter ''{0}'' in domain {1} could not be removed! It is linked to {2} Group Policies.' -f $Name, $DomainName, $LinkedGPOs.Count )

        } else {

            Write-Error ( 'WMI filter with GUID ''{0}'' in domain {1} could not be removed! It is linked to {2} Group Policies.' -f $GUID.ToString('B'), $DomainName, $LinkedGPOs.Count )
        
        }

        return

    }

    if ( $PSCmdlet.ShouldProcess( $WmiFilterObject.Name, 'remove' ) ) {

        $SOMContainer = [adsi]"LDAP://CN=SOM,CN=WMIPolicy,CN=System,$NamingContext"

        if ( $Credential ) {

            $SOMContainer.PSBase.Username = $Credential.UserName
            $SOMContainer.PSBase.Password = $Credential.GetNetworkCredential().Password

        }

        $WmiObject = $SOMContainer.Children.Find( "CN=$($WmiFilterObject.GUID.ToString('B'))" )

        $SOMContainer.Children.Remove( $WmiObject )

        $SOMContainer.Dispose()

    }

}


<#
.SYNOPSIS
 Set registry values on domain controller to allow writing to system only
 attributes.
.NOTES
 This function has been taken from the GPWmiFilter.psm1 module written by Bin
 Yi from Microsoft with minimal changes.
#>
function Set-ADSystemOnlyChange {

    param(

        [Parameter(Mandatory, ValueFromPipeline, Position=1, ParameterSetName='Enable_Remote')]
        [Parameter(Mandatory, ValueFromPipeline, Position=1, ParameterSetName='Disable_Remote')]
        [string[]]
        $ComputerName,

        [Parameter(Mandatory, ParameterSetName='Enable_Local')]
        [Parameter(Mandatory, ParameterSetName='Enable_Remote')]
        [switch]
        $Enable,

        [Parameter(Mandatory, ParameterSetName='Disable_Local')]
        [Parameter(Mandatory, ParameterSetName='Disable_Remote')]
        [switch]
        $Disable,

        [Parameter(ParameterSetName='Enable_Remote')]
        [Parameter(ParameterSetName='Disable_Remote')]
        [pscredential]
        $Credential

    )

    begin {

        $CommandSplat = @{}

        if ( $Credential ) { $CommandSplat.Credential = $Credential }

        [ArrayList]$Computers = @()

    }

    process {

        $ComputerName.ForEach({ $Computers.Add( $_ ) > $null })

    }

    end {

        if ( $Computers.Count -gt 0 ) {

            [string[]]$CommandSplat.ComputerName = $Computers

        }

        if ( $Enable ) {

            Write-Warning "Enabling the setting 'Allow System Only Change' should be a temporary measure. Don't foreget to revert this setting once changes are applied."

        }

        Invoke-Command @CommandSplat -ScriptBlock {

            # check for NTDS service
            if ( -not( Get-Service NTDS -ErrorAction SilentlyContinue ) ) {

                throw 'Must be run on a domain controller!'

            }

            # check for and create if missing the Parameters registry key
            $ParametersKey = Get-Item -Path 'HKLM:\System\CurrentControlSet\Services\NTDS\Parameters' -ErrorAction SilentlyContinue

            if ( -not $ParametersKey ) {
        
                New-Item -Path 'HKLM:\System\CurrentControlSet\Services\NTDS\Parameters' -ItemType RegistryKey > $null
        
            }

            # check if 'Allow System Only Change' value exists
            $SystemOnlyChangeValue = Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\NTDS\Parameters' -Name 'Allow System Only Change' -ErrorAction SilentlyContinue

            if ( -not $SystemOnlyChangeValue ) {

                New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\NTDS\Parameters' -Name 'Allow System Only Change' -Value ([int]$Using:Enable.IsPresent) -PropertyType DWORD > $null

            } else {

                Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\NTDS\Parameters' -Name 'Allow System Only Change' -Value ([int]$Using:Enable.IsPresent) > $null
            
            }

        }

    }

}


<#
.SYNOPSIS
 Check if 'Allow System Only Change' is enabled.
 attributes.
.NOTES
 This function has been taken from the GPWmiFilter.psm1 module written by Bin
 Yi from Microsoft with minimal changes.
#>
function Test-ADSystemOnlyChangeEnabled {

    [CmdletBinding(DefaultParameterSetName='Local')]
    param(

        [Parameter(Mandatory, ValueFromPipeline, Position=1, ParameterSetName='Remote')]
        [string[]]
        $ComputerName,

        [Parameter(ParameterSetName='Remote')]
        [pscredential]
        $Credential

    )

    begin {

        $CommandSplat = @{}

        if ( $Credential ) { $CommandSplat.Credential = $Credential }

        [ArrayList]$Computers = @()

    }

    process {

        $ComputerName.ForEach({ $Computers.Add( $_ ) > $null })

    }

    end {

        if ( $Computers.Count -gt 0 ) {

            [string[]]$CommandSplat.ComputerName = $Computers

        }

        Invoke-Command @CommandSplat -ScriptBlock {

            # check for NTDS service
            if ( -not( Get-Service NTDS -ErrorAction SilentlyContinue ) ) {

                throw 'Must be run on a domain controller!'

            }

            # check for and create if missing the Parameters registry key
            $ParametersKey = Get-Item -Path 'HKLM:\System\CurrentControlSet\Services\NTDS\Parameters' -ErrorAction SilentlyContinue

            if ( -not $ParametersKey ) {
        
                return $false
        
            }

            # check if 'Allow System Only Change' value exists
            $SystemOnlyChangeValue = Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\NTDS\Parameters' -Name 'Allow System Only Change' -ErrorAction SilentlyContinue |
                Select-Object -ExpandProperty 'Allow System Only Change'

            return [bool]$SystemOnlyChangeValue

        }

    }

}


<#
.SYNOPSIS
 Utility function to return the selected Naming Context.
#>
function _GetNamingContext {

    [CmdletBinding()]
    param (

        [ValidateSet( 'Default', 'Configuration', 'Schema' )]
        [ValidateNotNullOrEmpty()]
        [string]
        $NamingContext = 'Default',

        [ValidateNotNullOrEmpty()]
        [Alias('DnsDomain')]
        [string]
        $DomainName = $env:USERDNSDOMAIN,

        [pscredential]
        $Credential,

        [Parameter(ValueFromRemainingArguments, DontShow)]
        $UnboundArguments

    )

    $PSBoundParameters.Remove( 'UnboundArguments' ) > $null

    $RootDSE = [ADSI]"LDAP://$DomainName/RootDSE"

    if ( $Credential ) {

        $RootDSE.PSBase.Username = $Credential.UserName
        $RootDSE.PSBase.Password = $Credential.GetNetworkCredential().Password

    }

    try {

        return $RootDSE.Get( $NamingContext + 'NamingContext' )

    } catch {

        Write-Error ( 'Could not retrieve {0} for domain ''{1}'', user may not have rights to query the domain.' -f ( $NamingContext + 'NamingContext' ), $DomainName )
        return

    }

}


<#
.SYNOPSIS
 Utility function to return a Directory Searcher object.
#>
function _GetSearcher {

    [CmdletBinding()]
    [OutputType([System.DirectoryServices.DirectorySearcher])]
    param (

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SearchBase,

        [ValidateNotNullOrEmpty()]
        [string]
        $SearchFilter = '(objectClass=*)',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Alias('DnsDomain')]
        [string]
        $DomainName = $env:USERDNSDOMAIN,

        [pscredential]
        $Credential,

        [Parameter(ValueFromRemainingArguments, DontShow)]
        $UnboundArguments

    )

    $PSBoundParameters.Remove( 'UnboundArguments' ) > $null

    if ( $Credential ) {

        $ADSearchRoot = [DirectoryEntry]::new( "LDAP://$DomainName/$SearchBase", $Credential.UserName, $Credential.GetNetworkCredential().Password )

    } else {

        $ADSearchRoot = [DirectoryEntry]::new( "LDAP://$DomainName/$SearchBase" )

    }

    [DirectorySearcher]::new( $ADSearchRoot, $SearchFilter )
    
}


<#
.SYNOPSIS
 Utility function to generate DomainParams.
#>
function _GetDomainParams {

    param(

        [string]
        $DomainName,

        [pscredential]
        $Credential,

        [Parameter(ValueFromRemainingArguments, DontShow)]
        $UnboundArguments
        
    )

    $PSBoundParameters.Remove( 'UnboundArguments' ) > $null
    return $PSBoundParameters

}

