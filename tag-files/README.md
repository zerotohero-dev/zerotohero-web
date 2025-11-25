# Tag Mapping Files

This directory contains tag mapping files for all markdown content in the zerotohero-web repository.

## Overview

- **Total Files Analyzed**: 215 markdown files
- **Total Tag Files Created**: 49
- **Files Tagged**: 201 (excluding _index.md files)

## Format

Each `.txt` file contains one slug per line. The slug is the filename without the `.md` extension and without the directory path.

Example:
- File: `/content/inbox/docker-go.md`
- Slug in tag file: `docker-go`

## Tag Statistics

### Top 10 Tags by File Count

1. **learning** - 201 files
2. **http** - 93 files
3. **tutorial** - 73 files
4. **security** - 56 files
5. **kubernetes** - 54 files
6. **leadership** - 50 files
7. **authentication** - 38 files
8. **git** - 38 files
9. **terminal** - 35 files
10. **infrastructure** - 31 files

### All Tags with File Counts

| Tag | Count | Tag | Count |
|-----|-------|-----|-------|
| learning | 201 | http | 93 |
| tutorial | 73 | security | 56 |
| kubernetes | 54 | leadership | 50 |
| authentication | 38 | git | 38 |
| terminal | 35 | infrastructure | 31 |
| secrets-management | 29 | vmware | 28 |
| highlights | 28 | vcf | 27 |
| spiffe | 26 | bash | 22 |
| roadmap | 22 | productivity | 21 |
| spire | 20 | architecture | 19 |
| go | 18 | linux | 17 |
| mtls | 16 | tls | 15 |
| encryption | 14 | esxi | 13 |
| microservices | 13 | soft-skills | 13 |
| tips | 13 | vcenter | 13 |
| docker | 12 | vsphere | 12 |
| career | 11 | jwt | 11 |
| testing | 11 | aws | 8 |
| cloud-native | 7 | vim | 7 |
| vsecm | 7 | best-practices | 4 |
| design-patterns | 4 | rest-api | 4 |
| devops | 3 | databases | varies |
| logging | varies | monitoring | varies |
| opinion | varies | reference | varies |
| web-development | varies |

## Directory-Based Auto-Tagging

Files are automatically tagged based on their directory location:

- Files in `/content/highlights/` → tagged with `highlights`
- Files in `/content/roadmap/` → tagged with `roadmap`
- Files in `/content/tips/` → tagged with `tips`

## Sample Tag Contents

### go.txt (18 files)
- authenticate-all-the-things
- base64-decoding-a-string-in-go
- cross-compilation
- docker-go
- getting-the-body-of-an-http-request-with-go
- jwt-parsing
- jwt-validation
- ... and more

### kubernetes.txt (54 files)
- bundle-client
- cluster-secrets-store
- deploying-a-microservice-to-k8s
- kubernetes-namespace
- spiffe-acl
- vsecm-operator
- ... and more

### security.txt (56 files)
- age-decryption-guide
- custom-ca
- dek-kek
- file-hashing
- git-gpg-sign
- jwt-mtls
- secure-password-input
- sha256-guide
- ... and more

### vmware.txt (28 files)
- add-vsphere-clusters-in-vcf
- deploying-vcsa
- esxi-installation
- vcenter-backup
- vcf-intro
- vsphere-to-vcf-migration
- ... and more

## Usage

These tag files can be used for:
- Building tag index pages
- Creating related content suggestions
- Generating tag clouds
- Filtering and searching content by topic
- Building topic-based navigation

## Regeneration

To regenerate these tag files, analyze the markdown files in `/content` directory and match against the tag patterns defined in the analysis logic.
