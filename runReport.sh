#!/bin/bash

# This script will pull the release notes for a given OpenShift release, and pull them locally, then 
# pass them to the sysdig contianer image for scanning and then output the final report for the container

# Set the following variables or this wont work

OCP_RELEASE=4.6.47
SYSDIG_URL=https://us2.app.sysdig.com
SYSDIG_TOKEN=082c6c5e-80dc-4703-ad0f-dfe76e7c93d6
ARCHITECTURE=x86_64
CONTAINER_CLEANUP=Y

# Generate a temp file for download
RELEASE_FILE=$(mktemp -t release)
MANIFEST_FILE=$(mktemp -t manifest)

# trap ctrl-c and cleanup before exit
trap clean_temp_files INT

get_manifests () {
    # Grab the release file
    curl https://mirror.openshift.com/pub/openshift-v4/${ARCHITECTURE}/clients/ocp/${OCP_RELEASE}/release.txt -o ${RELEASE_FILE}
    # Parse the release file and just get the container images 
    # dump them into a temp file
    sed -e '1,/PULL SPEC/ d' ${RELEASE_FILE} | awk '{print $2}' > ${MANIFEST_FILE}
}

scan_container_images () {
    for i in `cat ${MANIFEST_FILE}`
    do 
        CONTAINER_IMAGE=$(mktemp -t image).tar
        docker pull ${i}
        docker save ${i} -o ${CONTAINER_IMAGE}
        docker run --rm \
        -v ${CONTAINER_IMAGE}:/tmp/image.tar \
        quay.io/sysdig/secure-inline-scan:2 \
        --sysdig-url ${SYSDIG_URL} \
        --sysdig-token ${SYSDIG_TOKEN} \
        --storage-type docker-archive \
        --storage-path /tmp/image.tar \
        quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:c7779c311b248e5ece4b5aef8fadd4b828c02bb35065812be5bb589f69bea994
        rm ${CONTAINER_IMAGE}
    done
}

clean_temp_files () {
    rm ${MANIFEST_FILE}
    rm ${RELEASE_FILE}
    return 0
}


get_manifests
scan_container_images
clean_temp_files