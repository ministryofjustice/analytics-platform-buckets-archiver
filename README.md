[![Docker Repository on Quay](https://quay.io/repository/mojanalytics/buckets-archiver/status "Docker Repository on Quay")](https://quay.io/repository/mojanalytics/buckets-archiver)


# buckets-archiver

Archives S3 buckets tagged as `to-archive`.

For each of the S3 buckets tagged as `to-archive` it moves its content to
`${ARCHIVE_BUCKET}/${BUCKET_NAME}/` and then deletes the S3 bucket.


### Example
If `${ARCHIVE_BUCKET}` is `dev-archived-buckets-data`, when the `dev-test-bucket-1`
S3 bucket is archived its data will be moved to the `dev-archived-buckets-data`
bucket under `/dev-test-bucket-1/*`.


## Usage

Run `$ ENV=xxx ARCHIVE_BUCKET=xxx buckets-archiver archive` to start the archiving process.

- `ENV` is the environment in which this is running, e.g. `dev` and it's used
  to avoid archiving of buckets in other environments
- `ARCHIVE_BUCKET` is the S3 bucket where the data of the archived S3 bucket
  will be moved, e.g. `dev-archived-buckets-data`


The script will also show an help message if one of these environment
variables is missing or if run by `$ buckets-archiver help`.


## AWS Credentials

The script awscli to interact with AWS. It will need to be configured in
the usual way as explained in the AWS official documentation:

https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html


## Permissions

The following table show the IAM permissions required by the `buckets-archived`
in order to move the data and delete the bucket.

| Permission         | Resource                                      | Used by                                          |
| ------------------ | --------------------------------------------- | ------------------------------------------------ |
| `tag:GetResources` | `*`                                           | `aws resourcegroupstaggingapi get-resources`     |
| `s3:ListBucket`    | `arn:aws:s3:::${ENV}-*`                       | `aws s3 mv` (to get objects to mv)               |
| `s3:GetObject`     | `arn:aws:s3:::${ENV}-*/*`                     | `aws s3 mv` (to read objects from source)        |
| `s3:DeleteObject`  | `arn:aws:s3:::${ENV}-*/*`                     | `aws s3 mv` (to delete objects from source)      |
| `s3:PutObject`     | `arn:aws:s3:::${ENV}-archived-buckets-data/*` | `aws s3 mv` (to write objects to destination)    |
| `s3:DeleteBucket`  | `arn:aws:s3:::${ENV}-*/*`                     | `aws s3 rb` (to delete the bucket once archived) |
