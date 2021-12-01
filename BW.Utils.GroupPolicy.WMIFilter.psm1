using namespace System.DirectoryServices.ActiveDirectory
using namespace System.DirectoryServices
using namespace System.Security.Principal
using namespace System.Collections
using module .\classes\WmiFilterObject.psm1
using module .\classes\WmiFilterList.psm1

# .ExternalHelp BW.Utils.GroupPolicy.WMIFilter-help.xml
function ConvertFrom-WmiFilterString {

    [OutputType([WmiFilterList])]
    param(

        [Parameter(
            Mandatory,
            Position = 0
        )]
        [WmiFilterList]
        $InputObject

    )

    return , $InputObject

}

# .ExternalHelp BW.Utils.GroupPolicy.WMIFilter-help.xml
function ConvertTo-WmiFilterString {

    [OutputType([WmiFilterList])]
    param(

        [Parameter(
            Mandatory,
            Position = 0
        )]
        [WmiFilterList]
        $InputObject

    )

    return $InputObject.ToString()

}


# .ExternalHelp BW.Utils.GroupPolicy.WMIFilter-help.xml
function New-WmiFilterObject {

    [OutputType([WmiFilterObject])]
    param (

        [Parameter(Mandatory, Position=1)]
        [ValidatePattern('^SELECT.*FROM.*WHERE.*$')]
        [ValidateNotNullOrEmpty()]
        [string]
        $Filter,

        [ValidateNotNullOrEmpty()]
        [string]
        $NameSpace = 'root\CIMv2',

        [ValidateSet('WQL')]
        [string]
        $Language = 'WQL',

        [WmiFilterList]
        $WmiFilterList

    )

    $WmiFilterObject = [WmiFilterObject]@{
            Filter      = $Filter
            NameSpace   = $NameSpace
            Language    = $Language
    }

    if ( $WmiFilterList -is [WmiFilterList] ) {

        $WmiFilterList.Add( $WmiFilterObject ) > $null

    } else {
        
        return $WmiFilterObject

    }

}


# .ExternalHelp BW.Utils.GroupPolicy.WMIFilter-help.xml
function New-WmiFilterList {

    [CmdletBinding(DefaultParameterSetName='EmptyList')]
    [OutputType([WmiFilterList])]
    param (

        [Parameter(ParameterSetName='FromObject', Mandatory, Position=1)]
        [WmiFilterObject[]]
        $WmiFilterObject,
        
        [Parameter(ParameterSetName='FromString', Mandatory, Position=1)]
        [ValidatePattern('^SELECT.*FROM.*WHERE.*$')]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Filter,

        [Parameter(ParameterSetName='FromString')]
        [ValidateNotNullOrEmpty()]
        [string]
        $NameSpace = 'root\CIMv2',

        [Parameter(ParameterSetName='FromString')]
        [ValidateSet('WQL')]
        [string]
        $Language = 'WQL'

    )

    $WmiFilterList = [WmiFilterList]::new()

    switch ( $PSCmdlet.ParameterSetName ) {

        'FromObject' {

            $WmiFilterList.AddRange( $WmiFilterObject ) > $null

        }

        'FromString' {

            $Filter | ForEach-Object {

                $WmiFilterList.Add([WmiFilterObject]@{
                    Filter      = $Filter
                    NameSpace   = $NameSpace
                    Language    = $Language
                }) > $null
    
            }

        }

    }

    # note that the comma is important so PowerShell doesn't convert to an Array
    return , $WmiFilterList

}


