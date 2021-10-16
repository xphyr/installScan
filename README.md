# Scaning OpenShift Container Images prior to install 

## PreRequisites

1) you will need a pull secret. Log into https://console.redhat.com/openshift/install/pull-secret and download your pull secret
2) you will need a sysdig api-key
   1) You can get this by logging into sysdig-secure here https://us2.app.sysdig.com/secure/#/settings/user and get the api-key, this will be used later



## Steps - New

docker pull quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:c7779c311b248e5ece4b5aef8fadd4b828c02bb35065812be5bb589f69bea994
docker save quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:c7779c311b248e5ece4b5aef8fadd4b828c02bb35065812be5bb589f69bea994 -o image.tar
docker run --rm \
    -v ${PWD}/image.tar:/tmp/image.tar \
    quay.io/sysdig/secure-inline-scan:2 \
    --sysdig-url https://us2.app.sysdig.com \
    --sysdig-token 082c6c5e-80dc-4703-ad0f-dfe76e7c93d6 \
    --storage-type docker-archive \
    --storage-path /tmp/image.tar \
    quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:c7779c311b248e5ece4b5aef8fadd4b828c02bb35065812be5bb589f69bea994

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

### OSX
docker run --rm \
    -v /var/run/docker.sock.raw:/var/run/docker.sock \
    quay.io/sysdig/secure-inline-scan:2 \
    --sysdig-url https://us2.app.sysdig.com \
    --sysdig-token 082c6c5e-80dc-4703-ad0f-dfe76e7c93d6 \
    --storage-type docker-daemon \
    --storage-path /var/run/docker.sock \
    openshift-release-dev/ocp-v4.0-art-dev@sha256:c7779c311b248e5ece4b5aef8fadd4b828c02bb35065812be5bb589f69bea994


## References
https://docs.openshift.com/container-platform/4.6/installing/installing-mirroring-installation-images.html

https://sysdiglabs.github.io/secure-inline-scan-examples/

https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/4.6.47/release.txt
