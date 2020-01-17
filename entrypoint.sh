#!/bin/bash
set -e

END=300
ATTEMPTS=0

echo "$INPUT_GKE_SERVICE_ACCOUNT" | base64 -d > /tmp/service_account.json

gcloud auth activate-service-account --key-file=/tmp/service_account.json

gcloud config set project "$INPUT_GKE_PROJECT"

CZONE=$(gcloud container clusters list --format="get(location)" --filter="name=$INPUT_GKE_CLUSTER_NAME")

gcloud container clusters get-credentials $INPUT_GKE_CLUSTER_NAME --zone $CZONE --project $INPUT_GKE_PROJECT



NAME=$(kubectl create -f $INPUT_MANIFEST_FILE -o jsonpath='{.spec.template.metadata.labels.job-name}' -n $INPUT_NAMESPACE)
JOB=job/$NAME

#Make sure Job is active
echo "Job" $NAME "provisioned, waiting for job to start..."
until [[ $SECONDS -gt $END ]] || [[ $(kubectl get $JOB -n $INPUT_NAMESPACE -o jsonpath='{.status.active}') == "1" ]]; do
    printf "\rWaiting "$ATTEMPTS"s"
    ((ATTEMPTS=ATTEMPTS+1))
    sleep 1
done
printf "\rWaiting "$ATTEMPTS"s"
((ATTEMPTS=ATTEMPTS+1))

#Make sure first container is running (act)
echo "Job created, waiting for pod"
until [[ $SECONDS -gt $END ]] || [[ $(kubectl get pod -l job-name=$NAME -n $INPUT_NAMESPACE -o jsonpath='{.items[0].status.phase}') == "Running" ]]; do
    STATUS=$(kubectl get pods -l job-name=$NAME -n $INPUT_NAMESPACE -o jsonpath='{.items[0].status.phase}')
    printf "\rPod status: "$STATUS
done
STATUS=$(kubectl get pods -l job-name=$NAME -n $INPUT_NAMESPACE -o jsonpath='{.items[0].status.phase}')
printf "\rPod status: "$STATUS

printf "\n"
echo "Job started, displaying logs:"
kubectl logs --follow $JOB -n $INPUT_NAMESPACE

if [ $(kubectl get $JOB -o jsonpath='{.status.succeeded}' -n $INPUT_NAMESPACE) == "1" ]
then
    echo "Test job completed successfully"
    exit 0
else
    echo "Test job failed"
    exit 1
fi