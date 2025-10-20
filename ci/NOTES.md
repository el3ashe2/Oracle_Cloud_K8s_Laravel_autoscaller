CI and accessing secrets:
- Recommended: use **OCI DevOps** pipelines because they can be given IAM policies and read Vault secrets directly, avoiding placing API keys in GitHub Secrets.
- If you use GitHub Actions, you can store an OCI service user's API key in GitHub Secrets. For better security, rotate that key and restrict its permissions (least privilege).
- Alternatively, configure GitHub Actions to call an intermediate service that can fetch secrets from OCI Vault (but that service needs authentication).