# .ExternalHelp BW.Utils.GroupPolicy.WMIFilter-help.xml
function Get-GPWmiFilter {

    [CmdletBinding()]
    param(
    
        [Parameter(
            ParameterSetName = 'GetAll',
            Mandatory
        )]
        [switch]
        $All,
        
        [Parameter(
            ParameterSetName = 'ByName',
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [Parameter(
            ParameterSetName = 'ByGUID',
            DontShow,
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'DisplayName' )]
        [string]
        $Name,

        [Parameter(
            ParameterSetName = 'ByGUID', 
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'Id' )]
        [guid]
        $Guid,

        [Parameter(
            ParameterSetName = 'ByGPO',
            Mandatory,
            Position = 0,
            ValueFromPipeline
        )]
        [Microsoft.GroupPolicy.Gpo]
        $GPO,

        [Parameter(
            ParameterSetName = 'GetAll',
            ValueFromPipelineByPropertyName
        )]
        [Parameter(
            ParameterSetName = 'ByName',
            ValueFromPipelineByPropertyName
        )]
        [Parameter(
            ParameterSetName = 'ByGUID',
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'DomainName' )]
        [string]
        $Domain = $env:USERDNSDOMAIN,

        [Parameter(
            ParameterSetName = 'GetAll'
        )]
        [Parameter(
            ParameterSetName = 'ByName'
        )]
        [Parameter(
            ParameterSetName = 'ByGUID'
        )]
        [Alias( 'DC' )]
        [string]
        $Server,

        [Parameter(
            DontShow
        )]
        [switch]
        $AsDirectoryEntry

    )

    process {

        # if we are passed a GPO on the pipeline we do a special lookup
        if ( $GPO ) {

            if ( $GPO.WmiFilter ) {

                $GPO.WmiFilter.Path -replace '^MSFT_SomFilter\.' -split '(?<="),' | ForEach-Object {

                    $Key, $Value = $_.Split('=').ForEach({ $_.Trim('"') })
                    
                    if ( $Key -eq 'ID' ) { $Guid = $Value }
                    if ( $Key -eq 'Domain' ) { $Domain = $Value }

                }

                return Get-GPWmiFilter -Guid $Guid -Domain $Domain -AsDirectoryEntry:$AsDirectoryEntry.IsPresent


            } else {

                Write-Warning "No WMI filter attached to GPO"
                return
            }

        }

        if ( -not $Server ) {
        
            $DirectoryContext = [DirectoryContext]::new( 'Domain', $Domain )
            $Server = [Domain]::GetDomain( $DirectoryContext ).FindDomainController().Name
        
        }

        $NamingContext = ([adsi]"LDAP://$Domain/RootDSE").defaultNamingContext
        $SOMContainer = [adsi]"LDAP://$Server/CN=SOM,CN=WMIPolicy,CN=System,$NamingContext"
        $SearchFilter = switch ( $PSCmdlet.ParameterSetName ) {
            'GetAll' { '(objectclass=msWMI-Som)' }
            'ByName' { "(&(objectclass=msWMI-Som)(mswmi-name=$Name))" }
            'ByGUID' { "(&(objectclass=msWMI-Som)(mswmi-id=$($Guid.ToString('B'))))" }
        }
        
        $Searcher = [adsisearcher]::new( $SOMContainer, $SearchFilter )
        $Searcher.PropertiesToLoad.Add( 'adspath' ) > $null
        
        [object[]]$DirectoryEntries = $Searcher.FindAll().ForEach({ [adsi]$_.Path })

        $Searcher.Dispose() > $null
        $SOMContainer.Dispose() > $null

        if ( $DirectoryEntries.Count -eq 0 ) {

            if ( -not $All ) {

                Write-Error 'No WMI filter found!'

            }

            return

        }
        
        if ( $AsDirectoryEntry ) {

            return $DirectoryEntries

        }
        
        $DirectoryEntries | Select-Object `
            @{ N='DisplayName'  ; E={ $_.'mswmi-name' }},
            @{ N='DomainName'   ; E={ $Domain }},
            @{ N='Server'       ; E={ $Server }},
            @{ N='Owner'        ; E={ $_.PsBase.ObjectSecurity.Owner }},
            @{ N='Id'           ; E={ [guid][string]$_.'mswmi-id' }},
            @{ N='Description'  ; E={ $_.'mswmi-parm1' }},
            @{ N='Author'       ; E={ $_.'mswmi-author' }},
            @{ N='Filters'      ; E={ , [WmiFilterList][string]$_.'mswmi-parm2' }}

    }

}


# .ExternalHelp BW.Utils.GroupPolicy.WMIFilter-help.xml
function New-GPWmiFilter {

    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
    param(

        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'DisplayName' )]
        [string]
        $Name,

        [Alias( 'Id' )]
        [guid]
        $Guid = ( [guid]::NewGuid() ),

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Description,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Author = ([WindowsIdentity]::GetCurrent().Name),

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [WmiFilterList]
        $Filters,

        [Alias( 'DomainName' )]
        [string]
        $Domain = $env:USERDNSDOMAIN,

        [Alias( 'DC' )]
        [string]
        $Server
        
    )

    process {

        if ( -not $Server ) {
        
            $DirectoryContext = [DirectoryContext]::new( 'Domain', $Domain )
            $Server = [Domain]::GetDomain( $DirectoryContext ).FindDomainController().Name
        
        }

        $TestParams = @{
            Domain = $Domain
            Server = $Server
        }

        # Check for existing filter with same name
        if ( $ExistingFilter = Get-GPWmiFilter -Name $Name @TestParams -ErrorAction SilentlyContinue ) {
            
            Write-Error ( 'WMI filter ''{0}'' already exists in domain {1}!' -f $ExistingFilter.DisplayName, $Domain )
            return

        }
        
        # check for existing filter with same quid
        if ( $ExistingFilter = Get-GPWmiFilter -Guid $Guid @TestParams -ErrorAction SilentlyContinue ) {

            Write-Error ( 'WMI filter with GUID ''{0}'' already exists in domain {1}!' -f $ExistingFilter.Id.ToString('B'), $Domain )
            return

        }

        $NamingContext = ([adsi]"LDAP://$Domain/RootDSE").defaultNamingContext
        $SOMContainer = [adsi]"LDAP://$Server/CN=SOM,CN=WMIPolicy,CN=System,$NamingContext"

        # create a time stamp
        $Created = [datetime]::UtcNow.ToString('yyyyMMddHHmmss.ffffff-000')

        try {

            if ( $PSCmdlet.ShouldProcess( $Name, 'create' ) ) {
            
                $WmiFilter = $SOMContainer.Create( 'msWMI-Som', "CN=$($Guid.ToString('B'))" )

                $WmiFilter.Put( 'msWMI-Name',               $Name                                       )
                $WmiFilter.Put( 'msWMI-Parm1',              $Description                                )
                $WmiFilter.Put( 'msWMI-Parm2',              $Filters.ToString()                         )
                $WmiFilter.Put( 'msWMI-Author',             $Author                                     )
                $WmiFilter.Put( 'msWMI-ID',                 $Guid.ToString('B')                         )
                $WmiFilter.Put( 'instanceType',             4                                           )
                $WmiFilter.Put( 'showInAdvancedViewOnly',   'TRUE'                                      )
                $WmiFilter.Put( 'distinguishedname',        "CN=$($Guid.ToString('B')),$SOMContainer"   )
                $WmiFilter.Put( 'msWMI-ChangeDate',         $Created                                    )
                $WmiFilter.Put( 'msWMI-CreationDate',       $Created                                    )

                $WmiFilter.SetInfo()

            }

            Get-GPWmiFilter -Guid $Guid @TestParams

        } catch {

            Write-Error ( 'Failed to create WMI filter ''{0}'' in domain {1}. Please verify that you have rights to create WMI filters. You may also need to first enable ''Allow System Only Change'' for the domain. You can use the Set-ADSystemOnlyChange cmdlet to make this change.' -f $Name, $Domain )
        
        } finally {

            $SOMContainer.Dispose()
        
        }

    }

}


# .ExternalHelp BW.Utils.GroupPolicy.WMIFilter-help.xml
function Set-GPWmiFilter {

    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
    param(

        [Parameter(
            ParameterSetName = 'ByName',
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [Parameter(
            ParameterSetName = 'ByGUID',
            DontShow,
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'DisplayName' )]
        [string]
        $Name,

        [Parameter(
            ParameterSetName = 'ByGUID', 
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'Id' )]
        [guid]
        $Guid,

        [string]
        $NewName,

        [string]
        $Description,

        [WmiFilterList]
        $Filters,

        [Alias( 'DomainName' )]
        [string]
        $Domain = $env:USERDNSDOMAIN,

        [Alias( 'DC' )]
        [string]
        $Server
        
    )

    process {

        if ( -not $Server ) {
        
            $DirectoryContext = [DirectoryContext]::new( 'Domain', $Domain )
            $Server = [Domain]::GetDomain( $DirectoryContext ).FindDomainController().Name
        
        }

        $GetParams = @{
            Domain = $Domain
            Server = $Server
        }
        if ( $Guid ) { $GetParams.Guid = $Guid }
        elseif ( $Name ) { $GetParams.Name = $Name }

        # verify that the WMI filter exists
        $ExistingFilter = Get-GPWmiFilter @GetParams -AsDirectoryEntry -ErrorAction Stop

        $IsUpdated = $false

        if ( $NewName ) {

            $ExistingFilter.'msWMI-Name' = $NewName
            $IsUpdated = $true

        }

        if ( $PSBoundParameters.ContainsKey( 'Description' ) -and [string]::IsNullOrEmpty( $Description ) ) {

            $ExistingFilter.PutEx( 1, 'msWMI-Parm1', 0 )
            $IsUpdated = $true

        } elseif ( $PSBoundParameters.ContainsKey( 'Description' ) ) {

            $ExistingFilter.'msWMI-Parm1' = $Description
            $IsUpdated = $true

        }

        if ( $Filters ) {

            $ExistingFilter.'msWMI-Parm2' = $Filters.ToString()
            $IsUpdated = $true

        }

        if ( $IsUpdated ) {

            if ( $PSCmdlet.ShouldProcess( $ExistingFilter.'msWMI-Name', 'update' ) ) {

                try {

                    $ExistingFilter.'msWMI-ChangeDate' = [datetime]::UtcNow.ToString('yyyyMMddHHmmss.ffffff-000')
                    $ExistingFilter.CommitChanges()

                } catch {

                    Write-Error ( 'Failed to update WMI filter ''{0}'' in domain {1}. Please verify that you have rights to create WMI filters. You may also need to first enable ''Allow System Only Change'' for the domain. You can use the Set-ADSystemOnlyChange cmdlet to make this change.' -f $ExistingFilter.'msWMI-Name'[0], $Domain )

                }

            }
        
        } else {

            Write-Warning ( 'No changes made to WMI filter ''{0}'' in domain {1}.' -f $ExistingFilter.'msWMI-Name'[0], $Domain )

        }

    }

}


# .ExternalHelp BW.Utils.GroupPolicy.WMIFilter-help.xml
function Remove-GPWmiFilter {

    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
    param(

        [Parameter(
            ParameterSetName = 'ByName',
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [Parameter(
            ParameterSetName = 'ByGUID',
            DontShow,
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'DisplayName' )]
        [string]
        $Name,

        [Parameter(
            ParameterSetName = 'ByGUID', 
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'Id' )]
        [guid]
        $Guid,

        [string]
        $NewName,

        [string]
        $Description,

        [WmiFilterList]
        $Filters,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'DomainName' )]
        [string]
        $Domain = $env:USERDNSDOMAIN,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'DC' )]
        [string]
        $Server
        
    )

    process {

        if ( -not $Server ) {
        
            $DirectoryContext = [DirectoryContext]::new( 'Domain', $Domain )
            $Server = [Domain]::GetDomain( $DirectoryContext ).FindDomainController().Name
        
        }

        $GetParams = @{
            Domain = $Domain
            Server = $Server
        }
        if ( $Guid ) { $GetParams.Guid = $Guid }
        elseif ( $Name ) { $GetParams.Name = $Name }

        Write-Verbose ( ConvertTo-Json $GetParams )

        # verify that the WMI filter exists
        $ExistingFilter = Get-GPWmiFilter @GetParams -ErrorAction Stop

        Write-Debug 'Stop Here'

        $LookupBy = ( 'Name', 'GUID' )[ $PSBoundParameters.ContainsKey( 'Guid' ) ]
        $LookupValue = ( $Name, $Guid.ToString('B') )[ $PSBoundParameters.ContainsKey( 'Guid' ) ]

        # verify this WMI filter isn't in use
        $LinkedGPOs = Get-GPWmiFilterLinkedGPO @GetParams

        if ( $LinkedGPOs.Count -gt 0 ) {

            Write-Verbose 'Linked Group Policies:'



            $LinkedGPOs | ForEach-Object {

                Write-Verbose ( '{0} {1}' -f $_.DisplayName, $_.Id.ToString('B') )

            }

            Write-Error ( 'WMI filter with {0} ''{1}'' in domain {2} could not be removed! It is linked to {3} Group Policies.' -f $LookupBy, $LookupValue, $Domain, $LinkedGPOs.Count )
            return

        }

        if ( $PSCmdlet.ShouldProcess( $ExistingFilter.DisplayName, 'remove' ) ) {

            try {

                $NamingContext = ([adsi]"LDAP://$Domain/RootDSE").defaultNamingContext
                $SOMContainer = [adsi]"LDAP://$Server/CN=SOM,CN=WMIPolicy,CN=System,$NamingContext"
            
                $WmiFilterObject = $SOMContainer.Children.Find( "CN=$($ExistingFilter.Id.ToString('B'))" )

                $SOMContainer.Children.Remove( $WmiFilterObject )

            } catch {

                Write-Error ( 'Failed to remove WMI filter ''{0}'' in domain {1}. Please verify that you have rights to remove WMI filters. You may also need to first enable ''Allow System Only Change'' for the domain. You can use the Set-ADSystemOnlyChange cmdlet to make this change.' -f $ExistingFilter.DisplayName, $Domain )

            }

            $SOMContainer.Dispose()

        }

    }
    
}


# .ExternalHelp BW.Utils.GroupPolicy.WMIFilter-help.xml
function Get-GPWmiFilterLinkedGPO {

    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
    param(

        [Parameter(
            ParameterSetName = 'ByName',
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [Parameter(
            ParameterSetName = 'ByGUID',
            DontShow,
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'DisplayName' )]
        [string]
        $Name,

        [Parameter(
            ParameterSetName = 'ByGUID', 
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'Id' )]
        [guid]
        $Guid,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'DomainName' )]
        [string]
        $Domain = $env:USERDNSDOMAIN,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'DC' )]
        [string]
        $Server
        
    )

    process {

        if ( -not $Server ) {
        
            $DirectoryContext = [DirectoryContext]::new( 'Domain', $Domain )
            $Server = [Domain]::GetDomain( $DirectoryContext ).FindDomainController().Name
        
        }

        $GetParams = @{
            Domain = $Domain
            Server = $Server
        }
        if ( $Guid ) { $GetParams.Guid = $Guid }
        elseif ( $Name ) { $GetParams.Name = $Name }

        # verify that the WMI filter exists
        $ExistingFilter = Get-GPWmiFilter @GetParams

        if ( -not $ExistingFilter ) {

            $LookupBy = ( 'Name', 'GUID' )[ $PSBoundParameters.ContainsKey( 'Guid' ) ]
            $LookupValue = ( $Name, $Guid.ToString('B') )[ $PSBoundParameters.ContainsKey( 'Guid' ) ]
            
            Write-Error ( 'WMI filter with {0} ''{1}'' could not be found in domain {2}!' -f $LookupBy, $LookupValue, $Domain )
            return

        }

        # get all linked GPOs
        $NamingContext = ([adsi]"LDAP://$Domain/RootDSE").defaultNamingContext

        $SearchFilter = "(&(objectclass=groupPolicyContainer)(gPCWQLFilter=*$($ExistingFilter.Id.ToString('B'))*))"
        $SearchRoot = [adsi]"LDAP://$Server/CN=Policies,CN=System,$NamingContext"
        
        $Searcher = [adsisearcher]::new( $SearchRoot, $SearchFilter )
        $Searcher.PropertiesToLoad.Add( 'name' ) > $null
        
        $Searcher.FindAll().ForEach({ $_.Properties.name }).ForEach({ Get-GPO -Guid $_ })

        $Searcher.Dispose()
        $SearchRoot.Dispose()

    }

}


# .ExternalHelp BW.Utils.GroupPolicy.WMIFilter-help.xml
function Set-GPOWmiFilterLink {

    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
    param(

        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline
        )]
        [Microsoft.GroupPolicy.Gpo]
        $GPO,

        [Parameter(
            ParameterSetName = 'ByName',
            Mandatory,
            Position = 1
        )]
        [Alias( 'DisplayName' )]
        [string]
        $Name,

        [Parameter(
            ParameterSetName = 'ByGUID',
            Mandatory,
            Position = 1
        )]
        [guid]
        $Guid,

        [Parameter(
            ParameterSetName = 'Clear',
            Mandatory,
            Position = 1
        )]
        [switch]
        $Clear,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'DomainName' )]
        [string]
        $Domain,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'DC' )]
        [string]
        $Server,

        [switch]
        $PassThru
        
    )

    process {

        if ( -not $Server ) {
        
            $DirectoryContext = [DirectoryContext]::new( 'Domain', $Domain )
            $Server = [Domain]::GetDomain( $DirectoryContext ).FindDomainController().Name
        
        }

        # get the GPO as a directory entry
        $GPODirectoryEntry = Get-GPODirectoryEntry $GPO -Domain $Domain -Server $Server

        if ( $Clear ) {

            $GPODirectoryEntry.PutEx( 1, 'gPCWQLFilter', 0 )

        } else {

            # get the GPWmiFilter object
            $GetParam = @{}
            if ( $Name ) { $GetParam.Name = $Name }
            if ( $Guid ) { $GetParam.Guid = $Guid }
            $WmiFilterObject = Get-GPWmiFilter @GetParam -Domain $Domain -Server $Server -ErrorAction Stop

            # assign the value
            $GPODirectoryEntry.gPCWQLFilter = "[$Domain;$($WmiFilterObject.Id.ToString('B'));0]"

        }

        if ( $PSCmdlet.ShouldProcess( $GPO.DisplayName, 'set WMI filter' ) ) {

            try {

                $GPODirectoryEntry.CommitChanges()

            } catch {

                Write-Error ( 'Failed to update GPO ''{0}'' in domain {1}. Please verify that you have rights to edit this GPO.' -f $GPO.DisplayName, $GPO.DomainName )
                return

            }

        }

        if ( $PassThru ) {

            $GPO | Get-GPO

        }

    }

}


# .ExternalHelp BW.Utils.GroupPolicy.WMIFilter-help.xml
function Get-GPODirectoryEntry {

    param(

        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline
        )]
        [Microsoft.GroupPolicy.Gpo]
        $GPO,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'DomainName' )]
        [string]
        $Domain,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'DC' )]
        [string]
        $Server

    )

    process {

        $DirectoryContext = [DirectoryContext]::new( 'Domain', $Domain )
        
        if ( -not $Server ) {

            $Server = [Domain]::GetDomain( $DirectoryContext ).FindDomainController().Name

        }
        
        $NamingContext = ([adsi]"LDAP://$Domain/RootDSE").defaultNamingContext
        [adsi]"LDAP://$Server/CN=$($GPO.Id.ToString('B')),CN=Policies,CN=System,$NamingContext"

    }

}


# .ExternalHelp BW.Utils.GroupPolicy.WMIFilter-help.xml
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


# .ExternalHelp BW.Utils.GroupPolicy.WMIFilter-help.xml
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

function Test-GPWmiFilterParameterBinding {

    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
    param(

        [Parameter(
            ParameterSetName = 'ByName',
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [Parameter(
            ParameterSetName = 'ByGUID',
            DontShow,
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'DisplayName' )]
        [string]
        $Name,

        [Parameter(
            ParameterSetName = 'ByGUID', 
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'Id' )]
        [guid]
        $Guid,

        [string]
        $NewName,

        [string]
        $Description,

        [WmiFilterList]
        $Filters,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'DomainName' )]
        [string]
        $Domain = $env:USERDNSDOMAIN,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [Alias( 'DC' )]
        [string]
        $Server
        
    )

    process {

        Write-Verbose "Being Called" -Verbose
        $input | %{ Write-Verbose "INPUT: $_" -Verbose }
        $args | %{ Write-Verbose "ARGS: $_" -Verbose }
        $PSBoundParameters.Keys | %{ Write-Verbose "BOUND: $_" -Verbose }

    }

}