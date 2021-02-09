#!/bin/bash

# Description: Deploy Enclave Service (Monitoring and Auditing)
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
print_color "red" "Deploying Enclave Services"
print_color "default" ""
print_color "green" "####################################################"

print_color "default" ""
print_color "green" "Deploy Elastic Search"
print_color "default" ""


kubectl create ns logging
helm repo add elastic https://helm.elastic.co/
helm repo update
helm install elasticsearch -n logging elastic/elasticsearch

print_color "green" "Check Elastic Service Deploy Status"

while true
do
	Running_Pod="$(kubectl get pods --field-selector=status.phase=Running -l app=elasticsearch-master -n logging  |  grep -i Running | wc -l)"
	if [[ "$Running_Pod" == 3 ]];
	then
		print_color "green" "Elastic Pod is running in each node"
		break;
	else
		kubectl get pod -n logging
		sleep 5;
	fi
done

print_color "default" ""
print_color "green" "Deploy Kibana Service ver.7.9.3"
print_color "default" ""

kubectl create secret tls logging-general-tls --cert "${CERTFILE}" --key "${KEYFILE}" -n logging

helm install kibana -n logging elastic/kibana --version '7.9.3' --set ingress.enabled=true \
        --set "ingress.annotations.kubernetes\.io/ingress\.class"='nginx' \
        --set ingress.tls[0].secretName=logging-general-tls --set ingress.hosts[0]="${KIBANA_HOST}" \
        --set ingress.tls[0].hosts[0]="${KIBANA_HOST}"

kubectl get pvc -n logging
kubectl get pod -n logging

print_color "default" ""
print_color "green" "Deploying Jager for Tracing"
print_color "default" ""

kubectl create ns tracing
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update

kubectl create secret tls tracing-general-tls --cert "${CERTFILE}" --key "${KEYFILE}" -n tracing
helm install jaeger-operator -n tracing jaegertracing/jaeger-operator --version '2.14.2' --set jaeger.create='true' \
        --set jaeger.spec.ingress.security='none' --set rbac.clusterRole='true' \
        --set jaeger.spec.storage.type='elasticsearch' --set jaeger.spec.storage.options.es.server-urls="http://elasticsearch-master.logging.svc:9200/" \
        --set jaeger.spec.storage.options.es.username='elastic' --set jaeger.spec.storage.options.es.password='changeme' \
        --set jaeger.spec.ingress.enabled='true' --set "jaeger.spec.ingress.annotations.kubernetes\.io/ingress\.class"='nginx' \
        --set jaeger.spec.ingress.tls[0].secretName='tracing-general-tls' --set jaeger.spec.ingress.hosts[0]="${JAEGER_HOST}" \
        --set jaeger.spec.ingress.tls[0].hosts[0]="${JAEGER_HOST}"

while true
do
        Running_Pod="$(kubectl get pods -n tracing  |  grep -i Running | wc -l)"
        if [[ "$Running_Pod" == 2 ]];
        then
                print_color "green" "Jaeger Pod is running "
                break;
        else
                kubectl get pod -n tracing
                sleep 5;
        fi
done

print_color "default" ""
print_color "green" "Deploying Prometheus and Grafana for Metric"
print_color "default" ""

kubectl create ns monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

kubectl create secret tls monitoring-general-tls --cert "${CERTFILE}" --key "${KEYFILE}" -n monitoring

helm install prometheus-operator -n monitoring prometheus-community/kube-prometheus-stack --version='10.1.1' \
        --set nameOverride='prometheus-operator' --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.accessModes[0]='ReadWriteOnce' \
        --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage='20Gi' --set alertmanager.ingress.enabled='true' \
        --set "alertmanager.ingress.annotations.kubernetes\.io/ingress\.class"='nginx' \
        --set alertmanager.ingress.tls[0].secretName="monitoring-general-tls" \
        --set alertmanager.ingress.hosts[0]="${ALERTMANAGER_HOST}" \
        --set alertmanager.ingress.tls[0].hosts[0]="${ALERTMANAGER_HOST}" --set grafana.ingress.enabled='true' \
        --set "grafana.ingress.annotations.kubernetes\.io/ingress\.class"='nginx' \
        --set grafana.ingress.tls[0].secretName="monitoring-general-tls" --set grafana.ingress.hosts[0]="${GRAFANA_HOST}" \
        --set grafana.ingress.tls[0].hosts[0]="${GRAFANA_HOST}"

kubectl get pvc -n monitoring

while true
do
        Running_Pod="$(kubectl get pods --field-selector=status.phase=Running -n monitoring | grep -E 'alertmanager|grafana' | wc -l )"
        if [[ "$Running_Pod" == 2 ]];
        then
                print_color "green" "Alert Manager Pod and Granfana Pod are runninbg properly."
                break;
        else
                kubectl get pod -n monitoring
                sleep 5;
        fi
done

kubectl get svc -n ingress ingress-nginx-controller

IPADDRESS=$(kubectl get svc -n ingress ingress-nginx-controller | awk '{ print $4 }' | sed -n 2p )

print_color "green" "####################################################"
print_color "default" ""
print_color "green" "Update hosts file or DNS Server"
print_color "green" "${IPADDRESS}       ${KIBANA_HOST}  ${JAEGER_HOST}  ${ALERTMANAGER_HOST}  ${GRAFANA_HOST} ${SSP_FQDN}   ${SA_FQDN}"
print_color "red" "Complete deploying Enclave Services.. Please check the configurations."

print_color "default" ""
print_color "green" "####################################################"
