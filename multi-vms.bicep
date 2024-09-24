param virtualnetworkcount int = 2
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
param publicipcount int = 2
param publicipPrefix string = 'mypip'
param niccardcount int = 2
param niccardPrefix string = 'mynic'
param nsgcount int = 2
param nsgPrefix string = 'mynsg'
param vmcount int = 2
param vmPrefix string = 'myvm'
param vmsize string = 'Standard_DS1_v2'
param adminusername string = 'adminuser'
param adminpassword string = 'Ravindra@2503'

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

resource pip 'Microsoft.Network/publicIPAddresses@2024-01-01' =[for i in range(0, publicipcount):{
  name: '${publicipPrefix}${i}'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}]

resource niccard 'Microsoft.Network/networkInterfaces@2024-01-01' = [for i in range(0, niccardcount):{
  name: '${niccardPrefix}${i}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: vnet[i].properties.subnets[0].id
         }
         privateIPAllocationMethod: 'Dynamic'
         publicIPAddress: {
          id: pip[i].id
         }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg[i].id
    }
  }
}]

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-01-01' =[for i in range(0, nsgcount):{
  name: '${nsgPrefix}${i}'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDP'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'Allowhttp'
        properties: {
          priority: 110
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'Allowhttps'
        properties: {
          priority: 120
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}]

resource vms 'Microsoft.Compute/virtualMachines@2024-07-01' =[for i in range(0, vmcount):{
  name: '${vmPrefix}${i}'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmsize
    }
    osProfile: {
      computerName: '${vmPrefix}${i}'
      adminUsername: adminusername
      adminPassword: adminpassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: niccard[i].id
        }
      ]
    }
  }
}]
