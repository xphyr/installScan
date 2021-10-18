# Scaning OpenShift Container Images prior to install 

## PreRequisites

1) you will need a pull secret. Log into https://console.redhat.com/openshift/install/pull-secret and download your pull secret
2) you will need a sysdig api-key
   1) You can get this by logging into sysdig-secure here https://us2.app.sysdig.com/secure/#/settings/user and get the api-key, this will be used later

You will need to log into quay with the username/password that is in the pull secret that you downloaded in step 1. In order to do this we will extract the generated username/password from the pull-secret and then manually log into quay with this secret. 

NOTE: If you are using a Linux box for this, you can manually update the ~/.docker/config.json with the login information from the pull secret. Windows machines and OSX machines use a seperate keystore and the password must be added via the docker command.

### Log in to Quay.io

Run the following command to extract the quay username/password from the pull secret:

```
jq '.auths."quay.io".auth' pull-secret | tr -d '"' | base64 -d
```

This will output a username password in the format \<username\>:\<password\>

Use the docker command and login to quay copy and paste the username and password from the output above

```
$ docker login -u \<username\> -p \<password\> quay.io
```

Ensure that login is succesful before proceeding.

## Run the script



## References
https://docs.openshift.com/container-platform/4.6/installing/installing-mirroring-installation-images.html

https://sysdiglabs.github.io/secure-inline-scan-examples/

https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/4.6.47/release.txt
