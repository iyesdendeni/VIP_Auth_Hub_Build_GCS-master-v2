VIP Auth Hub Build Guide on Google Cloud Kubernetes Environment 

This guide will help you to build VIP Auth Hub in your environemnt.

Install command line tools

# Install the latest version Helm and Kubectl (root user)

    # Helm latest version install (Versin 3.5. Jan. 2021)
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

    # Helm version check
    helm version

    # Kubectl latest version install (Version 1.20.2 Jan. 2021)

    cat <<EOF > /etc/yum.repos.d/kubernetes.repo
    [kubernetes]
    name=Kubernetes
    baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
    enabled=1
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
    EOF

    yum install -y kubectl

    # kubectl version check
    kubectl version

# Install specific Helm version and Specific Kubectl version (root user)

    # Helm 3.1.3 Install

    # Download Helm 3.1.3 Download
    
    wget https://get.helm.sh/helm-v3.1.3-linux-amd64.tar.gz

    # Extract File
    
    tar -zxvf helm-v3.1.3-linux-amd64.tar.gz

    # Move the file into /usr/local/bin directory
    
    sudo mv linux-amd64/helm /usr/local/bin/helm

    # Helm version check
    
    helm version

    # Kubectl 1.19.7 version install

    yum install kubectl-1.19.7

    ### Kubectl availabe version 
    ### curl -s https://packages.cloud.google.com/apt/dists/kubernetes-xenial/main/binary-amd64/Packages | grep Version | awk '{print $2}'

# JQ install for token parsing (It is used 6.Configure_ID_Store.sh)

    # Install Pre-requisitive

    yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

    # Install jq

    yum install -y jq

    # Verify 

    jq -Version

# The latest GIt version install (Version 2.24.1 Jan. 2021)

    sudo yum -y install https://packages.endpoint.com/rhel/7/os/x86_64/endpoint-repo-1.7-1.x86_64.rpm

    sudo yum -y install git

    # Git Version check
    git --version

# Install LDAP Search command

    yum install -y openldap-clients

# Python install (Versio 3.6.8 Jan. 2021)

    # Python3 install 

    yum install -y python3

    # Install Development tool and libraries.. 
    
    yum groupinstall -y "Development Tools" && yum install gcc openssl-devel bzip2-devel libffi-devel -y

    # set Python 3 as a default

    alternatives --install /usr/bin/python python /usr/bin/python2 50
    alternatives --install /usr/bin/python python /usr/bin/python3.6 60
    alternatives --config python

    # Validate Python install

    python --version

    # !!! Caution !!! When you install Python 3.x on CentOS, yum command does not work with Python 3. Please run "alternatives --config python", and select Pytyon 2.

# Create a user in CentOS and install Google SDK
    
    # useradd <User ID>

    useradd ssp19
    
    # su - <User ID>

    su - ssp19

    # Download Google SDK

    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-325.0.0-linux-x86_64.tar.gz

    # Extract the files

    tar -zxvf google-cloud-sdk-325.0.0-linux-x86_64.tar.gz

    # Install Google SDK

    ./google-cloud-sdk/install.sh

    # Initialize Google sdk with your google account credential

    ./google-cloud-sdk/bin/gcloud init

    # logout the current user and login again. Then, glcoud configuration is set under the user profile

    ### Reference URL: https://cloud.google.com/kubernetes-engine/docs/quickstart#create_cluster #####

    # Default zone setting as us-west1-b (Broadcome IT recommendation)
 
    gcloud config set compute/zone us-west1-b

# Git Clone or download from https://github.gwd.broadcom.net/br664753/VIP_Auth_Hub_Build_GCS (VPN Connection) 

    # Upload public key and priviate key to access your git hub repository (Please ignore these command when you download from the web page)

    cat ~/.ssh/id_rsa.pub | ssh ssp19@dev1 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >>  ~/.ssh/authorized_keys"
    cat ~/.ssh/id_rsa | ssh ssp19@dev1 "cat >>  ~/.ssh/id_rsa && chmod 400 ~/.ssh/id_rsa"

    # Git clone 

    git clone git@github.gwd.broadcom.net:br664753/VIP_Auth_Hub_Build_GCS.git

    cd VIP_Auth_Hub_Build_GCS

