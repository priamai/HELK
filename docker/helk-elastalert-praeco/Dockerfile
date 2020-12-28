# HELK script: HELK Elastalert Praeco Dockerfile
# HELK build Stage: Alpha
# Author: paolo@priam.ai
# License: GPL-3.0

FROM praecoapp/elastalert-server:latest

ENV ESALERT_HOME=/opt/elastalert-server
ENV ESALERT_SIGMA_HOME=/opt/sigma

USER root

RUN apk update && \
    apk add vim bash curl git && \
    rm -rf /var/cache/apk/*

ADD scripts/elastalert-start.sh /usr/local/bin/
ADD scripts/elastic_search_status.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/elastalert-start.sh 
RUN chmod +x /usr/local/bin/elastic_search_status.sh

USER node

# ********* Download SIGMA *******************
RUN git clone https://github.com/Cyb3rWard0g/sigma.git -b helk_neu5ron_updates ${ESALERT_SIGMA_HOME}

# ********* Copy Elastalert files **************
#COPY scripts/* ${ESALERT_HOME}/ <- ignore for now
#COPY config.yaml ${ESALERT_HOME}/
COPY pull-sigma-config.yaml ${ESALERT_HOME}/ 
#COPY rules/* ${ESALERT_HOME}/rules/ <- the existing rules should be moved into templates instead
COPY sigmac/sigmac-config.yml ${ESALERT_SIGMA_HOME}/sigmac-config.yml

ENTRYPOINT ["/usr/local/bin/elastalert-start.sh"]