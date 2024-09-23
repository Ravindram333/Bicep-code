param vnetName string = 'devvnet'
param location string = resourceGroup().location
param addressprefixs array = ['10.0.0.0/16']
param subnetName string = 'devsubnet'
param addressprefix string = '10.0.1.0/24'

param storageName string = 'devstragetest875'
param storagesku string = 'Standard_LRS'



resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vnetName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: addressprefixs
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: addressprefix
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [
                location
              ]
            }
          ]
        }
      }
    ]
  }
}


resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageName
  location: location
  sku: {
    name: storagesku
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, subnetName) //'${vnet.name}/subnets/subnetName' 
        }
      ]
      ipRules: []
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
      }
      keySource: 'Microsoft.Storage'
    }
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
  }
}
