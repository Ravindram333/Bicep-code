param vnetname string = 'prodvnet'
param location string = resourceGroup().location
param addressSpace array = ['172.16.0.0/16']
// param sub01 string = 'devsubnet'
param subnets array = [
  {
    name: 'subnet1'
    addressPrefix: '172.16.0.0/24'
  }
  {
    name: 'subnet2'
    addressPrefix: '172.16.1.0/24'
  }
  {
    name: 'subnet3'
    addressPrefix: '172.16.2.0/24'
  }
]
param pulicip string = 'prodpip01'
param niccard string = 'prodnic01'
param nsg string = 'prodnsg01'
param virtualmachine string = 'prodvm01'
param vmSize string = 'Standard_DS1_v2'
param osDisk string = 'prodmyosdisk'
param adminUsername string = 'azureuser123'
@secure()
param adminPassword string


module prod 'dev.bicep' = {
  name: 'proddeployment'
  params: {
    vnetname: vnetname
    location: location
    addressSpace: addressSpace
    subnets: subnets
    pulicip: pulicip
    niccard: niccard
    nsg: nsg
    virtualmachine: virtualmachine
    vmSize: vmSize
    osDisk: osDisk
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}
