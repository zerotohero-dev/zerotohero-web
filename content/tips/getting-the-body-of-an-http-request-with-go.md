+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Getting the Body of an HTTP Request With Go"
date = "2023-03-01"

[taxonomies]
tags = ["tips", "go", "http", "request"]
+++

![Getting the Body of an HTTP Request With Go](/images/size/w1200/2024/03/http.png)

You can use the io to get the request body from an **HTTP**request
in `io.ReadAll()` function to read the`r.Body` object representing the incoming
request body. Here is an example of how you can do this:

```go
package main

import (
    "errors"
    "fmt"
    "io"
    "net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
    // Read the request body
    body, err := io.ReadAll(r.Body)

    if err != nil {
        // Handle the error by sending an HTTP status code 
        // and message back to the client.
        http.Error(w, "Error reading request body", 
            http.StatusBadRequest)
        return
    }

    // Ensure that request body is closed.
    defer func(Body io.ReadCloser) {
        err := Body.Close()
        if err != nil {
            fmt.Print("Error while closing the body", 
                err.Error())
        }
    }(r.Body)

    // Use the request body here
    // For example, echoing the request body back to the client
    _, err = w.Write(body)
    if err != nil {
        fmt.Println("Error while writing the body", err.Error())
        return
    } // Note: In a real application, check the error from Write
}

func main() {
    // Register the handler function for the root path
    http.HandleFunc("/", handler)

    // Start the HTTP server on port 8080
    // ListenAndServe always returns a non-nil error.
    // After Shutdown or Close, the returned error is 
    // ErrServerClosed.
    if err := http.ListenAndServe(":8080", nil); err != nil {
        if errors.Is(err, http.ErrServerClosed) {
            fmt.Println("Server closed.")
            return
        }

        // Unexpected error. Log and exit.
        panic(err)
    }
}
```

That was your nugget 😄.

Until the next one... May the source be with you 🦄.

## Section Contents

{{ tips_nav(selected=3) }}
