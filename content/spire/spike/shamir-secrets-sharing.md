+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Shamir's Secret Sharing Scheme with SPIFFE and SPIKE"
date = "2024-12-28"

[taxonomies]
tags = ["spiffe","spire","spike","shamir","secrets-management","security","encryption","system-design","key-management"]
+++

## Introduction

**Secure secrets management** is a critical aspect of any modern distributed 
system's infrastructure. [**SPIKE**][spike] (*Secure 
Production Identity for Key Encryption*) is a system that achieves secure 
secrets management through a **distributed**, **zero-trust** architecture. 

To learn more about **SPIKE**, you can visit[**SPIKE**'s website][spike-web]
or check out [**SPIKE**'s GitHub repository][spike].

## A Video is a Worth a Million Words

Here is a video that goes over what we discuss in this article:

<div style="padding:56.25% 0 0 0;position:relative;"><iframe src="https://player.vimeo.com/video/1042946784?badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479" frameborder="0" allow="autoplay; fullscreen; picture-in-picture; clipboard-write" style="position:absolute;top:0;left:0;width:100%;height:100%;" title="SPIKE’s Shamir Secrets Sharing with SPIFFE mTLS"></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>

## Keeping the Root Key Secret

In **SPIKE** architecture, **SPIKE Nexus** is the central secret store.
**SPIKE Nexus** requires a **root key** to save its secrets to its
*backing store* in encrypted form. That's why the **root key** is a critical 
secret that must always be kept secure.

This article discusses how **SPIKE** securely manages the **root key** using
[**Shamir's Secret Sharing**][shamir] scheme.

## Introducing Shamir's Secret Sharing

Our design relies upon several layers of security to ensure the root key remains
secure:

* We leverage [**SPIFFE-based mTLS encryption**][spiffe] to secure communication 
  between various **SPIKE** components.
* We use [**Shamir's Secret Sharing**][shamir] to split the root key into
  multiple shares. This ensures that no single entity can access the full
  key anytime.
* The Shamir **shares** are never stored on disk.
* **SPIKE Keeper**s generate one share per Keeper; however, a single share is
  not enough to reconstruct the root key. So even in the unlikely event that 
  a **SPIKE Keeper** is compromised, the root key remains secure.
* Only **SPIKE Nexus** can compose the root key from the shares; once created,
  it remains in the memory. The root key is **never** stored on disk
  and **never** leaves the network perimeter. 
* In addition, there is no API or programmatic access that can reveal the root
  key. The attacker will need admin privileges and sophisticated memory forensics 
  to extract the root key from the **SPIKE Nexus**, which is a significant 
  security barrier.

This article further discusses the architecture and design choices that make
**SPIKE**'s **Nexus** and **Keeper** interaction an excellent model for secure
key management.

> **How about Disaster Recovery?**
> 
> In the case of all **SPIKE Keepers** simultaneously crashing, the root key is
> lost. 
> 
> We have secure and sophisticated ideas to help teams recover from an unlikely
> doomsday scenario by requiring multi-party approval to reconstruct the root
> key. Yet, this is a topic for another article.
> 
> However, even in this multiple-SPIKE-keepers scenario, a surefire way to
> prevent from losing the root key is to increase the number of **SPIKE Keeper**s
> to a higher number, say 5 or 7. This way, even if a few **SPIKE Keeper**s
> crash, the root key can still be reconstructed.
> 
> And when you geographically distribute the **SPIKE Keeper**s, you can ensure
> that even a natural disaster won't take down all the **SPIKE Keeper**s at once.

## SPIKE Architecture: A Brief Overview

The **SPIKE** system consists of three core components:

* **SPIKE Keeper**: These are distributed instances responsible for generating
   shards (*parts of a root key*) using [Shamir's Secret Sharing][shamir]. Each
   **SPIKE Keeper** maintains a piece of the secret, ensuring no single entity
   has the full key.

* **SPIKE Nexus**: This is the **secrets store** that gathers shards from the
   **SPIKE Keeper**s to reconstruct the `rootKey` during bootstrapping, enabling
   secure initialization of its backing store.

* **SPIKE Pilot**: This is the CLI tool that communicates with **SPIKE Nexus** 
  and manages policies and secrets through the **SPIKE Nexus RESTful mTLS API**. 
  **SPIKE Pilot** is **not** a part of this article, but it's an essential 
  component of the **SPIKE** system.

Both components leverage [**SPIFFE**][spiffe] for identity and secure 
communication through [**mTLS**][mtls].

## High-Level Design

Here is a high-level overview of the **SPIKE** root key management system.
You can open the image in a separate tab for a better view:

{{img(
src="/images/2024/spike/shamir/spike-shamir.jpg"
alt="SPIKE Root Key Partitioning: High-Level Conceptual Diagram"
)}}

This diagram illustrates the the distributed key management 
system workflow between **SPIKE Keeper**s and the **SPIKE Nexus**. Let me 
break down the sequence:

For starters, all connections use [**SPIFFE** mTLS][spiffe] for security.

### Starting SPIKE Keepers and SPIKE Nexus

For **SPIKE Keepers** to know about each other and **SPIKE Nexus**, we pass
some configuration information during startup using environment variables
as follows:

```bash
# ./hack/start-nexus.sh

SPIKE_KEEPER_PEERS='{"1":"https://localhost:8443", \
"2":"https://localhost:8543","3":"https://localhost:8643"}' \
./nexus
```

Here is how each of the keepers start:

```bash
# /hack/start-keeper-1.sh

SPIKE_KEEPER_PEERS='{"1":"https://localhost:8443", \
"2":"https://localhost:8543","3":"https://localhost:8643"}' \
SPIKE_KEEPER_TLS_PORT=':8443' \
SPIKE_KEEPER_ID="1" \
./keeper
```

```bash
# /hack/start-keeper-2.sh

SPIKE_KEEPER_PEERS='{"1":"https://localhost:8443",\
"2":"https://localhost:8543","3":"https://localhost:8643"}' \
SPIKE_KEEPER_TLS_PORT=':8543' \
SPIKE_KEEPER_ID="2" \
./keeper
```

```bash
# /hack/start-keeper-3.sh

SPIKE_KEEPER_PEERS='{"1":"https://localhost:8443",\
"2":"https://localhost:8543","3":"https://localhost:8643"}' \
SPIKE_KEEPER_TLS_PORT=':8643' \
SPIKE_KEEPER_ID="3" \
./keeper
```

### Initial Share Generation (*the top of the diagram*)

Each **SPIKE Keeper** computes a secure random share.

There's a parallel process where each **SPIKE Keeper**:

* Broadcasts its `{id, share}` to other **SPIKE Keeper**s
* Receives shares from other peer **SPIKE Keeper**s

### Root Key Generation (*middle-left*)

* **SPIKE Keeper** waits until all shards are collected.
* **SPIKE Keeper** computes a `rootKey` by `XOR`ing all collected shards.
* This ensures that no single **SPIKE Keeper** knows the complete key once it
  computes its **Shamir Secret Share** from the `rootKey` and discards the
  root key and any intermediate values.

### Shamir Secret Sharing

* Takes the rootKey as input
* Creates three partitions
  * This will be configurable, but it's hard-coded to 3 and 2 for now.
* Uses `threshold = 2` (*meaning any two shares can reconstruct the `rootKey`*)

Each **SPIKE Keeper** then:

* Discards the original root key (*security measure*)
* Keeps only its assigned partition (*also a security measure*)
* Discards knowledge of other partitions

Here is a more detailed drill-down of the **SPIKE Keeper** workflow:

* **Compute Secure Random Share**: Each **SPIKE Keeper** generates a
  cryptographically secure random share derived from an [AES-256][aes] seed.
* **Broadcast and Receive**: **SPIKE Keeper**s broadcast their shards (*id,
  share*) to peers and receive shards from them in parallel. Secure
  [**mTLS**][mtls] ensures the **integrity** and **confidentiality** of these
  communications.
* **Shard Aggregation and Root Key Derivation**: **SPIKE Keeper** waits until
  all shards are gathered, combines them using [`XOR`][xor], and derives the
  `rootKey`.
* **Shamir Secret Sharing**: The derived `rootKey` is split into **three
  partitions**, ensuring only a subset (*e.g., 2 out of 3*) is required for
  reconstruction. **SPIKE Keeper**s discard the `rootKey` and retain only their 
  assigned share after generating the shares.

### SPIKE Nexus Bootstrapping (bottom)

During startup, **SPIKE Nexus** fetches **exactly two shards** (*and no more*) 
from its **SPIKE Keeper** peers. Again, we use **SPIFFE mTLS** for secure
communication.

In the "*reconstruct*" phase (bottom-right):

* **SPIKE Nexus** combines the two collected shards.
* It uses [*Shamir Secret Recovery*][shamir] to reconstruct the `rootKey`.
* It uses the reconstructed key to configure the backing store encryption.

Again, here is a more detailed drill-down of this workflow:

* **Acquire Shards**: **SPIKE Nexus** gathers **exactly two shards** from
  **SPIKE Keeper**s during the bootstrap phase. This is achieved through
  authenticated requests over [**SPIFFE mTLS**][spiffe] connections.
* **Reconstruction**: **SPIKE Nexus** uses [Shamir's Secret Sharing
  Algorithm][shamir] to reconstruct the `rootKey` from the collected shards.
* **Configure Backing Store**: The reconstructed `rootKey` initializes the
  backing store, securing it for further operations.

The following sections will dive deeper into the **SPIKE Keeper** and
**SPIKE Nexus** workflows.

## The SPIKE Keeper Workflow

### Initialization

Each **SPIKE Keeper** generates a random **shard** using a cryptographically 
secure seed. Shards are distributed to other **SPIKE Keeper**s using 
[**SPIFFE mTLS**][spiffe] connections. 

The following code snippet illustrates the initialization logic:

```go
func RandomContribution() []byte {
	myContributionLock.Lock()
	defer myContributionLock.Unlock()

	if len(myContribution) == 0 {
		mySeed, _ := crypto.Aes256Seed()
		myContribution = []byte(mySeed)

		return myContribution
	}

	return myContribution
}
```

### Shard Contribution

**SPIKE Keeper**s exchange shards with peers using authenticated requests. 
The contribution process involves generating a random shard and sending it to 
other **SPIKE Keeper**s.

We use [Cloudflare's CIRCL library][circl] for secret sharing. **CIRCL** is
a well-maintained, audited, and production-ready library that provides
efficient and secure secret sharing capabilities.

Here is an example of shard contribution logic:

```go
func Contribute(source *workloadapi.X509Source) {
	peers := env.Peers()
	myId := env.KeeperId()

	for id, peer := range peers {
		if id == myId {
			continue
		}

		contributeUrl, err := url.JoinPath(
			peer, "v1/store/contribute",
		)
		if err != nil {
			log.FatalLn("Failed to join path: " + 
				err.Error())
 		}

		client, err := net.CreateMtlsClientWithPredicate(
			source, auth.IsKeeper,
		)
		if err != nil {
			panic(err)
		}

		contribution := state.RandomContribution()
		state.Shards.Store(myId, contribution)

		md, err := json.Marshal(reqres.ShardContributionRequest{
			KeeperId: myId,
			Shard:    base64.StdEncoding.EncodeToString(
				contribution),
		})

		_, err = net.Post(client, contributeUrl, md)
		for err != nil {
			time.Sleep(5 * time.Second)
			_, err = net.Post(client, contributeUrl, md)
		}
	}
}
```

### Shard Validation

Once enough shards are collected, **SPIKE Keeper** computes the final `rootKey`.

After this, it computes **Shamir Shares** and discards the `rootKey`.

After that, it also discards all but one of the **Shamir Shares** it computed
and retains only the one assigned to it.

```go
func WaitForShards() {
	for {
		shardCount := 0
		Shards.Range(func(key, value any) bool {
			shardCount++
			return true
		})

		if shardCount < 3 {
			time.Sleep(2 * time.Second)
			continue
		}

		if shardCount > 3 {
			log.FatalLn("too many shards")
		}

		// Compute the final key.
		finalKey := computeFinalKey()
		
		// Compute the Shamir shares off of the final key.
		secret, shares := computeShares(finalKey)
		
		// Save only one shard from the shares and
		// discard everything else
		setInternalShard(shares)
		
		// Self-consistency check to ensure that
		// the reconstructed secret will match
		// the original secret.
		sanityCheck(secret, shares)

		break
	}
}
```

To create shares from the root key, we use [Cloudflare's CIRCL library][circl].

Here are the `computeFinalKey`, `computeShares`, `setInternalShard`, and
`sanityCheck` functions for the sake of completeness:

#### computeFinalKey 

```go 
func computeFinalKey() []byte {
	finalKey := make([]byte, 32)

	counter := 0
	Shards.Range(func(key, value any) bool {
		counter++
		shard := value.([]byte)
		for i := 0; i < 32; i++ {
			finalKey[i] ^= shard[i]
		}
		return true
	})

	if counter != 3 {
		log.FatalLn("computeFinalKey: Not all shards received")
	}

	if len(finalKey) != 32 {
		log.FatalLn("computeFinalKey: key size mismatch")
	}

	return finalKey
}
```

#### computeShares

```go
func computeShares(finalKey []byte) (
    group.Scalar, []secretsharing.Share,
) {
	// Initialize parameters
	g := group.P256
	t := uint(1) // Need t+1 shares to reconstruct
	n := uint(3) // Total number of shares

	// Create secret from your 32 byte key
	secret := g.NewScalar()
	if err := secret.UnmarshalBinary(finalKey); err != nil {
		log.FatalLn(
			e"computeShares: Failed to unmarshal key: %v" + 
			eerr.Error())
	}

	// Create deterministic random source using 
	// the key itself as seed
	// You could use any other seed value for consistency
	deterministicRand := crypto.NewDeterministicReader(finalKey)

	// Create shares
	ss := secretsharing.New(deterministicRand, t, secret)
	return secret, ss.Share(n)
}
```

#### setInternalShard

```go
func setInternalShard(shares []secretsharing.Share) {
	// Sort the keys of env.Peers() alphabetically 
	// for deterministic shard indexing.
	peers := env.Peers()
	peerKeys := make([]string, 0, len(peers))
	for id := range peers {
		peerKeys = append(peerKeys, id)
	}
	sort.Strings(peerKeys)

	myId := env.KeeperId()

	// Find the index of the current SPIKE Keeper's ID
	var myShard []byte
	for index, id := range peerKeys {
		if id == myId {
			// Save the shard corresponding to this Keeper
			if val, ok := Shards.Load(myId); ok {
				myShard = val.([]byte)
				shareVal, _ := shares[
				    index].Value.MarshalBinary()

				SetShard(shareVal)
				EraseIntermediateShards()

				break
			}
		}
	}

	// Ensure myShard is stored correctly in the state namespace
	if myShard == nil {
		log.FatalLn("setInternalShard: id not found")
	}
}
```

#### sanityCheck

```go
func sanityCheck(secret group.Scalar, shares []secretsharing.Share) {
	t := uint(1) // Need t+1 shares to reconstruct

	reconstructed, err := secretsharing.Recover(t, shares[:2])
	if err != nil {
		log.FatalLn("computeShares: Failed to recover: " + 
			err.Error())
	}
	if !secret.IsEqual(reconstructed) {
		log.FatalLn(
		    "computeShares: recovery failure",
        )
	}
}
```

### Deterministic Randomness

The astute reader might notice that while computing the shards, we use a
deterministic random source, using the key itself as a seed. This is done to keep
the shard calculation consistent across all **SPIKE Keeper**s.

Here is the relevant code snippet:

```go
	deterministicRand := crypto.NewDeterministicReader(finalKey)
	ss := secretsharing.New(deterministicRand, t, secret)
```

And here is how the `NewDeterministicReader` function looks:

```go
type DeterministicReader struct {
	data []byte
	pos  int
}

func (r *DeterministicReader) Read(p []byte) (n int, err error) {
	if r.pos >= len(r.data) {
		// Generate more deterministic data if needed
		hash := sha256.Sum256(r.data)
		r.data = hash[:]
		r.pos = 0
	}
	n = copy(p, r.data[r.pos:])
	r.pos += n
	return n, nil
}

func NewDeterministicReader(seed []byte) *DeterministicReader {
	hash := sha256.Sum256(seed)
	return &DeterministicReader{
		data: hash[:],
		pos:  0,
	}
}
```

## The Nexus Workflow

### Polling Keepers

**SPIKE Nexus** queries Keepers for shards using mTLS:

```go
func Tick(ctx context.Context, 
  source *workloadapi.X509Source, ticker *time.Ticker) {
	for {
		select {
		case <-ticker.C:
			keepers := env.Peers()
			shardsCollected := [][]byte{}

			for _, keeperApiRoot := range keepers {
				u, _ := url.JoinPath(keeperApiRoot, 
					"/v1/store/shard")

            client, err := \
                net.CreateMtlsClientWithPredicate(
              source, auth.IsKeeper)
            if err != nil {
                continue
            }

            md, _ := json.Marshal(reqres.ShardRequest{})
            data, err := net.Post(client, u, md)

            var res reqres.ShardResponse
            if err = json.Unmarshal(data, &res); err == nil {
                shard, _ := base64. \
                    StdEncoding.DecodeString(res.Shard)
                shardsCollected = append(
                    shardsCollected, shard,
                )
            }
			}

			if len(shardsCollected) >= 2 {
            reconstructed, _ := secretsharing.Recover(
              1, shardsCollected[:2])
            binaryRec, _ := reconstructed.MarshalBinary()
            state.Initialize(string(binaryRec))
            return
			}
		case <-ctx.Done():
			return
		}
	}
}
```

To reconstruct the secrets, we, again use [Cloudflare's CIRCL library][circl].

Here is how the `state.Initialize()` and other related functions look, for 
completeness:

Here is the `state.Initialize()` function:

```go
func Initialize(r string) {
	// No need for a lock; this method is called only 
	// once during initial bootstrapping.

	persist.InitializeBackend(r)
}
```

And here is the `persist.InitializeBackend()` function:

```go
func InitializeBackend(rootKey string) backend.Backend {
	backendMu.Lock()
	defer backendMu.Unlock()

	log.Log().Info(
		"initializeBackend",
		"msg", "Initializing backend", "storeType", 
			env.BackendStoreType(),
	)

	storeType := env.BackendStoreType()

	switch storeType {
	case env.Memory:
		return &memory.NoopStore{}
	case env.Sqlite:
		return InitializeSqliteBackend(rootKey)
	default:
		return &memory.NoopStore{}
	}
}
```

## Threat Analysis

This system implements a sophisticated approach to root key management with
several layers of security:

### Key Distribution and Access

#### SPIKE Keepers

* Generate and distribute shares of the root key.
* Never have access to the complete key except transiently during initialization.
* After setup, each **SPIKE Keeper** retains only its own Shamir share, which is
  not enough to reconstruct the root key.
* All other key material is **securely erased**.

#### SPIKE Nexus

* Reconstructs the root key from Shamir shares during initialization
* Uses the key to configure SQLite (*or other backing store*) encryption
* Has no programmatic interface to access the root key
* The root key exists only in the SQLite driver's memory space for encryption
  operations.
* The root key material is not directly accessible, even through the 
  application code.

### Randomness in Shamir's Secret Sharing

At first glance, this might look like a security weakness, but it's not.
Here's why:

#### Entropy Source

* `finalKey` is derived from `XOR`ing multiple 32-byte random contributions
* If at least one **SPIKE Keeper** provides true randomness, `finalKey` will be
  random.
* `32 bytes = 256 bits` of entropy  is cryptographically sufficient
* Even in the unlikely event that some **SPIKE Keeper**s are malicious, they
  can't predict or control the `finalKey` value as long as one
  **SPIKE Keeper** is honest.

#### Independence

We're using the same value (*i.e., `finalKey`*) for both:

* The secret that gets shared (via scalar conversion)
* The seed for deterministic randomness in share generation.

This coupling is okay because:

* Shamir Secret Sharing algorithm's security doesn't depend on hiding the
  secret value. In contrast, what matters is the unpredictability of share
  generation
* [`CIRCL`][circl]'s implementation uses the deterministic random only for
  generating polynomial coefficients.The coefficients need to be consistent
  across keepers but don't need to be independent from the secret.

In [CIRCL's implementation][circl], the deterministic random is used to generate
the polynomial coefficients. The security of [Shamir's Secret Sharing][shamir]
relies on the polynomial evaluation, **not** the "*security by obscurity*"
of hiding these coefficients. Therefore, as long as we have sufficient entropy
for unique evaluations, the scheme remains secure.

### Security Properties

The system provides strong security through:

#### Access Control

* Requires multiple **SPIKE Keeper** shares for key reconstruction
* [**SPIFFE workload attestation**][spiffe] ensures only legitimate instances
  participate mTLS secures all network communication

#### Key Protection

* No component retains the complete key in accessible form
  * The original root key is immediately discarded after sharing
  * Each Keeper only maintains knowledge of its own partition and discards the
    rest
* While the key exists in **SPIKE Nexus**'s process memory for backing store
  operations, accessing it would require:
  * Root privileges on the host system
  * Memory inspection capabilities
  * Ability to locate and extract key material from SQLite driver memory space
  * Sophisticated forensics tools
  * Knowledge of the SQLite encryption algorithm and key derivation process
  * Which makes it highly unlikely to compromise the root key

In addition, **SPIKE Nexus** run on a hardened, secure host with
strict access controls, audit logging, and monitoring because **SPIKE**'s
threat model assumes that once an attacker has access to the host system,
the system's security is already compromised.

[In **SPIKE**'s security model][spike-security], the primary trust boundary is
at the machine level. Once the machine is compromised, hardening **SPIKE**
components will provide diminishing returns. In that regard, physical and
OS-level hardening is crucial.

In essence, the security model relies on:

* [**SPIFFE workload attestation**][spiffe] to ensure only legitimate
  **SPIKE Nexus** instances can gather shares, and only legitimate **SPIKE
  Keeper** instances can contribute shares.
* **Network isolation** and **mTLS** to prevent unauthorized access
* The requirement that an attacker would need to compromise multiple
  **SPIKE Keeper**s to reconstruct the key independently.
* **SPIKE Keeper**s never maintaining the complete root key except transiently
  during initialization.
* Each **SPIKE Keeper** only knowing its own Shamir share after initialization,
  which is not enough to reconstruct the root key.
* Or compromise the **SPIKE Nexus** host and gain root access to try extracting
  the root key from memory using sophisticated forensics tools,
  searching for the key material in the SQLite driver memory space.

#### Compromise Resistance

* Compromising a single **SPIKE Keeper** yields only one share, which is
  insufficient to reconstruct the root key.
* Compromising **SPIKE Nexus** application code doesn't expose the key.
* It would require both multiple **SPIKE Keeper** compromises **AND** 
  system-level access to extract key material, which is a very high bar for
  attackers and is highly unlikely to happen.

#### Secure Connectivity

[SPIFFE mTLS][spiffe] secures **all communication channels**, ensuring
**identity verification** and preventing eavesdropping or tampering.

#### Shamir's Secret Sharing

[Shamir's Secret Sharing][shamir] ensures the *root key* is divided into
multiple *shards*, with reconstruction requiring a predefined threshold of
shards. In **SPIKE**'s implementation:

* The root key is split into **three** shards (*configurable*).
* Reconstruction requires **two out of three** shards (*configurable*),
  balancing **redundancy** and **security**.

This model ensures that:

* No single **SPIKE Keeper** can compromise the root key.
* Even if one **SPIKE Keeper** is compromised, the root key remains secure.

#### Zero-Trust Principles

This architecture adheres to the following **zero-trust principles**:

- **Least Privilege**: **SPIKE Keeper**s only manage their shards; they cannot
  reconstruct the root key. During bootstrapping and disaster recovery, they may 
  require additional shards from their peer **SPIKE Keepers**. However, that 
  will be temporary, and the material will be securely erased once the operation 
  is complete.
- **Boundary Enforcement**: It's important to highlight that the **root key never
  leaves the network perimeter**. Only shards cross the network boundary and
  only through secure [**mTLS**][mtls] connections. Even in the very unlikely case
  of a connection compromise, the shards are cryptographically secure and useless
  without the other shards.
- **Identity-Based Access**: [**SPIFFE SVIDs**][spiffe] are used to authenticate
  and authorize all communications.

#### SPIFFE and SPIRE Integration

[**SPIRE**][spire] (*SPIFFE Runtime Environment*) provides **workload attestation**
and **identity issuance**. Each **SPIKE Keeper** and **SPIKE Nexus**
receive a unique *SPIFFE Verifiable Identity Document* (**SVID**), enabling:

* Secure [**mTLS**][mtls] connections between components.
* **Workload identity attestation** to ensure only authorized entities
  participate in shard management.

#### Additional Security Measures

* **Mutual Authentication**: Every interaction between **SPIKE Keeper**s and
  **SPIKE Nexus** is secured by **mTLS**.
* **Shard Validation**: Shards are validated before use to prevent malicious
  tampering.
* **Sanity Checks**: Reconstruction includes checks to ensure the recovered
  secret matches expectations.

## Conclusion

The architecture's zero-trust design ensures that no single 
**SPIKE Keeper** can compromise the `rootKey` while also providing 
threshold-based reconstruction that balances redundancy with strict security. 

Since the number of keepers and the minimum number of shares required for 
reconstruction are configurable, this design can be adapted to the user's risk 
tolerance and security requirements.

Additionally, [**SPIFFE**-based workload
attestation][spiffe] and secure [**mTLS**][mtls] communication work together to
enhance the overall security posture.

**SPIKE**’s **Nexus** and **Keeper** architecture exemplifies how modern
distributed systems can securely manage secrets without compromising
availability or scalability. 

By leveraging [**Shamir’s Secret Sharing**][shamir], [**SPIFFE mTLS**][spiffe], 
and a **zero-trust** design, we ensure that the root key, and, therefore, the
secrets, remain protected against a wide range of threats. 

This approach is secure and pragmatic, offering a scalable solution for managing 
and sharing sensitive material in any distributed system. So, the content 
presented here can have applications beyond the use case covered in this article.

## References and Further Reading

### SPIKE

* [**SPIKE** Website][spike-web]
* [**SPIKE** Source Code][spike]
* [**SPIKE** Security Model][spike-security]
* [**SPIKE** Presentations and Demos][spike-use-case]

### SPIFFE and SPIRE

* [**SPIFFE**][spiffe]
* [**SPIFFE** Concepts][spiffe-concepts]
* [**SPIRE**][spire]
* [mTLS with **SPIRE**][mtls-with-spire]
* [Setting Up **SPIRE** on **EKS** in Less Than Ten Minutes][spire-eks]

### Security and Cryptography

* [Shamir's Secret Sharing][shamir]
* [Cloudflare's CIRCL Library][circl]
* [Advanced Encryption Standard (AES)][aes]
* [Mutual Authentication (mTLS)][mtls]
* [XOR Cipher][xor]

[mtls-with-spire]: https://zerotohero.dev/spire/mtls/
[spiffe-concepts]: https://spiffe.io/docs/latest/spiffe-about/spiffe-concepts/
[spike-use-case]: https://spike.ist/#/presentations/README
[spire-eks]: https://zerotohero.dev/spire/spire-rocks/
[spike-web]: https://spike.ist/
[spire]: https://spiffe.io/docs/latest/spire-about/
[spike]: https://github.com/spiffe/spike
[shamir]: https://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing
[spiffe]: https://spiffe.io/
[circl]: https://github.com/cloudflare/circl
[spike-security]: https://spike.ist/#/architecture/security-model
[aes]: https://en.wikipedia.org/wiki/Advanced_Encryption_Standard
[mtls]: https://en.wikipedia.org/wiki/Mutual_authentication
[xor]: https://en.wikipedia.org/wiki/XOR_cipher
[circl]: https://github.com/cloudflare/circl
