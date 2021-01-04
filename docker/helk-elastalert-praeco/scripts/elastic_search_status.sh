#!/bin/bash

# HELK script:elastic_search_status.sh
# HELK script description: Start ELASTALERT
# HELK build Stage: Alpha
# Author: paolo@priam.ai
# License: GPL-3.0

# *********** Helk log tagging variables ***************
# For more efficient script editing/reading, and also if/when we switch to different install script language
HELK_ELASTALERT_INFO_TAG="$HELK_ELASTALERT_INFO_TAG"
#HELK_ERROR_TAG="[HELK-ELASTALERT-DOCKER-INSTALLATION-ERROR]"

# *********** Environment Variables***************
if [[ -z "$ES_HOST" ]]; then
  ES_HOST=helk-elasticsearch
fi
echo "$HELK_ELASTALERT_INFO_TAG Setting Elasticsearch server name to $ES_HOST"

if [[ -z "$ES_PORT" ]]; then
  ES_PORT=9200
fi
echo "$HELK_ELASTALERT_INFO_TAG Setting Elasticsearch server port to $ES_PORT"

if [[ -n "$ELASTIC_PASSWORD" ]]; then
    if [[ -z "$ELASTIC_USERNAME" ]]; then
        ELASTIC_USERNAME=elastic
    fi
    echo "es_username: $ELASTIC_USERNAME" >> "${ESALERT_HOME}/config.yaml"
    echo "es_password: $ELASTIC_PASSWORD" >> "${ESALERT_HOME}/config.yaml"
    echo "$HELK_ELASTALERT_INFO_TAG Setting Elasticsearch username to $ELASTIC_USERNAME"
    echo "$HELK_ELASTALERT_INFO_TAG Setting Elasticsearch password to $ELASTIC_PASSWORD"
    ELASTICSEARCH_ACCESS=http://$ELASTIC_USERNAME:"$ELASTIC_PASSWORD"@$ES_HOST:$ES_PORT
else
    ELASTICSEARCH_ACCESS=http://$ES_HOST:$ES_PORT
fi
<<'###NOT-REQUIRED'
# *********** Update Elastalert Config ******************
echo "$HELK_ELASTALERT_INFO_TAG Updating Elastalert main config.."
sed -i "s/^es_host\:.*$/es_host\: ${ES_HOST}/g" "${ESALERT_HOME}/config.yaml"
sed -i "s/^es_port\:.*$/es_port\: ${ES_PORT}/g" "${ESALERT_HOME}/config.yaml"
###NOT-REQUIRED
# *********** Check if Elasticsearch is up ***************
until [[ "$(curl -s -o /dev/null -w "%{http_code}" $ELASTICSEARCH_ACCESS)" == "200" ]]; do
    echo "$HELK_ELASTALERT_INFO_TAG Waiting for elasticsearch URI to be accessible.."
    sleep 3
done

echo "$HELK_ELASTALERT_INFO_TAG Elasticsearch is up"

# *********** Transform SIGMA Rules to Elastalert Signatures *************
echo "$HELK_ELASTALERT_INFO_TAG Executing pull-sigma.sh script.."
pull-sigma.sh

# *********** Creating Elastalert Status Index ***************
response_code=$(curl -s -o /dev/null -w "%{http_code}" $ELASTICSEARCH_ACCESS/praeco_elastalert_status)
if [[ $response_code == 404 ]]; then
    echo "$HELK_ELASTALERT_INFO_TAG Creating Elastalert index.."
    if [[ -n "$ELASTIC_PASSWORD" ]]; then
        elastalert-create-index --host $ES_HOST --port $ES_PORT --username $ELASTIC_USERNAME --password "$ELASTIC_PASSWORD" --no-auth --no-ssl --url-prefix '' --old-index ''
    else
        elastalert-create-index --host $ES_HOST --port $ES_PORT --no-auth --no-ssl --url-prefix '' --old-index ''
    fi
else
    echo "$HELK_ELASTALERT_INFO_TAG Elastalert index already exists"
fi
