#!/bin/bash
# Use kubectl to manually tear down the deployed solargeometry app

kubectl delete -f solargeometry-secrets-fake.yml
kubectl delete -f solargeometry-deploy.yml
kubectl delete -f solargeometry-service.yml
