---
external help file: BW.Utils.GroupPolicy.WMIFilter-help.xml
Module Name: BW.Utils.GroupPolicy.WMIFilter
online version:
schema: 2.0.0
---

# Set-ADSystemOnlyChange

## SYNOPSIS
Set registry values on domain controller to allow writing to system only
attributes.

## SYNTAX

### Disable_Remote
```
Set-ADSystemOnlyChange [-ComputerName] <String[]> [-Disable] [-Credential <PSCredential>] [<CommonParameters>]
```

### Enable_Remote
```
Set-ADSystemOnlyChange [-ComputerName] <String[]> [-Enable] [-Credential <PSCredential>] [<CommonParameters>]
```

### Enable_Local
```
Set-ADSystemOnlyChange [-Enable] [<CommonParameters>]
```

### Disable_Local
```
Set-ADSystemOnlyChange [-Disable] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ComputerName
{{ Fill ComputerName Description }}

```yaml
Type: String[]
Parameter Sets: Disable_Remote, Enable_Remote
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Enable
{{ Fill Enable Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Enable_Remote, Enable_Local
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Disable
{{ Fill Disable Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Disable_Remote, Disable_Local
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
{{ Fill Credential Description }}

```yaml
Type: PSCredential
Parameter Sets: Disable_Remote, Enable_Remote
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
This function has been taken from the GPWmiFilter.psm1 module written by Bin
Yi from Microsoft with minimal changes.

## RELATED LINKS
