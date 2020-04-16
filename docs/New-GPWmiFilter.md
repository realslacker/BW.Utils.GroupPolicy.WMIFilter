---
external help file: BW.Utils.GroupPolicy.WMIFilter-help.xml
Module Name: BW.Utils.GroupPolicy.WMIFilter
online version:
schema: 2.0.0
---

# New-GPWmiFilter

## SYNOPSIS
Create a new WMI filter in Active Directory.

## SYNTAX

```
New-GPWmiFilter [-Name] <String> [-Description <String>] [-GUID <Guid>] -Filter <WmiFilterObject[]>
 [-DomainName <String>] [-Credential <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
Create a new WMI filter object in Active Directory.

## EXAMPLES

### EXAMPLE 1
```
New-GPWmiFilter -Name 'Servers Only' -Description 'Selects computers where the product type is Domain Controller (2) or Server (3)' -Filter 'SELECT * FROM Win32_OperatingSystem WHERE ProductType = 2 OR ProductType = 3'
```

This example would create a filter that selects computers where the product type is Domain Controller (2) or Server (3).

## PARAMETERS

### -Name
The Name of the WMI filter to create.
Must be unique.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
An optional description of what the WMI filter does.

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

### -GUID
Allows you to optionally specify the GUID of the WMI filter.
This is useful
for restoring WMI filters from backup.
Defaults to a random GUID.

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: ( [guid]::NewGuid() )
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
Either string filter(s) or WMI filter object(s) returned by New-WmiFilterObject.

```yaml
Type: WmiFilterObject[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DomainName
The destination domain.

```yaml
Type: String
Parameter Sets: (All)
Aliases: DnsDomain

Required: False
Position: Named
Default value: $env:USERDNSDOMAIN
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
{{ Fill Credential Description }}

```yaml
Type: PSCredential
Parameter Sets: (All)
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

## RELATED LINKS
