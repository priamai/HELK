#!/bin/bash

# HELK script: elastalert-start.sh
# HELK script description: Start ELASTALERT
# HELK build Stage: Alpha
# Author: paolo@priam.ai
# License: GPL-3.0

# *********** Helk log tagging variables ***************
# For more efficient script editing/reading, and also if/when we switch to different install script language
HELK_ELASTALERT_INFO_TAG="$HELK_ELASTALERT_INFO_TAG"
#HELK_ERROR_TAG="[HELK-ELASTALERT-DOCKER-INSTALLATION-ERROR]"

set -e

echo "$HELK_ELASTALERT_INFO_TAG Giving Elasticsearch time to start..."

elastic_search_status.sh

echo "$HELK_ELASTALERT_INFO_TAG Starting ElastAlert!"
npm start
