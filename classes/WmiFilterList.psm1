using module .\WmiFilterObject.psm1

class WmiFilterList:System.Collections.Generic.List[WmiFilterObject] {

    WmiFilterList () {}

    WmiFilterList ( [string]$Filter ) {

        # if the filter begins with four groups of numbers the filter is from a
        # GPO and we have to parse off the number of filters first
        if ( $Filter -match '^(?:\d+;){4}\D.+' ) {

            [int]$FilterCount, $RemainingFilter  = $Filter.Split( ';', 2 )

        }
        
        # if the filter begins with only three groups of numbers it is a filter
        # created by New-WmiFilterObject and should be considered to be one
        # filter
        elseif ( $Filter -match '^(?:\d+;){3}\D.+' ) {

            [int]$FilterCount = 1
            $RemainingFilter  = $Filter

        }

        # finally, any other format is invalid
        else {

            throw 'Invalid WMI filter'

        }

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

    }

    [string] ToString () {

        return ( [string]$this.Count + ';' + -join( $this | ForEach-Object { $_.ToString() } ) )

    }

}

