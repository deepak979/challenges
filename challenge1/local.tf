#define local values
locals{
    subscription_id = "Subscription id where resource needs to be created"
    tenant_id       = "tenant id of organization"
    rg_name         = "name of resourcegroup"
    location        = "location where resource needs to be deployed"
    tags            ={
        environment = "prod"
        technical_owner = "name of technical owner"
        business_owner  = "name of business owner"
    }
}
