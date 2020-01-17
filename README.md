# GKE CI Test

Runs a code test on a GKE cluster and monitors the job until completion.

### `gke_service_account`

#### Google Kubernetes Engine Service Account

A credentials file containing for the service account to be used to interact with the GKE cluster.

### `gke_cluster_name`

#### Google Kubernetes Engine Cluster Name

Cluster name of the GKE instance.

### `gke_project`

#### Google Kubernetes Engine Project

Project which contains the GKE instance.

### `manifest_file`

#### Kubernetes Job Manifest File 

Path and name of the Kubernetes manifest .yml file. This file should describe the testing job to be run. This file must run a kubernets job and only the logs of the first pod will be monitored.
Defaults to 'ci-test.yml'

### `namespace`

#### Kubernetes Namespace

The Kubernetes namespace on which the test job will run.
Defaults to 'ci-test'

## Example usage

```ylm
- name: Run test job
    uses: colpal/actions-gke-ci-test
    with:
    GCP_SERVICE_ACCOUNT: ${{ secrets.GCR_GCP_CREDENTIALS }}
    GCP_PROJECT: 'cp-advancedtech-sandbox'
    GKE_CLUSTER_NAME: cp-advtech-cluster
    MANIFEST_FILE: 'testing/ci-test.yml'
```