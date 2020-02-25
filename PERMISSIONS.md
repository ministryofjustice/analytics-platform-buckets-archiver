| Permission         | Resource                                      | Used by                                          |
| ------------------ | --------------------------------------------- | ------------------------------------------------ |
| `tag:GetResources` | `*`                                           | `aws resourcegroupstaggingapi get-resources`     |
| `s3:ListBucket`    | `arn:aws:s3:::${ENV}-*`                       | `aws s3 mv` (to get objects to mv)               |
| `s3:GetObject`     | `arn:aws:s3:::${ENV}-*/*`                     | `aws s3 mv` (to read objects from source)        |
| `s3:DeleteObject`  | `arn:aws:s3:::${ENV}-*/*`                     | `aws s3 mv` (to delete objects from source)      |
| `s3:PutObject`     | `arn:aws:s3:::${ENV}-archived-buckets-data/*` | `aws s3 mv` (to write objects to destination)    |
| `s3:DeleteBucket`  | `arn:aws:s3:::${ENV}-*/*`                     | `aws s3 rb` (to delete the bucket once archived) |
