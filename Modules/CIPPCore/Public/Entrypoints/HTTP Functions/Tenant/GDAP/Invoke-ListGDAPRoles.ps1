using namespace System.Net

Function Invoke-ListGDAPRoles {
    <#
    .FUNCTIONALITY
        Entrypoint
    .ROLE
        Tenant.Relationship.Read
    #>
    [CmdletBinding()]
    param($Request, $TriggerMetadata)

    $APIName = $TriggerMetadata.FunctionName
    Write-LogMessage -user $request.headers.'x-ms-client-principal' -API $APINAME -message 'Accessed this API' -Sev 'Debug'


    # Write to the Azure Functions log stream.
    Write-Host 'PowerShell HTTP trigger function processed a request.'
    $Table = Get-CIPPTable -TableName 'GDAPRoles'
    $Groups = Get-CIPPAzDataTableEntity @Table

    $MappedGroups = foreach ($Group in $Groups) {
        [PSCustomObject]@{
            GroupName        = $Group.GroupName
            GroupId          = $Group.GroupId
            RoleName         = $Group.RoleName
            roleDefinitionId = $Group.roleDefinitionId
        }
    }

    # Associate values to output bindings by calling 'Push-OutputBinding'.
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode = [HttpStatusCode]::OK
            Body       = @($MappedGroups)
        })

}
