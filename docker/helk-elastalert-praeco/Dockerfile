# HELK script: HELK Elastalert Praeco Dockerfile
# HELK build Stage: Alpha
# Author: paolo@priam.ai
# License: GPL-3.0

FROM praecoapp/elastalert-server:latest

ENV ESALERT_USER=elastalertuser
ENV ESALERT_HOME=/opt/elastalert
ENV ESALERT_SERVER=/opt/elastalert-server
ENV ESALERT_SIGMA_HOME=/opt/sigma
ENV SKIP_SIGMA_TRANSLATION=yes
USER root

RUN apk update && \
    apk add vim bash curl git && \
    rm -rf /var/cache/apk/*
# FIX LATEST GREP VERSION
RUN apk add --no-cache grep=3.4-r0

ADD scripts/elastalert-start.sh /usr/local/bin/
ADD scripts/elastic_search_status.sh /usr/local/bin/
ADD scripts/pull-sigma.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/elastalert-start.sh 
RUN chmod +x /usr/local/bin/elastic_search_status.sh
RUN chmod +x /usr/local/bin/pull-sigma.sh

USER node

# ********* Download SIGMA *******************
RUN git clone https://github.com/Cyb3rWard0g/sigma.git -b helk_neu5ron_updates ${ESALERT_SIGMA_HOME}

# ********* Copy Sigma config files **************
COPY pull-sigma-config.yaml ${ESALERT_HOME}/ 
COPY sigmac/sigmac-config.yml ${ESALERT_SIGMA_HOME}/sigmac-config.yml

# ********* Copy HELK rules files **************
#RUN mkdir -pv ${ESALERT_HOME}/rule_templates/HELK/
#COPY helk_rules/* ${ESALERT_HOME}/rule_templates/HELK/
#COPY rule_templates/* ${ESALERT_HOME}/rule_templates/
#COPY rules/BaseRule.config ${ESALERT_HOME}/rules/BaseRule.config

ENTRYPOINT ["/usr/local/bin/elastalert-start.sh"]