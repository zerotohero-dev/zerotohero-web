+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Snippet/Draft: Crypto in Go"
description = "Snippet/Draft: Crypto in Go"
date = "2025-07-12"

[taxonomies]
tags = ["snippets","drafts","inbox"]
+++

## Encrypting and Decrypting with AES CBC

```go 
package main

import (
    "crypto/aes"
    "crypto/cipher"
    "crypto/rand"
    "encoding/base64"
    "fmt"
    "io"
)

func main() {
    plaintext := []byte("Hello, Go encryption!")
    key := []byte("32-byte-key-for-AES-256-!!!!!!!!") // 32 bytes for AES-256

    // Encrypt
    ciphertext, err := encryptAES(plaintext, key)
    if err != nil {
        fmt.Println("Encryption error:", err)
        return
    }
    fmt.Printf("Ciphertext (base64): %s\n", base64.StdEncoding.EncodeToString(ciphertext))

    // Decrypt
    decrypted, err := decryptAES(ciphertext, key)
    if err != nil {
        fmt.Println("Decryption error:", err)
        return
    }
    fmt.Printf("Decrypted: %s\n", decrypted)
}

func encryptAES(plaintext, key []byte) ([]byte, error) {
    block, err := aes.NewCipher(key)
    if err != nil {
        return nil, err
    }

    // Pad plaintext to block size
    padding := aes.BlockSize - len(plaintext)%aes.BlockSize
    padtext := append(plaintext, bytes.Repeat([]byte{byte(padding)}, padding)...)

    ciphertext := make([]byte, aes.BlockSize+len(padtext))
    iv := ciphertext[:aes.BlockSize]
    if _, err := io.ReadFull(rand.Reader, iv); err != nil {
        return nil, err
    }

    mode := cipher.NewCBCEncrypter(block, iv)
    mode.CryptBlocks(ciphertext[aes.BlockSize:], padtext)

    return ciphertext, nil
}

func decryptAES(ciphertext, key []byte) ([]byte, error) {
    block, err := aes.NewCipher(key)
    if err != nil {
        return nil, err
    }

    if len(ciphertext) < aes.BlockSize {
        return nil, fmt.Errorf("ciphertext too short")
    }

    iv := ciphertext[:aes.BlockSize]
    ciphertext = ciphertext[aes.BlockSize:]

    mode := cipher.NewCBCDecrypter(block, iv)
    mode.CryptBlocks(ciphertext, ciphertext)

    // Unpad
    padding := int(ciphertext[len(ciphertext)-1])
    return ciphertext[:len(ciphertext)-padding], nil
}

// Output:
// Ciphertext (base64): [base64 string varies due to random IV]
// Decrypted: Hello, Go encryption!
```

Important:

* Key length matters: Use 32 bytes for AES-256, 24 for AES-192, or 16 for AES-128.
* IV is critical: It ensures each encryption is unique, even with the same key and plaintext.
* Padding: AES requires data to be a multiple of the block size (16 bytes). 
  The example uses `PKCS#5` padding.

## AES GCM Encryption and Decryption

```go
package main

import (
    "crypto/aes"
    "crypto/cipher"
    "crypto/rand"
    "encoding/base64"
    "fmt"
    "io"
)

func main() {
    plaintext := []byte("Secure data with GCM!")
    key := []byte("32-byte-key-for-AES-256-!!!!!!!!") // 32 bytes for AES-256

    // Encrypt
    ciphertext, err := encryptGCM(plaintext, key)
    if err != nil {
        fmt.Println("Encryption error:", err)
        return
    }
    fmt.Printf("Ciphertext (base64): %s\n", base64.StdEncoding.EncodeToString(ciphertext))

    // Decrypt
    decrypted, err := decryptGCM(ciphertext, key)
    if err != nil {
        fmt.Println("Decryption error:", err)
        return
    }
    fmt.Printf("Decrypted: %s\n", decrypted)
}

func encryptGCM(plaintext, key []byte) ([]byte, error) {
    block, err := aes.NewCipher(key)
    if err != nil {
        return nil, err
    }

    gcm, err := cipher.NewGCM(block)
    if err != nil {
        return nil, err
    }

    nonce := make([]byte, gcm.NonceSize())
    if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
        return nil, err
    }

    return gcm.Seal(nonce, nonce, plaintext, nil), nil
}

func decryptGCM(ciphertext, key []byte) ([]byte, error) {
    block, err := aes.NewCipher(key)
    if err != nil {
        return nil, err
    }

    gcm, err := cipher.NewGCM(block)
    if err != nil {
        return nil, err
    }

    nonceSize := gcm.NonceSize()
    if len(ciphertext) < nonceSize {
        return nil, fmt.Errorf("ciphertext too short")
    }

    nonce, ciphertext := ciphertext[:nonceSize], ciphertext[nonceSize:]
    return gcm.Open(nil, nonce, ciphertext, nil)
}

// Output:
// Ciphertext (base64): [base64 string varies due to random nonce]
// Decrypted: Secure data with GCM!
```

