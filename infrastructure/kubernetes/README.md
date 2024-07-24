authentik









# principles
http://blog.itaysk.com/2017/11/20/deployment-strategies-defined

# operating systems
os
debian
nix?
    - https://github.com/justinas/nixos-ha-kubernetes?tab=readme-ov-file#non-goals
not guix lmao

kubernetes
    talos
    coreos
    https://k3os.io/




# tailscale
https://tailscale.com/kb/1185/kubernetes#use-the-kubernetes-operator

# RUNNING THIS SHIT
Sure. Install kubeadm on the node, "kubeadm init", install a pod network, then remove the master taint

# single node
https://news.ycombinator.com/item?id=16699465
https://github.com/alexellis/k3sup
https://github.com/k3d-io/k3d
k3s?

# local dev
https://skaffold.dev/
kind
minikube

# ha??

But Kubeadm will still do it. Kops if you're on AWS. GKE if you're on GCP. Just Docker would be easier to set up though, and that's what the OP means.

# research
fly kubernets
    https://news.ycombinator.com/item?id=38685393
https://azure.microsoft.com/en-us/blog/the-microsoft-azure-incubations-team-launches-radius-a-new-open-application-platform-for-the-cloud/
https://news.ycombinator.com/item?id=38687066




# TOP READING
https://news.ycombinator.com/item?id=39272698
https://news.ycombinator.com/item?id=39281058
https://news.ycombinator.com/item?id=39581976
