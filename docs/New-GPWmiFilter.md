---
external help file: BW.Utils.GroupPolicy.WMIFilter-help.xml
Module Name: BW.Utils.GroupPolicy.WMIFilter
online version:
schema: 2.0.0
---

# New-GPWmiFilter

## SYNOPSIS
Create a new WMI filter in Active Directory

## SYNTAX

```
New-GPWmiFilter [-Name] <String> [-Guid <Guid>] [-Description <String>] [-Author <String>]
 -Filters <WmiFilterObject[]> [-Domain <String>] [-Server <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Create a new WMI filter object in Active Directory by directly creating the object in AD.

## EXAMPLES

### EXAMPLE 1
```
New-GPWmiFilter -Name 'Servers Only' -Description 'Selects computers where the product type is Domain Controller (2) or Server (3)' -Filter 'SELECT * FROM Win32_OperatingSystem WHERE ProductType = 2 OR ProductType = 3'
```

This example would create a filter that selects computers where the product type is Domain Controller (2) or Server (3).

## PARAMETERS

### -Name

```yaml
Type: String
Parameter Sets: (All)
Aliases: DisplayName

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
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
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Author

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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
Default value: None
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
List of WmiFilterObjects, use New-WmiFilterObject to create

```yaml
Type: WmiFilterObject[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Guid

```yaml
Type: Guid
Parameter Sets: (All)
Aliases: Id

Required: False
Position: Named
Default value: ( [guid]::NewGuid() )
Accept pipeline input: False
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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

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
