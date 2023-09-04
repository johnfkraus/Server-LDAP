# Certified Kubernetes Application Developer (CKAD) - A Cloud Guru

Other courses/sample exams:

https://kodekloud.com/courses/ultimate-certified-kubernetes-administrator-cka-mock-exam/?utm_medium=email&_hsmi=244174706&_hsenc=p2ANqtz-8VeXWZ8lWoaps3w54GYKwTuGGyOXOPuyYFpUwpLokWhcgJRcR2iebF2FCXm7C2fnK9Dx8CbhHxq24IFs15cN6QkJpoAg&utm_content=244173916&utm_source=hs_email


## CHAPTER 1 - Introduction

### 1.1 Course Introduction

#### Shortcuts
```
# [Get all resources in all namespaces](https://linuxhint.com/get-all-resources-kubectl-namespace/)

k get all -A

kubectl api-resources --verbs=list --namespaced -o name  | xargs -n 1 kubectl get --show-kind --ignore-not-found -n kube-node-lease
```
Start a long-running container and then [exec into it.](https://kubernetes.io/docs/tasks/debug/debug-application/get-shell-running-container/):

The following command creates a single Pod in default Namespace and will execute sleep command with infinity argument.  Having a process that runs in foreground keeps container alive.

You can interact with Pod by running kubectl exec command.
```
kubectl run ubuntu --image=ubuntu --restart=Never --command sleep infinity

kubectl exec ubuntu -it -- bash

k ... dry-run=client


```
#### Internalize resource short names.  List short names of resources:
```
kubectl api-resources
k get apiservice
```
[If you're curious how kubectl api-resources command builds such a list of supported resources, here is a nice trick showing what API calls were made by any kubectl command:]
(https://iximiuz.com/en/posts/kubernetes-api-structure-and-terminology/)
```
kubectl api-resources -v 6
```
-v 6 means "extra verbose logging"

#### Delete Kubernetes objects:

To start over or delete misconfigured K8s objects without wasting precious exam time:
```
kubectl delete pod nginx --grace-period=0 --force
```
#### Find object information

- Combine `describe` command with other Unix commands using a pipe.  
- Use grep -C to render lines before and after the search term.
```
kubectl describe pods | grep -C 10 "author=John Doe"
kubectl get pods -o yaml | grep -C 5 labels:
```
#### Discover command options using command-specific kubectl --help.
```
kubectl create --help
```
#### Use `explain` to explore the fields of every Kubernetes object.
```
kubectl explain pods.spec
```
It is typical for Kubernetes Objects to have the spec (desired state) and status (actual state) fields.
https://iximiuz.com/en/posts/kubernetes-api-structure-and-terminology/

Dealing with the Kubernetes API from code involves a lot of Object manipulation, so having a solid understanding of a common Object structure is a must. The kubectl explain command can help you with that.  `kubectl explain` can be called on resources and nested fields:
```
kubectl explain deployment.spec.template

KIND:     Deployment
VERSION:  apps/v1

RESOURCE: template <Object>

DESCRIPTION:
     Template describes the pods that will be created.
     PodTemplateSpec describes the data a pod should have when created from a
     template

FIELDS:
   metadata <Object>
     Standard object's metadata. More info:
     https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata

   spec <Object>
     Specification of the desired behavior of the pod. More info:
     https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
```
#### Kubernetes Context

A Kubernetes context is an entity defined inside kubeconfig to alias cluster parameters with a human-readable name.  A Kubernetes context only applies to the client side.  The Kubernetes API server itself doesn’t recognize context the way it does other objects such as pods, deployments, or namespaces.  See 'kubectl config -h' for help and examples.

A Kubeconfig is a YAML file with all the Kubernetes cluster details, nodes, and secret token to authenticate the cluster.

When you use kubectl, it uses the information in the kubeconfig file to connect to the kubernetes cluster API.
```
k config current-context
kubernetes-admin@kubernetes

k config get-contexts

CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE
*         kubernetes-admin@kubernetes   kubernetes   kubernetes-admin

In Docker desktop, k config get-contexts returns:
CURRENT   NAME             CLUSTER          AUTHINFO         NAMESPACE
*         docker-desktop   docker-desktop   docker-desktop
          minikube         minikube         minikube         default

kubectl config get-contexts
```
Switch contexts:
```
kubectl config use-context [CONTEXT-NAME]

k config view

apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://172.31.124.84:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED
cloud_user@control:~$
```
#### Setting the Namespace preference

Namespace defines the space within which each name must be unique. An empty Namespace is equivalent to the "default" Namespace, but "default" is the canonical representation.

Not all objects are required to be scoped to a Namespace - the value of field for those objects will be empty.

Must be a DNS_LABEL. Cannot be updated. More info: http://kubernetes.io/docs/user-guide/namespaces

You can permanently save the Namespace for all subsequent kubectl commands in that context.  (However saving the Namespace may break the verify.sh script.)
```
kubectl config set-context --current --namespace=<insert-namespace-name-here>

# Validate the Namespace:

kubectl config view --minify | grep namespace:

kubectl config view

k config get-contexts
```
#### Resources:

See page 11 of the O'Reilly CKAD book for links.


### 1.2 About the Exam

https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/

Study guide: https://acloudguru-content-attachment-production.s3-accelerate.amazonaws.com/1643315148640-CKAD_Study_Guide.pdf

https://www.examslocal.com/ScheduleExam/Home/CompatibilityCheck

Allowed documentation during the exam:

[kubernetes.io/docs](https://kubernetes.io/docs/)
[github.com/kubernetes](https://github.com/kubernetes/)
[kubernetes.io/blog](https://kubernetes.io/blog/)
[helm.sh/docs](https://helm.sh/docs/)

Learn the k8s objects: pods, deployments, services, etc.

#### [Pods](https://kubernetes.io/docs/concepts/workloads/pods/)

Pod - the smallest deployable units of computing that you can create and manage in Kubernetes.

A Pod (as in a pod of whales or pea pod) is:
- a group of one or more containers,
  - with shared storage and
  - network resources, and a
  - specification for how to run the containers.
- A Pod's contents are always *co-located* and *co-scheduled*, and run in a *shared context*.  
- A Pod models an application-specific "logical host": it contains one or more application containers which are relatively tightly coupled.
- In non-cloud contexts, applications executed on the same physical or virtual machine are analogous to cloud applications executed on the same *logical host*.

- Pods colocation and codependency: In a microservices setting or a tightly coupled application stack, certain pods should be collocated on the same machine to improve performance, avoid network latency, and connection failures. For example, it’s a good practice to run a web server on the same machine as an in-memory cache service or database.

- In Kubernetes, scheduling refers to making sure that Pods are matched to Nodes so that Kubelet can run them.

A Pod can contain:

- application containers,
- init containers that run during Pod startup, and
- ephemeral containers that you can also inject for debugging if offered by your cluster.

#### Creating Pods [from CKAD Study Guide]

Create a Pod imperatively (from the command line):
```
k run hazelcast --image=hazelcast/hazelcast --restart=Never --port=5701 --env="DNS_DOMAIN=cluster" --labels="app=hazelcast,env=prod"
```
Create a pod declaratively (use a manifest file):
```
apiVersion: v1
kind: Pod
metadata:
  name: hazelcast
  labels:
    app: hazelcast
    env: prod
spec:
  containers:
  - env:
    - name: DNS_DOMAIN
      value: cluster
    ports:
    - containerPort: 5701
    name: hazelcast
    image: hazelcast/hazelcast
  restartPolicy: Never

k describe pods hazelcast
k logs hazelcast
k exec -it hazelcast -- /bin/sh
k exec hazelcast -- env
k delete pod hazelcast --grace-period=0 --force
k delete -f pod.yml
```


### 1.3 CKAD Exam Updates

Latest changes to CKAD version 1.24.

- Uses k8s version 1.24.
- PSI Bridge Proctoring Platform using PSI secure browser.  
- Documentation links but no personal bookmarks.
- Only one monitor allowed.
- Don't need to wait to check in.

As of 2/13/23, my control node has:
```
k version --short
Flag --short has been deprecated, and will be removed in the future. The --short output will become the default.
Client Version: v1.24.0
Kustomize Version: v4.5.4
Server Version: v1.24.0
```

### 1.4 Building a Kubernetes Cluster (Hands-on Walk Through) - Version 2

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

kubeadm - a tool to simplify setting up a k8s cluster

If you are using the acloudguru.com cloud playground, create three Ubuntu servers with the following settings:

Distribution: Ubuntu 20.04 Focal Fossa LTS Size: medium

Login to servers:
```
ssh cloud_user@[public ip address]
```
new password: bananaban

For convenience when using sudo:
- update editor for visudo to use vim instead of nano
- add line to sudoers file:
```
sudo update-alternatives --config editor

There are 4 choices for the alternative editor (providing /usr/bin/editor).

  Selection    Path                Priority   Status
------------------------------------------------------------
* 0            /bin/nano            40        auto mode
  1            /bin/ed             -100       manual mode
  2            /bin/nano            40        manual mode
  3            /usr/bin/vim.basic   30        manual mode
  4            /usr/bin/vim.tiny    15        manual mode

Choose 3

sudo visudo
cloud_user ALL=(ALL) NOPASSWD: ALL
```
#### hostnamectl

Set an appropriate hostname for each node. On the control plane node:

`sudo hostnamectl set-hostname control`

On the first worker node:

`sudo hostnamectl set-hostname worker1`

On the second worker node:

`sudo hostnamectl set-hostname worker2`

```
sudo hostnamectl set-hostname control
sudo hostnamectl set-hostname worker1
sudo hostnamectl set-hostname worker2
```
#### hosts file
```
sudo vi /etc/hosts
```
On all three nodes, set up the hosts file to enable all the nodes to reach each other using the hostnames you set (above).

In the '/etc/hosts' file of all three servers, add the private IP addresses of all three servers and the hostnames you  created.

On all three nodes, add the following entries at the end of the hosts file. You will need to supply/substitute the actual private IP address for each node.

Log out of all three servers and log back to allow the host file changes to take effect.

```bash
sudo vi /etc/hosts
<control plane node private IP>   control
<worker node 1 private IP>        worker1
<worker node 2 private IP>        worker2

172.31.124.84  control
172.31.126.155 worker1
172.31.119.124 worker2

```
Log out and back in to all three servers.
```
exit
ssh cloud_user@#.#.#.#
```

#### containerd (all three servers)

Complete script follows.

Install and configure containerd on all three servers.

##### Enable kernel modules that will load on startup (all three nodes)

You need to load some kernel modules and modify some system settings as part of process.

**containerd** is available as a daemon for Linux and Windows.  containerd manages the complete container lifecycle of its host system:

- image transfer and storage,  
- container execution and supervision
- low-level storage to network attachments and beyond.

Containerd was designed to be used by Docker and Kubernetes as well as any other container platform that wants to abstract away syscalls or OS specific functionality to run containers on linux, windows, solaris, or other OSes.

containerd provides:
- push and pull functionality
- image management  
- container lifecycle APIs to create, execute, and manage containers and their tasks.
- an entire API dedicated to snapshot management.  
- everything that you need to build a container platform without having to deal with the underlying OS details.  

containerd provides a versioned and stable API that will have bug fixes and security patches backported.

  "Backporting" is the process of making new software run on something old. A version of something new that's been modified to run on something old is called a "backport".

  Backporting is when a software patch or update is taken from a recent software version and applied to an older version of the same software. A backport is most commonly used to address security flaws in legacy software or older versions of the software that are still supported by the developer.

##### Enable kernel modules (all three servers)

Enable kernel modules that will load on startup.
```bash
cat << EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
```
  The tee command reads from the standard input and writes to both standard output and one or more files at the same time. tee is mostly used in combination with other commands through piping.

  Syntax: tee [OPTIONS] [FILE]

Immediately enable the same modules currently without having to restart the server:

```
sudo modprobe overlay
sudo modprobe br_netfilter
```
##### Set up system-level networking configurations (all three servers)

Set up some system-level networking configurations that k8s needs:
```
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
```

Apply the above configs immediately without restarting:
```
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
```
Apply configurations immediately:
```
sudo sysctl --system
```
##### Install containerd (all three servers).
```
sudo apt-get update && sudo apt-get install -y containerd
```
Make a configuration file for containerd:
```
sudo mkdir -p /etc/containerd
```
Create the default configuration and pipe the configuration into a config file:
```
sudo containerd config default | sudo tee /etc/containerd/config.toml
```
To make sure we are  using the new configuration, restart containerd.
```
sudo systemctl restart containerd
```

#### Install Kubernetes
##### Disable swap

On all nodes, disable swap.  Kubernetes requires swap to be disabled.

`sudo swapoff -a`

##### Install kubeadm, kubelet, and kubectl on all three servers

Get required packages for the install.  Some may be already installed but they are listed in the k8s documentation as part of the install process.   to make sure they are installed...

```bash
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
```
Set up the package repository for k8s packages:.  Download gpg key for the repository and add the key.
```
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
```
Create a file named 'kubernetes.list' consisting of one line: "deb https://apt.kubernetes.io/ kubernetes-xenial main".  The kubernetes.list file has a reference to the k8s repository.

```
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/  kubernetes-xenial main
EOF
```
Update the local package listings:
```
sudo apt-get update
sudo apt-get install -y kubelet=1.24.0-00 kubeadm=1.24.0-00 kubectl=1.24.0-00
```
Prevent packages from being automatically upgraded:
```
sudo apt-mark hold kubelet kubeadm kubectl
```
REPEAT the process for the worker nodes:
- Enable kernel modules.
- Install and configure containerd and k8s.
- Etc.

Repeating...
```bash
cat << EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system
sudo apt-get update && sudo apt-get install -y containerd

sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
sudo swapoff -a
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/  kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet=1.24.0-00 kubeadm=1.24.0-00 kubectl=1.24.0-00
sudo apt-mark hold kubelet kubeadm kubectl
```

##### Initialize cluster (control plane only)

On the control plane node only, initialize the cluster and set up kubectl access.  Some of these command require a few minutes to run.

```bash
sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.24.0
```

`--pod-network-cidr 192.168.0.0/16` is an IP address range that we will use for the internal pod network.  the network plugin will require IP range.

Repeating with log output...
```
sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.24.0

[init] Using Kubernetes version: v1.24.0
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform action in beforehand using 'kubeadm config images pull'
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [control kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 172.31.124.84]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [control localhost] and IPs [172.31.124.84 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [control localhost] and IPs [172.31.124.84 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". can take up to 4m0s
[apiclient] All control plane components are healthy after 22.004203 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in Namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node control as control-plane by adding the labels: [node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
[mark-control-plane] Marking the node control as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule node-role.kubernetes.io/control-plane:NoSchedule]
[bootstrap-token] Using token: k759qr.ybfxr94c1hebfjnb
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 172.31.124.84:6443 --token k759qr.ybfxr94c1hebfjnb \
	--discovery-token-ca-cert-hash sha256:db9407d30d9e5153d69059cda5b612d24254aaf7edf131c3258affbd172f6dc8

[END OF LOG OUTPUT]

```

To start using your cluster, you need to run the following as a regular user.  The following commands are output as logs from the 'kubeadm init' command above:
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config  
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
Alternatively, if you are the root user, you can run:
```
export KUBECONFIG=/etc/kubernetes/admin.conf
```

```
kubectl get nodes

kubectl get nodes
NAME      STATUS     ROLES           AGE    VERSION
control   NotReady   control-plane   6m3s   v1.24.0

```

##### Error
sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.24.0
invalid or incomplete external CA: failure loading key for apiserver: couldn't load the private key file /etc/kubernetes/pki/apiserver.key: open /etc/kubernetes/pki/apiserver.key: no such file or directory
To see the stack trace of error execute with --v=5 or higher

https://stackoverflow.com/questions/66213199/config-not-found-etc-kubernetes-admin-conf-after-setting-up-kubeadm-worker

##### Fix:
```
rename /etc/kubernetes/kubectl.conf to admin.conf

mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Verify the cluster is working.

```
kubectl get nodes`

NAME      STATUS     ROLES           AGE    VERSION
control   NotReady   control-plane   6m3s   v1.24.0
```

Set up kubeconfig so you can interact with the cluster -- the commands were printed to the console.

Test:
```
kubectl get nodes

NAME                           STATUS     ROLES           AGE   VERSION
297e090ecf1c.mylabserver.com   Ready      control-plane   19h   v1.24.0
297e090ecf2c.mylabserver.com   NotReady   <none>          19h   v1.24.0
297e090ecf3c.mylabserver.com   NotReady   <none>          19h   v1.24.0
```

Status should be NotReady because we have not yet configured the networking plugin.  

#### Install Calico network add-on (control server only)

BROKEN: `kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml`

`kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml`

Source: https://forum.linuxfoundation.org/discussion/860981/lab-3-1-install-kubernetes-calico-url-404

##### Join worker nodes to cluster

Get the join command (the command is also printed during kubeadm init. Feel free to copy the command from the terminal output from kubeadm init).

Join the worker nodes to the cluster.  We need a join command with a token.  To obtain the command to join the workers to the cluster execute the following command:

`kubeadm token create --print-join-command`

```
cloud_user@worker1:~$ sudo kubeadm join 172.31.124.84:6443 --token ftl63r.1c034xhos4f390zi --discovery-token-ca-cert-hash sha256:db9407d30d9e5153d69059cda5b612d24254aaf7edf131c3258affbd172f6dc8
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

the node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see node join the cluster.

```

The required command is returned to the control server console.  Run the command as root in the worker node consoles.
Copy the join command from the control plane node. Run the join command on each worker node as root (i.e. with sudo ).  For example:

```
sudo kubeadm join 172.31.118.144:6443 --token bukfc7.fmxpqgtthck29eob --discovery-token-ca-cert-hash sha256:5dd8386e1a8c0e389c295c731321a84d3af0731e994f52c195e34d2bf3eb7381

sudo kubeadm join 172.31.118.144:6443 --token 5x1rgz.0s9ycyiguhj33m70 --discovery-token-ca-cert-hash sha256:5dd8386e1a8c0e389c295c731321a84d3af0731e994f52c195e34d2bf3eb7381
```

Your Kubernetes control-plane has initialized successfully!

On the control plane node, verify all nodes in your cluster are ready.  Some time may elapse before all of the nodes to enter the READY state.

```
kubectl get nodes

# You should see the hostnames you created: control, worker1 and worker2!

 kubectl get nodes
NAME      STATUS     ROLES           AGE   VERSION
control   Ready      control-plane   12m   v1.24.0
worker1   NotReady   <none>          37s   v1.24.0
worker2   NotReady   <none>          28s   v1.24.0

# after a while:

kubectl get nodes
NAME      STATUS   ROLES           AGE   VERSION
control   Ready    control-plane   13m   v1.24.0
worker1   Ready    <none>          65s   v1.24.0
worker2   Ready    <none>          56s   v1.24.0

```
Section 1.4 Done.

?????
You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:
```
kubeadm join 172.31.26.38:6443 --token 9dv1vp.t3kavsa35oim9i44 \
	--discovery-token-ca-cert-hash sha256:dd791d57b2a72f13e23e0553e25a1e01c5f1b42ebb9c40383734b8533fe9e6ba
cloud_user@control

sudo kubeadm join ....
```
Test the cluster from the control node command line (a few minutes might elapse before the worker nodes are ready):
```
kubeadm get nodes
```
Set up kubectl auto-completion in the bash shell.  (Source: https://spacelift.io/blog/kubectl-auto-completion)
```
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null

echo 'complete -o default -F __start_kubectl k' >>~/.bashrc

source ~/.bashrc

```

K8s cluster deployment is done.


### 1.5 Application Development in Kubernetes Overview

The CKAD exam certifies that you can design, build, configure, and expose cloud-native applications for k8s.  You have the skills necessary to develop and manage apps in a k8s environment.

Major concepts:

Designing and building applications.

Deployment - how to get new code into the k8s environment.

Observability and Maintenance - ways to gather information about the apps and troubleshoot issues.

Environment, Configuration and Security -

Services and Networking - how k8s facilitates network communication with the app components.

Passing the CKAD exam certifies that the user can design, build, configure and expose cloud-native applications for K8s.

k8s is first and foremost a platform for running and managing applications.

We will be exploring how the features of k8s can be used to build applications that are reliable, manageable and secure.

Initial demo: lab server passwords = wordpass1


## CHAPTER 2 Application Design and Build

### 2.1 Application Design and Build Intro

Images - What are container images and how do we create them?

Jobs and CronJobs - Kubernetes tools that allow us to do one-time and scheduled job executions using Kubernetes containers.

Multi-container Pods - more than one container in a Pod

init containers - container processes that run when a Pod starts up

Container storage - external storage for containers, including ephemeral volumes and PersistentVolumes.


### 2.2 Building Container Images

[Lesson Reference](https://acloudguru-content-attachment-production.s3-accelerate.amazonaws.com/1648649791669-1077%20-%20S02L02%20Building%20Container%20Images.pdf)

[Lesson Reference - local file](PDF/S02L02_Building_Container_Images.pdf)

[Install Docker engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

[docker build](https://docs.docker.com/engine/referencecommandline/build/)

[Dockerfile reference](https://docs.docker.com/engine/reference/builder/)

Container image - a lightweight standalone file that contains the software and executable needed to run one or more containers.

- Allows you to package your app so you can run your app using container technology.

Docker is one of the tools that you can use to create your own images.

Alternatives to Docker: Podman, LXD, Containerd, Buildah, BuildKit, Kaniko, RunC.  https://www.containiq.com/post/docker-alternatives

- A Dockerfile defines exactly what is contained within that image.
- Use the `docker build` command to build an image using that Dockerfile.

**Demo - install Docker on the control plan server**

##### Install Docker

SSH into the control plane server.  (You don't necessarily need to install Docker on one of your Kubernetes servers; we are doing so for convenience.)

`ssh cloud_user@publicipaddress`

Temp password: bananaban

Create a docker user group with the Linux command:

`sudo groupadd docker`.

The `sudo groupadd docker` command adds the following line to the `/etc/group` file:

`docker:x:1002:cloud_user`

The docker group will be used to give users permission to use Docker.

##### Install packages.

```bash
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
```
https://linuxize.com/post/how-to-use-apt-command/

`apt` (advanced package tool) is a command-line utility for installing, updating, removing, and otherwise managing deb packages on Ubuntu, Debian, and related Linux distributions.

`apt` combines the most frequently used commands from the apt-get and apt-cache tools with different default values of some options.

`apt` is designed for interactive use. Prefer using apt-get and apt-cache in your shell scripts as they are backward compatible between the different versions and have more options and features.

Most of the apt commands must be run as a user with sudo privileges.

`apt-transport-https` - APT transport for downloading via the Hypertext Transfer Protocol (HTTP).  APT transport allows the use of repositories accessed via the Hypertext Transfer Protocol (HTTP).  APT transport is available by default and probably the most used of all transports.  Note that a transport is never called directly by a user but used by APT tools based on user configuration.

`ca-certificates` is a debian package that contains certificates provided by the Certificate Authorities.  All digital certificates need to be updated, replaced and changed every now and then. package holds the updated versions of the ca-certificates that are common to everyone.

The ca-certificates package simplifies the process of downloading certificates and importing them manually.  When you install the ca-certificates package, you also get an updater  You can run the updater manually or add the updater to a cron job.

The default location to install certificates is /etc/ssl/certs. enables multiple services to use the same certificate without overly complicated file permissions. For applications that can be configured to use a CA certificate, you should also copy the /etc/ssl/certs/cacert.

**curl** is a tool to transfer data from or to a server, using one of the supported protocols (DICT, FILE, FTP, FTPS, GOPHER, HTTP, HTTPS, IMAP, IMAPS, LDAP, LDAPS, POP3, POP3S, RTMP, RTSP, SCP, SFTP, SMB, SMBS, SMTP, SMTPS, TELNET and TFTP).  The curl command is designed to work without user interaction.

`gnupg` - GnuPG allows you to encrypt and sign your data and communications; ghupg features a versatile key management system, along with access modules for all kinds of public key directories. GnuPG, also known as GPG, is a command line tool with features for easy integration with other applications.

`lsb-release` - The lsb_release command displays LSB (Linux Standard Base) information about your specific Linux distribution, including version number, release codename, and distributor ID.

##### Install the Docker GPG public key for the Docker package repository

Download the Docker GPG public key and then pass the Docker GPG public key to the GPG command to add the GPG key.

Why? Most Linux package managers are able to validate the integrity of a software package before installation by verifying it’s PGP (GPG) key.  As a best practice package maintainers typically sign software packages and make the public key available.

Most modern Linux distributions come with a set of PGP keys installed for the distribution's default repositories. Docker packages are updated at different frequencies than Linux distributions.  Docker has elected to run its own package repositories for major distributions.  When you’re configuring your system to install packages from one of those repositories, you have to add the public key if you want to validate the image.

Details on software package signing: https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/ms537361(v=vs.85)?redirectedfrom=MSDN

Software package validation is optional.  RedHat yum has --nogpgcheck, and Debian dpkg has --no-debsig, both which allow skipping validation of the signatures. The installer does so at their own risk.

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
Add the Docker package repository.

```bash
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
Update package listings and install docker-ce and docker-ce-cli.  Regarding any prompt about configuration for containerd: accept the default by pressing Enter.
```
sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli
```
Test your setup.  Run sudo docker version to see server and client information -> installed correctly and everything is up and running.
```
sudo docker version
Client: Docker Engine - Community
 Version:           20.10.22
 API version:       1.41
 Go version:        go1.18.9
 Git commit:        3a2c30b
...
```
Make sure cloud_user has access to use Docker. Add cloud_user to the Docker group.

`sudo usermod -aG docker cloud_user`

Exit and log back in for the above to take effect.  Now you can do docker version without sudo.

Check effective user and group IDs for cloud_user
```
id cloud_user

uid=1001(cloud_user) gid=1001(cloud_user) groups=1001(cloud_user),27(sudo),1002(docker)

groups cloud_user
cloud_user : cloud_user sudo docker

sudo apt install finger

finger cloud_user
getent passwd cloud_user
lslogins
lslogins -u
users
who
w

docker version # ... lots of output
```
#### Create a custom image using Docker.  x

Create a directory to contain files for custom image.  cd into the new directory.
```
mkdir my-website
cd my-website
```
Create a simple static website with an nginx server.
```
vim index.html

Hello, World!

vim Dockerfile

FROM nginx:stable
COPY index.html /usr/share/nginx/html/
```
The FROM directive defines the base image for the custom image. nginx:stable is a simple image with an nginx web server.  We will customize the nginx:stable image using the COPY directive to copy index.html into the default static HTML directory for the nginx image, which is /usr/share/nginx/html/.

Run `docker build -t`, -t flag allows me to supply the tag for the image; Include a dot to indicate that I want to build from the current directory.

`docker build -t my-website:0.0.1 .`

`docker build -t my-website:0.0.2 .`

Test the image by running a container using Docker.

[Alternatively we could run the image in Kubernetes, but for right now, we will run the image using Docker with the `docker run` command.  Use `--rm`  to automatically delete the container once the container is stopped.]

- Give the container a name, "my-website".
- Run the container in detached mode.
- Expose external port 8080.  Nginx listens on port 80, so map external port 8080 to port 80 inside the container.
- Use the tag we created in the build command above, my-website:0.0.1.

`docker run --rm --name my-website -d -p 8080:80 my-website:0.0.1`

`curl localhost:8080`

To clean up that container,

`docker stop my-website`

You may want to save that image to a file.  You can then move that image file to another server or store the file in some kind of artifact repository.

Use the docker save command; use the -o flag to specify the location where I want to save the image.

Give the archive file the name my-website_0.0.1.tar, a tar archive of the image, specify the image name and the tag.

`docker save -o /home/cloud_user/my-website_0.0.1.tar my-website:0.0.1`

`ls /home/cloud_user`

**Exam tips**

- Images are files that include all of the software needed to run a container.
- A Dockerfile is a file that defines the contents of an image,
- The docker build command is the command that we can use to build an image once we have the Dockerfile.


### Deploy local Docker image in Pod  https://medium.com/swlh/how-to-run-locally-built-docker-images-in-kubernetes-b28fbc32cc1d

https://stackoverflow.com/questions/58654118/pulling-local-repository-docker-image-from-kubernetes

https://docs.docker.com/registry/deploying/#run-a-local-registry

https://medium.com/htc-research-engineering-blog/setup-local-docker-repository-for-local-kubernetes-cluster-354f0730ed3a


docker run -d -p 5000:5000 --restart=always --name registry registry:2

docker tag my-website:0.0.2 localhost:5000/my-website:0.0.2

docker push localhost:5000/my-website:0.0.2







### 2.3 Running Jobs and CronJobs

[Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/)

Kubernetes Jobs are objects designed to run a containerized task successfully to completion.

Unlike a container that might be designed to run all the time continuously, a Job runs some code that needs to perform a task, and then stop running.

Kubernetes Jobs manage these kinds of tasks.  A job helps us to run a single task to completion.

[From the Kubernetes Jobs documentation](https://kubernetes.io/docs/concepts/workloads/controllers/job/):

A Job:
- creates one or more Pods and
- will continue to retry execution of the Pods until a specified number of them successfully terminate.
  - As pods successfully complete, the Job tracks the successful completions.
  - When a specified number of successful completions is reached, the task (ie, Job) is complete.
  - Deleting a Job will clean up the Pods it created.
  - Suspending a Job will delete its active Pods until the Job is resumed again.

A simple case is to create one Job object in order to reliably run one Pod to completion. The Job object will start a new Pod if the first Pod fails or is deleted (for example due to a node hardware failure or a node reboot).

You can also use a Job to run multiple Pods in parallel.

If you want to run a Job (either a single task, or several in parallel) on a schedule, see CronJob.

A CronJob allows us to run jobs periodically, according to a schedule.

If you  want to run a task once, you can use a Job.

If you want to run a task every minute, or every hour or every day, or according to any other schedule you can use a CronJob.

A Job creates one or more Pods and will continue to retry execution of the Pods until a specified number of them successfully terminate.

As pods successfully complete, the Job tracks the successful completions. When a specified number of successful completions is reached, the task (ie, Job) is complete. Deleting a Job will clean up the Pods it created. Suspending a Job will delete its active Pods until the Job is resumed again.

A simple case is to create one Job object in order to reliably run one Pod to completion. The Job object will start a new Pod if the first Pod fails or is deleted (for example due to a node hardware failure or a node reboot).

You can also use a Job to run multiple Pods in parallel.

If you want to run a Job (either a single task, or several in parallel) on a schedule, see CronJob.

*Demo*

#### Create a Job

In the control plane server create file `my-job.yml`.

Container: name: print; image: busybox:stable; command: echo any message; other parameters: 4 and 10

```
vim my-job.yml

apiVersion: batch/v1
kind: Job
metadata:
  name: my-job
spec:
  template:
    spec:
      containers:
      - name: print
        image: busybox:stable
        command: ["echo",  "This is a test!"]
      restartPolicy: Never
  backoffLimit: 4
  activeDeadlineSeconds: 10
```
Jobs are part of an API called the Batch API.  The API version is batch/v1.

The kind is Job.  The Job name is my-job.

The Job contains a Pod template specification.

Jobs run the containerized code using Pods, similar to how a Deployment operates.

The Pod template defines the settings of the Pod that Job is going to create.

`restartPolicy: Never`

The only difference between Job and a Deployment is the container is going to run its code and stop.  The Job container won't run forever.  We set restartPolicy set to Never because container never needs to restart.  The Job container needs to run and then finish.

The command is echoing "This is a test!"

The container will start, print text to the console log, and then stop, and the Job will be completed.

`backoffLimit: 4`

backoffLimit -- How many times Kubernetes is going to retry a Job execution.

A Kubernetes Job can automatically reattempt the Job if the Job fails.

If the command returns an error, and the Job doesn't complete successfully, Kubernetes will try to spin that container up again and retry the Job.

`activeDeadlineSeconds: 10`

The `activeDeadlineSeconds` setting is the maximum number of seconds that Kubernetes will allow the Job to run.

If completing simple operation, echoing some text to the console, takes longer than 10 seconds, probably something is wrong.  If command takes more than 10 seconds to complete, Kubernetes will automatically terminate the container.

Create the Job with kubectl apply.

```
kubectl apply -f my-job.yml
# or
k apply -f my-job.yml && k get jobs


kubectl get jobs

NAME     COMPLETIONS   DURATION   AGE
my-job   1/1           7s         7m8s
```
The terminal output reports that the Job has already completed.  1 out of 1 completions means the Job has already completed execution.

If I run `kubectl get pods`, I can see the Pod that was created as part of Job.
```
kubectl get pods

NAME           READY   STATUS      RESTARTS   AGE
my-job-z27jr   0/1     Completed   0          6m26s
```
The pod is in the Completed status, which means it ran and successfully completed.

`kubectl get pods`

Check the logs for that Pod; copy the Pod name, and use `kubectl logs`.  We observe the logs contain "This is a test".

```
kubectl logs my-job-z27jr

This is a test!
```
The Pod created by a Job will still exist after the Job is completed.

#### Create a CronJob.

CronJob parameters:

Container name: print; image: busybox:stable; command: echo anything;

Run once per minute.  Other: 4, 10


https://cron.help/#*_*_*_*_*

https://phoenixnap.com/kb/set-up-cron-job-linux

```
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed

vim my-cronjob.yml

apiVersion: batch/v1
kind: CronJob
metadata:
  name: my-cronjob
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: print
            image: busybox:stable
            command: ["echo",  "This is a cronjob test!"]
          restartPolicy: Never
      backoffLimit: 4
      activeDeadlineSeconds: 10


vim my-cronjob-date.yml

apiVersion: batch/v1
kind: CronJob
metadata:
  name: my-cronjob-date
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: print
            image: busybox:stable
            command: ["/bin/sh","-c"]
            args: ["echo This is a cronjob test!!; date"]
          restartPolicy: Never
      backoffLimit: 4
      activeDeadlineSeconds: 10
```

backoffLimit limits the pod creation when the Job fails to create successfully. Usually, when a Pod doesn’t create properly, it will go to the Error status and initiate another pod and this process continues until you get a successfully created pod.

If your Job contains something like a command error that prevents creating the Job successfully, k8s tries creating pods continuously.  When you run kubectl get pods you’ll see several pods with Error status. But using backoffLimit you can limit the number of pods created continuously.

activeDeadlineSeconds terminates the Job after the specified number of seconds.

https://www.hostinger.com/tutorials/cron-job
https://crontab.guru/#*/1_*_*_*_*
https://crontab-generator.org/

Is "*/1 * * * *" the same as "* * * * *"?

CronJob is part of the Batch API.

Everything under the jobTemplate key is similar to creating a Job.

A CronJob has three extra lines:
```
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
```
followed by a typical Job specification with the Pod template.

In the CronJob spec we add a schedule item using the cron expression syntax to run the Job every minute.
```
kubectl apply -f my-cronjob.yml

cronjob.batch/my-cronjob created

kubectl get cronjob

kubectl get jobs

kubectl get pods
```
`kubectl get cronjob` will tell me the last time the cronjob was scheduled.

The CronJob has executed, and we see the last time the CronJob was scheduled.

`kubectl get jobs` to see the Job that was automatically created as part of that CronJob and whether it completed successfully.
```
NAME                  COMPLETIONS   DURATION   AGE
my-cronjob-27859345   1/1           8s         91s
my-cronjob-27859346   1/1           7s         31s
my-job                1/1           7s         16h
cloud_user@control:~$
```
The restartPolicy for a Job or CronJob Pod must be set to OnFailure or Never, because Jobs are designed to run once to completion.

Jobs can't restart automatically.  We only want to restart them if they fail or not at all.

Use the `activeDeadlineSeconds` setting in the Job specification to terminate a Job
if it runs too long.  Specify the maximum number of seconds that the Job task is allowed to run.

Suspend CronJobs (supplemented to acloudguru course added by JK)

https://stackoverflow.com/questions/52776690/disabling-cronjob-in-kubernetes

Suspend cronjobs

```bash
kubectl patch cronjobs $(kubectl get cronjobs | awk '{ print $1 }' | tail -n +2) -p '{"spec" : {"suspend" : true }}'

kubectl get cronjobs | grep False | cut -d' ' -f 1 | xargs kubectl patch cronjobs -p '{"spec" : {"suspend" : true }}'
```

https://unofficial-kubernetes.readthedocs.io/en/latest/concepts/jobs/cron-jobs/

`kubectl get jobs --watch`

The `kubectl get` command is usually used for retrieving one or more resources of the same resource type. It features a rich set of flags that allows you to customize the output format using the -o or --output flag, for example. You can specify the -w or --watch flag to start watching updates to a particular object.

The kubectl describe command is more focused on describing the many related aspects of a specified resource. It may invoke several API calls to the API server to build a view for the user. For example, the kubectl describe node command retrieves not only the information about the node, but also a summary of the pods running on it, the events generated for the node etc.

Replace "hello-4111706356" with the job name in your system
```bash
pods=$(kubectl get pods --selector=job-name=hello-4111706356 --output=jsonpath={.items..metadata.name})

echo $pods
hello-4111706356-o9qcm

kubectl logs $pods
Mon Aug 29 21:34:09 UTC 2016
Hello from the Kubernetes cluster

kubectl delete cronjob my-cronjob-date
```

The delete command stops new jobs from being created.  However, running jobs won't be stopped, and no jobs or their pods will be deleted. To clean up those jobs and pods, you need to list all jobs created by the cron job, and delete them all:

```bash
kubectl get jobs
NAME               DESIRED   SUCCESSFUL   AGE
hello-1201907962   1         1            11m
hello-1202039034   1         1            8m
...

kubectl delete jobs hello-1201907962 hello-1202039034 ...
job "hello-1201907962" deleted
job "hello-1202039034" deleted
```

Exam Tips

- A Job is designed to run a containerized task successfully to completion.
- CronJobs run Jobs periodically according to a schedule.
- The `restart policy` for a Job or CronJob Pod must be OnFailure or Never.
- Use `activeDeadlineSeconds` in the Job spec to limit the time the Job can run.  `activeDeadlineSeconds` will terminate the Job if it runs longer than the specified number of seconds.  
- A time limit makes sense for objects such a Job (or a CronJob) that we might want to be able to cancel if a Pod runs for too long it.  

A Pod in a Deployment is not allowed to have `activeDeadlineSeconds`.  A deployment is intended for workloads that are supposed to be running perpetually, so using `activeDeadlineSeconds` to limit the time the Job can run doesn't make sense for that use case.  If we want to be able to refresh the Pods on a Deployment (or a StatefulSet) we can use the bestby controller.  With the bestby controller we can use a label to defined how often Pods need to be refreshed


### 2.4 Building Multi-Container Pods

[The Distributed System ToolKit: Patterns for Composite Containers](https://kubernetes.io/blog/2015/06/the-distributed-system-toolkit-patterns/)

[Pods – Resource Sharing and Communication](https://kubernetes.io/blog/2015/06/the-distributed-system-toolkit-patterns/)

[Shared Volumes](missinglink)

Multi-container Pods are Pods that include multiple containers that work together.

- More than one container within the same Pod.
- There are several different design patterns that we can use to make use of multi-container Pod feature to provide value in the applications.

#### 2.4 a. Sidecar pattern

A sidecar is an additional container in the pod that performs a task to assist the main container.

For example:

- a main container serves files from a shared volume, plus
- a sidecar container that periodically updates those files.  The sidecar helps the main container by doing some kind of auxiliary task off to the side.

Create ~/.vimrc file or add to existing ~/.vimrc:

`autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab`

Demo:

Log into the control plane node server.  (Worker nodes also need to be running.)

```
vim sidecar-test.yml

apiVersion: v1
kind: Pod
metadata:
  name: sidecar-test
spec:
  containers:
  - name: writer
    image: busybox:stable
    command: ['sh', '-c', 'echo "The writer wrote this!" > /output/data.txt; while true; do sleep 5; done']
    volumeMounts:
    - name: shared
      mountPath: /output
  - name: sidecar
    image: busybox:stable
    command: ['sh', '-c', 'while true; do cat /input/data.txt; sleep 5; done']
    volumeMounts:
    - name: shared
      mountPath: /input
  volumes:
  - name: shared
    emptyDir: {}
```
We have two containers listed. These containers are interacting with each other.

The writer container is going to echo the string, "The writer wrote this!" to /output/data.txt, and then sleep on a loop.

The write location is a volume mount, as per the volumeMounts configuration for container.  

From linux 'man sh':  The -c flag means Read commands from the command_string operand instead of from the standard input.  Special parameter 0 will be set from the command_name operand and the positional parameters ($1, $2, etc.) set from the remaining argument operands.

An emptyDir volume is first created when a Pod is assigned to a node, and exists as long as that Pod is running on that node.  The emptyDir volume is initially empty.

When a Pod is removed from a node for any reason, the data in the emptyDir is deleted permanently.

All containers in the Pod can read and write the same files in the emptyDir volume, though that volume can be mounted at the same or different paths in each container.

The emptyDir.medium field controls where emptyDir volumes are stored. By default emptyDir volumes are stored on whatever medium that backs the node such as disk, SSD, or network storage, depending on your environment. If you set the emptyDir.medium field to "Memory", Kubernetes mounts a tmpfs (RAM-backed filesystem) for you instead. While tmpfs is very fast, be aware that unlike disks, tmpfs is cleared on node reboot and any files you write count against your container's memory limit.

Excerpt of sidecar-test.yml:

```yml
spec:
  containers:
  - name: writer
    image: busybox:stable
    command: ['sh', '-c', 'echo "The writer wrote this!"; > /output/data.txt; while true; do sleep 5; done']
    volumeMounts:
    - name: shared
      mountPath: /output
```
The volume mount configures a storage location accessible to the container.

When the container writes to /output, it is writing to the volume mount.

We have a second container called `sidecar`.  The `sidecar` container is going to read data from /input/data.txt, which is also a volume mount.

Both of these containers' volume mounts point to a shared volume called shared; both volume mounts are pointing to the same volume.

One of the benefits of having multiple containers within the same Pod is that <u>they can both use the same storage volumes</u>.

These two containers are interacting with each other because they're both able to interact with the data that is stored in shared storage volume.

When writer writes data to shared storage location, the reader will read data from that location and we should be able to read the string, "The writer wrote this!" in the  sidecar container log.

Save and exit the file; create the sidecar Pod with kubectl apply.
```
kubectl apply -f sidecar-test.yml

pod/sidecar-test created
```
Run `kubectl get pod sidecar-test` to observe the pod in the running status.
```
kubectl get pod sidecar-test

NAME           READY   STATUS    RESTARTS   AGE
sidecar-test   2/2     Running   0          16s
```
Run `kubectl logs sidecar-test`.  

`Defaulted container "writer" out of: writer, sidecar`

We get an error message because in multi-container pod instance, we need to specify which container's logs we want.

Specify the container with the -c flag to see the log message.
```
kubectl logs sidecar-test -c sidecar
The writer wrote this!
The writer wrote this!
The writer wrote this!

k exec sidecar-test -it  -- sh
Defaulted container "writer" out of: writer, sidecar
/ # ls
bin     dev     etc     home    lib     lib64   output  proc    root    sys     tmp     usr     var
/ # cd output/
/output # ls
data.txt
/output #
exit

k exec sidecar-test -it -c sidecar  -- sh
/ # ls
bin    dev    etc    home   input  lib    lib64  proc   root   sys    tmp    usr    var
/ # cat input/data.txt
Hello from the writer container
```
List all containers in a Kubernetes Pod

https://kubernetes.io/docs/reference/kubectl/jsonpath/
https://downey.io/notes/dev/kubectl-jsonpath-new-lines/
https://stedolan.github.io/jq/manual/
```
kubectl get pods POD_NAME_HERE -o jsonpath='{.spec.containers[*].name}'

kubectl get pods sidecar-test -o jsonpath='{}'

kubectl get pods -o jsonpath='{.items[*].spec.containers[*].name}'

kubectl get pods sidecar-test -o jsonpath='{.spec.containers[*].name}'
```
The above command gets the JSON object representing the pod, then uses kubectl's JSONpath to extract the name of each container from the pod.
```
kubectl get pods -o json | jq -r '.items[] | [filter] | [formatted result]' | jq -s '.'

# Example of [filter]: select(.metadata.labels.name=="web")

# Example of [formatted result] (you can add more fields if you want): {name: .metadata.name}

# jq -s '.', for putting result objects in array.

To wrap it up:

kubectl get pods -o json | jq -r '.items[] | select(.metadata.labels.name=="web") | {name: .metadata.name}' | jq -s '.'

Then afterwards you can use this json data to get the desired output result.

kubectl get pods -A -o jsonpath='{range .items[*]}{.status.podIP}{"\n"}{end}'

kubectl get pods -o jsonpath='{range .items[*]}{.metadata.namespace}{"/"}{.metadata.name}{","}{.status.podIP}{"\n"}{end}'

default/sidecar-test,10.1.0.84
```

#### 2.4 b. Ambassador design pattern

See also: https://medium.com/bb-tutorials-and-thoughts/kubernetes-learn-ambassador-container-pattern-bc2e1331bd3a

An ambassador container proxies network traffic to and/or from the main container.

For example, a 'main' container is set up to make requests to a Service on port 80.  Then, for some reason the Service port is changed to port 81.

Instead of changing the (main container) code to make requests to port 81 instead of port 80, we could instead use an ambassador container in the same Pod to proxy requests from the main container to the Service using port 81.

Network traffic to or from the main container passes through the ambassador container.

To test the ambassador design pattern, we create the 'ambassador-test' app (a Pod and a Service) that can be the target of network communication.

In the file `ambassador-test-setup.yml`, create the 'ambassador-test' app:
- A Pod containing an nginx webserver listening on port 80
  - name: `ambassador-test-webserver`
  - app: `ambassador-test`
- A Service named `ambassador-test-svc`
  - listens on port 8081
  - forward to targetPort 80

```
vi ambassador-test-setup.yml

apiVersion: v1
kind: Pod
metadata:
  name: ambassador-test-webserver
  labels:
    app: ambassador-test
spec:
  containers:
  - name: nginx
    image: nginx:stable
    ports:
    - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: ambassador-test-svc
spec:
  selector:
    app: ambassador-test
  ports:
  - protocol: TCP
    port: 8081
    targetPort: 80
```
Optionally you could add a line to the nginx ports specification, 'name: http-web-svc', for example.  Then in the Service, change 'targetPort: 80' to 'targetPort: http-seb-svc'.

How to test the above ambassador-test webserver using curl:

Get the cluster IP for the Service:
```
k get svc -o wide

NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE     SELECTOR
ambassador-test-svc   ClusterIP   10.103.105.56   <none>        8081/TCP   4m10s   app=ambassador-test
```
Create a new Pod that runs curl.
```
kubectl run mycurlpod --image=curlimages/curl -i --tty -- sh
```
Curl the Service's cluster IP from inside `mycurlpod`.
```
curl 10.103.105.56:8081
...
<h1>Welcome to nginx!</h1>
```

A Service is an abstract way to expose an application running on a set of Pods as a network service.  Kubernetes applications don't need to be modified to use an unfamiliar service discovery mechanism.  Kubernetes gives Pods their own IP addresses and a single DNS name for a set of Pods, and can load-balance across them.

The Service API, part of Kubernetes, is an abstraction to help you expose groups of Pods over a network. Each Service object defines a logical set of endpoints (usually these endpoints are Pods) along with a policy about how to make those pods accessible.

For example, consider a stateless image-processing backend which is running with 3 replicas. Those replicas are fungible—frontends do not care which backend they use. While the actual Pods that compose the backend set may change, the frontend clients should not need to be aware of that, nor should they need to keep track of the set of backends themselves.

The Service abstraction enables this decoupling.

The set of Pods targeted by a Service is usually determined by a selector that you define. To learn about other ways to define Service endpoints, see Services without selectors.

If your workload speaks HTTP, you might choose to use an Ingress to control how web traffic reaches that workload. Ingress is not a Service type, but it acts as the entry point for your cluster. An Ingress lets you consolidate your routing rules into a single resource, so that you can expose multiple components of your workload, running separately in your cluster, behind a single listener.

The Gateway API for Kubernetes provides extra capabilities beyond Ingress and Service. You can add Gateway to your cluster - it is a family of extension APIs, implemented using CustomResourceDefinitions - and then use these to configure access to network services that are running in your cluster.

Source: https://kubernetes.io/docs/concepts/services-networking/service/


port: The port on which the Service listens

targetPort The webserver containerPort to which the Service will forward traffic.
  - A Service can map any incoming port to a targetPort. By default (unless specified) and for convenience, the targetPort is set to the same value as the port field.

“containerPort” describes the port on which app can be reached out inside the container.  Optional in a Pod specification.  So in the ambassador-test-webserver, in the nginx container, you can delete the following and it still seems to work:
    ports:
    - containerPort: 80

targetPort and containerPort  
- refer to the same port (so if both are used they are expected to have the same value) but
- are used in two different contexts and have entirely different purposes.
- cannot be used interchangeably as both are part of the specification of two distinct kubernetes resources/objects: Service and Pod respectively. While the purpose of containerPort can be treated as purely informational, targetPort is required by the Service which exposes a set of Pods.
- Declaring containerPort is optional in a Pod specification.  Without containerPort your Service will know where to direct the request based on the info the Service has declared in its targetPort.

nodePort: The port on the node on which external traffic will enter.

Declaring a containerPort in your Pod/Deployment specification does not make your app expose the specified containerPort.  For example, if you declare containerPort: 8080, for an nginx container (that exposes port 80 by default) the nginx server will not listen on port 8080 unless you configure it to do so.

targetPort is optional in the Service definition. If you omit targetPort, it defaults to the value you declared for port (the port on which the Service listens).

Source: https://stackoverflow.com/questions/63448062/difference-between-container-port-and-targetport-in-kubernetes

ports : containerPortList of ports to expose from the container. Exposing a port here gives the system additional information about the network connections a container uses, but is primarily informational. Not specifying a port here DOES NOT prevent that port from being exposed. Any port which is listening on the default "0.0.0.0" address inside a container will be accessible from the network. Cannot be updated.

So it is exactly same with docker EXPOSE instruction. Both are informational. If you don’t configure ports in Kubernetes deployment, you can still access to the ports using Pod IP inside the cluster. You can create a service to access the ports externally without configuring ports in the deployment. But it is good to configure. It will help you or others to understand the deployment configuration better.

from https://docs.docker.com/engine/reference/builder/
The EXPOSE instruction does not actually publish the port. It functions as a type of documentation between the person who builds the image and the person who runs the container, about which ports are intended to be published.

No need to say! you could talk to these pods directly, but when a node dies, the pods on that node will die too, and the Deployment will create new Pod with different IP. Your client app/pod will not be aware of this IP change. As result, container ports is just informative and The service should be used to solve this problem!

Source: https://faun.pub/should-i-configure-the-ports-in-kubernetes-deployment-c6b3817e495



Kubernetes assumes that pods can communicate with other pods, regardless of which host they land on.

Kubernetes gives every pod its own cluster-private IP address, so you do not need to explicitly create links between pods or map container ports to host ports.

This means that containers within a Pod can all reach each other's ports on localhost, and all pods in a cluster can see each other without NAT.

Source: https://kubernetes.io/docs/tutorials/services/connect-applications-service/
```
kubectl apply -f ambassador-test-setup.yml

pod/ambassador-test-webserver created
service/ambassador-test-svc created
```

Create a Pod with an ambassador container that interacts with the main container via shared network resources.  An ambassador container is going to proxy network traffic to and/or from the main container.

In the 'ambassador-test.yml` file, create:
- a Pod named 'ambassador-test' with two containers named main and ambassador:
  - main, with
    - image: radial/busyboxplus:curl
    - command: curls localhost:8080 every five seconds
  - ambassador; network traffic to or from the main container passes through the ambassador container.
    - image: haproxy:2.4
    - has a volume mount for the haproxy.cfg data
      - mountPath is /usr/local/etc/haproxy/
  - a volume named 'config'
- a ConfigMap named 'haproxy-config' with a data field that contains haproxy.cfg:
  haproxy.cfg: |
    frontend ambassador
      bind *:8080
      default_backend ambassador_test_svc
    backend ambassador_test_svc
      server svc ambassador-test-svc:8081

```
vim ambassador-test.yml

apiVersion: v1
kind: ConfigMap
metadata:
  name: haproxy-config
data:
  haproxy.cfg: |
    frontend ambassador
      bind *:8080
      default_backend ambassador_test_svc
    backend ambassador_test_svc
      server svc ambassador-test-svc:8081
---
apiVersion: v1
kind: Pod
metadata:
  name: ambassador-test
spec:
  containers:
  - name: main
    image: radial/busyboxplus:curl
    command: ['sh', '-c', 'while true; do curl localhost:8080; sleep 5; done']
  - name: ambassador
    image: haproxy:2.4
    volumeMounts:
    - name: config
      mountPath: /usr/local/etc/haproxy/
  volumes:
  - name: config
    configMap:
      name: haproxy-config
```

The Pod in the `ambassador-test.yml` has two containers named: 1. main; and 2. ambassador.

The main container's command makes a request to localhost on port 8080:
  - command: ['sh', '-c', 'while true; do curl localhost:8080; sleep 5; done'].

The ambassador container is an HAProxy server that listens on localhost port 8080 and forwards traffic to ambassador-test-svc on port 8081.  

HAProxy is a simple proxy tool that can forward network traffic from one location to another.

The main container in the ambassador-test Pod will therefore be communicating through the ambassador HAProxy container in the ambassador-test Pod with the ambassador-test-svc in the ambassador-test-webservice Pod.

HAProxy requires configuration.  We mount that configuration to the HAProxy ambassador container using a ConfigMap volume.  The ConfigMap is not really part of the multi-container setup.

The ConfigMap is not shared between the two containers.  The ConfigMap is only used by the ambassador container to load the config file.  You don't need to worry about the details of configuring HAProxy.

The HAProxy server will listen on port 8080, and it's going to forward that traffic to ambassador-test-svc on port 8081.

When the main container makes a curl request to localhost 8080, it's  communicating with the ambassador container in the same Pod, and then the ambassador container is going to proxy that traffic to the ambassador-test-svc service.


'ambassador-test' Pod/'main' container -> [curl request to localhost:8080] ->
'ambassador-test' Pod/'ambassador' container -> [curl request to localhost:8081] ->
'ambassador-test-svc' -> [curl request to port 80] -> ambassador-test-app

Save, exit, apply.

Run `kubectl get pods` to see if it is working.

The ambassador-test Pod is in the running status:
```bash
kubectl get pods

NAME                        READY   STATUS    RESTARTS   AGE
ambassador-test             2/2     Running   0          11m
ambassador-test-webserver   1/1     Running   0          15m
```
Check the logs main container.

`kubectl logs ambassador-test -c main`

The logs should contain an HTML file with "Welcome to nginx".

If you scroll up a little bit, you might be able to see some error messages, "connection refused".  At point the main container was up and running, but the ambassador container was still starting up.

Once the ambassador container was running, we start to see a  "Welcome to nginx" message.

Thus we have successfully set up a multi-container Pod with an ambassador container to proxy traffic from the main container to a Kubernetes service.

#### Named Port Definitions Supplement (https://kubernetes.io/docs/concepts/services-networking/service/)

Port definitions in Pods have names, and you can reference these names in the targetPort attribute of a Service. For example, we can bind the targetPort of the Service to the Pod port in the following way:

```
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app.kubernetes.io/name: proxy
spec:
  containers:
  - name: nginx
    image: nginx:stable
    ports:
      - containerPort: 80
        name: http-web-svc

---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app.kubernetes.io/name: proxy
  ports:
  - name: name-of-service-port
    protocol: TCP
    port: 80
    targetPort: http-web-svc
```

#### ConfigMap supplement

configMap
A ConfigMap provides a way to inject configuration data into pods. The data stored in a ConfigMap can be referenced in a volume of type configMap and then consumed by containerized applications running in a pod.

When referencing a ConfigMap, you provide the name of the ConfigMap in the volume. You can customize the path to use for a specific entry in the ConfigMap. The following configuration shows how to mount the log-config ConfigMap onto a Pod called configmap-pod:

apiVersion: v1
kind: Pod
metadata:
  name: configmap-pod
spec:
  containers:
    - name: test
      image: busybox:1.28
      volumeMounts:
        - name: config-vol
          mountPath: /etc/config
  volumes:
    - name: config-vol
      configMap:
        name: log-config
        items:
          - key: log_level
            path: log_level
The log-config ConfigMap is mounted as a volume, and all contents stored in its log_level entry are mounted into the Pod at path /etc/config/log_level. Note that this path is derived from the volume's mountPath and the path keyed with log_level.

Note:
You must create a ConfigMap before you can use it.

A container using a ConfigMap as a subPath volume mount will not receive ConfigMap updates.

Text data is exposed as files using the UTF-8 character encoding. For other character encodings, use binaryData.


#### 2.4 c. Adapter design pattern (no demo)

An adapter transforms the main container's output in some way.

For example, if the main container outputs some log data to the container log in a non-standard format, say, for example, without timestamps, then an adaptor container could read that log data and transform it into a standard format by adding those timestamps.

An adapter does takes some kind of output from the main container and adds to it or transforms it in some way.

If you need to run multiple containers usually it makes more sense to run multiple Pods.  But we can use multiple containers within the same Pod when those containers need to be tightly coupled.  "Tightly coupled" means the containers need to share resources, such as network resources or storage volumes.

If containers are closely connected together and need to share resources side by side, it might be appropriate for them to exist within the same Pod.

Exam Tips

- First, a sidecar container performs some task that helps the main container.
- An ambassador container proxies network traffic to and/or from the main container.
- An adapter container transforms the main container's output.


### 2.5 Using Init Containers

[Init Containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)

[Lesson Reference](https://acloudguru-content-attachment-production.s3-accelerate.amazonaws.com/1642601753088-1077%20-%20S02L05%20Using%20Init%20Containers.pdf)

An init container runs to complete a task before a Pod's main container starts up.

The main container will not start until the init container has completed.

The init container does not stay running like a web server.

An init container uses an image that is separate from the main container.

An init container allows you to use a different image to perform start-up tasks.  The init container image can include software and tools that the main container does not include and doesn't need.

You can also use an init container to delay the start-up of the main container until certain external preconditions are met.

If the main container depends on something like an external service, you could use an init container to verify that the service is up, running, and accessible and delay main container startup until the required external service becomes available.

Anytime you want to delay startup, init containers are a great way to do that.

Init containers can help maintain security.

**Demo: Create a Pod with an init container.**

In 'init-test.yml' create a Pod named 'init-test' with:
- an nginx:stable container
- a busybox init container
  - command: sleep for 60 seconds

```
vim init-test.yml

apiVersion: v1
kind: Pod
metadata:
  name: init-test
spec:
  containers:
  - name: nginx
    image: nginx:stable
  initContainers:
  - name:busybox
    image: busybox:stable
    command: ['sh', '-c', 'sleep 60']

k apply -f init-test.yml && k get pod init-test

pod/init-test created

kubectl get pod init-test

NAME        READY   STATUS     RESTARTS   AGE
init-test   0/1     Init:0/1   0          20s

kubectl get pod init-test

NAME        READY   STATUS            RESTARTS   AGE
init-test   0/1     PodInitializing   0          66s

kubectl get pod init-test

NAME        READY   STATUS    RESTARTS   AGE
init-test   1/1     Running   0          92s

kubectl run mycurlpod --image=curlimages/curl -i --tty -- sh

/ $ curl 10.1.0.102:80
<!DOCTYPE html>
<html>
...
```
Init containers can perform sensitive start-up steps such as consuming secrets in isolation from the main container.

For example, let's say you wanted to communicate with some kind of external service but only while the Pod is starting up.

Using the credentials for accessing that service in an init container will insulate those credentials from the main container when they're not needed on an ongoing basis.

The following demo demonstrates a basic pod running nginx plus an init container designated by an initContainers field.

You can have more than one init container.  They will run in order, and only when all of them have fully completed will the main container start up.

With two init containers, the status will show Init:0/2:
```
k get pods
NAME        READY   STATUS     RESTARTS   AGE
init-test   0/1     Init:0/2   0          4s
```
The init container in the following demo is a simple busybox container, which goes to sleep for 60 seconds.

Until that 60 seconds passes the init container remains in the init status signifying that the main container has not started up because the init container is still running.

We have one init container, so zero out of one init containers have completed: the sole init container still has not completed.

The Pod, therefore, is not in the ready status.

Once the init container has completed and the main container starts up and we are now in the running status.

Thus, we have successfully completed a Pod with an init container that delayed the startup of the main container for 60 seconds.

Exam tips:

- Init containers run to completion before the main container starts up.
- Add init containers to a Pod using the `initContainers` field within the Pod spec.


### 2.6 Lab:  Using Multiple Containers in a Kubernetes Pod

<span style="float:right">[Lab diagram](images/using-multiple-containers-in-k8s-pod.png)</span><br />

<img src="images/using-multiple-containers-in-k8s-pod.png"
     alt="Lab diagram:  Using Multiple Containers in a Kubernetes Pod"
     style="float: right; margin-right: 10px; margin-bottom: 10px;"
     width="90%" />

[Start the Lab](https://learn.acloud.guru/course/certified-kubernetes-application-developer/learn/de8b93ac-17b0-470d-8d6b-a569895c4b16/d8ae805e-538f-4ad7-8077-fb2b0589544d/lab/d8ae805e-538f-4ad7-8077-fb2b0589544d)

The subject application reaches out to an existing Service (hive-svc) maintained by another team. Some recent changes by the other team have led to some issues:

Your app Pods need to delay startup by a few seconds to allow time for some auxiliary systems to react to the Pod's presence.

The other team wants to change the external Port exposed by their Service to 9076 from 9090, and your app will need to be updated accordingly.  Add an ambassador container so that the external port is more easily configurable in the future.

Solve these problems by modifying your app's Deployment.  

- Add an init container to delay your app's startup, and
- add an ambassador container to allow your app to use the new external Service port number (9076) in a configurable way.

In summary:

1. Delay startup of the main container using an init container.

2. Change the port configuration using an ambassador container; the Service port changes to 9076 from 9090.


#### Learning Objectives

Update the Service to Use the New Port

- There is a Service called hive-svc located in the default Namespace.  Modify this service so that it listens on port 9076.

Add an init Container to Delay Startup

- The app is managed by the app-gateway Deployment in the default Namespace. Add an init container to the Pod template so that startup will be delayed by 10 seconds. You can do this by using the busybox:stable image and running the command sh -c sleep 10.

Add an ambassador container to make the app use the new Service port, 9076.

- Find the app-gateway Deployment located in the default Namespace.  Add an ambassador container to the Deployment's Pod template using the haproxy:2.4 image.

- Supply the ambassador container with an haproxy configuration file at /usr/local/etc/haproxy/haproxy.cfg. There is already a ConfigMap called haproxy-config in the default Namespace with a pre-configured haproxy.cfg file.

- You will need to edit the command of the main container so that it points to localhost instead of hive-svc.


#### Solution

Start the lab and log in to the server using the credentials provided:

`ssh cloud_user@<PUBLIC_IP_ADDRESS>`

Examine the already-running Pods, Services, nodes and deployments.

```bash
cloud_user@k8s-control:~$ kubectl get pods

NAME                           READY   STATUS    RESTARTS   AGE
app-gateway-54894c558b-c8hpw   1/1     Running   0          105m
hive-web                       1/1     Running   0          105m

cloud_user@k8s-control:~$ kubectl get svc

NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
hive-svc     ClusterIP   10.104.238.166   <none>        9090/TCP   105m
kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP    106m

cloud_user@k8s-control:~$ curl 10.104.238.166:9090
{"message": "Welcome to the Hive API!"}

cloud_user@k8s-control:~$ kubectl get nodes
NAME          STATUS   ROLES                  AGE     VERSION
k8s-control   Ready    control-plane,master   7m23s   v1.24.0
k8s-worker1   Ready    <none>                 7m      v1.24.0

cloud_user@k8s-control:~$ kubectl get deployments
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
app-gateway   1/1     1            1           14m
```

Update the Service to Use the New External Port (9090 -> 9076)

Edit the existing Service:

`kubectl edit svc hive-svc`

The following is the existing configuration, the starting point.

```yml
# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving file will be
# reopened with the relevant failures.
#
apiVersion: v1
kind: Service
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"name":"hive-svc","namespace":"default"},"spec":{"ports":[{"port":9090,"protocol":"TCP","targetPort":80}],"selector":{"app":"hive"}}}
  creationTimestamp: "2022-04-09T00:04:10Z"
  name: hive-svc
  namespace: default
  resourceVersion: "604"
  uid: ac257e63-fdd9-4177-bb30-7b55249db4b7
spec:
  clusterIP: 10.104.238.166
  clusterIPs:
  - 10.104.238.166
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - port: 9090
    protocol: TCP
    targetPort: 80
  selector:
    app: hive
  sessionAffinity: None
  type: ClusterIP
status:
  loadBalancer: {}
```
Change the service listening port from 9090 to 9076:
```yml
ports:
- port: 9076
  ...
```
Type ESC followed by :wq to save your changes and to update the Service.

`service/hive-svc edited`

To delay startup, add an init Container to the app-gateway Deployment.

Edit the app-gateway Deployment:

`kubectl edit deployment app-gateway`

```yml
# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving file will be
# reopened with the relevant failures.
#
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "1"
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{},"name":"app-gateway","namespace":"default"},"spec":{"replicas":1,"selector":{"matchLabels":{"app":"gateway"}},"template":{"metadata":{"labels":{"app":"gateway"}},"spec":{"containers":[{"command":["sh","-c","while true; do curl hive-svc:9090; sleep 5; done"],"image":"radial/busyboxplus:curl","name":"busybox"}]}}}}
  creationTimestamp: "2022-04-09T00:04:10Z"
  generation: 1
  name: app-gateway
  namespace: default
  resourceVersion: "1086"
  uid: 0a8fd307-d402-4cff-89de-85294614f9d4
  uid: 0a8fd307-d402-4cff-89de-85294614f9d4 ??
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: gateway
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: gateway
    spec:
      containers:
      - command:
        - sh
        - -c
        - while true; do curl hive-svc:9090; sleep 5; done
        image: radial/busyboxplus:curl
        imagePullPolicy: IfNotPresent
        name: busybox
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
status:
  availableReplicas: 1
  conditions:
  - lastTransitionTime: "2022-04-09T00:07:47Z"
    lastUpdateTime: "2022-04-09T00:07:47Z"
    message: Deployment has minimum availability.
    reason: MinimumReplicasAvailable
    status: "True"
    type: Available
  - lastTransitionTime: "2022-04-09T00:04:10Z"
    lastUpdateTime: "2022-04-09T00:07:47Z"
    message: ReplicaSet "app-gateway-54894c558b" has successfully progressed.
    reason: NewReplicaSetAvailable
    status: "True"
    type: Progressing
  observedGeneration: 1
  readyReplicas: 1
  replicas: 1
  updatedReplicas: 1
```
Scroll down to the Pod template in the Deployment specification. Add `initContainers:` to the Pod template on the same level as the containers field.

Note: When copying and pasting code into Vim from the lab guide, first enter `:set paste` (and then i to enter insert mode) to avoid adding unnecessary spaces and hashes. To save and quit the file, press Escape followed by :wq. To exit the file without saving, press Escape followed by :q!.

```yml
    spec:
      containers:
      - ...
      initContainers:
      - name: startup-delay
        image: busybox:stable
        command: ['sh', '-c', 'sleep 10']
```
Type ESC followed by :wq to save your changes to update the Deployment.

Check the status of the Deployment's Pod:
```
kubectl get pods

NAME                           READY   STATUS     RESTARTS   AGE
app-gateway-757bcd5456-ps95r   0/1     Init:0/1   0          5s
app-gateway-85d8c6bb4d-4ctgx   1/1     Running    0          62m
hive-web                       1/1     Running    0          62m

NAME                           READY   STATUS        RESTARTS   AGE
app-gateway-757bcd5456-ps95r   1/1     Running       0          35s
app-gateway-85d8c6bb4d-4ctgx   1/1     Terminating   0          63m
hive-web                       1/1     Running       0          63m

NAME                           READY   STATUS    RESTARTS   AGE
app-gateway-757bcd5456-ps95r   1/1     Running   0          67s
hive-web                       1/1     Running   0          63m
```

You should see the app-gateway Pod in the Init phase. Wait a few seconds, and re-run the command. You should see the Pod is now running, and the old one is terminating.

Add an Ambassador Container to Make the App Use the New Service Port

Edit the app-gateway Deployment again:

`kubectl edit deployment app-gateway`

Scroll down to locate the Pod template and specification. Change the main container's command to point to localhost instead of hive-svc:
```yml
        command:
          - sh
          - -c
          - while true; do curl localhost:9090; sleep 5; done
```
Add a new ambassador container that uses the haproxy:2.4 image. Mount the existing configMap to haproxy:

```yml
      containers:
      - name: busybox
        ...
      - name: ambassador
        image: haproxy:2.4
        volumeMounts:
        - name: haproxy-config
          mountPath: /usr/local/etc/haproxy/
      volumes:
      - name: haproxy-config
        configMap:
          name: haproxy-config

```
Type ESC followed by :wq to save your changes and to update the Deployment.

deployment.apps/app-gateway edited

Check the Pod status:
```
kubectl get pods

NAME                           READY   STATUS        RESTARTS   AGE
app-gateway-5bf5554d8d-sps7v   2/2     Running       0          19s
app-gateway-757bcd5456-ps95r   1/1     Terminating   0          11m
hive-web                       1/1     Running       0          73m

NAME                           READY   STATUS    RESTARTS   AGE
app-gateway-5bf5554d8d-sps7v   2/2     Running   0          63s
hive-web                       1/1     Running   0          74m
```
You should see the app-gateway Pod in the Init phase.  Wait a few seconds and re-run the command. The Pod should now be Running.

'Ready = 2/2' shows how many containers in a pod are considered ready. You can have some containers starting faster then others or having their readiness checks not yet fulfilled (or still in initial delay). In such cases there will be less containers ready in pod then their total number (ie. 1/2) hence the whole pod will not be considered ready.

Copy the full name of the app Pod. It should begin with app-gateway- (the one in the Running status). Use the Pod name to check the main container's logs:

```
kubectl logs $POD_NAME -c busybox`

{"message": "Welcome to the Hive API!"}
```

You should see the output from the Hive API. The application is able to successfully communicate with the Service through the ambassador container.


### 2.7 Exploring Volumes

[Lesson Reference]()

[Volumes](https://kubernetes.io/docs/concepts/storage/volumes/)

Kubernetes supports many types of volumes. A Pod can use any number of volume types simultaneously. Ephemeral volume types have a lifetime of a pod, but persistent volumes exist beyond the lifetime of a pod. When a pod ceases to exist, Kubernetes destroys ephemeral volumes; however, Kubernetes does not destroy persistent volumes.

For any kind of volume in a given pod, data is preserved across container restarts.

On-disk files in a container are ephemeral, which presents some problems for non-trivial applications when running in containers.  One problem is the loss of files when a container crashes.  The kubelet restarts the container but with a clean state. A second problem occurs when sharing files between containers running together in a Pod.  The Kubernetes volume abstraction solves both of these problems.

Kubernetes volume
- provides external storage outside of the container file system.
- defined in a Pod specification, but not within the container spec.  
- defines the details of where and how external data is stored.

Volume mount
- defined inside the container spec, not in the Pod spec.
- attaches the volume defined at the Pod specification level to a specific container within the Pod.
- defines the specific path where the volume data will appear to the container process at runtime.


Kubenetes volume types (partial coverage)

Here is a list of all the volume types: https://kubernetes.io/docs/concepts/storage/volumes/#volume-types

The volume type determines where and how the actual data storage is handled behind the scenes.

[hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath)

- hostPath data is stored in a specific location directly on the host file system in a directory on the Kubernetes node where the Pod is running.

[emptyDir](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir)

- emptyDir data is stored in an **automatically managed** location on the host file system.
- while a hostPath volume stores data in a specific location that you can use access from inside of a container, an emptyDir is automatically managed and the data is deleted if the Pod is deleted.
- a temporary storage location, even though the emptyDir is technically using the host file system to store the data.
- a quick temporary place to store data outside the container file system itself

Docker has a concept of volumes, though it is somewhat looser and less managed. A Docker volume is a directory on disk or in another container. Docker provides volume drivers, but the functionality is somewhat limited.


[persistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/volumes/#persistentvolumeclaim)

- allows you to mount data to a container.  The data is stored in a PersistentVolume.

**Demo: create some Pods that use volumes.**

To start off with we demonstrate the use of hostPath volumes.  hostPath volume types store the data on the Kubernetes node itself.

In this case, the Kubernetes node where the data is stored will be one of the two worker nodes.

Create some data on the worker nodes for demonstration.

I'm logged in to the control node and both of the worker nodes. On both of the worker nodes  create directory called '/etc/hostPath'.

Add some data to these directories.
```
sudo mkdir /etc/hostPath
worker1> echo "This is worker 1!" | sudo tee /etc/hostPath/data.txt
worker2> echo "This is worker 2!" | sudo tee /etc/hostPath/data.txt
```


Each of the two worker nodes has a file at `etc/hostPath/data.txt`.  Worker 1's file will contain the text, "This is worker 1!".  Worker 2's text will saym "This is worker 2."

If the containers can read data we'll be able to tell that they are reading data from their specific host file system based on what that data says.

In the control plane node create a Pod that's going to use a hostPath volume to access the files we created.

Create a file, hostPath-volume-test.yml
```
control>
vim hostpath-volume-test.yml

apiVersion: v1
kind: Pod
metadata:
  name: hostpath-volume-test
spec:
  restartPolicy: OnFailure
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'cat data/data.txt']
    volumeMounts:
    - name: host-data
      mountPath: /data
  volumes:
  - name: host-data
    hostPath:
      path: /etc/hostPath
      type: Directory

kubectl apply -f hostpath-volume-test.yml

pod/hostpath-volume-test created
```

The Pod will have a restartPolicy of OnFailure so the Pod is not going to run continuously.  

The Pod will run the command and complete.

We create a hostPath volume that will mount to a /data location and point to those files on the hosts.

We add volumes to the Pod spec but not within the container field.  The volume is not part of the container field.

We add a list for volumes and name the volume host-data.

We make the volume a a hostPath volume by defining the hostPath field under which we specify the path on the host.

The text files we created were located on the host at /etc/hostPath.

The path points to the location on the worker node where the data is  going to be stored.

hostPath volumes have a type, which might be 'File', 'FileOrCreate', or 'Directory'.  For more options, see: https://kubernetes.io/docs/concepts/storage/volumes/#hostpath

```
k explain pod.spec.volumes.hostPath
```

If we set type to 'File', it means we are pointing to a specific file.  If the file doesn't exist, the configuration that will fail.

We could also set hostPath.type to 'FileOrCreate', which would point to a specific file but it won't fail if the file doesn't exist, it will create the file.

Now, that's not going to work because we're pointing to a directory, not a file.

I could use Directory there or I could use DirectoryOrCreate.  DirectoryOrCreate will automatically create the directory if it doesn't exist.

Now, in the case, we've already created the directories in the worker nodes, so we can specify 'Directory'.  Directory will fail if the directory doesn't exist.

Now mount the volume to the container.  Under container we provide a list of volumeMounts.  We will specify 'name: host-data' to reference the volume.

Specify the mountPath as 'mountPath: /data', the location where we want the container to see data consistent with the 'cat data/data.txt' command we told the container to run.

Save, exit, apply to create the Pod.

check the status of the Pod to make sure that it's up and running,

```
kubectl get pods hostpath-volume-test
NAME                   READY   STATUS      RESTARTS   AGE
hostpath-volume-test   0/1     Completed   0          2m23s

kubectl logs hostpath-volume-test
This is worker 2!
```
The Pod happened to be scheduled on worker node #2, and therefore,
it read that file that we created on worker 2, and that's what ended up in the container log.

we've successfully created a Pod with a hostPath volume,

Now we look at how to use an emptyDir volume.
```
vim emptydir-volume-test.yml

apiVersion: v1
kind: Pod
metadata:
  name: emptydir-volume-test
spec:
  restartPolicy: OnFailure
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'echo "Writing to the empty dir..." > /data/data2.txt; cat /data/data2.txt']
    volumeMounts:
    - name: emptydir-vol
      mountPath: /data
  volumes:
  - name: emptydir-vol
    emptyDir: {}

kubectl apply -f emptydir-volume-test.yml

pod/emptydir-volume-test created

kubectl logs emptydir-volume-test

Writing to the empty dir...
```

emptyDir volumes provide temporary ephemeral storage outside of the container file system.

I'll  create file here called emptydir-volume-test.yml, and here's the beginning of the Pod specification.

I'm going to create a Pod called emptydir-volume-test.
It's not going to restart unless it fails and I'm  going to write some data,
I'll write "Writing to the empty dir...' to /data/data.txt,
and then I'll read that data back from that same location.

what we want to do is instead of doing that
in the container file system,
let's create an emptyDir volume so that data
will  be written to an external ephemeral temporary storage location.

We provide a volume named 'emptydir-vol' in the required list of volumes.

To specify an 'emptyDir' volume with an empty specification we use two curly braces with nothing inside: {}.

set up the volume mounts.  Use the same name, 'emptydir-vol', to reference the volume.

I'm  going to mount emptydir-vol and the mountPath where the container process
is going to be looking for that volume is going to be /data.

Save, exit and apply to create the Pod.

Of course, I can get the Pod to see that it is working, and I'll check the logs and sure enough, I can see that data writing to the emptyDir.

We've created a Pod that writes data to an ephemeral emptyDir volume.

 it is also accessible on the node. It is bind mounted into the container (sort of). The source directories are under /var/lib/kubelet/pods/PODUID/volumes/kubernetes.io~empty-dir/VOLUMENAME

sudo ls -l /var/lib/kubelet/pods/`kubectl get pod -n mynamespace mypod -o 'jsonpath={.metadata.uid}'`/volumes/kubernetes.io~empty-dir

sudo ls -l /var/lib/kubelet/pods/`kubectl get pod -n kitty emptydir-volume-test -o 'jsonpath={.metadata.uid}'`/volumes/kubernetes.io~empty-dir


Exam tips

The volumes field in the Pod spec defines details about volumes used in the Pod.

The volumeMounts field in the container spec mounts the actual volume to a specific container at a specific location.

HostPath volumes mount data from a specific location on the host, i.e, the Kubernetes node.

There is a type field within a hostPath volume.  

We could specify a hostPath type of
- Directory which mounts an existing directory on the host, or
- DirectoryOrCreate, which mounts a directory on the host and creates it if it doesn't already exist.
- File, which mounts an existing single file on the host
- FileOrCreate which mounts a single file and creates it if it doesn't exist.

emptyDir volumes provide a temporary storage that uses the host file system and are removed if the Pod is deleted.

https://www.alibabacloud.com/blog/kubernetes-volume-basics-emptydir-and-persistentvolume_594834


https://redhat-scholars.github.io/kubernetes-tutorial/kubernetes-tutorial/volumes-persistentvolumes.html


### 2.8 Using PersistentVolumes

[Lesson Reference]()

Persistent Volumes allow you to abstract volume storage details away from Pods and treat storage like a consumable resource.

When you create a Pod you don't need to assign CPU resources or memory resources to your Pod's containers.  Kubernetes handles CPU and memory for you when you create a Pod.  Kubernetes treats resources like CPU and memory as abstract consumable resources.

A PersistentVolume allows you to treat storage as an abstract consumable resource.

You can define available storage with a pv and then consume that storage in your Pods and containers on an as-needed basis.

In order to understand how PersistentVolumes work, we need to understand the relationship
between PersistentVolumes and PersistentVolumeClaims.

A PersistentVolume:
- defines an abstract storage resource which is ready to be consumed by Pods.
- points to actual underlying storage resources that are available.
- defines details about the type and amount of provided storage.
- a pv is storage that is available.

A PersistentVolumeClaim:
- a request for storage which includes details of the type of storage needed.
- a pvc is storage that is needed.

A PersistentVolumeClaim will automatically bind to a PersistentVolume that meets the provided requirements.

When you create a PersistentVolumeClaim it's going to look for a PersistentVolume that can provide what it needs and then bind to that PersistentVolume.

Then you can mount your PersistentVolumeClaim inside of a Pod's containers, like any other volume.

<span style="float:right">[Binding persistent volume claim](images/binding-persistent-volume.png)</span><br />

<img src="images/binding-persistent-volume.png"
     alt="Binding with Persistent Storage"
     style="float: right; margin-right: 10px; margin-bottom: 10px;"
     width="80%" />

The diagram above shows a PersistentVolume that defines a set of attributes for available storage resources.
- storageClassName of 'fast'.
- storage capacity: 5 gigabytes
- access mode.

We can have an additional PersistentVolume with a different storageClassName.

Another pv has a StorageClass called 'slow', with 10 gigabytes available and the same accessModes as the first pv.

We create a PersistentVolumeClaim that defines some attributes that look similar to the PersistentVolume attributes.

The pvc is looking for storage with a StorageClass of 'fast', at least 200 megabytes of storage and the ReadWriteOnce access mode.

The pvc will look at the available PersistentVolumes and choose one that meets the pvc's criteria.

[Binding](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#binding)

A user creates, or in the case of dynamic provisioning, has already created, a PersistentVolumeClaim with a specific amount of requested storage with specified access modes.

A control loop in the master (node?) watches for new pvcs, finds a matching pv (if possible), and binds them together.  

If a pv was dynamically provisioned for a new pvc, the loop will always bind that pv to the pvc.  Otherwise, the user will always get at least what they asked for, but the volume may be in excess of what was requested.  Once bound, PersistentVolumeClaim binds are exclusive, regardless of how they were bound.  A pvc to pv binding is a one-to-one mapping, using a ClaimRef which is a bi-directional binding between the PersistentVolume and the PersistentVolumeClaim.

Claims will remain unbound indefinitely if a matching volume does not exist.  Claims will be bound as matching volumes become available.  For example, a cluster provisioned with many 50Gi pvs would not match a pvc requesting 100Gi.  The pvc requesting 100Gi can be bound when a 100Gi pv is added to the cluster.

The Kubernetes Master node—runs the Kubernetes control plane which controls the entire cluster.  A cluster must have at least one master node; there may be two or more for redundancy.  Components of the master node include the API Server, etcd (a database holding the cluster state), Controller Manager, and Scheduler.

Of course, the master is going to choose that first one, because the first one has the same storageClassName of fast.  It has enough storage capacity and the same accessModes.

Because those attributes match between the PersistentVolumeClaim and the PersistentVolume, the claim is going to bind itself automatically to that volume.

**Demo:  Create a Pod that uses a PersistentVolume for storage.**

- create a PersistentVolume.
- create a PersistentVolumeClaim that is able to bind to that PersistentVolume.
- create a Pod with a container that utilizes that PersistentVolume storage.

Create a PersistentVolume in the control node:
- define a PersistentVolume object in hostpath-pv.yml.
- set storage capacity: 1Gi.
- set accessModes, ReadWriteOnce
- storageClassName can really be anything you want.  We will use 'slow'.
- additional information about where PersistentVolume storage is  located.
  - specify a volume type here.
  - specify a hostPath, similar to a regular hostPath volume. That means the data is ultimately to be stored on the actual host or a Kubernetes node where the Pod is running, /etc/hostpath.
- type: Directory.

#### [hostPath Volumes](https://kubernetes.io/docs/concepts/storage/volumes/)

A hostPath volume mounts a file or directory from the host node's filesystem into your Pod. This is not something that most Pods will need, but it offers a powerful escape hatch for some applications.

For example, some uses for a hostPath are:

- running a container that needs access to Docker internals; use a hostPath of /var/lib/docker
- running cAdvisor in a container; use a hostPath of /sys
- allowing a Pod to specify whether a given hostPath should exist prior to the Pod running, whether it should be created, and what it should exist as

In addition to the required path property, you can optionally specify a type for a hostPath volume.

Warning: hostPath volumes present many security risks, and it is a best practice to avoid the use of HostPaths when possible.  When a HostPath volume must be used, it should be scoped to only the required file or directory, and mounted as ReadOnly.

If restricting HostPath access to specific directories through AdmissionPolicy, volumeMounts MUST be required to use readOnly mounts for the policy to be effective.

Previously we might have already created some data on both of the worker nodes at the /etc/hostPath location.  If not, on both of the worker nodes create directory called '/etc/hostPath'.

```
sudo mkdir /etc/hostPath
worker1> echo "This is worker 1!" | sudo tee /etc/hostPath/data.txt
worker2> echo "This is worker 2!" | sudo tee /etc/hostPath/data.txt
```
Create a persistent volume in the control node:

Parameters for the pv:

Name: hostpath-pv
1G
storageClassName: slow
path /etc/hostPath
type Directory; a directory must exist at the given path

```
vim hostpath-pv.yml

apiVersion: v1
kind: PersistentVolume
metadata:
  name: hostpath-pv
spec:
  capacity:
    storage: 1G
  accessModes:
  - ReadWriteOnce
  storageClassName: slow
  hostPath:
    path: /etc/hostPath
    type: Directory


kubectl apply -f hostpath-pv.yml

persistentvolume/hostpath-pv created

kubectl get pv

NAME          CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
hostpath-pv   1G         RWO            Retain           Available           slow                    36s
```

Next create a PersistentVolumeClaim with a file, hostpath-pvc.yml,

The accessModes should match the PersistentVolume access mode.

The storageClassName should match slow.

We request 200 mebibytes or roughly 200 megabytes.  Capacity storage resource request needs to be less than the storage provided in the pv.

If you request more storage than is available in the PersistentVolume then the claim won't be able to bind to the pv.
```
vim hostpath-pvc.yml

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: hostpath-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 200Mi
  storageClassName: slow

kubectl apply -f hostpath-pvc.yml

persistentvolumeclaim/hostpath-pvc created

kubectl get pvc hostpath-pvc

NAME           STATUS   VOLUME        CAPACITY   ACCESS MODES   STORAGECLASS   AGE
hostpath-pvc   Bound    hostpath-pv   1G         RWO            slow           50m

```
The PersistentVolumeClaim is created and it should automatically bind to the PersistentVolume.

To check run `kubectl get pvc` on the claim.

Under status, you should see  'Bound'.

Under volume you should see the name of the PersistentVolume to which claim is bound.

Now that the PersistentVolumeClaim is bound to the PersistentVolume we should be able to mount it to an actual container within a Pod.

Create a file called pv-pod-test.yml,

Create a Pod that will read some data from /data/data.txt.

Mount the PersistentVolumeClaim as with any other volume.

Under the Pod spec create a volume called pv-host-data.
```
vim pv-pod-test.yml

apiVersion: v1
kind: Pod
metadata:
  name: pv-pod-test
spec:
  restartPolicy: OnFailure
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'cat /data/data.txt']
    volumeMounts:
    - name: pv-host-data
      mountPath: /data
  volumes:
  - name: pv-host-data
    persistentVolumeClaim:
      claimName: hostpath-pvc

kubectl apply -f pv-pod-test.yml

pod/pv-pod-test created

kubectl get pod pv-pod-test

NAME          READY   STATUS      RESTARTS   AGE
pv-pod-test   0/1     Completed   0          54s

kubectl logs pv-pod-test

This is worker 2!
```
To mount a PersistentVolumeClaim in a Pod, use the field pod.spec.volumes persistentVolumeClaim and then use the claimName: field with a value of 'hostpath-pvc', the name of the pvc we created above.

Now that you have the volume you can mount it to the container using the volumeMounts field, and refer to the name, pv-host-data.

Specify the mountPath which is going to be /data.

Save, exit, apply.  Check the pod's status.

`kubectl get pod pv-pod-test`

Check the logs.
it says, has worker 2.

It looks like the Pod is successfully able to read that data from the PersistentVolume.
We've successfully created a PersistentVolume.
We created a PersistentVolumeClaim that was able to bind to that PersistentVolume.
We created a Pod with a container that utilizes that PersistentVolume storage.

Exam tips
- A PersistentVolume defines a storage resource.
- A PersistentVolumeClaim defines a request to consume a storage resource.
- PersistentVolumeClaims automatically bind to a PersistentVolume that meets their criteria.
- You can mount a PersistentVolumeClaim to a container within a Pod as with other volume types.

### 2.9 Lab: Using Container Volume Storage in Kubernetes

[Lesson Reference]()

<span style="float:right">[Lab diagram](images/container-volume-storage-lab.png)</span><br />

<img src="images/container-volume-storage-lab.png"
     alt="Lab diagram:  Using Container Volume Storage in Kubernetes"
     style="float: right; margin-right: 10px; margin-bottom: 10px;"
     width="80%" />

Lab Objectives

Successfully complete lab by achieving the following learning objectives:

Add an Ephemeral Volume

- The application is managed by the app-processing Deployment in the default Namespace
- The application needs to write some temporary data, but it cannot write directly to the container file system because it is set as read-only.  Use a volume to create a temporary storage location at /tempdata.

Add a Persistent Volume

- The application is managed by the app-processing Deployment in the default Namespace. Use a PersistentVolume to mount data from the k8s host to the application's container. The data is located at /etc/voldata on the host. Set up the PersistentVolume to access data using directory mode.
- For the PersistentVolume, set a capacity of 1Gi. Set the access mode to ReadWriteOnce, and set the storage class to host.
- For the PersistentVolumeClaim, set the storage request to 100Mi. Mount it to /data in the container.
- Note: The application is set up to read data from the PersistentVolumeClaim's mounted location, then write it to the ephemeral volume location, and read it back from the ephemeral volume to the container log. means that if everything is set up properly, you see the Hive Key data in the container log!

Welcome to HiveCorp, a software design company that is totally not run by bees!

The company is always working to store things, mainly honey. Don't ask why! But right now, we  need to handle storing some data for the containers.

The application needs two forms of storage:

An ephemeral storage location to store some temporary data outside the container file system.  A Persistent Volume that utilizes a directory on the local disk of the worker node.  Modify the application's deployment to implement these storage solutions.

Kubernetes offers a variety of tools to help you manage external storage for your containers. In lab, you will have a chance to work with Kubernetes storage volumes, in the form of both ephemeral volumes and Persistent Volumes.

Solution

Log in to the server using the credentials provided:

ssh cloud_user@<PUBLIC_IP_ADDRESS>

Add an Ephemeral Volume

Begin by editing the application's Deployment:
```
kubectl edit deployment app-processing
```
Scroll down to the Deployment's Pod template.  Under the Pod template, nxote thzspecification. Add the following (under terminationMessagePolicy) to create the ephemeral storage volume with the volume mount.

Note: When copying and pasting code into Vim from the lab guide, first enter :set paste (and then i to enter insert mode) to avoid adding unnecessary spaces and hashes. To save and quit the file, press Escape followed by :wq. To exit the file without saving, press Escape followed by :q!.

            volumeMounts:
            - name: temp
              mountPath: /tempdata
          volumes:
          - name: temp
            emptyDir: {}

Type ESC followed by :wq to save your changes and to update the Deployment.
```
k edit deployment app-processing
```
deployment.apps/app-processing edited

Add a Persistent Volume

Create the PersistentVolume.
```
vi hostdata-pv.yml

apiVersion: v1
kind: PersistentVolume
metadata:
  name: hostdata-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteOnce
  storageClassName: host
  hostPath:
    path: /etc/voldata
    type: Directory

kubectl apply -f hostdata-pv.yml

persistentvolume/hostdata-pv created
```
Create a PersistentVolumeClaim:
```
vi hostdata-pvc.yml
```
Add the following to create the PersistentVolumeClaim that will bind to the PersistentVolume:
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: hostdata-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 100Mi
  storageClassName: host
```
Type ESC followed by :wq to save your changes.

Create the claim:
```
kubectl apply -f hostdata-pvc.yml

persistentvolumeclaim/hostdata-pvc created
```
Verify that the PersistentVolumeClaim is bound to the PersistentVolume:
```
kubectl get pvc hostdata-pvc

k get pvc hostdata-pvc
NAME           STATUS   VOLUME        CAPACITY   ACCESS MODES   STORAGECLASS   AGE
hostdata-pvc   Bound    hostdata-pv   1Gi        RWO            host           33s
```
Edit the Deployment, and mount the PersistentVolumeClaim to the container:

kubectl edit deployment app-processing

Scroll down to the volume spec. Under volumes, add the hostdata volume:

volumes:
- name: temp
  emptyDir: {}
- name: hostdata
  persistentVolumeClaim:
    claimName: hostdata-pvc

Scroll up, and under volumeMounts, mount the new volume to the container:

        volumeMounts:
        - name: temp
          mountPath: /tempdata
        - name: hostdata
          mountPath: /data

Type ESC followed by :wq to save your changes and update the Deployment.
```
deployment.apps/app-processing edited
```
Check the Pod status:
```
kubectl get pods

NAME                              READY   STATUS    RESTARTS   AGE
app-processing-6677ddff48-dpcnx   1/1     Running   0          34s
```
You should see that your new Pod for the Deployment is up and running.

Copy the name of the active Deployment Pod. The name will begin with 'app-processing-', but it will be the Pod that is in the Running status — not the Terminating status. Use the Pod name to check the Pod's container logs:
```
kubectl logs $POD_NAME

Hive Key:IQP7c6dTxOQA80Cf4UAk
Hive Key:IQP7c6dTxOQA80Cf4UAk
Hive Key:IQP7c6dTxOQA80Cf4UAk
```
If everything is set up correctly, you should see the Hive Key data in the Pod's logs.

Congratulations — you've completed hands-on lab!

### 2.10 Application Design and Build Quiz - 12 Questions


### 2.11 Application Design and Build Summary

[Lesson Reference]()

- container images - files that include all the software needed to run a container
  - A Dockerfile defines the contents of an image and the docker build command builds an image using that Dockerfile.
- Jobs - designed to run a containerized task successfully to completion (once)
- CronJobs - runs that Job task periodically according to a schedule
  - restartPolicy for a Job or CronJob Pod must be set to OnFailure or Never
  - activeDeadlineSeconds field in the Job spec terminates a Job after a certain number of seconds if it runs too long.

- multi-container Pods
  - sidecar container performs some task that helps the main container.
  - ambassador container proxies network traffic to and/or from the main container.
  - adaptor container transforms the main container's output.

- init containers - containers that run to completion before the main container starts up.  You can add init containers using the initContainers field of the PodSpec.

- container storage in the form of volumes and PersistentVolumes.






- volumes
  - the volumes field in the Pod spec defines details about volumes used in the Pod
    - the hostPath volume type mounts of data from a specific location on the host, which is the Kubernetes node.
  - the volumeMounts field in the container spec mounts a volume to a specific container at a specific location.


- hostPath volume types:
  - Directory - mounts an existing directory on the host.
  - DirectoryOrCreate - mounts a directory on the host, and creates it if it doesn't already exist.
  - File - mounts an existing single file on the host.
  - FileOrCreate - mounts a single file on the host, and creates it if it doesn't exist.
  - emptyDir - volume type provides temporary storage that uses the host file system; these temporary storage files are removed if the Pod is deleted.

- PersistentVolume defines a storage resource
- PersistentVolumeClaim defines a request to consume a storage resource. PersistentVolumeClaims automatically bind to a PersistentVolumes that meet their criteria.
  - once a PersistentVolumeClaim is bound you can mount that claim to a container  like a regular volume in order to use the PersistentVolume storage in your container.


## CHAPTER 3 Application [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

### 3.1 Application Deployment Intro

[Lesson Reference]()

Kubernetes Deployments
- used to manage multiple replica Pods
- rolling updates - rolling out new code with zero downtime.

Deployment strategies
- rolling updates (default)
- blue-green and canary deployments,
- Helm package manager, a tool for deploying pre-made configurations to your Kubernetes cluster.


### 3.2 Understanding Deployments

[Lesson Reference](https://acloudguru-content-attachment-production.s3-accelerate.amazonaws.com/1642602135941-1077%20-%20S03L02%20Understanding%20Deployments.pdf)

A Kubernetes Deployment is an object that defines a desired state for a set of replica Pods.

Kubernetes will constantly work to maintain that desired state by creating, deleting, and replacing Pods.

A Deployment allows us to manage a desired state across multiple replica Pods.

A Deployment manages multiple replica Pods using a Pod template, which is a shared configuration.

A Deployment uses a Pod template to create new replicas.

The concept of Deployment replicas makes it easy to achieve scaling with the applications in Kubernetes.

Each Deployment has a replicas field that determines the number of replicas in that Deployment.

If the Deployment specifies three replicas the Deployment will create three Pods.  We can change the replica number in order to scale up or scale down.

If we change replicas in the Deployment configuration to five the Deployment will create two additional replica Pods in order to ensure that desired state is achieved and there are five replicas.

A deployment is intended for perpetually-running workloads, so the activeDeadlineSeconds field does not apply.


Exam Tips

- A Deployment actively manages a desired state for a set of replica Pods.
- The Pod template provides the Pod configuration that the Deployment will use to create new Pods.
- The replicas field sets the number of replicas. You can scale up or down by changing its value.

[Lesson Reference](https://acloudguru-content-attachment-production.s3-accelerate.amazonaws.com/1642602135941-1077%20-%20S03L02%20Understanding%20Deployments.pdf)

Log in to the control plane node.

Create a Deployment that runs some replica Pods that run an nginx web server image.

```
vi nginx-deployment.yml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80

kubectl apply -f nginx-deployment.yml

deployment.apps/nginx-deployment created
```
Check the status of the Deployment.
```
kubectl get deployments

NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   2/2     2            2           19s
```
Check the Deployment's replica Pods.
```
kubectl get pods

NAME                                READY   STATUS             RESTARTS         AGE
...
nginx-deployment-6595874d85-hhcws   1/1     Running            0                41s
nginx-deployment-6595874d85-ndw5k   1/1     Running            0                41s
...
```
Scale the Deployment from the command line.
```
kubectl scale deployment/nginx-deployment --replicas=4
# OR
kubectl scale deploymentnginx-deployment --replicas=4

deployment.apps/nginx-deployment scaled
```
Check the Deployment's status and replica Pods.
```
k get deployments

NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   4/4     4            4           2m55s

k get deployment nginx-deployment

NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   4/4     4            4           3m2s

kubectl get pods

NAME                                READY   STATUS      RESTARTS         AGE
...
nginx-deployment-6595874d85-hhcws   1/1     Running     0                6m52s
nginx-deployment-6595874d85-lnvkw   1/1     Running     0                5m2s
nginx-deployment-6595874d85-ltwnq   1/1     Running     0                5m2s
nginx-deployment-6595874d85-ndw5k   1/1     Running     0                6m52s
...
```
Scale by editing the Deployment spec.
```
kubectl edit deployment nginx-deployment

spec:
...
replicas: 2

deployment.apps/nginx-deployment edited
```
Check the Deployment's status and replica Pods.
```
kubectl get deployment nginx-deployment

kubectl get pods
```
Copy the full name of one of the active Deployment Pods. Delete that Pod.
```
kubectl delete pod <Pod name> --force
kubectl delete pod <Pod name> --grace-period=0 --force
```
List the Pods again. The Deployment will maintain desired state by creating a new replica to replace the deleted Pod.
```
kubectl get pods
```
We will have two replicas in the Deployment.  Two Pods will be created.

The cluster will use the **selector field** to identify which Pods belong to the Deployment and which Pods the Deployment is going to manage.

A `matchLabels` selector describes the way K8s will identify Pods is based on their labels.

Setting `labels: app: nginx` means Pods that have the `app: nginx` label are going to be considered part of Deployment.

The Pod template is a shared configuration that will be used by Pods that Deployment creates.

The Deployment spins up replicas that will be configured per the provided Pod specification.

The Pod template looks like a Pod specification for a single standalone Pod.

We need to attach the `app: nginx` label to those Pods so that they will be considered managed by the Deployment.

Otherwise you have a regular container specification and to run a single container with the nginx:1.14.2 image.

Specify containerPort: 80.

Nginx is a web server and by default Nginx listens on port 80.

Once the Deployment is created, view the status with `kubectl get deployments` and `kubectl get pods`.

Ways to scale a Deployment:

- `kubectl scale deployment [DEPLOYMENT NAME] --replicas=#
- `kubectl edit deployment nginx-deployment`.  In the YAML specification of the Deployment object, change the replicas value and save the file.

Deployments maintaining a desired state.

A Deployment actively manages a desired state for a set of replica Pods.

The Pod template provides the Pod configuration that the Deployment will use to create new Pods.


### 3.3 Performing Rolling Updates

[Lesson Reference](https://acloudguru-content-attachment-production.s3-accelerate.amazonaws.com/1642602142648-1077%20-%20S03L03%20Performing%20Rolling%20Updates.pdf)

[Updating a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment)


A rolling update allows you to change a Deployment's Pod template, gradually replacing replicas with zero downtime.

You can use a rolling update to deploy new code.

Modify the Pod template and change it into a new Pod template.

K8s will update replicas to reflect that new Pod template.

K8s will not delete the old replicas all at once and then spin up some new replicas because then our application would be become unavailable briefly.

Instead, K8s will do a rolling update: we gradually spin up new replicas using the new Pod template and gradually remove those old replicas as the new replicas become available.

Our changes to the template are rolled out gradually without downtime for our users.

Create rolling-deployment.yml with five replicas.

```
vi rolling-deployment.yml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: rolling-deployment
  namespace: kitty
spec:
  replicas: 5
  selector:
    matchLabels:
      app: rolling
  template:
    metadata:
      labels:
        app: rolling
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80

kubectl apply -f rolling-deployment.yml

deployment.apps/rolling-deployment created
```
Update the container image version to 1.16.1 using:
```

kubectl set image deployment rolling-deployment nginx=nginx:1.16.1

# OR

k set image deployment rolling-deployment nginx=nginx:1.16.1 && k get rs

k set image deployment rolling-deployment nginx=nginx:1.14.2 && k get rs

```
`kubectl set ...` initiates a rolling deployment.

`kubectl set SUBCOMMAND` helps you make changes to existing application resources.

Check the status of a rolling update using the kubectl rollout status command,
```
kubectl get deployment rolling-deployment

k get rs

NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
rolling-deployment   5/5     5            5           33s
```
The terminal output above means all the replicas are running the new image and all of the old replicas were removed.

You can also initiate a rolling deployment by editing the Deployment manifest.

Change the image in the Pod template to 1.20.1 and save the file.

If there is a problem with your update, perhaps a major bug in the code, I may want to roll back to the previous version.
```
k rollout undo deployment rolling-deployment && k get rs
```
K8s treats this undo process as a separate rollout.

So I can monitor that with kubectl rollout status as well, and it's already completed.

And if I do kubectl get pods,
you can see all of my new Pods.
They're created by that undo process.
And I'll just copy the name of one of those Pods.
Just do kubectl describe pod.
And if I look at my container image,
I can see it's gone back to 1.16.1
because of that rollout undo.
Before we end the video,
let's go through a few quick exam tips.
First, a rolling update gradually rolls out changes
to a Deployment's Pod template by gradually
replacing replicas with new ones.
Second, we can use the `kubectl rollout status` command
to check the status of a rolling update,

roll back the latest rolling update with kubectl rollout undo.


Log in to the control plane node.  Create a Deployment.

```
vi rolling-deployment.yml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: rolling-deployment
spec:
  replicas: 5
  selector:
    matchLabels:
      app: rolling
  template:
    metadata:
      labels:
        app: rolling
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80

kubectl apply -f rolling-deployment.yml

deployment.apps/rolling-deployment created
```
Check the Deployment status and wait for all of the replicas to fully start up.
```
kubectl get deployment rolling-deployment
k get rs

NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
rolling-deployment   5/5     5            5           33s
```
Update the Deployment's image.
```
kubectl set image deployment.v1.apps/rolling-deployment nginx=nginx:1.16.1

# OR

kubectl set image deployment/rolling-deployment nginx=nginx:1.16.1

kubectl set image deploy rolling-deployment nginx=nginx:1.16.1 && kubectl rollout status deploy rolling-deployment

kubectl rollout status deploy rolling-deployment

deployment.apps/rolling-deployment image updated
```
View the list of Pods. The Deployment's Pods will be gradually replaced with new Pods running the new image version.

kubectl get pods

View the status of the rollout.
```
kubectl rollout status deployment/rolling-deployment

k set image deployment.v1.apps/rolling-deployment nginx=nginx:1.14.1
# OR
k set image deployment/rolling-deployment nginx=nginx:1.14.1

deployment.apps/rolling-deployment image updated

k rollout status deployment/rolling-deployment
Waiting for deployment "rolling-deployment" rollout to finish: 3 out of 5 new replicas have been updated...
Waiting for deployment "rolling-deployment" rollout to finish: 4 out of 5 new replicas have been updated...
Waiting for deployment "rolling-deployment" rollout to finish: 2 old replicas are pending termination...
Waiting for deployment "rolling-deployment" rollout to finish: 2 old replicas are pending termination...
Waiting for deployment "rolling-deployment" rollout to finish: 1 old replicas are pending termination...
Waiting for deployment "rolling-deployment" rollout to finish: 4 of 5 updated replicas are available...
deployment "rolling-deployment" successfully rolled out
```
You can also perform a rolling update by editing the Deployment manifest.
```
kubectl edit deployment rolling-deployment
```
Change the container image.
```
containers:
- name: nginx
image: nginx:1.20.1
```
Save the file to initiate the rolling update.

Check rollout status.
```
kubectl rollout status deployment/rolling-deployment
```
Wait for the rollout to finish, then roll back to the previous version ( 1.16.1 ).
```
kubectl rollout undo deployment/rolling-deployment
```
Check rollout status and the Pods.
```
kubectl rollout status deployment/rolling-deployment
kubectl get pods
```
Copy one of the pod names. Use it to check one of the pod to see that it is using the 1.16.1 image version.
```
kubectl describe pod <Pod name>
```
Exam Tips
- A rolling update gradually rolls out changes to a Deployment’s Pod template by gradually replacing replicas with new ones.
- Use `kubectl rollout status deploy [deployment_name]` to check the status of a rolling update.
- Roll back the latest rolling update with: `kubectl rollout undo`.


### 3.4 Deployment Strategies: Blue/Green and Canary

[Lesson Reference](https://acloudguru-content-attachment-production.s3-accelerate.amazonaws.com/1642602149596-1077%20-%20S03L04%20Deploying%20with%20BlueGreen%20and%20Canary%20Strategies.pdf)

Documentation

[Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

[Service](https://kubernetes.io/docs/concepts/services-networking/service/)


A Deployment strategy is a method of rolling out new code.

A blue/green Deployment strategy involves using two identical production environments usually called blue and green.

Users are using the blue environment.

We want to roll out new code with a blue/green Deployment strategy.  First our new code is rolled out to the new, green, environment.

We don't direct user traffic to the new environment until we confirm that the new environment is confirmed to be stable and working.

The canary strategy also employs a second environment, usually called the canary environment.   Unlike the blue/green deployment strategy, only a portion of the user base is directed to this new code in order to expose any issues before the changes are rolled out to everyone else.

So we allow a small portion of our user base to use that new environment, and once we've confirmed that everything is working, we roll out those changes to the main production environment as well, and then direct all of our users to that updated main production environment.

So the basic difference between blue/green and canary is that with canary, we are actually directing a small portion of our user base to the new code for testing purposes.

#### Blue-Green Deployment

Create a blue-deployment.yml manifest with an nginx web server with a custom image.  The server will return a message identifying the server as blue or green.

We add a label 'color: blue' to the selector and metadata to identify this Deployment's Pods
as being part of that blue environment.
```
vi blue-deployment.yml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: blue-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: bluegreen-test
      color: blue
  template:
    metadata:
      labels:
        app: bluegreen-test
        color: blue
    spec:
      containers:
      - name: nginx
        image: linuxacademycontent/ckad-nginx:blue
        ports:
        - containerPort: 80

kubectl apply -f blue-deployment.yml

deployment.apps/blue-deployment created
```
Set up a service to direct traffic to our environment and to those Pods that we just created.
```
vi bluegreen-test-svc.yml

apiVersion: v1
kind: Service
metadata:
  name: bluegreen-test-svc
spec:
  selector:
    app: bluegreen-test
    color: blue
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80

kubectl apply -f bluegreen-test-svc.yml

service/bluegreen-test-svc created

k get svc bluegreen-test-svc

NAME                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
bluegreen-test-svc   ClusterIP   10.100.181.118   <none>        80/TCP    80s

curl  10.100.181.118

I'm Blue!

```

pretend that we want to roll out some new code, and let's do that using a blue/green deployment strategy.

Create a separate Deployment, green-deployment.yml, the same as blue-deployment, except:
- name: green-deployment
- color: green
- image: linuxacademycontent/ckad-nginx:green


Make sure that our green environment is actually working before we switch users over to that new environment.
```
kubectl get pods -o wide to obtain the Pod IP address there for the green-deployment Pod.
```
curl the IP address.

response says "I'm green."
our green environment is working.

the next step is actually to direct our user traffic to that new green environment.
And I can do that by editing my Kubernetes service.

So I'll just do kubectl edit service on bluegreen-test-svc.

And I'll come down here to the selector that's part of my service spec, and change the label from blue to green

kubectl get service to get that Service IP address.

curl the IP,
it says "I'm green."

The Service now directs users to the new green environment after we spun up a new Deployment and verified that everything was working.

To implement a blue/green deployment strategy in Kubernetes we created a second Deployment
that was pretty much the same, except it had different labels and a new code version.

We verified that it was working and then we pointed our Service to that new Deployment's Pods.

#### Canary Deployment

Create a basic Deployment with three repicas in main-deployment.yml.

```
vi main-deployment.yml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: main-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: canary-test
      environment: main
  template:
    metadata:
      labels:
        app: canary-test
        environment: main
    spec:
      containers:
      - name: nginx
        image: linuxacademycontent/ckad-nginx:1.0.0
        ports:
        - containerPort: 80

kubectl apply -f main-deployment.yml

deployment.apps/main-deployment created
```
There are 3 replicas in the main-deployment and I have labels `app: canary-test` and `environment: main`.

image version 1.0.0.

Create a Service to direct user traffic to our Pods: create canary-test-svc.yml
```
vi canary-test-svc.yml

apiVersion: v1
kind: Service
metadata:
  name: canary-test-svc
  namespace: kitty
spec:
  selector:
    app: canary-test
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80

kubectl apply -f canary-test-svc.yml

service/canary-test-svc created
```

Our selector says app equals canary-test but **we do not specifically select the main environment.**

You may remember that our Deployment the pods had an 'environment: main' label, but with a canary Deployment, we are simultaneously directing traffic to both the main environment and the canary environment.

So we don't want to specifically select just the main environment because we want to direct traffic to both.

So I'll save and exit that file, and then create my Service with kubectl apply.

Test it out with kubectl get svc and curl the IP address.

"I'm the main production environment."

So how do we perform a canary Deployment now that we have our main environment up and running?

Well, I'm going to create a YAML file called canary-deployment.yml.
```
vi canary-deployment.yml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: canary-deployment
  namespace: kitty
spec:
  replicas: 1
  selector:
    matchLabels:
      app: canary-test
      environment: canary
  template:
    metadata:
      labels:
        app: canary-test
        environment: canary
    spec:
      containers:
      - name: nginx
        image: linuxacademycontent/ckad-nginx:canary
        ports:
        - containerPort: 80

kubectl apply -f canary-deployment.yml

deployment.apps/canary-deployment created
```

And just like with a blue/green setup, we can use an additional Deployment basically to create that additional canary environment.

matchLabels, the same app, but this time the environment is canary.

image version is canary, the new version of the code.

But how are we making sure that we actually direct only a small portion of our traffic to this canary environment?

Well, one simplistic way to do direct only a small portion of the traffic to the canary deployment is to deploy fewer replicas.

The main deployment had three replicas, The canary environment has one replica.

But the Service will direct traffic to the Pods from both environments.

we have 3 Pods that are in the main environment, 1 in the canary environment,
and therefore, approximately 1/4 of the traffic will be directed to the canary environment because it only has one replica while the main environment has 3.

Of course, that's a very simplistic way to implement this canary structure, but just with the basic building blocks of Deployments in Kubernetes, it's an easy enough way for us to implement that for our purposes right now.

use kubectl apply to create that canary Deployment.
So the Deployment is already created,

and because of the way our labels are set up on our Service,
we should already be directing traffic to both environments.

So I'm just going to get that canary-test-svc again, copy the IP address,
and just test that out.

curl the IP.

approximately 1/4 of the traffic would go to that canary environment.

But all that's important for us to really see right now is that we are getting responses from both of those environments.
our canary Deployment setup is working as expected.

Exam tips.
- use multiple Deployments to set up blue/green environments in Kubernetes.
- Use labels and selectors on services to direct user traffic to different Pods.
- a canary environment can be set up by using a Service that selects Pods from 2 different Deployments.
- Vary the number of replicas to direct fewer users to the canary environment.

#### Blue-Green Deployment

Create a Deployment in the control plane:
```
vi blue-deployment.yml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: blue-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: bluegreen-test
      color: blue
  template:
    metadata:
      labels:
        app: bluegreen-test
        color: blue
    spec:
      containers:
      - name: nginx
        image: linuxacademycontent/ckad-nginx:blue
        ports:
        - containerPort: 80

kubectl apply -f blue-deployment.yml

deployment.apps/blue-deployment created
```
A Service is an abstract way to expose an application running on a set of Pods as a network service.

With Kubernetes you don't need to modify your application to use an unfamiliar service discovery mechanism.  Kubernetes gives Pods their own IP addresses and a single DNS name for a set of Pods, and can load-balance across them.

Kubernetes Pods are created and destroyed to match the desired state of your cluster. Pods are nonpermanent resources. If you use a Deployment to run your app, it can create and destroy Pods dynamically.

Each Pod gets its own IP address, however in a Deployment, the set of Pods running in one moment in time could be different from the set of Pods running that application a moment later.

This leads to a problem: if some set of Pods (call them "backends") provides functionality to other Pods (call them "frontends") inside your cluster, how do the frontends find out and keep track of which IP address to connect to, so that the frontend can use the backend part of the workload?

In Kubernetes, a Service is an abstraction which defines a logical set of Pods and a policy by which to access them (sometimes this pattern is called a micro-service). The set of Pods targeted by a Service is usually determined by a selector. To learn about other ways to define Service endpoints, see Services without selectors.

For example, consider a stateless image-processing backend which is running with 3 replicas. Those replicas are fungible—frontends do not care which backend they use. While the actual Pods that compose the backend set may change, the frontend clients should not need to be aware of that, nor should they need to keep track of the set of backends themselves.

The Service abstraction enables this decoupling.

Create a Service to route traffic to the Deployment's Pods.
```
vi bluegreen-test-svc.yml

apiVersion: v1
kind: Service
metadata:
  name: bluegreen-test-svc
spec:
  selector:
    app: bluegreen-test
    color: blue
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80

kubectl apply -f bluegreen-test-svc.yml

service/bluegreen-test-svc created
```
Get the Service's cluster IP address.
```
kubectl get service bluegreen-test-svc

NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
bluegreen-test-svc   ClusterIP   10.97.32.163   <none>        80/TCP    29s
```
Test the Service.
```
curl <bluegreen-test-svc cluster IP address>

I'm Blue!

```
Create a green Deployment.
```
vi green-deployment.yml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: green-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: bluegreen-test
      color: green
  template:
    metadata:
      labels:
        app: bluegreen-test
        color: green
    spec:
      containers:
      - name: nginx
        image: linuxacademycontent/ckad-nginx:green
        ports:
        - containerPort: 80

kubectl apply -f green-deployment.yml

deployment.apps/green-deployment created
```
Verify the status of the green deployment.
```
kubectl get deployment green-deployment

NAME               READY   UP-TO-DATE   AVAILABLE   AGE
green-deployment   1/1     1            1           25s
```
Test the green Deployment's Pod directly to verify it is working before sending user traffic to it.

First, get the IP address of the green Deployment's Pod.
```
kubectl get pods -o wide

k get pods -o wide
NAME                                  READY   STATUS    RESTARTS   AGE   IP                NODE      NOMINATED NODE   READINESS GATES
blue-deployment-5849bb6bc4-gjtgm      1/1     Running   0          14m   192.168.235.169   worker1   <none>           <none>
green-deployment-6c6d95949b-mw97b     1/1     Running   0          66s   192.168.235.170   worker1   <none>           <none>
```
Copy the green-deployment Pod's IP address and use it to test the Pod.
```
curl <green-deployment Pod IP address>

I'm green!

```
Edit the Service selector so that it points to the green Deployment's Pods.
```
kubectl edit service bluegreen-test-svc

spec:
  selector:
  app: bluegreen-test
  color: green
```
Test the Service again. The response should indicate that you are communicating with the green version Pod.
```
kubectl get service bluegreen-test-svc

NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
bluegreen-test-svc   ClusterIP   10.97.32.163   <none>        80/TCP    11m

curl <bluegreen-test-svc cluster IP address>

I'm green!  (Previously I'm Blue!)
```

#### Canary Deployment

Create a main Deployment.
```
vi main-deployment.yml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: main-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: canary-test
      environment: main
  template:
    metadata:
      labels:
        app: canary-test
        environment: main
    spec:
      containers:
      - name: nginx
        image: linuxacademycontent/ckad-nginx:1.0.0
        ports:
        - containerPort: 80

kubectl apply -f main-deployment.yml

deployment.apps/main-deployment created
```
Create a Service.
```
vi canary-test-svc.yml

apiVersion: v1
kind: Service
metadata:
  name: canary-test-svc
spec:
  selector:
    app: canary-test
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80

kubectl apply -f canary-test-svc.yml

service/canary-test-svc created
```
Get the Service's cluster IP address.
```
kubectl get service canary-test-svc

NAME              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
canary-test-svc   ClusterIP   10.109.74.133   <none>        80/TCP    23s
```
Test the Service. At point, you should only get responses from the main environment.
```
curl <canary-test-svc cluster IP address>

I'm the main production environment!
```
Create a canary Deployment.
```
vi canary-deployment.yml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: canary-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: canary-test
      environment: canary
  template:
    metadata:
      labels:
        app: canary-test
        environment: canary
    spec:
      containers:
      - name: nginx
        image: linuxacademycontent/ckad-nginx:canary
        ports:
        - containerPort: 80

kubectl apply -f canary-deployment.yml

deployment.apps/canary-deployment created
```
Test the Service again. Re-run command multiple times. You should get responses from both the main environment and the canary environment.
```
curl <canary-test-svc cluster IP address>

I'm the canary!

curl  10.109.74.133
I'm  the main production environment!

curl  10.109.74.133
I'm the main production environment!
```

Exam Tips

- You can use multiple Deployments to set up blue/green environments in Kubernetes.
- Use labels and selectors on Services to direct user traffic to different Pods.
- A simple way to set up a canary environment in Kubernetes is to use a Service that selects Pods from 2 different Deployments. Vary the number of replicas to direct fewer users to the canary environment.

### 3.5 Lab: Advanced Rollout with Kubernetes Deployments

[Lesson Reference]()

Welcome to HiveCorp, a software design company that is totally not run by bees!

We need to ship new software versions for the Kubernetes applications!

We have a web frontend application that needs to be updated to a new version. Since the application is customer-facing, use a **rolling update** to roll out the new version with zero service interruptions.

We also have an internal API that needs to be updated. The team is concerned about stability issues that have occurred during past Deployments leading to lost productivity.  Use a **blue/green Deployment* strategy to test the new version and ensure that it is working before directing user traffic to it.

Learning Objectives
- Perform a Rolling Update
  - There is a Deployment in the hive Namespace called web-frontend.
  - Update the image used in the Deployment's Pod to nginx:1.16.1.

- Perform a Blue/Green Deployment
  - There is a Deployment in the hive Namespace called internal-api-blue.
  - A Service called api-svc directs traffic to this Deployment's Pods.
  - You can find a YAML manifest for the Deployment at /home/cloud_user/internal-api-blue.yml. Make a copy of this manifest at /home/cloud_user/internal-api-green.yml. Modify the manifest to create a green Deployment called internal-api-green. For the green Deployment, use the image linuxacademycontent/ckad-nginx:green.
  - Update the Service to point only to the green Deployment's Pods.

```
cat internal-api-blue.yml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: internal-api-blue
  namespace: hive
spec:
  replicas: 1
  selector:
    matchLabels:
      app: internal-api
      color: blue
  template:
    metadata:
      labels:
        app: internal-api
        color: blue
    spec:
      containers:
      - name: nginx
        image: linuxacademycontent/ckad-nginx:blue
        ports:
        - containerPort: 80
```
<span style="float:right">[Lab diagram](images/3_4_advanced_rollout.png)</span><br />

<img src="images/rolling-update.png"
     alt="Lab diagram: Rolling Update"
     style="float: right; margin-right: 10px; margin-bottom: 10px;"
     width="80%" />

<img src="images/3_4_advanced_rollout.png"
     alt="Lab diagram: Advanced Rollout with Kubernetes Deployments"
     style="float: right; margin-right: 10px; margin-bottom: 10px;"
     width="80%" />

The basic features of Kubernetes can be used to implement advanced Deployment strategies such as blue/green Deployments. In lab, you will have the opportunity to try your hand at implementing these strategies in Kubernetes.

Learning Objectives
- Perform a Rolling Update
- Perform a Blue/Green Deployment

Solution

Log in to the server using the credentials provided:
```
ssh cloud_user@<PUBLIC_IP_ADDRESS>
```
#### Perform a Rolling Update

Check the Deployment configuration (the web-frontend in the hive Namespace):
```
k get deployments -n hive

NAME                READY   UP-TO-DATE   AVAILABLE   AGE
internal-api-blue   1/1     1            1           156m
web-frontend        5/5     5            5           156m

kubectl describe deployment web-frontend -n hive

Name:                   web-frontend
Namespace:              hive
CreationTimestamp:      Fri, 23 Dec 2022 20:35:22 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=web-frontend
Replicas:               5 desired | 5 updated | 5 total | 5 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=web-frontend
  Containers:
   nginx:
    Image:        nginx:1.14.2
    Port:         <none>
    Host Port:    <none>
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   web-frontend-5ff599d8bf (5/5 replicas created)
Events:          <none>
```
Take note of the container's name, in case, 'nginx'.

Perform a rolling (image) update on the Deployment.  Update the image version to 1.16.1 from 1.14.1.
```
kubectl set image deployment.v1.apps/web-frontend -n hive nginx=nginx:1.16.1
OR:
k set image deployment/web-frontend -n hive nginx=nginx:1.16.1
OR:
k edit deployment web-frontend -n hive

deployment.apps/web-frontend image updated
```
Check the status of the rollout:
```
kubectl rollout status deployment/web-frontend -n hive
```
You should be able to see the status of the rollout while it occurs.

Check the Deployment's Pods in the hive Namespace:
```
kubectl get pods -n hive
```
You should see that the Deployment's Pods are now running the new image version.

#### Perform a Blue/Green Deployment

Make a copy of the blue Deployment manifest, changing the name so that it is for a green Deployment:
```
cp internal-api-blue.yml internal-api-green.yml
```
Edit the green Deployment manifest:
```
vi internal-api-green.yml
```
Make the following changes to the manifest:

- Change the Deployment's name to internal-api-green.
- Change the color value under matchLabels and under template to green.
- Change the image to linuxacademycontent/ckad-nginx:green.

The manifest should now look like this:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: internal-api-green
  namespace: hive
spec:
  replicas: 1
  selector:
    matchLabels:
      app: internal-api
      color: green
  template:
    metadata:
      labels:
        app: internal-api
        color: green
    spec:
      containers:
      - name: nginx
        image: linuxacademycontent/ckad-nginx:green
        ports:
        - containerPort: 80
```

Type ESC followed by :wq to save your changes.

Create the green Deployment.
```
kubectl apply -f internal-api-green.yml
```
Check the green Deployment status:
```
kubectl get deployments -n hive

NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
internal-api-blue    1/1     1            1           173m
internal-api-green   1/1     1            1           25s
web-frontend         5/5     5            5           173m
```
Obtain a list of Pods in the hive Namespace:

```
kubectl get pods -n hive -o wide

internal-api-blue-84957f7888-fjjsd    1/1     Running   0          174m    192.168.194.64   k8s-worker1   <none>           <none>
internal-api-green-697bc6fb8b-l6gbw   1/1     Running   0          118s    192.168.194.82   k8s-worker1   <none>           <none>
web-frontend-66bd977996-2nnwc         1/1     Running   0          9m29s   192.168.194.79   k8s-worker1   <none>           <none>
web-frontend-66bd977996-8xft4         1/1     Running   0          9m29s   192.168.194.77   k8s-worker1   <none>           <none>
web-frontend-66bd977996-9855m         1/1     Running   0          9m14s   192.168.194.81   k8s-worker1   <none>           <none>
web-frontend-66bd977996-b59wv         1/1     Running   0          9m29s   192.168.194.78   k8s-worker1   <none>           <none>
web-frontend-66bd977996-wjvt7         1/1     Running   0          9m14s   192.168.194.80   k8s-worker1   <none>           <none>
```
Copy the IP address for the Pod that is part of the green Deployment.  Use the green Deployment Pod's IP address to test the Pod directly:
```
curl <internal-api-green Pod IP address>
```
You should see the response, I'm green!

Edit the Service. You will be updating the Service so that it points to the green Deployment:
```
k get svc -n hive

NAME      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
api-svc   ClusterIP   10.105.115.31   <none>        80/TCP    176m

kubectl edit svc api-svc -n hive

cloud_user@k8s-control:~$ k get pods -n hive -o wide | grep Running

internal-api-blue-84957f7888-fjjsd    1/1     Running   0          174m    192.168.194.64   k8s-worker1   <none>           <none>
internal-api-green-697bc6fb8b-l6gbw   1/1     Running   0          118s    192.168.194.82   k8s-worker1   <none>           <none>
web-frontend-66bd977996-2nnwc         1/1     Running   0          9m29s   192.168.194.79   k8s-worker1   <none>           <none>
web-frontend-66bd977996-8xft4         1/1     Running   0          9m29s   192.168.194.77   k8s-worker1   <none>           <none>
web-frontend-66bd977996-9855m         1/1     Running   0          9m14s   192.168.194.81   k8s-worker1   <none>           <none>
web-frontend-66bd977996-b59wv         1/1     Running   0          9m29s   192.168.194.78   k8s-worker1   <none>           <none>
web-frontend-66bd977996-wjvt7         1/1     Running   0          9m14s   192.168.194.80   k8s-worker1   <none>           <none>

cloud_user@k8s-control:~$ curl 192.168.194.82
I'm green!

cloud_user@k8s-control:~$ curl  192.168.194.64
I'm Blue!

k get svc -n hive

NAME      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
api-svc   ClusterIP   10.105.115.31   <none>        80/TCP    176m

k edit svc api-svc -n hive

# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving file will be
# reopened with the relevant failures.
#
apiVersion: v1
kind: Service
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"name":"api-svc","namespace":"hive"},"spec":{"ports":[{"port":80,"protocol":"TCP","targetPort":80}],"selector":{"app":"internal-api","color":"blue"}}}
  creationTimestamp: "2022-12-24T14:35:34Z"
  name: api-svc
  namespace: hive
  resourceVersion: "565"
  uid: 8c80c80d-2894-4b5c-a433-ca772e820b3b
spec:
  clusterIP: 10.105.115.31
  clusterIPs:
  - 10.105.115.31
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: internal-api               
    color: blue
  sessionAffinity: None
  type: ClusterIP
status:
  loadBalancer: {}

```
Scroll down to the selector. Change the selector so that the Service directs traffic to the green Deployment's Pod:
```
  selector:
    app: internal-api
    color: green
```
Get the Service's CLUSTER-IP address:
```
kubectl get svc api-svc -n hive
```
Use the IP address to test the Service. The output should come from the green Pod:
```
curl <api-svc CLUSTER-IP address>
```
You should see the response, I'm green!

### 3.6 Installing Helm

[Lesson Reference](PDF/S03L05_Installing_Helm.pdf)

[Installing Helm](https://helm.sh/docs/intro/install/)

Log in to the control plane node.

Setup the Helm GPG key and package repository.
```
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -

echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helmstable-debian.list
```
Install the Helm package.
```
sudo apt-get update

sudo apt-get install -y helm
```
Verify the installation.
```
helm version

version.BuildInfo{Version:"v3.10.3", GitCommit:"835b7334cfe2e5e27870ab3ed4135f136eecc704", GitTreeState:"clean", GoVersion:"go1.18.9"}
```
Exam Tips

- Helm is a package management tool for Kubernetes applications.


### 3.7 Using Helm

[Lesson Reference](PDF/S03L06_Using_Helm.pdf)

[Helm Quickstart Guide](https://helm.sh/docs/intro/quickstart/)

A Helm chart is  a Helm software package.
- contains all of the Kubernetes resource definitions that are needed to get an application up and running in the cluster.
- Helm chart resource definitions are  the same thing as the YAML files that we've been creating to create objects like Pods, Deployments, and Services.
- Helm chart can be used to create several different objects in the cluster that compose a Kubernetes application.

Helm uses a packaging format called charts. A chart is a collection of files that describe a related set of Kubernetes resources. A single chart might be used to deploy something simple, like a memcached pod, or something complex, like a full web app stack with HTTP servers, databases, caches, and so on.

Charts are created as files laid out in a particular directory tree. They can be packaged into versioned archives to be deployed.

If you want to download and look at the files for a published chart, without installing it, you can do so with helm pull chartrepo/chartname.  Source: https://helm.sh/docs/topics/charts/


All of the configuration is packaged within a Helm chart making it easy to install applications in the cluster.

To install Helm charts we interact with a Helm repository.

A Helm repository is a collection of available charts.  You can use it to browse and download charts before installing them in your cluster.

We'll add a Helm repository and install a chart from that repository.

I'm logged in to the control plane node.

In the previous lesson, we installed Helm, so if, by any chance, you skipped over that lesson, you might want to go back and make sure that Helm is installed so that you can follow along.

Initialize a Helm Chart Repository

Once you have Helm ready, you can add a chart repository. Check Artifact Hub for available Helm chart repositories.

Use the `helm repo add` command to initialize a Helm repository.

We will add a repository called bitnami.

bitnami is a useful repository that has a lot of different useful Helm charts in it.

I'm  going to name it bitnami and then provide the URL, https://charts.bitnami.com/bitnami.

```
helm repo add bitnami https://charts.bitnami.com/bitnami
```
Update the local listings of packages from the repository,  with the `helm repo update` command.
Then I can view a list of all of the different charts that are available in the repository using the `helm search repo` command.

```
helm search repo bitnami
```
Searching the bitnami repo allows us to see the many available charts.

We will install a Helm chart called dokuwiki.

dokuwiki is a simple documentation tool.  We will use dokuwiki as an example for the purpose of lesson.

Before installing the Helm chart create a Namespace to help organize things.
We will keep everything for an application in its own Namespace.  Create a Namespace here called dokuwiki.  Then install the application with helm install.
```
k create namespace dokuwiki
```
Now I am going to set a special variable called persistence.enabled=false to remove the requirement to set up persistent volume storage for the application.  For the purposes of demonstration, we don't really care about going that deep and  setting up the storage solution, so we turn off persistence for easy installation.

Use the -n flag to specify the 'dokuwiki' Namespace.

```
helm install --set persistence.enabled=false -n dokuwiki dokuwiki bitnami/dokuwiki
```

We give a name to the application, calling it 'dokuwiki'.  Then we specify the name of the Helm chart, 'bitnami/dokuwiki'.

Run the command to install the Helm chart.

Examine objects created by the installation.
```
kubectl get pods -n dokuwiki
kubectl get deployments -n dokuwiki
kubectl get svc -n dokuwiki
```
The Helm chart contained all the configuration for those objects.

Complete clean up with helm uninstall and delete the Namespace.



#### Lesson Reference

Log in to the control plane node.

Add a Helm chart repository.
```
helm repo add bitnami https://charts.bitnami.com/bitnami

"bitnami" has been added to your repositories
```
Update the repository.
```
helm repo update

...Successfully got an update from the "bitnami" chart repository
Update Complete. ⎈Happy Helming!⎈
```
View a list of charts available in the repository.
```
helm search repo bitnami


NAME                                        	CHART VERSION	APP VERSION  	DESCRIPTION
bitnami/airflow                             	14.0.6       	2.5.0        	Apache Airflow is a tool to express and execute...
bitnami/apache                              	9.2.9        	2.4.54       	Apache HTTP Server is an open-source HTTP serve...
...
```
Create a Namespace.
```
kubectl create namespace dokuwiki

namespace/dokuwiki created
```
Install a chart.
```
helm install --set persistence.enabled=false -n dokuwiki dokuwiki bitnami/dokuwiki

NAME: dokuwiki
LAST DEPLOYED: Fri Dec 23 22:57:15 2022
NAMESPACE: dokuwiki
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: dokuwiki
CHART VERSION: 13.1.9
APP VERSION: 20220731.1.0

** Please be patient while the chart is being deployed **

1. Get the DokuWiki URL by running:

** Please ensure an external IP is associated to the dokuwiki service before proceeding **
** Watch the status using: kubectl get svc --namespace dokuwiki -w dokuwiki **

export SERVICE_IP=$(kubectl get svc --namespace dokuwiki dokuwiki --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")

echo "URL: http://$SERVICE_IP/"

2. Login with the following credentials

  echo Username: user
  echo Password: $(kubectl get secret --namespace dokuwiki dokuwiki -o jsonpath="{.data.dokuwiki-password}" | base64 -d)

```
View some of the objects created by the Helm install.
```
kubectl get pods -n dokuwiki

NAME                       READY   STATUS    RESTARTS   AGE
dokuwiki-6cffc49b9-mvkbp   0/1     Running   0          48s

kubectl get deployments -n dokuwiki

NAME       READY   UP-TO-DATE   AVAILABLE   AGE
dokuwiki   1/1     1            1           74s

kubectl get svc -n dokuwiki

NAME       TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)                      AGE
dokuwiki   LoadBalancer   10.97.69.52   <pending>     80:30782/TCP,443:30498/TCP   97s

```
Uninstall the release and delete the Namespace to clean up.
```
helm uninstall -n dokuwiki dokuwiki

release "dokuwiki" uninstalled

kubectl delete namespace dokuwiki

namespace "dw" deleted
```
Exam tips

- Helm charts are packages that contain all of the resource definitions needed to get an application up and running in the cluster,
- a Helm repository is a collection of charts and a source for browsing and downloading Helm charts.

More links:

https://medium.com/@nairgirish100/google-cloud-setup-selenium-grid-in-kubernetes-cluster-using-helm-chart-de7ccd133721

https://artifacthub.io/packages/helm/blackfire/selenium

https://github.com/SeleniumHQ/docker-selenium/blob/trunk/charts/selenium-grid/README.md


### 3.8 Lab: Deploying Packaged Kubernetes Apps with Helm

[Lesson Reference]()

Welcome to HiveCorp, a software design company that is totally not run by bees!

We are planning on developing some Kubernetes applications that could benefit from the `cert-manager` tool.  We want to install tool in the cluster. Luckily, there is a Helm chart we can use to make easier.

First, install Helm in the cluster.

Then, install `cert-manager` using the `bitnami/cert-manager` chart located in the bitnami chart repository.

Helm is a powerful tool that can allow you to more easily manage applications in Kubernetes. lab will give you a chance to get hands-on with Helm by installing Helm and deploying a Helm chart.

Learning Objectives

- Install Helm
  - Install Helm on the k8s Server.

- Install a Helm Chart in the Cluster
  - Install cert-manager using a Helm chart.
  - This chart can be found in the bitnami repository, located at https://charts.bitnami.com/bitnami.
  - You will need to add this repository, and then install the chart bitnami/cert-manager in the cluster. Install it in the existing cert-manager Namespace, and give it the name cert-manager.

Solution

Log in to the server using the credentials provided:
```
ssh cloud_user@<PUBLIC_IP_ADDRESS>
```
#### Install Helm

From Apt (Debian/Ubuntu)

Members of the Helm community have contributed a Helm package for Apt. This package is generally up to date.

```
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

sudo apt-get update
sudo apt-get install helm
```


Download the GPG key for the Helm package repository and add it to the apt package repository (requires password):
```
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
```
Set up the Helm package repository:
```
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
```
Update your local apt package listings:
```
sudo apt-get update

sudo apt-get install -y helm
```
Verify the installation:
```
helm version

version.BuildInfo{Version:"v3.10.3", GitCommit:"835b7334cfe2e5e27870ab3ed4135f136eecc704", GitTreeState:"clean", GoVersion:"go1.18.9"}
```
#### Install a Helm Chart in the Cluster

Add the bitnami chart repository:
```
helm repo add bitnami https://charts.bitnami.com/bitnami

"bitnami" has been added to your repositories
```
Update the chart listing:
```
helm repo update

Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "bitnami" chart repository
Update Complete. ⎈Happy Helming!⎈
```
Install the chart in the cert-manager Namespace:
```
helm search repo bitnami | grep cert

helm install -n cert-manager cert-manager bitnami/cert-manager

NAME: cert-manager
LAST DEPLOYED: Sat Dec 24 20:46:42 2022
NAMESPACE: cert-manager
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: cert-manager
CHART VERSION: 0.8.10
APP VERSION: 1.10.1

** Please be patient while the chart is being deployed **

In other to begin using certificates, you will need to set up Issuer or ClustersIssuer resources.

https://cert-manager.io/docs/configuration/

To configure a new ingress to automatically provision certificates, you will find some information in the following link:

https://cert-manager.io/docs/usage/ingress/
```
View the Pods created by the Helm installation:
```
kubectl get pods -n cert-manager

NAME                                       READY   STATUS    RESTARTS   AGE
cert-manager-cainjector-8459cf8cfc-8r97d   1/1     Running   0          5m46s
cert-manager-controller-5898f67cd-7pjtt    1/1     Running   0          5m46s
cert-manager-webhook-6c5894db65-rjb5s      1/1     Running   0          5m46s
```
View the Deployments created by the Helm installation:
```
kubectl get deployments -n cert-manager

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
cert-manager-cainjector   1/1     1            1           7m42s
cert-manager-controller   1/1     1            1           7m42s
cert-manager-webhook      1/1     1            1           7m42s
```
View the Services created by the Helm installation:
```
kubectl get svc -n cert-manager

NAME                              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
cert-manager-controller-metrics   ClusterIP   10.111.74.54     <none>        9402/TCP   8m18s
cert-manager-webhook              ClusterIP   10.102.169.173   <none>        443/TCP    8m18s
```
Done


### 3.9 Quiz: Application Deployment

[Lesson Reference]()

Which command can you use to roll a Deployment back to the previous version of the code?

kubectl rollout undo


### 3.10 Application Deployment Summary

[Lesson Reference]()

Kubernetes Deployments can be used to manage multiple replica Pods.

Rolling updates is the process of using Deployments to roll out new code with zero downtime.

A Deployment actively manages a desired state for a set of replica Pods.

The Pod template in a Deployment provides the Pod configuration that the Deployment will use to create new Pods and the replicas field sets the number of replicas.

You can scale up or scale down with Deployments by changing replica's value.

A rolling update gradually rolls out changes to a Deployment's Pod template by gradually replacing replicas with new ones.

Use the `kubectl rollout status` command to check the status of a rolling update and roll back the latest rolling update with `kubectl rollout undo`.

In a blue/green deployment strategy you use multiple Deployments to set up blue/green environments in Kubernetes, use labels and selectors on services to direct user traffic to different Pods.

A canary deployment can be obtain by using a service that selects Pods simultaneously from 2 different Deployments.  You can vary the number of replicas in those Deployments to direct fewer users to the canary environment.

Helm is a package management tool for Kubernetes applications.

Helm charts are packages that contain all of the resource definitions needed to get an application up and running in a cluster.

A Helm repository is a collection of charts and a source for browsing and downloading them.


## CHAPTER 4 Application Observability and Maintenance

### 4.1 Application Observability and Maintenance Intro

### 4.2 Understanding the API Deprecation Policy

[Lesson Reference](PDF/S04L02_Understanding_the_API_Deprecation_Policy.pdf)

[Kubernetes Deprecation Policy](https://kubernetes.io/docs/reference/using-api/deprecation-policy/)

[Deprecated API Migration Guide](https://kubernetes.io/docs/reference/using-api/deprecation-guide/)

The Kubernetes API is the primary interface for Kubernetes.

When you run a command like `kubectl get pods` you are communicating with the API which is part of the control plane.

The kubectl tool allows us to communicate with the Kubernetes API.

Deprecation is the process of providing advanced warning of changes to an API so API consumers have a chance to update their code and or processes.

You can check out the full Kubernetes API Deprecation Policy,

The apiVersion field on a Kubernetes object indicates which version of the API the object is compatible with.

The deprecation window is different for features that are in alpha, beta, or GA, or general availability.  GA features are features considered to be fully tested and fully released.

GA features have the longest deprecation window, 12 months or three releases.  Three releases means Kubernetes versions.  For example, Kubernetes 1.19, 1.20, 1.21, each of those is a release.

If a portion of the API is deprecated, you have at least 12 months to prepare for that change, and potentially even longer if the next three Kubernetes releases take longer than 12 months to come out.

The K8s documentation has a Migration Guide that gives you detailed information about API changes.

The deprecated API Migration Guide tells where to find information about the actual upcoming changes to the Kubernetes API.  For each Kubernetes version you can see an overview of the changes that are being made and get that advanced warning of those changes before you upgrade your Kubernetes cluster.

Exam Tips

- API Deprecation is the process of announcing changes to an API early, giving users time to update their code and/or tools.
- Kubernetes removes support for deprecated APIs that are in GA (General Availability) only after 12 months or 3 Kubernetes releases, whichever is longer.


### 4.3 Implementing Probes and Health Checks

[Lesson Reference](PDF/S04L03_Implementing_Probes_and_Health_Checks.pdf)

[Configure Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)

Probes are part of the container spec in Kubernetes.

Probes allow you to customize how Kubernetes detects the state of a container.

Probes provide for different kinds of health checks for the containers.

There are 3 different types of probes.

- liveness probes
  - is the container is healthy or should it be restarted?

- readiness probes.
  - is a container fully started and ready to receive user traffic?

- startup probes.
  - for slow starting containers that take a long time to get up and running.
  - act like a liveness probe that is only active during that slow startup time.
  - purpose is to prevent the container from being considered unhealthy during that long startup time that might be taking place.


Create a Pod with a liveness probe that checks container health by verifying that the command line responds.
```
vi liveness-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: liveness-pod
spec:
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'while true; do sleep 10; done']
    livenessProbe:
      exec:
        command: ['echo', 'health check!']
      initialDelaySeconds: 5
      periodSeconds: 5

kubectl apply -f liveness-pod.yml

pod/liveness-pod created
```

This Pod goes to sleep on a loop so the container is will continue running.

We implement a liveness probe that periodically checks the health of the container.

There are multiple different ways to implement the health check.

We have the probe run a command (any command) inside the container to make sure that the container is able to respond to that command.

To run a command put exec under the liveness probe and then provide a command.
The command is the 'main' ?? container command.

We specify a command that will be executed as part of the health check to verify that the container can respond to a basic command.

We specify initialDelaySeconds: wait 5 seconds after the container starts up before it begins to run the liveness probe health check.

We specify periodSeconds: how often the liveness probe is going to be executed.

Our spec says wait 5 seconds after the container starts up to start running the liveness probe then run the liveness probe command every 5 seconds to check whether the container is healthy.

save and exit that file.
then we'll create the pod with kubectl apply.
check the status of the pod.
kubectl get pod liveness-pod,
 if that health check was failing we would see that restart number go up
because it would detect that something's wrong with the container, and it would restart it.

But the number of restarts is zero because everything is working correctly at point.

I can also see some information about the liveness probes with kubectl describe.

 I'll do kubectl describe on that pod.

if I look at the container information here,
I can see the liveness probe information, and it  gives me a bunch of information
about the liveness probes.

 if you have an existing pod in a cluster, and you want to see what kind of liveness probes
are attached to it, you can use kubectl describe to get that information.

readiness probe.

readiness-pod.yml.

you might remember a readiness probe   detects whether the container is  fully started up and ready to receive requests from users.

 I'm  going to create a simple nginx pod here running the nginx web server,
add a readinessProbe section to the container.

another way to check the health of a container is to use httpGet.

this will make an HTTP request to the container.
 there's the path I'm going to make the request to.
I'll  use the root path
which is  slash and I'll make a request on port 80.
 readiness probe is
 going to make an HTTP request,
and if it gets a successful response from that nginx web server,
then it'll be considered ready.

 like with a liveness probe,
I can set the initialDelaySeconds and periodSeconds.
Now I'm going to set the initial delay to 15
 so that we have a little bit of extra time
to  see what pod looks like as it goes through process of starting up with a readiness probe.

If I set that to a short amount of time, it would complete before I have a chance to look at it.

Now I can also combine liveness probes and readiness probes so I'm going to add a liveness probe as well.

 a simple liveness probe almost identical to the readiness probe
because it's also going to use an httpGet to port 80
on that root path and have a little bit
of a shorter initial delay and time period there.
 it's going to wait 3 seconds
for the initial delay and run every 3 seconds.

You can combine multiple different kinds of probes within the same container.

create pod

then I'll  quickly do a kubectl get on the readiness pod,
and I can see the pod is in the running status but ready says zero out of 1.

 you might've seen ready column before when we were looking at pod information, but maybe now you have a little bit more of an understanding of what it  means.

the container is up and running, but it's not considered ready because the readiness probe has not completed yet.

After 15 seconds has probably passed I'm going to run that again,
and I can see the readiness probe has now completed successfully
and therefore 1 out of 1 containers are in the ready state.
Now I'm  going to look again at the readiness-pod.yml here.
 I have a liveness probe and a readiness probe.
We're not going to focus on startup probes here.
For the purposes of course, we're   going to focus mainly
on liveness and readiness probes.

Now you can also do a TCP socket health check in addition to the httpGet and  running a command.

Exam Tips

- Liveness probes check if a container is healthy so that it can be restarted if it is not.
- Readiness probes check whether a container is fully started up and ready to be used.
- Probes can run a command inside the container, make an HTTP request, or attempt a TCP socket connection to determine container status.


Lesson Reference

Log in to the control plane node.

Create a Pod with a liveness probe that checks container health by verifying that the command line responds.
```
vi liveness-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: liveness-pod
spec:
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'while true; do sleep 10; done']
    livenessProbe:
      exec:
        command: ['echo', 'health check!']
      initialDelaySeconds: 5
      periodSeconds: 5

kubectl apply -f liveness-pod.yml

pod/liveness-pod created
```
Check the status of the Pod.
```
kubectl get pod liveness-pod

NAME           READY   STATUS    RESTARTS   AGE
liveness-pod   1/1     Running   0          32s
```
You can see information about a container's liveness probes with kubectl describe.
```
kubectl describe pod liveness-pod

Name:         liveness-pod
Namespace:    default
Priority:     0
Node:         worker1/172.31.126.155
Start Time:   Sat, 24 Dec 2022 22:02:07 +0000
Labels:       <none>
Annotations:  cni.projectcalico.org/containerID: ce7c52c003de4c7e199502e62e77d3b3f2d45742c3f344446ad2c23bfcd42cb3
              cni.projectcalico.org/podIP: 192.168.235.183/32
              cni.projectcalico.org/podIPs: 192.168.235.183/32
Status:       Running
IP:           192.168.235.183
IPs:
  IP:  192.168.235.183
Containers:
  busybox:
    Container ID:  containerd://05c6cfc819ee170ddeed88931d9c6f9089132f46b9559327702e720257e92dde
    Image:         busybox:stable
    Image ID:      docker.io/library/busybox@sha256:3b3128d9df6bbbcc92e2358e596c9fbd722a437a62bafbc51607970e9e3b8869
    Port:          <none>
    Host Port:     <none>
    Command:
      sh
      -c
      while true; do sleep 10; done
    State:          Running
      Started:      Sat, 24 Dec 2022 22:02:08 +0000
    Ready:          True
    Restart Count:  0
    Liveness:       exec [echo health check!] delay=5s timeout=1s period=5s #success=1 #failure=3
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-2bnpg (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kube-api-access-2bnpg:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  88s   default-scheduler  Successfully assigned default/liveness-pod to worker1
  Normal  Pulled     87s   kubelet            Container image "busybox:stable" already present on machine
  Normal  Created    86s   kubelet            Created container busybox
  Normal  Started    86s   kubelet            Started container busybox
```
Create a Pod with a liveness probe and a readiness probe, both of which use an http check.
```
vi readiness-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: readiness-pod
spec:
  containers:
  - name: nginx
    image: nginx:1.20.1
    ports:
    - containerPort: 80
    livenessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 3
      periodSeconds: 3
    readinessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 15
      periodSeconds: 5

kubectl apply -f readiness-pod.yml

pod/readiness-pod created
```

Check the status of the Pod.  Initially, the status will be Running but the container will not be ready. Wait a bit and check the Pod status again. Once the readiness probe runs successfully, the container should become ready.
```
kubectl get pod readiness-pod

NAME            READY   STATUS    RESTARTS   AGE
readiness-pod   0/1     Running   0          3s
cloud_user@control:~$ k get pod readiness-pod

NAME            READY   STATUS    RESTARTS   AGE
readiness-pod   1/1     Running   0          78s

```
From: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/
```
vim liveness-exec.yml

apiVersion: v1
kind: Pod
metadata:
  labels:
    test: liveness
  name: liveness-exec
spec:
  containers:
  - name: liveness
    image: registry.k8s.io/busybox
    args:
    - /bin/sh
    - -c
    - touch /tmp/healthy; sleep 30; rm -f /tmp/healthy; sleep 600
    livenessProbe:
      exec:
        command:
        - cat
        - /tmp/healthy
      initialDelaySeconds: 5
      periodSeconds: 5

k apply -f liveness-exec

pod/liveness-exec created

kubectl describe pod liveness-exec

Events:
  Type     Reason     Age                  From               Message
  ----     ------     ----                 ----               -------
  Normal   Scheduled  3m34s                default-scheduler  Successfully assigned default/liveness-exec to worker1
  Normal   Pulled     3m32s                kubelet            Successfully pulled image "registry.k8s.io/busybox" in 900.966255ms
  Normal   Pulled     2m18s                kubelet            Successfully pulled image "registry.k8s.io/busybox" in 469.352094ms
  Normal   Created    63s (x3 over 3m32s)  kubelet            Created container liveness
  Normal   Started    63s (x3 over 3m31s)  kubelet            Started container liveness
  Normal   Pulling    63s (x3 over 3m33s)  kubelet            Pulling image "registry.k8s.io/busybox"
  Normal   Pulled     63s                  kubelet            Successfully pulled image "registry.k8s.io/busybox" in 432.119211ms
  Warning  Unhealthy  18s (x9 over 2m58s)  kubelet            Liveness probe failed: cat: can't open '/tmp/healthy': No such file or directory
  Normal   Killing    18s (x3 over 2m48s)  kubelet            Container liveness failed liveness probe, will be restarted

```


### 4.4 Lab: Implementing Health Checks in a Kubernetes Application

[Lesson Reference]()

Additional Resources

Welcome to HiveCorp, a software design company that is totally not run by bees!

We have recently deployed a new set of tools to the Kubernetes cluster, but there are some problems that need to be resolved.

One component called comb-dashboard is an application that serves HTTP requests. A bug in the code is causing it to randomly begin responding with error status codes, but the container process continues to run. Currently, the only way to fix the issue when it arises is to restart the application. Implement a probe that will cause the container to be automatically restarted when it begins responding with errors.

Another component, comb-monitor, is entering the ready status too early, before it has a chance to fully start up. Create a probe that will detect when the container is fully started up by running a test command.

Learning Objectives
- Add a Liveness Probe
- Add a Readiness Probe

Kubernetes health checks provide a deeper level of control over how Kubernetes detects the state of your application containers. In lab, you will work closely with health checks using Kubernetes probes to fine-tune how Kubernetes manages containers.

Solution

Log in to the server using the credentials provided:

ssh cloud_user@<PUBLIC_IP_ADDRESS>

#### Add a Liveness Probe

Edit the Deployment:
```
kubectl edit deployment comb-dashboard -n hive

```
Implement the liveness probe. Scroll down to your container, and add the following to the container spec (starting under terminationMessagePolicy):

Note: When copying and pasting code into Vim from the lab guide, first enter :set paste (and then i to enter insert mode) to avoid adding unnecessary spaces and hashes. To save and quit the file, press Escape followed by :wq. To exit the file without saving, press Escape followed by :q!.

```
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 3
          periodSeconds: 3
```
Type ESC followed by :wq to save your changes.

Check the comb-dashboard Pod status. The Pod should be restarted automatically whenever errors arise:
```
kubectl get pods -n hive
```

If you wait a few moments and check the status again, you should see the restart count increase.

#### Add a Readiness Probe

Edit the Deployment:
```
kubectl edit deployment comb-monitor -n hive
```
Implement the readiness probe. Scroll down to your container, and add the following to the container spec (starting under terminationMessagePolicy):
```
        readinessProbe:
          exec:
            command: ['echo', 'This is a test!']
          initialDelaySeconds: 3
          periodSeconds: 3
```
Type ESC followed by :wq to save your changes.

Check the comb-monitor Pod status. The Pod should start up successfully and the container should become ready:

kubectl get pods -n hive

Conclusion

Congratulations – you've completed hands-on lab!

### 4.5 Monitoring Kubernetes Applications

[Lesson Reference](PDF/S04L04 Monitoring Kubernetes Applications.pdf)

Documentation

[Resource metrics pipeline](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/)

[Tools for Monitoring Resources](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-usage-monitoring/)

[metrics-server GitHub reference](https://github.com/kubernetes-sigs/metrics-server)

[Metrics Server installation yaml](https://raw.githubusercontent.com/ACloudGuru-Resources/content-cka-resources/master/metrics-server-components.yaml)

Exam Tips

- The Kubernetes metrics API provides metric data about container performance.
- You can view Pod metrics using kubectl top pod .

Lesson Reference

Log in to the control plane node.

Install metrics-server.  command uses a yaml file with a small tweak to make it easier to get metrics-server running in the environment.
```
kubectl apply -f https://raw.githubusercontent.com/ACloudGuru-Resources/content-cka-resources/master/metrics-server-components.yaml

serviceaccount/metrics-server created
clusterrole.rbac.authorization.k8s.io/system:aggregated-metrics-reader created
clusterrole.rbac.authorization.k8s.io/system:metrics-server created
rolebinding.rbac.authorization.k8s.io/metrics-server-auth-reader created
clusterrolebinding.rbac.authorization.k8s.io/metrics-server:system:auth-delegator created
clusterrolebinding.rbac.authorization.k8s.io/system:metrics-server created
service/metrics-server created
deployment.apps/metrics-server created
apiservice.apiregistration.k8s.io/v1beta1.metrics.k8s.io created
```

Note: It may take a few minutes for metrics-server to gather initial metrics and become available.

Create a Pod that uses a detectable amount of CPU.

the setup uses a resource-consumer image that is designed to consume an approximate amount of CPU for testing purposes. Since it receives instructions via HTTP request, a sidecar container makes a request to the main container instructing it on how much CPU to consume.
```
vi resource-consumer-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: resource-consumer-pod
spec:
  containers:
  - name: resource-consumer
    image: gcr.io/kubernetes-e2e-test-images/resource-consumer:1.5
  - name: busybox-sidecar
    image: radial/busyboxplus:curl
    command: ['sh', '-c', 'until curl localhost:8080/ConsumeCPU -d "millicores=100&durationSec=3600"; do sleep 5; done && while true; do sleep 10; done']

kubectl apply -f resource-consumer-pod.yml
```
Use kubectl top to view metrics for Pods.
```
kubectl top pod

kubectl top pod -n default

NAME                    CPU(cores)   MEMORY(bytes)
resource-consumer-pod   101m         7Mi
cloud_user@control:~$ k top node

```
View metrics by node.
```
kubectl top node

NAME      CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
control   210m         10%    1915Mi          50%
worker1   78m          3%     1180Mi          31%
worker2   174m         8%     1197Mi          31%
```

Monitoring is the process of gathering data about the performance of your containerized applications in real time.

Steps to access monitoring data with the Kubernetes Metrics API.

Install Metrics Server, a component that gathers metric data so that we can access it.  Without Metrics Server the Kubernetes Metrics API won't provide any data.

Once we've installed Metric Server we can access metric data using the `kubectl top` command.

There are more advanced ways to monitor Kubernetes, including external tools. We will focus on basic tools, Metric Server and the kubectl top command,

Log into the Kubernetes Control Plane Server and install Metrics Server.

Metrics Server does provide their own yaml file but I have created a slightly tweaked version
of that yaml file, that will  make it easier for us to get Metrics Server up and running
in the cluster that we have set up.

Installing Metrics Server is not on the curriculum for Certified Kubernetes Application Developer.

We  need to get it installed so that we can experiment with the process of browsing and accessing that metric data which is something that's part of that curriculum.

We're  going to use to quickly get Metrics Server up and running.

 I'll  use kubectl apply to install all of those Metrics Server components.

to gather some metrics we need a pod to  gather metrics about.

 I'm going to  create a pod and I'm going to call it "resource-consumer-pod"
because is going to be a pod that consumes some CPU resources, so that we can detect that when we go to gather the metric data.

 here's the resource-consumer-pod and I'm  using a special container image created by Google as part of the Kubernetes end-to-end tests.
This is a container image designed to consume a configurable amount of resources.

The way we control Resource Consumer is by sending HTTP requests.

I'm using a busybox-sidecar container to communicate with main container using curl.

 I'm   making a curl request instructing main container on what to do and it's going to end up consuming approximately 100 millicores of CPU and we should see that reflected when we use kubectl top here in a moment.

save and exit the file and create the resource-consumer-pod.

run `kubectl top pod` for information about the resource usage of the pods.

You may notice the resource-consumer-pod is not in the list.
There's  some pods that I created earlier in a previous lesson here.
 one thing that's important to know, about Metrics Server is
it does take a few moments to gather metrics on new pods after they're created.
 we  created the Resource Consumer, and it's not going to show up in list for  a few moments.
 I'm  going to wait a little bit,
and then I'll rerun kubectl top pod and the resource consumer now appears.
it is using 100 millicores.
Sometimes it might be 101 or  some other number that's close to  100.
It's only an approximation,
but it happens to be at exactly 100 millicores when I ran kubectl top pod.
Now we are looking in the default Namespace because we didn't specify a Namespace.
But you can specify a Namespace with kubectl top,
and we do that with -n
 like we do with other kubectl commands.
 I could do kubectl top pod, -n default,

`kubectl top node` returns metric data organized according to each Kubernetes node in the cluster

the Kubernetes Metrics API provides metric data about container performance.
you can view pod metrics using the `kubectl top pod` command.

### 4.6 Accessing Container Logs

[Lesson Reference]()

[Logging Architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/)

In lesson, we're going to be talking about
accessing container logs.
 here's  a quick overview of what we'll be discussing.
First, we're going to talk about container logging
at a high level.
Then, we'll do a quick hands-on demonstration
of how to access container logs in your cluster,
and then we'll provide a few quick exam tips.
So, what are we talking about
when we talk about container logging?
Well, Kubernetes stores the stdout and stderr
console output for each container
in something called the container log.
So, I've got the container there
and any output from that container
will be stored in that container log.
I can then view that log with the kubectl logs command.
So, that's a great tool for diagnosing issues
or  gathering information about what's going on
inside your containers.
 let's dive into the cluster
and retrieve some log data from a container.
In order to retrieve log data, I need a container
that's  creating some output,
so I'll  create pod
called logging-pod.
I'll create the yaml file logging-pod.yml.
this is going to be a basic busybox pod,
I don't really need to do anything special
in order to capture the log output.
Anything written to the console by the container process
will appear in the log, so I'm  running a loop here
and every 5 seconds, I'm  going to echo
"Writing to the log!"
 we should  see line "Writing to the log!"
appearing over and over in the container log.
 I'll save and exit that file,
and we'll create the pod with kubectl apply-f
and accessing those logs is pretty easy,
I can  use the kubectl logs command.
I'll  put the name of the pod there, logging-pod.
Of course you can specify your Namespace if you need to
with -n but the pod's in the default Namespace,
so I don't need to do that.
I'll  do kubectl logs on that logging pod,
and I have the contents of that log here.
Now with multi-container pods,
you might need to specify which container within the pod
you want to get your logs for.
you can do that with -c flag.
 I'm  going to get the logs from logging pod again.
Now isn't required for particular pod
because there's only one container
so if you don't specify -c, and there's only one container,
it will  assume that single container,
but if there's multiple containers,
it'll give you an error message
because it won't know which container you want,
unless you specify -c flag.
the container is called busybox
so I'll  enter the container name there
and of course I get similar output,
it's had time to write that line more times to the log now
so it's a little bit longer,
but it's the output from that same container's log
that we saw before.
 that was  a quick look at using
the kubectl logs command to access container logs
in the cluster.
Before we end the video,
let's go over a few quick exam tips.
First, the standard and error output for containers
is stored automatically in the container log.
Second, you can view the container log
using the kubectl logs command.
for multi-container pods use the -c flag
to specify which container's logs you want to view.
 that was  a quick overview
of accessing container logs in Kubernetes.
That's all for lesson.
I'll see you in the next one.


Lesson Reference

Log in to the control plane node.

Create a Pod that generates some log output.
```
vi logging-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: logging-pod
spec:
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'while true; do echo "Writing to the log!"; sleep 5; done']


kubectl apply -f logging-pod.yml

```
Check the Pod's logs.
```
kubectl logs logging-pod
```
Specify the container to view logs for.
```
kubectl logs logging-pod -c busybox
```

Exam Tips
- Standard/Error output for containers is stored in the container log.
- You can view the container log using kubectl logs.
- For multi-container pods, use the -c flag to specify which container's logs you want to view.


### 4.7 Debugging in Kubernetes

[Lesson Reference](PDF/S04L06_Debugging_in_Kubernetes.pdf)

Documentation

[Troubleshoot Applications, debug pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-pods/)

[Application Introspection and Debugging, debug running pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/)

[Monitoring, Logging, and Debugging](https://kubernetes.io/docs/tasks/debug/)


Check object status
- locate the problem.
- identifying which components may not be working.

Check object configuration
- Once you've located that problem gather additional information about those broken components
- make changes to fix the issue.

Check object status.

Is a Pod broken?
- `k get pods`; are all the Pods running; is there an error message?

Check object configuration.
- kubectl describe
  - view the full object manifest to understand the relevant objects in more detail

Check logs
- check container logs and even cluster level logs for more insight into what is going on.

Log into the control plane node.

We will create a broken Pod to debug.
```
vi broken-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: broken-pod
spec:
  containers:
  - name: nginx
    image: nginx:1.20.q
    livenessProbe:
      httpGet:
        path: /
        port: 81
      initialDelaySeconds: 3
      periodSeconds: 3

kubectl apply -f broken-pod.yml
```
Instead of fixing the above yaml file, we will proceed through a debugging process to locate
the problems with pod.

kubectl get pods.

I can see it's pretty obvious that there's a problem with the broken pod here, from list. if you're having a problem with a pod or perhaps you don't even know which pod is broken, an easy thing to check is Status column, perhaps even Ready column, to get an idea of what's going on with the pods in your cluster.


k get pods

NAME         READY   STATUS         RESTARTS   AGE
broken-pod   0/1     ErrImagePull   0          5s

The pod status above indicates the problem.

The problem might not be in the default Namespace; check other namespaces with -n.

kubectl get pods --all-namespaces

New in kubectl v1.14, you can use -A instead of --all-namespaces, eg:

kubectl get -A pod

`--all-namespaces` or `-A` gets all the pods from all namespaces in the cluster, to give you an overview of the entire cluster.

`kubectl describe` returns a lot of information about Kubernetes objects,
for a closer look at the pod.

The image name is misspelled.  There's no such thing as nginx:1.20.q,

the state is ImagePullBackOff.
That's because we cannot download that image.

You might not have access to the yaml files that someone else used to create existing objects in a cluster.

But you can use kubectl describe to identify what's wrong.

Edit broken-pod.yml to fix the image version by changing it to 1.20.1
Save and exit the file.

When you make certain changes to existing pods you might have to delete the existing pod and recreate the pod.  You might not have time to wait for a graceful shutdown so use the --force flag.

kubectl delete pod broken-pod --force

kubectl apply -f broken-pod.yml

k get pod broken-pod

NAME         READY   STATUS    RESTARTS     AGE
broken-pod   1/1     Running   2 (5s ago)   24s

The pod has restarted two times.

Look at the pod logs.

kubectl logs broken-pod

Now sometimes you can locate a problem
by looking at a pod's logs, but in case,
it's not really giving us any relevant information
that's helping us locate the issue,
but that is often an important troubleshooting step
is  to check those pod logs.
Another important troubleshooting step to be aware of
is to get an object in the form of yaml.
 I'll do kubectl get pod broken-pod -o yaml,
and that will give me the full
yaml configuration of that pod,
and I can use that to
look at how Kubernetes object is configured.
if I look at the container spec here,
I can see that I have a livenessProbe
that is  pointing to port 81.
this is  a basic nginx web server,
which by default, listens on port 80.
 it's not going to listen on port 81,
and that's probably why the pod is continually restarting
because livenessProbe is failing
due to the fact that it's pointing to the wrong port.
 let's fix that.
I'll edit the broken-pod.yml,
come down here to the livenessProbe port
and  change that to port 80.
Then I'll save that file.
 like we did before,
I'll delete the pod and then recreate it.
if I do kubectl get pod on broken-pod here,
I can see the pod is up and running.
even if I wait a little while and rerun that command,
it's not going to continually restart,
so that number of restarts is still at zero.
Now, there are two final things
that I want to show you here before ending demo.
the first one is how to check
the kube-apiserver logs.
 normally as an application developer,
this isn't something you would often need to do,
but if you're really in dire straits
and you can't find any relevant information anywhere else,
this might be something in the real world
that you might need to look into.
 I'm  going to run as root.

sudo cat /var/log/containers/

to find the container logs for all the containers in directory and kube-apiserver runs as a container, so it can find the kube-apiserver logs here as well.

If I use auto-complete I can see there are a couple different log files here.

You might need to check the dates on those files to find which one is the most current, but I'm  going to look at one of those log files. there's quite a bit of log output here.  None of it is really relevant for us to look closely at right now,

how to access the logs for Kubelet.  Kubelet runs as a service so we can find those logs  using journalctl.

sudo journalctl -u kubelet

nothing really relevant to us right now here, but if you ever need to look
at the logs for your Kubelet
that's how you can do it  using journalctl.
 that was  a quick look
at some troubleshooting steps in the cluster.

Exam tips

use the kubectl get pods command to check the status of all pods in a Namespace.

use the all-namespaces flag if you don't know what Namespace to look in, and you want to look across all namespaces.

use kubectl describe to get detailed information about Kubernetes objects,

use kubectl logs to retrieve container logs,

if all else fails, you can check cluster level logs if you still cannot locate any relevant information.




Debugging in Kubernetes

Exam Tips

- Use kubectl get pods to check the status of all Pods in a Namespace. Use the --all-namespaces flag if you don't know what Namespace to look in.
- Use kubectl describe to get detailed information about Kubernetes objects.
- Use kubectl logs to retrieve container logs.
- Check cluster-level logs if you still cannot locate any relevant information.

Lesson Reference

Log in to the control plane node.

Create a broken Pod.
```
vi broken-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: broken-pod
spec:
  containers:
  - name: nginx
    image: nginx:1.20.q
    livenessProbe:
      httpGet:
        path: /
        port: 81
      initialDelaySeconds: 3
      periodSeconds: 3

kubectl apply -f broken-pod.yml
```

Get a list of Pods in the default Namespace.

```
kubectl get pods
kubectl get pods -n default

```
Get a list of Pods in all Namespaces.

```
kubectl get pods --all-namespaces
```

Get more details about the Pod.
```
kubectl describe pod broken-pod
```
Edit the yaml to fix the Pod's image version.
```
vi broken-pod.yml

image: nginx:1.20.1
```
Delete and re-create the Pod.
```
kubectl delete pod broken-pod --force

kubectl apply -f broken-pod.yml
```
Check the Pod status again. You should notice that it begins restarting repeatedly. is because the liveness probe is not configured correctly.

```
kubectl get pod broken-pod
```

Check the Pod's container logs.
```
kubectl logs broken-pod
```
Check the Pod's YAML manifest.
```
kubectl get pod broken-pod -o yaml
```
Edit the yaml to fix the liveness probe.
```
vi broken-pod.yml

livenessProbe:
  httpGet:
    path: /
    port: 80
```
Delete and re-create the Pod.
```
kubectl delete pod broken-pod --force

kubectl apply -f broken-pod.yml
```

Check the Pod status again.
```
kubectl get pod broken-pod
```
The Pod should now be working correctly.

Check the kube-apiserver logs. Note that the log file name contains a random hash. You will need to browse the file system within /var/log/containers/ to find the file.
sudo cat /var/log/containers/kube-apiserver-k8s-control_kube-system_kube-apiserver-<hash>.log

Check the kubelet logs.

sudo journalctl -u kubelet

### 4.8 Lab: Debugging a Kubernetes Application

Welcome to HiveCorp, a software design company that is totally not run by bees!

We are working on building some applications in the Kubernetes cluster, but there are some issues. We need you identify what is wrong and fix these problems!

First, some Deployment's Pods are unable to start up (they won't even enter the Running status). Unfortunately, whoever reported issue didn't provide much information, so you will need to locate issue and fix it.

Second, a Deployment called users-rest has Pods that are running, but they are not receiving any user traffic. Investigate why is happening and correct the issue.

Debugging is an essential skill for a Kubernetes application developer. lab will present you with some debugging challenges. You will get a chance to practice your troubleshooting skills as you identify and solve problems with a Kubernetes app.

Given a lab server with a running K8s cluster:

- Identify and fix a Broken Deployment
- Fix an Application That Is Not Receiving User Traffic.  Why is the application not able to receive user traffic?

Solution

Log in to the lab server using the credentials provided:

ssh cloud_user@<PUBLIC_IP_ADDRESS>

#### Fix a Broken Deployment

Check the status of all Pods in the cluster:
```
kubectl get pods --all-namespaces

k get pods --all-namespaces
NAMESPACE     NAME                                       READY   STATUS             RESTARTS   AGE
comb          auth-frontend-845d7bd785-74fnf             0/1     ImagePullBackOff   0          9m22s
comb          auth-frontend-845d7bd785-dpnrj             0/1     ImagePullBackOff   0          9m22s
hive          users-rest-c85cc7777-57hqs                 0/1     Running            0          9m22s
hive          users-rest-c85cc7777-ngqcw                 0/1     Running            0          9m22s
hive          web-frontend-7b46597bcf-44jlx              1/1     Running            0          9m23s
hive          web-frontend-7b46597bcf-nlv29              1/1     Running            0          9m23s

k get deployments auth-frontend -n comb

NAME            READY   UP-TO-DATE   AVAILABLE   AGE
auth-frontend   0/2     2            0           10m
```
You should see that the Pods from the auth-frontend Deployment in the comb Namespace do not have a STATUS of Running. is the Deployment that needs to be fixed.

Gather some details about the Deployment:
```
kubectl describe deployment auth-frontend -n comb

Name:                   auth-frontend
Namespace:              comb
CreationTimestamp:      Tue, 27 Dec 2022 14:14:58 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=auth-frontend
Replicas:               2 desired | 2 updated | 2 total | 0 available | 2 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=auth-frontend
  Containers:
   nginx:
    Image:        nginx:1.20.1z
    Port:         <none>
    Host Port:    <none>
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      False   MinimumReplicasUnavailable
  Progressing    False   ProgressDeadlineExceeded
OldReplicaSets:  <none>
NewReplicaSet:   auth-frontend-845d7bd785 (2/2 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  12m   deployment-controller  Scaled up replica set auth-frontend-845d7bd785 to 2

```
Note that there seems to be a mistake in the image tag. There is a z on the end of the version number. is the issue that needs to be corrected.

Edit the Deployment:
```
kubectl edit deployment auth-frontend -n comb
```
Scroll down and fix the image tag by removing the z. It should now look like this:
```
    spec:
      containers:
      - image: nginx:1.20.1
```
Type ESC followed by :wq to save your changes.
```
deployment.apps/auth-frontend edited
```

Check the status of the Pods. They should be in the Running status:
```
kubectl get pods -n comb

NAME                             READY   STATUS    RESTARTS   AGE
auth-frontend-7d455cfdc9-8dt4q   1/1     Running   0          109s
auth-frontend-7d455cfdc9-jwxk9   1/1     Running   0          108s
```
#### Fix an Application That Is Not Receiving User Traffic

Check the status of the users-rest Deployment:
```
kubectl get deployment users-rest -n hive

NAME         READY   UP-TO-DATE   AVAILABLE   AGE
users-rest   0/2     2            0           19m

```
Note that none of the replicas are marked as READY.

Check the Pod status:
```
kubectl get pods -n hive

NAME                            READY   STATUS    RESTARTS   AGE
users-rest-c85cc7777-57hqs      0/1     Running   0          20m
users-rest-c85cc7777-ngqcw      0/1     Running   0          20m
web-frontend-7b46597bcf-44jlx   1/1     Running   0          20m
web-frontend-7b46597bcf-nlv29   1/1     Running   0          20m

```
The Pod status shows that the Pods are Running, but the containers are not ready (0/1).

Look at the Deployment details:
```
kubectl describe deployment users-rest -n hive

Name:                   users-rest
Namespace:              hive
CreationTimestamp:      Tue, 27 Dec 2022 14:14:58 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=users-rest
Replicas:               2 desired | 2 updated | 2 total | 0 available | 2 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=users-rest
  Containers:
   nginx:
    Image:        nginx:1.20.1
    Port:         80/TCP
    Host Port:    0/TCP
    Readiness:    http-get http://:8080/ delay=3s timeout=1s period=3s #success=1 #failure=3
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      False   MinimumReplicasUnavailable
  Progressing    False   ProgressDeadlineExceeded
OldReplicaSets:  <none>
NewReplicaSet:   users-rest-c85cc7777 (2/2 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  22m   deployment-controller  Scaled up replica set users-rest-c85cc7777 to 2
```
Note that the readiness probe seems to be using the wrong port. The container listens on port 80, but the readiness probe is checking port 8080. is the issue you need to fix.

Edit the Deployment:
```
kubectl edit deployment users-rest -n hive
```
Scroll down and change the port used by the readiness probe from 8080 to 80. It should now look like this:
```
        readinessProbe:
          failureThreshold: 3
          httpGet:
            path: /
            port: 80
```
Type ESC followed by :wq to save your changes.

Check the Deployment status again:
```
kubectl get deployment users-rest -n hive

NAME         READY   UP-TO-DATE   AVAILABLE   AGE
users-rest   2/2     2            2           24m
```
All of the replicas should become ready (note that it might take a few moments).


### 4.9 Quiz: Application Observability and Maintenance

Which Kubernetes API would you use to check how much memory a Pod is using?

- Pod API
- Apps API
- Metrics API
- Core API

When a GA (General Availability) Kubernetes API is deprecated, what is the minimum amount of time you would have to adapt to the change?

You are coding a custom application. You have some output that you want to appear in the container log in Kubernetes. What can you do to accomplish this?

- There is no way to do this.
- Write the data to the container log file.
- Write the data to standard output.
- Send the data to the container logging API.


Which of the following methods can Kubernetes probes use to detect container status? (Select all that apply.)

Choose 3


Directly read the container filesystem.


Attempt a TCP socket connection.


Run a command inside the container.


Use an HTTP request.






### 4.10 Application Observability and Maintenance Summary

the Kubernetes API deprecation policy deals with how changes to the Kubernetes API are managed.

probes and health checks allow us to automate health status monitoring for the containers.
We talked about monitoring in Kubernetes,
gathering insight into container status and performance.

container logging. - accessing log output from the Kubernetes containers.

debugging - locating relevant data to help you identify problems with your Kubernetes applications.
I want to  take a quick moment
to review the exam tips from section
regarding API deprecation policy.
First, API deprecation is the process of announcing changes
to an API early,
giving users time to update their code and/or tools.
Secondly, Kubernetes remove support for deprecated APIs
that are in general availability,
only after 12 months or 3 Kubernetes releases,
whichever is a longer time period.
When it comes to probes and health checks,
first, liveness probes check if a container is healthy
so that it can be restarted if it is not.
Secondly, readiness probes check
whether a container is fully started up
and ready to be used.

Probes can run a command inside the container that can make an HTTP request or attempt a TCP socket connection in order to determine the container status.

For monitoring, the Kubernetes Metrics API provides metric data about container performance.

you can view Pod metrics using the "kubectl top Pod" command.

container logging:

Standard and error output for containers are stored automatically in the container log.

View the container log using "kubectl logs,"

If you're viewing logs for a multi-container Pod, use the -C flag to specify which container's logs you want to view.

debugging - use "kubectl get Pods" to check the status of all Pods in a Namespace and use the "all-namespaces" flag if you don't know what Namespace to look in.
use "kubectl describe" to get detailed information about Kubernetes objects.

use "kubectl logs" to retrieve container log data.
if none of that works check the cluster-level logs.


## CHAPTER 5 Application Environment, Configuration, and Security

### 5.1 Intro - Application Environment, Configuration, and Security

- Custom resources, or CRDs, CustomResourceDefinitions.
- How to define custom Kubernetes object resources.
- How to create the own custom Kubernetes objects.

ServiceAccounts and authentication:

- Authenticating with the Kubernetes API
- Using ServiceAccounts from within containers.
- Admission control handles validation and preprocessing of Kubernetes API requests.
- Compute resource management.
  - Managing compute resource usage for the containers.
- Application configuration--storing configuration data and passing it to the applications.
- Security context -- allows us to provide advanced security settings for the containers.


### 5.2 Using Custom Resources (CRD)

[Lesson Reference]()

A custom resource is an extension of the Kubernetes API that allows you to define your own custom Kubernetes object types and interact with them  as you would with other Kubernetes objects.

We have interacted with Kubernetes objects like Pods and Deployments before, but custom resources  allow you to create your own custom Kubernetes objects that you can interact with in the same way.

A CustomResourceDefinition (CRD) allows you to define these customized Kubernetes objects.

In the Kubernetes control plane server create a CRD for a custom resource called myresource

interact with that resource,

kubectl get myresource, to get a list of objects based on that CustomResourceDefinition.

you can also create custom controllers that  act upon these custom resources in specialized ways.

custom controllers are not part of the Certified Kubernetes Application Developer curriculum.

 you don't really need to dive into that for the purposes of the CKAD.

create the own custom resource.

I'm logged in to the Kubernetes control plane server, and I'm going to start by creating the own CustomResourceDefinition.

I'll  create file called beehives.yml.

I'm going to create a CustomResourceDefinition
that will allow us to  have a new Kubernetes object called beehive.

we'll be able to create a beehive after we've created the custom definition
for that beehive object type.

I'll start by putting in the top of the yml here to create a CustomResourceDefinition,
I'm going to use the kind of custom resource definition, and that is part of API version.

It's in the apiextensions.k8s.io API, /v1.

Now I'm going to leave the name blank for now
because we're going to need to make that match
some of the other data that we're going to do first.

I'll create the specification for the CustomResourceDefinition.

We need to set is the group.
this is usually related in some way to the organization that owns or manages the CustomResourceDefinition.

set group to acloud.guru and then set the names field here.

here we need to provide a series of names that we're going to use to refer to the objects that are defined by CRD.

Set plural to beehives, which allows us to issue a command like kubectl get beehives to get a list of the objects that are defined by the CRD.

Set singular to beehive.

I could issue command kubectl get beehives or kubectl get beehive.

Set kind to beehive.

Optionally you can also provide a list of shortNames.

But I'll add a shortName 'hive' to allow a command like 'kubectl get hive'.

Set the name for the CRD.
the name has to match a specific format.
It has to begin with the plural name (in case, 'beehives') followed by a dot and then the group name.
 the name is going to be beehives.acloud.guru.
```
metadata:
  name: beehives.acloud.guru
spec:
  group: acloud.guru
  names:
    plural: beehives
```

scope. set it to Namespaced,
means CRD is only going to be active within a specific Namespace.
that'll  be whatever Namespace it resides in.
So, because we haven't specified one, that'll be the default Namespace.
I could also set to a cluster scope where the CRD would be available throughout the whole cluster.
But for right now, we're  going to make it available in that one Namespace.

versions allows providing for multiple versions of the schema for the CustomResourceDefinition.

Now, for now, we're  going to create a single version.
I'm  going to call it v1.
Now I have set served equal to true here.

That means that the API server will serve version.

I've also set storage equal to true.

Only 1 version can have storage set to true.

That indicates that the API server

is going to use version to  store the data for the objects behind the scenes.
because we only have 1 version, I'm going to set that to true for v1.
the final thing I need to set up is the schema.
the schema   defines
the data fields that are available
for the custom object.
 I'll  paste that in here.
 I'm defining a schema, the type is object,
and I have a set of properties.
These are the properties that the object is going to have.
Of course, I will have a spec.
 when we create a new beehive object,
we'll have a spec inside that object,
and we have some properties.
I have 2 properties, supers and bees,
and both of those are integers.
  a beehive will  include
information about the number of supers
and the number of bees in that hive.
 these are the 2 properties
that are going to be part of the custom object.
 I'll  save and exit that file.
let's create the CRD with kubectl apply.
Now that the CRD has created, I can do kubectl get crd.
I can see all of the CRDs
that are available currently.
There is a lot of them that were created when we installed the Calico network plugin, but here is the custom CRD that I  created,
'beehives.acloud.guru'.

CRDs are  Kubernetes objects
that we can interact with as usual using kubectl.
Now that we've created the CustomResourceDefinition,
let's create an actual beehive object
based on that CRD.
 I'll  create a yml file here called
test-beehive.yml.
I'll start with the apiVersion.
Now I need to set the apiVersion
to the group for the CRD.
 if you remember,
the group that I used for the CRD was acloud.guru.
then I'll do a slash and the version number,
and we  had 1 version number, and it was v1.
 I'll do acloud.guru/v1.
For the kind, I'll  send that to the kind
that we specified in the CRD as well,
which is  beehive.
of course I can set the metadata,
and I'll  give a name,
of test-beehive.
then I can provide the spec.
Now, if you remember the 2 properties
that I specified in the spec for the CRD
was supers and bees.
those are both integers,
so I need to provide numbers.
 I'll  set supers to 3 and bees to 60,000.
 now that I've done that,
that is the specification for the new beehive.
 I'll save that,
and then we can create it with kubectl apply.
with that, I've created the beehive object
Now because of the CRD,
we can interact with object,
 using commands like kubectl get beehives.
There I can see the test beehive.
You can also use the singular version
kubectl get beehive,
or I can use that short name
that I specified kubectl get hive.
of course, I can also use commands
like kubectl describe.
 I'll do kubectl describe beehive test-beehive.
that'll give me additional information
about that beehive object.
 that's what CRDs allow us to do.
We can create custom object types
that we can interact with
 like any other Kubernetes object.
Now that we've explored CRDs in the cluster,
let's go through a few quick exam tips.
First, custom resources are  extensions
of the Kubernetes API.
a CustomResourceDefinition defines a custom resource.
 that was  a quick overview of using CRDs
and custom resources in the Kubernetes cluster.

[Extend the Kubernetes API with CustomResourceDefinitions] (https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/)

[Custom Resources](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)


[Using Custom Resources (CRD)](PDF/S05L02_Using_Custom_Resources_(CRD).pdf)

Exam Tips

- Custom Resources are extensions to the Kubernetes API.
- A CustomResourceDefinition defines a custom resource.

Lesson Reference

Log in to the control plane node.

Create a CustomResourceDefinition.
```
vi beehives.yml

apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: beehives.acloud.guru
spec:
  group: acloud.guru
  names:
    plural: beehives
    singular: beehive
    kind: BeeHive
    shortNames:
    - hive
  scope: Namespaced
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              supers:
                type: integer
              bees:
                type: integer

kubectl apply -f beehives.yml

customresourcedefinition.apiextensions.k8s.io/beehives.acloud.guru created
```
List the current CRDs.

kubectl get crd

cloud_user@control:~$ k get crd

NAME                                                  CREATED AT
beehives.acloud.guru                                  2022-12-27T19:53:28Z
...

Create an object using your new CRD.
- apiVersion is the group + version.

```
vi test-beehive.yml

apiVersion: acloud.guru/v1
kind: BeeHive
metadata:
  name: test-beehive
spec:
  supers: 3
  bees: 60000

kubectl apply -f test-beehive.yml

```

Interact with your custom object using kubectl commands.
```
kubectl get beehives

kubectl get hive

kubectl describe beehive test-beehive
```

### 5.3 Using ServiceAccounts

[Lesson Reference](PDF/S05L03_Using_ServiceAccounts.pdf)

Documentation

[Configure Service Accounts for Pods](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)

[Managing Service Accounts](https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/)

[Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

A ServiceAccount allows processes in containers to authenticate with the Kubernetes API server.

Processes can be assigned permissions via role-based access control (just like regular user accounts).

If you need to interact with the Kubernetes API from inside one of your Kubernetes containers a ServiceAccount is used to authenticate and manage permissions for a process.

A service account provides an identity for processes that run in a Pod, and maps to a ServiceAccount object. When you authenticate to the API server, you identify yourself as a particular user. Kubernetes recognises the concept of a user, however, Kubernetes itself does not have a User API.

ServiceAccounts use ServiceAccount tokens.  
- A token is the credential used to access the API using the ServiceAccount.
- The ServiceAccount token will automatically be mounted to each container and used by default.
- You can turn the ServiceAccount token off if you don't want to use it.  

We have the Pod here, and we have the ServiceAccount, and it's going to mount that token
inside the container.

The token for a Pod's ServiceAccount is automatically mounted to each container and used by default.

The container process can then use the automatically-mounted token to authenticate with the control plane and interact with the API server.

Log in to the control plane node.

Create a yaml file, 'my-sa.yml', for a ServiceAccount and enter the definition.
```
vi my-sa.yml

apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-sa
automountServiceAccountToken: true

kubectl apply -f my-sa.yml
```
ServiceAccounts are a Namespaced object; since we don't define a Namespace Service Account will belong to the default Namespace.

automountServiceAccountToken = [true|false]

If you don't want the token for the service account to automatically be mounted into the containers that are using that account you can set automountServiceAccountToken to false.  But we're going to set it to true.

Next create a Pod that will use and test the ServiceAccount functionality.
```
vi sa-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: sa-pod
spec:
  serviceAccountName: my-sa
  containers:
  - name: busybox
    image: radial/busyboxplus:curl
    command: ['sh', '-c', 'while true; do curl -s --header "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt https://kubernetes/api/v1/namespaces/default/pods; sleep 5; done']

kubectl apply -f sa-pod.yml
```
We specify the serviceAccountName, 'my-sa', in the Pod spec.  Therefore the 'sa-pod' will use the 'my-sa' custom ServiceAccount we created.

If we don't specify a Pod's serviceAccountName, the Pod will use the default ServiceAccount which, by default, doesn't have any permissions.

The Pod spec contains a single busybox container.  The radial/busyboxplus:curl image provides a basic busybox image with curl installed so we can use curl to make requests to the Kubernetes API.

The command in the Pod spec runs curl (in silent mode, -s) in a loop to make a request every five seconds to a service in the cluster at 'https://kubernetes/api/v1/namespaces/default/pods' that points to the Kubernetes API.

Requests to the Kubernetes host name automatically access the API; then the request is directed to /api/v1/namespaces/default/pods.

The request will retrieve a list of Pods in the default Namespace.  is the same type of information that would be returned by `kubectl get pods`.

Other flags:

--header "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"

This is the authorization header, which we use to authenticate with the API.

We provide the Bearer token.  We can read the token by reading a file on the disk because the ServiceAccount token is going to be mounted automatically to the container as a volume mount.  The ServiceAccount token will always be mounted in location: /var/run/secret/kubernetes.io/serviceaccount/tokens.

We read the token and include it as the Bearer token in the authorization header, which allows us to authenticate to the Kubernetes API.

--cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt

The cacert allows the curl command here to trust the Kubernetes API server certificate so curl can authenticate the Kubernetes API server as well.

To [use `kubectl exec` to get a shell into the running container](https://kubernetes.io/docs/tasks/debug/debug-application/get-shell-running-container/), to inspect these certificates:
```
kubectl exec --stdin --tty [POD NAME] -- /bin/bash
```
We have mutual authentication.

Kubernetes provides the cacert file mounted to the container as well.

We will pass the path to the cacert file in the flag: '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'.

Once the 'sa-pod' Pod is created inspect the logs for sa-pod.

`kubectl logs sa-pod`

The logs show several attempts to make the request to the Kubernetes API.  Every 5 seconds the response says the request is failing, but I am successfully authenticating, so is not an authentication issue, the reason is 'forbidden' and I'm getting a 403 response code.

The 403 response code means the client does not have access rights to the content; that is, it is unauthorized, so the server is refusing to give the requested resource. Unlike 401 Unauthorized, the client's identity is known to the server.

So is an authorization issue.  The ServiceAccount does not have permission to view a list of Pods.

The ServiceAccount doesn't have any permissions.  We did not assign any permissions, we created the ServiceAccount.  We are, however, successfully authenticating and communicating with the API.

In the next lesson, we will provide the necessary permissions to the ServiceAccounts.

To enable RBAC, start the API server with the --authorization-mode flag set to a comma-separated list that includes RBAC; for example:
```
kube-apiserver --authorization-mode=Example,RBAC --other-options --more-options
```
RBAC is or can be enabled in the control node configuration file: /etc/kubernetes/manifests/kube-apiserver.yaml


Lesson Reference

Create a ServiceAccount in the control plan node.
```
vi my-sa.yml

apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-sa
automountServiceAccountToken: true

kubectl apply -f my-sa.yml
```
Create a Pod that uses the new ServiceAccount.
```
vi sa-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: sa-pod
spec:
  serviceAccountName: my-sa
  containers:
  - name: busybox
    image: radial/busyboxplus:curl
    command: ['sh', '-c', 'while true; do curl -s --header "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt https://kubernetes/api/v1/namespaces/default/pods; sleep 5; done']

kubectl apply -f sa-pod.yml
```
Note the spelling of 'ca.crt'

Check the Pod logs.
```
kubectl logs sa-pod

{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {},
  "status": "Failure",
  "message": "pods is forbidden: User \"system:serviceaccount:default:my-sa\" cannot list resource \"pods\" in API group \"\" in the namespace \"default\"",
  "reason": "Forbidden",
  "details": {
    "kind": "pods"
  },
  "code": 403
```
The Pod log should display an error message indicating that the ServiceAccount does not have appropriate permissions to perform the requested API call.

The above log indicates an authorization problem, not an authentication problem.  The caller isn't authorized to access the file.  We are, however, successfully authenticating and communicating with the API.


Exam Tips

- ServiceAccounts allow processes within containers to authenticate with the Kubernetes API server.
- You can set the Pod’s ServiceAccount with serviceAccountName in the Pod spec.
- The Pod’s ServiceAccount token is automatically mounted to the Pod’s containers.

### 5.4 Understanding Kubernetes Auth

<span style="float:right">[Lab diagram]()</span><br />

<img src="images/service_account_role_diagram_Large_test_1.jpg"
     alt="ServiceAccount, Role and RoleBinding relationships"
     style="float: right; margin-right: 10px; margin-bottom: 10px;"
     width="95%" />

[Lesson Reference](PDF/S05L04_Understanding_Kubernetes_Auth.pdf)

Documentation

[Authenticating](https://kubernetes.io/docs/reference/access-authn-authz/authentication/)
[Controlling Access to the Kubernetes API](https://kubernetes.io/docs/concepts/security/controlling-access/)
[Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

Authentication vs. authorization

If a user wants to interact with the  Kubernetes API and ultimately with the Kubernetes cluster itself, the user makes a request to the K8s API.

First the user must be authenticated.

Then we evaluate the user's authorization to verify that the user has permission to do what they're trying to do.

In Kubernetes, there are 2 different types of users that we might try to authenticate.

1. ('Regular', human) users
- Human users are not represented by any kind of Kubernetes object,
- Users authenticate using client certificates.
- Users are sort of automatically created if their client certificate is valid.
- Users are usually used by an actual human user or tool running outside the cluster.
- Human users are assumed to be managed by an outside, independent service, like...
  - An admin distributing private keys, a user store like Keystone or Google Accounts, even a file with a list of usernames and passwords.

2. Service Accounts
- Represented by Kubernetes objects.
- Create a ServiceAccount using a YAML file or a command like kubectl create serviceaccount,
- Authenticate using an API token; ServiceAccounts usually don't use client certificates.
- If you have an automated process running inside one of your cluster containers, it's probably using a ServiceAccount; otherwise, it's a regular user.

Users and ServiceAccounts can both receive authorization using role-based access control.  is one major thing they have in common.  You can use role-based access control to control permissions for both regular users and ServiceAccounts.

Role-based access control.

- How we manage authorization in Kubernetes.
- Once we've authenticated either a user or a ServiceAccount, we can determine what permissions they have using role-based access control.

RBAC allows you to define what your users or groups of users are allowed to do within the Kubernetes cluster.

Log in to the Kubernetes control plane node.

Create a role, 'list-pods-role' that gives users permission to list Pods.

```
vi list-pods-role.yml

apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: list-pods-role
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["list"]

kubectl apply -f list-pods-role.yml
```
We leave the API group blank because Pods are part of the core API.  We don't need to specify a special API group there.

The resource is the type of Kubernetes object that we're going to act on.

The resource is going to be ["pods"].

The verb is going to be ["list"].  The verb is the action permitted the object.

Users with list pods role (assuming they don't have any other roles) will only be able to do one thing: retrieve a list of Pods.

I'll save and exit that.

Roles are namespaced: Role will only be able to function within a particular Namespace, in case, the default Namespace.

You can also create ClusterRoles, cluster-wide roles.

Create the Role with kubectl apply.

Connect the newly-created Role to some kind of account so that that account has the permissions associated with the Role.

We now create a RoleBinding to attach the Role to the ServiceAccount we created in the previous lesson.

A RoleBinding binds permissions within a specific Namespace.

Create list-pods-rb.yml.
```
vi list-pods-rb.yml

apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: list-pods-rb
subjects:
- kind: ServiceAccount
  name: my-sa
  namespace: default
roleRef:
  kind: Role
  name: list-pods-role
  apiGroup: rbac.authorization.k8s.io

kubectl apply -f list-pods-rb.yml

k get roles
```
The RoleBinding 'subjects' points to a list of accounts that the RoleBinding is addressing.

We specify a subject, ServiceAccount, having the name 'my-sa' in the default Namespace.

Now, if I was binding Role to a 'regular' (human) user, we could list the 'regular' user there as well.  You can list multiple users and multiple ServiceAccounts in subjects list.

The roleRef points to the Role to which we are binding these subjects.

We bind the RoleBinding to the 'list-pods-role' Role we created earlier.

We bind the 'list-pods-role' to the 'my-sa' ServiceAccount.

Exit, save, apply.

<img src="images/rbac-2023-01-14.jpg"
     alt="ServiceAccount, Role and RoleBinding relationships"
     style="float: right; margin-right: 10px; margin-bottom: 10px;"
     width="90%" />

In the previous lesson we created a ServiceAccount and a Pod that was trying to list Pods with a curl request to the Kubernetes API using that ServiceAccount.

The curl command failed because the ServiceAccount didn't have permissions.

The curl command was able to authenticate, but didn't have authorization to list Pods.

Now we should have provided the ServiceAccount with permission to list Pods.
```
kubectl logs sa-pod.
```
Instead of error messages anymore we receive a lot of information.


The curl request to the API is successfully retrieving information because we have provided the appropriate permissions to the ServiceAccount.


There is also a ClusterRoleBinding that can bind permissions across all Namespaces, but we're going to focus within the Namespace for now.


Lesson Reference

In the control plane node create a Role that provides permission to list Pods.
```
vi list-pods-role.yml

apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: list-pods-role
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["list"]

kubectl apply -f list-pods-role.yml
```
Create a RoleBinding to bind the new Role to the my-sa ServiceAccount. Note: ServiceAccount was created in a previous lesson.
```
vi list-pods-rb.yml

apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: list-pods-rb
subjects:
- kind: ServiceAccount
  name: my-sa
  namespace: default
roleRef:
  kind: Role
  name: list-pods-role
  apiGroup: rbac.authorization.k8s.io

kubectl apply -f list-pods-rb.yml
```
Note: RoleBinding has a 'subjects' (plural) field, not singular 'subject'.

Check the logs for sa-pod.

kubectl logs sa-pod

Now that permissions have been provided to the ServiceAccount using RBAC, the log should indicate that the Pod is able to successfully access the API and retrieve a list of Pods in the default Namespace.


Exam Tips

- Usually "normal" (human) users authenticate using client certificates, while ServiceAccounts use tokens.
- Authorization for both "normal" users and ServiceAccounts can be managed using role-based access control (RBAC).
- Roles and ClusterRoles define a specific set of permissions.
- RoleBindings and ClusterRoleBindings tie Roles or ClusterRoles to users/ServiceAccounts.

### 5.5 Exploring Admission Control

[Lesson Reference](PDF/S05L05_Exploring_Admission_Control.pdf)

Documentation

[Using Admission Controllers](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)

[A Guide to Kubernetes Admission Controllers](https://kubernetes.io/blog/2019/03/21/a-guide-to-kubernetes-admission-controllers/)

Admission controllers intercept requests to the Kubernetes API after authentication and authorization but before any objects are persisted.

Admission controllers can be used to validate, deny, or even modify the request.

Admission controllers allow you to provide even customized functionality that intercepts your requests coming into the API, and you can really use them as tools to do a wide variety of different things.

We have the user making a request to the Kubernetes API, and before the Kubernetes API  saves any changes to the Kubernetes data store, the API will go through all of the admission controllers.

The API will go through admission controller 1, and admission controller 1 might deny that request or perhaps even make some modifications to it.  We can have multiple admission controllers.  If there's another admission controller, it will go through that other admission controller all the way through the list.

Once the request has been through all the admission controllers, provided the request hasn't been denied, the request will be stored in the data store.

Each admission controller can provide its own flavor of customization or additional features on top of what's available in a normal Kubernetes installation.

There are multiple admission controllers that come built into Kubernetes itself, and you can even code your own.

We won't cover creating custom admission controllers in lesson.

We will now activate a built-in Kubernetes admission controllers and examine its effects.

In the control plane create a busybox Pod, 'new-namespace-pod.yml'.  The Pod is configured to echo some text to the console every five seconds.
```
vi new-namespace-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: new-namespace-pod
  namespace: new-namespace
spec:
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'while true; do echo Running...; sleep 5; done']

kubectl apply -f new-namespace-pod.yml
```
We set the Namespace for Pod to 'new-namespace', which does not yet exist.

Save, exit, apply.

The resulting error message says the Namespace was not found.

If you want such Namespaces to be created automatically every time someone tries to create an object with a Namespace that doesn't exist, there is an admission controller that provides exactly that functionality.  There are many different things admission controllers can do.

See the the Kubernetes documentation for more information on the different admission controllers that are available.  In the following discussion we describe an admission controller that will automatically create a Namespace if we try to create an object for which the specified Namespace doesn't exist.

To activate or deactivate admission controllers, change the Kubernetes API server configuration.

You need root access to edit the file.

`sudo vi /etc/kubernetes/manifests/kube-apiserver.yaml`

the file is a static Pod manifest for the Kubernetes API server, 'kube-apiserver'.

Under spec: containers: -command, kube-apiserver is run with a long list of flags.
```
apiVersion: v1
kind: Pod
metadata:
  annotations:
    kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint: 172.31.124.84:6443
  creationTimestamp: null
  labels:
    component: kube-apiserver
    tier: control-plane
  name: kube-apiserver
  namespace: kube-system
spec:
  containers:
  - command:
    - kube-apiserver
    - --advertise-address=172.31.124.84
    - --allow-privileged=true
    - --authorization-mode=Node,RBAC
    - --client-ca-file=/etc/kubernetes/pki/ca.crt
    - --enable-admission-plugins=NodeRestriction,NamespaceAutoProvision,ResourceQuota
    - --enable-bootstrap-token-auth=true
    - --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt
    - --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt
    - --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key
    - --etcd-servers=https://127.0.0.1:2379
    - --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt
    - --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key
    - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
    - --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt
    - --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key
    - --requestheader-allowed-names=front-proxy-client
    - --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt
    - --requestheader-extra-headers-prefix=X-Remote-Extra-
    - --requestheader-group-headers=X-Remote-Group
    - --requestheader-username-headers=X-Remote-User
    - --secure-port=6443
    - --service-account-issuer=https://kubernetes.default.svc.cluster.local
    - --service-account-key-file=/etc/kubernetes/pki/sa.pub
    - --service-account-signing-key-file=/etc/kubernetes/pki/sa.key
    - --service-cluster-ip-range=10.96.0.0/12
    - --tls-cert-file=/etc/kubernetes/pki/apiserver.crt
...
```
The flag --enable-admission-plugins can be used to enable additional admission controllers.

By default the kube-apiserver has NodeRestriction enabled. There are also some other flags that are enabled by default in kube-apiserver.  See the Kubernetes documentation for more information regarding these admission plugins that are being enabled beyond the default that's coded into kube-apiserver there.

Currently the 'NodeRestriction' plugin is enabled but we're going to add another one.

At the end of the flag's line, add a comma and 'NamespaceAutoProvision'.
```
 - --enable-admission-plugins=NodeRestriction,NamespaceAutoProvision,ResourceQuota
```
NamespaceAutoProvision is a built-in admission controller that comes as part of Kubernetes but is not enabled.

Once enabled the NamespaceAutoProvision admission controller will intercept incoming requests.  If we try to create an object in a Namespace that doesn't exist the NamespaceAutoProvision admission controller will automatically create the Namespace and allow us to create that object as well.

Save and exit the kube-apiserver.yaml file.

Changing the kube-apiserver manifest will cause the kube-apiserver to be re-created.  The kube-apiserver might be unavailable for a few moments.

Try again to create the new-namespace-pod Pod.

kubectl apply -f new-namespace-pod.yml

The pod should now be created successfully even though the specified Namespace did not exist.

`kubectl get namespace` will show that the specified Namespace was created.

We enable an admission controller by changing a flag on kube-apiserver.

Now you can go back and undo the change.  


Lesson Reference

In the control plane node try to create a Pod in a nonexistent Namespace.
```
vi new-namespace-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: new-namespace-pod
  namespace: new-namespace
spec:
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'while true; do echo Running...; sleep 5; done']

kubectl apply -f new-namespace-pod.yml
```
This will fail because specified Namespace, new-namespace , does not exist.

Change the API Server configuration to enable the NamespaceAutoProvision admission controller.
```
sudo vi /etc/kubernetes/manifests/kube-apiserver.yaml

```
Locate the --enable-admission-plugins flag, and add NamespaceAutoProvision to the list.
```
- --enable-admission-plugins=NodeRestriction,NamespaceAutoProvision
```
When you save changes to file, the API Server will be automatically re-created with the new settings. The API server may become unavailable for a few moments during process. Most kubectl commands will fail during time, until the new API Server is available.

Try to create new-namespace-pod again.
```
kubectl apply -f new-namespace-pod.yml
```
It should succeed time, as the NamespaceAutoProvision admission controller will automatically handle the process of creating the Namespace.

List the Namespaces to see the new Namespace.

kubectl get namespace

Exam Tips

- Admission controllers intercept requests to the Kubernetes API and can be used to validate or modify them.
- You can enable admission controllers using the `--enable-admission-plugins` flag for kube-apiserver.


### 5.6 Managing Compute Resource Usage

[Lesson Reference](PDF/S05L06_Managing_Compute_Resource_Usage.pdf)

Documentation

Managing Resources for Containers  https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

Assign CPU Resources to Containers and Pods https://kubernetes.io/docs/tasks/configure-pod-container/assign-cpu-resource/

Resource Quotas  https://kubernetes.io/docs/concepts/policy/resource-quotas/

Resource requests

Kubernetes resource requests are a specification of the expected minimum resources (such as CPU and memory) that a container will need to run effectively.  Resource requests are specified in the resource specification section of a Pod's spec.container definition.

Resource requests act as a guarantee to the cluster scheduler that the container will have the required resources available to it at all times.  Resource requests are used by the scheduler to make placement decisions, ensuring that containers are placed on nodes that have enough capacity to meet their resource requirements.

For example, if a container requests 1 CPU and 512 MB of memory, the scheduler will ensure that the node where the container is scheduled has at least that much free capacity. If a node does not have enough free capacity to meet the request, the scheduler will not place the container on that node.

It's important to note that the resource requests do not limit the maximum amount of resources that a container can use. The actual usage may be higher, but the requests provide a guarantee that the container will have enough resources to function correctly.

A resource request provides Kubernetes with an idea of how many resources a container is expected to use.  Requests are kind of an approximation or estimate.  Requests are used to determine which node a Pod will be run on.

A request is the amount of that resources that the system will guarantee for the container, and Kubernetes will use this value to decide on which node to place the pod. A limit is the maximum amount of resources that Kubernetes will allow the container to use.

Requests describes the minimum amount of compute resources required. If Requests is omitted for a container, it defaults to Limits if that is explicitly specified, otherwise to an implementation-defined value.  More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

Resource limits

Kubernetes resource limits are the maximum amount of resources (such as CPU and memory) that a container is allowed to use.  Resource limits are specified in the resource specification section of a Pod's definition, just like resource requests.

The purpose of resource limits is to ensure that one container does not consume all the resources of a node and negatively impact the performance of other containers running on the same node. Resource limits provide a way to control and manage the resource usage of containers in a cluster.

For example, if a container has a limit of one CPU and 512 MB of memory, the container will not be able to use more than that amount of resources, even if the node has more free capacity. If the container tries to consume more resources than its limit, it will be throttled or potentially killed by the kubelet, the primary "node agent" that runs on each node.

It's important to note that the resource limits should be set in conjunction with resource requests. The limits should be set higher than the requests to ensure that containers have enough resources to operate correctly, but not so high that they can consume all the resources of a node and impact other containers.

Resource limits are a hard upper limit. Limits are used to terminate the container if it exceeds that resource usage limit.

ResourceQuota

A Kubernetes ResourceQuota is a cluster-level resource management feature that allows administrators to enforce limits on the total amount of resources used by objects in a Namespace.  A ResourceQuote provides a way to control and manage the resource usage of multiple Pods, Services, and other objects in a Namespace, ensuring that one set of objects does not consume all the available resources and negatively impact the performance of other objects.

A ResourceQuota is defined as a Kubernetes object and is applied to a Namespace. It specifies the maximum amount of resources that can be consumed by objects in the Namespace, such as CPU, memory, or custom resources. Once a ResourceQuota is applied, the Kubernetes scheduler will ensure that no object in the Namespace can consume more resources than the specified limit.

For example, a ResourceQuota can be used to:
- limit the total amount of CPU and memory that can be consumed by all Pods in a Namespace, or
- limit the number of PersistentVolumeClaims that can be created.

By using ResourceQuotas, administrators can ensure that resource usage is managed effectively across a cluster, prevent one set of objects from consuming all the available resources, and ensure that resources are used fairly and efficiently.

A ResourceQuota is a Kubernetes object that sets limits on the resources used within a Namespace.  If creating or modifying a resource would go beyond limit, the request will be denied.

If you have multiple different teams using different Namespaces in your cluster and you want to make sure that one team doesn't end up using all of the compute resources a ResourceQuota is a good way to accomplish that.

Log in to the Kubernetes control plane node

Create a Namespace for testing, resources-test.
```
k create ns resources-test

or

apiVersion: v1
kind: Namespace
metadata:
  name: resources-test

kubectl config set-context --current --namespace=resources-test
```
ResourceQuotas affect the quantity of resources available for use within a Namespace.  I don't want to set a ResourceQuota on the **default** Namespace, and then later find there are problems such as not being able to create Pods because we're using too many resources.

Create a Pod with a file, resources-pod.yml.
```
vim resources-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: resources-pod
spec:
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'while true; do echo Running.....; sleep 5; done']
    resources:
      requests:
        memory: 64Mi
        cpu: 250m
      limits:
        memory: 128Mi
        cpu: 500m

# alternative command with date:
command: ['sh', '-c', 'while true; do echo Running... $(date +%F_%T); sleep 5; done']

kubectl apply -f resources-pod.yml
```
Create some resource requests and limits.

Resource requests and limits are part of the container spec.

Set memory to 64Mi, 64 mebibytes.

Specify CPU, 250m, 250 milli-CPUs.

Memory is measured in storage amounts.
For resource requests, CPU is specified in the amount of a CPU core that we want to use.

A milli-CPU is 1/1000 of a CPU core, so 250 milli-CPUs is approximately 1/4 of a single CPU core.

The resource request doesn't mean that the container can't end up using more than amount of memory or amount of CPU, and it doesn't mean that the container has to use amount.

A resource request provides Kubernetes with kind of the approximation of how much we intend it to use.  Kubernetes can use that information to select a node to run Pod that has enough resources available.

Optionally, we can set limits.
Resource limits need to be greater than or equal to the resource request.

Set the memory limit to 128Mi and CPU to 500 milli-CPUs or 1/2 of 1 CPU core.

These resource limits are hard limits.  If the container process tries to exceed the limits, the container process will be terminated.

Save, exit, apply.  Check that the Pod is runnng.

```
k get pods -n resources-test
```

ResourceQuotas

ResourceQuotas are enforced using an admission controller.

To experiment with ResourceQuotas we will first need to enable the admission controller, which is not enabled by default.
```
sudo vim /etc/kubernetes/manifests/kube-apiserver.yml
```
Find the enable admission plugins list and add ResourceQuota to the end of the list.  Save, exit.

Whenever we edit the kube-apiserver.yml manifest file the API server to be re-created,
and will be unavailable for a short period of time. You might have to wait for the kube-apiserver to become responsive again.

So if you run a command like `kubectl get pods` you might get an error message here,

Once the ResourceQuota admission controller is enabled, create a ResourceQuota object.
```
vim resources-test-quota.yml

apiVersion: v1
kind: ResourceQuota
metadata:
  name: resources-test-quota
  namespace: resources-test
spec:
  hard:
    requests.memory: 128Mi
    requests.cpu: 500m
    limits.memory: 256Mi
    limits.cpu: "1"

kubectl apply -f resources-test-quota.yml
```
The 'resources-test-quota' ResourceQuote sets hard limits that will be strictly enforced.

We specify `hard` under `spec` and provide quota values.

The ResourceQuota interacts with the resource requests and limits that are set on the various containers.

The ResourceQuota provides an upper limit for each of these values aggregated across the entire Namespace.

The ResourceQuota says that:
- the sum of all the resource **requests** for all the containers in the Namespace should not exceed exceed 128Mi or 500 milli-CPUs.
- the sum of all the resource **limits** for all the containers in the Namespace should not exceed exceed 256Mi or 1000 milli-CPUs (1 entire CPU core).

Creating a ResourceQuote requires you to specify requests and limits for all the containers within Namespace as well.

Once you set up a ResourceQuota for a Namespace, all containers in that Namespace must provide for resource requests and limits.

Now we try to create a Pod that attempts to exceed the 256MiB memory limit quota for the Namespace.

The following yml manifest creates a Pod named too-many-resources-pod in the resources-test Namespace.  The Pod container specifies a resource request and limit.  The server command runs a loop.
```
vi too-many-resources-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: too-many-resources-pod
  namespace: resources-test
spec:
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'while true; do echo Running...; sleep 5; done']
    resources:
      requests:
        memory: 64Mi
        cpu: 250m
      limits:
        memory: 200Mi
        cpu: 500m

kubectl apply -f too-many-resources-pod.yml
```
Alone, the 'too-many-resources' Pod container spec calls for resource.limit.memory of 200Mi, less than the quota's hard.limit.memory of 256Mi.

But the 'too-many-resources' Pod container spec resource.limit.memory of 200Mi, combined with the 'resources-test-quota' Pod resources.limit.memory of 128Mi that we created earlier, totals 328Mi, exceeding the quota of 200Mi.

The quote applies to the aggregate of resources of all the containers across the whole Namespace.

Pod creation fails if the quota would be exceeded.

                        ---- Requests ----    ---- Limits ----
                        Memory   CPU in       Memory    CPU in
                         MiB    milli-CPUs     MiB     milli-CPUs
resources-pod            64Mi    250m         128Mi     500m
too-many-resources-pod   64Mi    250m         200Mi     500m
Total Pod resources     128Mi    500m         328Mi    1000m

resources-test-quota    128Mi    500m         256Mi    1000m
status                    OK      OK          Fail      OK

Attempting to create the too-many-resources-pod fails and we get an error message that describes what quota is being exceed:
```
Error from server (Forbidden): error when creating "too-many-resources-pod.yml": pods "too-many-resources-pod" is forbidden: exceeded quota: resources-test-quota, requested: limits.memory=200Mi, used: limits.memory=128Mi, limited: limits.memory=256Mi
```



Log in to the control plane node.

Create a new Namespace.
```
kubectl create namespace resources-test
```
Create a Pod with resource requests and limits.
```
vi resources-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: resources-pod
  namespace: resources-test
spec:
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'while true; do echo Running...; sleep 5; done']
    resources:
      requests:
        memory: 64Mi
        cpu: 250m
      limits:
        memory: 128Mi
        cpu: 500m

# alternative command with date:
command: ['sh', '-c', 'while true; do echo Running... $(date +%F_%T); sleep 5; done']

kubectl apply -f resources-pod.yml
```
Check the status of the new Pod.
```
kubectl get pods -n resources-test

k logs resources-pod -n resources-test
Running... 2022-12-28_11:07:25
Running... 2022-12-28_11:07:30
Running... 2022-12-28_11:07:35
```
Enable the ResourceQuota admission controller.
```
sudo vi /etc/kubernetes/manifests/kube-apiserver.yaml
```
Locate the --enable-admission-plugins flag and add ResourceQuota to the list.

Note: If the NamespaceAutoProvision controller is still enabled from a previous lesson, you can remove it from the list to disable it, or leave it enabled if you wish.
```
- --enable-admission-plugins=NodeRestriction,ResourceQuota
```
Create a ResourceQuota.
```
vi resources-test-quota.yml

apiVersion: v1
kind: ResourceQuota
metadata:
  name: resources-test-quota
  namespace: resources-test
spec:
  hard:
    requests.memory: 128Mi
    requests.cpu: 500m
    limits.memory: 256Mi
    limits.cpu: "1"

kubectl apply -f resources-test-quota.yml
```

Try to create a Pod that would exceed the memory limit quota for the Namespace.
```
vi too-many-resources-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: too-many-resources-pod
  namespace: resources-test
spec:
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'while true; do echo Running...; sleep 5; done']
    resources:
      requests:
        memory: 64Mi
        cpu: 250m
      limits:
        memory: 200Mi
        cpu: 500m

kubectl apply -f too-many-resources-pod.yml

Error from server (Forbidden): error when creating "too-many-resources-pod.yml": pods "too-many-resources-pod" is forbidden: exceeded quota: resources-test-quota, requested: limits.memory=200Mi, used: limits.memory=128Mi, limited: limits.memory=256Mi

k get quota -n resources-test

NAME                   AGE     REQUEST                                                LIMIT
resources-test-quota   6m42s   requests.cpu: 250m/500m, requests.memory: 64Mi/128Mi   limits.cpu: 500m/1, limits.memory: 128Mi/256Mi

k describe quota -n resources-test

Name:            resources-test-quota
Namespace:       resources-test
Resource         Used   Hard
--------         ----   ----
limits.cpu       500m   1
limits.memory    128Mi  256Mi
requests.cpu     250m   500m
requests.memory  64Mi   128Mi

k delete quota resources-test-quota -n resources-test
```
Exam Tips

- A resource request
  - informs the cluster of the expected resource usage for a container.
  - is used to select a node that has enough resources available to run the Pod.
- A resource limit sets an upper limit on how many resources a container can use. If the container process attempts to go above limit, the container process will be terminated.
- A ResourceQuota limits the amount of resources that can be used within a specific Namespace. If a user attempts to create or modify objects in that Namespace such that the quota would be exceeded, the request will be denied


### 5.7 Lab: Managing Resource Usage in Kubernetes

<span style="float:right">[Lab diagram](images/managing-resource-usage.png)</span><br />

<img src="images/managing-resource-usage.png"
     alt="Lab diagram:  Managing Resource Usage"
     style="float: right; margin-right: 10px; margin-bottom: 10px;"
     width="70%" />

Welcome to HiveCorp, a software design company that is totally not run by bees!

We have been expanding the usage of Kubernetes. However, as the applications have grown more complex, we have run into issues with the availability of compute resources. It is time to build a more sophisticated way of planning for and controlling resource usage in the cluster!

You will need to set up resource requests and limits for a Deployment in the cluster. Once that is done, set up a quota to limit the amount of resources that can be consumed in the hive Namespace.

Kubernetes offers a variety of features that can help you control how resources are allocated in your cluster. lab will allow you to build your experience with some of these features by solving problems that might arise in a real-world cluster.

Learning Objectives

- Configure Resource Requests for a Deployment
- Configure Resource Limits for a Deployment
- Create a ResourceQuota for a Namespace

Learning Objectives

- Configure Resource Requests for a Deployment

There is a Deployment called royal-jelly in the hive Namespace.

Add resource requests to this Deployment's containers. The container should request 128Mi memory and 250m CPU.

- Configure Resource Limits for a Deployment

Add resource limits to the Deployment called royal-jelly in the hive Namespace.

For the containers in this Deployment, the limits should be 256Mi for memory and 500m for CPU.

- Create a ResourceQuota for a Namespace

Use a quota to limit the resources that can be used in the hive Namespace.

The quota should allow total resource requests in the Namespace up to 1Gi for memory and 1 CPU.

For resource limits, the quota should allow up to 2Gi for memory and 2 CPU.

Note: The ResourceQuota admission controller is already enabled in the environment. You do not need to enable it.


Solution

Log in to the server using the credentials provided:

ssh cloud_user@<PUBLIC_IP_ADDRESS>

#### Configure Resource Requests for a Deployment

Edit the royal-jelly Deployment:
```
kubectl edit deployment royal-jelly -n hive
```
Scroll down to the container specification, and add the following resource requests (after terminationMessagePolicy):

Note: When copying and pasting code into Vim from the lab guide, first enter :set paste (and then i to enter insert mode) to avoid adding unnecessary spaces and hashes. To save and quit the file, press Escape followed by :wq. To exit the file without saving, press Escape followed by :q!.
```
        resources:
          requests:
            memory: 128Mi
            cpu: 250m
```
Type ESC followed by :wq to save your changes.

Verify the Deployment status:
```
kubectl get deployment royal-jelly -n hive
```
You should see 3/3 Pods in the READY status.

#### Configure Resource Limits for a Deployment

Edit the royal-jelly Deployment again:
```
kubectl edit deployment royal-jelly -n hive
```
Under the resource requests you added, add resource limits:
```
        resources:
          requests:
            memory: 128Mi
            cpu: 250m
          limits:
            memory: 256Mi
            cpu: 500m
```
Type ESC followed by :wq to save your changes.

Again, verify the Deployment status:
```
kubectl get deployment royal-jelly -n hive

NAME          READY   UP-TO-DATE   AVAILABLE   AGE
royal-jelly   3/3     3            3           32m


```
You should see the Deployment is up and running, as expected.

#### Create a ResourceQuota for a Namespace

Create a ResourceQuota in the hive Namespace:
```
vi hive-resourcequota.yml

apiVersion: v1
kind: ResourceQuota
metadata:
  name: hive-resourcequota
  namespace: hive
spec:
  hard:
    requests.memory: 1Gi
    requests.cpu: "1"
    limits.memory: 2Gi
    limits.cpu: "2"
```
Type ESC followed by :wq to save your changes.

Create the ResourceQuota with kubectl apply:
```
kubectl apply -f hive-resourcequota.yml
```
Get a list of ResourceQuotas in the hive Namespace to ensure everything is working:
```
kubectl get resourcequota -n hive

NAME                 AGE   REQUEST                                            LIMIT
hive-resourcequota   46s   requests.cpu: 750m/1, requests.memory: 384Mi/1Gi   limits.cpu: 1500m/2, limits.memory: 768Mi/2Gi
```
You should see the hive-resourcequota as well as some additional information indicating that you have successfully created the ResourceQuota.

Learning Objectives

- Configure Resource Requests for a Deployment
- Configure Resource Limits for a Deployment
- Create a ResourceQuota for a Namespace


### 5.8 Configuring Apps with ConfigMaps and Secrets

[Lesson Reference](PDF/S05L07_Configuring_Applications_with_ConfigMaps_and_Secrets.pdf)

Documentation

[ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)

https://blog.gopaddle.io/2021/04/01/strange-things-you-never-knew-about-kubernetes-configmaps-on-day-one/

[Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)


ConfigMaps and Secrets allow us to configure a Kubernetes application.

#### ConfigMap

A ConfigMap is an object that stores configuration data for applications as key-value pairs.

We can pass the ConfigMap data to containers at runtime.

A ConfigMap is an API object used to store non-confidential data in key-value pairs. Pods can consume ConfigMaps as environment variables, command-line arguments, or as configuration files in a volume.

A ConfigMap allows you to decouple environment-specific configuration from your container images, so that your applications are easily portable.

Caution: ConfigMap does not provide secrecy or encryption. If the data you want to store are confidential, use a Secret rather than a ConfigMap, or use additional (third party) tools to keep your data private.

Use a ConfigMap for setting configuration data separately from application code.

For example, imagine that you are developing an application that you can run on your own computer (for development) and in the cloud (to handle real traffic). You write the code to look in an environment variable named DATABASE_HOST. Locally, you set that variable to localhost. In the cloud, you set it to refer to a Kubernetes Service that exposes the database component to your cluster. This lets you fetch a container image running in the cloud and debug the exact same code locally if needed.

A ConfigMap is not designed to hold large chunks of data. The data stored in a ConfigMap cannot exceed 1 MiB. If you need to store settings that are larger than this limit, you may want to consider mounting a volume or use a separate database or file service.

A ConfigMap is an API object that lets you store configuration for other objects to use. Unlike most Kubernetes objects that have a spec, a ConfigMap has data and binaryData fields. These fields accept key-value pairs as their values. Both the data field and the binaryData are optional. The data field is designed to contain UTF-8 strings while the binaryData field is designed to contain binary data as base64-encoded strings.

#### Secret

A Secret is similar to a ConfigMap except that it's designed to store sensitive data such as passwords or API tokens.

Optionally, Secret data may be encrypted.

There are two ways to pass data in a ConfigMap or Secret to containers.

Volume mounts or environment variables.

1. volume mount
- configured in the container spec in the volumeMount and the Pod volumes spec.
- the data will appear in the container's file system at runtime.  Each top-level key in the config data becomes the name of a file that we can access like a file on the file system.

2. environment variables
- configured in the 'env' field of the container spec.
- the data will appear as environment variables, which are visible to the container at runtime.
- you can specify specific keys and variable names for each piece of data.

#### Create a ConfigMap and pass the ConfigMap data to a container.

In the control plan node creating a ConfigMap, my-configmap.yml,
```
vim my-configmap.yml

apiVersion: v1
kind: ConfigMap
metadata:
  name: my-configmap
data:
  message: Hello, World!
  app.cfg: |
    # A configuration file!
    key1=value1
    key2=value2
```
ConfigMap is a Kubernetes object of kind 'ConfigMap', apiVersion: v1.

The 'data:' field contains the data that the ConfigMap is going to be storing in the form of key-value pairs.  The data can be whatever you want.

Under the 'data' field we will have a key, 'message', referring to a value 'Hello, World!'.

We can also provide multi-line data using a pipe (|).  We will store a few indented lines under 'app.cfg:'.

ConfigMaps can be used to manage individual pieces of data in a key-value format or the data could be an entire configuration file.

Save, exit and apply.  Once created you can use the ConfigMap's data inside a Pod.

In the control node create a Pod with a file named cm-pod.yml.
```
vi cm-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: cm-pod
spec:
  restartPolicy: Never
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'echo $MESSAGE; cat /config/app.cfg']
    env:
    - name: MESSAGE
      valueFrom:
        configMapKeyRef:
          name: my-configmap
          key: message
    volumeMounts:
    - name: config
      mountPath: /config
      readOnly: true
  volumes:
  - name: config
    configMap:
      name: my-configmap
      items:
      - key: app.cfg
        path: app.cfg

kubectl apply -f cm-pod.yml
```
The spec is for a busybox container that will run once to completion.  The container restartPolicy is Never.

The spec of a Pod has a restartPolicy field with possible values Always, OnFailure, and Never. The default value is Always.

The restartPolicy applies to all containers in the Pod. restartPolicy only refers to restarts of the containers by the kubelet on the same node. After containers in a Pod exit, the kubelet restarts them with an exponential back-off delay (10s, 20s, 40s, …), that is capped at five minutes. Once a container has executed for 10 minutes without any problems, the kubelet resets the restart backoff timer for that container.

The container spec has a command to echo the environment variable $MESSAGE and then cat the file '/config/app.cfg'.

This demonstrates how to load ConfigMap data as both an environment variable or as a volume mount through a file accessible on the disk.

To load ConfigMap data as an environment variable we add an 'env' key to the container spec.  You can specify one or more environment variables under 'env:'.

In the container spec under 'env:' we create an environmental variable, MESSAGE.

```
...
spec:
  restartPolicy: Never
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'echo $MESSAGE; cat /config/app.cfg']
    env:
    - name: MESSAGE
      valueFrom:
        configMapKeyRef:
          name: my-configmap
          key: message
    volumeMounts:
    - name: config
      mountPath: /config
      readOnly: true
```
The environmental variable named MESSAGE has a 'valueFrom:' field.  The 'valueFrom:' field has a ConfigMapKeyRef telling Kubernetes to reference a ConfigMap key for the value of environment variable.

We specify the name of the ConfigMap, 'my-configmap' and a specific key in the ConfigMap.  

The ConfigMap we created has a key, 'message', with a value of 'Hello World!'

We load the 'message' key into the MESSAGE environment variable.

We expect to see 'Hello World!' in the container log once the cm-pod container runs.

We will use a volume mount to provide some ConfigMap data.

Set up a ConfigMap-type volume named 'config' to read data from my-configmap.

The items section under 'configMap:' is optional.

If you don't specify 'items:', every top-level key in that ConfigMap is going to become a file
mounted to the container.

If you specify 'items' in the volumes configMap, you can mount the keys you want.

If your ConfigMap contains a lot of data and you only want a subset of that data to mount as a file you can use the items: field to limit the data you're mounting with the ConfigMap-type volume.

We mount the 'app.cfg' key. The path, 'app.cfg', is going to determine the filename that will be visible to the container.

Next we mount the volume to the container using the volumeMounts section of the container spec.

set it to readOnly.

mount path /config.

at '/config/app.cfg',
(which is what we're reading in the command) we should see the contents of that ConfigMap data,
and the contents should appear in the container log.
save and exit the 'cm-pod.yml' file, create the Pod.

kubectl apply -f cm-pod.yml.

In the logs we expect to see "Hello, World!" as well as the contents of the configuration file being read from the volume mount.

```
k logs cm-pod

Hello World!
# A configuration file!
key1=value1
key2=value2
cloud_user@control:~$
```

We have created a ConfigMap and passed the ConfigMap data to a container.

#### Create a Secret and pass the Secret data to a container.

Now let's look at the same process with a Secret,

We need to base64-encode the sensitive data.

We will echo string Secret Stuff! with an exclamation point and then pipe that to the base64 command.

that's a base64-encoded string for Secret Stuff! string here.
I'm also going to do the same thing for line, Secret stuff in a file!

Use the base64-encoded strings to set up the Secret.

Get base64-encoded strings for some sensitive data.
```
echo Secret Stuff! | base64
U2VjcmV0IFN0dWZmIQo=

echo Secret stuff in a file! | base64
U2VjcmV0IFN0dWZmIGluIGEgZmlsZSEK
```
Create a Secret using the base64-encoded data.  Create my-secret.yml with kind Secret.
```
vi my-secret.yml

apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
data:
  sensitive.data: U2VjcmV0IFN0dWZmIQo=
  passwords.txt: U2VjcmV0IHN0dWZmIGluIGEgZmlsZSEK

kubectl apply -f my-secret.yml
```

There are multiple different Secret types for additional functionality with username, passwords or API tokens.
The Opaque type means generic, freeform Secret data. We can put anything we want in the data.

As with a ConfigMap, a Secret has a data section.
We create 2 keys, sensitive.data and passwords.txt.
Provide the values as the base64-encoded strings we created.

Save, exit, apply my-secret.yml.

Create a Pod with a container to consume that Secret data.

vim secret-pod.yml

The container command will echo an environment variable called $SENSITIVE_STUFF and cat a file named config/passwords.txt.

```
vi secret-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: secret-pod
spec:
  restartPolicy: Never
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'echo $SENSITIVE_STUFF; cat /config/passwords.txt']
    env:
    - name: SENSITIVE_STUFF
      valueFrom:
        secretKeyRef:
          name: my-secret
          key: sensitive.data
    volumeMounts:
    - name: secret-config
      mountPath: /config
      readOnly: true
  volumes:
  - name: secret-config
    secret:
      secretName: my-secret
      items:
      - key: passwords.txt
        path: passwords.txt

kubectl apply -f secret-pod.yml
```

The container will pull the $SENSITIVE_STUFF environment variable from the Secret and mount the config/passwords.txt file from the Secret as well.

The valueFrom: field has a secretKeyRef: instead of a configMapKeyRef:.  secretKeyRef: has the name of the Secret, 'my-secret', and the name of the key (1 of those 2 keys from the my-secret Secret).

key: has a value of 'sensitive.data'.
```
    env:
    - name: SENSITIVE_STUFF
      valueFrom:
        secretKeyRef:
          name: my-secret
          key: sensitive.data
```

Create the volume with 'secret:'.  'secret:' has 'secretName:' with a value of 'my-secret'.  'secret:' also has items.
```
  volumes:
  - name: secret-config
    secret:
      secretName: my-secret
      items:
      - key: passwords.txt
        path: passwords.txt
```

Under 'volumes', as with ConfigMaps the 'items' section is optional.
If I omit 'items', every top-level key in the Secret will be mounted as a file,

We use 'items' to select passwords.txt.

In the volume mount we mount the volume named 'secret-config' to the 'secret-pod' container at /config.

```
    volumeMounts:
    - name: secret-config
      mountPath: /config
      readOnly: true
```

when we read /config/passwords.text we're getting that data that ultimately comes from the Secret.

We expect to see the environment variable value and the contents of that file in the container logs.

Save, exit, apply.

check the logs for the secret-pod, to see, "Secret Stuff!" and "Secret stuff in a file!"

We created a ConfigMap and a Secret and consumed the data from the ConfigMap and the Secret inside of containers using  both environment variables and volume mounts.


Lesson Reference

Log in to the control plane node.

Create a ConfigMap.
```
vi my-configmap.yml

apiVersion: v1
kind: ConfigMap
metadata:
  name: my-configmap
data:
  message: Hello, World!
  app.cfg: |
    # A configuration file!
    key1=value1
    key2=value2

kubectl apply -f my-configmap.yml
```
Create a Pod that uses the ConfigMap.
```
vi cm-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: cm-pod
spec:
  restartPolicy: Never
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'echo $MESSAGE; cat /config/app.cfg']
    env:
    - name: MESSAGE
      valueFrom:
        configMapKeyRef:
          name: my-configmap
          key: message
    volumeMounts:
    - name: config
      mountPath: /config
      readOnly: true
  volumes:
  - name: config
    configMap:
      name: my-configmap
      items:
      - key: app.cfg
        path: app.cfg

kubectl apply -f cm-pod.yml
```
Check the Pod logs. You should see the message followed by the contents of the config file, both from the ConfigMap.
```
kubectl logs cm-pod

Hello World!
# A configuration file!
key1=value1
key2=value2
cloud_user@control:~$

```
Get base64-encoded strings for some sensitive data.
```
echo Secret Stuff! | base64

U2VjcmV0IFN0dWZmIQo=

echo Secret stuff in a file! | base64

U2VjcmV0IFN0dWZmIGluIGEgZmlsZSEK

```
Create a Secret using the base64-encoded data.
```
vi my-secret.yml

apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
data:
  sensitive.data: U2VjcmV0IFN0dWZmIQo=
  passwords.txt: U2VjcmV0IHN0dWZmIGluIGEgZmlsZSEK

kubectl apply -f my-secret.yml
```
Create a Pod that uses the ConfigMap.
```
vi secret-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: secret-pod
spec:
  restartPolicy: Never
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'echo $SENSITIVE_STUFF; cat /config/passwords.txt']
    env:
    - name: SENSITIVE_STUFF
      valueFrom:
        secretKeyRef:
          name: my-secret
          key: sensitive.data
    volumeMounts:
    - name: secret-config
      mountPath: /config
      readOnly: true
  volumes:
  - name: secret-config
    secret:
      secretName: my-secret
      items:
      - key: passwords.txt
        path: passwords.txt

kubectl apply -f secret-pod.yml
```

Check the Pod logs. You should see the data from the Secret, both the environment variable and the file.
```
kubectl logs secret-pod

Secret Stuff!
Secret stuff in a file!

```
Exam Tips

- A ConfigMap stores configuration data that can be passed to containers.
- A Secret is designed to store sensitive configuration data such as passwords or API keys.
- Data from both ConfigMaps and Secrets can be passed to containers using either a volume mount or environment variables.


### 5.9 Lab: Configuring Applications in Kubernetes

[Lesson Reference]()

Welcome to HiveCorp, a software design company that is totally not run by bees!

We have an application that needs some external configuration. It has a daily message that needs to be configured as well as a secret key that will need to be stored more securely.

Create a ConfigMap and Secret to store the necessary configuration data. Then, modify a Deployment to pass the configuration data from the ConfigMap and Secret to the containers as requested.

Learning Objectives

- Create a ConfigMap
- Create a Secret
- Modify the Deployment To Use the ConfigMap and Secret Data

Kubernetes offers tools to help you manage application configuration within your cluster. lab will give you the opportunity to get hands-on with the process of configuring your Kubernetes apps.


Solution

Log in to the server using the credentials provided:

ssh cloud_user@<PUBLIC_IP_ADDRESS>

#### Create a ConfigMap
```
vi honey-config.yml

apiVersion: v1
kind: ConfigMap
metadata:
  name: honey-config
  namespace: hive
data:
  honey.cfg: |
    There is always money in the honey stand!

kubectl apply -f honey-config.yml
```
#### Create a Secret

Get a base64-encoded string for the sensitive data:
```
echo secretToken! | base64

c2VjcmV0VG9rZW4hCg==
```
Copy the full string as it will be used next.

Create a YAML file for the Secret.  Create the manifest and use the base64-encoded string you copied before for the hiveToken value:
```
vi hive-sec.yml

apiVersion: v1
kind: Secret
metadata:
  name: hive-sec
  namespace: hive
type: Opaque
data:
  hiveToken: <BASE-64-ENCODED-STRING>

kubectl apply -f hive-sec.yml
```

Modify the Deployment To Use the ConfigMap and Secret Data

The deployment has container spec command as follows:
```
   Command:
      sh
      -c
      echo daily message: $(cat /config/honey.cfg); echo Authenticating with hiveToken $TOKEN; while true; do sleep 5; done

```
Edit the Deployment:
```
kubectl edit deployment hive-mgr -n hive
```
Supply the Secret data to the container using an environment variable. Scroll down to the bottom of the container spec, and add the following to the bottom of the spec (below the terminationMessagePolicy line):

        env:
        - name: TOKEN
          valueFrom:
            secretKeyRef:
              name: hive-sec
              key: hiveToken

On the next line, provide the ConfigMap data as a mounted volume:

        volumeMounts:
        - name: config
          mountPath: /config
          readOnly: true
      volumes:
      - name: config
        configMap:
          name: honey-config
          items:
          - key: honey.cfg
            path: honey.cfg

Type ESC followed by :wq to save your changes.

Locate the Deployment's Pods:
```
kubectl get pods -n hive
```
You should see the old Pods have a status of Terminating, and the new ones are now Running.

Copy the NAME for one of the Running Pods, and use it to check the Pod log.  The logs should display the data from both the ConfigMap and the Secret. It should look something like:

```
kubectl logs -n hive <Pod NAME>

daily message: There is always money in the honey stand!
Authenticating with hiveToken secretToken!
```


### 5.10 Configuring SecurityContext for Containers

[Lesson Reference](PDF/S05L08_Configuring_SecurityContext_for_Containers.pdf)

Documentation

[Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)

A security context defines privilege and access control settings for a Pod or Container.

SecurityContext is part of the Pod and container specification.

Examples of those advanced security-related settings that you can control with SecurityContext.

- Set a custom user ID and or group ID; customize the UID or the GID that is used by the container process.
  - use SecurityContext to confine a user to a more restricted set of permissions than the default, for example.
- enable/disable privilege escalation mode for the container process.  Privilege escalation allows a process to request more permissions than the parent process.
  - Privilege escalation can be enabled or disabled on a container-by-container basis using SecurityContext settings.
- make a container's root filesystem read-only.
  - prevent someone who gained control of or manipulated the container process from changing any of the code for the actual container application itself.

Create a Pod in the control plane node:
```
vi securitycontext-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: securitycontext-pod
spec:
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'while true; do echo Running...; sleep 5; done']
    securityContext:
      runAsUser: 3000
      runAsGroup: 4000
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true

kubectl apply -f securitycontext-pod.yml
```
The 'securitycontext-pod' runs busybox image that echoes a message in a loop.
In the container spec we add securityContext section.
there's a variety of different fields
that I can set here in the SecurityContext
to do a lot of different things.
let's start with runAsUser.
That allows me to set a custom user ID.
Or I could do runAsGroup,
which allows me to set a custom group ID or GID.
Or I can even disable privilege escalation
with allowPrivilegeEscalation: false.
Or I could make the root filesystem read-only
with readOnlyRootFilesystem,
and set that to true.
Now, all of these settings are optional.
I could omit any of these if I wanted to.
there's a variety of additional settings
that I can provide under SecurityContext as well.
But these are those examples
that we talked about earlier of some of the things
that we can do with SecurityContext.
Now you can specify SecurityContext
at the Pod level as well.
the fields that are available at the Pod level
are a little bit different than the ones
that are available at the container level.
We're not going to go into too much detail about that.
All you really need to be aware of
is if you're setting things at the Pod level,
those settings will apply
to all of the containers in that Pod,
for example, in the case of a multi-container Pod.
But for right, now we're going to set
the SecurityContext here in the container spec.
I'll save and exit that file.
I'll create the Pod with kubectl apply.
now the Pod is created,
and I want to run some commands inside the container
just to kind of see
those SecurityContext settings inaction.
I'm going to do kubectl exec,
that allows me to execute a command inside the container.
I'm going to do kubectl exec on that SecurityContext Pod,
then 2 dashes, and after the 2 dashes,
I can enter the command
that I'm going to run inside the container.
I'm going to run the id command.
That's going to give me the user ID
and group ID of the current user.
of course, these are the values that we set
in the SecurityContext, 3000 and 4000.
Let's try something a little more complex.
I'm going to do sh -c and put some double quotes here,
and I'll echo a string test
and redirect that to test.text.
, I'm going to write to a file inside
the container, and that's going to fail.
there's  2 things protecting us
from being able to write to that file.
First off, we set the read-only root filesystem,
and that's what we're getting the error message from here
because the file system is read-only.
We can't write to a test.text file,
but also, user ID 3000 doesn't really have permission
to write to that file either.
what we've done here
is used the SecurityContext settings to limit
what can go on inside the container.
as you can imagine in a lot of scenarios,
that's very desirable from a security standpoint.
those SecurityContext settings
can be very powerful and very useful.
Now that we've seen what SecurityContext looks like
within the cluster, let's go through a few quick exam tips.
First, a container's SecurityContext allows you
to control advanced security-related settings
for the container.
Second, you can set the container's user ID, or UID,
and group ID, or GID, with securityContext.runAsUser
and securityContext.runAsGroup.
You can enable or disable privilege escalation
with securityContext.allowPrivilegeEscalation,
and you can make the container root file system read-only
with securityContext.readOnlyRootFilesystem.




Lesson Reference

Log in to the control plane node.

Create a Pod that uses some custom securityContext settings.

These settings will:
- Run the container as user ID 3000.
- Run the container with group ID 4000.
- Disable privilege escalation mode on the container process.
```
vi securitycontext-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: securitycontext-pod
spec:
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'while true; do echo Running...; sleep 5; done']
    securityContext:
      runAsUser: 3000
      runAsGroup: 4000
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true

kubectl apply -f securitycontext-pod.yml
```
Check the user and group ID used by the container.
```
kubectl exec securitycontext-pod -- id

uid=3000 gid=4000
```
Try to write to a file inside the container.
```
kubectl exec securitycontext-pod -- sh -c "echo test > test.txt"

k exec -it securitycontext-pod -- sh
```
Your attempt to write to a file inside the container will fail because the user ID of 3000 does not have file write permissions.


Exam Tips

- A container's SecurityContext allows you to control advanced security-related settings for the container.
- Set the container's user ID (UID) and group ID (GID) with securitContext.runAsUser and securityContext.runAsGroup.
- Enable or disable privilege escalation with securityContext.allowPrivilegeEscalation.
- Make the container root filesystem read-only with securityContext.readOnlyRootFilesystem .



### 5.11 Quiz: Application Environment, Configuration, and Security

[Lesson Reference]()

What Kubernetes feature allows you to manage authorization for the Kubernetes API?

- Worker nodes
- Role-Based Access Control (RBAC)
- The Kubernetes Permissions API
- Service Accounts

Using a CustomResourceDefinition, you have created a custom Kubernetes object type called buzz.  What command could you use to get a list of buzz objects?

- kubectl get customresourcedefinition buzz
- Kubernetes does not support listing of buzz objects
- kubectl get buzz
- kubectl get crd buzz

How do you configure a Pod to use a specific ServiceAccount?

- Add the Pod name to the ServiceAccount's spec.
- Create a RoleBinding that references the Pod and the ServiceAccount.
- Set the serviceAccountName in the Pod spec.
- Create a ServiceAccountBinding that references the Pod and the ServiceAccount.

What part of the container spec controls OS-level security settings, such as privileged mode, and which user executes the container process?

- Role
- allowPrivilegeEscalation
- securityConfig
- securityContext

In order to strengthen your security, you want to run a container process in Kubernetes as a user with the user ID 7171. What part of the container securityContext can you use to accomplish this?

- securityContext.runAsUser
- securityContext.allowPrivilegeEscalation
- securityContext.userId
- securityContext.nonRootUser

You have received a request to enable the NamespaceAutoProvision admission controller. How can you accomplish this?

- Set the --NamespaceAutoProvision flag to true for the Kubernetes API server.
- Set the --NamespaceAutoProvision flag to true when initializing the cluster with kubeadm.
- Add it to the --enable-admission-plugins flag when running the Kubernetes API server.
- Use the kubectl admission-plugin enable command.

You have a process within a Pod that needs to access the Kubernetes API. Which of the following is the best way to configure that process to authenticate with the API?

- Service Account
- None. Processes within Pods cannot access the Kubernetes API.
- User Account
- None. Processes within Pods do not need to authenticate with the Kubernetes API.

What can you use to specify a limit for memory usage within a Namespace.

- There is no way to specify a memory usage limit in Kubernetes.
- Resource request
- ResourceQuota
- Resource limit

Your application requires a configurable database password to be passed in via an environment variable. Which of the following is the best way to store password data in Kubernetes so that it can be passed to the application's containers?

- Secret
- ConfigMap
- Environment variable
- Volume

You have a Role that provides permission to view Pods, and you have a ServiceAccount that is being used by a Pod. How can you provide the Role's permissions to the ServiceAccount and the Pod using it?

- List the Role in the ServiceAccount's spec.
- Connect the Role and ServiceAccount with a RoleBinding.
- Use a PodRoleBinding to connect the Role and the Pod.
- Use the kubectl add permissions command.


### 5.12 Application Environment, Configuration, and Security Summary

the Kubernetes API deprecation policy deals with how changes to the Kubernetes API are managed.

probes and health checks allow us to automate health status monitoring for the containers.

monitoring in Kubernetes to get insight into container status and performance.

container logging accessing log output from the Kubernetes containers.

debugging - locating relevant data to help you identify problems with your Kubernetes applications.

Exam Tips

- API deprecation is the process of announcing changes to an API early giving users time to update their code and/or tools.
- Kubernetes removes support for deprecated APIs that are in general availability, only after 12 months or 3 Kubernetes releases, whichever is a longer time period.
- liveness probes check if a container is healthy so that it can be restarted if it is not.
- readiness probes check whether a container is fully started up and ready to be used.
- probes can run a command inside the container that can make an HTTP request or attempt a TCP socket connection, in order to determine the container status.
- the Kubernetes Metrics API provides metric data about container performance.
- view Pod metrics using the "kubectl top Pod" command.
- standard and error output for containers is stored automatically in the container log.
- View the container log using "kubectl logs.".  For a multi-container Pod use the -c flag to specify which container's logs you want to view.
- debugging
  - use "kubectl get Pods" to check the status of all Pods in a Namespace and use the "-- all-namespaces" flag if you don't know what Namespace to look in.
  - use "kubectl describe" to get detailed information about Kubernetes objects.
  - use "kubectl logs" to retrieve container log data.
  - check the cluster-level logs,


## CHAPTER 6 Services and Networking

### 6.1 Services and Networking Intro

NetworkPolicies - Kubernetes objects that allow controlling and limiting communication within the Kubernetes virtual network.

Services - manage microservices within the cluster.

Ingress - provide access to applications from outside the cluster.


### 6.2 Controlling Network Access with NetworkPolicies - Part 1

[Lesson Reference](PDF/S06L02_Controlling_Network_Access_with_NetworkPolicies_-_Part_1.pdf)

[NetworkPolicies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

[Cluster Networking](https://kubernetes.io/docs/concepts/cluster-administration/networking/)

The Kubernetes cluster uses a virtual network which allows Pods to communicate with one another seamlessly even if they are on different Kubernetes nodes.

We have 3 nodes represented here and 2 pods that are running on separate nodes.  The Kubernetes network consists of a virtual cluster network that spans across all the nodes allowing those 2 Pods to communicate with each other.

<img src="images/networking1.png"
     alt="A virtual cluster network spans all the nodes so Pods can communicate with each other"
     style="float: right; margin-right: 10px; margin-bottom: 10px;"
     width="70%" />

Pods don't need to worry about whether another Pod is on the same node or a different node when they're communicating with that other Pod.  Pods don't need to be aware of the concept of nodes at all when it comes to Kubernetes networking.

The virtual network allows Pods to communicate with each other as though they were on the same network.

NetworkPolicy is a Kubernetes object that allows you to restrict network traffic between Pods within the cluster network.

NetworkPolicies give you fine-grained control over what communication is or is not allowed within a cluster network.

You can use NetworkPolicies to block unnecessary or unexpected network traffic and make your applications more secure.

A **non-isolated Pod** is any Pod that is not selected by any NetworkPolicies.

NetworkPolicies use a selector to select Pods.

If a Pod is not selected by any NetworkPolicy that Pod is considered non-isolated.

A non-isolated Pod is open to all incoming and outgoing network traffic NetworkPolicies don't apply.  If no NetworkPolicies select a Pod, then it's open, and we're not restricting any traffic to or from that Pod.

An isolated Pod is selected by at least one NetworkPolicy.

An isolated Pod is only open to traffic that is explicitly allowed by the NetworkPolicy that selects the Pod.

When a Pod is not selected by any NetworkPolicies it's non-isolated, all traffic is allowed.

As soon as at least one NetworkPolicy selects that Pod then the Pod becomes isolated, and we need a NetworkPolicy to allow that traffic; otherwise, it will be blocked.

Create some Namespaces: np-test-a, np-test-b in the control plane.
```
kubectl create namespace np-test-a
kubectl create namespace np-test-b
```
'np' stands for NetworkPolicy.

NetworkPolicies interact with Namespaces and Pods using label selectors.  We must, therefore, attach labels to the relevant Namespaces.

The 'np-test-a' is to be labeled 'team=ateam'.  The 'np-test-b' is to be labeled 'team=bteam'.

Attach labels to these Namespaces.
```
kubectl label namespace np-test-a team=ateam
kubectl label namespace np-test-b team=bteam
```
Each of the two new Namespaces now has a unique label.

Create a server pod to receive network communication.

Create a yml manifest file for a server Pod in the np-test-a Namespace.  Give the server pod the label 'app: np-test-server'.
```
vi server-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: server-pod
  namespace: np-test-a
  labels:
    app: np-test-server
spec:
  containers:
  - name: nginx
    image: nginx:stable
    ports:
    - containerPort: 80

kubectl apply -f server-pod.yml
```
Obtain the server pod's IP address with
```
kubectl get pods server-pod -n np-test-a -o wide

NAME         READY   STATUS    RESTARTS   AGE     IP                NODE      NOMINATED NODE   READINESS GATES
server-pod   1/1     Running   0          2m34s   192.168.235.183   worker1   <none>           <none>
```
We use the server pod's IP address to communicate with the Pod from another Pod.

Now you could enable communication between Pods using Services, but for demonstration, we're going to use the IP address of the Pod directly.

Create a client pod in the 'np-test-b' Namespace to communicate with the server Pod.

```
vi client-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: client-pod
  namespace: np-test-b
  labels:
    app: np-test-client
spec:
  containers:
  - name: busybox
    image: radial/busyboxplus:curl
    command: ['sh', '-c', 'while true; do curl -m 2 <server Pod IP address>; sleep 5; done']

kubectl apply -f client-pod.yml
```
The 'client-pod' will make a curl request to that server Pod on a five-second loop using the server pod's IP address.

Give the client Pod a label: 'app: np-test-client'.

We now have two Pods in two separate Namespaces.

Check the logs of the client Pod.

kubectl logs client-pod -n np-test-b

We expect to see the nginx Welcome page in the client pod logs confirming that the client Pod is successfully communicating with the server Pod.

When there are no NetworkPolicies selecting any of those Pods all traffic is allowed.  Currently both Pods are non-isolated  That is why that communication is working.

Both of those Pods are also open to all communication within the Kubernetes cluster network.

We may want to lock down that communication and make sure that these Pods can communicate with each other, but they're not necessarily open to everything else.

We can use NetworkPolicies in order to do that.

Create a default deny ingress NetworkPolicy.  NetworkPolicy will block incoming traffic for all Pods, including the 'server-pod', in the 'np-test-a' Namespace by default.
```
vi np-test-a-default-deny-ingress.yml

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np-test-a-default-deny-ingress
  namespace: np-test-a
spec:
  podSelector: {}
  policyTypes:
  - Ingress

kubectl apply -f np-test-a-default-deny-ingress.yml
```
To turn off all incoming traffic under policyTypes we list Ingress.

You can also list Egress here if you want, which refers to outgoing traffic.
If you list both Ingress and Egress, the NetworkPolicy will apply to both.

For now, I'm going to only apply policy to incoming traffic, i.e., Ingress.

An empty podSelector is two empty braces: {}.  An empty podSelector causes the NetworkPolicy select all Pods in the Namespace.  All Pods in the np-test-a Namespace will be selected by policy, with the result being that those Pods will become isolated.

Check the logs for the client Pod.  The last few attempts to connect resulted in an error message.  Network communication is no longer working.  The connection is now timing out because we've created a default deny NetworkPolicy that is blocking the traffic.


Lesson Reference

Log in to the control plane node.
Create a setup with a Pod that communicates with another Pod via the network.
Create two Namespaces.
```
kubectl create namespace np-test-a
kubectl create namespace np-test-b
```
Attach labels to these Namespaces.
```
kubectl label namespace np-test-a team=ateam
kubectl label namespace np-test-b team=bteam
```
Create a server Pod.
```
vi server-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: server-pod
  namespace: np-test-a
  labels:
    app: np-test-server
spec:
  containers:
  - name: nginx
    image: nginx:stable
    ports:
    - containerPort: 80

kubectl apply -f server-pod.yml
```
Get the cluster IP address of the server Pod. You may need to wait a few moments for the Pod to be Running for the IP address to appear.
```
kubectl get pods server-pod -n np-test-a -o wide

NAME         READY   STATUS    RESTARTS   AGE   IP               NODE      NOMINATED NODE   READINESS GATES
server-pod   1/1     Running   0          41s   192.168.189.84   worker2   <none>           <none>

```
Create a client Pod.  In the command, provide the cluster IP address of the server Pod.  If the control node shuts down and is restarted, the server pod's IP address might have changed.
```
vi client-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: client-pod
  namespace: np-test-b
  labels:
    app: np-test-client
spec:
  containers:
  - name: busybox
    image: radial/busyboxplus:curl
    command: ['sh', '-c', 'while true; do curl -m 2 <server Pod IP address>; sleep 5; done']

kubectl apply -f client-pod.yml
```
Check the client Pod's log. You should see that it is able to successfully reach the server Pod.
```
kubectl logs client-pod -n np-test-b

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...
100   615  100   615    0     0   233k      0 --:--:-- --:--:-- --:--:--  300k
```
Create a default deny ingress NetworkPolicy.  NetworkPolicy will block incoming traffic for all Pods, including the 'server-pod', in the 'np-test-a' Namespace by default.
```
vi np-test-a-default-deny-ingress.yml

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np-test-a-default-deny-ingress
  namespace: np-test-a
spec:
  podSelector: {}
  policyTypes:
  - Ingress

kubectl apply -f np-test-a-default-deny-ingress.yml
```

Check the client Pod's log again. The traffic should now be blocked, resulting in error messages in the log.
```
kubectl logs client-pod -n np-test-b

curl: (28) Connection timed out after 2001 milliseconds
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:02 --:--:--     0

```
Exam Tips
- If a Pod is not selected by any NetworkPolicies, the Pod is non-isolated, and all traffic is allowed.
- If a Pod is selected by any NetworkPolicy, traffic will be blocked unless it is allowed by at least one NetworkPolicy that selects the Pod.
- If you combine a namespaceSelector and a podSelector within the same rule, the traffic must meet both the Pod- and Namespace-related conditions in order to be allowed.


### 6.3 Controlling Network Access with NetworkPolicies - Part 2

[Lesson Reference](PDF/S06L03_Controlling_Network_Access_with_NetworkPolicies_-_Part_2.pdf)

Documentation

[NetworkPolicies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

[Cluster Networking](https://kubernetes.io/docs/concepts/cluster-administration/networking/)

We blocked all incoming traffic to the 'server-pod' Pod in Namespace 'np-test-a' by creating NetworkPolicy 'np-test-a-default-deny-ingress' (in the previous lesson).
```
k get networkpolicy --all-namespaces

NAMESPACE   NAME                             POD-SELECTOR   AGE
nptesta     np-test-a-default-deny-ingress   <none>         7m35s
```
Let's restore communication with the server from the client Pod.

Create a new NetworkPolicy to
- allow communication from that client Pod.
- disallow communication from other sources

Create a NetworkPolicy, 'np-test-client-allow' in Namespace 'np-test-a', to allow traffic coming from the client Pod, 'np-test-client' in Namespace 'np-test-b' to reach 'np-test-server' in Namespace 'np-test-a'.
```
vi np-test-client-allow.yml

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np-test-client-allow
  namespace: np-test-a
spec:
  podSelector:
    matchLabels:
      app: np-test-server
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          team: bteam
      podSelector:
        matchLabels:
          app: np-test-client
    ports:
    - protocol: TCP
      port: 80

kubectl apply -f np-test-client-allow.yml
```
Note: apiVersion; ports vs. port; namespaceSelector and podSelector are at the same level.

The NetworkPolicy provides some rules that are going to specifically allow the traffic that we want to allow.

The 'np-test-client-allow' NetworkPolicy podSelector is 'matchLabels: > app: np-test-client'; the podSelector is non-empty.  In contrast, the 'np-test-a-default-deny-ingress' NetworkPolicy had an empty podSelector (spec: > podSelector: {}).

'np-test-client-allow' is an Ingress type policy, the policy applies to incoming traffic.

We list some Ingress rules that define what type of traffic is allowed by policy  Any traffic that meets the criteria specified by any of these rules will be allowed.

We have a 'from:' rule which pertains to the source of network traffic,
The 'from:' rule has a namespaceSelector and a podSelector.  We use labels to select Namespaces and Pods from which traffic will be accepted.

For traffic to be allowed, the source has to be a Pod with the label 'app: np-test-client' in a Namespace with the label 'team: bteam'.  

If traffic is coming from a Pod that has the selected label but not the selected Namespace, the traffic will be blocked.  The client pod has to be both in the right Namespace and have the right Pod label.

We also specify the allowed ports and protocols for the traffic; nginx is listening on port 80.

Save, exit, apply.

Check logs for the client Pod.

In the logs we expect to see the client Pod successfully communicating with the server Pod.

#### Egress Policies

Create a default deny Egress policy for the np-test-b Namespace that contains the client Pod.  Traffic is leaving the client Pod for the server Pod.  A default deny Egress policy is similar to a default deny Ingress policy.
```
vi np-test-b-default-deny-egress.yml

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np-test-b-default-deny-egress
  namespace: np-test-b
spec:
  podSelector: {}
  policyTypes:
  - Egress

kubectl apply -f np-test-b-default-deny-egress.yml
```
The policy type is Egress and it applies to all pods in the np-test-b Namespace.

This default deny NetworkPolicy will deny all outgoing traffic from Pods in the np-test-b Namespace.

Now the client Pod logs should show failure, connection timeouts again.

Now we will create a policy in the client Pod's Namespace, np-test-b, to allow that outgoing traffic from the client Pod.
```
vi np-test-client-allow-egress.yml

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np-test-client-allow-egress
  namespace: np-test-b
spec:
  podSelector:
    matchLabels:
      app: np-test-client
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          team: ateam
    ports:
    - protocol: TCP
      port: 80

kubectl apply -f np-test-client-allow-egress.yml
```
The Egress rule controls outgoing traffic.  We select the np-test-a Namespace by matching its label, 'team: ateam'.  This rule does not have a podSelector, just a namespaceSelector.  

The client Pod, therefore, will be able to reach any Pods in the np-test-a Namespace since that Namespace has the specified 'team: ateam' label.

If we had multiple server Pods in the np-test-a Namespace, the client Pod would be able to reach any of them using TCP on port 80.

With the creation of np-test-client-allow-egress, the logs should now indicate
that the client Pod and successfully communicate with the server Pod.


Lesson Reference

Log in to the control plane node.

#### Create a NetworkPolicy to allow traffic coming from the client Pod.
```
vi np-test-client-allow.yml

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np-test-client-allow
  namespace: np-test-a
spec:
  podSelector:
    matchLabels:
      app: np-test-server
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          team: bteam
      podSelector:
        matchLabels:
          app: np-test-client
    ports:
    - protocol: TCP
      port: 80

kubectl apply -f np-test-client-allow.yml
```
Check the client Pod's log again. The traffic should be allowed now.
```
kubectl logs client-pod -n np-test-b
```
Let's create a NetworkPolicy to restrict outgoing traffic for the client Pod.

#### Create a default deny Egress policy for the np-test-b Namespace.
```
vi np-test-b-default-deny-egress.yml

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np-test-b-default-deny-egress
  namespace: np-test-b
spec:
  podSelector: {}
  policyTypes:
  - Egress

kubectl apply -f np-test-b-default-deny-egress.yml
```
Check the client Pod's log. Traffic should now be denied.
```
kubectl logs client-pod -n np-test-b
```
Create a Policy to allow the Egress traffic from the client Pod. time, we'll allow traffic to any Pod in the np-test-a Namespace.
```
vi np-test-client-allow-egress.yml

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np-test-client-allow-egress
  namespace: np-test-b
spec:
  podSelector:
    matchLabels:
      app: np-test-client
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          team: ateam
    ports:
    - protocol: TCP
      port: 80

kubectl apply -f np-test-client-allow-egress.yml
```
Check the client Pod's log. Traffic should be allowed once more.
```
kubectl logs client-pod -n np-test-b
```

Exam Tips

- Even if a NetworkPolicy allows outgoing traffic from the source Pod, NetworkPolicies could still block the same traffic when it is incoming to the destination Pod.  Consider both Egress and Ingress traffic.


### 6.4 Exploring Services

[Lesson Reference]()

[Services](https://kubernetes.io/docs/concepts/services-networking/service/)

A Service allows you to expose an application running across multiple Pods to the network.

When clients communicate with a Service the traffic will be routed to one of the underlying Pods.

A Service can be positioned in front of an application that consists of multiple replica Pods.

Client requests directed to the Service are routed to any of those underlying Pods.

There are multiple different types of Services.

A ClusterIP Service exposes the application within the cluster network where it can be accessed by other Pods.

In the following example, we will have an application with three replica Pods running in the network. There will also be a client Pod that makes a request to the application.

We build a Service with its own IP address that directs requests to the replica Pods.

The Service has its own IP address.
instead of communicating with the Pods directly the client can communicate with that Service and the traffic will be automatically routed to any of those underlying Pods.
a ClusterIP Service exposes the application to other Pods inside the cluster.

a NodePort Service exposes the application externally by listening on an external port, on each cluster node.

in case, the client is outside the cluster.
we build the Service on top of the replicas.
the Service listens on a port directly on all 3 of the hosts Kubernetes nodes.

if the client communicates with that port on the node, that traffic will be routed
to one of those underlying replica Pods.

ClusterIP Service exposes the application inside the cluster.

NodePort exposes the application outside the cluster.

create some Services in the cluster.
log in to the Kubernetes control plane node.

create an nginx server Pod called service-server-Pod.

I can also create multiple replicas of Pod using, for example, a Deployment.

But for now, I'll create a single Pod because in terms of how Services are going to interact with it's the same as if we had used a Deployment.

I have a label here called app: service-server.

On the nginx Pod, an nginx server listening on port 80.

I'm going to use label to create a Service that will route traffic to Pod.

that's why I've attached to label here, app: service-server.

I'll save and exit that file.
let's create the Pod with kubectl apply.
now, the Pod is created.
Now, let's create a ClusterIP Service
that will allow us to route traffic to that Pod.
I'm going to create YAML file
called clusterip-service.yml.
then I'll create
a simple YAML definition of a Service.
I'm creating a Service object there.
It's going to be called clusterip-service.
I have the type here under the spec,
which is ClusterIP again.
ClusterIP Services expose applications
within the cluster itself.
if I wanted to,
I could  leave out type line
because ClusterIP is the default.
If I don't specify the type,
Kubernetes will assume that I want a ClusterIP Service,
but I'm going to specify it
so it's clear what we're creating.
Then I have the selector.
The selector determines which Pods Service
is going to route traffic to.
I specify the label here that I attached
to that Pod app: service-server.
any Pods that have label
will have traffic directed to them by Service.
if I had multiple replica Pods, all with that same label,
the Service would direct traffic
to all of those different replica Pods.
then of course, I have the ports listed here.
The port field specifies the actual port
that the Service itself listens on.
clients communicating with the Service
will need to use port 8080.
targetPort specifies the port where the traffic
is going to be routed to the underlying Pods.
the nginx Pods are listening on port 80.
that's going to be the target port.
Now, the listening port for the Service
can be the same as the target port.
I could leave it as 80 for simplicity sake,
but I made it different to kind of demonstrate
the difference between these 2 fields.
just to be clear,
the target port is  the port
that the underlying Pods are listening on.
if we're communicating through the Service,
we'll use whatever port is specified
here by port field, which is 8080.
we'll save and exit that.
I'll create the Service with kubectl apply.
Now, I can interact with Services
just like any other Kubernetes object.
I can do kubectl get svc.
That's the short form.
Of course, I can do kubectl get service.
Both of these commands mean the same thing.
I can see a list of Services here.
There's the ClusterIP Service that I created.
I can get a specific Service,
kubectl get svc clusterip-service.
There is the ClusterIP Service.
Now, the cluster IP address,
that's the IP address that the client Pods
could use to communicate with the Service.
Now because of the way the networking
is set up in the cluster,
we can  use IP directly from the host.
Now, of course, won't work from outside the cluster,
but if I'm logged in to one of the hosts, which I am,
I'm logged in to the control plane node there,
I can do a curl on that Service IP address
in order to communicate with the Service.
Now, it's not working.
the reason for that
is because I haven't specified the port.
I am  using port 80
because that's the default since I didn't specify one.
that's not the port that the Service is listening on.
It's listening on port 8080.
if I specify port 8080, I get a response there.
that's to kind of demonstrate, once again,
the difference between the Service port
and the target port.
Now, the Service port that's listed in the output
from kubectl get as well.
because I'm communicating with the Service IP address,
I need to use the Service port.
But on the backend,
the Service is reaching out to the Pod on that target port,
which is port 80.
therefore,
I was able to successfully get the nginx Welcome page there.
I got a response from the nginx server
by communicating with the Service.
Next, let's create a NodePort Service.
once again,
NodePort Services are able to listen externally.
I'll create a YAML file here
called nodeport-service.yml.
this is pretty similar to the ClusterIP Service.
I'm creating a Service object called nodeport-service.
This time, the type is set to NodePort.
Using the same selector,
so I'm going to select that same underlying Pod.
I have added 1 more field here to the port listing.
I've added nodePort field.
the port is still 8080.
the target port is 80.
I've added a nodePort field.
Now, in a lot of situations,
you can  omit field
and a NodePort will be automatically assigned,
but I want to use a specific NodePort
because I'm using a cloud server here.
the port is specifically opened externally
through the firewall in the Cloud Playground platform.
to make sure that I could  reach
the Service from, for example, the browser at home,
I'm going to use a port that's  open
through that firewall,
and that is 30080.
I'm going to specify that nodePort: 30080.
I'll save and exit that file.
that 30080 port will listen directly
on all of the Kubernetes nodes
and allow access to that Service.
I'll create the NodePort Service.
if I want to test that Service,
I can curl localhost: 30080
because that port is listening directly on the host.
I don't need to use the Service IP address.
There is the response from the nginx web server.
now, I've opened up a web browser.
it's no fun to test
the externally available Service
from within the server itself.
I want to try to access the nginx server.
what I'm doing is I've entered the external IP address
of the Kubernetes control plane node here.
I could use either of the worker nodes as well,
but I'm using the external IP of the control plane node
followed by :30080 here in the web browser.
I'll go to that URL.
sure enough,
I get that "Welcome to nginx!" welcome page there.
that's the NodePort Service being exposed externally
by accessing that port on one of the Kubernetes nodes.
that was a quick look
at using some Services in the cluster.
Before we end video,
let's walk through a few quick exam tips.
First, Services allow you to expose an application
running in multiple Pods.
ClusterIP Services expose the Pods
to other applications within the cluster,
while NodePort Services expose the Pods externally
using a port that listens on every node in the cluster.
now
you have a basic idea of what it looks like
to use Services in Kubernetes.
That's all for lesson.
I'll see you in the next one.



Lesson Reference

Log in to the control plane node.

Create a server Pod.
```
vi service-server-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: service-server-pod
  labels:
    app: service-server
spec:
  containers:
  - name: nginx
    image: nginx:stable
    ports:
    - containerPort: 80

kubectl apply -f service-server-pod.yml
```
Create a ClusterIP Service for the Pod.
```
vim clusterip-service.yml

apiVersion: v1
kind: Service
metadata:
  name: clusterip-service
spec:
  type: ClusterIP
  selector:
    app: service-server
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 80

kubectl apply -f clusterip-service.yml
```
Get the cluster IP address for the Service.
```
kubectl get svc clusterip-service

k get service

NAME                TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
clusterip-service   ClusterIP   10.99.36.82   <none>        8080/TCP   29s
kubernetes          ClusterIP   10.96.0.1     <none>        443/TCP    10d
```
Use the cluster IP to test the Service.
```
curl <service cluster IP address>:8080

curl 10.99.36.82:8080
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...
<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
Now let's create a NodePort Service.
```
vi nodeport-service.yml

apiVersion: v1
kind: Service
metadata:
  name: nodeport-service
spec:
  type: NodePort
  selector:
    app: service-server
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 80
    nodePort: 30080

kubectl apply -f nodeport-service.yml
```
Test the NodePort Service. The external node port listens directly on the host, so we can access it using localhost .

curl localhost:30080

You can also use the public IP address of any of your Kubernetes nodes to access the service at http://<Node Public IP address>:30080 .

```
curl 35.93.153.53:30080
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
```

Exam Tips

- Services allow you to expose an application running in multiple Pods.
- ClusterIP Services expose the Pods to other applications within the cluster.
- NodePort Services expose the Pods externally using a port that listens on every node in the cluster.


### 6.5 Exposing Applications with Ingress

[Lesson Reference]()

Documentation

[Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)

An Ingress is a Kubernetes object that manages access to Services, from outside the cluster.

For example, you can use an Ingress to provide your end users with access to your web application running in Kubernetes.

Now we've already talked about NodePort Services, which are able to expose applications externally, but Ingresses can provide external access to applications with some more powerful features that something like a NodePort Service doesn't have.

Ingresses may be used in the context of cloud platforms like AWS or Microsoft Azure.

An Ingress object routes traffic into your cluster to the correct application. By default, an ingress enables a Google Cloud Load Balancer.  These are some badass, globally available load balancers that can handle an outrageous amount of traffic. You probably don’t need that for most applications, especially development environments.  The Nginx ingress controller is a substitute. Its an application that runs in your cluster and handles routing and load balancing traffic. It’s simple to add an nginx ingress controller; apply the files in repository.  https://github.com/johnfkraus/kubernetes

`kubectl apply -f nginx-ingress-controller/`

Ingresses manage external access by automatically configuring the cloud platform to manage that external access.

Ingresses can provide SSL termination.  You can code your own Ingress controllers to do anything you want.

you can think of an Ingress as a more fully featured way of allowing external access into your applications that are running in the cluster.

In order to understand Ingresses, it's important to  have an idea of how they route traffic
from a client to an underlying Pod.

that's a concept called Ingress routing.

Ingresses work alongside Services.  The Ingress routes traffic to a Service which then routes the traffic to a Pod.

we have the client trying to reach out to the Pods, and the Ingress kind of acts as a middleman
between the client and a Service.

The client makes a request to the Ingress.
Then that traffic is routed to a Service and then to one of the underlying Pods.

It's important to note that you do need an Ingress controller to  implement the Ingress functionality.

Without an Ingress controller you can create Ingress objects, but they won't  do anything.

a lot of times, Kubernetes clusters when you set them up in the default way don't have any Ingress controllers enabled.

that's something that we're going to have to deal with if we want to  experiment
with Ingresses is in the cluster.


log in to the Kubernetes control plane node,

create a Pod called ingress-test-pod for the Ingress to communicate with.

it's a simple nginx web server with label: 'app: ingress-test'.

Save, exit, apply.

Ingresses work hand-in-hand with Services, so we need a Service.

create a ClusterIP Service called ingress-test-service,
that will select the 'ingress-service-pod' Pod that we created.

The port for the Service will be port 80 and the targetPort will be port 80 as well.

if we communicate with port 80 on Service we should get a response from the nginx web server Pod.

Save, exit and apply.

Before creating the Ingress, test the Service to make sure it's working.

kubectl get service,
on the name of the Service there,
and I'll copy that ClusterIP address,
and then do a quick curl,
on that IP address, to return the nginx Welcome page.
The Service and hte Pod are working as expected,

Create ingress-test-ingress.yml.

I'm creating Ingress called
ingress-test-ingress,
and I'm specifying an Ingress class name.
what does is it  tells the cluster
which Ingress controller to use
in order to interact with actual Ingress.

I'm going to set up an Ingress controller
called the nginx Ingress controller,
and it's called that because it  uses an nginx web server to handle all the routing
and to  interact with the incoming requests that are coming in.

that's going to be the name of the nginx controller, and I'll set the Ingress class name to nginx.

Here is the set of Ingress rules that take incoming requests and then route them to the appropriate destination.

the host for first rule is going to be ingresstest.acloud.guru, an HTTP rule, and the only path here I have is /.

if we make a request to domain ingresstest.acloud.guru,
the rule will route the request to the appropriate backend.

Here is the backend, which is going to be the Service.
I've specified the name of the Service here as well as the port.

if we make a request to domain ingresstest.acloud.guru, it'll get routed appropriately to the Service on the backend.

Save, exit, apply.

I'll get a list of Ingress objects that can
interact with these, like with any Kubernetes object.
here is the ingress-testingress there.

You can see the host, and the port,
all the basic information about the Ingress.
I can also use
kubectl describe.
on that Ingress, and I can get a little bit more detailed information, including information about the backend.
I can see the actual Service, and even the IP address of
the underlying Pods, for that Service.
it looks like everything is working so far.
The Ingress is able to successfully detect the backend.
Now don't worry if you see error message here,
that's only appearing because we didn't specify a default backend, and we're not going to focus on that for the purposes of lesson.
as it stands right now, Ingress that we've created doesn't  do anything because we have not installed an Ingress controller.

let's fix that.
We will use Helm to install an Ingress controller.
you may remember in a previous lesson we installed Helm.
If you happen to have skipped that lesson you may need to go back and make sure that you have Helm
installed in your cluster if you're following along.

I'm going to set up the Ingress controller.
add the Helm repository for nginx-stable.

there's the URL,
https://helm.nginx.com/stable.

that's the Helm repository.

I'll do a helm repo update and I'll create a special Namespace here to install into. I'll do
kubectl create namespace nginx-ingress.
then I'll do the helm install, and I'll call the release
nginx-ingress.

the package I'm going to install is
nginx-stable/nginx-ingress,
install into that Namespace I created.
the nginx Ingress Controller  creates an nginx web server that handles all of that incoming traffic.

if I want to  make a request to the application through that Ingress that I created I need to interact with that Ingress controller web server.

to do that, I need to get the IP address of the Ingress controller Service.
I'm going to execute kubectl get service,

and is going to be the name of that Service, nginx-ingress-nginx-ingress.

It's a little bit repetitive there,
but it's going to be in that nginx-ingress Namespace.
here I can see that Service and I need IP address.
That is the ClusterIP address of the Service.
I'm going to copy that IP address.
then I'll execute
sudo vi/etc/hosts.

I'll enter that IP address and URL (ingresstest.acloud.guru) into the hosts file of the control plane server here.

that'll allow us to make a request to the Ingress on domain,

and it'll be routed to that Ingress controller.
now, we can  test the setup here using curl.

I'll execute
curl ingresstest.acloud.guru.

I get back the nginx Welcome page.

we've successfully configured the Ingress.

you don't necessarily need to worry about setting up the Ingress controller for the purposes of the CKAD exam.

That's not part of the curriculum that's listed in the curriculum sheet.
We set up the Ingress controller so we could see the Ingress in action.

Exam Tips

- An Ingress manages external access to Kubernetes applications.
- An Ingress routes to one or more Kubernetes Services.
- You need an Ingress controller to implement the Ingress functionality. Which controller you use determines the specifics of how the Ingress will work.


Lesson Reference

Log in to the control plane node.

Create a Pod.
```
vi ingress-test-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: ingress-test-pod
  labels:
    app: ingress-test
spec:
  containers:
  - name: nginx
    image: nginx:stable
    ports:
    - containerPort: 80

kubectl apply -f ingress-test-pod.yml
```
Create a ClusterIP Service for the Pod.
```
vi ingress-test-service.yml

apiVersion: v1
kind: Service
metadata:
  name: ingress-test-service
spec:
  type: ClusterIP
  selector:
    app: ingress-test
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80

kubectl apply -f ingress-test-service.yml
```
Get the Service's cluster IP address.
```
kubectl get service ingress-test-service

NAME                   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
clusterip-service      ClusterIP   10.99.36.82      <none>        8080/TCP         44m
ingress-test-service   ClusterIP   10.101.132.223   <none>        80/TCP           18s
nodeport-service       NodePort    10.101.220.68    <none>        8080:30080/TCP   38m

```
Use the cluster IP address to test the Service.
```
curl <Service cluster IP address>

curl 10.101.132.223

<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...
```
Create an Ingress.
```
vi ingress-test-ingress.yml

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-test-ingress
spec:
  ingressClassName: nginx
  rules:
  - host: ingresstest.acloud.guru
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: ingress-test-service
            port:
              number: 80

kubectl apply -f ingress-test-ingress.yml
```
View a list of ingress objects.
```
kubectl get ingress

NAME                   CLASS   HOSTS                     ADDRESS   PORTS   AGE
ingress-test-ingress   nginx   ingresstest.acloud.guru             80      17s

```
Get more details about the ingress. You should notice ingress-test-service listed as one of the backends.
```
kubectl describe ingress ingress-test-ingress

k describe ingress

Name:             ingress-test-ingress
Labels:           <none>
Namespace:        default
Address:
Ingress Class:    nginx
Default backend:  <default>
Rules:
  Host                     Path  Backends
  ----                     ----  --------
  ingresstest.acloud.guru
                           /   ingress-test-service:80 (192.168.235.152:80)
Annotations:               <none>
Events:                    <none>
```
If you want to try accessing your Service through an Ingress controller, you will need to do some additional configuration.

First, use Helm to install the nginx Ingress controller.
```
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
kubectl create namespace nginx-ingress
helm install nginx-ingress nginx-stable/nginx-ingress -n nginx-ingress

NAME: nginx-ingress
LAST DEPLOYED: Fri Dec 30 11:45:33 2022
NAMESPACE: nginx-ingress
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
The NGINX Ingress Controller has been installed.
```
Get the cluster IP of the Ingress controller's Service.
```
k get svc --all-namespaces
NAMESPACE       NAME                          TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
...
nginx-ingress   nginx-ingress-nginx-ingress   LoadBalancer   10.106.52.15     <pending>     80:32233/TCP,443:32669/TCP   74s

kubectl get svc nginx-ingress-nginx-ingress -n nginx-ingress

NAME                          TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
nginx-ingress-nginx-ingress   LoadBalancer   10.106.52.15   <pending>     80:32233/TCP,443:32669/TCP   2m1s
```
Edit your hosts file.
```
sudo vi /etc/hosts
```
Use the cluster IP to add an entry to the hosts file.
```
<Nginx ingress controller Service cluster IP> ingresstest.acloud.guru

```
Now, test your setup.
```
curl ingresstest.acloud.guru

<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>

```

### 6.6 Lab: Exposing a Kubernetes Application with Services and Ingress


<span style="float:right">[Lab diagram](images/ingress_lab.png)</span><br />

<img src="images/ingress_lab.png"
     alt="Lab diagram: Exposing a Kubernetes Application with Services and Ingress"
     style="float: right; margin-right: 10px; margin-bottom: 10px;"
     width="70%" />

Welcome to HiveCorp, a software design company that is totally not run by bees!

We are working on setting up the external landing page, hive.io. The application Deployment is already set up, but we need to configure a Service and an Ingress to expose the application.

The Ingress controller is already set up. Create a Service to expose the existing Deployment. Then, create an Ingress that uses Service as a backend.

Many applications are built to serve the outside world. As such, managing external access to an application is a crucial part of Kubernetes application design. In lab, you will have the opportunity to use Services and Ingress to expose an application to the outside world.

Learning Objectives

- Create a Service to Expose the Application
- Expose the Application Externally Using an Ingress

Solution

Log in to the server using the credentials provided:
```
ssh cloud_user@<PUBLIC_IP_ADDRESS>
```
#### Create a Service to Expose the Application

To begin, get a list of Pods in the hive Namespace, and take note of the labels on the Pods associated with the hive-io-frontend Deployment:
```
kubectl get pods -n hive --show-labels

NAME                               READY   STATUS    RESTARTS   AGE   LABELS
hive-io-frontend-6d5f44d5d-447k7   1/1     Running   0          84m   app=hive-io-frontend,pod-template-hash=6d5f44d5d
hive-io-frontend-6d5f44d5d-5l7m9   1/1     Running   0          84m   app=hive-io-frontend,pod-template-hash=6d5f44d5d
```
You should see you have 2 Pods associated with the hive.io application.

Create a YAML manifest for the Service:
```
vi hive-io-frontend-svc.yml

apiVersion: v1
kind: Service
metadata:
  name: hive-io-frontend-svc
  namespace: hive
spec:
  type: ClusterIP
  selector:
    app: hive-io-frontend
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 80

kubectl apply -f hive-io-frontend-svc.yml
```
Get the Service's CLUSTER-IP address, and copy it:
```
kubectl get svc hive-io-frontend-svc -n hive

NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
hive-io-frontend-svc   ClusterIP   10.101.23.203   <none>        80/TCP    84s
```
Use the hive-io-frontend-svc CLUSTER-IP address you copied to test the Service on port 8080:
```
curl <CLUSTER-IP>:8080

<h1>Welcome to HiveCorp!</h1>
```
You should see the Welcome to HiveCorp! message indicating the Service is working.

#### Expose the Application Externally Using an Ingress

Create a YAML file for the Ingress object:
```
vi hive-io-frontend-ingress.yml

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hive-io-frontend-ingress
  namespace: hive
spec:
  ingressClassName: nginx
  rules:
  - host: hive.io
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: hive-io-frontend-svc
            port:
              number: 8080

kubectl apply -f hive-io-frontend-ingress.yml
```
Test your Ingress:
```
curl hive.io

<h1>Welcome to HiveCorp!</h1>
```


### 6.7 Quiz: Services and Networking

You want to expose your application externally and provide SSL termination. What Kubernetes feature should you use?

- Ingress
- Service
- Deployment
- NetworkPolicy


You have experienced a security breach where an attacker gained control of one Pod in the cluster. They were then able to use that Pod to communicate with every other Pod in the cluster. Luckily, the attack was stopped quickly, but what can you do to limit network communication between Pods and prevent unexpected or unnecessary network access?

- Only use Services to communicate between Pods.
- Disable the cluster network.
- Implement a secure Ingress object.
- Use NetworkPolicies.

You have implemented a set of NetworkPolicies in your cluster. You have a Pod that is not selected by any of your NetworkPolicies. Assuming NetworkPolicies allow traffic to and from the other Pods that Pod is communicating with, what will happen to Pod's traffic?

- Only outgoing traffic will be allowed.
- Only incoming traffic will be allowed.
- All of the Pod's traffic will be blocked.
- All of the Pod's traffic will be allowed.

X You have a Service that is reachable by communicating with port 30085 on one of your worker nodes. What type of Service is this?

- ExternalName
- NodePort - NodePort Services are exposed externally by listening on a port on all cluster nodes.
- ClusterIP - ClusterIP Services are not exposed externally and do not listen on a cluster node's port.
- Ingress

An Ingress NetworkPolicy selects podA and allows incoming requests from podB. An Egress policy selects podB and does not allow any traffic. There are no other NetworkPolicies in the Namespace. What will happen when podB attempts to make a request to podA?

- The traffic will be blocked.
- The traffic will be allowed.
- You will get an error message since the NetworkPolicies conflict.
- The traffic will sometimes be allowed and sometimes be blocked.

A user request comes to an Ingress. Where does the Ingress send the traffic next? (Assume that you are using a "typical" Ingress and not a custom resource backend.)

- Service
- Pods
- Deployment
- Worker Node

You have a NetworkPolicy with an empty podSelector. What will be the effect of the empty podSelector?

- The NetworkPolicy will not select any Pods and will have no effect on network traffic.
- It is impossible to create a NetworkPolicy with an empty podSelector.
- The NetworkPolicy will select all Pods in the Namespace.
- The NetworkPolicy will select all Pods in the cluster.

You have a Deployment with 7 replicas that serve an API used by other applications within your cluster. You want other Pods to be able to access API easily, without needing to know the IP addresses of the replica Pods. What Kubernetes object can you use to accomplish this?

- NetworkPolicy
- Another Deployment
- Service
- CustomResourceDefinition

- A Service can provide a network abstraction layer on top of the API replicas, allowing other Pods to easily access the API.


You have an Ingress NetworkPolicy that selects a Pod called podA, but does not allow any traffic. Another Ingress NetworkPolicy selects podA and allows incoming traffic from podB. What will happen when podB makes a request to podA?

- You will get an error message since the NetworkPolicies conflict.
- The request will be denied.
- The traffic will be allowed sometimes and sometimes blocked.
- The request will be allowed.


What is the purpose of a default deny NetworkPolicy?


- Block all traffic within a Namespace by default, allowing other NetworkPolicies to provide exceptions for necessary traffic.
- Force Pods to use Services to communicate with each other.
- Prevent the creation of Pods within a Namespace.
- Block all traffic within a Namespace — with no exceptions.

- Default deny policies block traffic in a Namespace by default, but the traffic will be allowed if another NetworkPolicy allows it. In way, you can provide exceptions to the default deny policy and allow necessary traffic.


### 6.8 Services and Networking Summary


NetworkPolicies control and limit communication within the Kubernetes virtual network.

- if a Pod is not selected by any NetworkPolicies the Pod is non-isolated and all traffic is allowed.
- If a Pod is selected by any NetworkPolicy traffic will be blocked unless it is allowed by at least one NetworkPolicy that selects the Pod.
- If you combine a namespaceSelector and a podSelector within the same rule, the traffic must meet both the Pod- and Namespace-related conditions in order to be allowed.
- even if a NetworkPolicy allows outgoing traffic from the source Pod NetworkPolicies could still block the same traffic when it is incoming to the destination Pod.

Services manage microservices in the cluster.

- Services allow you to expose an application running in multiple Pods.
- ClusterIP Services expose the Pods to other applications within the cluster.
- NodePort Services expose the Pods externally using a port that listens on every node in the cluster.

Ingress providing access to applications from outside the cluster.

- an Ingress manages external access to Kubernetes applications.
- An Ingress routes to one or more Kubernetes services.
- you need an Ingress controller to implement the Ingress functionality.  Which Ingress controller you use determines the specifics of how the Ingress will  work.


## CHAPTER 7 Practice Exams

### Part 1 - Fix a Deployment; ServiceAccount, Role, RoleBinding - CKAD Practice Exam

- Fix a Deployment with an Incorrect Image Name

A Deployment in the default Namespace is not working correctly due to a misspelled image name. Identify which Deployment is broken, and fix the issue.

- Fix an Issue with a Broken Pod

The bat Deployment in the cave Namespace is having some issues. Check the log for one of Deployment's Pods to determine what is wrong. Then, modify the Deployment to fix the issue.

Note: You do not need to make changes to any object other than the Deployment, although you may need to view other objects as you investigate how to solve the problem.

Use the provided environment to complete the tasks detailed in the learning objectives.

You will have access to a CLI server with hostname 'k8s-cli'.  

You can access all components of the cluster from the provided CLI server. The control plane server is 'k8s-control', and the worker is 'k8s-worker1'. If you need to log in to the control plane server, for example, use `ssh k8s-control` from the CLI server.

You can use kubectl from the CLI server, control plane node, or worker to interact with the cluster.  In order to use kubectl from the CLI server, you will need to select the **acgk8s** cluster to interact with, as follows:
```
kubectl config get-contexts

kubectl config use-context acgk8s
```
kubectl is aliased to k, and kubernetes autocompletion is enabled. You can use the k alias like so: k get pods.

the lab includes a verification script to help you determine whether you have completed the objectives successfully. You can run the verification script with /home/cloud_user/verify.sh.


Solution

Log in to the CLI server using the credentials provided:
```
ssh cloud_user@<PUBLIC_IP_ADDRESS>
```
Switch to the acgk8s cluster context:
```
kubectl config use-context acgk8s
```
Fix a Deployment with an Incorrect Image Name

Check the Pods in the default Namespace:
```
kubectl get pods
```
Note the Pods in the bruce Deployment have a status of ImagePullBackOff, indicating that Deployment has an issue with the image name.

#### Edit the Deployment.  

Note: When copying and pasting code into Vim from the lab guide, first enter :set paste (and then i to enter insert mode) to avoid adding unnecessary spaces and hashes. To save and quit the file, press Escape followed by :wq. To exit the file without saving, press Escape followed by :q!.

kubectl edit deployment bruce

Find the container image name in the Pod template, and change it from ninx:stable to nginx:stable:
```
      containers:
      - image: nginx:stable
```
Type ESC followed by :wq to save your changes.

Check the Pods again to see if the new Pods are working:

kubectl get pods

Run the verification script to ensure you completed the objective:

~/verify.sh

(Be sure to put '~/' in front of 'verify.sh'.)

#### Fix an (Authorization) Issue with a Broken Pod (Template)

Get a list of Pods in the cave Namespace:

Not all objects are in a Namespace.

Most Kubernetes resources (e.g. pods, services, replication controllers, and others) are namespaced.  However Namespace resources themselves are not namespaced.  Low-level resources such as nodes and persistentVolumes are not namespaced.
```
kubectl get pods -n cave
```
Copy the Pod's NAME.

Use the NAME of the bat Deployment's Pod to get the Pod logs:
```
kubectl logs <Pod NAME> -n cave

Error from server (Forbidden): pods is forbidden: User "system:serviceaccount:cave:default" cannot list resource "pods" in API group "" in the Namespace "cave"
```
The Pod log contains an error message indicating that the Pod's ServiceAccount (default) is not allowed to list the pods resource.  You will need to check the existing RBAC setup in the Namespace in order to locate a ServiceAccount with the appropriate permissions.

Check the Namespace's ServiceAccounts:
```
kubectl get sa -n cave

NAME        SECRETS   AGE
default     0         19m
gotham-sa   0         19m
wayne-sa    0         19m
```
Check the Roles in the Namespace:
```
kubectl get role -n cave

NAME          CREATED AT
batman-role   2023-01-10T12:22:29Z
robin-role    2023-01-10T12:22:28Z
```
Two Roles exist.  Get more detailed information on the batman-role:
```
kubectl describe role -n cave batman-role

Name:         batman-role
Labels:       <none>
Annotations:  <none>
PolicyRule:
  Resources    Non-Resource URLs  Resource Names  Verbs
  ---------    -----------------  --------------  -----
  deployments  []                 []              [get list]
  services     []                 []              [get list]
cloud_user@k8s-cli:~$
```
You should see Role has get and list permissions for deployments and services, but it doesn't have permissions for Pods.

Get more detailed information on the robin-role:
```
kubectl describe role -n cave robin-role

Name:         robin-role
Labels:       <none>
Annotations:  <none>
PolicyRule:
  Resources  Non-Resource URLs  Resource Names  Verbs
  ---------  -----------------  --------------  -----
  pods       []                 []              [get list]
```
The robin-role has permission to list Pods.

Check the RoleBindings to find out which ServiceAccount uses the robin-role:
```
kubectl get rolebinding -n cave

NAME        ROLE               AGE
batman-rb   Role/batman-role   26m
robin-rb    Role/robin-role    26m
```
You should see both a batman-rb and a robin-rb. You will need to review both RoleBindings.

Get more detailed information on the batman-rb RoleBinding:
```
kubectl describe rolebinding -n cave batman-rb

Name:         batman-rb
Labels:       <none>
Annotations:  <none>
Role:
  Kind:  Role
  Name:  batman-role
Subjects:
  Kind            Name      Namespace
  ----            ----      ---------
  ServiceAccount  wayne-sa  cave
```
The batman-rb role binding binds the batman-role and the wayne-sa ServiceAccount.  is not the RoleBinding we need.

Get more detailed information on the robin-rb RoleBinding:
```
kubectl describe rolebinding -n cave robin-rb

Name:         robin-rb
Labels:       <none>
Annotations:  <none>
Role:
  Kind:  Role
  Name:  robin-role
Subjects:
  Kind            Name       Namespace
  ----            ----       ---------
  ServiceAccount  gotham-sa  cave
```
You should see that robin-rb binds the robin-role, which allows [get list] on pods is bound to the 'gotham-sa' service account.  

Adding the gotham-sa ServiceAccount to the 'bat' deployment pod template spec will authorize the 'get pods' command.

Edit the Deployment:
```
kubectl edit deployment bat -n cave
```
Under the Pod template spec line, add the gotham-sa ServiceAccount:
```
spec:
  ...
  template:
    ...
    spec:
      serviceAccountName: gotham-sa
      containers: ...
```
Write and quit.

Get a list of Pods again:
```
kubectl get pods -n cave
```
You should see the old Pod Terminating and the new one with a Running status. Copy the name of the new Pod.

Using the NAME of the new Pod, check the new Pod's log to verify that it is now working:

kubectl logs <Pod NAME> -n cave

The Pod log should contain the output of a kubectl get pods that was successfully run within the Pod's container.

Run the verification script to ensure you completed the objective:

~/verify.sh

Done.


### Part 2 - ServiceAccount, Security Settings - CKAD Practice Exam

Objectives

- Configure a Deployment's Pods to Use an Existing ServiceAccount

There is a Deployment called han in the default Namespace. Modify Deployment so that its Pods use the falcon-sa ServiceAccount.

- Customize Security Settings for a Deployment's Pods

Find a Deployment called lando in the default Namespace. For Deployment's containers, allow privilege escalation, and configure the container process to run as the user with user ID 2727.

the lab provides practice scenarios to help prepare you for the Certified Kubernetes Application Developer (CKAD) exam. You will be presented with tasks to complete, as well as server(s) and/or an existing Kubernetes cluster to complete them in. You will need to use your knowledge of Kubernetes to successfully complete the provided tasks, much like you would on the real CKAD exam. Good luck!

Lab Environment

Use the provided environment to complete the tasks detailed in the learning objectives.

You can access all components of the cluster from the CLI server. The control plane server is k8s-control, and the worker is k8s-worker1. If you need to log in to the control plane server, for example, use ssh k8s-control from the CLI server.

You can also use kubectl from the CLI server, control plane node, or worker to interact with the cluster. In order to use kubectl from the CLI server, you will need to select the acgk8s cluster to interact with, like so: kubectl config use-context acgk8s.

kubectl is aliased to k, and Kubernetes autocompletion is enabled. You can use the k alias like so: k get pods.

the lab includes a verification script to help you determine whether you have completed the objectives successfully. You can run the verification script with /home/cloud_user/verify.sh.

#### Solution

Log in to the server using the credentials provided:

ssh cloud_user@<PUBLIC_IP_ADDRESS>

Switch to the acgk8s cluster context:

k config get-contexts

kubectl config use-context acgk8s

#### Configure a Deployment's Pods to Use an Existing ServiceAccount

Edit the Deployment:

kubectl edit deployment han

Scroll down to the Pod template and then to the Pod spec. Add the following to set the serviceAccountName to falcon-sa. You can add right under the spec line:

  template:
    ...

    spec:
      serviceAccountName: falcon-sa

ESC, :wq to save your changes.

Verify the Deployment's Pods are running:

kubectl get pods

You should see both the han and lando Pods are up and in a Running status.

Run the verification script to ensure you completed the objective:

~/verify.sh

#### Customize Security Settings for a Deployment's Pods

Edit the Deployment:

kubectl edit deployment lando

Scroll down to the containers spec, and configure the securityContext for the container *in the Pod template*. You can add the following under the terminationMessagePolicy line:
```
spec:
  ...
  template:
    ...
    spec:
      containers:
        ...
        securityContext:
          allowPrivilegeEscalation: true
          runAsUser: 2727
```
Type ESC followed by :wq to save your changes.

Verify the Deployment's Pods are running:
```
kubectl get pods
```
You should see the old lando Pod Terminating and the new one in a Running status.

Run the verification script to ensure you completed the objective:

~/verify.sh

Done.


### Part 3 - ConfigMap - CKAD Practice Exam

Learning Objectives

- Create a ConfigMap

Create a ConfigMap called kenobi in the yoda Namespace.

Store the following configuration data in the ConfigMap:

planet: hoth

- Create a Pod That Consumes the ConfigMap as a Mounted Volume

Create a Pod called chewie in the yoda Namespace. Use the nginx:stable image.

Provide the kenobi ConfigMap data to this Pod as a mounted volume at the path /etc/starwars.

The volume name must be defined as kenobi-cm.

Introduction

This lab provides practice scenarios to help prepare you for the Certified Kubernetes Application Developer (CKAD) exam. You will be presented with tasks to complete, as well as server(s) and/or an existing Kubernetes cluster to complete them in. You will need to use your knowledge of Kubernetes to successfully complete the provided tasks, much like you would on the real CKAD exam. Good luck!

Lab Environment

Use the provided environment to complete the tasks detailed in the learning objectives.

You can access all components of the cluster from the CLI server. The control plane server is k8s-control, and the worker is k8s-worker1. If you need to log in to the control plane server, for example, just use ssh k8s-control from the CLI server.

You can also use kubectl from the CLI server, control plane node, or worker to interact with the cluster. In order to use kubectl from the CLI server, you will need to select the acgk8s cluster to interact with, like so: kubectl config use-context acgk8s.

kubectl is aliased to k, and Kubernetes autocompletion is enabled. You can use the k alias like so: k get pods.

This lab includes a verification script to help you determine whether you have completed the objectives successfully. You can run the verification script with /home/cloud_user/verify.sh.


Solution

#### Create the ConfigMap

Log in to the CLI server using the credentials provided.

Switch to the acgk8s cluster context:
```
kubectl config use-context acgk8s

vim kenobi.yml

apiVersion: v1
kind: ConfigMap
metadata:
  name: kenobi
  namespace: yoda
data:
  planet: hoth

kubectl apply -f kenobi.yml
```
Run the verification script to ensure you completed the objective:
```
~/verify.sh
```
#### Create a Pod That Consumes the ConfigMap as a Mounted Volume
```
vi chewie.yml

apiVersion: v1
kind: Pod
metadata:
  name: chewie
  namespace: yoda
spec:
  containers:
  - name: nginx
    image: nginx:stable
    volumeMounts:
    - name: kenobi-cm
      mountPath: /etc/starwars
  volumes:
  - name: kenobi-cm
    configMap:
      name: kenobi

kubectl apply -f chewie.yml
```
Check the Pod status to make sure it is running as expected:

kubectl get pods -n yoda

Run the verification script to ensure you completed the objective:

~/verify.sh
Conclusion
Congratulations — you've completed this hands-on lab!


### Part 4 - Rollout Settings - CKAD Practice Exam

Use the provided environment to complete the tasks detailed in the learning objectives.

You can access all components of the cluster from the CLI server. The control plane server is k8s-control, and the worker is k8s-worker1. If you need to log in to the control plane server, for example, just use ssh k8s-control from the CLI server.

You can also use kubectl from the CLI server, control plane node, or worker to interact with the cluster. In order to use kubectl from the CLI server, you will need to select the acgk8s cluster to interact with, like so: kubectl config use-context acgk8s.

kubectl is aliased to k, and Kubernetes autocompletion is enabled. You can use the k alias like so: k get pods.

This lab includes a verification script to help you determine whether you have completed the objectives successfully. You can run the verification script with /home/cloud_user/verify.sh.

```
cat verify.sh

#!/bin/bash
echo -e "Checking Objectives..."
OBJECTIVE_NUM=0
function printresult {
  ((OBJECTIVE_NUM+=1))
  echo -e "\n----- Checking Objective $OBJECTIVE_NUM -----"
  echo -e "----- $1"
  if [ $2 -eq 0 ]; then
      echo -e "      \033[0;32m[COMPLETE]\033[0m Congrats! This objective is complete!"
  else
      echo -e "      \033[0;31m[INCOMPLETE]\033[0m This objective is not yet completed!"
  fi
}

expected="250%"
actual=$(kubectl get deployment fish -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}{.spec.strategy.rollingUpdate.maxSurge}' 2>/dev/null)
[[ "$actual" = "$expected" ]]
printresult "Change the rollout settings for an existing Deployment." $?

expected="fish"
actual=$(kubectl rollout history deployment/fish --revision=2 -o jsonpath='{.metadata.name}' 2>/dev/null)
[[ "$actual" = "$expected" ]]
printresult "Perform a rolling update." $?

expected="nginx:1.20.2fish"
actual=$(kubectl get deployment fish -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)$(kubectl rollout history deployment/fish --revision=3 -o jsonpath='{.metadata.name}' 2>/dev/null)
[[ "$actual" = "$expected" ]]
printresult "Roll back a Deployment to the previous version." $?
```

Learning Objectives

- Change the Rollout Settings for an Existing Deployment
  - There is a Deployment called fish in the default Namespace.
  - Change the maxUnavailable for this Deployment to 2. Change maxSurge to 50%.

- Perform a Rolling Update
  - Perform a rolling update to change the image used in the fish Deployment to nginx:1.21.5.

- Roll Back a Deployment to the Previous Version
  - Roll back the fish Deployment to the previous version.


#### Max Unavailable

.spec.strategy.rollingUpdate.maxUnavailable is an optional field that specifies the maximum number of Pods that can be unavailable during the update process. The value can be an absolute number (for example, 5) or a percentage of desired Pods (for example, 10%). The absolute number is calculated from percentage by rounding down. The value cannot be 0 if .spec.strategy.rollingUpdate.maxSurge is 0. The default value is 25%.

For example, when this value is set to 30%, the old ReplicaSet can be scaled down to 70% of desired Pods immediately when the rolling update starts. Once new Pods are ready, old ReplicaSet can be scaled down further, followed by scaling up the new ReplicaSet, ensuring that the total number of Pods available at all times during the update is at least 70% of the desired Pods.


#### Max Surge

.spec.strategy.rollingUpdate.maxSurge is an optional field that specifies the maximum number of Pods that can be created over the desired number of Pods. The value can be an absolute number (for example, 5) or a percentage of desired Pods (for example, 10%). The value cannot be 0 if MaxUnavailable is 0. The absolute number is calculated from the percentage by rounding up. The default value is 25%.

For example, when this value is set to 30%, the new ReplicaSet can be scaled up immediately when the rolling update starts, such that the total number of old and new Pods does not exceed 130% of desired Pods. Once old Pods have been killed, the new ReplicaSet can be scaled up further, ensuring that the total number of Pods running at any time during the update is at most 130% of desired Pods.




Solution

Log in to the server using the credentials provided:
```
ssh cloud_user@<PUBLIC_IP_ADDRESS>
```
Switch to the acgk8s cluster context:
```
kubectl config use-context acgk8s
```
#### Change the Rollout Settings for an Existing Deployment

Open and edit the fish Deployment:
```
kubectl edit deployment fish
```
Under the Deployment spec, look for the Deployment strategy. Change the maxSurge value from 10% to 50% and the maxUnavailable value from 1 to 2:

Note: When copying and pasting code into Vim from the lab guide, first enter :set paste (and then i to enter insert mode) to avoid adding unnecessary spaces and hashes. To save and quit the file, press Escape followed by :wq. To exit the file without saving, press Escape followed by :q!.

  strategy:
    rollingUpdate:
      maxSurge: 50%
      maxUnavailable: 2

Type ESC followed by :wq to save your changes.

Run the verification script to ensure you completed the objective:

~/verify.sh

#### Perform a Rolling Update

Reopen the fish Deployment:
```
kubectl edit deployment fish
```
Initiate a rolling update by changing the image version of the nginx container. Change the version from 1.20.2 to 1.21.5:

      containers:
      - name: nginx
        image: nginx:1.21.5
Type ESC followed by :wq to save your changes.

Check the Deployment status:
```
kubectl get deployment fish
```
You should see 5/5 are READY.

Check the Pods:
```
kubectl get pods
```
You should see all 5 replicas up and running.

Run the verification script to ensure you completed the objective:
```
~/verify.sh
```
#### Roll back a Deployment to the Previous Version

Roll back the Deployment:
```
kubectl rollout undo deployment/fish
```
Check the Deployment status:
```
kubectl get deployment fish
```
You should see 5/5 as READY and 5 UP-TO-DATE, meaning the rollback was successful.

Check the Pods:
```
kubectl get pods
```
You should see all 5 Pods with a young age, again indicating the rollback was successful.

Run the verification script to ensure you completed the objective:
```
~/verify.sh
```
Conclusion

Congratulations — you've completed this hands-on lab!



### Part 5 - PersistentVolume - CKAD Practice Exam

Lab Environment
Use the provided environment to complete the tasks detailed in the learning objectives.

You can access all components of the cluster from the CLI server. The control plane server is k8s-control, and the worker is k8s-worker1. If you need to log in to the control plane server, for example, just use ssh k8s-control from the CLI server.

You can also use kubectl from the CLI server, control plane node, or worker to interact with the cluster. In order to use kubectl from the CLI server, you will need to select the acgk8s cluster to interact with, like so:
```
kubectl config use-context acgk8s.
```
kubectl is aliased to k, and Kubernetes autocompletion is enabled. You can use the k alias like so: k get pods.

This lab includes a verification script to help you determine whether you have completed the objectives successfully. You can run the verification script with /home/cloud_user/verify.sh.

- Create a PersistentVolume

Create a PersistentVolume called pv-data in the default Namespace.

Set the storage amount to 1Gi and the storage class to static.

Use a hostPath to mount the host directory /var/pvdata with the PersistentVolume.


- Create a Pod That Consumes Storage from the PersistentVolume

Create a Pod called pv-pod in the default Namespace.

Use the busybox:stable image with the command sh -c while true; do sleep 3600; done.

Use the PersistentVolume to provide storage to this Pod's container at the path /var/data.

If everything is set up correctly, you should be able to find some data exposed to the container by the PersistentVolume at /var/data/data.txt.


00:05:54

Certified Kubernetes Application Developer (CKAD) Practice Exam - Part 5
1 hour duration
Practitioner
VIDEOS
GUIDE
Certified Kubernetes Application Developer (CKAD) Practice Exam - Part 5
Introduction
This lab provides practice scenarios to help prepare you for the Certified Kubernetes Application Developer (CKAD) exam. You will be presented with tasks to complete, as well as server(s) and/or an existing Kubernetes cluster to complete them in. You will need to use your knowledge of Kubernetes to successfully complete the provided tasks, much like you would on the real CKAD exam. Good luck!

Lab Environment
Use the provided environment to complete the tasks detailed in the learning objectives.

You can access all components of the cluster from the CLI server. The control plane server is k8s-control, and the worker is k8s-worker1. If you need to log in to the control plane server, for example, just use ssh k8s-control from the CLI server.

You can also use kubectl from the CLI server, control plane node, or worker to interact with the cluster. In order to use kubectl from the CLI server, you will need to select the acgk8s cluster to interact with, like so: kubectl config use-context acgk8s.

kubectl is aliased to k, and Kubernetes autocompletion is enabled. You can use the k alias like so: k get pods.

This lab includes a verification script to help you determine whether you have completed the objectives successfully. You can run the verification script with /home/cloud_user/verify.sh.

Solution
Log in to the server using the credentials provided:

ssh cloud_user@<PUBLIC_IP_ADDRESS>
Switch to the acgk8s cluster context:

kubectl config use-context acgk8s
Create a PersistentVolume
Create the PersistentVolume:

vi pv-data.yml
Add the following to create a PersistentVolume called pv-data in the default Namespace. Ensure you set the storage to 1Gi and the storageClassName to static. Use a hostPath to mount the host directory /var/pvdata with the PersistentVolume:

Note: When copying and pasting code into Vim from the lab guide, first enter :set paste (and then i to enter insert mode) to avoid adding unnecessary spaces and hashes. To save and quit the file, press Escape followed by :wq. To exit the file without saving, press Escape followed by :q!.

apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-data
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  storageClassName: static
  hostPath:
    path: /var/pvdata
Type ESC followed by :wq to save your changes.

Apply the changes with kubectl apply:

kubectl apply -f pv-data.yml
Check the PersistentVolume status:

kubectl get pv pv-data
You should see the information for the PersistentVolume with a STATUS of Available.

Run the verification script to ensure you completed the objective:

~/verify.sh
Create a Pod That Consumes Storage from the PersistentVolume
Create the PersistentVolumeClaim:

vi pv-data-pvc.yml
Add the following to create the PersistentVolumeClaim called pv-data-pvc. Configure the specification so that this PersistentVolumeClaim will bind to the PersistentVolume created earlier:

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pv-data-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 256Mi
  storageClassName: static
Type ESC followed by :wq to save your changes.

Apply the changes with kubectl apply:

kubectl apply -f pv-data-pvc.yml
Check the PersistentVolumeClaim status:

kubectl get pvc pv-data-pvc
A Bound status means that the PersistentVolumeClaim has successfully bound itself to the pv-data volume.

Create the Pod:

vi pv-pod.yml
Add the following to create a Pod named pv-pod. Use the busybox:stable image and below command. Use the PersistentVolume to provide storage to this Pod's container at the path /var/data:

apiVersion: v1
kind: Pod
metadata:
  name: pv-pod
spec:
  containers:
  - name: busybox
    image: busybox:stable
    command: ['sh', '-c', 'while true; do sleep 3600; done']
    volumeMounts:
    - name: static-content
      mountPath: /var/data
  volumes:
  - name: static-content
    persistentVolumeClaim:
      claimName: pv-data-pvc
Type ESC followed by :wq to save your changes.

Apply the changes with kubectl apply:

kubectl apply -f pv-pod.yml
Check the Pod status:

kubectl get pod pv-pod
You should see the Pod is in the Running STATUS.

Use kubectl exec to verify that the PersistentVolume's hostPath data is accessible from within the container:

kubectl exec pv-pod -- ls /var/data
You should see data.txt returned in the output. This is static content that is already on the Kubernetes worker node, and it is being pulled in via the PersistentVolume.

Review the contents of the data.txt file:

kubectl exec pv-pod -- cat /var/data/data.txt
You should see a string returned indicating you can successfully access the PersistentVolume's storage data through the Pod's container.

Run the verification script to ensure you completed the objective:

~/verify.sh
Conclusion
Congratulations — you've completed this hands-on lab!

Tools
Credentials
How do I connect?
Cloud Server CLI Server
Username

cloud_user
Password

!vPP4J1+
CLI Server Public IP

3.231.147.98
How do I connect?
Additional Resources
Use the provided environment to complete the tasks detailed in the learning objectives.

You can access all components of the cluster from the CLI server. The control plane server is k8s-control, and the worker is k8s-worker1. If you need to log in to the control plane server, for example, just use ssh k8s-control from the CLI server.

You can also use kubectl from the CLI server, control plane node, or worker to interact with the cluster. In order to use kubectl from the CLI server, you will need to select the acgk8s cluster to interact with, like so: kubectl config use-context acgk8s.

kubectl is aliased to k, and Kubernetes autocompletion is enabled. You can use the k alias like so: k get pods.

This lab includes a verification script to help you determine whether you have completed the objectives successfully. You can run the verification script with /home/cloud_user/verify.sh.

Learning Objectives
0 of 2 completed


Create a PersistentVolume

Create a PersistentVolume called pv-data in the default Namespace.

Set the storage amount to 1Gi and the storage class to static.

Use a hostPath to mount the host directory /var/pvdata with the PersistentVolume.


Create a Pod That Consumes Storage from the PersistentVolume

Create a Pod called pv-pod in the default Namespace.

Use the busybox:stable image with the command sh -c while true; do sleep 3600; done.

Use the PersistentVolume to provide storage to this Pod's container at the path /var/data.

If everything is set up correctly, you should be able to find some data exposed to the container by the PersistentVolume at /var/data/data.txt.

Certified Kubernetes Application Developer (CKAD) course artwork
Loading... - A Cloud Guru





### Part 6 - ResourceRequest, Secret - CKAD Practice Exam

### Part 7 - Schedule a Job; Create a Deployment - CKAD Practice Exam

### Part 8 - Liveness Probe; Pod CPU Usage - CKAD Practice Exam

### Part 9 - NodePort, Network Policy - CKAD Practice Exam

### Part 10 - Blue/Green and Canary Deployments - CKAD Practice Exam

### Part 11 - ConfigMap for haproxy; Service; ambassador container - CKAD Practice Exam

### Part 12 - Dockerfile, build and save a container - CKAD Practice Exam

## CHAPTER 8 Conclusion

### Course Summary

The basic domains of the Certified Kubernetes Application Developer.

Application design and build-designing applications to take advantage of Kubernetes features.

Deploying the code to the Kubernetes cluster.

Application observability and maintenance - gaining insight into applications at runtime and troubleshooting issues.

Application environment, configuration, and security. securing the applications within the Kubernetes environment,.

services and networking - handling network traffic to and from your applications and in between application components within the cluster.


### Conclusion and What’s Next


if you're interested in continuing your journey
with Kubernetes,
we have some other courses that you might be interested in.
If you want to take what you learned in course,
and maybe dive a little bit deeper,
we have a course called
"Designing Applications for Kubernetes."
That would be a great one to check out.
If you want to keep earning Kubernetes certifications,
or you want check out Kubernetes
from the system administration perspective,
you can check out
the "Certified Kubernetes Administrator" course.
That one can also help you earn that CKA certification.
the next certification after that,
the "Certified Kubernetes Security Specialist,"
that one focuses on Kubernetes security.
we have a course for that as well.
as always,
we have plenty of courses on Kubernetes in the cloud.
if you want to dive into Amazon EKS, or Azure AKS,
or Google's GKE,
we have courses on all of those as well.
Once again,
congratulations on making it to the end of course.
Good luck in your learning journey, and keep being awesome!





## Appendices

### Get a Shell in a Running Container

Source:
https://kubernetes.io/docs/tasks/debug/debug-application/get-shell-running-container/

How to use kubectl exec to get a shell to a running container.

In this exercise, you create a Pod that has one container. The container runs the nginx image. Here is the configuration file for the Pod:
```
vim shell-demo.yml

apiVersion: v1
kind: Pod
metadata:
  name: shell-demo
spec:
  volumes:
  - name: shared-data
    emptyDir: {}
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - name: shared-data
      mountPath: /usr/share/nginx/html
  hostNetwork: true
  dnsPolicy: Default

kubectl apply -f shell-demo.yml

kubectl get pod shell-demo
```
Get a shell to the running container:
```
kubectl exec --stdin --tty shell-demo -- /bin/bash
```
Note: The double dash (--) separates the arguments you want to pass to the command from the kubectl arguments.

In your shell, list the root directory:

#### Run this inside the container
```
ls /

bin   docker-entrypoint.d   home   media  proc	sbin  tmp
boot  docker-entrypoint.sh  lib    mnt	  root	srv   usr
dev   etc		    lib64  opt	  run	sys   var
```
In your shell, experiment with other commands. Here are some examples:

#### You can run these example commands inside the container
```
ls /
cat /proc/mounts
cat /proc/1/maps
apt-get update
apt-get install -y tcpdump
tcpdump
apt-get install -y lsof
lsof
apt-get install -y procps
ps aux
ps aux | grep nginx
```
Writing the root page for nginx

Look again at the configuration file for your Pod. The Pod has an emptyDir volume, and the container mounts the volume at /usr/share/nginx/html.

In your shell, create an index.html file in the /usr/share/nginx/html directory:

Run this inside the container
```
echo 'Hello shell demo' > /usr/share/nginx/html/index.html
```
In your shell (inside the container) , send a GET request to the nginx server:

```
apt-get update
apt-get install curl
curl http://localhost/

Hello shell demo
```
The output shows the text that you wrote to the index.html file:

When you are finished with your shell, enter `exit` to quit the shell in the container

Running individual commands in a container

In an ordinary command window, not your shell, list the environment variables in the running container:
```
kubectl exec shell-demo env # (deprecated)
k exec shell-demo -- env
```
Experiment with running other commands. Here are some examples:
```
kubectl exec shell-demo -- ps aux
kubectl exec shell-demo -- ls /
kubectl exec shell-demo -- cat /proc/1/mounts
```
Opening a shell when a Pod has more than one container

If a Pod has more than one container, use --container or -c to specify a container in the kubectl exec command. For example, suppose you have a Pod named my-pod, and the Pod has two containers named main-app and helper-app. The following command would open a shell to the main-app container.
```
kubectl exec -i -t my-pod --container main-app -- /bin/bash

k exec -it shell-demo --container nginx -- /bin/bash
```
Note: The short options -i and -t are the same as the long options --stdin and --tty



## Troubleshooting

https://www.containiq.com/post/debugging-kubernetes-nodes-in-not-ready-state


### How to Fix sub-process /usr/bin/dpkg returned an error code (1) in Ubuntu

https://phoenixnap.com/kb/fix-sub-process-usr-bin-dpkg-returned-error-code-1

`sudo dpkg --configure -a`

SSh into kubernetes node created by Docker Desktop:

docker run -it --rm --privileged --pid=host justincormack/nsenter1

Source: https://stackoverflow.com/questions/55378663/equivalent-of-minikube-ssh-with-docker-for-desktop-kubernetes-node


## Kubernetes Services

https://kubernetes.io/docs/concepts/services-networking/service/

A K8s Service is an abstract way to expose an application running on a set of Pods as a network service.

With Kubernetes you don't need to modify your application to use an unfamiliar service discovery mechanism. Kubernetes gives Pods their own IP addresses and a single DNS name for a set of Pods, and can load-balance across them.

**Motivation**

Kubernetes Pods are created and destroyed to match the desired state of your cluster. Pods are nonpermanent resources. If you use a Deployment to run your app, it can create and destroy Pods dynamically.

Each Pod gets its own IP address, however in a Deployment, the set of Pods running in one moment in time could be different from the set of Pods running that application a moment later.

This leads to a problem: if some set of Pods (call them "backends") provides functionality to other Pods (call them "frontends") inside your cluster, how do the frontends find out and keep track of which IP address to connect to, so that the frontend can use the backend part of the workload?

Enter Services.

Service resources

In Kubernetes, a Service is an abstraction which defines a logical set of Pods and a policy by which to access them (sometimes pattern is called a micro-service). The set of Pods targeted by a Service is usually determined by a selector. To learn about other ways to define Service endpoints, see Services without selectors.

For example, consider a stateless image-processing backend which is running with 3 replicas. Those replicas are fungible—frontends do not care which backend they use. While the actual Pods that compose the backend set may change, the frontend clients should not need to be aware of that, nor should they need to keep track of the set of backends themselves.

The Service abstraction enables decoupling.

Cloud-native service discovery

If you're able to use Kubernetes APIs for service discovery in your application, you can query the API server for Endpoints, that get updated whenever the set of Pods in a Service changes.

For non-native applications, Kubernetes offers ways to place a network port or load balancer in between your application and the backend Pods.

Defining a Service

A Service in Kubernetes is a REST object, similar to a Pod. Like all of the REST objects, you can POST a Service definition to the API server to create a new instance. The name of a Service object must be a valid RFC 1035 label name.

For example, suppose you have a set of Pods where each listens on TCP port 9376 and contains a label app=MyApp:

(What is a 'set of pods'?  Is a 'set of pods' a deployment?)

```yml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: MyApp
  ports:
    - protocol: TCP
      port: 80   # incoming port
      targetPort: 9376
```
The specification creates a new Service object named "my-service", which targets TCP port 9376 on any Pod with the app=MyApp label.

Kubernetes assigns Service an IP address (sometimes called the "cluster IP"), which is used by the Service proxies (see Virtual IPs and service proxies below).

The controller for the Service selector continuously scans for Pods that match its selector, and then POSTs any updates to an Endpoint object also named "my-service".

Note: A Service can map any incoming port to a targetPort. By default and for convenience, the targetPort is set to the same value as the port field.

Port definitions in Pods have names, and you can reference these names in the targetPort attribute of a Service. For example, we can bind the targetPort of the Service to the Pod port in the following way:

```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app.kubernetes.io/name: proxy
spec:
  containers:
  - name: nginx
    image: nginx:11.14.2
    ports:
      - containerPort: 80
        name: http-web-svc

---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app.kubernetes.io/name: proxy
  ports:
  - name: name-of-service-port
    protocol: TCP
    port: 80
    targetPort: http-web-svc
```
This works even if there is a mixture of Pods in the Service using a single configured name, with the same network protocol available via different port numbers. offers a lot of flexibility for deploying and evolving your Services. For example, you can change the port numbers that Pods expose in the next version of your backend software, without breaking clients.

The default protocol for Services is TCP; you can also use any other supported protocol.

As many Services need to expose more than one port, Kubernetes supports multiple port definitions on a Service object. Each port definition can have the same protocol, or a different one.

Lab Learning Objectives

Update the Service to Use the New Port.

- There is a Service called hive-svc located in the default Namespace. Modify the service so that it listens on port 9076.

Add an init Container to Delay Startup

- The app is managed by the app-gateway Deployment located in the default Namespace. Add an init container to the Pod template so that startup will be delayed by 10 seconds. You can do by using the `busybox:stable` image and running the command `sh -c sleep 10`.

Add an Ambassador Container to Make the App Use the New Service Port.

- Find the app-gateway Deployment located in the default Namespace. Add an ambassador container to the Deployment's Pod template using the haproxy:2.4 image.

- Supply the ambassador container with an haproxy configuration file at /usr/local/etc/haproxy/haproxy.cfg. There is already a ConfigMap called haproxy-config in the default Namespace with a pre-configured haproxy.cfg file.

- You will need to edit the command of the main container so that it points to localhost instead of hive-svc.

Multi-container Pods in Kubernetes use additional containers within the same Pod to solve technical challenges.  lab will allow you to get hands-on with multi-container Pods. You will build expertise as you design your own multi-container Pod in order to address a real-world issue.


## List All Kubernetes Resources (Objects)

[How to List all Resources in a Kubernetes Namespace](https://www.studytonight.com/post/how-to-list-all-resources-in-a-kubernetes-namespace}

To list all the resources (Kubernetes objects) associated to a specific Namespace, you can either use individual kubectl get commands to list each resource one by one, or you can list all the resources in a Kubernetes Namespace by running a single command.

In article we will show you multiple different ways to list all resources in a Kubernetes Namespace.

1. Using kubectl get all

Using the `kubectl get all` command we can list all the pods, services, statefulsets, etc. in a Namespace but not all the resources are listed using command. Hence, if you want to see the pods, services and statefulsets in a particular Namespace then you can use command.

kubectl get all -n studytonight

kubectl get all --all-namespaces

In the above command `studytonight` is the Namespace for which we want to list these resources.

The `k get all` command will get the following resources running in your Namespace, prefixed with the type of resource:

- pod
- service
- daemonset
- deployment
- replicaset
- statefulset
- job
- cronjobs

The `k get all` command will not show the custom resources running in the Namespace.

`k get all` returns an output like the following:

NAME READY STATUS RESTARTS AGE
pod/nginx-59cbfd695c-5v5f8 1/1 Running 4 19h

NAME TYPE CLUSTER-IP EXTERNAL-IP PORT(S) AGE
service/nginx ClusterIP 182.41.44.514 <none> 80/TCP 5d18h

NAME READY UP-TO-DATE AVAILABLE AGE
deployment/nginx 1/1 1 1 19h

2. Using kubectl api-resources

The kubectl api-resources enumerates the resource types available in your cluster.  Use we can use it by combining it with kubectl get

To list every instance of every resource type in a Kubernetes Namespace, use `k api-resources` combined with `k get`:
```
kubectl api-resources --verbs=list --namespaced -o name \
 | xargs -n 1 kubectl get --show-kind --ignore-not-found -n <namespace>
```
In the code above, provide your Namespace in place of <namespace> and can run the above command. For too many resources present in a Namespace, command can take some time.

Alternative command:
```
function kubectlgetall {
  for i in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
    echo "Resource:" $i
    kubectl -n ${1} get --ignore-not-found ${i}
  done
}
```
All we have to do is provide the Namespace while calling the above function. To use the above function, copy the complete code and paste it into the Linux terminal, hit Enter.

Then you can call the function:
```
kubectlgetall studytonight
```
To list all the resources in the studytonight Namespace. function will be available for use in the current session only, once you logout of the machine, change will be lost and you will have to again define the function first and then use it in the next session.

3. Using kubectl get

We can also use the simple kubectl get command to list the resources we want to see in a Namespace. Rather than running kubectl get command for each resource kind, we can run it for multiple resources in one go.

For example, if you want to get pods, services, and deployments for a Namespace, then you would run the following three commands:
```
kubectl get service -n studytonight
kubectl get pod -n studytonight
kubectl get deployment -n studytonight
```
Well you can combine these three commands into a single command too,
```
kubectl get service, pod, deployment -n studytonight
```

Now you know 3 different ways to list all the resources in a Kubernetes Namespace. Personally, I like the second approach where I use the function, because it becomes super easy to use it if you have to frequently see the resources.

## Links

https://joelngwt.github.io/2020/09/25/quick-crash-course-for-setting-up-kubernetes-on-eks.html
