#------------------------------------------------------------------
# Project build information
#------------------------------------------------------------------
PROJNAME := kubelet

KUBELET_VERSION := v1.18.0
KUBELET_SHA := f714f80feecb0756410f27efb4cf4a1b5232be0444fbecec9f25cb85a7ccccdcb5be588cddee935294f460046c0726b90f7acc52b20eeb0c46a7200cf10e351a

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