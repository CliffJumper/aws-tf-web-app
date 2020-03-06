#!/bin/bash

# Create the lambda Deploy package:
pushd ../lambda
zip ../infra/lambda_function_payload.zip exports.js
popd

# Run the Plan
pushd ../infra
terraform init
terraform plan

echo "Do you want to deploy this plan? Y/N"

while true; do
    read planinput
    case $planinput in
        [Yy] ) terraform apply; break;;
        [Nn] ) echo "Aborting Deploy"; break;;
        * ) echo "Please answer Y or N (invalid input given)"; ;;
    esac
done
