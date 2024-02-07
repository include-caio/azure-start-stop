<#
.SYNOPSIS
    Script para start/stop de diversos recursos do Azure
.DESCRIPTION
    O script recebe como parâmetros o ID do recurso e ação (Start ou Stop) e executa conforme o especificado

    Para iniciar, é necessário ter instalado o módulo Az
        Install-Module -Name Az
        
    Recursos atualmente suportados pelo script:
        microsoft.app/containerapps (Container Apps)
        Microsoft.ContainerInstance/containerGroups (Container Groups)
        Microsoft.ContainerService/managedClusters (Azure Kubernetes Service (AKS))
        Microsoft.Compute/virtualMachines (Virtual Machines)
        Microsoft.Network/applicationGateways (Application Gateways)
        Microsoft.AnalysisServices/servers (Analysis Services)
        Microsoft.DBforMySQL/servers (MySQL (Single Server))
        Microsoft.DBforMySQL/flexibleServers (MySQL (Flexible Server))
        Microsoft.DBforMariaDB/servers (MariaDB (Server))
        Microsoft.DBforPostgreSQL/flexibleServers (PostgreSQL (Flexible Server))
    
.PARAMETER ResourceId
    Id do recurso

.PARAMETER Action
    Ação desejada (Start ou Stop)

.EXAMPLE
    PS C:\> StartStop.ps1 `
            -ResourceId /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Compute/virtualMachines/machine1 `
            -Action start

    Com os parâmetros acima, o script irá executar a ação de start na VM "machine1"

.NOTES
    Filename: StartStop.ps1
    Author: Caio Souza do Carmo
    Modified date: 2024-02-07
    Version 1.0 - Start e Stop
#>

param(
    [Parameter(Mandatory = $true, HelpMessage = "O ID do recurso em que a ação será realizada")]
    [String]$ResourceId,

    [Parameter(Mandatory = $true, HelpMessage = "A ação para realizar no recurso. Pode ser 'Start' ou 'Stop'")]
    [ValidateSet("Start", "Stop", IgnoreCase = $true)]
    [String]$Action
)

Connect-AzAccount -Identity;

function GetDate() {
    $TimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById("E. South America Standard Time")
    $tCurrentTime = [System.TimeZoneInfo]::ConvertTimeFromUtc((Get-Date).ToUniversalTime(), $TimeZone)
    return Get-Date -Date $tCurrentTime -UFormat "%Y-%m-%d %H:%M:%S"
}

function StartStopContainerApp() {
    param (
        [Parameter()]
        [String]$Action,

        [Parameter()]
        [String]$ResourceGroupName,

        [Parameter()]
        [String]$ResourceName
    )

    if ($Action -eq "start") {
        Write-Output ("[$(GetDate)] Iniciando Container App: $($ResourceName)");
        Start-AzContainerApp  -ResourceGroupName $ResourceGroupName `
            -Name $ResourceName `
            -NoWait `
            -WarningAction SilentlyContinue;
    }
    elseif ($Action -eq "stop") {
        Write-Output ("[$(GetDate)] Parando Container App: $($ResourceName)");
        Stop-AzContainerApp  -ResourceGroupName $ResourceGroupName `
            -Name $ResourceName `
            -NoWait `
            -WarningAction SilentlyContinue;
    }
}

function  StartStopContainerGroup() {
    param (
        [Parameter()]
        [String]$Action,

        [Parameter()]
        [String]$ResourceGroupName,

        [Parameter()]
        [String]$ResourceName
    )

    if ($Action -eq "start") {
        Write-Output ("[$(GetDate)] Iniciando Container Group: $($ResourceName)");
        Start-AzContainerGroup  -ResourceGroupName $ResourceGroupName `
            -Name $ResourceName `
            -NoWait `
            -WarningAction SilentlyContinue;
    }
    elseif ($Action -eq "stop") {
        Write-Output ("[$(GetDate)] Parando Container Group: $($ResourceName)");
        Stop-AzContainerGroup  -ResourceGroupName $ResourceGroupName `
            -Name $ResourceName `
            -NoWait `
            -WarningAction SilentlyContinue;
    }
}

function StartStopAKS() {
    param (
        [Parameter()]
        [String]$Action,

        [Parameter()]
        [String]$ResourceGroupName,

        [Parameter()]
        [String]$ResourceName
    )

    if ($Action -eq "start") {
        Write-Output ("[$(GetDate)] Iniciando Azure Kubernetes: $($ResourceName)");
        Start-AzAksCluster  -ResourceGroupName $ResourceGroupName `
            -Name $ResourceName `
            -NoWait `
            -WarningAction SilentlyContinue;
    }
    elseif ($Action -eq "stop") {
        Write-Output ("[$(GetDate)] Parando Azure Kubernetes: $($ResourceName)");
        Stop-AzAksCluster  -ResourceGroupName $ResourceGroupName `
            -Name $ResourceName `
            -NoWait `
            -WarningAction SilentlyContinue;
    }
}

