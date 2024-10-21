# Terraform Project for Azure Infrastructure
This Terraform project provisions Azure resources using Service Principal authentication. The Service Principal used must have Owner privileges on the subscription.

## Prerequisites
### Before using this project, ensure the following:

1. Azure Account: You must have access to an Azure subscription.

2. Azure CLI: Ensure you have the Azure CLI installed ([Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)).

3. Terraform: Install [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) (version >= 1.0).

4. Service Principal: A Service Principal with the Owner role assigned to the subscription (see below for instructions on creating a Service Principal).

**Example Commands**
**Initialize Terraform:**

1. Run this command to initialize the Terraform project and download the necessary provider plugins.
>Review the init Terraform will make without applying them:

        terraform init

2. Plan Terraform Execution:

>Review the changes Terraform will make without applying them:

        terraform plan

3. Apply the Terraform Configuration:**

>Apply the changes to create the resources:

        terraform apply

4. Destroy Resources:**

>To destroy all resources created by this configuration:

        terraform destroy

## Project Configuration

This project provisions the following Azure resources:

1. Virtual Network with defined subnets.

2. Virtual Machines mapped to specific subnets.

3. Azure Kubernetes Service (AKS) with node pools and private cluster enabled.

4. Azure PostgreSQL Flexible Server with defined configuration.

5. Azure Key Vault with optional private endpoint integration.

6. Azure Application Gateway for AKS ingress.

7. Azure OpenAI for machine learning deployments.

## Core Project Variables

>Define your project variables in a terraform.tfvars file:

```
//Azure Service Principal Configuration

subscription_id = "<your-subscription-id>"

client_secret   = "<your-client-secret>"

client_id       = "<your-client-id>"

tenant_id       = "<your-tenant-id>"

//Backend Configuration

backend_resource_group_name = "terraform-backend-state"

backend_storage_account_name = "tfstateaccount03"

backend_storage_container_name = "tfstate"

//Core Configuration

resource_group_name = "application-zone"

location            = "Southeast Asia"

location_ai         = "East US"

name_prefix         = "jm"

//Virtual Network Configuration

vnet_name           = "application-ai-zone"

vnet_address_space  = ["10.0.0.0/16"]

//Subnets Configuration

subnets = [
  { name = "jump_box", address_prefix = "10.0.1.0/24" },
  { name = "github_runner", address_prefix = "10.0.5.0/24" },
  { name = "private-endpoints", address_prefix = "10.0.0.32/27" },
  { name = "postgresql", address_prefix = "10.0.0.64/28" },
  { name = "aks", address_prefix = "10.0.3.0/24" },
  { name = "application_gateway", address_prefix = "10.0.2.0/26" }
]

//VM to Subnet Mapping

vm_subnet_mapping = {
  "jump-box-vm"      = "jump_box"
  "github-runner-vm" = "github_runner"
}

//Subnet Mapping Configuration

subnet_mapping = {
  "aks-stel-cluster" = "aks"
  "app-gateway-stel" = "application_gateway"
  "postgresql-stel-flexible" = "postgresql"
  "private-endpoints-stel" = "private-endpoints"
}

//VM Configuration

vm_size        = "Standard_D2ds_v5"

admin_username = "azureadmin"

admin_password = "<your-admin-password>"

//AKS Configuration

aks_name = "aks-cluster"

system_node_pool_vm_size = "Standard_D2ds_v5"

system_node_auto_scaling = true

system_node_min_count = 1

system_node_max_count = 2

user_node_pool_vm_size = "Standard_D2ds_v5"

user_node_auto_scaling = true

user_node_min_count = 1

user_node_max_count = 2

kubernetes_version = "1.29.8"

private_cluster_enabled = true

//OpenAI Configuration

openai_name = "openai"

models = [
    { name = "gpt4o-deployment", model = "gpt-4o", format = "OpenAI" },
    { name = "embedding-deployment", model = "text-embedding-ada-002", format = "OpenAI" }
]

//Define Postgres Configuration

postgres_server_name = "flexible-server"

postgres_admin_username = "postgresadmin"

postgres_admin_password = "Password1234!"

postgres_version = "13"

postgres_sku_name = "GP_Standard_D4s_v3"

postgres_storage_mb = 32768

backup_retention_days = 7

geo_redundant_backup = false

high_availability_mode = "Disabled"

//Define Key Vault Configuration

key_vault_name = "key-vault"

sku_name_key_vault = "standard"

enable_private_endpoint = true

//Define Application Gateway Configuration

app_gateway_name = "app-gateway"

//Custom host header for AKS

aks_host_header = "api.mydomain.com"  # Replace with your custom domain if needed for AKS routing

//SKU and Capacity for Application Gateway

sku_name  = "WAF_v2"

sku_tier  = "WAF_v2"

capacity  = 2  # Adjust capacity based on your needs

//WAF Mode (Detection or Prevention)

waf_mode = "Detection"

admin_group_object_ids = []

//Define Log Analytics Configuration

workspace_name = "shared-log-analytics"

sku_log_analytics = "PerGB2018"

retention_in_days = 30

//Define Other Configuration

# Tags
tags = {
  environment = "dev"
  project     = "application-ai_zone_setup"
}

```

