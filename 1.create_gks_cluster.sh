#!/bin/bash

# Description: Create Google Kubernete Engine Cluster Creation with 3 nodes
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
print_color "red" "Deploy Google Kubernetes Cluster with 3 Nodes"
print_color "default" ""
print_color "green" "####################################################"

print_color "green" "Current Date and Time"
date
print_color "default" ""

gcloud container clusters create $GCS_CLUSTER_NAME \
    --num-nodes='3' \
    --machine-type='n1-standard-4' \
    --zone='us-west1-b'

#Get Authentication Credential for the cluster 
gcloud container clusters get-credentials $GCS_CLUSTER_NAME

#Grant cluster-admin permission to your gcp user account 
print_color "default" "Grant cluster-admin permission to your gcp user account"
kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $User_Account

print_color "default" ""
print_color "green" "Current Date and Time"
date
print_color "default" ""

print_color "green" "####################################################"
print_color "default" ""
print_color "red" "Please verify Cluster in GCP UI"
print_color "default" ""
print_color "green" "####################################################"
