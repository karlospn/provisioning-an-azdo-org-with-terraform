param (
    [Parameter(Mandatory=$true)][string]$personal_access_token,
    [Parameter(Mandatory=$true)]$pipelines_permissions,
    [Parameter(Mandatory=$true)][string]$group_descriptor,
    [Parameter(Mandatory=$true)][string]$project_id,
    [Parameter(Mandatory=$true)][string]$repository_name)

$organization = "cponsn"

# Generate authentication header
$token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($personal_access_token)"))
$header = @{authorization = "Basic $token"}

# Get group descriptor
# $groups_url = "https://vssps.dev.azure.com/${organization}/_apis/graph/groups?api-version=6.0-preview.1"
# $groups = Invoke-RestMethod -Uri $groups_url -Method Get -ContentType "application/json" -Headers $header
# $descriptor  = $groups.value |  Where-Object {$_.displayName -eq $group_name} | Select-Object -ExpandProperty descriptor

# Decode group descriptor
$encoded_group_descriptor = $group_descriptor.Split('.')[1]
$descriptor = [System.Convert]::FromBase64String([System.Text.Encoding]::UTF8.GetBytes($encoded_group_descriptor))

# Get Namespaces
$getSecurityNamespacesUrl = "https://dev.azure.com/${organization}/_apis/securitynamespaces?api-version=6.0"
$securityNamespaces = Invoke-RestMethod -Uri $getSecurityNamespacesUrl -Method Get -Headers $header

# Get Namespace Security Id
$identitySecurityNamespaceId = ($securityNamespaces.value | Where-Object name -eq "Build").namespaceId

# Get Namespace Actions
$Securityactions = $identitySecurityNamespaceId = ($securityNamespaces.value | Where-Object name -eq "Build").actions

# Transform permissions to object
$permissions = $pipelines_permissions | ConvertFrom-Json -AsHashtable


# $assignPermissionsBody = @"
# {
#   "token": "$project_id/$repository_name",
#   "merge": true,
#   "accessControlEntries": [
#     {
#       "descriptor": "Microsoft.TeamFoundation.Identity;${group_id}",
#       "allow": 31
#     }
#   ]
# }
# "@

# $assignTeamAdminUrl = "https://dev.azure.com/${organization}/_apis/accesscontrolentries/${identitySecurityNamespaceId}" + "?api-version=6.0"
# $result = Invoke-RestMethod -Uri $assignTeamAdminUrl -Method Post -ContentType "application/json" -Headers $header -Body $assignPermissionsBody