#!/bin/bash
# Use Helm to install my two apps - solargeometry and ogivc with FAKE secrets

# Install solargeometry
helm install solargeometry solargeometry/solargeometry -f ~/.secrets/SOLARGEOMETRY_ENV_FILE_FAKE.YML

# Install ogivc
helm install ogivc ogivc/ogivc -f ~/.secrets/OGIVC_CM_FILE.YML -f ~/.secrets/OGIVC_SECRET_FILE_FAKE.YML

# wait 5 secods and show the resources
echo 'Please wait...'
sleep 5
kubectl get all -o wide
