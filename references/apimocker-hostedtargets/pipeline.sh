#!/bin/sh
# Copyright 2020 Google LLC
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
set -x

npm install
npm run deploy

# wait for hosted target to be up
until curl -o /dev/null -s -f https://"$APIGEE_ORG"-"$APIGEE_ENV".apigee.net/mock/v1/dogs; do
    printf '.'
    sleep 2
done

npm test
