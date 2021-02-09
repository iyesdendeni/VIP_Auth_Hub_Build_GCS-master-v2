#!/bin/bash

# Description: Delete Service in Google Cluster
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
print_color "red" "Deleteing Sample App Service "
print_color "default" ""
print_color "green" "####################################################"

helm uninstall ${SA_RELEASENAME} -n ${SA_NAMESPACE}
kubectl delete ns ${SA_NAMESPACE}

print_color "green" "####################################################"
print_color "default" ""
print_color "red" "Deleteing VIP Auth Hub Service "
print_color "default" ""
print_color "green" "####################################################"

helm uninstall "$RELEASENAME" -n "$NAMESPACE"

print_color "green" "####################################################"
print_color "default" ""
print_color "red" "Deleteing VIP Auth Hub Infra Servicee "
print_color "default" ""
print_color "green" "####################################################"

helm uninstall infra-"$RELEASENAME" -n "$NAMESPACE"

helm ls --all-namespaces

echo "Deleting name space $NAMESPACE"
kubectl delete ns "$NAMESPACE"

print_color "green" "####################################################"
print_color "default" ""
print_color "red" "Deleteing Logging Service "
print_color "default" ""
print_color "green" "####################################################"

helm uninstall kibana -n logging
helm uninstall elasticsearch -n logging
kubectl delete ns logging 

print_color "green" "####################################################"
print_color "default" ""
print_color "red" "Deleteing Monitoring Service "
print_color "default" ""
print_color "green" "####################################################"

helm uninstall prometheus-operator -n monitoring
kubectl delete ns monitoring 

print_color "green" "####################################################"
print_color "default" ""
print_color "red" "Deleteing Traing Service "
print_color "default" ""
print_color "green" "####################################################"

helm uninstall jaeger-operator -n tracing
kubectl delete ns tracing  

print_color "green" "####################################################"
print_color "default" ""
print_color "red" "Deleteing Ingress Service "
print_color "default" ""
print_color "green" "####################################################"

helm uninstall ingress-nginx -n ingress
kubectl delete ns ingress   
