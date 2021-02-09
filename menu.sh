#!/bin/bash

clear

# Description: VIP Auth Hub Deploy Script Memu
# Created by: B.K. Rhim
# Last Modification: Jan. 28, 2021

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

while true
do
        print_color "default" "####################################################"
        print_color "default" ""
        print_color "green" "1. Create Gloogle Kubernetes Cluster with 3 nodes "
        print_color "green" "2. Deploy Ingress Controlller "
        print_color "green" "3. Deploy Enclave Services "
        print_color "green" "33. Update DNS in AWS Route 53 "
        print_color "green" "4. Deploy VIP Auth Hub Services "
        print_color "green" "5. Deploy Sample App Services "
        print_color "green" "6. Configure ID Store "
        print_color "green" "7. Initialized LDAP Data (Removing default phone numbers)  "
        print_color "green" "88. Show nodes, pod and VIP Auth configuration -- status check  "
        print_color "green" "99. Delete Entire Services in EKS Cluster "
        print_color "green" "999. Delete Google Kubernete Cluster "
        print_color "red" "X. Exit "
        print_color "default" ""
        print_color "default" "####################################################"
        print_color "default" ""
        print_color "default" ""
        read -p "Enter your choice: " choice

        case $choice in

                1) print_color "green" "Create EKS Cluster with 3 nodes"
                        source ${DIRNAME}/1.create_gks_cluster.sh
                        ;;
                2) print_color "green" "Deploy Ingress Controller "
                        source ${DIRNAME}/2.Deploy_Ingress_Controller.sh
                        ;;
                3) print_color "green" "Deploy Enclave Services"
                        source ${DIRNAME}/3.Deploying_Enclave_Services.sh
                        ;;
                4) print_color "green" "Deploy VIP Auth Hub Services"
                        source ${DIRNAME}/4.Deploying_VIP_AuthHub_Services.sh
			;;
                5) print_color "green" "Deploy Sample App Services"
                        source ${DIRNAME}/5.Deploying_Sample_App.sh
                        ;;
                6) print_color "green" "Configure ID Store"
                        source ${DIRNAME}/6.Configure_ID_Store.sh
			;;
                7) print_color "green" "Initialized LDAP Data (Removing default phone numbers)"
                        source ${DIRNAME}/7.Remove_Mobile_Number.sh
                        ;;
                88) print_color "green" "Show nodes, pod and VIP Auth configuration -- status check"
                        source ${DIRNAME}/88.status_check.sh
                        ;;
		99) print_color "green" "Delete Entire Services in EKS Cluster"
                        source ${DIRNAME}/99.delete_ssp.sh
                        ;;
		999) print_color "green" "Delete EKS Cluster"
                        source ${DIRNAME}/999.gks_cluster_delete.sh
                        ;;
                X) break
                        ;;
                *) continue
                        ;;
        esac
done
