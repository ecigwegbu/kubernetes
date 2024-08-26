#!/bin/bash
# This batch job tears down the solargeometry and ogivc apps that were deployed using kubectl

# Use kubectl to manually tear down the deployed solargeometry app
kubectl delete -f solargeometry/solargeometry-secrets-fake.yml
kubectl delete -f solargeometry/solargeometry-deploy.yml
kubectl delete -f solargeometry/solargeometry-service.yml

# Use kubectl to manually tear down the deployed ogivc app
kubectl delete -f ogivc/ogivc-secrets-fake.yml
kubectl delete -f ogivc/ogivc-cm.yml
kubectl delete -f ogivc/ogivc-deploy.yml
kubectl delete -f ogivc/ogivc-service.yml
