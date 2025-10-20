Kubernetes integration - two recommended approaches

1) Secrets Store CSI Driver + OCI provider
   - Deploy the Secrets Store CSI driver to your cluster.
   - Install the Oracle provider (oracle/oci-secrets-store-csi-driver-provider).
   - Create a SecretProviderClass which points to the OCI Vault secret OCID.
   - Mount the secrets in your pod as files; your app reads files.

   Reference: OCI docs — Managing Secrets for Kubernetes Clusters.

2) External Secrets Operator (ESO) with Oracle Vault provider
   - Install ESO in the cluster.
   - Create a SecretStore that configures the 'oracle-vault' provider with OCI credentials (or use a service principal).
   - Create ExternalSecret resources to sync Vault secrets into Kubernetes Secrets.

   Reference: External Secrets Operator - Oracle vault provider.

Examples below include both patterns.

