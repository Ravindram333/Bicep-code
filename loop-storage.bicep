// param location string = resourceGroup().location
// param storageAccountPrefix string = 'mystorage'
// param storageAccountcount int = 2

// resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = [for i in range(0, storageAccountcount):{
//   name: '${storageAccountPrefix}${i}${uniqueString(resourceGroup().id)}'
//   location: location
//   sku: {
//     name: 'Standard_LRS'
//   }
//   kind: 'StorageV2'
// }]


param location array = [
  'East US'
  'West US'
  'Central US'
]
param storageAccountPrefix string = 'mystorage'
// param storageAccountcount int = 2

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = [for (location, i) in location:{
  name: '${storageAccountPrefix}${i}${uniqueString(location)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}]
