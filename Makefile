cloud-env-create:
	PERSON=$(p) ACTION=create INFRA_REPO_REVISION=dev erb tekton/k8s-env-pipeline-run.yml.erb > output/k8s-env-pipeline-run.yml
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
