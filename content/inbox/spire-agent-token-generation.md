+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Securely Generating and Storing SPIRE Agent Tokens"
description = "Securely Generating and Storing SPIRE Agent Tokens"
date = "2024-12-02"

[taxonomies]
tags = ["SPIFFE","SPIRE","inbox","security","authentication","shell-scripting","productivity","secrets-management"]
+++

SPIRE (the SPIFFE Runtime Environment) requires tokens for agent authentication. Here's a secure way to generate and store these tokens using bash scripting.

## The Problem

When working with SPIRE, we often need to generate agent tokens and store them for later use. The default `spire-server token generate` command outputs tokens with a "Token: " prefix, which isn't always ideal for automation or direct use in configuration files.

## The Solution

Here's a bash script that generates a SPIRE agent token, strips unnecessary prefixes, and stores it securely:

```bash
#!/usr/bin/env bash

#    \\ SPIKE: Keep your secrets secret with SPIFFE.
#  \\\\\ Copyright 2024-present SPIKE contributors.
# \\\\\\\ SPDX-License-Identifier: Apache-2.0

TOKEN_FILE="agent-token.txt"

# Generate token and strip the "Token: " prefix
if ! spire-server token generate -spiffeID spiffe://spike.ist/spire-agent | sed 's/^Token: //' > "$TOKEN_FILE"; then
    echo "Error: Failed to generate token" >&2
    exit 1
fi

# Verify file was created and is not empty
if [ ! -s "$TOKEN_FILE" ]; then
    echo "Error: Token file is empty or was not created" >&2
    exit 1
fi

# Set restrictive permissions
chmod 600 "$TOKEN_FILE"

echo "Token successfully generated and saved to $TOKEN_FILE"
```

## How It Works

1. **Token Generation**: The script uses `spire-server token generate` to create a new token with a specific SPIFFE ID.

2. **Text Processing**: A `sed` command strips the "Token: " prefix from the output:
    - `'s/^Token: //'` replaces "Token: " at the start of the line with nothing
    - The clean token is then redirected to the output file

3. **Error Handling**:
    - Checks if token generation succeeded
    - Verifies the output file exists and isn't empty
    - Returns meaningful error messages

4. **Security**: Sets file permissions to 600 (read/write for owner only) to protect the token

## Usage

1. Save the script as `generate-agent-token.sh`
2. Make it executable: `chmod +x generate-agent-token.sh`
3. Run it: `./generate-agent-token.sh`

The token will be saved in `agent-token.txt` in the current directory.

## Best Practices

- Always use restrictive file permissions for token files
- Store tokens in a secure location
- Never commit tokens to version control
- Consider using environment variables or secure vaults for production environments

## Conclusion

This script provides a secure and automated way to generate and store SPIRE agent tokens. By removing the prefix and implementing proper error handling, it makes token management more reliable and automation-friendly.
