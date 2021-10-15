# Scaning OpenShift Container Images prior to install 

## Steps

OCP_RELEASE=4.6.47
PRODUCT_REPO='openshift-release-dev'
LOCAL_SECRET_JSON='pull-secret'
RELEASE_NAME="ocp-release"
ARCHITECTURE=x86_64
LOCAL_REGISTRY='afactory.ocp4.xphyrlab.net:443'
LOCAL_REPOSITORY='ocp4'

```
$ oc46 adm release mirror -a ${LOCAL_SECRET_JSON}  \
     --from=quay.io/${PRODUCT_REPO}/${RELEASE_NAME}:${OCP_RELEASE}-${ARCHITECTURE} \
     --to=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY} \
     --to-release-image=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY}:${OCP_RELEASE}-${ARCHITECTURE} --dry-run
```


docker run \
    -u root --privileged \
    -v /var/lib/containers:/var/lib/containers \
    quay.io/sysdig/secure-inline-scan:2 \
    --storage-type cri-o \
    --sysdig-token 082c6c5e-80dc-4703-ad0f-dfe76e7c93d6 \
    --sysdig-url https://us2.app.sysdig.com \
    localhost/quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:c7779c311b248e5ece4b5aef8fadd4b828c02bb35065812be5bb589f69bea994

podman run \
    -u root --privileged \
    -v /var/lib/containers:/var/lib/containers \
    quay.io/sysdig/secure-inline-scan:2 \
    --storage-type cri-o \
    --sysdig-token 082c6c5e-80dc-4703-ad0f-dfe76e7c93d6 \
    --sysdig-url https://us2.app.sysdig.com \
    localhost/quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:c7779c311b248e5ece4b5aef8fadd4b828c02bb35065812be5bb589f69bea994


https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/4.6.47/release.txt

## References
https://docs.openshift.com/container-platform/4.6/installing/installing-mirroring-installation-images.html


