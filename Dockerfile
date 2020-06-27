FROM docker.io/alpine:3.12 AS fetcher
LABEL maintainer="Steve Wade <steven@stevenwade.co.uk>"

ARG KUBELET_VERSION="Unknown"
ARG KUBELET_SHA="Unknown"
ARG ARCH=amd64

RUN apk add curl && \
  curl -L https://dl.k8s.io/${KUBELET_VERSION}/kubernetes-node-linux-${ARCH}.tar.gz -o node.tar.gz && \
  echo "${KUBELET_SHA}  node.tar.gz" | sha512sum -c && \
  tar xzf node.tar.gz kubernetes/node/bin/kubectl kubernetes/node/bin/kubelet

FROM us.gcr.io/k8s-artifacts-prod/build-image/debian-iptables:v12.1.0
LABEL maintainer="Steve Wade <steven@stevenwade.co.uk>"

RUN clean-install \
  bash \
  ca-certificates \
  ceph-common \
  cifs-utils \
  e2fsprogs \
  xfsprogs \
  ethtool \
  glusterfs-client \
  iproute2 \
  jq \
  nfs-common \
  socat \
  udev \
  util-linux

COPY --from=fetcher /kubernetes/node/bin/kubelet /usr/local/bin/kubelet
COPY --from=fetcher /kubernetes/node/bin/kubectl /usr/local/bin/kubectl
ENTRYPOINT ["/usr/local/bin/kubelet"]
