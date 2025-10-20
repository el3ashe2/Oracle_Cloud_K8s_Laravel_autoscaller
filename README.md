# OCI Laravel - Secrets + Backups (example)
This archive contains example Terraform snippets, Kubernetes manifests and a backup CronJob to:
- store application and DB secrets in **OCI Vault** (via Terraform),
- sync Vault secrets into Kubernetes using **Secrets Store CSI driver (OCI provider)** or **External Secrets Operator** (examples provided),
- perform automated logical backups (mysqldump) to **OCI Object Storage** via a Kubernetes CronJob.

**What I included**
- `terraform/` – provider + example `vault.tf` that creates a KMS vault, key and a secret (DB password).
- `k8s/` – Secret Store CSI / ExternalSecret examples and a `backup-cronjob.yaml` that shows how to dump MySQL and upload to Object Storage.
- `ci/` – notes for CI and safe patterns.
- `scripts/backup-upload.sh` – helper used by the CronJob.

Read the full instructions in this README for step-by-step usage and links to Oracle docs.

**Important**
- These are *example* files you must adapt (OCIDs, names, zones, nodepool OCIDs).
- I (the assistant) cannot push directly to your GitHub repo. You can download the zip and push/upload it yourself.
- If you want, I can produce a PR patch file you can apply locally.

