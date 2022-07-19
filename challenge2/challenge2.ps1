#Suppose we need to configure ASR for some windows VM, there are some pre-requisite which needs to be followed to enable the rsv to accept asr replication.But during the initial check you found some resources(recovery serives vault and some fabrics) are already deployed now you have to fetch those data from azure and proceed with left over vault preperations steps.

$vault_name = "name of vault"
$vault_resource_group = "name of rg where vault exists"

#first we should get the vault and set the vault context
$vault = Get-AzRecoveryServicesVault -Name $vault_name -ResourceGroupName $vault_resource_group
Set-AzRecoveryServicesAsrVaultContext -Vault $vault

#Fetching primary fabric since it is already deployed
$PrimaryFabric = Get-AzRecoveryServicesAsrFabric -Name "primary-fabric"

#creating secondary fabric to represent secondary location
$TempASRJob = New-AzRecoveryServicesAsrFabric -Azure -Location "AustraliaEast"  -Name "secondary-fabric"

# Track Job status to check for completion
while (($TempASRJob.State -eq "InProgress") -or ($TempASRJob.State -eq "NotStarted")){
        sleep 10;
        $TempASRJob = Get-AzRecoveryServicesAsrJob -Job $TempASRJob
}

#Check if the Job completed successfully. The updated job state of a successfully completed job should be "Succeeded"
Write-Output $TempASRJob.State

#Fetching recovery fabric so that it can be used for other deployment
$RecoveryFabric = Get-AzRecoveryServicesAsrFabric -Name "secondary-fabric"

#Fetching primary-protection-container since it is already deployed
$PrimaryProtContainer = Get-AzRecoveryServicesAsrProtectionContainer -Fabric $PrimaryFabric -Name "primary-protection-container"

#Create a Protection container in the recovery Azure region (with the Recovery fabric which we have fetched in out last command($RecoveryFabric))
$TempASRJob = New-AzRecoveryServicesAsrProtectionContainer -InputObject $RecoveryFabric -Name "secondary-protection-container"

#Track Job status to check for completion
while (($TempASRJob.State -eq "InProgress") -or ($TempASRJob.State -eq "NotStarted")){
        sleep 10;
        $TempASRJob = Get-AzRecoveryServicesAsrJob -Job $TempASRJob
}

#Check if the Job completed successfully. The updated job state of a successfully completed job should be "Succeeded"

Write-Output $TempASRJob.State

$RecoveryProtContainer = Get-AzRecoveryServicesAsrProtectionContainer -Fabric $RecoveryFabric -Name "secondary-protection-container"
