---
external help file: BW.Utils.GroupPolicy.WMIFilter-help.xml
Module Name: BW.Utils.GroupPolicy.WMIFilter
online version:
schema: 2.0.0
---

# Get-GPWmiFilter

## SYNOPSIS
Get WMI filters from Active Directory.

## SYNTAX

### Name (Default)
```
Get-GPWmiFilter [[-Name] <String>] [-DomainName <String>] [-Credential <PSCredential>] [<CommonParameters>]
```

### GUID
```
Get-GPWmiFilter [[-GUID] <Guid>] [-DomainName <String>] [-Credential <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
Get WMI filters from Active Directory and parse them into objects.

## EXAMPLES

### EXAMPLE 1
```
Get-GPWmiFilter
```

Will return a list of all WMI filters in the current user's domain.

### EXAMPLE 2
```
Get-GPWmiFilter -Name '*Server*' -DomainName 'contoso.com' -Credential (Get-Credential CONTOSO\Administrator)
```

Will return a list of all WMI filters with 'Server' in the name from the domain
contoso.com using the CONTOSO Administrator account.

### EXAMPLE 3
```
Get-GPWmiFilter -GUID '6a3a8a8d-2072-4596-8b5b-b24bcf0486ce'
```

Will return the WMI filter with the GUID '6a3a8a8d-2072-4596-8b5b-b24bcf0486ce'
from the current user's domain.

## PARAMETERS

### -Name
The Name of the WMI filter to return.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: 2
Default value: *
Accept pipeline input: False
Accept wildcard characters: True
```

### -GUID
The GUID of the WMI filter to return.

```yaml
Type: Guid
Parameter Sets: GUID
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DomainName
The domain to search for WMI filters.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
