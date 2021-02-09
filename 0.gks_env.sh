#!/bin/bash

# Description: Export VIP Auth Hub Deployment Environment Export
# Created by: B.K. Rhim
# Last Modification: Jan. 28, 2021

DIRNAME="$(cd "${BASH_SOURCE[0]%/*}"; pwd)"

# server.key : SSL Private key, server_add_chain.crt: SSL public cert and Chain Certificate
# SSL certificate is wilde certificate.. demo-broadcom.com

# Suffix is used for Host name + SUFFIX, for example, kibana01.demo-broadcom.com, grafana01.demo-broadcom.com
export SUFFIX="yourInitials"

export PREFIX="ssp"
export RELEASENAME="ssp"
export NAMESPACE="ssp"
export CERTFILE="${DIRNAME}/server_add_chain.crt"
export KEYFILE="${DIRNAME}/server.key"
export DOMAIN="security.demo-broadcom.com"
export FIDO_DOMAIN="demo-broadcom.com"      # Due to SSP19 limitation, it should use last 2 domain
export SSP_FQDN="ssp-${SUFFIX}.${DOMAIN}"    # ex: ssp01.security.demo-broadcom.com

export APP_NAME_SPACE="sample-app"
export SAMPLE_APP_RELEASE_NAME="sample-app"
export APP_FQDN="app-${SUFFIX}.${DOMAIN}"    #ex: app01.security.demo-broadcom.com

export SA_NAMESPACE="sample-app"
export SA_RELEASENAME="sample-app"
export SSP_URL="https://${SSP_FQDN}/default/"
export SA_FQDN="${APP_FQDN}"

export SA_KEYFILE="${DIRNAME}/server.key"
export SA_CERTFILE="${DIRNAME}/server_add_chain.crt"

# GCS Account Email Address
export User_Account="firstName.lastName@broadcom.com"

# Cluster Name in GCS ..
export GCS_CLUSTER_NAME="team-elcap"

# Logging Monitoring Host

export KIBANA_HOST="kibana-${SUFFIX}.${DOMAIN}"
export JAEGER_HOST="jaeger-${SUFFIX}.${DOMAIN}"
export ALERTMANAGER_HOST="alertmanager-${SUFFIX}.${DOMAIN}"
export GRAFANA_HOST="grafana-${SUFFIX}.${DOMAIN}"

# SSP Access Credential.. It is for Broadcom internal Access. Each customer will have a different credential.

export SSP_USERNAME="authhub-install@ca"
export SSP_CREDENTIAL="346a437f8b869a8089a6c8766593fe8a99f1f4db"