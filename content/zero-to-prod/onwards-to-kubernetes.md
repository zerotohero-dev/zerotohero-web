+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Zero to Prod in Half an Hour: Part 14: Onwards to Kubernetes"
date = "2022-02-09"

[taxonomies]
tags = ["zero-to-prod"]
+++

Onwards to Kubernetes
=====================

![Onwards to Kubernetes](/zerotohero-dev/content/images/size/w1200/2024/03/eks.png)

As a final step, we'll deploy our application to an AWS EKS Kubernetes cluster
and make sure that it's healthy, up, and running.

Lecture
-------

Zero to Prod in Half an Hour: Part 14 --- Onwards to Kubernetes

Playlist
--------

{{ zero_to_prod_nav(selected = 14) }}

Tools and Technologies Mentioned
--------------------------------

Here are the tools and technologies that were mentioned in the video, along with
related articles and other helpful links.

* [Amazon EKS](https://aws.amazon.com/eks)
* [Amazon ECR](https://aws.amazon.com/ecr/)
* [What is an Application Load Balancer?](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html)
* [Application Load Balancing on Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html)
* [Kubernetes](https://kubernetes.io/)
* [Kubernetes Tools](https://kubernetes.io/docs/tasks/tools/)
* [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
* [Service](https://kubernetes.io/docs/concepts/services-networking/service/)
* [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)
* [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
* [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
* [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
* [Configure Liveness, Readiness, and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)

High-Level Deployment Diagram
----------------------------------

Here's a high-level diagram for the entire Kubernetes deployment.

![Fizz Cluster High-Level Deployment Diagram](/images/2022/02/fizz-cluster-high-level-diagram.png)

Read The Source
---------------

* [Download the source code (_114kb zip
  archive_)](https://assets.zerotohero.dev/zero-to-prod-in-30/zero-to-prod-in-30.zip)

------------

Until the next lecture... May the source be with you 🦄.
