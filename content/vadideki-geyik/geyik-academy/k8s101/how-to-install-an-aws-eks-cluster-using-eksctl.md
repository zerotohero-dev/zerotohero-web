+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "TBD"
date = "2021-06-02"

[taxonomies]
tags = ["kubernetes"]
+++

{{img(
  src="/images/size/w1200/2024/03/pipeline.png",
  alt="A cluster."
)}}

## Introduction

In this article, we'll provision a managed **Kubernetes** cluster on an **AWS** 
cloud, and we'll also look into some of the alternatives.

## Why Managed Kubernetes?

But why do we use managed **Kubernetes** in the first place? I mean, is it that 
hard to create a [Control Plane][control-plane] using something like 
[`kubeadm`][kubeadm]?

Well, yes, and no. Provisioning a cluster with `kubeadm` is relatively easy; 
however, it's still a lot of work to **maintain**, **secure**, **update**, and 
**upgrade** that cluster. By using a *managed* Kubernetes solution, you push 
that maintenance and security burden to your cloud provider, and you can focus 
on your worker nodes instead.

[control-plane]: https://kubernetes.io/docs/reference/glossary/?all=true#term-control-plane
[kubeadm]: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

Managed Kubernetes Service in the Cloud
---------------------------------------

When it comes to "_Kubernetes as a Service_", you have several options to pick from.