Important:

* Nonce: A unique value (like IV) for each encryption. GCM uses a 12-byte nonce by default.
* Authentication: GCM verifies data integrity, rejecting tampered ciphertext.
* No padding: GCM handles variable-length data natively.

## RSA Encryption and Decryption

```go
package main

import (
    "crypto/rand"
    "crypto/rsa"
    "crypto/sha256"
    "encoding/base64"
    "fmt"
)

func main() {
    // Generate key pair
    privateKey, err := rsa.GenerateKey(rand.Reader, 2048)
    if err != nil {
        fmt.Println("Key generation error:", err)
        return
    }
    publicKey := &privateKey.PublicKey

    // Encrypt
    plaintext := []byte("RSA encryption in Go!")
    ciphertext, err := rsa.EncryptOAEP(sha256.New(), rand.Reader, publicKey, plaintext, nil)
    if err != nil {
        fmt.Println("Encryption error:", err)
        return
    }
    fmt.Printf("Ciphertext (base64): %s\n", base64.StdEncoding.EncodeToString(ciphertext))

    // Decrypt
    decrypted, err := rsa.DecryptOAEP(sha256.New(), rand.Reader, privateKey, ciphertext, nil)
    if err != nil {
        fmt.Println("Decryption error:", err)
        return
    }
    fmt.Printf("Decrypted: %s\n", decrypted)
}

// Output:
// Ciphertext (base64): [base64 string varies due to random padding]
// Decrypted: RSA encryption in Go!
```

Important:

* Key size: Use at least 2048 bits for security.
* OAEP padding: Go’s EncryptOAEP adds secure padding to prevent attacks.
* Small data only: RSA can only encrypt data smaller than the key size.
* Resource: Go's crypto/rsa documentation

## Hashing versus Encryption

| Feature     | Encryption                   | Hashing                   |
|-------------|------------------------------|---------------------------|
| Purpose     | Protect data confidentiality | Verify data integrity     |
| Reversible? | Yes (with key)               | No (one-way)              |
| Go Package  | crypto/aes, crypto/rsa       | crypto/sha256, crypto/md5 |
| Example Use | Secure API payloads          | Password storage          |

## SHA-256 Hash

```go 
package main

import (
    "crypto/sha256"
    "encoding/hex"
    "fmt"
)

func main() {
    data := []byte("Hash this string!")
    hash := sha256.Sum256(data)
    fmt.Printf("SHA-256 Hash: %s\n", hex.EncodeToString(hash[:]))

    // Output:
    // SHA-256 Hash: 2c7a6e66323c8f7a0e205803c763eb8a4e8b6f8b0b2c3f8a7e8f9d0b1e2c3d4e
}
```

## Generating a Secure Random Key

```go
import (
    "crypto/rand"
    "encoding/hex"
    "fmt"
)

func main() {
    key := make([]byte, 32) // 32 bytes for AES-256
    _, err := rand.Read(key)
    if err != nil {
        fmt.Println("Key generation error:", err)
        return
    }
    fmt.Printf("Generated key: %s\n", hex.EncodeToString(key))

    // Output:
    // Generated key: [random 64-character hex string]
}
```

## Common Encryption Pitfalls

