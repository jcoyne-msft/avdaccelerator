param AutoMitigate bool
param ActionGroupId string
param Enabled bool
param Environment string
param HostPoolName string
param MetricAlerts object
param Tags object
param Location string
param VMResourceGroupId string

module metricAlerts_VirtualMachines '../../../../../carml/1.3.0/Microsoft.Insights/metricAlerts/deploy.bicep' = [for i in range(0, length(MetricAlerts.virtualMachines)): {
  name: 'c_${replace(MetricAlerts.virtualMachines[i].name, 'xHostPoolNamex', HostPoolName)}-${Environment}'
  params: {
    enableDefaultTelemetry: false
    name: '${replace(MetricAlerts.virtualMachines[i].name, 'xHostPoolNamex', HostPoolName)}-${Environment}'
    criterias: MetricAlerts.virtualMachines[i].criteria.allOf
    location: 'global'
    alertDescription: MetricAlerts.virtualMachines[i].description
    severity: MetricAlerts.virtualMachines[i].severity
    enabled: Enabled
    scopes: [VMResourceGroupId]
    evaluationFrequency: MetricAlerts.virtualMachines[i].evaluationFrequency
    windowSize: MetricAlerts.virtualMachines[i].windowSize
    autoMitigate: AutoMitigate
    tags: contains(Tags, 'Microsoft.Insights/metricAlerts') ? Tags['Microsoft.Insights/metricAlerts'] : {}
    targetResourceType: MetricAlerts.virtualMachines[i].targetResourceType
    targetResourceRegion: Location
    actions: [
      {
        actionGroupId: ActionGroupId
        webHookProperties: {}
      }
    ]

  }
}]
