#!/bin/bash

# Get the directory where the current script file is located
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Now you can use $THIS_DIR to reference the script's directory
echo "Running the ogivc deploy script in: $THIS_DIR"

mkdir -p $HOME/.secrets
cp -r $THIS_DIR/.secrets-fake/* $HOME/.secrets/

# Create the manifest files for deploying the ogivc project manually in a Kubernetes cluster

# Create the Secrets manifest:
kubectl create secret generic ogivc --dry-run=client -o yaml --from-env-file $HOME/.secrets/OGIVC_SECRET_FILE_FAKE.INI > $THIS_DIR/ogivc-secrets-fake.yml

# Create the ConfigMap manifest:
kubectl create cm ogivc --dry-run=client -o yaml --from-env-file $HOME/.secrets/OGIVC_CM_FILE.INI > $THIS_DIR/ogivc-cm.yml

# Create the deployment:
kubectl create deploy ogivc --port=5004 --image=igwegbu/ogivc:latest --replicas=3 --dry-run=client -o yaml > $THIS_DIR/ogivc-deploy.yml

# Insert the envFrom attribute in the correct location in the deployment YAML
sed '/resources: {}/a\
        envFrom:\
        - secretRef:\
            name: ogivc \
        - configMapRef: \
            name: ogivc \
' $THIS_DIR/ogivc-deploy.yml > $THIS_DIR/temp.yml

mv $THIS_DIR/temp.yml $THIS_DIR/ogivc-deploy.yml

# Create the service:
kubectl create service nodeport ogivc --node-port=32300 --tcp=3300:3300 --dry-run=client -o yaml > $THIS_DIR/ogivc-service.yml

# Deploy the app
kubectl apply -f $THIS_DIR/ogivc-secrets-fake.yml
kubectl apply -f $THIS_DIR/ogivc-cm.yml
kubectl apply -f $THIS_DIR/ogivc-deploy.yml
kubectl apply -f $THIS_DIR/ogivc-service.yml

echo "Please wait..."
sleep 15
kubectl get rs -o wide
kubectl get deploy ogivc -o wide
kubectl get pod -o wide
kubectl get svc -o wide

