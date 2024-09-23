targetScope = 'subscription'

resource rg01 'Microsoft.Resources/resourceGroups@2024-03-01'= {
  name: 'devrg01'
  location: 'eastus'
}
