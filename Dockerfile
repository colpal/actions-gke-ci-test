FROM google/cloud-sdk:alpine

LABEL name="actions-gke-ci-test"
LABEL version="1.0.0"
LABEL com.github.actions.name="GKE CI Test"
LABEL com.github.actions.description="Run a code test on GKE"
LABEL com.github.actions.color="blue"
LABEL com.github.actions.icon="cloud"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN gcloud components install kubectl

ENTRYPOINT ["/entrypoint.sh"]