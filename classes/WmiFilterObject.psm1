class WmiFilterObject {

    [ValidateSet('WQL')]
    [string]
    $Language = 'WQL'
    
    [ValidateNotNullOrEmpty()]
    [string]
    $NameSpace = 'root\CIMv2'
    
    [ValidatePattern('^SELECT.*FROM.*WHERE.*$')]
    [ValidateNotNullOrEmpty()]
    [string]
    $Filter

    WmiFilterObject ( [string]$Filter ) {

        $this.Filter    = $Filter
    
    }

    WmiFilterObject ( [string]$NameSpace, [string]$Filter ) {

        $this.NameSpace = $NameSpace
        $this.Filter    = $Filter
    
    }

    WmiFilterObject ( [string]$Language, [string]$NameSpace, [string]$Filter ) {

        $this.Language  = $Language
        $this.NameSpace = $NameSpace
        $this.Filter    = $Filter
    
    }

    WmiFilterObject ( [hashtable]$WmiFilterHashtable ) {

        foreach ( $Key in $WmiFilterHashtable.Keys ) {
            
            $this.$Key = $WmiFilterHashtable.$Key
            
        }

    }

    WmiFilterObject ( [psobject]$WmiFilterObject ) {

        $WmiFilterObject |
            Get-Member -MemberType NoteProperty |
            Select-Object -ExpandProperty Name |
            ForEach-Object {

                $this.$_ = $WmiFilterObject.$_
                
            }

    }

    [string] ToString () {

        return -join ( $this.Language.Length, $this.NameSpace.Length, $this.Filter.Length, $this.Language, $this.NameSpace, $this.Filter | ForEach-Object { "$_;" } )

    }

}

