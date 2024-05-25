+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "The Journey of a Microservice: From Source Code to a Full-Blown Kubernetes Deployment"
date = "2021-08-09"

[taxonomies]
tags = ["zero-to-prod"]
+++

![The Journey of a Microservice: From Source Code to a Full-Blown Kubernetes Deployment](/zerotohero-dev/content/images/size/w1200/2024/03/harmony.png)

Introduction
------------

In this lecture, we'll containerize and deploy a [**REST
**ful](https://www.redhat.com/en/topics/api/what-is-a-rest-api) Go microservice
to a [**Kubernetes**](https://kubernetes.io/) cluster. We'll also learn about
some important building blocks of our cluster such
as [`Deployment`](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
s, [`Service`](https://kubernetes.io/docs/concepts/services-networking/service/)
s, [`ConfigMap`](https://kubernetes.io/docs/concepts/configuration/configmap/)
s, [`Secret`](https://kubernetes.io/docs/concepts/configuration/secret/)
s, [`Ingress`](https://kubernetes.io/docs/concepts/services-networking/ingress/)
es, and the like.

Lecture
-------

Deploying a Microservice to Kubernetes

Below, you'll find the **source code** of the projects that we used in this
video, links, resources, and other reference material for you learn and practice
even further.

Read the Source
---------------

Below, you'll find the **zip archives** of the projects and other related
artifacts that we've covered in this article.

* [`fizz-crypto` (**53KB
  ** zip archive)](https://assets.zerotohero.dev/deploying-a-microserve-to-kubernetes/68c3fb40-efdf-497b-8341-25962884db0d/fizz-crypto.zip)
* [`fizz-infra` (**29KB
  ** zip archive)](https://assets.zerotohero.dev/deploying-a-microserve-to-kubernetes/68c3fb40-efdf-497b-8341-25962884db0d/fizz-infra.zip)

The Contents of the .netrc File
-------------------------------

    machine github.com
    login your_github_username_comes_here
    password ghp_your_github_api_key_comes_here
    machine api.github.com
    login your_github_username_comes_here
    password ghp_your_github_api_key_comes_here

The Environment Variables
------------------------------

Here are the environment variables of interest that our builder script uses:

    ECR_REPO=112233445566.dkr.ecr.us-west-2.amazonaws.com
    ECR_IMAGE_FIZZ_CRYPTO=fizz-crypto
    ECR_TAG_FIZZ_CRYPTO=0.0.15

ECR Login Script
----------------

Here's the login script I used in the video:

    aws ecr get-login-password --region us-west-2 | \
    docker login --username AWS --password-stdin \
    1122334455667788.dkr.ecr.us-west-2.amazonaws.com

> **Note**
>
> To use the above script, you need
> to [install and configure AWS CLI](https://www.zerotohero.dev/creating-ecr-repositories/)
> first.

Resources and Additional Reading
--------------------------------

### Services We Used in the Video

* [Amazon Elastic Kubernetes Service](https://aws.amazon.com/eks/)
* [Papertrail: Frustration-free Log Management](https://www.papertrail.com/)

### Kubernetes

* [Kuberetes](https://kubernetes.io/)
* [Kubernetes Special Interest Groups (_SIG_s)](https://github.com/kubernetes-sigs)
* [Kubernetes: Performing a Rolling Update](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/)
* [Configuring Access to Multiple Clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/)
* [Configuring Liveness, Readiness, and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)

### Kubernetes API Objects That We Saw in the Video

* [`Deployment`](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
* [`ReplicaSet`](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)
* [`Service`](https://kubernetes.io/docs/concepts/services-networking/service/)
* [`ConfigMap`](https://kubernetes.io/docs/concepts/configuration/configmap/)
* [`Secret`](https://kubernetes.io/docs/concepts/configuration/secret/)
* [`Ingress`](https://kubernetes.io/docs/concepts/services-networking/ingress/)
* [`Job`](https://kubernetes.io/docs/concepts/workloads/controllers/job/)

### Containers

* [Containers](https://kubernetes.io/docs/concepts/containers/)
* [**Docker Engine** Overview](https://docs.docker.com/engine/)
* [**containerd** Overview](https://containerd.io/docs/)
* [What is **cri-o**](https://cri-o.io/#what-is-cri-o)
* [Managing Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
* [**CRI
  **: Container Runtime Interface](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-node/container-runtime-interface.md)

### Container Images We Used

* [`golang` Official Docker Image](https://hub.docker.com/_/golang)
* [`netshoot`: a Docker + Kubernetes network trouble-shooting swiss-army container](https://github.com/nicolaka/netshoot)

### Building Images

* [`Dockerfile` reference](https://docs.docker.com/engine/reference/builder/)
* [Using multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/)

### Best Practices

* [What is a REST API](https://www.redhat.com/en/topics/api/what-is-a-rest-api)
* [Semantic Versioning](https://semver.org/)

### GitHub Access Tokens

* [`.netrc` File](https://www.gnu.org/software/inetutils/manual/html_node/The-_002enetrc-file.html)
* [Creating **GitHub
  ** Personal Access Tokens](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token)

### Linux

* [.zprofile, .zshrc, .zenv, OMG! What Do I Put Where?! (_a **Zero to Hero**
  article_)](https://www.zerotohero.dev/zshell-startup-files/)
* [`curl`](https://curl.se/)
* [`telnet`](https://en.wikipedia.org/wiki/Telnet)

Conclusion
---------------

That was how you can containerize and deploy a **Go**\-based microservice to a *
*Kubernetes** cluster.

We'll have more **Go** programming and **Kubernetes** deployments in the
upcoming future.

Until next time... May the source be with you 🦄.
