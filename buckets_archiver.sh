#! /usr/bin/env bash -e

TAG_TO_ARCHIVE="to_archive"
ENV="dev"


function buckets_to_archive {
    aws resourcegroupstaggingapi get-resources --resource-type-filters=s3 --tag-filters Key=${TAG_TO_ARCHIVE},Values=true | jq -r .ResourceTagMappingList[].ResourceARN
}

function archive_bucket() {
    bucket_name=$1

    echo "Archiving ${bucket_name}..."
}

BUCKETS_ARNS="$(buckets_to_archive)"
for bucket_arn in $BUCKETS_ARNS; do
    # Ignore buckets in a different environment
    if [[ ! ${bucket_arn} == arn:aws:s3:::${ENV}-* ]];
    then
        continue
    fi

    echo "TODO: Archive ${bucket_arn} as its name starts with '${ENV}-'"
    # archive_bucket $bucket_arn
done
