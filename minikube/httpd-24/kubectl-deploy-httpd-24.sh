#!/bin/bash
# Deploy httpd-24 web server based on a Red Hat Registry image
# Demonstrates use of imagePullSecrets attribute and local persistent volume

# Get the directory where the current script file is located
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Now you can use $THIS_DIR to reference the script's directory
echo "Running the http-24 deploy script in: $THIS_DIR"

# Create the imagePullSecrets file(s) 
kubectl create secret docker-registry redhat-com --docker-server=https://registry.access.redhat.com --docker-username=$RHSM_USER --docker-password=$RHSM_PASS --dry-run=client -o yaml > $THIS_DIR/redhat-com-secrets.yml
# kubectl create secret docker-registry redhat-io --docker-server=https://registry.redhat.io --docker-username=$RHSM_USER --docker-password=$RHSM_PASS --dry-run=client -o yaml > $THIS_DIR/redhat-io-secrets.yml
# podman login --authfile=$HOME/.config/containers/auth.json registry.access.redhat.com
# kubectl create secret generic redhat-com --from-file=.dockerconfigjason=$HOME/.config/containers/auth.json --dry-run=client -o yaml > $THIS_DIR/redhat-com-secrets.yml
kubectl apply -f $THIS_DIR/redhat-com-secrets.yml

# Deploy the persistent volume (for the website content)
kubectl apply -f $THIS_DIR/httpd-24-volume.yml

# Create the Deployment manifest
# kubectl create deploy httpd-24 --port=8080 --image=registry.redhat.io/rhel9/httpd-24:latest --replicas=1 --dry-run=client -o yaml > $THIS_DIR/httpd-24-deploy.yml
kubectl create deploy httpd-24 --port=8080 --image=registry.access.redhat.com/ubi9/httpd-24:latest --replicas=1 --dry-run=client -o yaml > $THIS_DIR/httpd-24-deploy.yml

# sleep 10

# Insert the volumeMounts and volumes attributes in the correct location in the deployment YAML
sed -i '/resources: {}/a\
        volumeMounts:\
        - mountPath: /var/www\
          name: httpd-24\
      imagePullSecrets:\
        - name: redhat-com\
      volumes:\
      - name: httpd-24\
        persistentVolumeClaim:\
          claimName: httpd-24\
' $THIS_DIR/httpd-24-deploy.yml

# mv $THIS_DIR/temp.yml $THIS_DIR/httpd-24-deploy.yml

# Apply the Deployment manifest
kubectl apply -f $THIS_DIR/httpd-24-deploy.yml

sleep 5

# Expose the Deployment and apply the service
kubectl expose deployment httpd-24 --type=NodePort --port=8080 --target-port=8080 --dry-run=client -o yaml > $THIS_DIR/httpd-24-service.yml
# kubectl create service nodeport httpd-24 --node-port=32080 --tcp=8080:8080 --dry-run=client -o yaml > $THIS_DIR/httpd-24-service.yml 

kubectl apply -f $THIS_DIR/httpd-24-service.yml

# View resources
echo "Please wait..."
sleep 15
echo -e "\n####### Nodes ########"
kubectl get node -o wide
echo -e "\n####### Deployments ########"
kubectl get deploy -o wide
echo -e "\n####### Services ########"
kubectl get svc -o wide
echo -e "\n####### Pods ########"
kubectl get pod -o wide
echo

# Display Page
# sleep 15
# HTTPD24_SVC=$(minikube service httpd-24 --url)
# curl -I $HTTPD24_SVC
K8s_PORT=$(kubectl get service httpd-24 -o wide | grep httpd-24 | awk '{print $5}' | awk -F: '{print $2}' | awk -F/ '{print $1}')
echo "knode.igwegbu.tech:$K8s_PORT"
curl knodea.igwegbu.tech:$K8s_PORT
