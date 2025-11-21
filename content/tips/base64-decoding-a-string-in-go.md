+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Base64 Decoding a String in Go"
date = "2024-03-01"

[taxonomies]
tags = ["tips", "go", "base64", "encoding", "encoding"]
+++

{{img(
  src="/images/size/w1200/2024/03/strings.png",
  alt="Strings."
)}}

To base64-decode a string in Go, you can use the
`decoding.DecodeString` function from the `encoding/base64` package. 

This function takes a base64-encoded string as input and returns the decoded 
data as a byte slice.

Here's an example:

```go
package main

import (
    "encoding/base64"
    "fmt"
)

func main() {
    // The string to be decoded:
    encoded := "SGVsbG8gV29ybGQh"

    // Decode the string:
    decoded, err := base64.StdEncoding.DecodeString(encoded)

    if err != nil {
        fmt.Println("Error while decoding the string", 
            err.Error())
    }

    // Print the decoded data:
    fmt.Println(string(decoded))
    // Output: Hello World!

    // Encode it back:
    enc := base64.StdEncoding.EncodeToString(decoded)

    // Output: SGVsbG8gV29ybGQh
    fmt.Println("encoded", enc)
}
```

That was your nugget 😄.

Until the next one... May the source be with you 🦄.

--------

## Section Contents

{{ tips_nav(selected=1) }}
