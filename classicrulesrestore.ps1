#Provide Input. Firewall Policy Name, Firewall Policy Resource Group & Firewall Policy Rule Collection Group Name

Write-Host "Don't forget that in NAT rules destination address other than AzureFirewall PublicIP or PrivateIP
is not supported!"

$fpname = Read-Host -Prompt "FW name to restore to"
$fprg = Read-Host -Prompt "Resource group the fw is in"
 

$savepath = Read-Host -Prompt "Path where backup files are, default is c:\temp"
if ([string]::IsNullOrWhiteSpace($savepath))
{
$savepath = "c:\temp"
}


$targetfw = Get-AzFirewall -Name $fpname -ResourceGroupName $fprg



# Change the folder where the CSV is located
if (Test-Path -Path ${savepath}\netrules.csv)
{

    
    $readObj1 = import-csv ${savepath}\netrules.csv
    
    $colname1 = $readObj1[0].psobject.properties.value[0]
    #$targetrcg1 = New-AzFirewallPolicyRuleCollectionGroup -Name $colname1 -Priority 200 -FirewallPolicyObject $targetfp
    
    #$target1 = Get-AzFirewallPolicyRuleCollectionGroup -Name $colname1 -ResourceGroupName $fprg -AzureFirewallPolicyName $fpname
    $testcsv = $readObj1 | Select-Object -ExpandProperty RuleCollectionName -Unique
    
    
    ForEach ($item1 in $testcsv)
    {
        
        $2 = ($readObj1 | Where-Object {$_.RuleCollectionName -eq $item1})
        
        $RulesfromCSV1 = @()
        $rules1 = @()
    
    
    foreach ($entry1 in $2)
        {
            
            $properties = [ordered]@{
            RuleCollectionName = $entry1.RuleCollectionName;
            RulePriority = $entry1.RulePriority;
            ActionType = $entry1.ActionType;
            Name = $entry1.Name;
            protocols = $entry1.protocols -split ", ";
            SourceAddresses = $entry1.SourceAddresses -split ", ";
            DestinationAddresses = $entry1.DestinationAddresses -split ", ";
            SourceIPGroups = $entry1.SourceIPGroups -split ", ";
            DestinationIPGroups = $entry1.DestinationIPGroups -split ", ";
            DestinationPorts = $entry1.DestinationPorts -split ", ";
            DestinationFQDNs = $entry1.DestinationFQDNs -split ", ";
            }
        $obj1 = New-Object psobject -Property $properties
        $RulesfromCSV1 += $obj1
        
        }
    
    $RulesfromCSV1
     
    foreach ($entry1 in $RulesfromCSV1)
        {
            
            $RuleParameter1 = @{
            Name = $entry1.Name;
            Protocol = $entry1.protocols
            sourceAddress = $entry1.SourceAddresses
            DestinationAddress = $entry1.DestinationAddresses
            DestinationPort = $entry1.DestinationPorts
            }
        $rule1 = New-AzFirewallNetworkRule @RuleParameter1
        
            $NetworkRuleCollection = @{
            Name = $entry1.RuleCollectionName 
            
            Priority = $entry1.RulePriority
            ActionType = $entry1.ActionType
            Rule       = $rules1 += $rule1            
            
            }
        
        $NetworkRuleCategoryCollection = New-AzFirewallNetworkRuleCollection @NetworkRuleCollection
        
        
        }
        
        $newrulecol = $targetfw.AddNetworkRuleCollection($NetworkRuleCategoryCollection)
        
        
    }
    #$targetfw | Set-AzFirewall
    #Set-AzFirewall -AzureFirewall $targetfw
}


