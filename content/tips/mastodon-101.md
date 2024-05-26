+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Who Else Wants to Have Their Own Mastodon Server?"
date = "2023-01-01"

[taxonomies]
tags = ["tips", "setups", "mastodon"]
+++

![Who Else Wants to Have Their Own Mastodon Server?](/images/size/w1200/2024/03/eli.png)

## Introduction

> **Update** (2024-03-05)
>
> [I am back on Twitter](https://twitter.com/vadidekivolkan) . I still think
> Elon is a terrible human being and he does not know jack shit about what he's
> doing; however, Twitter is still the best way to represent the communities I
> represent, and spread the word around when needed. I have other reasons to be
> back, which I'll try to expand in this sidenote a bit.
>
> For starters, when you see everyone who despises Elon, still continue
> tweeting, it does not make sense to shield you away. I tried that for at
> least six months. For **six freaking months**, I was only at Mastodon, not even
> glancing at Twitter. But when I checked back, I realized every single person who
> was against Elon was still on the platform.
>
> If we don't move as a community, my individual resistance is just futile, 
> and even counterproductive. So, I'm still on the platform. Yes, Twitter
> is a racist, sexist, misogynistic, hatred-fulled dumspster fire; however, no
> alternative platform has been strong enough to force it to extinction. For
> whatever reason, it's still around.
>
> The current Twitter is like a democracy ran by a tyrant. People are 
> (_still_) there, because no matter how much it sucks, it is the only platform 
> that helps them connect to the world at scale. When you run away, you isolate 
> yourself.
>
> Social isolation is the opposite of social media: Nobody wants that.
>
> So, as long as there is no significant competitor to take its place, this hell
> hole of a birdsite will continue to exist. And I will be there being myself, not
> giving a flying clue to others.

After [all](https://www.washingtonpost.com/business/2022/11/09/elon-musk-how-not-to-fire-employees/) 
[the](https://www.wired.com/story/twitter-users-mastodon-meltdown/) [madness](https://variety.com/2022/digital/news/mark-cuban-slams-elon-musk-twitter-verification-plan-nightmare-1235429190/)
that has been happening in the birdsite,
I flipped the switch and [joined Mastodon (on Hachyderm, 
where all the misfits hang out)](http://hachyderm.io/@volkan).

With that, I have also wanted to create my own Mastodon instance for a while.

This article summarizes my experiences with the process and provides tips and
tricks to those who wish to follow the same path.

> **This Article Applies to** **Mastodon v3.5.3**
>
> The article here discusses my deployment experience for v3.5.3 of Mastodon. If
> you are deploying a different
> version, [make sure to follow the official installation guides](https://github.com/mastodon/mastodon).
>
> I've recently upgraded to a much newer version, and the installation/upgrade
> experience was **very** smooth.

## What Is a Mastodon Instance?

> **Interested? Check Out Fedi.Tips**
>
> For those new to the concept and want to learn more about **Mastodon** and the
**Fediverse**, [fedi.tips](https://fedi.tips/) is a great reference.

To sum it up at a very high level, **Fediverse** is a collection of
independently-run servers. You can create an account in any one of them and
follow, like, comment, and otherwise interact with anyone else with thousands of
other servers.

It's like you have a passport tied to a single country. And with that passport,
you can visit any country you like and interact with the people and culture
there. So that's where the "_Fed_" of the **Fediverse** comes from: It is "
_federated_."

Though, if you are at a point to deploy your own Mastodon instance, you probably
already know that 😀.

## Why Would You Want Your Own Instance?

So, why would anyone want to create their own **Mastodon** instance?

The first thing is, with your instance, you have total control over the content
and the community. If you are a **content creator** or someone with relatively
high visibility, it makes perfect sense to have your own Mastodon instance and
interact with people who want the hear what you have to say there.

With this approach, you manage your identity instead of letting your identity
become an advertising opportunity for a billion-dollar corporation.

Secondly, use it as a **microblog**, where you gather your thoughts and share
one-off ideas. If they are not that interesting to others, who cares 🤷‍♂️? It's
your instance, server, ideas, and rules. I use my instance 
to write down random _to-do_ notes, share bookmarks to things I might not easily
find later, and so on. 

Or you can do it out of **curiosity**: To have fun exploring new technology,
because you can 🙂. No matter your intention, if you want to create your
instance, here is my recent experience.

> **z2h.dev is my Little Kingdom**
>
> As of now, I'm running a single-person instance. Like, it's only me on the
> server, sharing my random stuff. Yet, it's public; so people still come and go
> and occasionally like and boost the content too.

Having a single-person instance, my compute requirements are minimal. Keep in
mind that as the number of users in your instance increase, so will your compute
requirements.

Mastodon can be a beast to scale up, especially if your community is active,
vibrant, and highly engaged. Which also is an excellent segue to the next
section.

## The Infra

Here's my current setup:

* A single dedicated [**Linode**](https://www.linode.com/) server with 2 CPU
  cores and 4 GB of Memory.
* [**Amazon S3**](https://aws.amazon.com/pm/serv-s3/) is the backing data store
  for static assets.
* [**Amazon CloudFront**](https://aws.amazon.com/cloudfront/) as a CDN layer in
  front of **S3**.
* [**AWS Certificate Manager**](https://aws.amazon.com/certificate-manager/) to
  manage TLS certificates for the static assets (files.z2h.dev).
* [**Certbot**](https://certbot.eff.org/) to do the same for the content at
  z2h.dev.
* **Linode DNS**, to manage the DNS records on the Linode end.
* **Linode Cloud Firewall** because I want my box to be safe.
* **Linode Backups** because I don't want to worry about losing data.
* [**Mailgun**](https://www.mailgun.com/) as the SMTP server because using a
  local SMTP can be problematic, especially when/if I want to extend the server
  to a larger audience. You should
  follow [Mailgun's official documentation](https://documentation.mailgun.com/)
  for SMTP configuration.

Here's what my current server utilization looks like:

![Linode server utilization](/images/2022/11/Screenshot-2022-11-12-at-7.48.38-AM.png)

It's not much because there is not much going on. Yet, it also shows that the
above specs are more than adequate to run your own Mastodon instance.

## Server Version

I'm running an Ubuntu server (_which_ [_Mastodon official
docs_](https://docs.joinmastodon.org/admin/install/) _recommend, too_) with the
following version:

```txt
Distributor ID:	Ubuntu
Description:    Ubuntu 22.10
Release:        22.10
Codename:       kinetic
```

## Compute and Memory Requirements

Regarding resource utilization, I'm coasting at **1GB** of ram and almost zero
CPU (because only one person, me, is posting). So if you want to run a
single-person instance, a VPS that gives you 2gigs of RAM and some minimal CPU
would work for your needs.

Though, your compute, and memory requirements be **much** higher depending on
the traffic and activity on your instance.

## Securing The Machine

Since this is a [**Linode**](https://www.linode.com/) box, I've followed Linode'
s security recommendations. I won't detail them here because the way you secure
your system will also depend on what you plan to use; however, you can follow
the excellent documentation that Linode has on those topics:

* [Setting Up and Securing a Compute Instance](https://www.linode.com/docs/guides/set-up-and-secure/)
* [Using Fail2ban to Secure Your Server](https://www.linode.com/docs/guides/using-fail2ban-to-secure-your-server-a-tutorial/)
* [Set Up a Web Server and Host a Website](https://www.linode.com/docs/guides/set-up-web-server-host-website/)

## Firewall Rules

I don't have that complicated of a firewall setup. Here is what it looks like:

![Firewall rules](/images/2022/11/Screenshot-2022-11-12-at-8.00.11-AM.png)

* **Inbound**  
  * Allow inbound ssh to a single IP
  * Accept all inbound HTTP 
  * Accept all inbound HTTPS
  * Deny everything else
* **Outbound**  
  * Allow everything

Which is good enough for the purpose of this application.

## DNS Settings

For the sake of completeness, I'll share the DNS settings too. Here's what it
looks like:

![SOA, NS, MX, A, AAAA](/images/2022/11/Screenshot-2022-11-12-at-8.03.45-AM.png)

![CNAME, TXT, SRV, CAA](/images/2022/11/Screenshot-2022-11-12-at-8.03.57-AM.png)

The **CNAME** records are there for [**Mailgun**](https://www.mailgun.com/) to
be able to validate the domain; you can check its documentation for instructions
about how to set it up.

Also, note that a **CNAME** record for files.z2h.dev points to an 
[**Amazon CloudFront**](https://docs.aws.amazon.com/AmazonCloudFront) CDN; 
we'll come to that soon.

The **TXT** records are for [**Mailgun SPF Validation
**](https://www.mailgun.com/blog/deliverability/spf-records-basics/) and for 
[**AWS Certificate Manager**](https://aws.amazon.com/certificate-manager/) to
issue and verify certificates to the static assets served at files.z2h.dev on an
AWS S3 bucket.

## CloudFront Setup

The thing about **Mastodon** is it will store files. Lots of files. Images,
memes, animated gifs, videos... they need to go somewhere. And the local disk of
your machine is not the best place to put them.

In my current setup, I'm using an **S3** bucket backed up by **CloudFront** to
sort that out.

Here are the **CloudFront** distribution settings for files.z2h.dev for
reference:

![CloundFront: Main Settings](/images/2022/11/Screenshot-2022-11-12-at-8.19.45-AM.png)

![CloudFront: Origin Settings](/images/2022/11/Screenshot-2022-11-12-at-8.20.10-AM.png)

![CloudFront: Behaviors](/images/2022/11/Screenshot-2022-11-12-at-8.20.20-AM.png)

## S3 Bucket Settings

The **CloudFront** uses an **S3 Bucket** as its origin. Here are the details of
the bucket.

I have set up a **bucket policy** to publicly allow GET operations on the
bucket.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Allow Public Access to All Objects",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::files.z2h.dev/*"
        }
    ]
}
```

I also had to [**enable access control lists**](https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html) on
the bucket for my **Mastodon** instance to push stuff to it without raising
errors. So here's how that part looks on the console:

![Bucket ACL Rules](/images/2022/11/Screenshot-2022-11-12-at-8.44.55-AM.png)

Without these ACL rules, Mastodon could not upload files to the bucket.

Other than that, everything on the bucket is in its default settings.

## Setting Up Mastodon The Hard Way

Now, we come to the fun part. You can install **Mastodon**

* As a set of **Docker** containers (using docker-compose).
* As a **Kubernetes** deployment.
* Or as a bare-metal installation directly on your server.

I tried the **Docker** installation route but could not make it work. It might
be because I was using an RC version instead of a stable one, or maybe because I
missed a step during the installation; however, I had better luck with the
bare-metal installation, so I'll explain that in this article.

Besides, a bare-metal install will give you the best performance benefit
compared to the alternatives.

So there are no helm templates, no Docker compose files... We're gonna do this 
**the hard way** ([_Kelsey_](https://github.com/kelseyhightower/kubernetes-the-hard-way), anyone?)

## You'll Need An Older Version of `yarn`

One of the most significant issues you are likely going to
face [is if you follow the official docs](https://docs.joinmastodon.org/admin/install/).
As of the time of this writing (_late 2022_), the docs' instruction on
installing `node` and `yarn` is inadequate and incomplete, and if you follow
them step-by-step, you'll likely fail while bundling the static assets.

The gist is:

* You need an **older** version of `yarn` (**_v1.x_**) to bundle static assets.
* However, you need **the most recent** `node` version for security and
  stability.

I was able to do that by...

* Installing the recent versions of `node` and yarn on the system,
* And then patching the `yarn`
  binaries [with the most recent v1.x release that I could find](https://github.com/yarnpkg/yarn/releases/tag/v1.22.19).

The following sections outline how I managed to do that.

## Install `node` and `npm`

First, install the recent version of `node` and `npm`:

```bash
sudo apt install curl wget gnupg apt-transport-https \
lsb-release ca-certificates

# Install node.
# You can also try a newer version of Node.
# I'm using v18.x as of now.
curl -sL https://deb.nodesource.com/setup_18.x | bash -

# Check node and npm versions.

node -v
# v18.7.0

npm -v
# 6.14.17
```

> **You Might Want to Use `nvm`**
>  
> Note that you might want to use [`nvm` (_Node Version Manager_)](https://github.com/nvm-sh/nvm)  
> to switch between different versions of `node`.
> That might be helpful if your Mastodon instance does not function  
> properly using a particular version of `node`.

## Create an Unprivileged `mastodon` User

The next thing is to create a dedicated user to run **Mastodon**. This is *
*recommended** because Mastodon is a [ruby](https://www.ruby-lang.org/en/)
monolith, and switching to different user accounts is a hassle-free way to
experiment with different Ruby versions.

Besides, having a dedicated, unprivileged user is a good security practice.

```bash
# Add a `mastodon` user, if you haven't already done so
adduser --disabled-login mastodon
# Set a password for the user:
sudo passwd mastodon
# Switch to that user:
sudo su - mastodon

# Validate that we are on the correct user accout:
whoami
# mastodon
```

## Configure `npm` to Work Without Root Privileges

Next, we'll configure `npm` to work rootless because we are not allowed to
do `sudo` for the `mastodon` user.

```bash
sudo su - mastodon

mkdir ~/.npm-global
npm config set prefix '~/.npm-global'

# Update ~/.profile with this:
# export PATH=~/.npm-global/bin:$PATH

# Then source it to use the new $PATH:
source ~/.profile
```

## Patch `yarn`

**This is the critical part**. You'll need to use the `**v1.x**` version
of `yarn` (_at least when this article is written, that's the case_). If you
install `yarn` following the documentation, you'll get a much higher version,
which will cause errors when bundling static asses for the web application.

```bash
sudo su - mastodon

wget https://github.com/yarnpkg/yarn/releases/\
download/v1.22.19/yarn-v1.22.19.tar.gz

tar -xzvf yarn-v1.22.19.tar.gz 

cd yarn-v1.22.19/
cd bin/
cp yarn /home/mastodon/.npm-global/bin/
cp yarnpkg /home/mastodon/.npm-global/bin/
cd ..
cp bin/* /home/mastodon/.npm-global/bin
```

That will hopefully take care of your possible `yarn` problems. If not, you can
find yourself experimenting with things a bit. Honestly, this version
incompatibility was the most challenging part. That took **hours** for me to
fix. I'm sharing it here so that others don't suffer the same pains I've had.

## Install Postgres

Mastodon uses Postgres (_or any Postgres-compatible DB_) as its backend
database. So, we'll install that to our instance too.

```bash
sudo su

wget -O /usr/share/keyrings/postgresql.asc \ 
https://www.postgresql.org/media/keys/ACCC4CF8.asc

echo "deb [signed-by=/usr/share/keyrings/postgresql.asc] \
http://apt.postgresql.org/pub/repos/apt \
$(lsb_release -cs)-pgdg main" \
> /etc/apt/sources.list.d/postgresql.list

apt update

apt install -y \
  imagemagick ffmpeg libpq-dev libxml2-dev libxslt1-dev \
  file git-core g++ libprotobuf-dev protobuf-compiler \
  pkg-config nodejs gcc autoconf \
  bison build-essential libssl-dev libyaml-dev libreadline6-dev \
  zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev \
  nginx redis-server redis-tools postgresql postgresql-contrib \
  certbot python3-certbot-nginx libidn11-dev libicu-dev \
  libjemalloc-dev
```

## Install Ruby

Mastodon is a [Ruby](https://ruby-lang.org/) server, so we'll, for sure,
need `ruby`.

```bash
su - mastodon

git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

exec bash

git clone https://github.com/rbenv/ruby-build.git \
~/.rbenv/plugins/ruby-build
```

Once that's done, install the `ruby` version that we need:

```bash
RUBY_CONFIGURE_OPTS=--with-jemalloc rbenv install 3.0.3
rbenv global 3.0.3
```

We'll also need `bundler`:

```bash
gem install bundler --no-document
```

## Configure Postgres

Next up, we'll configure our database:

```bash
sudo -u postgres psql

CREATE USER mastodon CREATEDB;
\q
```

And, that's it 🙌.

## Set Up Mastodon

Now it's time to set up the elephant in the room.

We'll build **Mastodon** straight from the source code.

```bash
git clone https://github.com/tootsuite/mastodon.git \
live && cd live
git checkout \
$(git tag -l | grep -v 'rc[0-9]*$' | sort -V | tail -n 1)

bundle config deployment 'true'
bundle config without 'development test'
bundle install -j$(getconf _NPROCESSORS_ONLN)
yarn install --pure-lockfile
```

After all these set, we'll run the interactive setup wizard:

```bash
RAILS_ENV=production bundle exec rake mastodon:setup
```

The wizard will ask you certain questions. I've added my answers to some of
those, redacting sensitive parts.

```bash
LOCAL_DOMAIN=z2h.dev
SINGLE_USER_MODE=false
DB_HOST=/var/run/postgresql
DB_PORT=5432
DB_NAME=mastodon_production
DB_USER=mastodon
DB_PASS=
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
S3_ENABLED=true
S3_PROTOCOL=https
S3_BUCKET=files.z2h.dev
S3_REGION=us-west-2
S3_HOSTNAME=s3.us-west-2.amazonaws.com
AWS_ACCESS_KEY_ID=AKIA[REDACTED]
AWS_SECRET_ACCESS_KEY=Yj[REDACTED]
S3_ALIAS_HOST=files.z2h.dev
SMTP_SERVER=smtp.mailgun.org
SMTP_PORT=587
SMTP_LOGIN=postmaster@z2h.dev
SMTP_PASSWORD=b[REDACTED]
SMTP_AUTH_METHOD=plain
SMTP_OPENSSL_VERIFY_MODE=none
SMTP_FROM_ADDRESS='Mastodon <notifications@z2h.dev>'
```

Once the installer finishes successfully, you'll get a prompt similar to this:

```txt
All done! You can now power on the Mastodon server 🐘

Do you want to create an admin user straight away? Yes
Username: $usernameYouChoseDuringSetup
E-mail: $emailYouChoseDuringSetup
You can login with the password: $someRandomPassword
You can change your password once you login.
```

> **The Installer Gave Me an `emoji-mart`-Related Error**
>
> Before triggering the setup, I also had to manually  
> `npm install --save emoji-mart` in the `live` folder  
> because the installer complained otherwise.
>
> I don't know if it will be fixed by the time you use the latest and  
> greatest Mastodon. Yet, I wanted to share it here in case you  
> bump into a similar issue.

## Getting TLS Certificates

Once you have your compute instance, DNS, and ingress firewall set up, you can
fetch a TLS certificate from [Let's Encrypt](https://letsencrypt.org/)
using [`certbot`](https://certbot.eff.org/):

```bash
sudo certbot certonly --standalone -d z2h.dev
```

The command above will temporarily spin up a web server, do the necessary
negotiations and fetch a TLS certificate for the domain `z2h.dev`.

Also, ensure that certbot timer is enabled via `systemctl status certbot.timer`.
If the timer is not enabled, make sure to enable it
using `systemctl enable certbot.timer`.

```txt
volkan@z2h-dev:~$ systemctl status certbot.timer
● certbot.timer - Run certbot twice daily
     Loaded: loaded (/lib/systemd/system/certbot.timer; 
enabled; preset: enabled)
     Active: active (waiting) 
since Fri 2022-11-11 03:02:18 PST; 1 day 9h ago
      Until: Fri 2022-11-11 03:02:18 PST; 1 day 9h ago
    Trigger: Sat 2022-11-12 22:37:01 PST; 10h left
   Triggers: ● certbot.service
```

Also, make sure that your certificates are where they need to be:

```bash
sudo ls -al /etc/letsencrypt/live/z2h.dev

# The output should look something like this:
# drwxr-xr-x 2 root root 4096 Nov 11 02:41 .
# drwx------ 3 root root 4096 Nov 11 02:41 ..
# lrwxrwxrwx 1 root root   31 Nov 11 02:41 cert.pem 
# -> ../../archive/z2h.dev/cert1.pem
# lrwxrwxrwx 1 root root   32 Nov 11 02:41 chain.pem 
# -> ../../archive/z2h.dev/chain1.pem
# lrwxrwxrwx 1 root root   36 Nov 11 02:41 
# fullchain.pem -> ../../archive/z2h.dev/fullchain1.pem
# lrwxrwxrwx 1 root root   34 Nov 11 02:41 privkey.pem 
# -> ../../archive/z2h.dev/privkey1.pem
# -rw-r--r-- 1 root root  692 Nov 11 02:41 README
```

## Configure NGINX

Now that we have our certificates in place, we can configure **NGINX**.

Here's my `/etc/nginx/sites-available/z2h.dev.conf`

```txt
map $http_upgrade $connection_upgrade {
  default upgrade;
  ''      close;
}

upstream backend {
    server 127.0.0.1:3000 fail_timeout=0;
}

upstream streaming {
    server 127.0.0.1:4000 fail_timeout=0;
}

proxy_cache_path /var/cache/nginx levels=1:2 
  keys_zone=CACHE:10m inactive=7d max_size=1g;

server {
  listen 80;
  listen [::]:80;
  server_name z2h.dev;
  root /home/mastodon/live/public;
  location /.well-known/acme-challenge/ { allow all; }
  location / { return 301 https://$host$request_uri; }
}

server {
  listen 443 ssl http2;
  listen [::]:443 ssl http2;
  server_name z2h.dev;

  ssl_protocols TLSv1.2 TLSv1.3;
  ssl_ciphers HIGH:!MEDIUM:!LOW:!aNULL:!NULL:!SHA;
  ssl_prefer_server_ciphers on;
  ssl_session_cache shared:SSL:10m;
  ssl_session_tickets off;

  # Uncomment these lines once you acquire a certificate:
  ssl_certificate     /etc/letsencrypt/live/z2h.dev/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/z2h.dev/privkey.pem;

  keepalive_timeout    70;
  sendfile             on;
  client_max_body_size 80m;

  root /home/mastodon/live/public;

  gzip on;
  gzip_disable "msie6";
  gzip_vary on;
  gzip_proxied any;
  gzip_comp_level 6;
  gzip_buffers 16 8k;
  gzip_http_version 1.1;
  gzip_types text/plain text/css application/json 
    application/javascript text/xml application/xml 
    application/xml+rss text/javascript 
    image/svg+xml image/x-icon;

  location / {
    try_files $uri @proxy;
  }

  location = /sw.js {
    add_header Cache-Control 
      "public, max-age=604800, must-revalidate";
    add_header Strict-Transport-Security 
      "max-age=63072000; includeSubDomains";
    try_files $uri =404;
  }

  location ~ ^/assets/ {
    add_header Cache-Control 
      "public, max-age=2419200, must-revalidate";
    add_header Strict-Transport-Security 
      "max-age=63072000; includeSubDomains";
    try_files $uri =404;
  }

  location ~ ^/avatars/ {
    add_header Cache-Control 
      "public, max-age=2419200, must-revalidate";
    add_header Strict-Transport-Security 
      "max-age=63072000; includeSubDomains";
    try_files $uri =404;
  }

  location ~ ^/emoji/ {
    add_header Cache-Control 
      "public, max-age=2419200, must-revalidate";
    add_header Strict-Transport-Security 
      "max-age=63072000; includeSubDomains";
    try_files $uri =404;
  }

  location ~ ^/headers/ {
    add_header Cache-Control 
      "public, max-age=2419200, must-revalidate";
    add_header Strict-Transport-Security 
      "max-age=63072000; includeSubDomains";
    try_files $uri =404;
  }

  location ~ ^/packs/ {
    add_header Cache-Control 
      "public, max-age=2419200, must-revalidate";
    add_header Strict-Transport-Security 
      "max-age=63072000; includeSubDomains";
    try_files $uri =404;
  }

  location ~ ^/shortcuts/ {
    add_header Cache-Control 
      "public, max-age=2419200, must-revalidate";
    add_header Strict-Transport-Security 
      "max-age=63072000; includeSubDomains";
    try_files $uri =404;
  }

  location ~ ^/sounds/ {
    add_header Cache-Control 
      "public, max-age=2419200, must-revalidate";
    add_header Strict-Transport-Security 
      "max-age=63072000; includeSubDomains";
    try_files $uri =404;
  }

  location ~ ^/system/ {
    add_header Cache-Control 
      "public, max-age=2419200, immutable";
    add_header Strict-Transport-Security 
      "max-age=63072000; includeSubDomains";
    try_files $uri =404;
  }

  location ^~ /api/v1/streaming {
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header Proxy "";

    proxy_pass http://streaming;
    proxy_buffering off;
    proxy_redirect off;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;

    add_header Strict-Transport-Security 
      "max-age=63072000; includeSubDomains";

    tcp_nodelay on;
  }

  location @proxy {
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header Proxy "";
    proxy_pass_header Server;

    proxy_pass http://backend;
    proxy_buffering on;
    proxy_redirect off;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;

    proxy_cache CACHE;
    proxy_cache_valid 200 7d;
    proxy_cache_valid 410 24h;
    proxy_cache_use_stale error timeout 
      updating http_500 http_502 http_503 http_504;
    add_header X-Cached $upstream_cache_status;

    tcp_nodelay on;
  }

  error_page 404 500 501 502 503 504 /500.html;
}
```

I've copied the
file [from Mastodon's source code repo](https://github.com/mastodon/mastodon/blob/main/dist/nginx.conf)
and changed `example.com` to `z2h.dev` in the file.

## Set Up NGINX to Use `mastodon` User

One more thing, `nginx`, by default, uses `www-data` as a user, and that---in my
case---caused issues when I started Mastodon's microservices.
Editing `/etc/nginx/nginx.conf` and replacing `www-data` with `mastodon` fixed
that for me.

Here's the entire file for reference:

```txt
user mastodon;
#user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 768;
}

http {
    sendfile on;
    tcp_nopush on;
    types_hash_max_size 2048;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    gzip on;

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
```

## Link the Site

```bash
cd /etc/nginx/sites-enabled
sudo ln -s ../sites-available/z2h.dev.conf
```

This will make **NGINX** import and use the rules that we've defined in the
former section.

Start NGINX
----------------

Then we can start `nginx`:

```bash
sudo systemctl restart nginx
```

Then check the status of the `nginx` service:

```txt
volkan@z2h-dev:~$ sudo systemctl status nginx
● nginx.service - 
A high performance web server and a reverse proxy server
     Loaded: loaded 
(/lib/systemd/system/nginx.service; enabled; preset: enabled)
     Active: active (running)
```

So far, all looking good 👌.

## Setting Up `systemd` Services

Make sure you have these files under `/etc/systemd/system`. Again, I've copied
them [from the official Mastodon repository](https://github.com/mastodon/mastodon/tree/main/dist).

### /etc/systemd/system/mastodon-sideqik.service

```txt
[Unit]
Description=mastodon-sidekiq
After=network.target

[Service]
Type=simple
User=mastodon
WorkingDirectory=/home/mastodon/live
Environment="RAILS_ENV=production"
Environment="DB_POOL=25"
Environment="MALLOC_ARENA_MAX=2"
Environment="LD_PRELOAD=libjemalloc.so"
ExecStart=/home/mastodon/.rbenv/shims/bundle exec sidekiq -c 25
TimeoutSec=15
Restart=always
# Proc filesystem
ProcSubset=pid
ProtectProc=invisible
# Capabilities
CapabilityBoundingSet=
# Security
NoNewPrivileges=true
# Sandboxing
ProtectSystem=strict
PrivateTmp=true
PrivateDevices=true
PrivateUsers=true
ProtectHostname=true
ProtectKernelLogs=true
ProtectKernelModules=true
ProtectKernelTunables=true
ProtectControlGroups=true
RestrictAddressFamilies=AF_INET
RestrictAddressFamilies=AF_INET6
RestrictAddressFamilies=AF_NETLINK
RestrictAddressFamilies=AF_UNIX
RestrictNamespaces=true
LockPersonality=true
RestrictRealtime=true
RestrictSUIDSGID=true
RemoveIPC=true
PrivateMounts=true
ProtectClock=true
# System Call Filtering
SystemCallArchitectures=native
SystemCallFilter=~@cpu-emulation @debug 
  @keyring @ipc @mount @obsolete @privileged @setuid
SystemCallFilter=@chown
SystemCallFilter=pipe
SystemCallFilter=pipe2
ReadWritePaths=/home/mastodon/live

[Install]
WantedBy=multi-user.target
```

### /etc/systemd/system/mastodon-streaming.service

```txt
[Unit]
Description=mastodon-streaming
After=network.target

[Service]
Type=simple
User=mastodon
WorkingDirectory=/home/mastodon/live
Environment="NODE_ENV=production"
Environment="PORT=4000"
Environment="STREAMING_CLUSTER_NUM=1"
ExecStart=/usr/bin/node ./streaming
TimeoutSec=15
Restart=always
# Proc filesystem
ProcSubset=pid
ProtectProc=invisible
# Capabilities
CapabilityBoundingSet=
# Security
NoNewPrivileges=true
# Sandboxing
ProtectSystem=strict
PrivateTmp=true
PrivateDevices=true
PrivateUsers=true
ProtectHostname=true
ProtectKernelLogs=true
ProtectKernelModules=true
ProtectKernelTunables=true
ProtectControlGroups=true
RestrictAddressFamilies=AF_INET
RestrictAddressFamilies=AF_INET6
RestrictAddressFamilies=AF_NETLINK
RestrictAddressFamilies=AF_UNIX
RestrictNamespaces=true
LockPersonality=true
RestrictRealtime=true
RestrictSUIDSGID=true
RemoveIPC=true
PrivateMounts=true
ProtectClock=true
# System Call Filtering
SystemCallArchitectures=native
SystemCallFilter=~@cpu-emulation @debug 
  @keyring @ipc @memlock @mount @obsolete 
  @privileged @resources @setuid
SystemCallFilter=pipe
SystemCallFilter=pipe2
ReadWritePaths=/home/mastodon/live

[Install]
WantedBy=multi-user.target
```

### /etc/systemd/system/mastodon-web.service

```txt
[Unit]
Description=mastodon-web
After=network.target

[Service]
Type=simple
User=mastodon
WorkingDirectory=/home/mastodon/live
Environment="RAILS_ENV=production"
Environment="PORT=3000"
Environment="LD_PRELOAD=libjemalloc.so"
ExecStart=/home/mastodon/.rbenv/shims/bundle exec \
puma -C config/puma.rb
ExecReload=/bin/kill -SIGUSR1 $MAINPID
TimeoutSec=15
Restart=always
# Proc filesystem
ProcSubset=pid
ProtectProc=invisible
# Capabilities
CapabilityBoundingSet=
# Security
NoNewPrivileges=true
# Sandboxing
ProtectSystem=strict
PrivateTmp=true
PrivateDevices=true
PrivateUsers=true
ProtectHostname=true
ProtectKernelLogs=true
ProtectKernelModules=true
ProtectKernelTunables=true
ProtectControlGroups=true
RestrictAddressFamilies=AF_INET
RestrictAddressFamilies=AF_INET6
RestrictAddressFamilies=AF_NETLINK
RestrictAddressFamilies=AF_UNIX
RestrictNamespaces=true
LockPersonality=true
RestrictRealtime=true
RestrictSUIDSGID=true
RemoveIPC=true
PrivateMounts=true
ProtectClock=true
# System Call Filtering
SystemCallArchitectures=native
SystemCallFilter=~@cpu-emulation @debug 
  @keyring @ipc @mount @obsolete @privileged @setuid
SystemCallFilter=@chown
SystemCallFilter=pipe
SystemCallFilter=pipe2
ReadWritePaths=/home/mastodon/live

[Install]
WantedBy=multi-user.target
```

That handles the `systemd` part of things.

Checking The Services
---------------------

Make sure you have all the services are up

```bash
sudo systemctl status mastodon-*
```

If any of the services are down or disabled, you can enable them:

```bash
sudo systemctl enable mastodon-web
sudo systemctl enable mastodon-sideqik
sudo systemctl enable mastodon-streaming
sudo systemctl start mastodon-web
sudo systemctl start mastodon-sideqik
sudo systemctl start mastodon-streaming
```

If you didn't have any issues so far, you should have a running **Mastodon**
instance that you can browse to the domain you set up (in my case
it's `z2h.dev`. Then, you can log in as an Administrator with
a random password that the installer has provided you during the guided
installation section you've followed above.

## Securing Mastodon

Since we have **Mastodon** itself up and running, it's time to secure the
instance.

We'll start with the users.

Ah, as soon as I created the instance, I made a second unprivileged user.

I use the root user only to administer the Mastodon server, and I use the
unprivileged user [z2h.dev/@volkan](http://z2h.dev/@volkan) to post things on
the site.

The next thing you **MUST** do is
to [enable 2FA for all users you control](https://github.com/McKael/mastodon-documentation/blob/master/Using-Mastodon/2FA.md).
**DO NOT** defer this. **Mastodon** is getting quite popular, which also means
it's attracting many people with bad intentions. Due to a zero-day
vulnerability, you would not want your server to become a spammers' barbeque
backyard. **2FA** is an added layer of security that makes it extra hard for
attackers to impersonate you.

## Scaling Up Mastodon

All the services **Mastodon** relies upon (_i.e., Redis, Postgres, etc_.) can
scale independently. Mastodon is, in itself, stateless. That means you can put
several Mastodon servers behind a load balancer and point them to the same
Postgres and Redis, which will take care of scalability for a long time.

Here's a high-level outline of how that might look like:

![Scaling Up Mastodon](/images/2022/11/mastodon-lb.png)

If things get even crazier, you'll have to come up with solutions to the
bottleneck you are facing. Like tuning Redis, adding read replicas; doing the
same to Postgres; tuning **NGINX**, maybe backing **NGINX** with another cloud
load balancer; sharding the data, geographically sharding the users... the list
can go on.

However, if you have reached that scale, the thing has become your full-time
job, and you probably have a team of intelligent engineers to sort out these
problems with you 🙂. If not, then you don't have to worry about future issues.

## Monitoring and Operating Mastodon

[SideKiq](https://sidekiq.org/) is the Ruby-based job queue that Mastodon uses.
If you log into the admin panel, you can find a link to monitor its state.

![SideQik Dashboard](/images/2022/11/Screenshot-2022-11-12-at-1.33.19-PM.png)

The **Sidekiq** dashboard is the first place you want to look when you feel
things are slowing down.

In addition, you can find on the admin console **PgHero** that can show you
important stats about your database.

![PgHero](/images/2022/11/Screenshot-2022-11-12-at-9.58.08-PM.png)

Also there is [**PgTune**](https://pgtune.leopard.in.ua/), which can help you
tune optimize your database when you fill in some values in a web form.

Mastodon official documentation recommends you check out **PgTune** if you want
to fine-tune your database further. That could be a low-hanging scalability
fruit to use from day zero.

![PgTune UI](/images/2022/11/Screenshot-2022-11-12-at-10.02.02-PM.png)

How you monitor **Mastodon** will vastly depend on where you run it. You might
use your cloud provider's altering mechanism, install
an [ELK Stack](https://www.elastic.co/elastic-stack) to take things under your
control, or do a mixture of both and some more. I'll keep that part out of the
scope of this article.

Also, [the official documentation](https://docs.joinmastodon.org/) is the right
place to begin your search for anything related to fixing, operating, and
configuring Mastodon.

## Conclusion

That's so far my experience and notes while installing Mastodon.

It took work, and I found myself debugging, looking into error messages, and
checking out `journalctl` errors and **NGINX** access and error log more than I
used to do in other guided installations.

However, it was **not** the most challenging thing either.
The [the official documentation](https://docs.joinmastodon.org/) is in good
shape, and when things don't work, the error messages make sense and help you
figure out the next steps.

So, if you end up having a similar experience to mine, you'll just need some
patience and to tap into your analytical debugging skills a bit more than usual.
Which also has been a fun learning experience that led to this article.

Hope you find it informative... And may the source be with you 🦄.

--------

## Section Contents

{{ tips_nav(selected=6) }}
