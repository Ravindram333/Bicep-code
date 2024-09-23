

param vnetname string = 'devvnet'
param location string = resourceGroup().location
param addressSpace array = ['10.0.0.0/16']
// param sub01 string = 'devsubnet'
param subnets array = [
  {
    name: 'subnet1'
    addressPrefix: '10.0.0.0/24'
  }
  {
    name: 'subnet2'
    addressPrefix: '10.0.1.0/24'
  }
  {
    name: 'subnet3'
    addressPrefix: '10.0.2.0/24'
  }
]
param pulicip string = 'devpip01'
param niccard string = 'devnic01'
param nsg string = 'devnsg01'
param virtualmachine string = 'devvm01'
param vmSize string = 'Standard_DS1_v2'
param osDisk string = 'myosdisk'
param adminUsername string = 'azureuser123'
@secure()
param adminPassword string
param datadisk1 string = 'devdatadisk1'
param dataDisk1Sku string = 'Standard_LRS'
param datadisk1gb int = 1024
param datadisk2 string = 'devdatadisk2'
param dataDisk2Sku string = 'Standard_LRS'
param datadisk2gb int = 512



resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01'= {
  name: vnetname
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressSpace
    }
    subnets: [
      for subnet in subnets: {
        name:subnet.name
        properties: {
          addressPrefix: subnet.addressPrefix
        }
      }
    ]
  }
}

resource publicip 'Microsoft.Network/publicIPAddresses@2024-01-01'= {
  name: pulicip
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
   publicIPAllocationMethod: 'Dynamic'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2024-01-01' = {
  name: niccard
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: vnet.properties.subnets[0].id
          }
          publicIPAddress: {
            id: publicip.id
          }
          
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgname.id
    }
  }
}

resource nsgname 'Microsoft.Network/networkSecurityGroups@2024-01-01' = {
  name: nsg
  location: location
  properties: {
    securityRules: [
      {
        name: 'allowRDP'
        properties: {
          priority: 100
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
          description: 'Allow RDP'
        }
      }
      {
        name: 'allowhttp'
        properties: {
          priority: 110
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '80'
          description: 'Allow http'
        }
      }
      {
        name: 'allowhttps'
        properties: {
          priority: 120
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
          description: 'Allow https'
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: virtualmachine
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      dataDisks: [
        {
          lun: 1
          name: datadisk1
          createOption: 'Attach'
          diskSizeGB: datadisk1gb
          managedDisk: {
            id: datadisk01.id
          }
        }
        {
          lun: 2
          name: datadisk2
          createOption: 'Attach'
          diskSizeGB: datadisk2gb
          managedDisk: {
            id: datadisk02.id
          }
        }
      ]
      osDisk: {
        name: osDisk
        caching: 'ReadWrite'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    osProfile: {
      computerName: virtualmachine
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

resource datadisk01 'Microsoft.Compute/disks@2023-10-02' = {
  name: datadisk1
  location: location
  sku: {
    name: dataDisk1Sku
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: datadisk1gb
  }
}


resource datadisk02 'Microsoft.Compute/disks@2023-10-02' = {
  name: datadisk2
  location: location
  sku: {
    name: dataDisk2Sku
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: datadisk2gb
  }
}
