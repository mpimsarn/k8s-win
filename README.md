# Kubernetes on Windows

Scripts for setting up a local hybrid Kubernetes cluster, with a Linux master, Linux worker and Windows worker. Currently deploys:

- Docker 19.03.0
- Kubernetes 1.15.1

> The setup is documented here: [Getting Started with Kubernetes on Windows](https://blog.sixeyed.com/getting-started-with-kubernetes-on-windows/).

## Apps

There are also Kubernetes manifests for some [sample apps](./apps/README.md), running in Windows and Linux pods.

### Credits

The scripts are mostly hacked together from other scripts and docs:

- [Guide for adding Windows Nodes in Kubernetes](https://kubernetes.io/docs/setup/production-environment/windows/user-guide-windows-nodes/)

- [Kubernetes on Windows](https://docs.microsoft.com/en-us/virtualization/windowscontainers/kubernetes/getting-started-kubernetes-windows)



Quick setup — if you’ve done this kind of thing before
or	
https://github.com/mpimsarn/k8s-win.git
Get started by creating a new file or uploading an existing file. We recommend every repository include a README, LICENSE, and .gitignore.

…or create a new repository on the command line
echo "# k8s-win" >> README.md
git init
git add README.md
git commit -m "first commit"
git remote add origin https://github.com/mpimsarn/k8s-win.git
git push -u origin master
                
…or push an existing repository from the command line
git remote add origin https://github.com/mpimsarn/k8s-win.git
git push -u origin master
…or import code from another repository
You can initialize this repository with code from a Subversion, Mercurial, or TFS project.