### 1. Authenticate with Azure CLI

Before creating the Service Principal, authenticate using Azure CLI by running the following command:


    az login


>This will open a browser window for you to sign in with your Azure account credentials. Once signed in, Azure CLI will authenticate you for any subsequent commands.

If you have access to multiple Azure subscriptions, you can set the active subscription with:

    
    az account set --subscription "<subscription-id>"
    

### 2. Creating a Service Principal

You can create an Azure Service Principal and assign it the Owner role using the Azure CLI:

    az ad sp create-for-rbac --name "<service-principal-name>" --role="Owner" --scopes="/subscriptions/<your-subscription-id>"

This will output values for appId, password, and tenant, which are required for authentication.

    Example output:
    {
    "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "displayName": "<service-principal-name>",
    "password": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    }

**Authentication for Terraform**

Configuring Azure Service Principal Authentication

In order to authenticate with Azure, you need to set the following environment variables with the Service Principal credentials:

>Alternatively, you can add these details directly to a Terraform provider file (not recommended for production):

    backend "azurerm" {
        resource_group_name   = "xxxxx"
        storage_account_name  = "xxxxx"
        container_name        = "xxxxx"
        key                   = "xxxxx.tfstate" 
    }

**Variables**

>You can define your variables in terraform.tfvars or pass them directly at runtime. Here is an example of a terraform.tfvars file:

    client_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    client_secret   = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

 ### 3. Assigning the Owner Role
If not already done, you can assign the Owner role to the Service Principal with this command:

    az role assignment create --assignee <appId> --role "Owner" --scope /subscriptions/<your-subscription-id>

    
### 4. Setting Up Backend State in Azure Storage
Terraform uses a backend to store state files. In this project, we configure an Azure Storage Account as the backend for state management.

>This ensures that the Terraform state is securely stored and can be shared across team members.
        
**- Step 1: Running Project to Create Backend State**

    terraform init

    terraform plan

    terraform apply

> First, you need to create an Azure Storage Account to store the state file. Run the following Terraform code without backend configuration to create the necessary resources:

Run terraform init and terraform apply to create the storage account and container.

> This configuration tells Terraform to use the Azure Storage Account for state management. The key parameter ("terraform.tfstate") specifies the name of the state file to store.

Step 3: Reconfigure Terraform to Use the Backend
            
>Now that the backend is defined, run the following command to reconfigure Terraform to store state remotely:


    terraform init -reconfigure
          

>This command will migrate the local state file to the configured backend in Azure Storage. Terraform will now keep the state in the Azure Storage Account instead of locally.
     

**Checking Service Principal Permissions**

>Ensure that the Service Principal has Owner permissions in the subscription. You can verify its role with:

```
az role assignment list --assignee <appId>
```

>For more information about Service Principal authentication in Azure, refer to the [Terraform documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) and [Azure CLI documentation](https://learn.microsoft.com/en-us/cli/azure/azure-cli-sp-tutorial-1?tabs=bash).






