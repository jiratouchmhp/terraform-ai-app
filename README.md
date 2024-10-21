# Terraform Project for Azure Infrastructure
This Terraform project provisions Azure resources using Service Principal authentication. The Service Principal used must have Owner privileges on the subscription.

## Prerequisites
### Before using this project, ensure the following:

***1. Azure Account: You must have access to an Azure subscription.***

***2. Azure CLI: Ensure you have the Azure CLI installed ([Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)).***

***3. Terraform: Install [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) (version >= 1.0).***
***4. Service Principal: A Service Principal with the Owner role assigned to the subscription (see below for instructions on creating a Service Principal).***

### 1. Authenticate with Azure CLI
    - Before creating the Service Principal, authenticate using Azure CLI by running the following command:

    ```
    az login
    ```

    This will open a browser window for you to sign in with your Azure account credentials. Once signed in, Azure CLI will authenticate you for any subsequent commands.

    - If you have access to multiple Azure subscriptions, you can set the active subscription with:

    ```
    az account set --subscription "<subscription-id>"
    ```

### 2. Creating a Service Principal
    - You can create an Azure Service Principal and assign it the Owner role using the Azure CLI:

    az ad sp create-for-rbac --name "<service-principal-name>" --role="Owner" --scopes="/subscriptions/<your-subscription-id>"

    This will output values for appId, password, and tenant, which are required for authentication.

    ```
    Example output:
    {
    "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "displayName": "<service-principal-name>",
    "password": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    }
    ```

 ### 3. Assigning the Owner Role
    If not already done, you can assign the Owner role to the Service Principal with this command:

    ```
    az role assignment create --assignee <appId> --role "Owner" --scope /subscriptions/<your-subscription-id>
    ```

    
### 4. Setting Up Backend State in Azure Storage
**Terraform uses a backend to store state files. In this project, we configure an Azure Storage Account as the backend for state management.** 

**This ensures that the Terraform state is securely stored and can be shared across team members.
        
**- Step 1: Running Project to Create Backend State**
        ```
        terraform init
        ```

        ```
        terraform plan
        ```

        ```
        terraform apply
        ```
**- First, you need to create an Azure Storage Account to store the state file. Run the following Terraform code without backend configuration to create the necessary resources:**



**Run terraform init and terraform apply to create the storage account and container.**

- This configuration tells Terraform to use the Azure Storage Account for state management. The key parameter ("terraform.tfstate") specifies the name of the state file to store.

Step 3: Reconfigure Terraform to Use the Backend
            
>Now that the backend is defined, run the following command to reconfigure Terraform to store state remotely:


            terraform init -reconfigure
          

**- This command will migrate the local state file to the configured backend in Azure Storage. Terraform will now keep the state in the Azure Storage Account instead of locally.**

### Authentication for Terraform

Configuring Azure Service Principal Authentication

>In order to authenticate with Azure, you need to set the following environment variables with the Service Principal credentials:

>Alternatively, you can add these details directly to a Terraform provider file (not recommended for production):

    backend "azurerm" {
        resource_group_name   = "xxxxx"
        storage_account_name  = "xxxxx"
        container_name        = "xxxxx"
        key                   = "xxxxx.tfstate"  // State file for application ai zone
    }

**Variables**

>You can define your variables in terraform.tfvars or pass them directly at runtime. Here is an example of a terraform.tfvars file:

    client_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    client_secret   = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"


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
     

**Checking Service Principal Permissions**

>Ensure that the Service Principal has Owner permissions in the subscription. You can verify its role with:

```
az role assignment list --assignee <appId>
```

>For more information about Service Principal authentication in Azure, refer to the [Terraform documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) and [Azure CLI documentation](https://learn.microsoft.com/en-us/cli/azure/azure-cli-sp-tutorial-1?tabs=bash).