*   [**EKS** from Amazon Web Services](https://aws.amazon.com/eks/)
*   [**AKS** from Microsoft Azure](https://docs.microsoft.com/en-us/azure/aks/intro-kubernetes)
*   And [**GKE** from Google](https://cloud.google.com/kubernetes-engine).

All of these platforms are [**CNCF-conformant**](https://www.cncf.io/certification/software-conformance/), which means "_in theory_", it's relatively easy to migrate your **Kubernetes** workloads from one cluster to another. In practice, though, "_vendor lock-in is real_", so it still makes sense to spend time reviewing all of the offerings and pick the cluster that suits your needs best.

For example, if you want your control plane to be upgraded automatically, you might like to choose **GKE**; on the other hand, if you want more control over your control plane's upgrade cycles, you might choose either **AKS** or **EKS**.

If you want the most advanced **Kubernetes** version, then **GKE** would be a better option. On the other hand, if **cost** is your primary concern, then **AKS** would be preferable since both **EKS** and **GKE** charge for the control plane, while **AKS** doesn't.

In short, although all of the big players offer "_more or less_" the same feature set, the devil is in the details, and you'd be better off if you do your research beforehand.

Why EKS?
--------

That leads to the follow-up question: "_Why are we choosing **EKS** for_ [**_FizzBuzz Pro_**](https://fizzbuzz.pro/)_?_". Well, it's mostly for convenience. We'll be using other **AWS** services, so having our cluster initiated in an **AWS** cloud will better integrate with a less operational headache. Yes, that also means we will likely be vendor-locked-in; however, that's a calculated risk to take.

Installing an EKS Cluster
------------------------------

There are two ways to install an **EKS** cluster.

*   Using the **AWS Console** Web UI.
*   Using the `eksctl` command-line utility.

In this article, I will cover the second option, as it appears to be the option that everyone chooses to follow; it works out of the box. Unfortunately, setting things up using **AWS Console** is a more tedious---and error-prone---process.

Installing AWS CLI
------------------

Before moving any further, make sure that you have [AWS CLI installed and configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) on your system.

To test that, you can type `aws --version` in your terminal.

Here is what I get when I do it:

    $ aws --version
    aws-cli/2.2.9 Python/3.8.8 Darwin/20.5.0 exe/x86_64 prompt/off
    

If this command fails for you, [follow these instructions to install **AWS CLI** to your system](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html).

In my case, it was [fetching the latest **Mac OS** Binary](https://awscli.amazonaws.com/AWSCLIV2.pkg), then following the on-screen instructions.

This one is important:

> **Caveat**  
>   
> Make sure that the user installing **EKS** is the same user you configure to use the AWS CLI.  
>   
> Why? Because initially, only the user who created the EKS cluster can access and modify the cluster. So if your AWS CLI user and the user you use to provision your EKS cluster are not the same, you'll have to do some RBAC gymnastics that you don't, otherwise, have to do.

You can always change your users and assign different users with different roles to your cluster. That being said, I've found it's hassle-free first to configure the cluster with an admin-level user and then set up a fine-grain access control later.

Configuring IAM Policies
------------------------

After installing AWS CLI, you need to configure it to authenticate you with AWS services.

If you don't have an access key yet, navigate to the IAM console of the user that you are going to use, create an access key, and **download** a csv export of the access key.

![Creating an access key on the AWS IAM console.](/images/2021/07/Screen-Shot-2021-07-28-at-12.57.01-PM.png)

Creating an access key on the AWS IAM console.

Also, for my user, I **at least** provide `AdministratorAccess` as a permission, because _at the very least,_ when provisioning Kubernetes resources, the user will have to touch **a lot** of AWS infrastructure from CloudFormation Templates to Network ACLs, Subnet mappings, Security groups, to actually provisioning and configuring EC2 instances.

![IAM Policies.](/images/2021/07/Screen-Shot-2021-07-28-at-1.03.41-PM.png)

IAM Policies.

If you want to be more granular, or if you are not comfortable with giving admin access to your user, then the following policies can be a starting point:

*   `AmazonEC2FullAccess`
*   `AWSCloudFormationFullAccess`
*   `EksAllAccess`
*   `IamLimitedAccess`

If you see any errors during EKS provisioning, you may want to add more policies to this chain, but those should be **good enough** for most cases.

Configuring AWS CLI
-------------------

Once you set up your policies, downloaded your IAM credentials, and ensured that AWS CLI is installed on your system, now it's time to set up the AWS CLI. You can configure your AWS client by executing `aws configure` on the terminal:

    ➜  ~ aws configure
    AWS Access Key ID [****************ABCD]: 
    AWS Secret Access Key [****************DEFG]: 
    Default region name [us-west-2]: 
    Default output format [yaml]: 
    

Verifying AWS CLI Configuration
-------------------------------

After you enter your **Access Key ID** and **Secret** and answer a bunch of questions, the installer will create an `~/.aws` folder for you:

    $ pwd
    /Users/volkan/.aws
    
    $ tree
    .
    ├── config
    ├── credentials
    
    $ cat config
    [default]
    region = us-west-2
    output = yaml
    
    $ cat credentials
    [default]
    aws_access_key_id = your_access_key_id
    aws_secret_access_key = your_secret
    

If you see all these, your AWS Client is all set. Next up is installing `eksctl`.

Installing `eksctl`
-------------------

`eksctl` is a command-line utility for creating and managing clusters on **EKS**. It's written in **Go** and uses AWS **CloudFormation**.

You can [follow the official `eksctl` installation instructions on **AWS**](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html) to set it up in your system.

In my case it is, installing [**HomeBrew**](HomeBrew) first:

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    

Then adding the necessary **tap** to **HomeBrew**:

    brew update
    brew tap weaveworks/tap
    

Followed by installing `eksctl`:

    brew install weaveworks/tap/eksctl
    

Verifying `eksctl` Installation
-------------------------------

If you get a successful response to `eksctl version`, then you have set it up correctly, and we can move to the next step.

    $ eksctl version
    0.57.0
    

Provisioning Our Cluster
------------------------

> **Caveat**  
>   
> Provisioning an **EKS** cluster costs a non-trivial amount of money. You  
> not only pay for the control plane, but also you'll pay for any resources  
> that `eksctl` provisions.  
>   
> As of this writing, aside from provisioning the control plane, `eksct` creates two `m5.large` EC2 instances by default. And those instances are **not** cheap.  
>   
> So if you are experimenting with things, make sure to **tear down**  
> your cluster once you are done to avoid additional costs.

Okay, since you have been warned, let's move to the fun part.

[You can follow the detailed instructions here](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html). In this article, I'll just summarize what I did to provision the **FizzBuzz Pro** EKS cluster.

Create a Key Pair
-----------------

Let's create a key pair first and **note it down**.

    aws ec2 create-key-pair --region us-west-2 --key-name fizz-kp
    

I am using `us-west-2` as the region because it's closer to where I live, and also it is one of the AWS regions that typically new/experimental AWS services and features are introduced first.

Create the Kubernetes Cluster
----------------------------------

After all this prep work, creating the Kubernetes cluster is a one-liner:

    eksctl create cluster \
    --name fizz-cluster \
    --region us-west-2 \
    --with-oidc \
    --ssh-access \
    --ssh-public-key fizz-kp \
    --managed
    

This process will take up to half an hour, and in the end, you'll have a new shiny EKS cluster with all its glory.

![EKS cluster overview.](/images/2021/07/Screen-Shot-2021-07-28-at-1.48.20-PM.png)

EKS cluster overview.

![EKS cluster workloads.](/images/2021/07/Screen-Shot-2021-07-28-at-1.48.38-PM.png)

EKS cluster workloads.

![EKS cluster addons.](/images/2021/07/Screen-Shot-2021-07-28-at-1.49.03-PM.png)

EKS cluster addons.

> **Caveat**  
>   
> The cluster add-ons `kube-proxy`, `coredns`, and `vpc-cni` are **NOT** enabled by default, and you'll most likely **need them**.  
>   
> Navigate to "**Configuration » Add-ons**" and manually enable them.

And, just like that, we've created a **Kubernetes** cluster using `eksctl`.

Resources and Additional Reading
--------------------------------

### Kubernetes Basics

*   [Kubernetes Components](https://kubernetes.io/docs/concepts/overview/components/)
*   [Kubernetes Concepts](https://kubernetes.io/docs/concepts/)
*   [Control Plane](https://kubernetes.io/docs/reference/glossary/?all=true#term-control-plane)

### Cloud Native

*   [Cloud Native Computing Foundation](https://www.cncf.io/)
*   [CNCF Software Conformance](https://www.cncf.io/certification/software-conformance/)

### Kubernetes Providers

*   [AWS **EKS**](https://aws.amazon.com/eks/)
*   [Azure **AKS**](https://docs.microsoft.com/en-us/azure/aks/intro-kubernetes)
*   [Google **GKE**](https://cloud.google.com/kubernetes-engine)
*   [Kubernetes as a Service: GKE vs. AKS vs. EKS](https://logz.io/blog/kubernetes-as-a-service-gke-aks-eks/)

### Kubernetes Tooling

*   [Creating a Cluster with `kubeadm`](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)

AWS Tooling
----------------

*   [AWS IAM Policies and Permissions](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html)
*   [Installing and Configuring AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

### `eksctl`

*   [`eksctl` User Guide](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
*   [Getting Started With `eksctl`](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html)
*   [`eksctl` Home](https://eksctl.io/)

Conclusion
---------------

In this article, we have seen how we can create a managed **Kubernetes** cluster on **AWS** using `eksctl`.

Coming up next:

*   We'll see how we can **containerize** and **register** our microservices to **AWS ECR** as container images;
*   Create **Deployment Manifests** for, `ConfigMap`s, `Secret`s, `Service`s, and `Deployment`s
*   And **deploy** our microservices to our cluster using the above manifests that we've created.

After all of these are done, I plan to talk about each service, one by one.

So, as always, there's a lot to cover.

Stay tuned... And, may the source be with you 🦄.
