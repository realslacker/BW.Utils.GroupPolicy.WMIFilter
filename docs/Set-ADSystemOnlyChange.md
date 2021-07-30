---
external help file: BW.Utils.GroupPolicy.WMIFilter-help.xml
Module Name: BW.Utils.GroupPolicy.WMIFilter
online version:
schema: 2.0.0
---

# Set-ADSystemOnlyChange

## SYNOPSIS
Set registry values on domain controller to allow writing to system only attributes.

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
Set registry values on domain controller to allow writing to system only attributes.

## EXAMPLES

### Example 1
```
PS C:\> Set-ADSystemOnlyChange -Enable -ComputerName dc.contoso.com -Credential (Get-Credential)
```

Enables System Only Change on dc.contoso.com.

## PARAMETERS

### -ComputerName
The remote computer to connect to.

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
Enable writing to System Only objects in AD.

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
Disable writing to System Only objects in AD.

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
Credential for authenticating to a remote computer.

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
This function has been taken from the GPWmiFilter.psm1 module written by Bin Yi from Microsoft with minimal changes.

## RELATED LINKS
