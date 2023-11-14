# Azfw classic rules backup and restore

These powershell scripts will take any Dnat, network and application rules and collections then save them to csv files for each rule type (for example, netrules.csv, apprules.csv). You will be prompted for the resource group and firewall name to backup as well as the path to save to. The default path is "c:\temp". The restore script parses the files and creates the rules in the specified firewall. You will be prompted to create a new policy and for the resource group name and firewall name to restore to and the path to look in.
