#! /usr/bin/env bash -e

ENV="dev"
TAG_TO_ARCHIVE="to-archive"
ARCHIVE_BUCKET="dev-archived-buckets-data"


function buckets_to_archive {
    aws resourcegroupstaggingapi get-resources --resource-type-filters=s3 --tag-filters Key=${TAG_TO_ARCHIVE},Values=true | jq -r .ResourceTagMappingList[].ResourceARN
}

function log() {
    msg=$1

    echo "[$(date -u)] - ${msg}"
}

function archive_bucket() {
    bucket_name=$1

    log "Archiving '${bucket_name}' S3 bucket..."

    log "Moving data from '${bucket_name}' to '${ARCHIVE_BUCKET}'..."
    aws s3 mv --recursive s3://${bucket_name} s3://${ARCHIVE_BUCKET}/${bucket_name}/

    log "Deleting '${bucket_name}' S3 bucket..."
    aws s3 rb s3://${bucket_name}

    log "'${bucket_name}' S3 bucket archived."
}

BUCKETS_ARNS="$(buckets_to_archive)"
for bucket_arn in $BUCKETS_ARNS; do
    # Ignore buckets in a different environment
    if [[ ! ${bucket_arn} == arn:aws:s3:::${ENV}-* ]];
    then
        continue
    fi

    bucket_name=`echo ${bucket_arn} | sed 's/arn:aws:s3::://'`

    log "About to archive '${bucket_name}' ..."
    echo
    sleep 3

    archive_bucket $bucket_name
done