function StartStopVM() {
    param (
        [Parameter()]
        [String]$Action,

        [Parameter()]
        [String]$ResourceGroupName,

        [Parameter()]
        [String]$ResourceName
    )

    if ($Action -eq "start") {
        Write-Output ("[$(GetDate)] Iniciando Virtual Machine: $($ResourceName)");
        Start-AzVM  -ResourceGroupName $ResourceGroupName `
            -Name $ResourceName `
            -NoWait;
    }
    elseif ($Action -eq "stop") {
        Write-Output ("[$(GetDate)] Parando Virtual Machine: $($ResourceName)");
        Stop-AzVM  -ResourceGroupName $ResourceGroupName `
            -Name $ResourceName `
            -NoWait;
    }
}

function StartStopApplicationGateway() {
    param (
        [Parameter()]
        [String]$Action,

        [Parameter()]
        [String]$ResourceGroupName,

        [Parameter()]
        [String]$ResourceName
    )

    $ApplicationGateway = (Get-AzApplicationGateway -Name $ResourceName -ResourceGroupName $ResourceGroupName)

    if ($Action -eq "start") {
        Write-Output ("[$(GetDate)] Iniciando Application Gateway: $($ResourceName)");
        Start-AzApplicationGateway -ApplicationGateway $ApplicationGateway;
    }
    elseif ($Action -eq "stop") {
        Write-Output ("[$(GetDate)] Parando Application Gateway: $($ResourceName)");
        Stop-AzApplicationGateway -ApplicationGateway $ApplicationGateway;
    }
}

function StartStopAnalysisServices() {
    param (
        [Parameter()]
        [String]$Action,

        [Parameter()]
        [String]$ResourceGroupName,

        [Parameter()]
        [String]$ResourceName
    )

    #Licença poética
    if ($Action -eq "start") {
        Write-Output ("[$(GetDate)] Resumindo Analysis Services: $($ResourceName)");
        Resume-AzAnalysisServicesServer -Name $ResourceName -ResourceGroupName $ResourceGroupName;
    }
    elseif ($Action -eq "stop") {
        Write-Output ("[$(GetDate)] Suspendendo Analysis Services: $($ResourceName)");
        Suspend-AzAnalysisServicesServer -Name $ResourceName -ResourceGroupName $ResourceGroupName;
    }
}

function StartStopMySQLSingle() {
    param (
        [Parameter()]
        [String]$Action,

        [Parameter()]
        [String]$ResourceId
    )

    $ResourceName = $ResourceId.Split("/")[-1];

    $AuthHeader = @{
        'Content-Type'  = 'application/json'
        'Authorization' = 'Bearer ' + (Get-AzAccessToken).Token
    }

    if ($Action -eq "start") {
        Write-Output ("[$(GetDate)] Iniciando MySQL Single Server: $($ResourceName)");
        $RestUri = "https://management.azure.com$($ResourceId)/start?api-version=2020-01-01";
        Invoke-RestMethod -Uri $RestUri -Method Post -Headers $AuthHeader;
    }
    elseif ($Action -eq "stop") {
        Write-Output ("[$(GetDate)] Parando MySQL Single Server: $($ResourceName)");
        $RestUri = "https://management.azure.com$($ResourceId)/stop?api-version=2020-01-01";
        Invoke-RestMethod -Uri $RestUri -Method Post -Headers $AuthHeader;
    }
}

function StartStopMySQLFlexible() {
    param (
        [Parameter()]
        [String]$Action,

        [Parameter()]
        [String]$ResourceGroupName,

        [Parameter()]
        [String]$ResourceName
    )

    if ($Action -eq "start") {
        Write-Output ("[$(GetDate)] Iniciando MySQL Flexible Server: $($ResourceName)");
        Start-AzMySqlFlexibleServer -Name $ResourceName -ResourceGroupName $ResourceGroupName -NoWait;
    }
    elseif ($Action -eq "stop") {
        Write-Output ("[$(GetDate)] Parando MySQL Flexible Server: $($ResourceName)");
        Stop-AzMySqlFlexibleServer -Name $ResourceName -ResourceGroupName $ResourceGroupName -NoWait;
    }
}

