UTA Ansible Lab 2.0 - Kubernetes Cluster

This project creates a Kubernetes Cluster consisting of a Control Plane and up to 26 worker nodes. All nodes are Red Hat Linux Virtual Machines.

The base infrastructure is provisioned using Vagrant (with Ruby, PowerShell and Bash scripts), while the configuration is handled by Ansible with some Bash scripting. The entire process is fully automated. Just download the Vagrantfile and save it as Vagrantfile (without any extension!) and launch it (vagrant up) from your Windows PowerShel termninal, with Oracle Virtual Box already running. Provide your Red Hat subscription credentials and (optionally) specify the number of worker nodes desired. Then sit back and relax for ca. 10 minutes and watch a fully functional and configured Kubernets Cluster and Ansible Training Lab get deployed just by launching a single Vagrantfile from your Windows PowerShell terminal. Pure Magic :)

The control plane and worker nodes have full password-less key-based authentication connectivity for the user 'ansible' (with initial password: 'ansible').

The infrastructure can either be used as a Kubernetes Cluster or simply as an Ansible playground/sandbox. The original lab was built for the latter use case, but this current extensive version is a full-scale home lab built with Kubeadm for Kubernetes workloads, either as a personal lab or for production worksloads, for the Developer / DevOps professional who wishes to advance beyond the basic Minikube :)

Updates and upgrades are expected in the near future, with a more formal documentation.

Note: For system requirements and important usage formation, please PLEASE READ THE GUIDANCE NOTES at the top of the Vagrantfile.

Any comments/queries? Let me know on my LinkedIn page!

Elias Igwegbu
https://www.linkedIn.com/in/elias-igwegbu.
Automation Ambassador. Work Less. Play More™.
(Author)