# Environment variable setup

        DIRNAME="$(cd "${BASH_SOURCE[0]%/*}"; pwd)"

        # server.key : SSL Private key, server_add_chain.crt: SSL public cert and Chain Certificate
        # SSL certificate is wilde certificate.. security.demo-broadcom.com

        # Suffix is used for Host name + SUFFIX, for example, kibana01.demo-broadcom.com, grafana01.demo-broadcom.com
        
        export SUFFIX="01"

        export PREFIX="ssp"
        export RELEASENAME="ssp"
        export NAMESPACE="ssp"
        export CERTFILE="${DIRNAME}/server_add_chain.crt"
        export KEYFILE="${DIRNAME}/server.key"
        export DOMAIN="security.demo-broadcom.com"
        export FIDO_DOMAIN="demo-broadcom.com"      # Due to SSP19 limitation, it should use last 2 domain
        export SSP_FQDN="ssp${SUFFIX}.${DOMAIN}"    # ex: ssp01.security.demo-broadcom.com

        export APP_NAME_SPACE="sample-app"
        export SAMPLE_APP_RELEASE_NAME="sample-app"
        export APP_FQDN="app${SUFFIX}.${DOMAIN}"    #ex: app01.security.demo-broadcom.com

        export SA_NAMESPACE="sample-app"
        export SA_RELEASENAME="sample-app"
        export SSP_URL="https://${SSP_FQDN}/default/"
        export SA_FQDN="${APP_FQDN}"

        export SA_KEYFILE="${DIRNAME}/server.key"
        export SA_CERTFILE="${DIRNAME}/server_add_chain.crt"

        # GCS Account Email Address
        export User_Account="bong-kyun.rhim@broadcom.com"

        # Cluster Name in GCS ..
        export GCS_CLUSTER_NAME="team-grandcaynon"

        # Logging Monitoring Host

        export KIBANA_HOST="kibana${SUFFIX}.${DOMAIN}"
        export JAEGER_HOST="jaeger${SUFFIX}.${DOMAIN}"
        export ALERTMANAGER_HOST="alertmanager${SUFFIX}.${DOMAIN}"
        export GRAFANA_HOST="grafana${SUFFIX}.${DOMAIN}"

        # SSP Access Credential.. It is for Broadcom internal Access. Each customer will have a different credential.

        export SSP_USERNAME="authhub-install@ca"
        export SSP_CREDENTIAL="346a437f8b869a8089a6c8766593fe8a99f1f4db"


# Environment export

    source ./0.gks_env.sh

    # Check the variable name such as SSP
    env

# 1. Create Google Kubernetes Cluster

    ./1.create_gks_cluster.sh

    # Check Node in GCS

    kubeclt get nodes

# 2. Deploy Ingress Controller

    ./2.Deploy_Ingress_Controller.sh

    # check Ingress Service

    kubectl get svc -n ingress

# 3. Deploy Enclave Services (logging & Monitoring)

    ./3.Deploying_Enclave_Services.sh

    # Check logging service (elastic search)
    kubectl get pod -n logging

    # Check Monitoring Service (Prometheus)
    kubectl get pod -n monitoring

    # Check Tracing service (Jaeger)
    kubectl get pod -n tracing

    # Add Host Name and IP Address in host file or DNS server. Please also update hosts file where you execute kubectl commands

# 4. Deploy VIP Auth Hub Service

    ./4.Deploying_VIP_AuthHub_Services.sh

# 5. Deploy Sample Service

    ./5.Deploying_Sample_App.sh

# 6. ID Store (LDAP) Set Up from command line

    # Please do a network connection check where you execute the commands. ex: ping app01.security.demo-broadcom.com. When it cannot connect app[suffx].security.demo-broadcom.com. Step 6 will not work properly.

    ./6.Configure_ID_Store.sh

    # Access Sample App and validate the loing with nbruce/password, ex: https://<SA_FQDN>/sample-app/

# 7.(optional) Remove mobile phone number in the Sample User Directory

    # switch to VIP Auth Hub Test User
    # su - ssp19  # example

    ./7.Remove_Mobile_Number.sh

# 99. Delete Services (Sample App, VIP Auth Hub, Monitoring, Logging, Tracing and Ingress)

    ./99.delete_ssp.sh

# 999. Delete Google Kubernete Cluster

    ./999.gks_cluster_delete.sh