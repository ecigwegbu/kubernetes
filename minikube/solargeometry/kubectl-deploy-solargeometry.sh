#!/bin/bash

# Create the manifest files for deploying the solargeometry project manually in a Kubernetes cluster

# Get the directory where the current script file is located
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Now you can use $THIS_DIR to reference the script's directory
echo "Running the solargeometry deploy script in: $THIS_DIR"

# Create the Secrets manifest:
kubectl create secret generic solargeometry --dry-run=client -o yaml --from-env-file $HOME/.secrets/SOLARGEOMETRY_ENV_FILE_FAKE.INI > $THIS_DIR/solargeometry-secrets-fake.yml

# Create the deployment:
kubectl create deploy solargeometry --port=5004 --image=igwegbu/solargeometry:latest --replicas=3 --dry-run=client -o yaml > $THIS_DIR/solargeometry-deploy.yml

# Insert the envFrom attribute in the correct location in the deployment YAML
#sed -i '/resources: {}/a\
#        envFrom:\
#        - secretRef:\
#            name: solargeometry' $THIS_DIR/solargeometry-deploy.yml

sed '/resources: {}/a\
        envFrom:\
        - secretRef:\
            name: solargeometry\
        volumeMounts:\
        - mountPath: /myapp/app-data\
          name: solargeometry\
      volumes:\
      - name: solargeometry\
        persistentVolumeClaim:\
          claimName: solargeometry\
' $THIS_DIR/solargeometry-deploy.yml > $THIS_DIR/temp.yml
mv $THIS_DIR/temp.yml $THIS_DIR/solargeometry-deploy.yml

# Create the service:
kubectl create service nodeport solargeometry --node-port=32504 --tcp=5004:5004 --dry-run=client -o yaml > $THIS_DIR/solargeometry-service.yml

# Deploy the app
kubectl apply -f $THIS_DIR/solargeometry-secrets-fake.yml
kubectl apply -f $THIS_DIR/solargeometry-volume.yml
kubectl apply -f $THIS_DIR/solargeometry-deploy.yml
kubectl apply -f $THIS_DIR/solargeometry-service.yml

echo "Please wait..."
sleep 10
kubectl get rs -o wide
kubectl get deploy solargeometry -o wide
