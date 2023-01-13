RECENT_PIPELINERUN_ID = $(shell tkn pipelineruns -n devops list --limit 1 --no-headers | cut -d' ' -f1)
SVC_PORT = $(shell kubectl get service -n $(p) $(p)-ide-svc | grep -oe  "\d\{5\}")
DOMAIN = "dev.klstr.io"
SSH_CONF_FILE = "$(HOME)/.cloud-dev/ssh_config"
SSH_CONF_LINE = "Include $(HOME)/.cloud-dev/ssh_config"

ecr-login:
	aws --profile tarkalabs ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 260741046218.dkr.ecr.us-east-1.amazonaws.com

build-and-push-docker-image:
	docker build -t 260741046218.dkr.ecr.us-east-1.amazonaws.com/cloud-dev:ubuntu-base-$(v) .
	docker push 260741046218.dkr.ecr.us-east-1.amazonaws.com/cloud-dev:ubuntu-base-$(v)

# make cloud-env-create p=madhav pku="https://github.com/svmadhavareddy.keys" iit="ubuntu-base-v4" ss=2 irr=dev
cloud-env-create:
	PERSON=$(p) PUBLIC_KEY_URL="$(pku)" IDE_IMAGE_TAG="$(iit)" STORAGE_SIZE="$(ss)" ACTION=create INFRA_REPO_REVISION="$(irr)" erb tekton/k8s-env-pipeline-run.yml.erb > output/k8s-env-pipeline-run.yml
	kubectl create -f output/k8s-env-pipeline-run.yml

# make cloud-env-update p=madhav pku="https://github.com/svmadhavareddy.keys" iit="ubuntu-base-v4" irr=dev
cloud-env-update:
	PERSON=$(p) PUBLIC_KEY_URL="$(pku)" IDE_IMAGE_TAG="$(iit)" ACTION=apply INFRA_REPO_REVISION="$(irr)" erb tekton/k8s-env-pipeline-run.yml.erb > output/k8s-env-pipeline-run.yml
	kubectl create -f output/k8s-env-pipeline-run.yml

# make cloud-env-delete p=madhav
cloud-env-delete:
	PERSON=$(p) ACTION=delete INFRA_REPO_REVISION="$(irr)" erb tekton/k8s-env-pipeline-run.yml.erb > output/k8s-env-pipeline-run.yml
	kubectl create -f output/k8s-env-pipeline-run.yml

tekton-pipelineruns-log-recent:
	tkn pipelineruns logs -f $(RECENT_PIPELINERUN_ID)

tekton-pipelineruns-logs-all:
	tkn pipelineruns logs -f -n devops

tekton-pipelineruns-delete-all:
	tkn pipelineruns delete -n devops --all

tekton-resources-k8s-apply:
	kubectl apply -n devops -f tekton/resources/

update-ssh-config:
	$(shell [ ! -d "$(HOME)/.cloud-dev" ] && mkdir $(HOME)/.cloud-dev)
	grep -qxF $(SSH_CONF_LINE) ~/.ssh/config || echo \\n$(SSH_CONF_LINE) >> ~/.ssh/config
	DOMAIN=$(DOMAIN) PERSON="$(p)" SSH_PORT=$(SVC_PORT) SSH_PRIVATE_FILE=$(spf) erb ssh-config.erb > $(SSH_CONF_FILE)
	@echo "\nCloud dev environment ssh config updated. Please select $(p)-cloud-dev to start development."
