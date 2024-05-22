+++
title = "Unlock Your True Potential: Make Your Hard Work Visible"
date = "2023-01-16"

[taxonomies]
tags = ["highlights"]
+++

![Unlock Your True Potential: Make Your Hard Work Visible](/images/size/w1200/2024/03/stand.png)

> **Update 2024-05-21**
> 
> **Aegis** is now maintained by **VMware Tanzu** GitHub Organization 
> with a new name: **[VMware Secrets Manager](https://vsecm.com/)**.
> 
> It is ready for production use, and as the time of this writing we
> are already using it in production clusters.

Welcome to the 25th issue of **Zero to Hero** Highlights.

Several things have been going on, yet I think this week's highlight was 
[**Aegis**](https://vsecm.com/). It has been very well received by people who
are well-known in the Cloud Native security community, and I have a feeling it
is growing to become a bit more than a side project, but we'll see.

## Aegis: Keep Your Secrets... Secret

As I said, last week was mainly about **Aegis**, but what is **Aegis**?

[**Aegis**](https://github.com/vmware-tanzu/secrets-manager) is a Kubernetes-native,
lightweight secrets management solution that keeps your secrets secret. And last
week, I made significant progress with
it. 

Some key highlights of the current version are:

* Upgraded **Aegis** to the latest and greatest [**SPIRE**](https://spiffe.io/)
  version as the identity control plane. That gave a bunch of stability
  improvements and reduced memory usage significantly.
* A lot of documentation updates to make **Aegis** easier to use and deploy.
* Making everything configurable via environment variables.
* Added **liveness** and **readiness** probes to critical components for
  Kubernetes-native lifecycle management.
* Started using [**distroless images**](https://github.com/GoogleContainerTools/distroless) 
  for an additional layer of security.
* Using [**SPIFFE CSI driver**](https://github.com/spiffe/spiffe-csi) instead of
  volume mounts (_for security again_).

Although **Aegis** is still an alpha product and has yet to be battle-tested, 
I am confident it can be used in a production cluster.

## Random Thought of the Week

In today's fast-paced and competitive business environment, it is essential to
stand out and make your hard work and achievements visible to your management.
Unfortunately, you can fall into the trap of being overlooked as a hidden gem
among your peers, despite your consistent efforts and contributions to the team.

This can be detrimental to career growth and advancement opportunities. So what
are the ways to sort this out, unlock your true potential, and ace your career?

One word: **Take initiative**... Okay, that was two words, but still 🙂.

By sharing your daily progress, goals, and accomplishments with your manager,
you can ensure that your hard work does not go unnoticed.

One effective way to make your work visible is by providing **regular updates**
and participating in huddles with your manager. This allows you to share your
progress on current projects, any challenges you may be facing, and any new
ideas or solutions you have come up with.

By providing this information regularly, you can create a transparent view of
your work for your manager and demonstrate your willingness to actively
collaborate and contribute to the team.

Another critical aspect of making your work visible is sharing real-time metrics
and key performance indicators (**_KPIs_**) with your manager. These metrics
provide valuable insights into the impact and results of your work and
demonstrate your ability to measure and track your progress. This can help your
manager better understand the value you bring to the team and your role in
achieving business goals.

In addition to regular updates and sharing metrics, it is also essential to
**proactively** offer **creative solutions**, volunteer extra time and effort,
and showcase your skill set to help your manager tackle challenges. This
demonstrates your willingness to go above and beyond and showcases your ability
to think outside the box and bring fresh perspectives to the team.

All these can put you on your manager's radar as a valuable asset to the team
and help you get the promotion you deserve.

## Look What I've Found

Here are the things that grabbed my attention this week.

I typically don't share these anywhere else.

Exclusively hand-picked for you 👌. Enjoy.

* [Sampler is a tool for shell commands execution, visualization and alerting](https://sampler.dev/).
* [Airplane is a developer infrastructure for internal tooling](https://www.airplane.dev/).
* [In case you wonder how a unix kernel runs a program, here is a nice article about it](https://0xax.gitbooks.io/linux-insides/content/SysCall/linux-syscall-4.htm).

Thanks a Lot ❤️
---------------

That's all for this week. Next week, I'll gather more unique content and
resources.

So, until next time... May the source be with you 🦄.

## Issues

{{ issues_nav(selected=25) }}
