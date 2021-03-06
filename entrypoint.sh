#!/bin/sh 

set -e

# if [ -z "$S3_BUCKET" ]; then
#   echo "S3_BUCKET is not set. Quitting."
#   exit 1
# fi
# if [ -z "$AWS_ACCESS_KEY_ID" ]; then
#   echo "AWS_ACCESS_KEY_ID is not set. Quitting."
#   exit 1
# fi
# if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
#   echo "AWS_SECRET_ACCESS_KEY is not set. Quitting."
#   exit 1
# fi

# if [-z "$FILE"]; then
#   echo "FILE is not set. Quitting"
#   exit 1
# fi

# if [ -z "$AWS_REGION"]; then
#   AWS_REGION="us-east-1"
# fi

mkdir -p ~/.aws

touch ~/.aws/credentials

echo "[default]
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" > ~/.aws/credentials

aws s3 cp ${FILE} s3://${S3_BUCKET}/${S3_KEY} --region ${AWS_REGION} --recursive $*

cd ${FILE}

for f in `find . -iname '*.gz'`; do
  mv $f ${f%.gz} && \
  dir=$(echo ${f%.gz} | cut -c2-) && \
  aws s3 cp ${f%.gz} s3://${S3_BUCKET}/${S3_KEY}${dir} --region ${AWS_REGION} --content-encoding='gzip' $*
done

for f in `find . -iname '*.br'`; do
  mv $f ${f%.br} && \
  dir=$(echo ${f%.br} | cut -c2-) && \
  aws s3 cp ${f%.br} s3://${S3_BUCKET}/${S3_KEY}${dir} --region ${AWS_REGION} --content-encoding='br' $*
done

rm -rf ~/.aws

