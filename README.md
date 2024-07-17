# Ansible Collection - igwegbu.kubernetes_cluster

UTA Ansible Lab 2.1.2 - Kubernetes Cluster

This project creates a Kubernetes Cluster consisting of a Control Plane and up to 26 worker nodes. All nodes are Red Hat Linux Virtual Machines.

The base infrastructure is provisioned using Vagrant (with Ruby, PowerShell and Bash scripts), while the configuration is handled by Ansible with some Bash scripting. The entire process is fully automated. Just download the Vagrantfile and save it as Vagrantfile (without any extension!) and launch it (vagrant up) from your Windows PowerShell terminal, with Oracle Virtual Box already running. Provide your Red Hat subscription credentials and (optionally) specify the number of worker nodes desired. Then sit back and relax for ca. 10 minutes and watch a fully functional and configured Kubernetes Cluster and Ansible Training Lab get deployed just by launching a single Vagrantfile from your Windows PowerShell terminal. Pure Magic :)

The control plane and worker nodes have full password-less key-based authentication connectivity for the user 'ansible' (with initial password: 'ansible').

The infrastructure can either be used as a Kubernetes Cluster or simply as an Ansible playground/sandbox. The original lab was built for the latter use case, but this current extensive version is a full-scale home lab built with Kubeadm for Kubernetes workloads, either as a personal lab or for production worksloads, for the Developer / DevOps professional who wishes to advance beyond the basic Minikube :)

Updates and upgrades are expected in the near future, with more formal documentation.

Note: For system requirements and important usage formation, please PLEASE READ THE GUIDANCE NOTES at the top of the Vagrantfile.
As a minimum, for the default cluster with a control plane and two worker nodes, you will require a Windows PC with at leaset 6 CPUs, 10 GB RAM and 50 GB of free disk space. Adjust your cluster size based on your system resources. (For a basic PC with 4 CPUs and 8 GB RAM, you could probably handle a cluster with one control plane host and one worker node.)

To log into your cluster after the provisioning, use Putty and ssh into the control plane (192.168.56.30) as user 'ansible' and initial password 'ansible'. 
Then to view your cluster run:

$ cd ~/bin && ls -l && kubectl get node -o wide

To learn about the magic of Kubernetes, visit https://kubernetes.io.

Any comments/queries? Let me know on my LinkedIn page! Plus follow to be among the first to get my future automation tips!

Elias Igwegbu
https://www.linkedIn.com/in/elias-igwegbu.
Automation Ambassador. Work Less. Play More™.
(Author of CBVmatic™)
