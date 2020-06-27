#------------------------------------------------------------------
# Project build information
#------------------------------------------------------------------
PROJNAME := kubelet

KUBELET_VERSION := v1.18.1
KUBELET_SHA := 88a9b68c8cba77fe50751d998117ab632d1e8aa12a45f6bef71a24ee5a8fb6f559d00f129b8682f9d5838671edb6649e3c9caebdf9ce2a37f282f21316a522e0

GCR_REPO := eu.gcr.io/swade1987
GCLOUD_SERVICE_KEY ?="unknown"
GCLOUD_SERVICE_EMAIL := circle-ci@swade1987.iam.gserviceaccount.com
GOOGLE_PROJECT_ID := swade1987
GOOGLE_COMPUTE_ZONE := europe-west2-a

CIRCLE_BUILD_NUM ?="unknown"
IMAGE := $(PROJNAME):$(KUBELET_VERSION)

#------------------------------------------------------------------
# CI targets
#------------------------------------------------------------------

build:
	docker build \
	--build-arg KUBELET_VERSION=$(KUBELET_VERSION) \
	--build-arg KUBELET_SHA=$(KUBELET_SHA) \
	-t $(IMAGE) .

push-to-gcr: configure-gcloud-cli
	docker tag $(IMAGE) $(GCR_REPO)/$(IMAGE)
	gcloud docker -- push $(GCR_REPO)/$(IMAGE)
	docker rmi $(GCR_REPO)/$(IMAGE)

configure-gcloud-cli:
	echo '$(GCLOUD_SERVICE_KEY)' | base64 --decode > /tmp/gcloud-service-key.json
	gcloud auth activate-service-account $(GCLOUD_SERVICE_EMAIL) --key-file=/tmp/gcloud-service-key.json
	gcloud --quiet config set project $(GOOGLE_PROJECT_ID)
	gcloud --quiet config set compute/zone $(GOOGLE_COMPUTE_ZONE)

scan: build
	trivy --light -s "UNKNOWN,MEDIUM,HIGH,CRITICAL" --exit-code 1 $(IMAGE)