param([Parameter(Mandatory = $true, HelpMessage = "Resource ID")][String]$ResourceId,
[Parameter(Mandatory = $true, HelpMessage = "Action")][ValidateSet("start", "resume", "stop", "deallocate", "suspend", IgnoreCase = $false)][String]$Action,
[Parameter(Mandatory = $true, HelpMessage = "Api Version")][String]$ApiVersion)
Connect-AzAccount -Identity;
Invoke-RestMethod -Uri "https://management.azure.com$ResourceId/$Action?api-version=$ApiVersion" -Method Post -Headers @{"Content-Type"  = "application/json"; "Authorization" = "Bearer $((Get-AzAccessToken).Token)"};