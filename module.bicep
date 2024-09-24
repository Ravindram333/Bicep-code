
param vnetname string = 'testvnet'
param location string = resourceGroup().location
param addressSpace array = ['192.168.0.0/16']
// param sub01 string = 'devsubnet'
param subnets array = [
  {
    name: 'subnet1'
    addressPrefix: '192.168.0.0/24'
  }
  {
    name: 'subnet2'
    addressPrefix: '192.168.1.0/24'
  }
  {
    name: 'subnet3'
    addressPrefix: '192.168.2.0/24'
  }
]
param pulicip string = 'testpip01'
param niccard string = 'testnic01'
param nsg string = 'testnsg01'
param virtualmachine string = 'testvm01'
param vmSize string = 'Standard_DS1_v2'
param osDisk string = 'myosdisk'
param adminUsername string = 'azureuser123'
@secure()
param adminPassword string

module test 'dev.bicep' = {
  name: 'testdeployment'
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
