---
external help file: BW.Utils.GroupPolicy.WMIFilter-help.xml
Module Name: BW.Utils.GroupPolicy.WMIFilter
online version:
schema: 2.0.0
---

# Set-GPOWmiFilterLink

## SYNOPSIS
Set the WMI filter for a supplied GPO

## SYNTAX

### ByName (Default)
```
Set-GPOWmiFilterLink [-GPO] <Gpo> [-Name] <String> [-Server <String>] [-PassThru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ByGUID
```
Set-GPOWmiFilterLink [-GPO] <Gpo> [-Guid] <Guid> [-Server <String>] [-PassThru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Clear
```
Set-GPOWmiFilterLink [-GPO] <Gpo> [-Clear] [-Server <String>] [-PassThru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Set the WMI filter for a supplied GPO by modifying AD directly.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-GPO -Name 'Default Domain Controllers Policy' | Set-GPOWmiFilterLink -Name 'Domain Controllers'
```

Will set the GPO 'Default Domain Controllers Policy' to use the 'Domain Controllers' WMI filter.

## PARAMETERS

### -GPO

```yaml
Type: Gpo
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name

```yaml
Type: String
Parameter Sets: ByName
Aliases: DisplayName

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Guid

```yaml
Type: Guid
Parameter Sets: ByGUID
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Clear
Clear existing WMI filter

```yaml
Type: SwitchParameter
Parameter Sets: Clear
Aliases:

Required: True
Position: 2
Default value: False
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

### -PassThru

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

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
