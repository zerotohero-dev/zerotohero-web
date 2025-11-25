+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "How to Decrypt Files Using age - A Quick Guide"
description = "How to Decrypt Files Using age - A Quick Guideg"
date = "2024-12-03"

[taxonomies]
tags = ["inbox","security","shell-scripting","encryption","git","secrets-management"]
+++

Age is a modern file encryption tool that's simple yet powerful. Here's how to decrypt age-encrypted files using a secret key.

## Prerequisites

- age installed on your system
- An encrypted file (base64 encoded)
- A secret key (starting with AGE-SECRET-KEY-)

## Step-by-Step Decryption

1. First, decode the base64 content to a file:
```bash
echo "YOUR-BASE64-CONTENT" | base64 -d > encrypted.age
```

2. Save the secret key to a file:
```bash
echo "AGE-SECRET-KEY-YOUR-KEY" > key.txt
chmod 600 key.txt  # Set proper permissions
```

3. Decrypt the file:
```bash
age --decrypt -i key.txt encrypted.age
```

## Installing age

Choose your platform:
- macOS: `brew install age`
- Ubuntu/Debian: `apt install age`
- Other systems: Download from the [age GitHub repository](https://github.com/FiloSottile/age)

## Common Issues

- Ensure you're using only the AGE-SECRET-KEY line for decryption
- Verify the base64 content is complete and properly formatted
- Check file permissions on the key file (should be readable only by you)

## Security Best Practices

- Never share your secret key
- Delete key files after use
- Store encrypted files and keys separately
- Use secure channels when transferring encrypted files
