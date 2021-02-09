#!/bin/bash


# Description: Deploy Ingress Controller
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
print_color "red" "Deploy Ingress Controller"
print_color "default" ""
print_color "green" "####################################################"

kubectl create ns ingress
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx -n ingress ingress-nginx/ingress-nginx --set controller.service.externalTrafficPolicy="Local" --version=3.7.1

print_color "default" "####################################################"
print_color "default" ""
print_color "green" "Get Ingress IP Address"
print_color "default" ""
print_color "default" "####################################################"

kubectl get pods -n ingress
kubectl get svc -n ingress 

