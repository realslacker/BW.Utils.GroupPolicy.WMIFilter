---
external help file: BW.Utils.GroupPolicy.WMIFilter-help.xml
Module Name: BW.Utils.GroupPolicy.WMIFilter
online version:
schema: 2.0.0
---

# Test-ADSystemOnlyChangeEnabled

## SYNOPSIS
Check if 'Allow System Only Change' is enabled.
attributes.

## SYNTAX

### Local (Default)
```
Test-ADSystemOnlyChangeEnabled [<CommonParameters>]
```

### Remote
```
Test-ADSystemOnlyChangeEnabled [-ComputerName] <String[]> [-Credential <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
Check if 'Allow System Only Change' is enabled.
attributes.

## EXAMPLES

### Example 1
```powershell
PS C:\> Test-ADSystemOnlyChange -ComputerName dc.contoso.com -Credential (Get-Credential)
```

Returns TRUE if System Only Change is enabled, or FALSE if it is disabled.

## PARAMETERS

### -ComputerName
The remote computer to connect to.

```yaml
Type: String[]
Parameter Sets: Remote
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Credential
Credential for authenticating to a remote computer.

```yaml
Type: PSCredential
Parameter Sets: Remote
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This function has been taken from the GPWmiFilter.psm1 module written by Bin
Yi from Microsoft with minimal changes.

## RELATED LINKS
