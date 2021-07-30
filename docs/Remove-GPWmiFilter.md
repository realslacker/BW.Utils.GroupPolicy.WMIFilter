---
external help file: BW.Utils.GroupPolicy.WMIFilter-help.xml
Module Name: BW.Utils.GroupPolicy.WMIFilter
online version:
schema: 2.0.0
---

# Remove-GPWmiFilter

## SYNOPSIS
Remove WMI filter from Active Directory

## SYNTAX

### ByName (Default)
```
Remove-GPWmiFilter [-Name] <String> [-Domain <String>] [-Server <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ByGUID
```
Remove-GPWmiFilter [-Guid] <Guid> [-Domain <String>] [-Server <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Remove WMI filter from Active Directory after validating that they are not in use by any Group Policy objects.

## EXAMPLES

### Example 1
```
PS C:\> Remove-GPWmiFilter -GUID '6a3a8a8d-2072-4596-8b5b-b24bcf0486ce'
```

Will remove the WMI filter with the GUID '6a3a8a8d-2072-4596-8b5b-b24bcf0486ce' from the current user's domain.

## PARAMETERS

### -Name

```yaml
Type: String
Parameter Sets: ByName
Aliases: DisplayName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domain

```yaml
Type: String
Parameter Sets: (All)
Aliases: DomainName

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Guid

```yaml
Type: Guid
Parameter Sets: ByGUID
Aliases: Id

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Server

```yaml
Type: String
Parameter Sets: (All)
Aliases: DC

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

## NOTES

## RELATED LINKS