if (Test-Path -Path ${savepath}\apprules.csv)
{

    
    # Change the folder where the CSV is located
    $readObj2 = import-csv ${savepath}\apprules.csv
    $colname2 = $readObj2[0].psobject.properties.value[0]
    
    $testcsv = $readObj2 | Select-Object -ExpandProperty RuleCollectionName -Unique
    ForEach ($item1 in $testcsv)
    {
        
        $2 = ($readObj2 | Where-Object {$_.RuleCollectionName -eq $item1})
        
        $RulesfromCSV2 = @()
        $rules2 = @()

    foreach ($entry2 in $2)
        {
            $properties = [ordered]@{
            RuleCollectionName = $entry2.RuleCollectionName;
            RulePriority = $entry2.RulePriority;
            ActionType = $entry2.ActionType;
            RuleCollectionType = $entry2.RuleCollectionType;
            Name = $entry2.Name;
            protocols = $entry2.Protocols -split ", ";
            SourceAddresses = $entry2.SourceAddresses -split ", ";
            TargetFqdns = $entry2.TargetFqdns -split ", ";
            SourceIPGroups = $entry2.SourceIPGroups -split ", ";
            WebCategories = $entry2.WebCategories -split ", ";
            TargetUrls = $entry2.TargetUrls -split ", ";
        
            }
        $obj2 = New-Object psobject -Property $properties
        $RulesfromCSV2 += $obj2
        }

    $RulesfromCSV2

    $rules2 = @()
    foreach ($entry2 in $RulesfromCSV2)
        {
            $RuleParameter2 = @{
            Name = $entry2.Name;
            Protocol = $entry2.Protocols
            sourceAddress = $entry2.SourceAddresses
            TargetFqdn = $entry2.TargetFqdns
        
            }
        $rule2 = New-AzFirewallApplicationRule @RuleParameter2
        $ApplicationRuleCollection = @{
            Name = $entry2.RuleCollectionName
            Priority = $entry2.RulePriority
            ActionType = $entry2.ActionType
            Rule       = $rules2 += $rule2
            }
        
            $ApplicationRuleCategoryCollection = New-AzFirewallApplicationRuleCollection @ApplicationRuleCollection
        }

    # Create a network rule collection
    
    $newrulecol = $targetfw.AddApplicationRuleCollection($ApplicationRuleCategoryCollection)
    # Deploy to created rule collection group
    
    }
    #Set-AzFirewallPolicyRuleCollectionGroup -Name $colname2 -Priority 200 -RuleCollection $target1.Properties.RuleCollection -FirewallPolicyObject $targetfp
}

if (Test-Path -Path ${savepath}\dnatrules.csv)
    {

        
        # Change the folder where the CSV is located
        $readObj3 = import-csv ${savepath}\dnatrules.csv
        $colname3 = $readObj3[0].psobject.properties.value[0]
        
        $testcsv = $readObj3 | Select-Object -ExpandProperty RuleCollectionName -Unique
        ForEach ($item1 in $testcsv)
        {
        
        $2 = ($readObj3 | Where-Object {$_.RuleCollectionName -eq $item1})
        
        $RulesfromCSV3 = @()
        $rules3 = @()


        foreach ($entry3 in $2)
        {
                $properties = [ordered]@{
                RuleCollectionName = $entry3.RuleCollectionName;
                RulePriority = $entry3.RulePriority;
                ActionType = $entry3.ActionType;
                RuleCollectionType = $entry3.RuleCollectionType;
                Name = $entry3.Name;
                protocols = $entry3.Protocols -join ", ";
                SourceAddresses = $entry3.SourceAddresses -join ", ";
                TranslatedAddress = $entry3.TranslatedAddress -join ", ";
                SourceIPGroups = $entry3.SourceIPGroups -join ", ";
                TranslatedPort = $entry3.TranslatedPort -join ", ";
                DestinationAddresses = $entry3.DestinationAddresses -join ", ";
                DestinationPorts = $entry3.DestinationPorts -join ", ";
            }
            $obj3 = New-Object psobject -Property $properties
            $RulesfromCSV3 += $obj3
        }
        
        $RulesfromCSV3
        #Clear-Variable rules
        $rules3 = @()
        foreach ($entry3 in $RulesfromCSV3)
        {
            $RuleParameter3 = @{
                Name = $entry3.Name;
                Protocol = $entry3.Protocols
                sourceAddress = $entry3.SourceAddresses
                DestinationAddress = $entry3.DestinationAddresses
                DestinationPort = $entry3.DestinationPorts
                TranslatedAddress = $entry3.TranslatedAddress
                TranslatedPort = $entry3.TranslatedPort
                
            }
            $rule3 = New-AzFirewallNatRule @RuleParameter3
                $NatRuleCollection = @{
                Name = $entry3.RuleCollectionName
                Priority = $entry3.RulePriority
                #ActionType = $entry3.ActionType
                Rule       = $rules3 += $rule3
            }
            $NatRuleCategoryCollection = New-AzFirewallNatRuleCollection @NatRuleCollection
        }
        
        # Create a network rule collection
        
        $newrulecol = $targetfw.AddNatRuleCollection($NatRuleCategoryCollection)
        # Deploy to created rule collection group
        
        }    
        #Set-AzFirewallPolicyRuleCollectionGroup -Name $colname3 -Priority 200 -RuleCollection $target1.Properties.RuleCollection -FirewallPolicyObject $targetfp
    }
Write-Host "Setting Firewall"
$1 = Set-AzFirewall -AzureFirewall $targetfw
Write-Host "Done"