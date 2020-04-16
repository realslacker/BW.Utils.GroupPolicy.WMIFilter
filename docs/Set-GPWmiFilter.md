---
external help file: BW.Utils.GroupPolicy.WMIFilter-help.xml
Module Name: BW.Utils.GroupPolicy.WMIFilter
online version:
schema: 2.0.0
---

# Set-GPWmiFilter

## SYNOPSIS
Updates an exising WMI filter in Active Directory.

## SYNTAX

### Name (Default)
```
Set-GPWmiFilter [-Name] <String> [-NewName <String>] [-Description <String>] [-Filter <WmiFilterObject[]>]
 [-DomainName <String>] [-Credential <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### GUID
```
Set-GPWmiFilter [-GUID] <Guid> [-NewName <String>] [-Description <String>] [-Filter <WmiFilterObject[]>]
 [-DomainName <String>] [-Credential <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
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
The Name of the WMI filter to update.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GUID
The GUID of the WMI filter to update.

```yaml
Type: Guid
Parameter Sets: GUID
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
The new name if renaming the WMI filter.

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
A description of what the WMI filter does.

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

### -Filter
Either string filter(s) or WMI filter object(s) returned by New-WmiFilterObject.

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
Credential for binding to the domain.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
