class WmiFilterList:System.Collections.Generic.List[WmiFilterObject] {

    WmiFilterList () {}

    WmiFilterList ( [string]$Filter ) {

        if ( $Filter -notmatch '^(?:\d+;){4}.+' ) {

            throw 'Invalid WMI filter'

        }

        # first substring in a filter is the filter count
        [int]$FilterCount, $RemainingFilter  = $Filter.Split( ';', 2 )

        while ( $FilterCount -gt 0 ) {

            # each filter is a list of lengths and string sections
            # we use the substring length instead of just a split on ';' to ensure
            # semi-colons in the filter are properly captured

            [int]$LanguageLength, [int]$NameSpaceLength, [int]$FilterLength, $RemainingFilter = $RemainingFilter.Split( ';', 4 )

            $WmiFilterObject = [WmiFilterObject]@{
                Language    = $RemainingFilter.Substring( 0, $LanguageLength )
                NameSpace   = $RemainingFilter.Substring( $LanguageLength + 1, $NameSpaceLength )
                Filter      = $RemainingFilter.Substring( $LanguageLength + 1 + $NameSpaceLength + 1, $FilterLength )
            }
            
            $this.Add( $WmiFilterObject ) > $null

            $RemainingFilter = $RemainingFilter.Substring( $LanguageLength + 1 + $NameSpaceLength + 1 + $FilterLength + 1 )

            $FilterCount --

        }

    }
    
    WmiFilterList ( [WmiFilterObject[]] $WmiFilterObject ) {

        $this.AddRange( $WmiFilterObject ) > $null
        
        #$WmiFilterObject | ForEach-Object { $this.Add( $_ ) }

    }

    [string] ToString () {

        return ( [string]$this.Count + ';' + -join( $this | ForEach-Object { $_.ToString() } ) )

    }

}

