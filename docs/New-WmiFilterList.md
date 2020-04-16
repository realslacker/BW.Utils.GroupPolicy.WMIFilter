---
external help file: BW.Utils.GroupPolicy.WMIFilter-help.xml
Module Name: BW.Utils.GroupPolicy.WMIFilter
online version:
schema: 2.0.0
---

# New-WmiFilterList

## SYNOPSIS
Create a new WmiFilterList for use in WMI filters.

## SYNTAX

### EmptyList (Default)
```
New-WmiFilterList [<CommonParameters>]
```

### FromObject
```
New-WmiFilterList [-WmiFilterObject] <WmiFilterObject[]> [<CommonParameters>]
```

### FromString
```
New-WmiFilterList [-Filter] <String[]> [-NameSpace <String>] [-Language <String>] [<CommonParameters>]
```

## DESCRIPTION
Create a new WmiFilterList for use in WMI filters.

## EXAMPLES

### EXAMPLE 1
```
New-WmiFilterList 'SELECT * FROM Win32_OperatingSystem WHERE ProductType = 2 OR ProductType = 3'
```

This example would create a filter that selects computers where the product
type is Domain Controller (2) or Server (3).

### EXAMPLE 2
```
$WmiFilter1 = New-WmiFilterObject 'SELECT * FROM Win32_OperatingSystem WHERE ProductType = 3'
$WmiFilter2 = New-WmiFilterObject 'SELECT * FROM Win32_TerminalServiceSetting WHERE TerminalServerMode = 1' -NameSpace 'root\CIMv2\TerminalServices'
New-WmiFilterList $WmiFilter1, $WmiFilter2
```

This example would create a filter list that selects member servers which have
terminal server enabled. Note we are not using the default namespace for one
of the filters.

### EXAMPLE 3
```
$WmiFilterList = New-WmiFilterList
New-WmiFilterObject 'SELECT * FROM Win32_OperatingSystem WHERE ProductType = 3' -WmiFilterList $WmiFilterList
New-WmiFilterObject 'SELECT * FROM Win32_TerminalServiceSetting WHERE TerminalServerMode = 1' -NameSpace 'root\CIMv2\TerminalServices' -WmiFilterList $WmiFilterList
```

This is the same result as Example 2, however this time we are appending
filters to a WmiFilterList object instead.

## PARAMETERS

### -WmiFilterObject
WMI filter objects from New-WmiFilterObject.

```yaml
Type: WmiFilterObject[]
Parameter Sets: FromObject
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
The WMI filter.
The pattern 'SELECT \<something\> FROM \<somewhere\> WHERE \<sometest\>' is enforced.

```yaml
Type: String[]
Parameter Sets: FromString
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
Parameter Sets: FromString
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
Parameter Sets: FromString
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
