---
external help file: BW.Utils.GroupPolicy.WMIFilter-help.xml
Module Name: BW.Utils.GroupPolicy.WMIFilter
online version:
schema: 2.0.0
---

# Get-GPWmiFilterLinkedGPO

## SYNOPSIS
Return all GPO objects linked to a given WMI filter

## SYNTAX

### ByName (Default)
```
Get-GPWmiFilterLinkedGPO [-Name] <String> [-Domain <String>] [-Server <String>] [<CommonParameters>]
```

### ByGUID
```
Get-GPWmiFilterLinkedGPO [-Guid] <Guid> [-Domain <String>] [-Server <String>] [<CommonParameters>]
```

## DESCRIPTION
Return all GPO objects linked to a given WMI filter

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-GPWmiFilterLinkedGPO -Name 'Domain Controllers'
```

Will return any GPO with the 'Domain Controllers' WMI filter.

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

### -Domain

```yaml
Type: String
Parameter Sets: (All)
Aliases: DomainName

Required: False
Position: Named
Default value: $env:USERDNSDOMAIN
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
