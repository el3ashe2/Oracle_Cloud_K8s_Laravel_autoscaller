#!/bin/sh
set -e
FNAME="mysql-backup-$(date +%Y%m%dT%H%M%SZ).sql.gz"
mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" --all-databases   --single-transaction --quick --set-gtid-purged=OFF | gzip > /tmp/$FNAME
echo "Uploading $FNAME to OCI Object Storage..."
oci os object put --bucket-name "$BUCKET_NAME" --file "/tmp/$FNAME" --name "$FNAME"
echo "Backup completed successfully."
