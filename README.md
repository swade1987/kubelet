# Kubelet

`kubelet` provides a [container image](https://quay.io/repository/poseidon/kubelet) packaging the upstream Kubernetes `kubelet` and dependencies, for use on container-optimized OS distributions. 

## Repositories

Images can be found at [https://eu.gcr.io/swade1987/kubelet](https://eu.gcr.io/swade1987/kubelet).

The container is also scanned by [https://github.com/aquasecurity/trivy](https://github.com/aquasecurity/trivy) as part of CI.

## Packages

The [debian-iptables](https://github.com/kubernetes/kubernetes/tree/master/build/debian-iptables) base provides `conntrack`, `ebtables`, `ipset`, `kmod`, and `netbase`.

Kubelet also requires:

* `ca-certificates` - https://github.com/kubernetes/kubernetes/pull/7755
* `ceph-common` - https://github.com/kubernetes/kubernetes/pull/34416
* `cifs-utils` - https://github.com/kubernetes/kubernetes/pull/34416
* `e2fsprogs` (`mkfs.ext4`) - https://github.com/kubernetes/kubernetes/issues/52789
* `xfsprogs` - https://github.com/kubernetes/kubernetes/pull/56937
* `ethtool` - https://github.com/kubernetes/kubernetes/pull/18273
* `glusterfs-client` - https://github.com/kubernetes/kubernetes/pull/32686
* `jq` - https://github.com/coreos/bugs/issues/1706
* `kmod` (`modprobe`) - https://github.com/kubernetes/kubernetes/pull/53642
* `nfs-common` - https://github.com/kubernetes/kubernetes/pull/30320
* `udev` (`udevadm`)- https://github.com/kubernetes/kubernetes/pull/61357

### kubectl

`kubectl` (no dependencies) is also included for convenience (e.g. use pre-pulled Kubelet image to `kubectl delete node` on preemption)
