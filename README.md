## Scripts para ligar e desligar recursos no Azure

O objetivo desses scripts é facilitar o processo de liga/desliga dos recursos no Azure e assim trazer uma economia financeira para o ambiente

Todos os scripts utilizam a [API REST do Azure](https://learn.microsoft.com/en-us/rest/api/azure/) e para a versão "mais completa" são utilizados os cmdlets do módulo [Az PowerShell](https://learn.microsoft.com/en-us/powershell/azure/what-is-azure-powershell?view=azps-11.2.0)

Para as versões "mais simples" do script, as versões de APIs abaixo podem ser utilizadas:
- Container Apps (start/stop): 2023-05-01
- Container Groups (start/stop): 2023-05-01
- Azure Kubernetes Service (start/stop): 2023-11-01
- Virtual Machines (start/deallocate): 2023-09-01
- Application Gateways (start/stop): 2023-09-01
- Analysis Services (resume/suspend): 2017-08-01
- MySQL Single Server (start/stop): 2020-01-01
- MySQL Flexible Server (start/stop): 2023-06-30
- MariaDB Server (start/stop): 2020-01-01
- PostgreSQL Flexible Server (start/stop): 2022-12-01

No intuito de conceder o mínimo de permissões, sugiro a criação de uma [*custom role*](https://github.com/include-caio/azure-start-stop-custom-role) apenas com as ações necessárias

## Utilização de maneira automatizada

Para automatizar o processo, é necessário [criar uma Automation Account](https://learn.microsoft.com/en-us/azure/automation/automation-create-standalone-account)

<img src="https://i.imgur.com/7hwERM5.png" width="650">

No submenu ["Identity"](https://learn.microsoft.com/en-us/azure/automation/enable-managed-identity-for-automation) da Automation Account, a role com as permissões necessárias para o liga e desliga dos recursos deve ser atribuída no escopo em que os recursos existem

<img src="https://i.imgur.com/lWMCq3e.png" width="650">
<img src="https://i.imgur.com/TSpls8g.png" width="650">

No submenu "Runbooks", deve ser criado e publicado o runbook com a versão escolhida do script

<img src="https://i.imgur.com/bYtQHUO.png" width="650">
<img src="https://i.imgur.com/GWm4XfP.png" width="650">
<img src="https://i.imgur.com/ZzaoBkU.png" width="650">
<img src="https://i.imgur.com/ZmGsLGU.png" width="650">

Para agendar o liga/desliga, é necessário a criação de [schedules](https://learn.microsoft.com/en-us/azure/automation/shared-resources/schedules) com os parâmetros de cada recurso e a frequência/recorrência desejada

<img src="https://i.imgur.com/MJxi4du.png" width="650">
