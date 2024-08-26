#!/bin/bash
# Use kubectl to manually tear down the deployed ogivc app

kubectl delete -f ogivc-secrets-fake.yml
kubectl delete -f ogivc-cm.yml
kubectl delete -f ogivc-deploy.yml
kubectl delete -f ogivc-service.yml
