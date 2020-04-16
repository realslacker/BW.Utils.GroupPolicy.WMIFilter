# BW.Utils.GroupPolicy.WMIFilter

Module to support the import and export of Group Policy WMI filters.

## Documentation

 - [Get-GPWmiFilter](docs/Get-GPWmiFilter.md)
 - [New-GPWmiFilter](docs/New-GPWmiFilter.md)
 - [New-WmiFilterList](docs/New-WmiFilterList.md)
 - [New-WmiFilterObject](docs/New-WmiFilterObject.md)
 - [Remove-GPWmiFilter](docs/Remove-GPWmiFilter.md)
 - [Set-ADSystemOnlyChange](docs/Set-ADSystemOnlyChange.md)
 - [Set-GPWmiFilter](docs/Set-GPWmiFilter.md)
 - [Test-ADSystemOnlyChangeEnabled](docs/Test-ADSystemOnlyChangeEnabled.md)

## Notes

If your Active Directory is based on Windows 2003 or has been upgraded
from Windows 2003, you may may have an issue with System Owned Objects.
Importing or adding a WMI Filter object into AD used to be a system only
operation. So you previously needed to enable system only changes on a
domain controller for a successful ldifde import.

If this is the case you will need to set the following registry value:

    Key: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\NTDS\Parameters
    Type: REG_DWORD
    Value: Allow System Only Change
    Data: 1
    
You can use the Set-ADSystemOnlyChange cmdlet to configure this value.

## Sources

This module was created from resources found in the following scripts:

1.  [Using Powershell to Automatically Create WMI Filters](http://gallery.technet.microsoft.com/scriptcenter/f1491111-9f5d-4c83-b436-537eca9e8d94) ([Archive.org](https://web.archive.org/web/20200318052952/http://gallery.technet.microsoft.com/scriptcenter/f1491111-9f5d-4c83-b436-537eca9e8d94))
2.  [Exporting and Importing WMI Filters with PowerShell: Part 1, Export](http://blogs.technet.com/b/manny/archive/2012/02/04/perform-a-full-export-and-import-of-wmi-filters-with-powershell.aspx) ([Archive.org](https://web.archive.org/web/20150609055154/http://blogs.technet.com/b/manny/archive/2012/02/04/perform-a-full-export-and-import-of-wmi-filters-with-powershell.aspx))
3.  [Exporting and Importing WMI Filters with PowerShell: Part 2, Import](http://blogs.technet.com/b/manny/archive/2012/02/05/exporting-and-importing-wmi-filters-with-powershell-part-2-import.aspx) ([Archive.org](https://web.archive.org/web/20150304225257/http://blogs.technet.com/b/manny/archive/2012/02/05/exporting-and-importing-wmi-filters-with-powershell-part-2-import.aspx))

Another great reference:
-   [Digging Into Group Policy WMI Filters and Managing them through PowerShell](http://sdmsoftware.com/group-policy-blog/gpmc/digging-into-group-policy-wmi-filters-and-managing-them-through-powershell/) ([Archive.org](https://web.archive.org/web/20190405080627/https://sdmsoftware.com/group-policy-blog/gpmc/digging-into-group-policy-wmi-filters-and-managing-them-through-powershell/))

