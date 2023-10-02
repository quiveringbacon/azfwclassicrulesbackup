
$rg = Read-Host -Prompt "Resource group the fw is in"

$fwname = Read-Host -Prompt "FW name to backup"

$savepath = Read-Host -Prompt "Path to save files to, default is c:\temp"
if ([string]::IsNullOrWhiteSpace($savepath))
{
$savepath = "c:\temp"
}

$colgroups = Get-AzFirewall -Name $fwname -ResourceGroupName $rg
#foreach ($colgroup in $colgroups.RuleCollectionGroups)
#{
    

    $returnObj = @()
    foreach ($rulecol in $colgroups.NetworkRuleCollections) {
        
        #if ($rulecol.rules.RuleType -contains "NetworkRule")
        #{
            #$returnObj = @()
            
            foreach ($rule in $rulecol.rules)
            {
                $properties = [ordered]@{
                #RuleCollectionGroupName = $rulecolgroup.Name;
                RuleCollectionName = $rulecol.Name;
                RulePriority = $rulecol.Priority;
                ActionType = $rulecol.Action.Type;
                RuleCollectionType = $rulecol.RuleCollectionType;
                Name = $rule.Name;
                protocols = $rule.protocols -join ", ";
                SourceAddresses = $rule.SourceAddresses -join ", ";
                DestinationAddresses = $rule.DestinationAddresses -join ", ";
                SourceIPGroups = $rule.SourceIPGroups -join ", ";
                DestinationIPGroups = $rule.DestinationIPGroups -join ", ";
                DestinationPorts = $rule.DestinationPorts -join ", ";
                DestinationFQDNs = $rule.DestinationFQDNs -join ", ";
                }
            $obj = New-Object psobject -Property $properties
            $returnObj += $obj
            
            }
    
                #change c:\temp to the path to export the CSV
            $returnObj | Export-Csv ${savepath}\netrules.csv -NoTypeInformation
            
    
        }
        $returnObj = @()
        foreach ($rulecol in $colgroups.ApplicationRuleCollections)
        {
            foreach ($rule in $rulecol.rules)
            {
                $properties = [ordered]@{
                #RuleCollectionGroupName = $rulecolgroup.Name;
                RuleCollectionName = $rulecol.Name;
                RulePriority = $rulecol.Priority;
                ActionType = $rulecol.Action.Type;
                RuleCollectionType = $rulecol.RuleCollectionType;
                Name = $rule.Name;
                protocols = $rule.protocols.protocolType -join ", ";
                SourceAddresses = $rule.SourceAddresses -join ", ";
                TargetFqdns = $rule.TargetFqdns -join ", ";
                SourceIPGroups = $rule.SourceIPGroups -join ", ";
                WebCategories = $rule.WebCategories -join ", ";
                TargetUrls = $rule.TargetUrls -join ", ";
                
                }
                
            $obj = New-Object psobject -Property $properties
            $returnObj += $obj
            }
            
            #change c:\temp to the path to export the CSV
            $returnObj | Export-Csv ${savepath}\apprules.csv -NoTypeInformation   
        }
        $returnObj = @()
        foreach ($rulecol in $colgroups.NatRuleCollections)
        {
            foreach ($rule in $rulecol.rules)
            {
                $properties = [ordered]@{
                #RuleCollectionGroupName = $rulecolgroup.Name;
                RuleCollectionName = $rulecol.Name;
                RulePriority = $rulecol.Priority;
                ActionType = $rulecol.Action.Type;
                RuleCollectionType = $rulecol.RuleCollectionType;
                Name = $rule.Name;
                protocols = $rule.Protocols -join ", ";
                SourceAddresses = $rule.SourceAddresses -join ", ";
                TranslatedAddress = $rule.TranslatedAddress -join ", ";
                SourceIPGroups = $rule.SourceIPGroups -join ", ";
                TranslatedPort = $rule.TranslatedPort -join ", ";
                DestinationAddresses = $rule.DestinationAddresses -join ", ";
                DestinationPorts = $rule.DestinationPorts -join ", ";
                }
                
            $obj = New-Object psobject -Property $properties
            $returnObj += $obj
            }
            
            #change c:\temp to the path to export the CSV
            $returnObj | Export-Csv ${savepath}\dnatrules.csv -NoTypeInformation   
        }
    #}
    
#}
