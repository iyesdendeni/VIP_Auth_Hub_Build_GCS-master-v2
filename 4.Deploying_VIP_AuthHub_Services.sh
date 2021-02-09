#!/bin/bash

# Description: Deploy VIP AuthHub Service
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
print_color "red" "Deploying VIP Auth Hub  Services"
print_color "default" ""
print_color "green" "####################################################"


kubectl create ns "${NAMESPACE}"
helm repo add ssp_helm_charts https://ssp_helm_charts.storage.googleapis.com
helm repo update
helm search repo ssp_helm_charts --versions

kubectl create secret tls ssp-general-tls --cert "${CERTFILE}" --key "${KEYFILE}" -n "${NAMESPACE}"
helm upgrade --install infra-"${RELEASENAME}" ssp_helm_charts/ssp-infra --set sspReleaseName="${RELEASENAME}" -n "${NAMESPACE}"

while true
do
        Running_Pod="$(kubectl get pods -n ${NAMESPACE}  |  grep -i Running | wc -l)"
        Completed_Pod="$(kubectl get pods -n ${NAMESPACE}  |  grep -i Completed | wc -l)"
        if [[ ( "$Running_Pod" == 7 ) && ( "$Completed_Pod" == 1)  ]];
        then
                print_color "green" "SSP Infra Service is running properly."
                break;
        else
                kubectl get pod -n ${NAMESPACE}
                sleep 5;
        fi
done

kubectl get pod -n "${NAMESPACE}"

helm upgrade --install "${RELEASENAME}" -n "${NAMESPACE}" ssp_helm_charts/ssp --set ssp.global.monitoring.prometheusOperator.serviceMonitor.create=true \
        --set ssp.ingress.host="${SSP_FQDN}" --set ssp.ingress.tls.host="${SSP_FQDN}" --set ssp.ingress.tls.secretName=ssp-general-tls \
        --set ssp.global.ssp.registry.credentials.username="${SSP_USERNAME}" --set ssp.global.ssp.registry.credentials.password="${SSP_CREDENTIAL}"


while true
do
        Completed_Pod="$(kubectl get pods -l app.kubernetes.io/name=ssp-infra-create-db-job -n ${NAMESPACE}  |  grep -i Completed | wc -l)"
        if [[ "$Completed_Pod" == 1 ]];
        then
                print_color "green" "VIP Auth Hub Service is running properly."
                break;
        else
                kubectl get pod -n ${NAMESPACE}
                sleep 5;
        fi
done

print_color "green" "####################################################"
print_color "default" ""
print_color "red" "Complete VIP Auth Hub Deploy.. Please check the configurations."
print_color "default" ""
print_color "green" "####################################################"

kubectl get svc -n ingress ingress-nginx-controller
IPADDRESS=$(kubectl get svc -n ingress ingress-nginx-controller | awk '{ print $4 }' | sed -n 2p )

print_color "green" "####################################################"
print_color "default" ""
print_color "default" ""
print_color "default" ""
print_color "default" "Execute \" watch kubectl get pods -n ${NAMESPACE} \"  and validate the status of VIP Auth Hub Pods"
print_color "default" ""
print_color "default" ""
print_color "green" "####################################################"
