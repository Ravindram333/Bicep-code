param virtualnetworkcount int = 3 
param vnetPrefix string = 'myvnet'
param location string = resourceGroup().location
param addresPrefixes array = [
  '10.0.0.0/16'
  '10.1.0.0/16'
  '10.2.0.0/16'
]
param subnetPrefix string = 'mysubnet'
param addressprefix array = [
  '10.0.0.0/24'
  '10.1.0.0/24'
  '10.2.0.0/24'
  
]

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = [for i in range(0, virtualnetworkcount):{
  name: '${vnetPrefix}${i}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addresPrefixes[i]
      ]
    }
    subnets: [
      {
        name: '${subnetPrefix}${i}'
        properties: {
          addressPrefix: addressprefix[i]
        }
      }
    ]
  }
}]
