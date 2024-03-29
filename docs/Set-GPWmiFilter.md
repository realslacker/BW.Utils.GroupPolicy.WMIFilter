---
external help file: BW.Utils.GroupPolicy.WMIFilter-help.xml
Module Name: BW.Utils.GroupPolicy.WMIFilter
online version:
schema: 2.0.0
---

# Set-GPWmiFilter

## SYNOPSIS
Updates an exising WMI filter in Active Directory

## SYNTAX

### ByName (Default)
```
Set-GPWmiFilter [-Name] <String> [-NewName <String>] [-Description <String>] [-Filters <WmiFilterObject[]>]
 [-Domain <String>] [-Server <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByGUID
```
Set-GPWmiFilter [-Guid] <Guid> [-NewName <String>] [-Description <String>] [-Filters <WmiFilterObject[]>]
 [-Domain <String>] [-Server <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates an exising WMI filter in Active Directory.

## EXAMPLES

### EXAMPLE 1
```
Set-GPWmiFilter -Name 'Servers Only' -Description 'Selects computers where the product type is Domain Controller (2) or Server (3)'
```

This example would update the description of the WMI filter with the name 'Servers Only'.

## PARAMETERS

### -Name

```yaml
Type: String
Parameter Sets: ByName
Aliases: DisplayName

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -NewName

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
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

### -Filters

```yaml
Type: WmiFilterObject[]
Parameter Sets: (All)
Aliases:

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
Position: 2
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

## OUTPUTS

## NOTES

## RELATED LINKS
