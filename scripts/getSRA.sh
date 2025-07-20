#!/usr/bin/env bash
# getSRA.sh

while read SRA; do
    fasterq-dump --split-3 $SRA -O raw_data/
done < samples.txt



# S3 bucket PATH
#S3_BUCKET="s3://your-bucket/raw_data/"

# upload raw_data folders to S3 bucket
#aws s3 cp raw_data/ $S3_BUCKET --recursive

