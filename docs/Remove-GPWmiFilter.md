---
external help file: BW.Utils.GroupPolicy.WMIFilter-help.xml
Module Name: BW.Utils.GroupPolicy.WMIFilter
online version:
schema: 2.0.0
---

# Remove-GPWmiFilter

## SYNOPSIS
Remove WMI filters from Active Directory.

## SYNTAX

### Name (Default)
```
Remove-GPWmiFilter [-Name] <String> [-DomainName <String>] [-Credential <PSCredential>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### GUID
```
Remove-GPWmiFilter [-GUID] <Guid> [-DomainName <String>] [-Credential <PSCredential>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Remove WMI filters from Active Directory after validating that they are not in
use by any Group Policy objects.

## EXAMPLES

### Example 1
```powershell
PS C:\> Remove-GPWmiFilter -GUID '6a3a8a8d-2072-4596-8b5b-b24bcf0486ce'
```

Will remove the WMI filter with the GUID '6a3a8a8d-2072-4596-8b5b-b24bcf0486ce'
from the current user's domain.

## PARAMETERS

### -Name
The Name of the WMI filter.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GUID
The GUID of the WMI filter.

```yaml
Type: Guid
Parameter Sets: GUID
Aliases:

Required: True
Position: 1
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
Default value: None
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

### None

## OUTPUTS

## NOTES

## RELATED LINKS
