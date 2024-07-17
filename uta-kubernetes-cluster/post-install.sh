#!/bin/bash

# Path to the Ansible inventory file
INVENTORY_FILE="/etc/ansible/inventory"

# Function to retrieve hostnames from the workers group in the Ansible inventory
get_workers() {
  awk '/\[k8sworkers\]/{flag=1; next} /\[/{flag=0} flag && NF' $INVENTORY_FILE
}

# Function to configure local user and join the node to the cluster
configure_and_join_node() {
  local NODE_NAME=$1
  local JOIN_COMMAND=$2

  # SSH into the node and configure it
  ssh -o StrictHostKeyChecking=no -T ansible@$NODE_NAME << EOF
  echo "Joining $NODE_NAME to the Kubernetes cluster..."
  sudo $JOIN_COMMAND
EOF
}

# Main script execution
main() {
  echo "Setting up kubectl for the local user..."
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  # Set KUBECONFIG for the current session of the script
  export KUBECONFIG=$HOME/.kube/config

  echo "Setting KUBECONFIG environment variable for root..."
  echo "export KUBECONFIG=/etc/kubernetes/admin.conf" | sudo tee -a /root/.bashrc

  # Source the .bashrc to apply changes for the current session for root
  sudo bash -c "source /root/.bashrc"

  # echo "Installing Calico CRDs..."
  # kubectl apply -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
  # kubectl apply -f https://docs.projectcalico.org/manifests/custom-resources.yaml

  echo "Installing network add-on (Calico)..."
  kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml --validate=false

  echo "Retrieving join command..."
  JOIN_COMMAND=$(kubeadm token create --print-join-command)
  echo "Join command: $JOIN_COMMAND"

  echo "Retrieving worker nodes from Ansible inventory..."
  NODE_NAMES=$(get_workers)
  echo "Worker nodes: $NODE_NAMES"

  for NODE_NAME in $NODE_NAMES; do
    configure_and_join_node $NODE_NAME "$JOIN_COMMAND"
  done
}

main
