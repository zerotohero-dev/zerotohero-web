+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Computing SHA256 Hashes for Binary Files: A Quick Guide"
description = "Computing SHA256 Hashes for Binary Files: A Quick Guide"
date = "2024-11-27"

[taxonomies]
tags = ["inbox", "hashing", "bash", "cli", "security"]
+++

When distributing binary files, it's crucial to provide cryptographic hashes so users can verify the integrity of their downloads. This guide shows how to generate SHA256 hashes for multiple binary files across different platforms.

## The Problem

Let's say you have a set of binary files for different platforms and architectures:

```
keeper-darwin-arm64
keeper-linux-amd64
keeper-linux-arm64
nexus-darwin-arm64
nexus-linux-amd64
nexus-linux-arm64
spike-darwin-arm64
spike-linux-amd64
spike-linux-arm64
```

You want to generate SHA256 hash files for each binary, with each hash saved in its own file next to the binary.

## Platform-Specific Solutions

### On macOS

On macOS, we use the `shasum` command with the `-a 256` flag to specify SHA256:

```bash
for file in keeper-* nexus-* spike-*; do
    shasum -a 256 "$file" > "$file.sum.txt"
done
```

### On Linux

Linux systems typically use `sha256sum`:

```bash
for file in keeper-* nexus-* spike-*; do
    sha256sum "$file" > "$file.sum.txt"
done
```

## What This Does

The script will:
1. Loop through all files matching the patterns `keeper-*`, `nexus-*`, and `spike-*`
2. For each file, compute its SHA256 hash
3. Save the hash and filename in a corresponding `.sum.txt` file

For example, if you have a file named `keeper-darwin-arm64`, it will create `keeper-darwin-arm64.sum.txt` containing something like:

```
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  keeper-darwin-arm64
```

## Verifying Hashes

Users can verify the files using:

On macOS:
```bash
shasum -a 256 -c filename.sum.txt
```

On Linux:
```bash
sha256sum -c filename.sum.txt
```

## Best Practices

1. Always use quotation marks around filenames in scripts to handle spaces and special characters
2. Keep hash files alongside binaries for easy reference
3. Consider also creating a single file containing all hashes for batch verification
4. Document which hashing algorithm was used (in this case, SHA256)

This approach provides a secure way to distribute binaries while allowing users to verify their integrity through cryptographic hashes.
