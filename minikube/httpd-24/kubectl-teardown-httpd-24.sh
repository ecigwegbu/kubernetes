#!/bin/bash
# Use kubectl to manually tear down the deployed httpd-24 app

kubectl delete -f redhat-com-secrets.yml
kubectl delete -f httpd-24-deploy.yml
kubectl delete -f httpd-24-service.yml
kubectl delete -f httpd-24-volume.yml
