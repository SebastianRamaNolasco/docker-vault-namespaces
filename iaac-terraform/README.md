# Vault Namespace Demo with Terraform

This project demonstrates setting up HashiCorp Vault with namespaces, secrets engines, identity groups, userpass authentication, and ACL policies using Terraform.

## Prerequisites

1.  **HashiCorp Vault Server**: Running and accessible. The `docker-vault-stack` from `nhsy-hcp/docker-vault-stack` is recommended for a quick dev setup.
    Ensure Vault is unsealed and you have the root token.
    Default address: `http://127.0.0.1:8200`
    Default dev root token for `docker-vault-stack`: `root`
2.  **Terraform**: Installed (version supporting the Vault provider features, e.g., v1.x).

## Configuration

1.  **Vault Address and Token**:
    The Terraform configuration uses variables for Vault's address and token.
    - `vault_addr`: Defaults to `http://127.0.0.1:8200`.
    - `vault_token`: Defaults to `root`. **It's crucial to set this securely for non-dev environments.**

    You can set these using environment variables:
    ```bash
    export TF_VAR_vault_addr="http://your-vault-address:8200"
    export TF_VAR_vault_token="your-root-token"
    ```
    Or create a `terraform.tfvars` file (ensure it's in `.gitignore` if containing sensitive info):
    ```terraform
    // terraform.tfvars
    vault_addr  = "http://127.0.0.1:8200"
    vault_token = "root" // For dev only
    ```

## Deployment

1.  **Initialize Terraform**:
    Navigate to the directory containing these Terraform files.
    ```bash
    terraform init
    ```

2.  **Plan the Deployment**:
    Review the changes Terraform will make.
    ```bash
    terraform plan
    ```

3.  **Apply the Configuration**:
    ```bash
    terraform apply
    ```
    Confirm by typing `yes` when prompted.

## Verification Steps

After applying the Terraform configuration:

1.  **Login as Root (or Admin with sufficient perms) to Vault UI/CLI.**
    ```bash
    export VAULT_ADDR="http://127.0.0.1:8200"
    export VAULT_TOKEN="root" # Or your TF_VAR_vault_token
    ```

2.  **Check Namespaces**:
    ```bash
    vault namespace list
    # Expected: admin/
    vault namespace list -namespace=admin
    # Expected: bu-0001/, bu-0002/, bu-0003/, shared/
    ```

3.  **Check KV Mounts & Secrets**:
    ```bash
    # In admin/bu-0001
    vault kv list -namespace=admin/bu-0001 secrets
    # Expected: application1
    vault kv get -namespace=admin/bu-0001 secrets/application1
    # Expected: username: wibble, password: strongpassword

    # In admin/shared
    vault kv list -namespace=admin/shared secrets
    # Expected: jenkins
    vault kv get -namespace=admin/shared secrets/jenkins
    # Expected: username: wibble, password: strongpassword
    ```

4.  **Check Identity Groups**:
    ```bash
    # Central groups in 'admin' namespace
    vault list -namespace=admin identity/group/name
    # Expected: app1-reader, app2-reader, app3-reader

    # Aliased group in 'admin/bu-0001'
    vault read -namespace=admin/bu-0001 identity/group/name/app1-reader
    # Check its canonical ID and metadata
    ```

5.  **Check Userpass Auth & Users**:
    ```bash
    vault auth list -namespace=admin
    # Expected: userpass/ (among others)

    vault list -namespace=admin auth/userpass/users
    # Expected: alice, bob, jane
    ```

6.  **Test User Login and Policy**:
    Login as `alice`:
    ```bash
    # Unset root token if set
    unset VAULT_TOKEN

    vault login -method=userpass -namespace=admin username=alice password=AlicePassword123!
    # You should get a client token.
    ```
    Attempt to read secrets in `admin/bu-0001`:
    ```bash
    # As Alice (who is in app1-reader group)
    # Her token has policies applied from the admin/bu-0001/app1-reader group (via alias)
    # The kv-reader policy in admin/bu-0001 should allow this:
    vault kv get -namespace=admin/bu-0001 secrets/application1
    # Expected: SUCCESS, data shown.

    # The policy also allows access to 'secrets/data/team1/*' because 'app1-reader' group has 'team: team1' metadata.
    # To test this, you'd need to put a secret there:
    # (As root/admin) vault kv put -namespace=admin/bu-0001 secrets/team1/test value=foo
    # (As alice) vault kv get -namespace=admin/bu-0001 secrets/team1/test
    # Expected: SUCCESS

    # Try to access a secret in another BU (should fail if not explicitly allowed)
    vault kv get -namespace=admin/bu-0002 secrets/someothersecret # (Assuming someothersecret exists)
    # Expected: Permission denied
    ```

## Cleanup

To remove all resources created by this Terraform configuration:
```bash
terraform destroy