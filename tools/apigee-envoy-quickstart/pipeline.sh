#!/bin/bash

# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

export ENVOY_HOME=/home

export PIPELINE_TEST="true"

export APIGEE_REMOTE_SRVC_CLI_VERSION=2.0.5
export APIGEE_REMOTE_SRVC_ENVOY_VERSION=2.0.5

if [[ "$APIGEE_X_HOSTNAME" == http* ]]; then
    echo "Runtime hostname value correctly set";
else
    APIGEE_X_HOSTNAME="https://$APIGEE_X_HOSTNAME";
fi

printf "Running edge envoy cleanup"
./aekitctl.sh --type standalone-apigee-envoy --action delete --platform edge

printf "Running edge envoy setup"
./aekitctl.sh --type standalone-apigee-envoy --action install --platform edge

printf "Running edge envoy cleanup"
./aekitctl.sh --type standalone-apigee-envoy --action delete --platform edge

export APIGEE_PROJECT_ID="$APIGEE_X_ORG"
TOKEN="$(gcloud config config-helper --force-auth-refresh --format json | jq -r '.credential.access_token')";
export TOKEN

printf "Running X envoy cleanup"
./aekitctl.sh --type standalone-apigee-envoy --action delete

printf "Running X envoy setup"
./aekitctl.sh --type standalone-apigee-envoy --action install

printf "Running X envoy cleanup"
./aekitctl.sh --type standalone-apigee-envoy --action delete