function StartStopMariaDBServer() {
    param (
        [Parameter()]
        [String]$Action,

        [Parameter()]
        [String]$ResourceId
    )

    $ResourceName = $ResourceId.Split("/")[-1];

    $AuthHeader = @{
        'Content-Type'  = 'application/json'
        'Authorization' = 'Bearer ' + (Get-AzAccessToken).Token
    }

    if ($Action -eq "start") {
        Write-Output ("[$(GetDate)] Iniciando MariaDB Server: $($ResourceName)");
        $RestUri = "https://management.azure.com$($ResourceId)/start?api-version=2020-01-01";
        Invoke-RestMethod -Uri $RestUri -Method Post -Headers $AuthHeader;
    }
    elseif ($Action -eq "stop") {
        Write-Output ("[$(GetDate)] Parando MariaDB Server: $($ResourceName)");
        $RestUri = "https://management.azure.com$($ResourceId)/stop?api-version=2020-01-01";
        Invoke-RestMethod -Uri $RestUri -Method Post -Headers $AuthHeader;
    }
}

function StartStopPostgreSQLFlexible() {
    param (
        [Parameter()]
        [String]$Action,

        [Parameter()]
        [String]$ResourceGroupName,

        [Parameter()]
        [String]$ResourceName
    )

    if ($Action -eq "start") {
        Write-Output ("[$(GetDate)] Iniciando PostgreSQL Flexible Server: $($ResourceName)");
        Start-AzPostgreSqlFlexibleServer -Name $ResourceName -ResourceGroupName $ResourceGroupName -NoWait;
    }
    elseif ($Action -eq "stop") {
        Write-Output ("[$(GetDate)] Parando PostgreSQL Flexible Server: $($ResourceName)");
        Stop-AzPostgreSqlFlexibleServer -Name $ResourceName -ResourceGroupName $ResourceGroupName -NoWait;
    }
}

$TempID = $ResourceId.Split("/");
$SubscriptionId = $TempID[2];
$ResourceGroupName = $TempID[4];
$ResourceName = $TempID[-1];
$Action = $Action.ToLower();

Write-Output ("[$(GetDate)] Selecionando assinatura: $($SubscriptionId)");
$SelectedSubscription = (Select-AzSubscription -SubscriptionId $SubscriptionId -WarningAction SilentlyContinue);
Write-Output ("[$(GetDate)] Assinatura `"$($SelectedSubscription.Subscription.Name)`" selecionada");

switch -regex ($ResourceId) {
    "microsoft.app/containerapps" {
        Write-Output ("[$(GetDate)] Recurso identificado como: Container App");
        StartStopContainerApp -Action $Action -ResourceGroupName $ResourceGroupName -ResourceName $ResourceName;
    }
    "microsoft.containerinstance/containergroups" {
        Write-Output ("[$(GetDate)] Recurso identificado como: Container Group");
         StartStopContainerGroup -Action $Action -ResourceGroupName $ResourceGroupName -ResourceName $ResourceName;
    }
    "microsoft.containerservice/managedclusters" {
        Write-Output ("[$(GetDate)] Recurso identificado como: Azure Kubernetes Service");
        StartStopAKS -Action $Action -ResourceGroupName $ResourceGroupName -ResourceName $ResourceName;
    }
    "microsoft.compute/virtualmachines" {
        Write-Output ("[$(GetDate)] Recurso identificado como: Virtual Machine");
        StartStopVM -Action $Action -ResourceGroupName $ResourceGroupName -ResourceName $ResourceName;
    }
    "microsoft.network/applicationgateways" {
        Write-Output ("[$(GetDate)] Recurso identificado como: Application Gateway");
        StartStopApplicationGateway -Action $Action -ResourceGroupName $ResourceGroupName -ResourceName $ResourceName;
    }
    "microsoft.analysisservices/servers" {
        Write-Output ("[$(GetDate)] Recurso identificado como: Analysis Services");
        StartStopAnalysisServices -Action $Action -ResourceGroupName $ResourceGroupName -ResourceName $ResourceName;
    }
    "microsoft.dbformysql/servers" {
        Write-Output ("[$(GetDate)] Recurso identificado como: MySQL Single Server");
        StartStopMySQLSingle -Action $Action -ResourceId $ResourceId;
    }
    "microsoft.dbformysql/flexibleservers" {
        Write-Output ("[$(GetDate)] Recurso identificado como: MySQL Flexible Server");
        StartStopMySQLFlexible -Action $Action -ResourceGroupName $ResourceGroupName -ResourceName $ResourceName;
    }
    "microsoft.dbformariadb/servers" {
        Write-Output ("[$(GetDate)] Recurso identificado como: MariaDB Server");
        StartStopMariaDBServer -Action $Action -ResourceId $ResourceId;
    }
    "microsoft.dbforpostgresql/flexibleservers" {
        Write-Output ("[$(GetDate)] Recurso identificado como: PostgreSQL Flexible Server");
        StartStopPostgreSQLFlexible -Action $Action -ResourceGroupName $ResourceGroupName -ResourceName $ResourceName;
    }
    default {
        Write-Output ("[$(GetDate)] Recurso não identificado ou não suportado");
    }
}