#!/usr/bin/env bash

JQ_COMMAND="jq -Mr"
NAME=`cat ./mapping.json | $JQ_COMMAND .mapping.$1.name`
KEY=`cat ./mapping.json | $JQ_COMMAND .mapping.$1.key`
VALUES_PATH=`cat ./mapping.json | $JQ_COMMAND .mapping.$1.values_path`
SECRET_NAME=`cat ./mapping.json | $JQ_COMMAND .mapping.$1.secret_name`
UNSEALED_SECRET_PATH=`cat ./mapping.json | $JQ_COMMAND .mapping.$1.unsealed_secret_path`
SEALED_SECRET_PATH=`cat ./mapping.json | $JQ_COMMAND .mapping.$1.sealed_secret_path`
NAMESPACE=`cat ./mapping.json | $JQ_COMMAND .mapping.$1.namespace`
PUBLIC_KEY_PATH=`cat ./mapping.json | $JQ_COMMAND .public_key_path`

echo "Check for dependencies..."

which kubeseal > /dev/null 2>&1 
HAS_KUBESEAL=$?

which kubectl > /dev/null 2>&1 
HAS_KUBECTL=$?

which jq > /dev/null 2>&1 
HAS_JQ=$?

DEPENDENCY_CHECKER=$(( $HAS_JQ + $HAS_KUBECTL + $HAS_KUBESEAL ))

if [[ $DEPENDENCY_CHECKER -gt 0 ]]; then
    echo "Dependencies were not installed. Make sure you have the following:"
    echo -e "\t- jq"
    echo -e "\t- kubectl"
    echo -e "\t- kubeseal"
    exit 1
fi

echo "Generating secrets for $NAME..."
echo "================================================================"
echo "Checking for values file..."
if ! [[ -f $VALUES_PATH ]]; then
    echo "Values file at $VALUES_PATH was not found."
    exit 1
else
    echo "Values file at $VALUES_PATH was found."
    echo "================================================================"
    echo "Generating unsealed secret..."
fi
kubectl create secret generic $SECRET_NAME --from-file="$KEY=$VALUES_PATH" --namespace="$NAMESPACE" --dry-run=client -o yaml > $UNSEALED_SECRET_PATH
echo "Secret $SECRET_NAME has been outputted to $UNSEALED_SECRET_PATH."
echo "================================================================"
echo "Generating sealed secret..."
kubeseal --format=yaml --cert=$PUBLIC_KEY_PATH --namespace="$NAMESPACE" < $UNSEALED_SECRET_PATH > $SEALED_SECRET_PATH
echo "Sealed secret $SECRET_NAME has been outputted to $SEALED_SECRET_PATH."