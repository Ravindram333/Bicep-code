param vnetName01 string = 'devnet01'
param location string = resourceGroup().location
param AddressSpaces01 array = ['10.0.0.0/16']
param subnetName01 string = 'devsubnet01'
param Addressprefix01 string = '10.0.0.0/24'
param vnetName02 string = 'testvnet01'
param AddressSpaces02 array = ['192.168.0.0/16']
param subnetName02 string = 'devsubnet01'
param Addressprefix02 string = '192.168.0.0/24'

resource vnet01 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vnetName01
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: AddressSpaces01
    }
    subnets: [
      {
        name: subnetName01
        properties: {
          addressPrefix: Addressprefix01
        }
      }
    ]
  }
}

resource vnet02 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vnetName02
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: AddressSpaces02
    }
    subnets: [
      {
        name: subnetName02
        properties: {
          addressPrefix: Addressprefix02
        }
      }
    ]
  }
}

resource vnet01ToVnet02peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  name: 'vnet01ToVnet02'
  parent: vnet01
  properties: {
    remoteVirtualNetwork: {
      id: vnet02.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource vnet02Tovnet01peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  name: 'vnet02ToVnet01'
  parent: vnet02
  properties: {
    remoteVirtualNetwork: {
      id: vnet01.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}
