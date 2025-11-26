#!/usr/bin/env python3
"""
Tag Analyzer for Zero to Hero Content
Analyzes markdown files and creates tag mapping files
"""

import os
import re
from pathlib import Path
from collections import defaultdict

# Content root
CONTENT_DIR = "/Users/volkan/Desktop/WORKSPACE/zerotohero-web/content"
TAG_FILES_DIR = "/Users/volkan/Desktop/WORKSPACE/zerotohero-web/tag-files"

# Tag mappings based on taxonomy
tag_mappings = defaultdict(list)
file_count = 0
difficult_files = []

def extract_slug(filepath):
    """Extract slug from file path"""
    path = Path(filepath)
    # Skip index files
    if path.stem == "_index":
        return None
    return path.stem

def read_file_content(filepath, max_lines=100):
    """Read first N lines of file"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            return ''.join(lines[:max_lines])
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
        return ""

def extract_title_and_description(content):
    """Extract title and description from frontmatter"""
    title = ""
    description = ""

    # Look for title
    title_match = re.search(r'title\s*=\s*"([^"]+)"', content)
    if title_match:
        title = title_match.group(1).lower()

    # Look for description
    desc_match = re.search(r'description\s*=\s*"([^"]+)"', content)
    if desc_match:
        description = desc_match.group(1).lower()

    return title, description

def analyze_file(filepath):
    """Analyze a file and return applicable tags"""
    tags = set()
    content = read_file_content(filepath)
    content_lower = content.lower()
    path_str = filepath.lower()

    # Extract metadata
    title, description = extract_title_and_description(content)
    combined_meta = (title + " " + description).lower()

    # Get the slug
    slug = extract_slug(filepath)
    if not slug:
        return tags

    # Directory-based tags
    if '/highlights/' in path_str:
        tags.add('highlights')
    if '/roadmap/' in path_str:
        tags.add('roadmap')
    if '/tips/' in path_str:
        tags.add('tips')

    # Go programming - must have substantial Go content
    if any(x in content_lower for x in ['package main', 'func main()', 'import (', '```go']):
        tags.add('go')
    elif 'go-' in slug or 'golang' in slug or \
         any(x in combined_meta for x in ['golang', ' go ', 'go programming', 'go language', ' in go']):
        tags.add('go')

    # Kubernetes
    if any(x in content_lower for x in ['kubernetes', 'k8s', 'kubectl', 'deployment', 'pod', 'helm']) or \
       any(x in combined_meta for x in ['kubernetes', 'k8s']):
        tags.add('kubernetes')

    # Security general - but not just "secure" as adjective
    if 'secur' in combined_meta or \
       any(x in content_lower for x in ['security', 'vulnerability', 'threat model', 'attack vector', 'zero trust']):
        tags.add('security')

    # SPIFFE
    if any(x in content_lower for x in ['spiffe', 'spiffeid', 'svid']) or 'spiffe' in combined_meta:
        tags.add('spiffe')

    # SPIRE
    if any(x in content_lower for x in ['spire-', 'spire server', 'spire agent']) or 'spire' in combined_meta or '/spire/' in path_str:
        tags.add('spire')

    # Docker
    if any(x in content_lower for x in ['dockerfile', 'docker-compose', 'docker container', 'docker image']) or \
       'docker' in combined_meta:
        tags.add('docker')

    # VMware
    if any(x in content_lower for x in ['vmware', 'vsphere', 'esxi', 'vcenter', 'vcf', 'vcsa']) or \
       'vmware' in combined_meta:
        tags.add('vmware')

    # VCF
    if any(x in content_lower for x in ['vcf', 'cloud foundation', 'sddc manager', 'workload domain']):
        tags.add('vcf')

    # ESXi
    if 'esxi' in content_lower or 'esxi' in combined_meta:
        tags.add('esxi')

    # vSphere
    if 'vsphere' in content_lower or 'vsphere' in combined_meta:
        tags.add('vsphere')

    # vCenter
    if 'vcenter' in content_lower or 'vcsa' in content_lower or 'vcenter' in combined_meta:
        tags.add('vcenter')

    # Career/Leadership/Soft Skills (check highlights content)
    if any(x in combined_meta for x in ['career', 'promotion', 'professional development', 'job']) or \
       any(x in content_lower for x in ['career growth', 'career development', 'earn the promotion', 'job search', 'job interview']):
        tags.add('career')

    # For highlights, check content more broadly
    if '/highlights/' in path_str:
        if any(x in content_lower for x in ['leadership', 'leading', 'leader', 'management', 'manager', 'team']):
            tags.add('leadership')
        if any(x in content_lower for x in ['communication', 'asking', 'feedback', 'empathy', 'helping']):
            tags.add('soft-skills')
    else:
        if any(x in combined_meta for x in ['leadership', 'leader', 'management']) or \
           any(x in content_lower for x in ['leadership', 'leading team', 'team management', 'manager']):
            tags.add('leadership')

        if any(x in combined_meta for x in ['communication', 'soft skill', 'interpersonal']) or \
           any(x in content_lower for x in ['communication skill', 'soft skill', 'interpersonal', 'empathy']):
            tags.add('soft-skills')

    # Authentication
    if any(x in content_lower for x in ['authentication', 'oidc', 'oauth', 'authn']) or \
       'auth' in combined_meta:
        tags.add('authentication')

    # Encryption
    if any(x in content_lower for x in ['encryption', 'decrypt', 'cipher', 'cryptography', 'age encryption']) or \
       'encrypt' in combined_meta:
        tags.add('encryption')

    # TLS
    if any(x in content_lower for x in ['tls', 'ssl', 'x509', 'x.509', 'certificate']):
        tags.add('tls')

    # JWT
    if any(x in content_lower for x in ['jwt', 'json web token']):
        tags.add('jwt')

    # Secrets Management
    if any(x in content_lower for x in ['secret management', 'secrets store', 'secret store', 'vault']) or \
       'secret' in combined_meta:
        tags.add('secrets-management')

    # VSEcM
    if any(x in content_lower for x in ['vsecm', 'vmware secrets manager']):
        tags.add('vsecm')

    # mTLS
    if any(x in content_lower for x in ['mtls', 'mutual tls', 'mutual authentication']):
        tags.add('mtls')

    # Linux
    if any(x in content_lower for x in ['linux', 'systemd', 'ubuntu', 'debian']) or 'linux' in combined_meta:
        tags.add('linux')

    # Bash
    if any(x in content_lower for x in ['#!/bin/bash', 'bash script', 'shell script']):
        tags.add('bash')

    # Git
    if any(x in content_lower for x in ['git commit', 'git push', 'git pull', 'git clone', 'github', 'repository']) or \
       'git' in combined_meta:
        tags.add('git')

    # Vim
    if any(x in content_lower for x in ['vim', 'neovim', 'vi editor']):
        tags.add('vim')

    # HTTP/REST
    if any(x in content_lower for x in ['http://', 'https://', 'http request', 'http server', 'http client', 'api endpoint']):
        tags.add('http')

    if any(x in content_lower for x in ['rest api', 'restful']):
        tags.add('rest-api')

    # Testing
    if any(x in content_lower for x in ['unit test', 'integration test', 'testing strategy']) or \
       'test' in combined_meta:
        tags.add('testing')

    # Design Patterns
    if any(x in content_lower for x in ['design pattern', 'singleton', 'factory pattern', 'observer pattern']):
        tags.add('design-patterns')

    # Best Practices
    if any(x in content_lower for x in ['best practice', 'best practices']):
        tags.add('best-practices')

    # Tutorial
    if any(x in combined_meta for x in ['tutorial', 'guide', 'walkthrough', 'step-by-step']) or \
       any(x in content_lower for x in ['in this tutorial', 'step-by-step', 'how to']):
        tags.add('tutorial')

    # Reference
    if any(x in combined_meta for x in ['reference', 'documentation']) or \
       any(x in content_lower for x in ['reference guide', 'reference documentation']):
        tags.add('reference')

    # Opinion
    if '/top-of-mind/' in path_str:
        tags.add('opinion')

    # Cloud Native
    if any(x in content_lower for x in ['cloud-native', 'cloud native', 'cncf']):
        tags.add('cloud-native')

    # Microservices
    if any(x in content_lower for x in ['microservice', 'service mesh']):
        tags.add('microservices')

    # DevOps
    if any(x in content_lower for x in ['devops', 'ci/cd', 'continuous integration', 'continuous deployment']):
        tags.add('devops')

    # AWS
    if any(x in content_lower for x in ['aws', 'amazon web services', 'eks', 'ecr', 'ec2']) or \
       'aws' in combined_meta:
        tags.add('aws')

    # Databases
    if any(x in content_lower for x in ['database', 'sql', 'mysql', 'postgres', 'sqlite']):
        tags.add('databases')

    # Web Development
    if any(x in content_lower for x in ['web development', 'frontend', 'backend', 'javascript', 'react', 'vue']):
        tags.add('web-development')

    # Terminal
    if any(x in content_lower for x in ['command line', 'cli tool', 'terminal emulator']):
        tags.add('terminal')

    # Productivity
    if any(x in combined_meta for x in ['productivity', 'workflow', 'efficiency']):
        tags.add('productivity')

    # Learning
    if '/roadmap/' in path_str and 'learn' in combined_meta:
        tags.add('learning')

    # Architecture
    if any(x in content_lower for x in ['architecture', 'system design', 'architectural pattern']):
        tags.add('architecture')

    # Infrastructure
    if any(x in content_lower for x in ['infrastructure', 'deployment', 'provisioning', 'infrastructure as code']):
        tags.add('infrastructure')

    # Logging
    if any(x in content_lower for x in ['logging', 'slog', 'log level', 'audit log']):
        tags.add('logging')

    # Monitoring
    if any(x in content_lower for x in ['monitoring', 'observability', 'prometheus', 'metrics']):
        tags.add('monitoring')

    return tags

def main():
    global file_count

    # Create tag files directory
    os.makedirs(TAG_FILES_DIR, exist_ok=True)

    # Find all markdown files
    md_files = []
    for root, dirs, files in os.walk(CONTENT_DIR):
        for file in files:
            if file.endswith('.md'):
                md_files.append(os.path.join(root, file))

    print(f"Found {len(md_files)} markdown files")

    # Analyze each file
    for filepath in md_files:
        slug = extract_slug(filepath)
        if not slug:
            continue

        file_count += 1
        tags = analyze_file(filepath)

        # Track difficult files (less than 2 tags)
        if len(tags) < 2:
            difficult_files.append((filepath, list(tags)))

        # Add slug to each tag's list
        for tag in tags:
            tag_mappings[tag].append(slug)

        if file_count % 20 == 0:
            print(f"Processed {file_count} files...")

    # Write tag files
    print(f"\nWriting tag files to {TAG_FILES_DIR}")
    for tag, slugs in tag_mappings.items():
        tag_file = os.path.join(TAG_FILES_DIR, f"{tag}.txt")
        with open(tag_file, 'w') as f:
            for slug in sorted(set(slugs)):
                f.write(f"{slug}\n")
        print(f"  {tag}.txt: {len(set(slugs))} files")

    # Print summary
    print(f"\n{'='*60}")
    print("SUMMARY")
    print(f"{'='*60}")
    print(f"Total files analyzed: {file_count}")
    print(f"Total tag files created: {len(tag_mappings)}")

    # Top 10 tags by file count
    print(f"\nTop 10 tags by file count:")
    sorted_tags = sorted(tag_mappings.items(), key=lambda x: len(x[1]), reverse=True)
    for i, (tag, slugs) in enumerate(sorted_tags[:10], 1):
        print(f"  {i:2d}. {tag:20s} - {len(set(slugs)):3d} files")

    # Difficult files
    print(f"\nFiles with fewer than 2 tags ({len(difficult_files)} files):")
    for filepath, tags in difficult_files[:10]:
        rel_path = filepath.replace(CONTENT_DIR, '')
        print(f"  {rel_path}: {tags if tags else 'NO TAGS'}")

    if len(difficult_files) > 10:
        print(f"  ... and {len(difficult_files) - 10} more")

if __name__ == '__main__':
    main()
