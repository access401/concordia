#!/bin/bash

export ENV_NAME=prod

# aws cloudformation create-stack --region us-east-1 --stack-name $ENV_NAME-bastionhosts --template-url https://s3.amazonaws.com/crowd-deployment/infrastructure/bastion-hosts.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=$ENV_NAME ParameterKey=KeyPairName,ParameterValue=rstorey@loc.gov --disable-rollback
# aws cloudformation delete-stack --region us-east-1 --stack-name $ENV_NAME-bastionhosts

export TODAY=$(date +%Y%m%d)
export POSTGRESQL_PW="$(aws secretsmanager get-secret-value --secret-id crowd/${ENV_NAME}/DB/MasterUserPassword | python3 -c 'import json,sys;Secret=json.load(sys.stdin);SecretString=json.loads(Secret["SecretString"]);print(SecretString["password"])')"
export POSTGRESQL_HOST=${POSTGRESQL_HOST:-localhost}
export DUMP_FILE=concordia.dmp

echo "${POSTGRESQL_HOST}:5432:*:concordia:${POSTGRESQL_PW}" > ~/.pgpass
chmod 600 ~/.pgpass

pg_dump -Fc --clean --create --no-owner --no-acl -U concordia -h "${POSTGRESQL_HOST}" concordia -f "${DUMP_FILE}"
aws s3 cp "${DUMP_FILE}" "s3://crowd-deployment/database-dumps/concordia.${TODAY}.dmp"
aws s3 cp "${DUMP_FILE}" s3://crowd-deployment/database-dumps/concordia.latest.dmp
