cloud-env-create:
	PERSON=$(p) ACTION=create INFRA_REPO_REVISION=dev erb tekton/k8s-env-pipeline-run.yml.erb > output/k8s-env-pipeline-run.yml
	kubectl create -f output/k8s-env-pipeline-run.yml

cloud-env-update:
	PERSON=$(p) ACTION=apply INFRA_REPO_REVISION=dev erb tekton/k8s-env-pipeline-run.yml.erb > output/k8s-env-pipeline-run.yml
	kubectl create -f output/k8s-env-pipeline-run.yml

cloud-env-delete:
	PERSON=$(p) ACTION=delete INFRA_REPO_REVISION=dev erb tekton/k8s-env-pipeline-run.yml.erb > output/k8s-env-pipeline-run.yml
	kubectl create -f output/k8s-env-pipeline-run.yml

RECENT_PIPELINERUN_ID := $(shell tkn pipelineruns -n devops list --limit 1 --no-headers | cut -d' ' -f1)
tekton-pipelineruns-log-recent:
	tkn pipelineruns logs -f $(RECENT_PIPELINERUN_ID)

tekton-pipelineruns-logs-all:
	tkn pipelineruns logs -f -n devops

tekton-pipelineruns-delete-all:
	tkn pipelineruns delete -n devops --all

tekton-resources-k8s-apply:
	kubectl apply -n devops -f tekton/resources/

SVC_PORT := $(shell kubectl get service -n $(p) $(p)-ide-svc | grep -oe  "\d\{5\}")
DOMAIN = "dev.klstr.io"
SSH_CONF_FILE = "$(HOME)/.cloud-dev/ssh_config"
SSH_CONF_LINE = "Include $(HOME)/.cloud-dev/ssh_config"
update-ssh-config:
	$(shell [ ! -d "$(HOME)/.cloud-dev" ] && mkdir $(HOME)/.cloud-dev)
	grep -qxF $(SSH_CONF_LINE) ~/.ssh/config || echo \\n$(SSH_CONF_LINE) >> ~/.ssh/config
	DOMAIN=$(DOMAIN) PERSON="$(p)" SSH_PORT=$(SVC_PORT) erb ssh-config.erb > $(SSH_CONF_FILE)
	@echo "\nCloud dev environment ssh config updated. Please select $(p)-cloud-dev to start development."
