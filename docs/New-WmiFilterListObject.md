---
external help file: BW.Utils.GroupPolicy.WMIFilter-help.xml
Module Name: BW.Utils.GroupPolicy.WMIFilter
online version:
schema: 2.0.0
---

# New-WmiFilterListObject

## SYNOPSIS
Create a new WmiFilterObject for use in WMI filters.

## SYNTAX

```
New-WmiFilterListObject [-Filter] <String[]> [-NameSpace <String>] [-Language <String>] [<CommonParameters>]
```

## DESCRIPTION
Create a new WmiFilterObject for use in WMI filters.

## EXAMPLES

### EXAMPLE 1
```
New-WmiFilterObject 'SELECT * FROM Win32_OperatingSystem WHERE ProductType = 2 OR ProductType = 3'
```

This example would create a filter that selects computers where the product type is Domain Controller (2) or Server (3).

## PARAMETERS

### -Filter
The WMI filter.
The pattern 'SELECT \<something\> FROM \<somewhere\> WHERE \<sometest\>' is enforced.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NameSpace
The namespace to use when executing the query.
Defaults to 'root\CIMv2'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Root\CIMv2
Accept pipeline input: False
Accept wildcard characters: False
```

### -Language
The query language to use.
Current versions of Windows only support WQL, which is the default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: WQL
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### WmiFilterList

## NOTES

## RELATED LINKS
