+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Here Are the Repositories, Tools, and Services We'll Use for FizzBuzz Pro"
date = "2021-06-05"

[taxonomies]
tags = []
+++

{{img(
  src="/images/size/w1200/2024/03/shopping.png",
  alt="Go shopping for microservices."
)}}

## Introduction

In this series, we will create **use
case** articles about **FizzBuzz Pro**. Those articles will outline the entire
architecture design, proof of concepts, and development of 
[**FizzBuzz Pro**][fizz-that-buzz] and **Zero to Hero**.

> While we are working hard creating stuff, you'll feel right in the kitchen
> 👩‍🍳.

This is one of those articles where I'm sharing the repository structure and
what kinds of microservices **FizzBuzz Pro** will have.

## Repositories

Here is how I've organized the current repositories in [Tower][git-tower]:

[git-tower]: https://www.git-tower.com/
[fizz-that-buzz]: @/zero-to-prod/fizz-that-buzz.md

{{img(
  src="/images/2021/06/Screen-Shot-2021-06-04-at-8.44.36-PM.png",
  alt="Current Zero to Hero and FizzBuzz Pro repositories."
)}}

Most of the repositories are _empty_ right now; however, the picture above *at
least* gives some structure about which services we will initially design.

Let me briefly go over those repositories:

### **Zero to Hero Design**

* `z2h-ghost-tpl`: The theme of this very page that you are looking at. **Zero
  to Hero** is a [**Ghost**][ghost]-based learning
  management system. This repository contains a customized fork of **Casper**,
  the default **Ghost** theme.

[ghost]: https://github.com/TryGhost/Ghost

### **FizzBuzz Pro** Knowledge Base

* `fizz-buzz`: This is where the meat of **FizzBuzz Pro** will be. It will have
  study notes, questions, answers, strategy recommendations... anything you need
  to become a better competitive programmer to nail that coding interview.

### **FizzBuzz Pro** DevOps and Automation

* `fizz-job-kb`: This is
  a [Kubernetes Job][job]
  that fetches the content from the above `fizz-buzz` repository, does some
  preprocessing and conversion on it and uploads it to
  an [S3 Bucket][s3] for some of the
  microservices to pre-populate their local caches
  using [Init Containers][init-containers].
* `fizz-infra`: Infrastructure-related configurations, descriptors, manifests,
  scripts. This repository will primarily be used by the 
  [**CI/CD**][ci-dd] pipeline.

[job]: https://kubernetes.io/docs/concepts/workloads/controllers/job/
[s3]: https://aws.amazon.com/s3/
[init-containers]: https://kubernetes.io/docs/concepts/workloads/pods/init-containers/
[ci-cd]: https://opensource.com/article/18/8/what-cicd

### **FizzBuzz Pro** Libraries

* `fizz-entity`: Data models and entities that all of the microservices share in
  common.
* `fizz-logging`: Common logging utilities that all of the microservices share.
* `fizz-validation`: Common validation and sanitization methods that all the
  microservices share.
* `fizz-middleware`: HTTP security and tracing middleware that all the
  microservices use in common.
* `fizz-app`: Contains microservice application related middlewares and
  utilities like `Monitor()`, `ListenAndServe()` which decorate and augment
  existing functionality.

### **FizzBuzz Pro** Microservices

* `fizz-idm`: Identity management, users, password reminders, account
  activation, and the like.
* `fizz-store`: Payment gateway integration.
* `fizz-crypto`: Anything cryptography-related: encryption, decryption, token
  generation, token validation, etc.
* `fizz-mailer`: Sends emails from `hermes@fizzbuzz.pro` to places.
* `fizz-questions`: A microservice to serve questions and answers.
* `fizz-notes`: A microservice that serves additional notes and articles.

## External Services to Use

We'll be leveraging third-party "*as a service*" solutions as much as possible
instead of reinventing the wheel so that we can focus on... well... things
like... actually providing some value.

I haven't decided on all of them yet, so things may change down the line. And
here are the initial list of services that I think we'll leverage.

* [**MongoDB Atlas**](https://www.mongodb.com/cloud/atlas)
  for both the database and also the caching layer.  
  --- I doubt it, but if **caching** becomes a more significant issue, we might
  launch an [**Amazon ElastiCache**](https://aws.amazon.com/elasticache/) cluster 
  too. Still, there's no need to use it unless there's a significant lag that a
  caching layer can solve.
* [**Mailgun**](https://www.mailgun.com/) for sending system
  emails and newsletters.
* [**Amazon Elastic Container Registry**](https://aws.amazon.com/ecr/) to 
  push microservice container images.
* [**Amazon EKS**](https://aws.amazon.com/eks) for a managed
  Kubernetes cluster. We don't strictly need Kubernetes, but it'll be fun to
  deploy the infrastructure onto a [
  _Kubernetes_](https://kubernetes.io/) cluster.
* [**Amazon S3**](https://aws.amazon.com/s3/), along with 
  [**Amazon CloudFront**](https://aws.amazon.com/cloudfront/)
  to serve the static web apps.
* [**CloudWatch**](https://aws.amazon.com/cloudwatch/) and 
  **Amazon Container Insights** for monitoring.  
  --- Later on, we might consider a solution like
  [**DataDog**](https://www.datadoghq.com/) for better visibility and
  observability. Still, we'll initially start with what the **AWS** ecosystem
  already provides us.
* [**Papertrail**](https://www.papertrail.com/) for log
  aggregation.  
  --- Related to that, [**Honeybadger**](https://www.honeybadger.io/) for 
  catching and reporting errors.

## Playlist

{{ zero_to_prod_nav(selected = 19) }}

## Conclusion

This is a long journey, and there's **a lot** to do. My first focus is to
develop a "*minimally delightful*" user experience as fast as possible.

I'll share the entire journey with y'all with all of the design, architecture,
and business decisions with complete transparency: There will be lots of use
case articles and videos to cover how **FizzBuzz Pro** is evolving.

> **Aside**
>
> Before I forget, the source code will be private; but I'll share enough of it
> to give you ideas and pointers to use as a starting point if you want to create
> a similar service.

That being said, that's all there is to it for today.

Next, I think I'll start creating some of these services locally. I'll then
ensure that they run on a local **Kubernetes** cluster before deploying them to
a staging **EKS** [*Kubernetes*](https://kubernetes.io/)
cluster.

And until then... may the source be with you 🦄.
