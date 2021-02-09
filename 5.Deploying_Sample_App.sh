#!/bin/bash

# Description: Deploy VIP AuthHub Sample Service
# Created by: B.K. Rhim
# Last Modification: Jan. 31, 2021

DIRNAME="$(cd "${BASH_SOURCE[0]%/*}"; pwd)"
source ${DIRNAME}/0.gks_env.sh

NC="\033[0m"

function print_color(){

  case $1 in
    "green") COLOR="\033[0;32m" ;;
    "red")  COLOR="\033[0;31m" ;;
    *) COLOR="\033[0m" ;;
  esac
  echo -e "${COLOR} $2 ${NC}"
}

print_color "green" "####################################################"
print_color "default" ""
print_color "red" "Deploying VIP Samplle App  Services"
print_color "default" ""
print_color "green" "####################################################"

kubectl create ns "${SA_NAMESPACE}"

kubectl create secret tls sample-app-tls-generic --cert "${SA_CERTFILE}" --key "${SA_KEYFILE}" -n "${SA_NAMESPACE}"
SA_CLIENTID=$(kubectl get secret ${RELEASENAME}-ssp-secret-democlient -n "${NAMESPACE}" -o jsonpath="{.data.clientId}" | base64 --decode)
SA_CLIENTSECRET=$(kubectl get secret ${RELEASENAME}-ssp-secret-democlient -n "${NAMESPACE}" -o jsonpath="{.data.clientSecret}" | base64 --decode)

helm repo add ssp_helm_charts https://ssp_helm_charts.storage.googleapis.com
helm repo update

helm install "${SA_RELEASENAME}" -n "${SA_NAMESPACE}" ssp_helm_charts/ssp-sample-app --render-subchart-notes \
    --set ssp.serviceUrl="${SSP_URL}" --set ssp.clientId="${SA_CLIENTID}" --set ssp.clientSecret="${SA_CLIENTSECRET}" \
    --set ingress.host="${SA_FQDN}" --set ingress.tls.host="${SA_FQDN}" --set ingress.tls.secretName=sample-app-tls-generic \
    --set ssp-symantec-dir.service.type=LoadBalancer --set ssp-symantec-dir.service.servicePort=389 \
    --set global.registry.credentials.username="${SSP_USERNAME}" --set global.registry.credentials.password="${SSP_CREDENTIAL}"


print_color "green" "####################################################"
print_color "default" ""
print_color "red" "Complete VIP Sample App Service.. Please check the configurations."
print_color "default" ""
print_color "green" "####################################################"

kubectl get svc -n ingress ingress-nginx-controller
IPADDRESS=$(kubectl get svc -n ingress ingress-nginx-controller | awk '{ print $4 }' | sed -n 2p )

print_color "green" "####################################################"
print_color "default" ""
print_color "green" "Accessing Sample App: https://${SA_FQDN}/sample-app/ "
print_color "default" ""
print_color "green" "####################################################"
