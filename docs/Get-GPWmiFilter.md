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

### GetAll
```
Get-GPWmiFilter [-All] [-Domain <String>] [-Server <String>] [-AsDirectoryEntry] [<CommonParameters>]
```

### ByName
```
Get-GPWmiFilter [-Name] <String> [-Domain <String>] [-Server <String>] [-AsDirectoryEntry] [<CommonParameters>]
```

### ByGUID
```
Get-GPWmiFilter [-Guid] <Guid> [-Domain <String>] [-Server <String>] [-AsDirectoryEntry] [<CommonParameters>]
```

### ByGPO
```
Get-GPWmiFilter -GPO <Gpo> [-AsDirectoryEntry] [<CommonParameters>]
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

Will return a list of all WMI filters with 'Server' in the name from the domain contoso.com using the CONTOSO Administrator account.

### EXAMPLE 3
```
Get-GPWmiFilter -GUID '6a3a8a8d-2072-4596-8b5b-b24bcf0486ce'
```

Will return the WMI filter with the GUID '6a3a8a8d-2072-4596-8b5b-b24bcf0486ce' from the current user's domain.

## PARAMETERS

### -Name
WMI Filter Name

```yaml
Type: String
Parameter Sets: ByName
Aliases: DisplayName

Required: True
Position: 2
Default value: *
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -All

```yaml
Type: SwitchParameter
Parameter Sets: GetAll
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AsDirectoryEntry
Return results as DirectoryEntry object

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domain

```yaml
Type: String
Parameter Sets: GetAll, ByName, ByGUID
Aliases: DomainName

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GPO
Microsoft.GroupPolicy.Gpo to use to select the WMI filter

```yaml
Type: Gpo
Parameter Sets: ByGPO
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
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
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Server

```yaml
Type: String
Parameter Sets: GetAll, ByName, ByGUID
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