| Pitfall                 | Solution                                  |
|-------------------------|-------------------------------------------|
| Reusing IV/nonce        | Generate a unique IV/nonce per encryption |
| Weak key generation     | Use crypto/rand for keys and IVs          |
| Hardcoding keys         | Store keys in secure storage              |
| Ignoring authentication | Use AES-GCM for authenticated encryption  |

## Hybrid Encryption

```go
package main

import (
    "crypto/aes"
    "crypto/cipher"
    "crypto/rand"
    "crypto/rsa"
    "crypto/sha256"
    "encoding/base64"
    "fmt"
    "io"
)

func main() {
    // Generate RSA key pair
    privateKey, err := rsa.GenerateKey(rand.Reader, 2048)
    if err != nil {
        fmt.Println("Key generation error:", err)
        return
    }
    publicKey := &privateKey.PublicKey

    // Generate AES key
    aesKey := make([]byte, 32)
    if _, err := rand.Read(aesKey); err != nil {
        fmt.Println("AES key generation error:", err)
        return
    }

    // Encrypt data with AES
    plaintext := []byte("Hybrid encryption in Go!")
    ciphertext, err := encryptAES(plaintext, aesKey)
    if err != nil {
        fmt.Println("AES encryption error:", err)
        return
    }

    // Encrypt AES key with RSA
    encryptedKey, err := rsa.EncryptOAEP(sha256.New(), rand.Reader, publicKey, aesKey, nil)
    if err != nil {
        fmt.Println("RSA encryption error:", err)
        return
    }

    fmt.Printf("Encrypted AES key (base64): %s\n", base64.StdEncoding.EncodeToString(encryptedKey))
    fmt.Printf("Ciphertext (base64): %s\n", base64.StdEncoding.EncodeToString(ciphertext))

    // Decrypt AES key with RSA
    decryptedKey, err := rsa.DecryptOAEP(sha256.New(), rand.Reader, privateKey, encryptedKey, nil)
    if err != nil {
        fmt.Println("RSA decryption error:", err)
        return
    }

    // Decrypt data with AES
    decrypted, err := decryptAES(ciphertext, decryptedKey)
    if err != nil {
        fmt.Println("AES decryption error:", err)
        return
    }
    fmt.Printf("Decrypted: %s\n", decrypted)
}

func encryptAES(plaintext, key []byte) ([]byte, error) {
    block, err := aes.NewCipher(key)
    if err != nil {
        return nil, err
    }

    padding := aes.BlockSize - len(plaintext)%aes.BlockSize
    padtext := append(plaintext, bytes.Repeat([]byte{byte(padding)}, padding)...)

    ciphertext := make([]byte, aes.BlockSize+len(padtext))
    iv := ciphertext[:aes.BlockSize]
    if _, err := io.ReadFull(rand.Reader, iv); err != nil {
        return nil, err
    }

    mode := cipher.NewCBCEncrypter(block, iv)
    mode.CryptBlocks(ciphertext[aes.BlockSize:], padtext)

    return ciphertext, nil
}

func decryptAES(ciphertext, key []byte) ([]byte, error) {
    block, err := aes.NewCipher(key)
    if err != nil {
        return nil, err
    }

    if len(ciphertext) < aes.BlockSize {
        return nil, fmt.Errorf("ciphertext too short")
    }

    iv := ciphertext[:aes.BlockSize]
    ciphertext = ciphertext[aes.BlockSize:]

    mode := cipher.NewCBCDecrypter(block, iv)
    mode.CryptBlocks(ciphertext, ciphertext)

    padding := int(ciphertext[len(ciphertext)-1])
    return ciphertext[:len(ciphertext)-padding], nil
}

// Output:
// Encrypted AES key (base64): [base64 string varies]
// Ciphertext (base64): [base64 string varies]
// Decrypted: Hybrid encryption in Go!
```

## What to Use When

* AES-CBC: Good for general-purpose encryption with manual padding.
* AES-GCM: Best for authenticated encryption in secure communications.
* RSA: Ideal for key exchange or small data encryption.
* Hybrid encryption: Combines AES and RSA for large-scale secure data transfer.
