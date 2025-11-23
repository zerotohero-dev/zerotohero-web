+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Exploring Rust as a Go Developer"
date = "2024-07-21"

[taxonomies]
tags = ["development","go","learning","tips"]
+++

{{img(
  src="/images/2024/rust/go-rust.png",
  alt="Learning from each other."
)}}

## Introduction

In this article, I will explore [**Rust**][rust] from the perspective of a 
[**Go**][go] developer.

I am using this article as my study notes while learning Rust. 

While I'll occasionally compare [**Rust**][rust] with [**Go**][go], I will not 
focus on the differences too much. I will highlight the features of **Rust** 
and share my thoughts on the language instead.

## How To Read This Article

As in any profound topic, it's virtually impossible to introduce basic concepts
without referring to more advanced ones, and vice versa. So, this article 
feels more like a directed graph than a linear narrative. 

To get the best value out of this article, I recommend reading four times:

* Read it from start to finish once, getting a general idea of the concepts.
* Read it again, focusing on the details and examples, using your favorite
  editor to write, run, and experiment with the code, changing it and trying
  to see what happens.
* And one final time, doing a deep dive and exploring the concepts in a
  non-linear way, jumping from one section to another, and trying to connect
    the dots.
* And one final time, but, this time doing the exploration with external 
  supporting resources, such as [the Rust documentation][rust-book], [Rust by
  Example][rust-by-example], [Rustlings][rustlings], [Reddit][r-rust],
  [Rust on YouTube][rust-youtube], and the [Programming Rust][programming-rust]
  book.

## The Tooling

Before we even get started with Rust, let's install the toolchain.

I am on a Mac, so my instructions will be for macOS. Adjust them as needed
for your operating system.

We'll install [`rustup`][rust-up], which is the recommended tool to install Rust 
and Cargo, the Rust package manager.

```bash
curl https://sh.rustup.rs -sSf | sh
```

The command above will download a script and start the installation.

By the end of the process you should see something like this:

```txt
Rust is installed now. Great!
```

To check that everything is working, run:

```bash
rustc --version
# Output will look like: 
# 1.79.0 (129f3b996 2024-06-10)

cargo --version
# Output will look like:
#  1.79.0 (ffa9cf99a 2024-06-03)
```

## Choosing an IDE

You can program Rust in your favorite text editor or IDE.

Some popular choices are:

* [Visual Studio Code](https://code.visualstudio.com/)
* [RustRover](https://www.jetbrains.com/rust/)
* [Vim](https://www.vim.org/)

I prefer [RustRover](https://www.jetbrains.com/rust/) because I am already
familiar with JetBrains products and their keyboard shortcuts; however,
you should choose the one that you feel most comfortable with.

## Creating a New Project

To create a new Rust project, use the `cargo` command:

```bash
# Go to a common workspace directory:
cd $WORKSPACE
# "hello-rust" is the name of the project:
cargo new hello-rust
# Switch to the project directory:
cd hello-rust
# Run the project:
cargo run
 
# Output will look like:
#
#   Compiling hello-rust v0.1.0 
#    Finished `dev` profile [unoptimized + debuginfo] target(s) 
#     Running `target/debug/hello-rust`
#
# Hello, world!
```

## Hello Rust

`cargo new` creates a new project with the following structure:

```txt
├── Cargo.lock
├── Cargo.toml
├── src
│   └── main.rs
└── target
```

Here is the content of `./src/main.rs`:

```rust
fn main() {
    println!("Hello, world!");
}
```

* The `fn` keyword is used to define a function.
* The `main` function is the entry point of the program.
* The `println!` [macro][macro] is used to print text to the console.
* Indentation is not significant in Rust, the style guide suggest using 
  **four spaces** for indentation.

By merely looking at this "*Hello, world*" example, syntactically, Rust feels 
a bit like Go, with its own oddities and quirks.

When you run the above code using `cargo run`, the output should be similar 
to the following:

`println()!` is a macro that prints text to the console and returns the unit
type `()`. This is similar to `void` in other languages.

```bash
cargo run

# Output:
#   Finished `dev` profile target(s) in 0.04s
#   Running `target/debug/hello-rust`
# Hello, world!
```

Not bad for a first program, right?

## Unit Type

The unit type `()` in Rust is a special type that represents an empty tuple. 
It's often referred to as the "*unit*" type because it has only one value, 
which is also written as `()`. This type and its value are used in situations 
where you need to return or represent "nothing" in a type-safe way.

The unit type occupies no memory because it contains no data.

The unit time is commonly used in the following scenarios:

* As a return type for functions that perform an action but don't produce a 
  meaningful result (*similar to `void` in C or C++*).
* As a placeholder in generic types.
* In `Result<T, E>`: when there's no meaningful success value, you might use 
  `Result<(), E>`.
* In expressions: The unit value `()` is the implicit return value of 
  expressions if no other value is returned.
* If a function doesn't return a value, it implicitly returns `()`.

Here are some interesting use cases of the unit type:

```rust
struct Holder<T> {
    value: Option<T>,
}

trait Callable {
    type Output;
    fn call(&self) -> Self::Output;
}

struct NoOp;

impl Callable for NoOp {
    type Output = ();
    fn call(&self) -> Self::Output {
        // Do nothing and return ()
    }
}

fn main() {
    // Using () as a placeholder when we don't need to store any data
    let empty_holder: Holder<()> = Holder { value: None };
    
    // Using an actual type when we want to store data
    let int_holder: Holder<i32> = Holder { value: Some(42) };
    
    let no_op = NoOp;
    let result = no_op.call();
    assert_eq!(result, ());
}
```

We will see more about traits and generics later in this article where the
above example will make more sense.

## Rust Tooling

Rust comes with a set of tools that help you write, build, and test your code.

Here are some of the most commonly used tools:

* `rustc`: The Rust compiler.
* `cargo`: The Rust package manager and build tool.
* `rustup`: The Rust toolchain installer.
* `rustdoc`: The Rust documentation generator.
* `clippy`: A linter for Rust code.
* `rustfmt`: A code formatter for Rust code.

There are more tools that you can install as needed using `cargo install`.

## `rustfmt` And Code Formatting

Rust has something similar to `gofmt`. It's called `rustfmt`.

Here are some key points about `rustfmt`:

* **Purpose**: Like `gofmt`, `rustfmt` is an automatic code formatter for Rust. It
  enforces a consistent coding style across Rust projects.
* **Installation**: It comes bundled with Rust when you install via `rustup`.
* **Usage**: You can run it from the command line: `rustfmt filename.rs` or
  format an entire project: `cargo fmt`.
* **IDE Integration**: Most Rust-aware IDEs and text editors can be configured
  to run rustfmt automatically on save.
* **Configuration**: Unlike `gofmt`, which is deliberately unconfigurable,
  `rustfmt` allows some customization through a `rustfmt.toml` file in your
  project root.
* **Style Guide**: `rustfmt` follows the Rust style guide by default, which
  helps maintain consistency across the Rust ecosystem.
* **CI Integration**: Many projects run `rustfmt` in their CI pipelines to
  ensure all code follows the agreed-upon style.

## Crates

* Crates are the smallest amount of code that the Rust compiler considers at a time.
* They can contain modules, and the modules may be split into different files.

### Types of Crates

There are two types of crates:

* **Binary Crates**: Compile to an executable
* **Library Crates**: Don't compile to an executable but are meant to be used
  in other programs

### Using External Crates

Add dependencies to your `Cargo.toml` file:

```toml
[dependencies]
rand = "0.8.5"
```

Then use the crate in your code:

```rust
use rand::Rng;

fn main() {
    let random_number = rand::thread_rng().gen_range(1..101);
    println!("Random number: {}", random_number);
}
```
### Creating Your Own Crate

* Use `cargo new my_crate` for a binary crate
* Use `cargo new my_crate --lib` for a library crate

### Publishing a Crate

* Sign up for an account on `crates.io`
* Set up your crate metadata in `Cargo.toml`
* Use `cargo publish` to publish your crate

### Cargo Workspaces

Cargo workspaces can manage multiple related crates.

Workspaces can also allow you to manage multiple related packages from one
location.

### Crate Features

Create features allow conditional compilation of crate functionalities.

### Alternative Registries

* Cargo supports alternative registries other than `crates.io`.
* You can set up your own private registry.
* You can even use Git repositories as dependencies.
* For local development, you can use path dependencies to reference local crates.
* There are also options for hosting your own private crate registry.

Here is how you would configure Cargo to user your private registry:

In `.cargo/config.toml`:

```toml
[registries]
my-company = { index = "https://my-company-registry.com/index" }
```

In your project's `Cargo.toml`:

```toml
[dependencies]
private-crate = { version = "0.1.0", registry = "my-company" }
```

Or you can specify Git dependencies like this.

```toml
[dependencies]
private-crate = { git = "https://github.com/my-company/private-crate.git", branch = "dev" }
```

Here is how to create path dependencies:

```toml
[dependencies]
private-crate = { path = "../private-crate" }
```

## What Is a Macro?

In Rust, a [macro][macro] is a way of writing code that writes other code, 
which is also known as [metaprogramming][metaprogramming]. 

Macros provide a powerful and flexible tool to generate repetitive code, 
define domain-specific languages, or even alter the syntax of Rust itself.

I'll go back to macros later, but now let's focus our attention on more funner 
things.

## About Stack Memory and Heap Memory

Before going any further, it's essential to understand the difference between
stack and heap memory models as they come up frequently in Rust programming,
and they will immensely clarify your understanding of the important concepts
such as ownership, borrowing, and lifetimes.

I'll, again, get into the details of what *ownership*, *borrowing* and 
*lifetimes* are later in this article, but here's a concise explanation of 
**why** *stack* and *heap* memory are important in **Rust**:

* **Ownership and borrowing**: Rust's ownership rules are closely tied to how
  data is stored on the stack or heap. This affects how variables are passed,
  moved, or borrowed.
* **Performance**: Stack allocations are generally faster than heap allocations.
  Knowing where data is stored helps in writing more efficient code.
* **Lifetimes**: The stack's LIFO (*Last In, First Out*) nature directly relates
  to Rust's lifetime concept, which ensures memory safety.
* **Memory safety**: Rust's guarantees about preventing null or dangling pointer
  dereferences, data races, and buffer overflows are implemented through strict
  control over stack and heap usage.
* **Resource management**: Understanding stack vs. heap helps in making informed
  decisions about how to structure data for optimal resource use.
* **Zero-cost abstractions**: Rust's ability to provide high-level abstractions
  without runtime overhead is partly due to its sophisticated use of stack and
  heap.

Having said that, let's dive into the details of stack and heap memory.

### Stack Memory

* Stack memory is dynamically allocated and deallocated, but in a very specific
  way. Allocation and deallocation happen automatically as functions are called
  and return.
* Stack follows a strict last-in, first-out (*LIFO*) order.
* The size of stack allocations must be known at compile time.

### Heap Memory

* Heap memory, can be allocated and deallocated at any time during program
  execution. This allows for more flexible memory management.
* The size can be determined at runtime.
* On the stack, the allocations and deallocations occur automatically with
  function calls and returns. Whereas on the heap, the allocations and
  deallocations can happen at any point in the program's execution.

### Size Flexibility

* **Stack**: The size of allocations must be known at compile time.
* **Heap**: The size can be determined at runtime.

### Lifetime

* **Stack**: Memory is automatically reclaimed when a function returns.
* **Heap**: Memory persists until explicitly deallocated or the program ends.

### Speed

* **Stack**: Generally faster, as it just involves moving a stack pointer.
* **Heap**: Typically slower, as it involves more complex memory management.

### Fragmentation

* **Stack**: Less prone to fragmentation.
* **Heap**: More susceptible to memory fragmentation over time.

In Rust, Stack versus Heap distinction is particularly important because the
language's ownership system and borrowing rules are designed to make stack
allocation safe and efficient while also providing tools for safe heap
allocation when needed.

## Fat Pointers

A fat pointer in Rust, as it relates to the String type, refers to a pointer 
that contains not just the memory address of the data, but also additional 
information about the data it points to. In the case of `String` data type
(*that we'll see later*), the fat pointer contains three pieces of information:

* A **pointer** to the heap-allocated buffer containing the string data,
* The **length** of the string (*number of bytes currently in use*),
* And the **capacity** of the allocated buffer (*total number of bytes 
  allocated*).

<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 300">
  <!-- Fat Pointer Box -->
  <rect x="10" y="10" width="280" height="100" fill="none" stroke="black" stroke-width="2"/>
  <text x="20" y="30" font-family="Arial" font-size="14">Fat Pointer (String)</text>

  <!-- Pointer -->
  <rect x="20" y="40" width="80" height="30" fill="lightblue" stroke="black"/>
  <text x="30" y="60" font-family="Arial" font-size="12">Pointer</text>

  <!-- Length -->
  <rect x="110" y="40" width="80" height="30" fill="lightgreen" stroke="black"/>
  <text x="120" y="60" font-family="Arial" font-size="12">Length: 5</text>

  <!-- Capacity -->
  <rect x="200" y="40" width="80" height="30" fill="lightyellow" stroke="black"/>
  <text x="210" y="60" font-family="Arial" font-size="12">Capacity: 8</text>

  <!-- Heap memory -->
  <rect x="10" y="160" width="400" height="60" fill="none" stroke="black" stroke-width="2"/>
  <text x="20" y="180" font-family="Arial" font-size="14">Heap Memory</text>

  <!-- String content -->
  <rect x="20" y="190" width="240" height="20" fill="lightpink" stroke="black"/>
  <text x="30" y="205" font-family="Arial" font-size="12">H</text>
  <text x="70" y="205" font-family="Arial" font-size="12">e</text>
  <text x="110" y="205" font-family="Arial" font-size="12">l</text>
  <text x="150" y="205" font-family="Arial" font-size="12">l</text>
  <text x="190" y="205" font-family="Arial" font-size="12">o</text>

  <!-- Unused capacity -->
  <rect x="260" y="190" width="140" height="20" fill="lightgray" stroke="black"/>
  <text x="270" y="205" font-family="Arial" font-size="12">Unused</text>

  <!-- Arrow -->
  <line x1="60" y1="70" x2="60" y2="190" stroke="black" stroke-width="2" marker-end="url(#arrowhead)"/>

  <!-- Arrow marker -->
  <defs>
    <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="0" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" />
    </marker>
  </defs>
</svg>

This structure allows Rust to efficiently manage String objects with several 
benefits:

* **O(1) length checks**: The length is stored directly in the fat pointer, so 
  checking the length of a string is a constant-time operation.
* ** **Efficient capacity management**: By tracking both length and capacity, 
  Rust can avoid unnecessary allocations when growing strings.
* **Safe borrowing**: The fat pointer enables Rust to enforce borrowing rules at 
  compile-time, preventing data races and other memory safety issues. We will 
  cover borrowing and ownership in more detail later in this article.
* **Efficient slicing**: Creating string slices (`&str`) is cheap because they 
  can reuse the same heap-allocated buffer while adjusting the pointer and 
  length.

It's worth noting that while we commonly refer to this as a "*fat pointer*," 
in Rust terminology, it's more accurately described as a `struct` containing a 
`pointer` and two `usize` values for `length` and `capacity`.

## In a Nutshell

### Stack

* Fast allocation and deallocation
* Fixed size, known at compile time
* LIFO (*Last In, First Out*) data structure
* Limited in size
* Automatically managed by the program

### Heap

* Slower allocation and deallocation
* Dynamic size, can grow or shrink at runtime
* No particular order of allocation/deallocation
* Limited only by system memory
* Manually managed (*in many languages, but Rust helps automate this*)

### Key Differences

* **Performance**: Stack allocation is generally faster because it's just a
  matter of moving the stack pointer. Heap allocation requires more complex
  bookkeeping.
* **Size flexibility**: If you need a data structure that can change size,
  you'll need to use the heap.
* **Lifetime**: Stack-allocated data lives only as long as the function it's in.
  Heap-allocated data can live for as long as it's needed, even beyond the
  function it was created in.
* **Ownership**: In Rust, heap-allocated data is subject to **ownership rules**,
  which help prevent memory leaks and data races. We will cover the concept of
  ownership later in this article.

Rust's borrow checker and ownership system help manage heap allocations safely
without a garbage collector, which is one of its key innovations.

Here's a simple example to illustrate what is allocated where:

```rust
fn main() {
    // Stack allocation
    let x = 5; // Integer, known fixed size
    let y = true; // Boolean, known fixed size

    // Heap allocation
    let s = String::from("hello"); // String, can grow or shrink

    // Vector (similar to slice in Go) is heap-allocated
    let v = vec![1, 2, 3, 4, 5]; 
}
```

In this example:

* `x` and `y` are stack-allocated. Their size is known at compile time, and
  they're automatically pushed onto and popped off the stack.
* `s` and `v` are heap-allocated. The `String` and `Vector` can grow or shrink,
  so they're stored on the heap. What's on the stack is actually a pointer to
  the heap data, along with length and capacity information.

Having overviewed pointers, and how memory management in the **stack** and 
**heap**, now let's shift gears and move on to some basic Rust syntax.

## Variables and Mutability

Variables are **immutable** by default. This means that once a variable
is assigned a value, it cannot be changed.

```rust
fn main() {
    let x = 5; // Immutable
    println!("The value of x is: {}", x);
    
    // x = 6; // This would cause an error
    
    let mut y = 5; // Mutable
    println!("The value of y is: {}", y);
    
    y = 6; // This is allowed
    println!("The value of y is now: {}", y);
}
```

* `let` is used to define variables (*similar to `:=` in Go*).
* Adding `mut` makes things mutable.
* The `{}` in `println!` is a placeholder for the value of the variable.

## Returning From Functions

To define a function, we use the `fn` keyword. Functions can return values
either explicitly using the `return` keyword or implicitly by omitting the
semicolon at the end of the expression.

If you are omitting the semicolon, what you return should be the last
expression in the function.

Here are some examples:

### Returning From a Block

```rust
fn main() {
    let x = {
        let y = 5;
        y + 1  // No semicolon here
    };
  
    println!("The value of x is: {}", x); // This will print 6
}
```

### Implicit Return

```rust
// Implicit return
fn add(a: i32, b: i32) -> i32 {
    a + b  // Note: no semicolon
}
```

### Explicit Return

```rust
// Explicit return
fn subtract(a: i32, b: i32) -> i32 {
    return a - b;
}
```

### Mixed Style

```rust
// Mixed style
fn abs(x: i32) -> i32 {
    if x < 0 {
        return -x; // Early return
    }

    x  // Implicit return for the positive case
}
```

Implicit return in Rust allows for allows for concise return statements and 
is particularly useful in [functional-style programming][fp] patterns.

## Coding Conventions

In **Rust**, the convention is to use `snake_case` for both functions and
variables. This is different from *Go*, which uses `camelCase` for functions
and variables.

Another difference between Rust and Go is, by convention you indent using
"*four spaces*" in Rust, whereas in Go you use Tab for indentation.

Here's a quick overview of Rust naming conventions:

```rust
// Functions: snake_case
fn calculate_total()

//Variables: snake_case
let user_name = "Alice";

// Constants: SCREAMING_SNAKE_CASE
const MAX_CONNECTIONS: u32 = 100;

// Types (structs, enums, traits): PascalCase
struct UserProfile {}

// Modules: snake_case
mod network_utils;

// Macros: Usually snake_case!
println!(), vec![]
```

Here's a small example demonstrating these conventions:

```rust
const MAX_USERS: u32 = 100;

struct UserAccount {
    user_name: String,
    email: String,
}

fn create_user(name: &str, email: &str) -> UserAccount {
    UserAccount {
        user_name: String::from(name),
        email: String::from(email),
    }
}

fn main() {
    let new_user = create_user("alice", "alice@example.com");
    println!("Created user: {}", new_user.user_name);
}
```

Following these conventions helps make Rust code more consistent and easier to
read across different projects and the Rust ecosystem. They are not enforced
by the compiler, but it's considered good practice following them.

## Data Types

Rust has a strong, static type system, which means that the type of every
variable must be known at compile time.

```rust
fn main() {
    // Integer types
    let a: i32 = 5;  // 32-bit signed integer
    let b: u64 = 100;  // 64-bit unsigned integer

    // Floating-point types
    let c: f64 = 3.14;  // 64-bit float

    // Boolean type
    let d: bool = true;

    // Character type
    let e: char = 'z';

    // String type
    let f: String = String::from("Hello, Rust!");

    println!("{}, {}, {}, {}, {}, {}", a, b, c, d, e, f);
}
```

* Type annotations are optional if Rust can infer the type.
* Integers can be signed (`i8`, `i16`, `i32`, `i64`, `i128`) or unsigned
  (`u8`, `u16`, `u32`, `u64`, `u128`).
* Floats come in `f32` and `f64`.
* Booleans are `true` or `false`.
* Chars are **Unicode** scalar values.
* Strings are **UTF-8** encoded.

## `String` versus `&str`

> **Stack and Heap**
> 
> If you haven't paid attention to the Stack and Heap memory section near the
> beginning of this article, now is the time to revisit it.

`String` and `&str` are two different types used for working with text, each 
with its own characteristics and use cases. 

Let's see some of the key differences:

### Allocation

#### `String`

The `String` type itself is typically allocated on the stack.

However, the actual string **data** that the `String` manages is allocated on 
the heap. This allows `String` to be resizable, as heap memory can be 
dynamically allocated and deallocated.

#### `&str`

The `&str` itself (the reference or "*fat pointer*") is typically allocated on 
the **stack**.

The data it refers to can be anywhere in memory, depending on its origin:

* If it's a string literal, the data is in the *read-only data* section of the 
  program's memory.
* If it's a slice of a `String`, the data it refers to is on the heap (*where
  the `String`'s data lives*).
* If it's a slice of a string in a static variable, the data is in the *static 
  memory* section.

Here is a diagram to illustrate the difference:

<svg viewBox="0 0 500 300" xmlns="http://www.w3.org/2000/svg">
  <rect x="10" y="10" width="230" height="280" fill="#f0f0f0" stroke="#000" />
  <text x="15" y="30" font-family="Arial" font-size="16">Stack</text>

  <rect x="260" y="10" width="230" height="280" fill="#e0e0e0" stroke="#000" />
  <text x="265" y="30" font-family="Arial" font-size="16">Heap</text>

  <rect x="20" y="50" width="100" height="60" fill="#ff9999" stroke="#000" />
  <text x="25" y="70" font-family="Arial" font-size="14">String</text>
  <text x="25" y="90" font-family="Arial" font-size="12">ptr</text>
  <text x="25" y="105" font-family="Arial" font-size="12">len: 5</text>

  <rect x="270" y="50" width="120" height="30" fill="#ff9999" stroke="#000" />
  <text x="275" y="70" font-family="Arial" font-size="14">"Hello"</text>

  <path d="M120 80 L270 65" stroke="#000" fill="none" />

  <rect x="20" y="150" width="100" height="40" fill="#99ff99" stroke="#000" />
  <text x="25" y="170" font-family="Arial" font-size="14">&amp;str</text>
  <text x="25" y="185" font-family="Arial" font-size="12">ptr, len</text>

  <rect x="270" y="200" width="200" height="30" fill="#cccccc" stroke="#000" />
  <text x="275" y="220" font-family="Arial" font-size="14">"Static string data"</text>

  <path d="M120 170 L270 215" stroke="#000" fill="none" />
</svg>

Here is another diagram that illustrates a program's memory layout:

<svg viewBox="0 0 300 400" xmlns="http://www.w3.org/2000/svg">
  <rect x="10" y="10" width="280" height="380" fill="#f0f0f0" stroke="#000" />

  <rect x="20" y="20" width="260" height="60" fill="#ffcccc" stroke="#000" />
  <text x="30" y="50" font-family="Arial" font-size="14">Stack</text>

  <rect x="20" y="90" width="260" height="100" fill="#ccffcc" stroke="#000" />
  <text x="30" y="120" font-family="Arial" font-size="14">Heap</text>

  <rect x="20" y="200" width="260" height="60" fill="#ccccff" stroke="#000" />
  <text x="30" y="230" font-family="Arial" font-size="14">Static/Global Memory</text>

  <rect x="20" y="270" width="260" height="60" fill="#ffffcc" stroke="#000" />
  <text x="30" y="300" font-family="Arial" font-size="14">Read-only Data</text>

  <rect x="20" y="340" width="260" height="40" fill="#ffccff" stroke="#000" />
  <text x="30" y="365" font-family="Arial" font-size="14">Code (Text)</text>
</svg>

### Ownership

I will cover ownership later in this article, but for now, remember that:

* `String` is an **owned type**, meaning it owns its data and is responsible for 
  allocating and deallocating memory.
* `&str` is a **borrowed type**, specifically a string slice. It's a reference 
  to a sequence of UTF-8 bytes, typically part of another string or string-like 
  data.

### Mutability

* `String` is **mutable** by default. You can modify its contents, append to it, 
etc.
* `&str` is **immutable**. You cannot modify the contents of a string slice.

### Memory Allocation

String allocates memory on the heap. It can grow or shrink as needed.
&str doesn't allocate memory; it's just a view into existing memory.

### Flexibility

* `String` is more flexible. You can easily append, remove, or modify its 
  contents.
* `&str` is more rigid but more efficient for read-only operations.

### Common Uses

* Use `String` when you need to own and **modify** string data.
* Use `&str` for function parameters, string literals, or when you only need to 
  **read** string data.

## Conversion between `String` and `&str`

* You can convert a `String` to a `&str` with `&`.
* Converting `&str` to `String` requires allocation (*e.g.,
  `String::from()` or `.to_string()`).

Likely, `&str` will often be used for function parameters when you just need
to read the string data, and `String` when you need to own or modify the string.

```rust
fn print_string(s: &str) {
    println!("{}", s);
}

fn main() {
    let s1 = "Hello";  // &str
    let s2 = String::from("World");  // String

    print_string(s1);
    print_string(&s2);  // &String coerces to &str
}
```

## Functions

Now, let's look at how we define functions in Rust. We have already seen one
function at least: `main()`. Here are some more examples:

```rust 
fn main() {
    println!("Sum: {}", add(5, 3));
    println!("Difference: {}", subtract(5, 3));
}

fn add(x: i32, y: i32) -> i32 {
    x + y  // Note: no semicolon here
}

fn subtract(x: i32, y: i32) -> i32 {
    return x - y;  // Using 'return' keyword
}
```

* Functions are declared using `fn`.
* Parameters are typed.
* Return type is specified after `->`.
* You can use an implicit return (*last expression without semicolon*) 
  or the return keyword.

## References

`&` in Rust is similar to but not exactly the same as the *address-of* operator
in languages like C or C++.

In Rust, `&` is used to create a **reference**, which is similar to a pointer
but with some important differences:

References in Rust:

* Are always valid (*i.e., non-null*)
* Have a **lifetime**
* Can be **mutable** or **immutable**
* Don't require manual memory management

In comparison, the address-of operator in C/C++:

* Returns a raw memory address
* Can be `null`
* Doesn't have built-in lifetime tracking
* Doesn't distinguish between mutable and immutable at the type level

Here's a simple example to illustrate this concept:

```rust
fn main() {
    let x = 5;
    let y = &x;  // y is a reference to x

    println!("x is: {}", x);
    println!("y is: {}", y);  // This will print the value, not the address
    println!("y points to: {}", *y);  // Dereferencing, similar to C/C++
}

// Output:
// x is: 5
// y is: 5
// y points to: 5
```

* &x creates a reference to x, not just its memory address.
* When you print y, you get the value it points to, not the address.
* You can use *y to explicitly dereference, similar to C/C++. Which will
  again print the value `y` points to.

Rust also distinguishes between mutable and immutable references:

```rust
fn main() {
    let mut a = 10;
    let b = &a;     // Immutable reference
    let c = &mut a; // Mutable reference

    // *b += 1;  // This would be a compile-time error
    *c += 1;     // This is allowed

    println!("a is now: {}", a);
}
```

In this example:

* `&a` creates an immutable reference
* `&mut a` creates a mutable reference

Which also means, references are immutable by default.

Here are some more examples to illustrate the concept of references:

```rust
fn main() {
    let a = 42;

    // a = 43; // error: a is immutable.

    let mut b = 42;
    b = 43; // this is fine.

    let c = &a; // immutable reference to a
    // c = &b; // not allowed; c is immutable.

    // mutable variable holding immutable reference:
    let mut c = &a;
    c = &b; // This is fine.

    let d = &a;
    // d = d + 1; // not allowed: &a is immutable.

    let mut z = 42;

    let e = &mut z;
    *e = *e + 1;
    
    println!("{}", e);
}
```

## Borrow Rules

The Rust *borrow checker* enforces rules about these references:

* You can have any number of immutable references to a value
* **OR** you can have exactly one mutable reference
* **BUT** you can't have both at the same time

This system allows Rust to prevent data races at compile time, which is a key
feature of the language.

Hold onto these rules because they will be important. We will cover them later
in more detail with examples.

## Aren't References Just Pointers?

In Rust, we say "**reference to**" rather than "*pointer to*"
(*unlike Go, or C*) for several reasons:

* **Safety**: References in Rust are always valid. They can never be `null` and
  are guaranteed to point to valid memory. This is unlike raw pointers in
  languages like C or C++, which can be null or dangling.
* **Borrowing semantics**: References in Rust come with built-in rules about
  how they can be used, enforced by the borrow checker. These rules prevent
  data races and ensure memory safety.
* **Abstraction level**: References operate at a higher level of abstraction
  than raw pointers. They're designed to be safe and ergonomic to use, hiding
  some of the low-level details that pointers expose.
* **Lifetime association**: References in Rust have an associated lifetime,
  which the compiler uses to ensure they don't outlive the data they refer to.
* **Semantic meaning**: The term "*reference*" implies a **temporary** borrowing
  of data, which aligns well with Rust's ownership model. You're "*referring*"
  to data owned by someone else, not taking possession of it.
* **Distinction from raw pointers**: Rust does have raw pointers (*`*const T`
  and `*mut T`*), which are more similar to pointers in C. By using different
  terminology, Rust makes a clear distinction between its safe references and
  these unsafe raw pointers.

It's worth noting that despite the different terminology, Rust references are
typically implemented as pointers under the hood. The difference is in the
**guarantees** and **rules** that Rust provides around their use.

## What Kinds of Return to Use Where

* For short, single-expression functions, implicit return is often preferred as
  it's more concise.
* For longer functions or those with complex logic, explicit returns can 
  sometimes be clearer, especially for early returns.
* The Rust style guide doesn't strictly mandate one over the other, but it does
  encourage consistent style within a codebase.
* Many *Rustaceans* prefer implicit returns where possible, as it aligns well 
  with Rust's expression-based nature.
* The `return` keyword is always necessary for early returns (*i.e., returning
  before the end of the function body*).
* For very short functions, you might see the body written on the same line as
  the function signature: `fn square(x: i32) -> i32 { x * x }`

The key is to **prioritize readability and consistency**. Choose the style that
makes your code clearest in each specific context.

## Dereferencing in Rust

Rust handles dereferencing differently (*and more ergonomically*) from C.

In C here is how you would dereference:

```cpp
x = 5;
int* ptr = &x;
printf("Address: %p\n", (void*)ptr);  // Prints hexadecimal address
printf("Value: %d\n", *ptr);          // Prints 5
```

Whereas in Rust here is how it works:

```rust
fn main() {
    let x = 5;
    let ref_x = &x;
    
    println!("ref_x: {:p}", ref_x);  // Prints hexadecimal address
    println!("Value: {}", ref_x);    // Prints 5
    println!("Also value: {}", *ref_x);  // Also prints 5
}
```

* In Rust, when you print a reference with `{}`, it automatically dereferences 
  and prints the value.
* To print the address, you need to use the `{:p}` format specifier.

In Rust, you can use `*ref_x` to explicitly dereference, similar to C.
However, in many contexts, Rust will *automatically* dereference for you.

Also, it's worth to mention once more that Rust references are always valid, so 
you don't risk undefined behavior by dereferencing a null pointer.

## Format Specifiers

Rust uses a powerful formatting system that allows for flexible and precise 
control over how values are displayed. Here's an overview of the common 
format specifiers:

* `{}`: Default formatter
  * Used for general purpose formatting
  * Automatically chooses an appropriate format based on the type
* `{:?}`: Debug formatter
  * Outputs a debug representation of a value
  * Useful for debugging and development
* `{:#?}`: Pretty print debug formatter
  * Similar to `{:?}`, but with more readable, multi-line output
* `{:b}`: Binary formatter
  * Outputs integers in binary format
* `{:o}`: Octal formatter
  * Outputs integers in octal format
* `{:x}`: Lowercase hexadecimal formatter
  * Outputs integers in lowercase hexadecimal format
* `{:X}`: Uppercase hexadecimal formatter
  * Outputs integers in uppercase hexadecimal format
* `{:e}`: Lowercase exponential notation
  * Formats floating-point numbers in scientific notation with a lowercase "e".
* `{:E}`: Uppercase exponential notation
  * Formats floating-point numbers in scientific notation with an uppercase "E".
* `{:.}`: Precision specifier
  * Controls the number of decimal places for floating-point numbers. For 
    example, `{:.2}` for two decimal places
* `{:width$}`: Width specifier
  * Sets the minimum width of the output. Pads with spaces if the value is 
    shorter than the specified width
* `{:0width$}`: Zero-padded width specifier 
  * Similar to `width$`, but pads with zeros instead of spaces
* `{:<}`, `{:^}`, `{:>}`: Alignment specifiers
  * Left-align, center-align, and right-align respectively
* `{:+}`: Sign specifier
  * Always prints the sign (*`+` or `-`*) for numeric types

Here is an example code that demonstrates these:

```rust
fn main() {
    let num = 42;
    let pi = 3.14159;
    let name = "Alice";

    // Default formatter
    println!("Default: {}", num);

    // Debug formatter
    println!("Debug: {:?}", num);

    // Pretty print debug formatter
    let complex_data = vec![1, 2, 3];
    println!("Pretty print debug: {:#?}", complex_data);

    // Binary, octal, and hexadecimal formatters
    println!("Binary: {:b}", num);
    println!("Octal: {:o}", num);
    println!("Lowercase hex: {:x}", num);
    println!("Uppercase hex: {:X}", num);

    // Exponential notation
    println!("Lowercase exponential: {:e}", pi);
    println!("Uppercase exponential: {:E}", pi);

    // Precision specifier
    println!("Pi with 2 decimal places: {:.2}", pi);

    // Width specifier
    println!("Width of 10: {:10}", num);

    // Zero-padded width specifier
    println!("Zero-padded width of 5: {:05}", num);

    // Alignment specifiers
    println!("Left-aligned: {:<10}", name);
    println!("Center-aligned: {:^10}", name);
    println!("Right-aligned: {:>10}", name);

    // Sign specifier
    println!("Always show sign: {:+}", num);

    // Combining specifiers
    println!("Combined: {:+10.2}", pi);
}
```

## Method Calls on References

In Rust, you can call methods on references without explicit dereferencing:

```rust
let s = String::from("hello");

let len = (&s).len(); // Works, but parentheses are unnecessary
let len = s.len();    // This is the idiomatic way
```

Here is a more intricate example:

```rust
let s = String::from("hello");

let len = &s.len();   // Works, but & is unnecessary
let len = (*s).len(); // Works, but unusual
let len = (&s).len(); // Works, but & is unnecessary
let len = s.len();    // This is the idiomatic way
```

Let's break down what's happening here:

* `&s.len()`: This takes a reference to the result of s.len(). It's unnecessary 
  but harmless. In Rust, when you call a method on a value, you don't need to 
  explicitly take a reference. The compiler automatically borrows a reference 
  when calling methods.
* `(*s).len()`: Although it looks (*and feels*) invalid, this is actually valid 
  Rust code. `*s` would typically mean "*dereference s*", but `String` 
  implements the Deref `trait` (*we will se more about traits later*). When 
  you use `*` on a type that implements `Deref`, it calls the `deref` method, 
  which for `String` returns a `&str`. So `(*s).len()` is equivalent to 
  `s.deref().len()`, which works but is **unnecessarily** complex.
* `(&s).len()`: This takes a reference to `s` and then calls `len()`. It works, 
  but the `&` (*and the parentheses around `&s`) is unnecessary.
* `s.len()`: This is the idiomatic way.

In all cases, we are ultimately calling the `len()` method on either the 
`String` itself or a `&str` derived from it. 

The `Deref` trait and Rust's automatic referencing/dereferencing make all these 
forms work, even though some are more idiomatic than others.

## Automatic Referencing and Dereferencing

Rust has a feature called "*deref coercion*" which automatically dereferences as
needed in many contexts.

This behavior in Rust is designed to make working with references more ergonomic
and less error-prone compared to raw pointers in C, while still allowing
low-level control when needed.

In Rust, references are designed to behave much like regular variables in many
contexts, with the language doing a lot of the "*dirty work*" behind the scenes.

This design choice has several benefits:

* **Ergonomics**: It makes code more readable and intuitive to write. You can
  often work with references as if they were the values themselves.
* **Safety**: By handling dereferencing automatically in many cases, Rust
  reduces the chance of errors that can occur with manual pointer manipulation.
* **Zero-cost abstractions**: Despite this high-level behavior, Rust compiles
  references down to efficient machine code, typically equivalent to raw pointers.
* **Consistency**: This behavior is part of a broader pattern in Rust where the
  language tries to do the "*obvious*" thing automatically, reducing boilerplate
  code.

Some examples of how Rust handles references "behind the scenes":

* Automatic dereferencing for method calls.
* Deref coercion, which can convert between different levels of indirection.
* Borrow checking, which ensures references are used safely without runtime
  overhead.
* Lifetime elision, where the compiler often infers lifetimes without explicit
  annotation.

We will see "*borrow checking*" and "*lifetime elision*" later in this article.

These approaches allow Rust to provide the power and efficiency of low-level
programming with the safety and ergonomics more commonly associated with
high-level languages. It's a key part of Rust's goal to empower developers to
write safe, concurrent, and performant code without sacrificing control over
low-level details.

## Borrow Checking

Borrow checking is Rust's system for ensuring memory safety and preventing 
[data races][data-race] at compile time. It's based on a set of rules about how 
references can be created and used.

Here are some key concepts that relate to **borrow checking**:

* **Ownership**: Every value in Rust has an owner (*i.e., a variable*).
* **Borrowing**: References allow you to refer to a value without taking
  ownership.
* **Lifetimes**: The compiler tracks how long references are valid.

You can also explicitly define lifetimes for variables too, but it's better 
to dive that topic later in this article.

Here are some basic rules of borrowing:

At any given time, you can have either:
* One mutable reference (`&mut T`)
* Any number of immutable references (`&T`)
* References must always be valid (no dangling references).

Here's an example:

```rust
fn main() {
    let mut x = 5;

    let y = &x; // Immutable borrow
    let z = &x; // Another immutable borrow - this is fine
    
    // We are using two immutable borrows here:
    println!("{} {}", y, z);
    
    // We stopped using y and z here, so we can create a mutable borrow.
    // Remember that you cannot have both mutable and immutable borrows at the
    // same time.
    
    let w = &mut x;  // Mutable borrow
    *w += 1;
    
    // println!("{}", y);  // Error: can't use y here as x is mutably borrowed.
    
    println!("{}", x);  // This is okay - mutable borrow has ended
}
```

## Non-Lexical Lifetimes (NLL)

When verifying borrow rules, the Rust borrow checker first considers lexical 
scope, but it goes beyond that with a more sophisticated analysis. 

Let's see how this works:

**Lexical analysis**: The borrow checker looks at lexical scope as a starting 
point. This is why you can have multiple borrows that don't overlap in their 
lexical scopes.

**Non-lexical lifetimes (*NLL*)**: However, Rust's borrow checker uses a more 
advanced system called ["*non-lexical lifetimes*" (*NLL*)][nll]. This system 
was introduced to make the borrow checker smarter and more flexible.

Here's how NLL works differently from pure lexical analysis:

* **Flow-sensitive analysis**: The borrow checker analyzes the actual control 
 flow of the program, not just the lexical structure. It tracks where variables 
  are actually used, not just where they're in scope.
* **Finer-grained lifetimes**: NLL allows the compiler to end a borrow's 
  lifetime as soon as it's no longer needed, even if it's still in lexical scope.
* **Multiple lifetime regions**: The borrow checker can now reason about 
  multiple lifetime regions within a single lexical scope.

Here's an example:

```rust
fn main() {
    let mut x = 5;
    
    // While y (an immutable reference) is active,
    // x cannot be borrowed or mutated.
    //
    // While y is active, x is effectively frozen.
    //
    // * The borrowed value (x in this case) cannot be mutated directly.
    // * No mutable borrows of x can be created.
    // * But additional immutable borrows are allowed.
    let y = &x;
    
    // x = 6;  // This would fail because y is still active.
    
    println!("{}", y); // This is fine.
    
    // y is not used anymore. x can be mutated now.
    
    x = 6;  // This would fail with lexical analysis, 
            // but works with NLL.
    
    println!("{}", x);
}
```

With purely lexical analysis, this code wouldn't compile because `y` is still 
in scope when we try to mutate `x`. 

However, with NLL, the compiler recognizes that `y` isn't used after the first 
`println!`, so it's safe to mutate x.

In essence, Rust's borrow checker is more sophisticated than just lexical 
analysis. It uses lexical scope as a starting point but then applies more 
advanced techniques to provide a more accurate and flexible analysis of 
lifetimes and borrows.

## Why Do We Need Borrow Rules?

But why do we need those rules. Let's see some of the reasons:

* **Data Races**: In a multi-threaded context, if one thread could mutate data 
  while another thread is reading it, this could lead to data races. [Data 
  races][data-race] occur when multiple threads access the same memory location 
  concurrently, and at least one of the accesses is a write. This can result in 
  unpredictable behavior and is a common source of bugs in concurrent systems.
* **Iterator Invalidation**: If you're iterating over a collection and the 
  underlying data is modified during iteration, it could invalidate the 
  iterator, potentially causing crashes or undefined behavior.
* **Unexpected Value Changes**: If code is reading a value through an immutable
  reference, it generally assumes that value won't change. Allowing mutation
  through another path would violate this assumption, leading to logical errors 
  in the program.
* **Violation of Aliasing XOR Mutability**: Rust's type system is built on the 
  principle that you can have either multiple readers (*aliasing*) or a single 
  writer (*mutability*) at any given time, but not both. Violating this 
  principle would undermine many of Rust's safety guarantees.
* **Breaking Optimizations**: Compilers often make optimizations based on the 
  assumption that immutably borrowed data doesn't change. Allowing mutation 
  through other means would break these optimizations.
* **Memory Safety Issues**: In more complex scenarios, this could lead to 
  use-after-free bugs, dangling pointers, or other memory safety issues that 
  Rust is specifically designed to prevent.
* Borrow checking prevents data races at compile time.
* Borrow checking eliminates entire classes of bugs (*null/dangling pointer 
  dereferences, use after free, etc.*).
* Borrow checking enables fearless concurrency.
* No runtime overhead - all checks are done at compile time.

## Other Benefits of Borrow Checking

The borrow checker also prevents common errors:

Use after free:

```rust
fn main() {
    let y: &i32;

    {
        let x = 5;
        y = &x;  // Error: `x` does not live long enough
    }

    println!("{}", y);
}
```

Double free:

```rust
fn main() {
    let s = String::from("hello"); // s owns the string
    let t = s; // Ownership moved to t

    println!("{}", s); // Error: use of moved value

    // Note that at any given time, 
    // a value can have only one owner.
}
```

## Ownership and Borrowing

There's a significant difference between **ownership** and **borrowing** in 
Rust. 

Let's break this down:

### Ownership

* In Rust, each value has a variable that is its "*owner*".
* There can only be one owner at a time.
* When the owner goes out of scope, the value will be dropped (*freed*).

### Borrowing

* Borrowing allows you to refer to some value without taking ownership of it.
* There are two types of borrows: shared (`&T`) and mutable (`&mut T`).
* You can have multiple shared borrows or one mutable borrow at a time, 
  but not both simultaneously.

* Here's an example to illustrate the difference:

```rust
fn main() {
    let s = String::from("hello"); // s owns the string

    let len = calculate_length(&s); // s is borrowed here
    println!("The length of '{}' is {}.", s, len);
    
    // s is still valid here because it was only borrowed, not moved
}

fn calculate_length(s: &String) -> usize { // s is a borrowed reference
    s.len()
}
```

In this example:

* s owns the `String`.
* We pass a reference `&s` to `calculate_length`. This is borrowing:
  `calculate_length` can use the `String`, but doesn't own it.
* After `calculate_length` returns, `s` is still valid and owned by the
  main function.

What if `calculate_length` tried to take ownership of `s`?
Let's see:

```rust
fn main() {
    let s = String::from("hello");
    let len = calculate_length(s);
    
    // s is no longer valid here because ownership was transferred
    // println("{}", s); // Error: value borrowed here after move.
    
    println!("The length was: {}", len);
}

fn calculate_length(s: String) -> usize {
    s.len()
}
```

If you want to use a value after it is moved to another function, you will
get an error. This is because Rust prevents you from using a value after it
has been moved to another owner.

Borrowing is powerful because it allows you to use data without transferring 
ownership, which means you can use it in multiple places without cloning or 
moving the data.

The key differences are:

* Ownership involves responsibility for cleaning up the data.
* Borrowed data is *temporary* and the borrower is not responsible for cleaning 
  it up.
* Owned data can be modified freely (*if it's mutable*), while borrowed data 
  has restrictions (*shared borrows can't modify, only one mutable borrow 
  at a time*).

Here is another example:

```rust
fn main() {
    let mut x = 42;
    let f = &mut x;
    
    // f is not used here, so we can create a mutable borrow.
    
    let g = &mut x;

    println!("{}", g);
}
```

Compare the code above with this one:

```rust
fn main() {
    let mut x = 42;
    let f = &mut x;
    
    // f is used below ([1]), 
    // so we can't create a mutable borrow here.
    
    // let g = &mut x; // This is an error.

    println!("{}", f); // [1]
}
```

Yet another example:

```rust
func main() {
    let mut x = 42;

    let mut g = &mut x; // <---- lifecycle of g starts here
                        // |
    println!("{}", x); //<--- Cannot borrow `x` when something can change `x`.
                        // |  i.e., cannot borrow `x` when there is an
                        // |  active mutable borrow of `x`. 
                        // |
    *g = *g + 1;        // <---- lifecycle of g ends here.
                        //       i.e. x's borrow ends here.
}
```

## Mutable Variable to a Mutable Reference

The mutability of the reference itself (*i.e., whether g can be reassigned*) 
is separate from the mutability of the value it points to.

There are some scenarios where you might want a mutable variable holding a 
mutable reference, but they're not common. One example might be if you wanted 
to reassign g to point to different mutable references:

```rust
let mut x = 5;
let mut y = 10;

let mut g = &mut x;
*g += 1;

g = &mut y;  // Reassigning g to point to y
*g += 1;
```

But in most cases, you don't need the extra mutability on the variable holding 
the reference. It's generally cleaner and clearer to keep things as immutable 
as possible whenever you can.

## Give It Time to Sink In

The borrow checker can be frustrating for newcomers. Sometimes requires 
rethinking algorithms or data structures to satisfy the borrow checker.

As you work more with Rust, you'll develop an intuition for what the borrow 
checker allows and disallows. It's a powerful tool that, once understood, 
allows you to write safe and efficient code with confidence.

The key thing to remember is that Rust's borrow checker ensures that:

* You don't have multiple mutable references to the same data simultaneously.
* You don't have a mutable reference and an immutable reference to the same 
  data simultaneously.
* Last Use Principle: A borrow is considered to end after its last use in the 
  control flow of the program.
* Compiler Analysis: The Rust compiler analyzes the code to determine where 
  references are no longer used.

Thus, at any given point in the program's execution, there can be only one 
mutable reference to a particular piece of data. This is indeed true not just 
within a function, but across the entire program.

This means, Rust's borrow checker works based on the potential for use, not 
actual use. It doesn't wait to see if you actually use the references.

## Summarizing Ownership and Borrowing

Let's summarize the key points about ownership and borrowing in Rust that
we've covered so far:

* Every value in Rust has an owner (*which is a variable*).
* There can only be one owner at a time.
* When the owner goes out of scope, the value is dropped.
* References allow you to refer to a value without taking ownership.
* In Rust, we say "*reference to*" rather than "*pointer to*".
* The `&` symbol is used to create a reference.
* At any given time, you can have either:
  * One mutable reference (`&mut T`)
  * Any number of immutable references (`&T`)
  * But not both at the same time.
* References must always be valid (*no dangling references*).
* You can borrow a variable mutably or immutably.
* Mutable borrows are exclusive; immutable borrows are not.
* A borrow's lifetime ends at its last use, **not** necessarily at the end of 
  its lexical scope. This is known as Non-Lexical Lifetimes (*NLL*).
* You can have multiple mutable borrows of different variables simultaneously.
* You can't have multiple simultaneous mutable borrows of the same variable.
* Using a variable often creates an implicit borrow.
* You can use the original variable once all mutable borrows of it have ended.
* Rust's borrow checker enforces these rules at compile-time.
* It analyzes the flow of borrows through the program.
* The borrow checker prevents data races and ensures memory safety.
* The borrow checker has become more flexible with Non-Lexical Lifetimes.
* It now considers the actual usage of borrows, not just their lexical scope.

These rules and concepts form the foundation of Rust's memory safety guarantees, 
allowing for safe concurrent programming without a garbage collector.

## Structs and Methods

**Structs** in Rust are similar to structs in C or classes in other languages. 
They allow you to create custom data types by grouping related data together. 
**Methods** are functions associated with a particular struct.

Let's start with a basic example:

```rust
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
      self.width * self.height
    }

    fn new(width: u32, height: u32) -> Rectangle {
        Rectangle { width, height }
    }
}

fn main() {
    let rect = Rectangle::new(30, 50);
    println!(
      "The area of the rectangle is {} square pixels.", 
      rect.area()
    );
}
```

* In the above code, we define a `Rectangle` struct `with` width and `height` 
 fields. Fields in a struct are **private** by default.
* The `impl` block is where we define methods associated with the Rectangle struct.
* `area` is an **instance method**. It takes `&self` as its first parameter, which 
  is a reference to the instance.
* `new` is an **associated function** (*similar to a static method in other 
  languages*). It doesn't take `self` and is often used as a constructor.

### Method Receivers

* `&self` for read-only access to the instance
* `&mut self` for mutable access
* `self` for taking ownership (*rare*)

### Associated Functions

* Functions in the `impl` block that don't take self are called **associated 
  functions**.
* They are often used for constructors or utility functions related to the struct.


### Multiple impl Blocks

You can have multiple impl blocks for a struct, which is useful for organizing code.

## Taking Ownership of `self`

`&mut self` is a mutable reference to the instance. The method can modify the 
instance, but doesn't take ownership of it. This means, after the method call, 
the caller still owns the instance and can use it.

Whereas `self` takes ownership of the instance. We say that "the method consumes 
the instance", meaning the caller can no longer use it after the method call ends.

This is less common and is typically used when you want to transform the 
instance into something else or when you're done with it and want to essentially
clean it up and prevent further use.

Here is an example:

```rust
struct Counter {
    count: u32,
}

impl Counter {
    // Method with &mut self
    fn increment(&mut self) {
        self.count += 1;
    }

    // Method with self
    fn reset(self) -> Counter {
        Counter { count: 0 }
    }
}

fn main() {
    let mut counter = Counter { count: 5 };

    counter.increment();
    println!("Count: {}", counter.count);  // This is fine
    
    let new_counter = counter.reset();
    // println!("Old count: {}", counter.count);  // This would be an error
    println!("New count: {}", new_counter.count); // This is fine.
}
```

The choice between &mut self and self depends on what you want to do with the 
instance:

* Use `&mut self` when you want to modify the instance but keep using it.
* Use `self` when you're transforming the instance into something else or when 
  you're done with it and want to ensure it's not used again.

## Enums and Pattern Matching

Enums (*short for enumerations*) allow you to define a type by enumerating its 
possible variants.

Rust enums are much more flexible than Go enums.

Here's a basic example of an enum and how to use pattern matching with it:

```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

fn process_message(msg: Message) {
    match msg {
        Message::Quit => {
            println!("Quitting");
        }
        Message::Move { x, y } => {
            println!("Moving to ({}, {})", x, y);
        }
        Message::Write(text) => {
            println!("Writing: {}", text);
        }
        Message::ChangeColor(r, g, b) => {
            println!("Changing color to ({}, {}, {})", r, g, b);
        }
    }
}

fn main() {
    let msg1 = Message::Move { x: 10, y: 20 };
    let msg2 = Message::Write(String::from("Hello, Rust!"));

    process_message(msg1);
    process_message(msg2);
}
```

* **Variants**: Each enum can have multiple variants (`Quit`, `Move`, `Write`, 
  `ChangeColor`).
* **Data in variants**: Variants can hold different types and amounts of data.
* **No null**: Enums are often used instead of null values in Rust.

## Advanced Pattern Matching

Pattern matching with `match`:

* **Exhaustive**: match **must** cover all possible variants of the enum.
* **Binding**: You can bind variables to the data inside enum variants.
* **Multiple patterns**: You can match multiple patterns with `|`.
* **Catch-all**: `_` can be used as a catch-all pattern.

Here's an example of more advanced pattern matching:

```rust
enum OptionalInt {
    Value(i32),
    None,
}

fn describe_optional_int(oi: OptionalInt) {
    match oi {
        OptionalInt::Value(42) => println!("The answer!"),
        OptionalInt::Value(n) if n > 100 => println!("Big number: {}", n),
        OptionalInt::Value(n) => println!("Number: {}", n),
        OptionalInt::None => println!("No value"),
    }
}

fn main() {
    describe_optional_int(OptionalInt::Value(42));
    describe_optional_int(OptionalInt::Value(200));
    describe_optional_int(OptionalInt::Value(50));
    describe_optional_int(OptionalInt::None);
}
```

This example demonstrates:

* Matching specific values (`42`)
* Using guards (`if n > 100`)
* Binding variables (`n`)
* Catch-all patterns

Enums and pattern matching are often used together in Rust for:

* Representing and handling different states
* Error handling (with the `Result` enum)
* Optional values (with the `Option` enum)

## Pattern Matching Order

In a `match` expression, patterns are evaluated from top to bottom, and only 
the first matching pattern is executed. Once a match is found, the corresponding 
code block is run, and the rest of the patterns are not evaluated.

This behavior allows you to put more specific patterns before more general ones. 

For example:

```rust
match some_value {
    0 => println!("Zero"),
    n if n < 0 => println!("Negative"),
    _ => println!("Positive"),
}
```

If some_value is 0, only the first arm will execute. If it's negative, only the 
second arm will execute. The last arm only executes if the previous patterns 
don't match.

## Guards in Pattern Matching

Guards are additional conditions you can add to a match arm using the `if` 
keyword. They allow you to express more complex conditions than pattern 
matching alone.

Here's how guards work:

*The pattern is matched first.
* If the pattern matches, the guard condition is evaluated.
* If the guard condition is `true`, the arm is selected.
* If the guard condition is `false`, matching continues with the next arm.

Let's look at an example:

```rust
enum Temperature {
    Celsius(f32),
    Fahrenheit(f32),
}

fn describe_temperature(temp: Temperature) {
    match temp {
        Temperature::Celsius(c) if c > 30.0 => println!("Hot day! {}°C", c),
        Temperature::Celsius(c) if c < 10.0 => println!("Cold day! {}°C", c),
        Temperature::Celsius(c) => println!("Moderate temperature: {}°C", c),
        Temperature::Fahrenheit(f) if f > 86.0 => println!("Hot day! {}°F", f),
        Temperature::Fahrenheit(f) if f < 50.0 => println!("Cold day! {}°F", f),
        Temperature::Fahrenheit(f) => println!("Moderate temperature: {}°F", f),
    }
}

fn main() {
    describe_temperature(Temperature::Celsius(35.0));
    describe_temperature(Temperature::Fahrenheit(68.0));
}
```

Guards are powerful because they allow you to express conditions that can't be 
represented by patterns alone, such as ranges or complex logical conditions.

Remember, the order matters here too. More specific guards should come **before**
more general ones to ensure they have a chance to match.

## This Looks A Lot Like Haskell

Here are some key points of similarity between Rust and [Haskell][haskell] in 
the context of pattern matching:

* **Algebraic Data Types**: Rust's enums are similar to Haskell's algebraic data 
  types. Both allow you to define types with multiple variants that can hold 
  different kinds of data.
* **Pattern Matching**: Both languages use pattern matching as a core feature 
  for working with these types. The syntax and exhaustiveness checking are quite
  similar.
* **Guards**: As we just discussed, both Rust and Haskell allow the use of 
  guards in pattern matching to add extra conditions.
* **Expression-based**: Both languages treat if statements, match expressions, 
  and many other constructs as expressions that return values.
* **Strong Static Typing**: Both languages have strong, static type systems that 
  catch many errors at compile time.

However, Rust differs from Haskell in several important ways:

* **Mutability**: Rust allows controlled mutability, whereas Haskell is purely 
  functional with immutable data by default.
* **Memory Management**: Rust uses its ownership system for memory management, 
  while Haskell uses garbage collection.
* **Side Effects**: Rust doesn't isolate side effects in the type system the 
  way Haskell does with its [IO monad][monad].
* **Performance Focus**: Rust is designed as a systems programming language 
  with a focus on performance, while Haskell is more oriented towards high-level 
  abstraction.

This design philosophy reveals itself in many aspects, not only pattern matching:
Rust's design philosophy has been to take powerful ideas from functional 
programming (*like those found in Haskell*) and apply them in a way that's 
suitable for systems programming. 

This results in a language that can feel familiar to functional programmers in 
many ways, while still providing the low-level control needed for systems 
programming. 

## Patterns and Traits

We will cover traits later in this article. But, still, it's a good time to
compare patterns and traits and see when to use each.

Pattern matching and traits in Rust serve different purposes, although they can 
sometimes be used to solve similar problems.

**Use pattern matching when**:

* You want to destructure complex data types
* You need to handle multiple cases based on the structure or value of data
* You are working with enums and want to handle different variants
* You want to extract values from Option or Result types

For example:

* Matching on enum variants
* Destructuring tuples or structs
* Implementing control flow based on data structure

**Use traits when**:

* You want to define shared behavior across different types
* You need to implement polymorphism
* You are designing generic code that works with multiple types
* You want to extend the functionality of existing types without modifying 
  their source code

For example:

* Defining common methods for different structs
* Implementing interfaces for various types
* Creating generic functions that work with any type implementing a specific 
  trait

The following example illustrates the difference:

```rust
// Pattern matching example
enum Shape {
    Circle(f64),
    Rectangle(f64, f64),
}

fn area(shape: Shape) -> f64 {
    match shape {
        Shape::Circle(radius) => std::f64::consts::PI * radius * radius,
        Shape::Rectangle(width, height) => width * height,
    }
}

// Trait example
trait Area {
    fn area(&self) -> f64;
}

struct Circle {
    radius: f64,
}

struct Rectangle {
    width: f64,
    height: f64,
}

impl Area for Circle {
    fn area(&self) -> f64 {
        std::f64::consts::PI * self.radius * self.radius
    }
}

impl Area for Rectangle {
    fn area(&self) -> f64 {
        self.width * self.height
    }
}
```

In this example, pattern matching is used to handle different variants of the 
`Shape` enum, while traits are used to define a common `Area` **behavior** 
for different struct types.

To summarize:

* Use **pattern matching** for **control flow** and data extraction based on the 
  structure or value of data.
* Use **traits** for defining **shared behavior** across different types and 
  creating generic, polymorphic code.

## Collections in Rust

Let's focus on three of the most commonly used collections:

* `Vec<T>` (*Vector*)
* `HashMap<K, V>` (*Hash Map*)
* `HashSet<T>` (*Hash Set*)

### Vector

```rust
fn main() {
    // Creating a vector
    let mut v: Vec<i32> = Vec::new();
    v.push(1);
    v.push(2);
    v.push(3);

    // Another way to create a vector
    let v2 = vec![1, 2, 3];

    // Accessing elements
    let third: &i32 = &v[2];
    println!("The third element is {}", third);

    // Safe access with get()
    match v.get(2) {
        Some(x) => println!("The third element is {}", x),
        None => println!("There is no third element."),
    }

    // Iterating over values
    for i in &v {
        println!("{}", i);
    }

    // Mutating while iterating
    for i in &mut v {
        *i += 50;
    }
}
```

* Vector provides a growable array type
* Elements are stored contiguously in memory
* Vector can add or remove elements from the end efficiently

### Hash Map

```
use std::collections::HashMap;

fn main() {
    // Creating a HashMap
    let mut scores = HashMap::new();

    // Inserting values
    scores.insert(String::from("Blue"), 10);
    scores.insert(String::from("Yellow"), 50);

    // Accessing values
    let team_name = String::from("Blue");
    let score = scores.get(&team_name);

    // Updating a value
    scores.entry(String::from("Yellow")).or_insert(50);

    // Iterating over key/value pairs
    for (key, value) in &scores {
        println!("{}: {}", key, value);
    }
}
```

* A Hash Map stores key-value pairs
* Allows you to look up data by using a key
* Uses hashing function to determine how to store the data

### Hash Set

```rust
use std::collections::HashSet;

fn main() {
    // Creating a HashSet
    let mut fruits = HashSet::new();

    // Inserting values
    fruits.insert("Apple");
    fruits.insert("Banana");
    fruits.insert("Cherry");

    // Checking for a value
    println!("Contains Apple? {}", fruits.contains("Apple"));

    // Removing a value
    fruits.remove("Banana");

    // Iterating over values
    for fruit in &fruits {
        println!("{}", fruit);
    }

    // Set operations
    let mut set1 = HashSet::new();
    set1.insert(1);
    set1.insert(2);

    let mut set2 = HashSet::new();
    set2.insert(2);
    set2.insert(3);

    // Union
    let union: HashSet<_> = set1.union(&set2).cloned().collect();
    println!("Union: {:?}", union);
}
```

* A Hash Set stores unique values of type T
* Useful for eliminating duplicates
* Allows for efficient membership testing

## Collections and Ownership

Rust collections interact with Rust's ownership system:

* When you put a value into a collection, the collection becomes the **owner** 
  of that value. That means the collection is responsible for cleaning up the
  value when it's dropped. Also, no one else can use the value while it's in
  the collection. 
* When the collection is dropped, all of its contents are also dropped.

## The `use` Keyword

The `use` keyword in Rust is indeed similar to `import` in Go. Here are the key 
things to know about `use` in Rust:

* **Purpose**: It brings items (*like types, functions, or modules*) into scope, 
  allowing you to use them without fully qualified paths.
* **Syntax**: The basic syntax is use `path::to::item`;
* **Multiple items**: You can bring multiple items from the same path using 
  curly braces: `use std::collections::{HashMap, HashSet};`
* **Renaming**: You can rename items as you import them using the `as` keyword:
  `use std::collections::HashMap as Map;`
* **Nested paths**: Rust allows nesting paths to avoid repetition:
  `use std::{collections::HashMap, io::Read}`;
* **Glob imports**: You can bring all public items from a module into scope 
  using `*`: `use std::collections::*;` (*this is generally **discouraged** 
  except in specific cases like tests*)
* **Re-exporting**: You can combine `use` with `pub` to re-export items:
  `pub use self::some_module::SomeType`;
* **Prelude**: Some common items are automatically imported via the standard 
  prelude, so you don't need to explicitly use them. 

## Generics

Generics allow you to write code that works with multiple types.
Generics in Rust are similar to generics in languages like Java or C#, 
or templates in C++.

Rust's generics are **zero-cost abstractions**, meaning they don't add runtime 
overhead.

Let's define a few generics:

```rust
// A generic struct
struct Pair<T> {
    first: T,
    second: T,
}

// A generic enum
enum Option<T> {
    Some(T),
    None,
}

// A generic function
fn print_pair<T: std::fmt::Display>(pair: &Pair<T>) {
    println!("({}, {})", pair.first, pair.second);
}

// Generic implementation
impl<T> Pair<T> {
    fn new(first: T, second: T) -> Pair<T> {
        Pair { first, second }
    }
}

fn main() {
    // Using the generic struct with different types
    let integer_pair = Pair::new(5, 10);
    let float_pair = Pair::new(1.0, 2.0);
    let string_pair = Pair::new(String::from("hello"),
        String::from("world"));

    print_pair(&integer_pair);
    print_pair(&float_pair);
    print_pair(&string_pair);
}
```

Here are some important points about generics:

* `Type Parameters`: The `<T>` in `Pair<T>` is a type parameter. You can use 
  any valid identifier, but single uppercase letters are conventional.
* **Multiple Type Parameters**: You can have multiple type parameters, 
  e.g., `struct KeyValue<K, V> { key: K, value: V }`.
* **Trait Bounds**: You can specify that a type parameter must implement certain 
  traits, as in `T: std::fmt::Display` in the `print_pair` function.
* **Generic Functions**: Functions can also be generic over types they accept 
  or return.
* **Generic Implementations**: You can implement methods for generic types, as 
  shown with the `new` method for `Pair<T>`.
* **Monomorphization**: Rust generates specialized code for each concrete type 
  used with a generic type or function, ensuring no runtime cost for generics.

Generics are widely used in Rust's standard library, including in 
the collections we just discussed (`Vec<T>`, `HashMap<K, V>`, etc.).

## Copy and Non-Copy Types

Let think about the following example:

```rust
fn main() {
    let mut v: Vec<i32> = Vec::new();

    v.push(1);
    v.push(2);
    v.push(3);

    let v2 = vec![1, 2, 3];

    // This borrows an element of the vector.
    let third = &v[2];
    
    // This copies an element of the vector
    // and it is valid because i32 is a Copy type:
    //
    // let third = v[2];
    
    println!("The third element is '{}'.", third)
}
``` 

Instead of `let third = &v[2];`, if we change it to `let third = v[2];`,
(i.e., if we copy the value instead of borrowing it), the code would still 
compile.

Here are a few things that would happen in that case:
 
* If you change `let third = &v[2];` to `let third = v[2];`, the code 
  would still compile and run correctly.
* Instead of borrowing the value, you'd be copying it.

The key difference is in how Rust treats the types involved:

`i32` (*32-bit integer*) is a "Copy" type in Rust. This means it's small and 
stored entirely on the stack, so Rust will copy its value rather than move it.

For "Copy" types, there's no significant performance difference between 
borrowing and copying for small, simple types like integers. But still you'd
want to borrow for several reasons:

* **Consistency**: Borrowing is a common pattern in Rust, especially when 
  working with collections.
* **Flexibility**: If you later change the vector to contain a non-Copy type 
  (like `String`), the borrowing approach would still work without modification.
* **Preventing Accidental Mutations**: If `v` were mutable, and you wanted to 
  ensure third always reflected the current state of the vector, a reference 
  would be necessary.

Here's an example to illustrate the difference with a non-Copy type:

```rust
fn main() {
    let mut v: Vec<String> = Vec::new();
    v.push(String::from("hello"));
    v.push(String::from("world"));

    // This borrows - it's always valid
    let third_ref = &v[1];
    println!("Borrowed: {}", third_ref);

    // This moves the String out of the vector!
    // let third_owned = v[1];  // This would cause an error
    // println!("Owned: {}", third_owned);

    // Instead, we could clone if we really need ownership
    let third_cloned = v[1].clone();
    println!("Cloned: {}", third_cloned);
}
```

In this case:

* Borrowing with `&v[1]` is efficient and doesn't change the vector.
* Trying to move with `v[1]` would actually be an error, as it would leave a 
  "*hole*" in the vector.
* If you need ownership, you'd typically clone the value explicitly.

The decision to **borrow by default** is part of Rust's design philosophy, 
encouraging developers to think about ownership and minimize unnecessary 
copying or moving of data.

## Syntactical Similarities Between Rust and Go

If you squint hard enough, Rust reads just like Go.

Rust and Go share some syntactical similarities, but they differ significantly 
in their underlying philosophies and features, particularly when it comes to 
memory management and type systems. 

Let's explore this a bit:

### Similarities Between Rust and Go

* Syntax for basic constructs:
  * Curly braces for blocks
  * Similar function declaration syntax
  * Use of `let` (Rust) and `:=` (Go) for variable declaration
* Focus on systems programming and performance
  * Built-in concurrency support (*though implemented differently*)
  * Strong static typing
  * Emphasis on simplicity and readability

### Key Differences Between Rust and Go

* Memory Management
  * Rust: Ownership system, borrow checker, no garbage collection
  * Go: Garbage collection
* Generics
  * Rust: Robust generics system
  * Go: Only recently added generics (*Go 1.18+*), more limited
* Null Safety
  * Rust: No null, uses `Option<T>`
  * Go: Has nil, no built-in null safety
* Error Handling
  * Rust: `Result<T, E>` type, no exceptions
  * Go: Multiple return values, error as second return
* Inheritance
  * Rust: No inheritance, uses traits for shared behavior
  * Go: No inheritance, uses interfaces
* Lifetimes
  * Rust: Explicit lifetime annotations
  * Go: No concept of lifetimes
* Compile-time Guarantees
  * Rust: Prevents data races, null pointer dereferences at compile time
  * Go: Relies more on runtime checks

Let's compare two similar code snippets in Rust and Go:

Rust:

```rust
fn main() {
    let numbers = vec![1, 2, 3, 4, 5];
    let sum: i32 = numbers.iter().sum();
    println!("Sum: {}", sum);
}
```

Go:

```go
package main

import "fmt"

func main() {
	numbers := []int{1, 2, 3, 4, 5}
	sum := 0
	for _, num := range numbers {
		sum += num
	}
	fmt.Println("Sum:", sum)
}
```

While the basic structure looks similar, Rust's version showcases its powerful 
iterator system and functional programming features.

Rust's design choices, particularly around **ownership** and **borrowing**, aim 
to provide memory safety without garbage collection, which is a key 
distinguishing feature from Go.

## About `<_>` (*Type Inference*)

Let's examine the following code snippet:

```rust
fn main() {
    let set1: HashSet<i32> = vec![1, 2, 3].into_iter().collect();
    let set2: HashSet<i32> = vec![3, 4, 5].into_iter().collect();

    // Using type inference with <_>
    let union: HashSet<_> = set1.union(&set2).cloned().collect();
    println!("Union with <_>: {:?}", union);

    // Explicitly specifying the type
    let union_explicit: HashSet<i32> = set1.union(&set2).cloned().collect();
    println!("Union with explicit type: {:?}", union_explicit);

    // Without cloned(), we'd need to collect references
    let union_refs: HashSet<&i32> = set1.union(&set2).collect();
    println!("Union of references: {:?}", union_refs);
}
```

### `<_>`

The underscore `_` in `<_>` here is a placeholder that tells the Rust compiler 
to infer the type. In this case, it's inferring the type of elements in the 
`HashSet` based on the input.

If `set1` and `set2` contain integers, Rust will infer `HashSet<i32>` 
(*or whatever the specific integer type is*).

So, `<_>` is a way to say "figure out the type for me" rather than explicitly 
specifying it.


### `.cloned()`

* `union()` returns an iterator of references to the elements.
* `.cloned()` creates an iterator that clones each element.

This is necessary because `union()` returns references, but we want to own the 
values in our new `HashSet`.

Without `.cloned()`, you might think that we'd have an iterator of references, 
which can't be collected into a new owned `HashSet`. But, again, Rust is
smart enough to handle this for us:

```rust
// The elements are automatically cloned when collected into the HashSet.
let union: HashSet<i32> = set1.union(&set2).collect();
```

Compare this with the next code:

```rust
// .cloned() creates an iterator of references to cloned values.
let union: HashSet<&i32> = set1.union(&set2).cloned().collect();
```

### `.collect()`

This method transforms an iterator into a collection. It's very flexible and 
can create different types of collections depending on the context. Here, 
because we specified `HashSet<_>`, `collect()` knows to create a `HashSet`.

`collect()` is part of Rust's powerful iterator system, allowing for efficient, 
expressive data processing.

Key points:

* `set1.union(&set2)` returns an iterator over `&i32`.
* When we `collect()` without `cloned()`, Rust automatically dereferences and 
  clones the values to create a `HashSet<i32>`.
* When we use cloned(), we're creating an iterator of `&i32`, which then 
  collects into a `HashSet<&i32>`.
* `cloned()` works with any type that implements `Clone`, not just with types 
  that have special `FromIterator` implementations.

That being said, using `cloned()` makes it clear in the code that you're 
intentionally creating clones. It can make the code more self-documenting.

Here is another variation of this theme:

```rust
fn main() {
    let numbers = vec![1, 2, 3, 4, 5];

    // Without cloned(), we work with &i32 references.
    let doubled: Vec<i32> = numbers.iter().map(
        |&x| x * 2).collect();
    
    // With cloned(), we can work directly with i32 values
    let doubled_explicit: Vec<i32> = numbers.iter()
        .cloned().map(|x| x * 2).collect();
    
    println!("Doubled: {:?}", doubled);
    println!("Doubled explicit: {:?}", doubled_explicit);
    
    // Here's an example where cloned() is necessary:
    
    let strings = vec![String::from("hello"), String::from("world")];
    let first_chars: Vec<char> = strings.iter().map(
        |s| s.chars().next().unwrap()
      ).collect();
    
    // If we wanted to modify these strings, we'd need cloned().
    // Remember that iter() returns references to String (`&String`); 
    // you cannot map over `&String` and modify it.
    //
    // Why? Because the trait `FromIterator<&String>` is not implemented for 
    // `Vec<String>`. So, you will need `Strings`s as elements to `collect()` 
    // them (instead of `&String`s).
    //
    let modified: Vec<String> = strings.iter().cloned().map(|mut s| {
        s.push('!');
        s
    }).collect();
    
    println!("First chars: {:?}", first_chars);
    println!("Modified: {:?}", modified);
    println!("Original strings: {:?}", strings);  // Unchanged
}
```

In summary, while `cloned()` might seem redundant in some cases like the 
`HashSet` example above, it becomes crucial when:

* You need to perform operations that require owned values.
* You're working with types that don't have specialized `FromIterator` 
  implementations.
* You want to make cloning explicit in your code for **clarity**.
* You're doing complex iterator chains where owning the values is necessary 
  at some intermediate step.

## Purpose of `collect()`

`collect()` consumes an iterator and creates a collection from its elements.
It's part of Rust's "*zero-cost abstractions*" philosophy, often being as 
efficient as manual iteration.

`collect()` can create many different collection types, not just `Vec` or 
`HashSet`. The type it creates is often inferred from context, but can be 
explicitly specified.

For many common cases, `collect()` is optimized to allocate the correct amount 
of memory upfront.

In addition `collect()` can also be used to accumulate `Result`s, turning an 
iterator of `Result`s into a `Result` of a collection.

Let's compare this with an imperative approach:

```rust
fn main() {
    let numbers = vec![1, 2, 3, 4, 5];

    // Using collect()
    let doubled: Vec<i32> = numbers.iter().map(|&x| x * 2).collect();

    // Imperative approach
    let mut doubled_imperative = Vec::new();
    for &num in &numbers {
        doubled_imperative.push(num * 2);
    }

    println!("Doubled (collect): {:?}", doubled);
    println!("Doubled (imperative): {:?}", doubled_imperative);

    // collect() with type inference
    let set: HashSet<_> = numbers.iter().cloned().collect();

    // collect() for error handling
    let results: Vec<Result<i32, &str>> = 
      vec![Ok(1), Err("oops"), Ok(3)];
    let collected_results: 
      Result<Vec<i32>, &str> = results.into_iter().collect();

    println!("Set: {:?}", set);
    println!("Collected results: {:?}", collected_results);
}
```

Here are some highlights:

* The `collect()` version is more concise and focuses on the transformation 
  (map), not the mechanics of building the collection.
* `collect()` can infer the type of collection to create, making it very
  flexible.
* It can be used in more complex scenarios, like accumulating Result types.

Yes, you can always write an imperative loop to achieve the same result, 
however, `collect()` offers several advantages:

* It's more declarative, focusing on what you want, not how to do it.
* It's often more concise and can be chained with other iterator methods.
* It can be more efficient in some cases, as the compiler can optimize it better.
* It's more flexible, easily allowing you to collect into different types of collections.

In essence, collect() is a bridge between Rust's iterator system and its 
collections, embodying Rust's approach to combining high-level abstractions 
with low-level performance.

## `Result` Type in Rust

`Result` is a crucial type in Rust's error handling system. 
It is an `enum` used for returning and propagating errors. 
It's defined as follows:

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

Let's break it down:

* `Ok(T)`: Represents success and contains a value of type `T`
* `Err(E)`: Represents an error and contains an error value of type `E`

`Result` is used for operations that can fail. It allows you to handle errors 
explicitly without exceptions.

`Result` is often used as the return type for functions that might fail.
It forces error handling, improving reliability

Here's a simple example:

```rust
use std::fs::File;
use std::io::Read;

fn read_file_contents(path: &str) -> Result<String, std::io::Error> {
    let mut file = File::open(path)?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    Ok(contents)
}

fn main() {
    match read_file_contents("example.txt") {
        Ok(contents) => println!("File contents: {}", contents),
        Err(error) => println!("Error reading file: {}", error),
    }
}
```

* The function returns `Result<String, std::io::Error>`
* On success, it returns `Ok(contents)`
* On failure, it returns `Err(error)`

In `File::open(path)?;`, the `?` operator is used for easy error propagation. 
It's shorthand for a match expression that returns early on error.

Here is a more explicit version:

```rust
let mut file = match File::open(path) {
    Ok(file) => file,
    Err(e) => return Err(e.into()),
};
```

In `main()`, we use pattern matching to handle both success and failure cases.

Here are other some common ways to work with `Result`:

```rust
// Don't care about error details.
if let Ok(contents) = read_file_contents("example.txt") {
  println!("File contents: {}", contents);
}
```

```rust
// Expect panics with a custom message.
let contents = read_file_contents("example.txt")
  .expect("Failed to read file");
```

```rust 
// A combination
let line_count = read_file_contents("example.txt")
  .map(|contents| contents.lines().count())
  // .unwrap() panics, unwrap_or() provides a default value.
  .unwrap_or(0);
```

`Result` is a key part of Rust's approach to creating reliable, error-resistant 
code. It encourages explicit error handling and helps prevent issues like 
unchecked null values or unhandled exceptions found in some other languages.

## `Result` versus Promises

The `Result` type in Rust does share some conceptual similarities with 
[Deferreds, Promises, and Monads][monad]. Let's explore these connections:

### Similarity to Promises/Deferreds

Like Promises, `Result` represents the outcome of an operation that may succeed 
or fail. Both provide a structured way to handle success and failure cases.
However, `Result` is **synchronous**, while Promises typically deal with 
*asynchronous* operations.


### Monadic Nature

`Result` is indeed very similar to a `Monad`, particularly the `Either` monad 
in functional programming languages. It provides a way to chain operations that 
might fail, similar to how Monads allow sequencing of computations.

Here's how Result exhibits monad-like behavior:

```rust
fn divide(x: i32, y: i32) -> Result<i32, String> {
    if y == 0 {
        Err("Division by zero".to_string())
    } else {
        Ok(x / y)
    }
}

fn main() {
    let result = divide(10, 2)
        .and_then(|x| divide(x, 2))
        .map(|x| x * 2);
    
    match result {
        Ok(value) => println!("Result: {}", value),
        Err(e) => println!("Error: {}", e),
    }
}
```

In this example:

* `and_then` is similar to `flatMap` or `bind` in other monadic systems.
* `map` allows transforming the success value, similar to functor operations.

`Result` is monadic because it allows: 

* Encapsulation of computation,
* Sequencing of operations,
* And error short-circuiting.

However, there are differences, too:

* `Result` is **synchronous** and immediately available.
* It's used for error handling rather than managing asynchronous operations.

Rust's approach with Result:

* Enforces explicit error handling at compile-time.
* Provides a type-safe way to handle errors without exceptions.
* Allows for expressive, functional-style composition of fallible operations.

The similarity to monads and functional programming concepts is not accidental. 
Rust incorporates many ideas from functional programming, including this approach 
to error handling, while still maintaining its systems programming focus.

## `std::fmt::Display`

In the above code, `std::fmt::Display` is a trait that allows for text-based
display of a type. It's similar to `Stringer` in Go or `toString()` in other
languages.

* `std` is the standard library.
* `fmt` is a **module** within the standard library for formatting and display.
* The `::` is used to access items within modules.

This hierarchical structure helps organize code and prevent naming conflicts.

## `Display as a Trait

Display is a trait. 

Traits in Rust are similar to interfaces in other languages, but more powerful. 
They define a set of methods that a type must implement. You can think of 
them as defining an "*ability*" or "*behavior*" that a type can have.

In the context of the above example code, `T: std::fmt::Display` 
is a **trait bound**. It means, "*T can be any type that implements the 
`Display` trait*".

The `Display` trait defines how a type should be formatted for user-facing 
output.

Here's a brief example of how a type implements `Display`:

```rust
use std::fmt;

struct Point {
    x: i32,
    y: i32,
}

impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

fn main() {
    let p = Point { x: 1, y: 2 };
    println!("{}", p);  // Prints: (1, 2)
}
```

* Traits (*like `Display`*) define a contract that types can implement.
* They are used extensively in Rust for polymorphism and to define shared behavior.
* In generic functions, trait bounds (like `T: std::fmt::Display`) specify what 
  capabilities the generic types must have.

So, in our `print_pair` function, it can work with any `Pair<T>` where `T` is 
any type that knows how to display itself (i.e., implements `Display`).

This is how Rust achieves polymorphism and code reuse without traditional 
inheritance.

You can also bind multiple traits to a type.

You can use the `+` syntax:

```rust
fn print_info<T: std::fmt::Display + std::fmt::Debug>(value: T) {
    println!("Display: {}", value);
    println!("Debug: {:?}", value);
}
```

Or, you can use `where` clauses for more complex bounds:

```rust
fn complex_function<T, U>(t: T, u: U) -> i32
  where
    T: std::fmt::Display + Clone,
    U: std::fmt::Debug + PartialEq,
  {
    // Function body
    0
}
```

You can use traits in trait definitions too:
In trait definitions:

```rust
trait MyTrait: std::fmt::Display + std::fmt::Debug {
    // Trait methods
}
```

Also, traits can be helpful in struct or enum definitions with trait bounds:

```rust
struct Wrapper<T: std::fmt::Display + std::fmt::Debug>(T);
```

Here's a more complete example:

```rust
use std::fmt;

// A trait for things that can be doubled
trait Doubler {
    fn double(&self) -> Self;
}

// Implement Doubler for i32
impl Doubler for i32 {
    fn double(&self) -> Self {
        self * 2
    }
}

// A function that uses multiple trait bounds
fn double_and_print<T: Doubler + fmt::Display>(value: T) {
    let doubled = value.double();
    println!("Original: {}, Doubled: {}", value, doubled);
}

fn main() {
    double_and_print(5);
}
```

## About `Self`

`Self` is a special keyword in Rust that refers to the type that's implementing 
a trait or method. It's a way to refer to the current type without naming it 
explicitly.

* In trait definitions: `Self` represents the type that will implement the trait.
* In method implementations: `Self` refers to the type the `impl` block is for.
* `Self` is always capitalized when used as a type.

Here are some examples:

In a trait definition:

```rust
trait Cloneable {
    fn clone(&self) -> Self;
}
```

Here, `Self` will be whatever type implements this trait.

In an impl block:

```rust
struct Point {
    x: i32,
    y: i32,
}

impl Point {
    fn new(x: i32, y: i32) -> Self {
      Self { x, y }
    }
}
```

In this case, `Self` is equivalent to `Point`.

In trait implementations:

```rust
impl Cloneable for Point {
    fn clone(&self) -> Self {
        Self {
            x: self.x,
            y: self.y,
        }
    }
}
```

As a return type:

```rust
trait Builder {
    fn reset(&mut self) -> &mut Self;
}

impl Builder for Point {
    fn reset(&mut self) -> &mut Self {
        self.x = 0;
        self.y = 0;
        self
    }
}
```

In associated types:

```rust
trait Container {
    type Item;
    fn contains(&self, item: &Self::Item) -> bool;
}
```

Here are some important notes about `Self`:

* It allows for more generic and reusable code.
* It is particularly useful in traits where you don't know the concrete type 
  implementing the trait.
* It can be used as a return type, parameter type, or in type annotations within 
  methods or associated functions.
* It helps in writing self-referential structs or in implementing the 
  [builder pattern][builder].

One thing to note is `Self` refers the type itself, not an instance of the type.
This is different from `self` (*lowercase*), which refers to the current instance.

## With Borrowing, Do We "Ever" Need Pointers?

With all this reference and borrowing semantics, you will seldom need to use
pointers in Rust. Instead of raw pointers, references are much more frequently 
used and are safer due to the borrow checker.

* References (`&` and `&mut`) are the primary way to share access to data 
  without transferring ownership.
* References are always valid (non-null) and checked by the borrow checker.

Rust's reference system provides memory safety guarantees at **compile time**.
This prevents common issues like null pointer dereferencing, dangling pointers, 
and [data races][data-race].

Raw pointers (`*const T` and `*mut T`) do exist in Rust, but they're used much 
less frequently. They're primarily used in `unsafe` code blocks for low-level 
operations or interfacing with C libraries.

Here's a comparison:

```rust
fn main() {
    let x = 5;

    // Reference (safe, common)
    let ref_x = &x;
    println!("Reference value: {}", *ref_x);

    // Raw pointer (unsafe, uncommon)
    let ptr_x = &x as *const i32;
    unsafe {
        println!("Pointer value: {}", *ptr_x);
    }
}
```

Pointers can (*as a very very VERY last resort*) be used to work around
the limitations of the borrow checker.

Rust's approach offers several advantages:

* Memory safety without garbage collection
* Elimination of entire classes of bugs at compile time
* Clear ownership semantics
* Performance comparable to manual memory management

This design allows Rust to achieve its goal of being a systems programming 
language that is safe, concurrent, and practical.

## Lifetimes

Lifetimes are a crucial and unique feature of Rust that deserve their own 
discussion.

Lifetimes are Rust's way of ensuring that references are valid for the duration 
they are used. They are part of Rust's borrow checker, preventing 
*use-after-free* and *dangling pointer* errors.


### Why Do We Need Lifetimes?

* Lifetimes help the compiler ensure that references don't outlive the data 
  they refer to.
* They allow for more complex borrowing patterns while maintaining memory safety.


### Implicit Lifetime Elision

In many cases, Rust can infer lifetimes without explicit annotation.

### Explicit Lifetime Annotation

You can use the syntax `'a`, `'b`, etc. (*the names are arbitrary but 
`'a` is conventional for a single lifetime*) to annotate lifetimes explicitly.

Let's see some examples:

```rust
// Implicit lifetime
fn longest(x: &str, y: &str) -> &str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}

// Explicit lifetime
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
      if x.len() > y.len() {
          x
      } else {
          y
     }
}

fn main() {
    let string1 = String::from("short");
    let string2 = String::from("longer");
    let result = longest(&string1, &string2);

    println!("Longest string is {}", result);
}
```

In the explicit version:

* `'a` is a lifetime parameter.
* It tells the compiler that all the references in the arguments and return 
  value must have the same lifetime.

Rust has rules to infer lifetimes in common patterns, reducing the need for 
explicit annotations. That's called **lifetime elision**.

Let's see another example:

```rust
struct ImportantExcerpt<'a> {
    part: &'a str,
}
```

This struct can't outlive the reference it holds.

### Static Lifetime

`'static` is a special lifetime that lasts for the entire program execution.

### Multiple Lifetimes

You can specify different lifetimes for different references:

```rust
fn complex<'a, 'b>(x: &'a str, y: &'b str) -> &'a str {
    x
}
```

### Lifetime Bounds

You can specify that a type must live for a certain lifetime:

```rust
fn print_type<T: Display + 'static>(t: &T) {
    println!("{}", t);
}
```

Lifetimes are one of the more challenging concepts in Rust, but they're crucial 
for the language's memory safety guarantees without garbage collection.

Let's see some more complex scenarios involving lifetimes.

### Lifetimes with Structs and Implementation Blocks

In Rust, when you use references in struct definitions, you need to specify 
lifetime parameters to help the compiler ensure that the references remain 
valid for as long as the struct instance exists. 

For example, the following code will raise an error:

```rust
struct Excerpt {
    text: &str,
    //    ^ expected named lifetime parameter!
}
```

Let's fix that below:

```rust
struct Excerpt<'a> {
    text: &'a str,
}

impl<'a> Excerpt<'a> {
    fn level(&self) -> i32 {
      3
    }

    fn announce_and_return_part(&self, announcement: &str) -> &str {
        println!("Attention please: {}", announcement);
        self.text
    }
}

fn main() {
    let novel = String::from("Call me Volkan. Some years ago...");
    let first_sentence = novel.split('.').next().expect("Could not find a '.'");
    let i = Excerpt {
      text: first_sentence,
    };

    println!("Excerpt level: {}", i.level());
    println!("Excerpt: {}", i.announce_and_return_part("Here's an excerpt"));
}
```

In the code above, `<'a>` declares a lifetime parameter that the struct uses, 
and `&'a str` specifies that the text field must live for at least as long as 
this lifetime `'a'`. Any instance of `Excerpt` is then constrained to live no 
longer than the concrete lifetime that `'a'` represents when the struct is 
instantiated.

For example:

```rust 
fn main() {
    let long_lived_string = String::from("I live long");

    let excerpt;
    
    {
        let short_lived_string = String::from("I'm short-lived");

        // We borrow from short_lived_string
        excerpt = Excerpt { text: &short_lived_string };

    } // short_lived_string goes out of scope here

    // We cannot used excerpt here because short_lived_string 
    // is no longer valid.

} // long_lived_string and excerpt go out of scope here
```

Let's compare it with this one:

```rust
fn main() {
    let long_lived_string = String::from("I live long");

    let excerpt;

    {
        let short_lived_string = String::from("I'm short-lived");

        // We borrow from long_lived_string
        excerpt = Excerpt { text: &long_lived_string };

    } // short_lived_string goes out of scope here

    // We can use excerpt here because `'a` refers to the lifetime of
    // long_lived_string which is still valid.
    println!("value: {}", excerpt.text)

} // long_lived_string and excerpt go out of scope here
```

### Lifetimes With Trait Bounds

The next example demonstrates how lifetimes can be used with traits and trait 
implementations:

```rust 
trait Summarizable<'a> {
    fn summary(&self) -> &'a str;
}

struct Article<'a> {
    title: &'a str,
    content: &'a str,
}

impl<'a> Summarizable<'a> for Article<'a> {
    fn summary(&self) -> &'a str {
        self.title
    }
}

fn main() {
    let article = Article {
        title: "Rust Lifetimes",
        content: "Lifetimes are a complex but powerful feature...",
    };
    println!("Article summary: {}", article.summary());
}
```

### Higher-Rank Trait Bounds (*HRTB*)

In [type theory][type-theory], "*higher-rank*" refers to types that involve 
quantifiers (like "*for all*" or "*exists*") in positions other than just the 
outermost level. In Rust, this translates to lifetimes or types that are 
quantified in nested positions.

The following example introduces Higher-Rank Trait Bounds, allowing for more
flexible lifetime relationships.

```rust
trait Matcher<T> {
    fn match_with(&self, item: T) -> bool;
}

// A function that works with any reference lifetime
fn match_any<T, M>(matcher: &M, items: &[T]) -> bool
where
    M: for<'a> Matcher<&'a T>,
    {
        items.iter().any(|item| matcher.match_with(item))
    }

struct StartsWith(char);

impl<'a> Matcher<&'a &str> for StartsWith {
    fn match_with(&self, item: &'a &str) -> bool {
        item.starts_with(self.0)
    }
}

fn main() {
    let items = vec!["apple", "banana", "cherry"];
    let matcher = StartsWith('b');
    println!("Matched: {}", match_any(&matcher, &items));
}
```

Why is the above trait bound considered higher-rank?

* It's saying that `M` must implement `Matcher<&'a T>` for all 
  possible lifetimes `'a`.
* This is different from a simple generic lifetime because it's quantifying the 
  lifetime at the trait bound level, not at the function level.
* It's essentially a "*forall*" quantifier nested inside the type signature, 
  hence "*higher-rank*".

### Lifetime Subtyping

Lifetime subtyping is an important concept in Rust's borrowing and lifetime 
system. It allows for more flexible and expressive code when dealing with 
references that have different lifetimes.

Lifetime subtyping is based on the idea that one lifetime can be a "*subtype*" 
of another, meaning it lives at least as long as the other.

We express this relationship as `'a: 'b`, which is read as "*`'a` outlives `'b`*" 
or "`'a` is a subtype of `'b`".

If `'a: 'b`, then any reference with lifetime `'a` can be used where a reference 
with lifetime `'b` is expected. This is because `'a` is guaranteed to live at 
least as long as `'b`, so it's safe to use in place of `'b`.

Here is an example:

```rust
struct Context<'s>(&'s str);

struct Parser<'c, 's: 'c> {
    context: &'c Context<'s>,
}

impl<'c, 's> Parser<'c, 's> {
    fn parse(&self) -> Result<(), &'s str> {
        Err(&self.context.0[1..])
    }
}

fn parse_context(context: Context) -> Result<(), &str> {
    Parser { context: &context }.parse()
}

fn main() {
    let context = Context("Hello, world!");
    let result = parse_context(context);
    println!("Result: {:?}", result);
}
```

This showcases lifetime subtyping, where one lifetime must outlive another.

Note that the last few examples are more advanced use cases of lifetimes
that you might not encounter frequently in everyday Rust programming.
Regardless, they demonstrate the flexibility and power of Rust's lifetime system.

Let's use a different example to illustrate lifetime without any annotation
to see how Rust infers lifetimes, and how you can intuitively reason about
them:

```rust
fn main() {
    let title: &str;
    let content: &str;
    let article: Article;

    {
        let t = String::from("Rust Lifetimes");
        let c = String::from("Lifetimes are a complex but powerful...");
        
        title = &t;
        content = &c;
        
        article = Article { title, content };
        
        // Article can be used here
        println!("Title: {}", article.title);
    } // t and c go out of scope here

    // This would cause a compile error:
    // println!("Title: {}", article.title);
}
```

It's good that Rust infers most of the lifetimes for us. Otherwise, the above
code would have looked something like this:

```rust
struct Article<'a, 'b> {
    title: &'a str,
    content: &'b str,
}

fn main<'main>() {
    let title: &'main str;
    let content: &'main str;
    let article: Article<'main, 'main>;

    {
        let t: String = String::from("Rust Lifetimes");
        let c: String = String::from("Lifetimes are a complex but powerful...");
        
        title = &'main t;
        content = &'main c;
        
        article = Article { title, content };
        
        // Article can be used here
        println!("Title: {}", article.title);
    } // t and c go out of scope here

    // This would cause a compile error:
    // println!("Title: {}", article.title);
}
```

In this example, `Article` can't be used after `t` and `c` go out of scope
because its lifetime is constrained by the lifetimes of the references it holds.

The Rust compiler ensures that article is not used beyond the scope where both 
title and content are valid.

To be clear, lifetimes express constraints, not durations.

* The `'a` in `Article<'a>` means "*this struct is parameterized by some 
  lifetime `'a`*". It does **NOT** mean, "*this struct's life is bound by `'a`*"
* The `'a` on the fields means "*these references must be valid for at least 
  the lifetime `'a`*".
* The struct itself is bound by these constraints--it cannot be used in a 
  context where these constraints aren't met.

So, more precisely:

* The `<'a>` doesn't impose a constraint; it declares a lifetime parameter.
* The uses of `'a` in the field types create the actual constraints, tying the 
  struct's usable lifetime to the lifetimes of its references.

Here's another way to think about it:

```rust
struct Article<'a> {
    title: &'a str,
    content: &'a str,
}
```

The above is conceptually similar to how we use generic types:

```rust
struct Pair<T> {
    first: T,
    second: T,
}
```

In both cases, the angle brackets introduce a parameter (*lifetime or type*) 
that's then used within the struct definition.

The key point is that `Article<'a>` is defining a family of types, one for each 
possible concrete lifetime. The compiler then ensures that whenever an `Article` 
is instantiated, all the lifetimes line up correctly.

## Closures

Let's shift our focus to **closures** in Rust. Closures in Rust have some 
similarities to those in Go, but there are also significant differences due to 
Rust's unique features like ownership and borrowing.

Let's start with a basic overview and then compare with Go:

In Rust, a closure looks like this:

```rust
let add_one = |x| x + 1;
```
Rust can often infer the types, but you can also be explicit:

```rust
let add_one: fn(i32) -> i32 = |x: i32| x + 1;
```

Rust closures can capture variables from their environment:

```rust 
let y = 5;
let add_y = |x| x + y;
```

Now, let's compare with Go:

* Similarities
  * Both Rust and Go support closures (*anonymous functions that can capture 
    their environment*).
  * Both allow closures to be passed as arguments and returned from functions.
* Key Differences
  * Syntax 
    * Rust uses `|params| body` syntax.
    * Go uses `func(params) { body }` syntax.
  * Capture Mechanism
    * Rust has more complex capture rules due to its ownership system.
    * Go simply captures by reference. 
    
### Mutability

Rust requires explicit mutability:

```rust
let mut x = 5;
let mut add_to_x = |y| {
    x += y;
    x
};
```

### Ownership and Borrowing

Rust closures interact with the borrow checker:

```rust
let v = vec![1, 2, 3];
let print_vec = || println!("{:?}", v);  // Borrows v
print_vec();
// v can be used here because the borrow has ended
```

### Move Semantics

Rust allows forcing ownership transfer into the closure:

```rust
let v = vec![1, 2, 3];
let print_vec = move || println!("{:?}", v);
// v is moved into the closure and can't be used here
```

### Closure Traits:

Rust closures implement traits like `Fn`, `FnMut`, or `FnOnce`, which 
determines how they can be called and what they can do with captured variables.

Here's a more complex example in Rust:

```rust
fn create_adder(x: i32) -> impl Fn(i32) -> i32 {
    move |y| x + y
}


fn main() {
    let add_5 = create_adder(5);
    println!("5 + 10 = {}", add_5(10));  // Outputs: 5 + 10 = 15
}
```

This demonstrates returning a closure and using the move keyword to transfer 
ownership of captured variables.

So, while Rust and Go both support closures, Rust's implementation is more 
complex due to its ownership system. This complexity brings additional safety 
guarantees and performance optimizations that aren't present in Go's simpler 
model.

## Concurrency

Rust provides OS-level threads through the standard library using threads.

```rust
use std::thread;

fn main() {
    let handle = thread::spawn(|| {
        println!("Hello from a thread!");
    });

    handle.join().unwrap();
}
```

Unlike Go's lightweight goroutines, these are OS threads.

Rust uses channels for communication between threads, similar to Go:

```rust
use std::sync::mpsc;
use std::thread;

fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        tx.send("Hello from a thread!").unwrap();
    });

    println!("Received: {}", rx.recv().unwrap());
}
```

Rust allows shared state concurrency, but with strict rules to prevent 
data races:

```rust
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();
            *num += 1;
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Result: {}", *counter.lock().unwrap());
}
```

It's also worth noting that Rust uses OS-level threads, which are heavier than 
Go's goroutines. In addition, Rust doesn't have a built-in scheduler like Go's 
runtime.

One more nuance is Rust's ownership rules apply to concurrent code, ensuring 
thread safety. In Go, you need to be careful about sharing mutable state 
between goroutines.

## Async/Await

Rust also has async/await syntax for asynchronous programming:

```rust
use async_std::task;

async fn say_hello() {
    println!("Hello, async world!");
}

fn main() {
    task::block_on(async {
        say_hello().await;
    });
}
```

This is more similar to Go's goroutines in terms of lightweight concurrency.

## No Built-in Select

Rust doesn't have a built-in select statement like Go.
There are crates ([like `crossbeam`][crossbeam]) that provide similar 
functionality.

## Error Handling

* Rust's `Result` type is often used for error handling in concurrent code.
* Go typically uses multiple return values for error handling.

## Rust's Approach to Concurrency

Rust's approach to concurrency is designed to leverage its ownership and type 
system to prevent common concurrency bugs at compile time. This can make 
concurrent Rust code more verbose than Go, but it provides stronger 
safety guarantees.

## Atomic Reference Counter (Arc)

Let's copy one of the code snippets above for further discussion:

```rust
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();
            *num += 1;
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Result: {}", *counter.lock().unwrap());
}
```

Here, `counter` is an `Arc<Mutex<i32>>`:

### `Arc`

* `Arc` (*Atomic Reference Counted*) allows multiple ownership across threads.
* `Mutex` (*mutual exclusion*) ensures only one thread can access the data at 
  a time.

### `counter.lock()`

* `counter.lock()` attempts to acquire the lock on the `Mutex`.
* It returns a `Result<MutexGuard<i32>, PoisonError<MutexGuard<i32>>>`.
* If successful, it gives you a `MutexGuard<i32>`, which acts like a smart 
  pointer to the protected data.
* If the mutex is already locked, the thread will block until it can acquire 
  the lock.

### `unwrap()`

* `.unwrap()` extracts the `MutexGuard<i32>` from the `Result` if the lock was 
  successfully acquired. 
* If the lock failed (e.g., due to poison), it will panic.

So, `counter.lock().unwrap()`; does the following:

* Tries to lock the mutex.
* If successful, gives you access to the protected data.
* If it fails (*which is rare and usually indicates a serious problem like a 
  panic in another thread while holding the lock*), it will panic.

Here's a more detailed example:

```rust
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();
            *num += 1;
            // MutexGuard automatically unlocks when it goes out of scope
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Result: {}", *counter.lock().unwrap());
}
```

Key points to remember:

* `lock()` is used to safely access the shared data.
* `unwrap()` is used here for simplicity, but in production code, you might 
  want to handle potential errors more gracefully.
* The `MutexGuard` returned by `lock()` automatically releases the lock when it 
  goes out of scope.

This pattern ensures that only one thread can modify the counter at a time, 
preventing data races and other concurrency issues.

## More on `unwrap()`

`unwrap()` is a method available on `Result<T, E>` and `Option<T>` types.

It's used to extract the value inside a `Result` or `Option`.

For `Result<T, E>`:

* If the `Result` is `Ok(value)`, `unwrap()` returns the value.
* If the `Result` is `Err(e)`, `unwrap()` will panic.

For `Option<T>`:

* If the `Option` is `Some(value)`, `unwrap()` returns the value.
* If the `Option` is `None`, `unwrap()` will panic.

Here's an example:

```rust
rust main() {
    // With Result
    let result: Result<i32, &str> = Ok(5);
    let value = result.unwrap(); // This is fine, value = 5

    let error_result: Result<i32, &str> = Err("oops");
    // let value = error_result.unwrap(); // This would panic!

    // With Option
    let option: Option<i32> = Some(10);
    let value = option.unwrap();  // This is fine, value = 10

    let none_option: Option<i32> = None;
    // let value = none_option.unwrap();  // This would panic!
}
```

## Alternatives to `unwrap()`

* `expect()` works similar to `unwrap()`, but allows you to specify an error 
  message.
* You can use `match` foor more fine-grained control over both success and 
  error cases.
* `if let`: For concise handling when you only care about the success case.
* `?` operator: For propagating errors in functions that return `Result`.


Here's an example of more robust error handling:

```rust
fn divide(a: i32, b: i32) -> Result<i32, String> {
    if b == 0 {
        Err("Division by zero".to_string())
    } else {
        Ok(a / b)
    }
}

fn main() {
    match divide(10, 2) {
        Ok(result) => println!("Result: {}", result),
        Err(e) => println!("Error: {}", e),
    }

    // Or using if let
    if let Ok(result) = divide(10, 0) {
        println!("Result: {}", result);
    } else {
        println!("Division failed");
    }
}
```

In summary, while `unwrap()` is a convenient way to quickly get to the value 
in a `Result` or `Option`, it's generally better to use more explicit error 
handling in production code to avoid unexpected panics and provide better error 
information.

## Mutexes

Let's revisit the example with `Mutex`:

```rust
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();
            *num += 1;
            // MutexGuard automatically unlocks when it goes out of scope
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Result: {}", *counter.lock().unwrap());
}
```

Here are some key points in the above example to consider:

### Mutex Locking

* When you call `counter.lock()`, it returns a `MutexGuard` wrapped in a `Result`.
* `MutexGuard` is a smart pointer that provides exclusive access to the data 
  inside the `Mutex`.
* While a `MutexGuard` exists, no other thread can acquire the lock on this 
  Mutex.

### Exclusive Access

* Once you've called `unwrap()` and have the `MutexGuard`, you have exclusive 
  access to the data.
* Other threads trying to lock the same Mutex will block until your `MutexGuard` 
  is dropped.

### Borrow Checking

* The borrow checker ensures that you use the `MutexGuard` correctly within your 
  thread.
* It prevents you from keeping the lock longer than necessary or trying to 
  acquire it multiple times simultaneously in the same thread.


### Lock Release

The `MutexGuard` automatically releases the lock when it goes out of scope 
(*i.e., at the end of the block or function where it was created*).

### Annotated Example

Here's an expanded example to illustrate:

```rust 
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();
            // At this point, we have exclusive access to the data
            *num += 1;
            // The lock is released here when `num` goes out of scope
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Final count: {}", *counter.lock().unwrap());
}
```

Let's review the key points:

* The `Mutex` ensures that only one thread can access the data at a time.
* The borrow checker ensures that within a single thread, you're using the 
  `MutexGuard` correctly.
* The combination of Mutex and Rust's ownership system provides thread-safe 
  access to shared mutable state.

## The `join()` Method

* `join()` waits for the thread to finish and returns a `Result`.
* Its signature is: `fn join(self) -> Result<T, Box<dyn Any + Send + 'static>>`.


The Result allows for handling of two scenarios:

* The thread completed successfully (Ok variant)
* The thread panicked (Err variant)

## Modules and Crates

**Modules** and **crates** are fundamental to organizing Rust code, especially 
as projects grow larger.

### Modules

* **Modules** are used to organize code within a **crate**.
* They can be defined in a single file or in separate files.

### Crates

* A crate is the smallest amount of code that the Rust compiler considers at a 
  time.
* It can be a **binary crate** (*an executable*) or a **library crate**.


Let's create a simple project to demonstrate:

```bash
cargo new my_project
cd my_project
```
Now, let's structure our project:

Here is the project file structure:

```txt
my_project/
├── Cargo.toml
└── src/
├── main.rs
├── lib.rs
└── models/
├── mod.rs
├── user.rs
└── product.rs
```

### Defining Modules

In `src/lib.rs`

```rust
// Declare the models module
pub mod models;

// You can also define modules inline
pub mod utils {
    pub fn helper_function() {
        println!("I'm a helper!");
    }
}
```

In `src/models/mod.rs`:

```rust
// Declare submodules
pub mod user;
pub mod product;
```

In `src/models/user.rs`:

```rust
pub struct User {
    pub name: String,
    pub age: u32,
}

impl User {
    pub fn new(name: String, age: u32) -> Self {
        User { name, age }
    }
}
```

In `src/models/product.rs`:

```rust
pub struct Product {
    pub name: String,
    pub price: f64,
}
```

### Using Modules

In `src/main.rs`:

```rust
// Import the library crate
use my_project::models::{user::User, product::Product};
use my_project::utils::helper_function;

fn main() {
    let user = User::new("Alice".to_string(), 30);
    println!("User: {} is {} years old", user.name, user.age);

    let product = Product { name: "Book".to_string(), price: 29.99 };
    println!("Product: {} costs ${}", product.name, product.price);

    helper_function();
}
```

### Visibility

* Items in modules are private by default.
* Use `pub` keyword to make items public.
* You can use `pub(crate)` to make items visible only within the current crate.


### The `use` Keyword

* Brings items into scope.
* Can be used with aliases: `use std::io::Result as IoResult;`

### The `mod` Keyword

* Declares a module.
* Can be used to create inline modules or to load module contents from another 
  file.

### Crate Root

* `src/main.rs` is the crate root of a binary crate.
* `src/lib.rs` is the crate root of a library crate.

So, `src/main.rs` and `src/lib.rs` have special status in Rust projects.
Rust and Cargo automatically recognize these files without needing explicit 
module declarations.

### Key Points

* Use modules to organize related code together.
* The module hierarchy doesn't need to match your file system structure, but it 
  often does for clarity.
* You can have both a binary and a library crate in the same project.
* Use `cargo build` to compile and `cargo run` to run your project.

### Declaring Modules

#### File Approach

If you declare `pub mod models;`, for example, Rust will first look for a file 
named `models.rs` in the same directory as the file where you declared the module.

#### Directory Approach

If `models.rs` doesn't exist, Rust will look for a directory named `models` with 
a file named `mod.rs` inside it.

You don't need both models.rs and a models/ directory; Rust will use one or the 
other. If both exist, Rust will use `models.rs` and ignore the `models/` 
directory.

The choice between file and directory approach often depends on the size and 
complexity of your module.

As your project grows, you can easily switch from the file approach to the 
directory approach without changing how other parts of your code import the module.

### Nested Modules

You can define modules inside other modules.

This creates a hierarchy that can help organize complex code structures.

* You can either inline nested modules;
* Or use separate files for nested modules.

Nested modules provide a way to create a logical hierarchy in your code, which 
is especially useful for large projects. They allow you to group related 
functionality together while maintaining clear boundaries between different 
parts of your codebase.

## Smart Pointers

Box<T>, Rc<T>, Arc<T> ? EditCertainly! 

Smart pointers are an important concept in Rust, providing additional 
functionality beyond regular references. Let's dive into `Box<T>`, `Rc<T>`, 
and `Arc<T>`:

### `Box<T>`

`Box<T>` is a smart pointer for heap allocation.

* Stores data on the heap rather than the stack
* Useful for recursively defined types or when you need a type of unknown size
* Has single ownership semantics

Here's an example:

```rust
fn main() {
    let b = Box::new(5);
    println!("b = {}", b);

    // Recursive type example
    enum List {
        Cons(i32, Box<List>),
        Nil,
    }

    let list = List::Cons(1, 
        Box::new(List::Cons(2, 
            Box::new(List::Nil))));
}
```

In this code, `Cons` is a variant of the `List` enum that represents a node 
in a recursively defined linked list.

The List enum is defined with two variants:

* `Cons(i32, Box<List>)`: This variant represents a non-empty list node.
* `Nil`: This variant represents the end of the list.

In the `Cons` variant:

* The first element (`i32`) is the value stored in the current node.
* The second element (`Box<List>`) is a boxed pointer to the next node in the list.

The `Box` is used here because Rust needs to know the size of all types at 
compile time. Without `Box`, the `List` type would have an infinite size due to 
its recursive nature. `Box` provides a fixed-size pointer to heap-allocated 
data, solving this issue.

### `Rc<T>` (*Reference Counted*)

`Rc<T>` allows multiple ownership of the same data.

* Keeps track of the number of references to a value.
* Only for use in **single-threaded** scenarios
* Values are **immutable** by default

Here's an example:

```rust
use std::rc::Rc;

fn main() {
    let a = Rc::new(String::from("Hello"));
    let b = Rc::clone(&a);
    let c = Rc::clone(&a);

    println!("Reference count: {}", Rc::strong_count(&a)); 
    // Prints: Reference count: 3
    
    println!("{}, {}, {}", a, b, c);
}
```

### `Arc<T>` (*Atomically Reference Counted*)

`Arc<T>` is similar to `Rc<T>` but safe to use in **concurrent** situations.

* Thread-safe version of `Rc<T>`
* Slightly more expensive than `Rc<T>` due to the overhead of atomic operations
* Commonly used in multithreaded programs

Here's an example:

```rust
use std::sync::Arc;
use std::thread;

fn main() {
    let s = Arc::new(String::from("Hello, threads!"));
    let mut handles = vec![];

    for _ in 0..3 {
        let s_clone = Arc::clone(&s);
        let handle = thread::spawn(move || {
            println!("{}", s_clone);
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }
}
```

It's important to note that `Arc::clone(&s)` doesn't create a borrow, but a new 
owned reference to the same data.

* Each clone increases the reference count of the Arc.
* The `Arc` keeps track of how many clones exist.
* The data is only dropped when the last `Arc` is dropped and the count reaches 
  zero.

Also, `Arc` allows the data to be safely shared between threads because it uses 
atomic operations for its reference counting.

The actual data is kept alive as long as at least one `Arc` pointing to it exists.
When the last `Arc` is dropped, the data is automatically deallocated.

* `Arc` provides shared, **immutable** access to its contents.
* If you need mutable access, you'd typically combine `Arc` with something like 
  `Mutex` or `RwLock`.


Let's break down our example a bit more:

```rust
use std::sync::Arc;
use std::thread;

fn main() {
    let s = Arc::new(String::from("Hello, threads!"));
    let mut handles = vec![];

    for _ in 0..3 {
        let s_clone = Arc::clone(&s);
        let handle = thread::spawn(move || {
            println!("{}", s_clone);
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }
}
```

Here is what's happening:

* `Arc::new(String::from("Hello, threads!"))` creates an `Arc` containing the 
   string.
* `Arc::clone(&s)` creates a new `Arc` pointing to the same data, incrementing 
   the reference count.
* `thread::spawn(move || { ... })` **moves** the `s_clone` into the new thread, 
  giving that thread ownership of this `Arc`.
* Each thread can safely read the string because `Arc` provides thread-safe 
  shared access.
* As each thread finishes, its `Arc` is dropped, decrementing the reference 
  count.
* The original `Arc` in the main thread keeps the data alive until all threads 
  have finished.
* When the main thread ends and the last `Arc` is dropped, the string is 
  deallocated.

Also note that we can't move the original Arc into multiple threads: Each thread 
needs its own Arc pointing to the shared data.

Other key points:

* `Arc` is about shared ownership, not borrowing.
* It's safe for concurrent use because its reference counting is atomic.
* It keeps the data alive until all references are dropped.
* `Arc` itself only provides immutable access; for mutable access, you'd need 
  to combine it with synchronization primitives.

Here's how you can implement a shared, mutable counter using Arc and Mutex:

```rust
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    // Create a shared, mutable counter
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();
            *num += 1;
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Final count: {}", *counter.lock().unwrap());
}
```

### Comparison and Use Cases

#### `Box<T>`

Use when you have a large amount of data you want to transfer ownership of 
without copying:

* For recursive types
* When you need a trait object

#### `Rc<T>`

Use it:

* When you need multiple ownership in a single-threaded context
* For implementing shared data structures like graphs

#### `Arc<T>`

Use it:

* When you need multiple ownership in a multithreaded context
* For sharing data between threads

#### `RefCell<T>`

`RefCell<T>` is often used with `Rc<T>` to allow mutable borrowing:

```rust
use std::cell::RefCell;
use std::rc::Rc;

fn main() {
    let data = Rc::new(RefCell::new(5));

    let a = Rc::clone(&data);
    let b = Rc::clone(&data);

    *a.borrow_mut() += 1;
    *b.borrow_mut() *= 2;

    println!("data: {:?}", data); // Prints: data: RefCell { value: 12 }
}
```

`RefCell<T>`:

* Provides interior mutability
* Enforces borrowing rules at runtime instead of compile time
* Often used with `Rc<T>` to create mutable, shared data structures

Smart pointers in Rust provide powerful tools for managing memory and ownership 
in various scenarios, allowing you to build complex data structures and manage 
shared state effectively.

We'll cover `Cell<T>` and `RefCell<T>` in more detail in **Interior Mutability**
section that follows.

### Atomic Types

For simple counters, you might consider using atomic types, which can be more 
efficient:

```rust
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::Arc;
use std::thread;

fn main() {
    let counter = Arc::new(AtomicUsize::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            counter.fetch_add(1, Ordering::SeqCst);
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Final count: {}", counter.load(Ordering::SeqCst));
}
```

This approach using `AtomicUsize` is often more efficient for simple operations 
like counters, as it doesn't require locking.

## Interior Mutability

**Interior Mutability** is the ability to mutate data even when there are
immutable references to that data. It's a way to bend Rust's strict borrowing
rules in a controlled, safe manner.

### `Cell<T>`

`Cell<T>` provides interior mutability for types that implement `Copy`.

This has no runtime cost, but limited to `Copy` types.

```rust
use std::cell::Cell;

struct Counter {
    value: Cell<i32>,
}

impl Counter {
    fn new(value: i32) -> Self {
        Counter { value: Cell::new(value) }
    }

    fn increment(&self) {
        self.value.set(self.value.get() + 1);
    }

    fn get(&self) -> i32 {
        self.value.get()
    }
}

fn main() {
    let counter = Counter::new(0);
    
    counter.increment();
    counter.increment();
    
    println!("Count: {}", counter.get()); // Prints: Count: 2
}
```

`Cell<T>`:

* Works only with `Copy` types (*like `i32`, `bool`, etc.*)
* Provides `get()` and `set()` methods
* No runtime borrow checking
* Useful for simple, thread-local mutable state

### `RefCell<T>`

`RefCell<T>` provides interior mutability for any type.

It enforces borrowing rules at **runtime** instead of compile-time.

```rust
use std::cell::RefCell;

struct Logger {
    logs: RefCell<Vec<String>>,
}

impl Logger {
    fn new() -> Self {
        Logger { logs: RefCell::new(Vec::new()) }
    }

    fn add_log(&self, message: &str) {
        self.logs.borrow_mut().push(message.to_string());
    }

    fn logs(&self) -> Vec<String> {
        self.logs.borrow().clone()
    }
}

fn main() {
    let logger = Logger::new();

    logger.add_log("First log");
    logger.add_log("Second log");

    println!("Logs: {:?}", logger.logs());
}
```

`RefCell<T>`:

* Works with any type `T`
* Provides `borrow()` and `borrow_mut()` methods
* Enforces borrowing rules at **runtime**
* Panics if borrowing rules are violated
* Useful for more complex scenarios where compile-time borrowing is
  too restrictive

### When to Use `Cell<T>` and `RefCell<T>`

* Use `Cell<T>` for simple types that implement `Copy` when you need interior
  mutability.
* Use `RefCell<T>` when you need interior mutability for *non-Copy* types or
  when you need more complex borrowing patterns.

### Safety and Performance or `Cell<T>` and `RefCell<T>`

* `Cell<T>` has no runtime cost but is limited to `Copy` types.
* `RefCell<T>` has a small runtime cost but can be used with any type.
* `RefCell<T>` can panic if borrowing rules are violated at runtime.
* Both are **not thread-safe**. For thread-safe versions, use `Mutex` or
  `RwLock`.

### Common Use Cases for Interior Mutability

* Implementing self-referential structures
* Modifying data in callbacks
* Implementing caches or memoization

Here's an example combining `RefCell` with `Rc` for a shared, mutable data
structure:

```rust
use std::cell::RefCell;
use std::rc::Rc;

struct SharedData {
    value: RefCell<i32>,
}

fn main() {
    let data = Rc::new(SharedData { value: RefCell::new(1) });

    let data_clone = Rc::clone(&data);
    
    // Modify the value
    *data.value.borrow_mut() += 10;
    
    // Read the value from the clone
    println!("Value: {}", 
        *data_clone.value.borrow()); // Prints: Value: 11
}
```

This pattern allows for shared mutable state, but be cautious as it can lead to
runtime panics if not used correctly.

## Macros

Macros are a powerful feature in Rust that allow you to write code that writes 
other code, which is known as [metaprogramming][metaprogramming]. 

There are two main types of macros in Rust:

* Declarative Macros (macro_rules!)
* Procedural Macros

Let's start with Declarative Macros:

### Declarative Macros (macro_rules!)

* These are also known as "*macro by example*" or "*macro_rules macros*"
* They are Defined using the `macro_rules!` syntax
* They Allow you to write something similar to a match expression

Here's an example:

```rust
macro_rules! say_hello {
    () => {
        println!("Hello!");
    };
    ($name:expr) => {
        println!("Hello, {}!", $name);
    };
}

fn main() {
    say_hello!(); // Prints: Hello!
    say_hello!("Rust"); // Prints: Hello, Rust!
}
```

* Declarative macros use pattern matching to define different behaviors
* They are expanded before the compiler interprets the meaning of the code
* They are useful for reducing repetitive code

Now, let's look at Procedural Macros:

### Procedural Macros

These are more powerful and flexible than declarative macros

They come in three flavors:

* Function-like macros
* Derive macros
* Attribute macros

* They operate on the [abstract syntax tree (*AST*)] of Rust code

Here is an example of a simple function-like procedural macro:

First, in a separate crate (typically with a name like `my_macro`):

```rust
use proc_macro::TokenStream;
use quote::quote;
use syn;

#[proc_macro]
pub fn make_answer(_item: TokenStream) -> TokenStream {
    let answer = 42;
    let expanded = quote! {
        println!("The answer is: {}", #answer);
    };
    expanded.into()
}
```

Then, in your main crate:

```rust
use my_macro::make_answer;

fn main() {
    make_answer!();
}
```

This will print: `"The answer is: 42"`

Here are some important points of procedural macros:

* They are more complex but more powerful than declarative macros
* They require a separate crate to define
* They can generate arbitrary Rust code
* The are commonly used for deriving traits, generating boilerplate code, etc.

### Differences between Macros and Functions

* Macros are expanded at compile time, functions are called at runtime
* Macros can take a variable number of arguments, functions have a fixed number
* Macros can generate repetitive code more easily
* Macros are more complex and can be harder to debug

### Common Use Cases for Macros:

* Creating domain-specific languages (*DSLs*)
* Reducing boilerplate code
* Implementing traits automatically (*with derive macros*)
* Creating test frameworks or assertion macros

Here's an example of a more complex declarative macro:

```rust
macro_rules! vec_of_strings {
    ($($x:expr),*) => {
        {
            let mut temp_vec = Vec::new();
            $(
               temp_vec.push($x.to_string());
            )*
            temp_vec
        }
    };
}

fn main() {
    let v = vec_of_strings![1, "hello", 3.14, true];
    println!("{:?}", v);  
    // Prints: ["1", "hello", "3.14", "true"]
}
```

This macro creates a vector of strings from a variety of input types.

## Unsafe Rust

**Unsafe Rust** is a way to tell the Rust compiler "*I know what I'm doing*" 
for operations it can't verify as safe. It allows you to perform operations 
that might violate Rust's safety guarantees.

Unsafe Rust is typically used to:

* Interact with hardware or other languages (like C)
* Implement fundamental abstractions that safe Rust builds upon
* Optimize performance-critical code

Here are certain things that you can do with unsafe Rust:

* Dereference raw pointers
* Call unsafe functions (*including C functions*)
* Access or modify mutable static variables
* Implement unsafe traits

Since you are bypassing Rust's safety checks, you have
certain responsibilities when using unsafe code:

* Ensure memory safety
* Prevent data races
* Avoid undefined behavior

Here's an example of unsafe Rust:

```rust
fn main() {
    let mut num = 5;

    let r1 = &num as *const i32;
    let r2 = &mut num as *mut i32;

    unsafe {
        println!("r1 is: {}", *r1);
        *r2 += 1;
        println!("r2 is: {}", *r2);
    }
}
```

In this example:

* We create raw pointers (`*const i32` and `*mut i32`)
* We dereference these pointers in an unsafe block

Common use cases for unsafe:

Here are things to keep in ming when using unsafe Rust:

* Minimize the amount of unsafe code
* Encapsulate unsafe code in safe abstractions
* Document your safety assumptions and invariants
* Use `debug_assert! `to check invariants in debug builds

It's important to note that "unsafe" doesn't mean the code is necessarily 
dangerous; it means the compiler can't verify its safety. Well-written unsafe 
code can be just as safe as safe Rust, but it requires more care and expertise 
to get right.

## `debug_assert!` and `assert!`

`assert!` is a macro used for debugging and testing purposes. It allows you to 
check if a boolean condition is `true` and panics if the condition is `false`.

`debug_assert!` is a conditional compilation macro for assertions
Similar to assert!, but only enabled in debug builds.

* In debug builds: Acts like `assert!`
* In release builds: The code is completely removed, incurring zero runtime cost

Here's an example:

```rust
rustCopyfn divide(a: i32, b: i32) -> i32 {
    debug_assert!(b != 0, "Divisor must not be zero!");
    a / b
}

fn main() {
    println!("10 / 2 = {}", divide(10, 2));
    // Uncomment the next line to see the debug assertion in action
    // println!("10 / 0 = {}", divide(10, 0));
}
```

## Build Profiles

* Debug build (default): `cargo build` or `cargo run`
* Release build: `cargo build --release` or `cargo run --release`


## `assert!` in Test

`assert!` is commonly used in tests to check conditions and ensure correctness.

Here's an example:

```rust
mod tests {
    use super::*;

    #[test]
    fn test_calculate_average() {
        let nums = vec![1.0, 2.0, 3.0];
        assert_eq!(calculate_average(&nums), 2.0);
    }

    #[test]
    #[should_panic(expected = "Cannot calculate average of an empty slice")]
    fn test_calculate_average_empty() {
        let empty: Vec<f64> = vec![];
        calculate_average(&empty);
    }
}
```

In tests, `assert!` and its variants are used extensively.

## `assert!` In Production Code

### When to Use `assert!` in Production Code

* Checking invariants that, if violated, indicate a bug in the program.
* Verifying preconditions in public APIs where the conditions are clearly 
  documented.
* Ensuring internal consistency in data structures.

### When **Not** to Use `assert!` in Production Code

* For handling expected error conditions (*use `Result` instead*).
* For checking user input (*validate and return errors instead*).
* In performance-critical paths where the check is redundant.

## Associated Types

Associated types are a way to associate a **type** with a **trait**. They're 
used when a trait needs to use a type, but the specific type isn't known until 
the trait is implemented.

Here's an example:

```rust
trait Container {
    type Item;
    fn add(&mut self, item: Self::Item);
    fn get(&self) -> Option<&Self::Item>;
}

struct VecContainer<T>(Vec<T>);

impl<T> Container for VecContainer<T> {
    type Item = T;

    fn add(&mut self, item: Self::Item) {
        self.0.push(item);
    }
    
    fn get(&self) -> Option<&Self::Item> {
        self.0.last()
    }
}
```

You can use associated types:

* When you want to associate types with traits without using generics
* To improve code readability and reduce the number of generic parameters

## Default Type Parameters

Default type parameters allow you to specify a default type for a generic 
type parameter. This can be useful for reducing boilerplate when a specific type 
is commonly used.

Here's an example:

```rust
use std::ops::Add;

#[derive(Debug, PartialEq)]
struct Point<T = f64> {
    x: T,
    y: T,
}

impl<T: Add<Output = T>> Add for Point<T> {
    type Output = Self;

    fn add(self, other: Self) -> Self::Output {
        Point {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}

fn main() {
    let p1 = Point { x: 1.0, y: 2.0 };
    let p2 = Point { x: 3.0, y: 4.0 };
    let p3 = p1 + p2;
    
    assert_eq!(p3, Point { x: 4.0, y: 6.0 });
}
```

You'd use default types parameters:

* To provide a commonly used default type
* To maintain backwards compatibility when adding new type parameters 
  to existing code

## Fully Qualified Syntax

This syntax allows you to disambiguate between multiple implementations of a 
trait for a type, or to call a specific trait method.

Here's an example:

```rust
trait Animal {
    fn make_sound(&self);
}

trait Cat {
    fn make_sound(&self);
}

struct MyCat;

impl Animal for MyCat {
    fn make_sound(&self) {
        println!("Animal sound");
    }
}

impl Cat for MyCat {
    fn make_sound(&self) {
        println!("Meow");
    }
}

fn main() {
    let cat = MyCat;

    // cat.make_sound(); // Ambiguous, won't compile
    
    // Fully qualified syntax
    Animal::make_sound(&cat); // Prints: Animal sound
    Cat::make_sound(&cat);    // Prints: Meow
    
    // Alternative syntax
    <MyCat as Animal>::make_sound(&cat); // Prints: Animal sound
    <MyCat as Cat>::make_sound(&cat);    // Prints: Meow
}
```

You can use fully-qualified syntax:

* To disambiguate between multiple trait implementations
* To explicitly call a trait method when there might be ambiguity

These features contribute to Rust's powerful type system:

## Newtype Pattern

The newtype pattern involves creating a new type, usually to wrap an existing 
type. This is done using a tuple struct with a single field.

Here's an example:

```rust
struct Meters(f64);
struct Kilometers(f64);

impl Meters {
    fn to_kilometers(&self) -> Kilometers {
        Kilometers(self.0 / 1000.0)
    }
}

fn main() {
    let distance = Meters(5000.0);
    println!("Distance in km: {}", distance.to_kilometers().0);
}
```

Here are some use cases for ths pattern:

* Type safety: Prevent mixing up different units or concepts
* Implementing traits for types you don't own
* Adding methods to existing types without modifying them

## Type Aliases

Type aliases create a new name for an existing type. They don't create a new 
type; they're just a **shorthand**.

Here's an example:

```rust
type Kilometers = f64;

fn distance_to_mars(speed: Kilometers) -> Kilometers {
    225.0 * 1_000_000.0 / speed
}

fn main() {
    let speed = 100.0;  // km/h
    println!("Time to Mars: {} hours", distance_to_mars(speed));
}
```

Here are some use cases for type aliases:

* Simplifying complex type signatures
* Creating domain-specific vocabularies
* Improving code readability


## Never Type (`!`)

The **never type**, denoted by `!`, represents a type that can never be instantiated. 
It's used for functions that never return.

Here's an example:

```rust
fn exit() -> ! {
    std::process::exit(0);
}

fn main() {
    let x: i32 = loop {
        if some_condition() {
            break 5;
        } else if another_condition() {
            exit();  // This function never returns
        }
    };
    
    println!("x is {}", x);
}

fn some_condition() -> bool { true }
fn another_condition() -> bool { false }
```

Here are when you might use the *never type*:

* Indicating that a function never returns (like `panic!` or `exit`)
* In match expressions where some arms diverge
* Representing the "*bottom*" type in type theory

Let's look at a more complex example combining these concepts:

```rust
use std::ops::Add;

// Newtype
struct Money(u32);

// Type alias
type Result<T> = std::result::Result<T, String>;

// Function that returns the never type
fn transaction_error(msg: &str) -> ! {
    panic!("Transaction Error: {}", msg);
}

impl Add for Money {
    type Output = Result<Money>;

    fn add(self, other: Self) -> Self::Output {
        let sum = self.0.checked_add(other.0)
            .ok_or_else(|| "Overflow occurred".to_string())?;
        Ok(Money(sum))
    }
}

fn process_transaction(a: Money, b: Money) -> Result<Money> {
    match a + b {
        Ok(sum) => Ok(sum),
        Err(e) => transaction_error(&e),  // This arm has type `!`
    }
}

fn main() -> Result<()> {
    let wallet1 = Money(100);
    let wallet2 = Money(50);
    let total = process_transaction(wallet1, wallet2)?;

    println!("Total money: {}", total.0);
    Ok(())
}
```

In this example above:

* `Money` is a newtype, providing type safety for monetary values.
* `Result<T>` is a type alias, simplifying error handling syntax.
* `transaction_error` returns `!`, indicating it never returns normally.

These features contribute to Rust's type system by:

* Enhancing type safety and encapsulation (*newtype*)
* Improving code readability and maintenance (*type aliases*)
* Expressing control flow and type-level constraints (*never type*)

Let see *never type* in some more action:

```rust
// A function that returns !
fn forever() -> ! {
    loop {
        println!("I'm running forever!");
    }
}

// ! in a match expression
fn check_number(x: i32) -> &'static str {
    match x {
        0 => "zero",
        1 => "one",
        _ => panic!("Unknown number"),  // This arm has type !
    }
}

// Using ! for diverging functions
fn exit(code: i32) -> ! {
    std::process::exit(code)
}

fn main() {
    let x: u32 = loop {
      break 42;
    };
    println!("x: {}", x);  // This works because ! can coerce to u32
                           // Never type can coerce to any type

    // This would run forever:
    // forever();

    println!("Number: {}", check_number(1));  // Prints: Number: one
    // This would panic:
    // check_number(2);

    // This would exit the program:
    // exit(0);
}
```

Here are some key points:

* `!` is used for functions or expressions that don't return normally.
* It doesn't cause panics, but is often used in contexts where panics occur.
* It can be used to satisfy the type system in places where a value is needed 
  but never actually provided.

## Never Type versus Null

The "never type" is more akin to concepts like "bottom" in type theory or `void` 
in some other languages. It is not `null`, but more like "indeterminate". 

"never type" is a way to represent computations that don't complete normally, 
whether due to infinite loops, program termination, or panics.

In Rust, which doesn't have `Null`, the closest equivalent to Null would be 
`Option<T>` with a `None` value. This is very different from `!`, as `Option<T>` 
is about representing the **presence or absence of a value**, while `!` is 
about representing the **absence of a return**.

## Function Pointers

Function pointers allow you to pass functions as arguments or store them in 
structs. They have a concrete size known at compile time.

Here's the syntax: `fn(params) -> return_type`

Here's an example that uses function pointers:

```rust
fn add(a: i32, b: i32) -> i32 {
   a + b
}

fn subtract(a: i32, b: i32) -> i32 {
    a - b
}

fn do_operation(f: fn(i32, i32) -> i32, x: i32, y: i32) -> i32 {
  f(x, y)
}

fn main() {
    println!("Add: {}", do_operation(add, 5, 3));
    // Prints: Add: 8
    
    println!("Subtract: {}", do_operation(subtract, 5, 3)); 
    // Prints: Subtract: 2
}
```

Here are certain use cases for function pointers:

* Callbacks
* [Strategy pattern][strategy]
* Pluggable behavior in algorithms

## Returning Closures

Closures are anonymous functions that can capture their environment. Returning 
closures is a bit trickier because their size isn't known at compile time, so 
we need to use **dynamic dispatch**.

Here's the syntax: `Box<dyn Fn(params) -> return_type>`

Here is an example that returns closures:

```rust
fn create_adder(x: i32) -> Box<dyn Fn(i32) -> i32> {
    Box::new(move |y| x + y)
}

fn main() {
    let add_5 = create_adder(5);
    println!("5 + 10 = {}", add_5(10));  // Prints: 5 + 10 = 15
}
```

Here are some use cases for returning closures:

* Factory functions
* Customizable behaviors
* Partial function application

Now let's look at a more complex example combining several concepts:

```rust
fn math_operation(op: &str) -> Box<dyn Fn(i32, i32) -> i32> {
    match op {
        "add" => Box::new(|x, y| x + y),
        "subtract" => Box::new(|x, y| x - y),
        "multiply" => Box::new(|x, y| x * y),
        "divide" => Box::new(|x, y| x / y),
        _ => Box::new(|x, _| x),  
        // ^ Identity function for unknown operations
    }
}

fn apply_operations(operations: 
    &[fn(i32, i32) -> i32], x: i32, y: i32) -> Vec<i32> {
    operations.iter().map(|op| op(x, y)).collect()
}

fn main() {
    let add = math_operation("add");
    println!("10 + 5 = {}", add(10, 5));  // Prints: 10 + 5 = 15

    let operations = [
        math_operation("add") as fn(i32, i32) -> i32,
        math_operation("multiply") as fn(i32, i32) -> i32,
    ];

    let results = apply_operations(&operations, 10, 5);

    println!("Results: {:?}", results);  // Prints: Results: [15, 50]
}
```

Here are some insights and considerations:

* Function pointers (fn) have a known size and can be used in FFI 
  (*Foreign Function Interface*).
* Closures returned as `Box<dyn Fn(...)>` can capture their environment but 
  require dynamic dispatch.
* Function pointers can be coerced to closures, but not vice versa.
* Returning closures often requires the use of `Box` and dynamic dispatch due 
  to their unknown size.
* Function pointers can't capture environment.
* Returned closures have a runtime cost due to dynamic dispatch.
* The `'static` lifetime is often required for returned closures to ensure 
  they live long enough.

These features allow for powerful functional programming patterns in Rust, 
enabling you to write more flexible and reusable code.

## Async/Await

Here is how you can use async/await in Rust:

```rust
// Tokio is a popular asynchronous runtime for Rust:
use tokio;

async fn fetch_data(url: &str) -> Result<String, Box<dyn std::error::Error>> {
    // Simulating an async operation
    tokio::time::sleep(std::time::Duration::from_secs(1)).await;
    Ok(format!("Data from {}", url))
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let result = fetch_data("https://example.com").await?;
    println!("Fetched: {}", result);
    Ok(())
}
```

Here is an example of concurrent operations:

```rust
use tokio;
use futures::future::join_all;

async fn fetch_multiple(urls: &[&str]) -> 
    Vec<Result<String, Box<dyn std::error::Error>>> {
    let fetches = urls.iter().map(|&url| fetch_data(url));
    join_all(fetches).await
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let urls = vec!["https://example.com", "https://rust-lang.org"];
    let results = fetch_multiple(&urls).await;
    for result in results {
        match result {
            Ok(data) => println!("Fetched: {}", data),
            Err(e) => println!("Error: {}", e),
        }
    }
    Ok(())
}
```

Here are some key points about async/await:

* Async functions return a `Future`, which must be polled to make progress.
* The runtime is responsible for polling `Future`s.
* You need to choose and set up an async runtime (*`tokio`, `async-std`, etc.*).
* The `#[tokio::main]` attribute sets up the `tokio` runtime for the `main` 
  function.
* Async functions typically return `Result<T, E>` for error handling.
* The `?` operator is often used for propagating errors in async contexts.
* Rust's async/await is designed to have minimal runtime overhead.
* `Future`s in Rust often need to be pinned in memory for safety reasons.
* For async iterators, Rust has the `Stream` trait, similar to JavaScript's 
  async iterators.


## `#[tokio::main]` 

`#[tokio::main]` is an attribute macro that sets up the `tokio` runtime for
the `main` function. It's a convenient way to run asynchronous code in Rust.

Attribute macros allow you to create custom attributes that can be applied to
items like functions, structs, or modules. They can generate, modify, or 
replace code.

The `#[tokio::main]` is just one example of this broader concept. 

Here are some other common uses:

* **Test Framework**: `#[test]`
* **Derive Macros**: `#[derive(Debug, Clone)]`
* **Web Frameworks**: `#[get("/")]` in [Rocket][rocket] or [Actix][actix]
* **Async Runtimes**: `#[tokio::main]`, `#[async_std::main]`
* **Serialization**: `#[serde(rename = "my_field")]`

## Web Assembly

Compiling Rust to [WebAssembly (Wasm)][wasm] is indeed an exciting topic. 
Rust is one of the best-supported languages for WebAssembly compilation, thanks 
to its low-level control and lack of runtime.

Let's see how we can compile Rust into Web Assembly:

First add the WebAssembly target:

```bash
rustup target add wasm32-unknown-unknown
```

Then install `wasm-pack`:

```bash
cargo install wasm-pack
```

Then create a new library project:

```bash
cargo new --lib hello-wasm
cd hello-wasm
```

Now, modify `Cargo.toml`:

```toml
[lib]
crate-type = ["cdylib"]

[dependencies]
wasm-bindgen = "0.2"
```

Write your rust code:

```rust
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn greet(name: &str) -> String {
    format!("Hello, {}!", name)
}
```

Build the WebAssembly module:

```bash
wasm-pack build --target web
```

Then use in HTML/JavaScript:

Create an `index.html` file:

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Rust WebAssembly Demo</title>
</head>
<body>
    <script type="module">
        import init, { greet } from './pkg/hello_wasm.js';

        async function run() {
            await init();
            const result = greet('WebAssembly');
            document.body.textContent = result;
        }

        run();
    </script>
</body>
</html>
```

Use any kind of local statis server to serve the files.

```bash
python3 -m http.server
```

Here's what happens in this process:

* `wasm-bindgen` is crucial for creating JavaScript bindings for your Rust functions.
* The `#[wasm_bindgen]` attribute exposes Rust functions to JavaScript.
* `wasm-pack` handles much of the complexity of building and packaging Wasm modules.
* The resulting `.wasm` file is not used directly; instead, use the generated 
  JavaScript wrapper.

Here's a more complex example using web APIs:

```rust
use wasm_bindgen::prelude::*;
use web_sys::{Document, HtmlElement};

#[wasm_bindgen(start)]
pub fn run() -> Result<(), JsValue> {
    let window = web_sys::window().expect("no global `window` exists");
    let document = window.document().expect("should have a document on window");
    let body = document.body().expect("document should have a body");

    let val = document.create_element("p")?;
    val.set_inner_html("Hello from Rust!");

    body.append_child(&val)?;

    Ok(())
}
```

This example demonstrates how to manipulate the [DOM][dom] using Rust compiled to 
WebAssembly.

## Why Use Rust for WebAssembly

Here are certain areas where using Rust for WebAssembly shines:

* CPU-intensive calculations (*e.g., audio/video processing, complex simulations*)
* Porting existing C/C++/Rust libraries to the web
* Games and graphics-intensive applications
* Cryptography and security-related computations

WebAssembly is about bringing near-native performance to the web for 
computationally intensive tasks. Rust's safety guarantees and performance make it 
an excellent choice for WebAssembly.

The real power of [Wasm][wasm] comes when you combine WebAssembly's performance 
with JavaScript's flexibility.

You can use WebAssembly when:

* You need high performance for complex computations
* You're working with large amounts of data
* You want to port existing Rust libraries to the web
* You're developing performance-critical web applications 
  (*like games or design tools*)

## Wasm JavaScript Wrapper

In the generated code

* The `.wasm` file contains the compiled WebAssembly module. It is a binary file.
* The `my_wasm_module.js` file is a JavaScript wrapper that provides a friendly 
  interface to the WebAssembly module.

Here's a conceptual view of how it works:

```txt
[Your JavaScript Code] 
    <-> [JS Wrapper (.js)] 
       <-> [WebAssembly Module (.wasm)]
```

The JavaScript wrapper is doing several important things:

* **Loading**: It fetches and instantiates the `.wasm` module.
* **Type Conversion**: It handles converting between JavaScript types and 
  WebAssembly types.
* **Memory Management**: For more complex data structures, it may handle 
  allocating and freeing memory in the WebAssembly linear memory.
* **Error Handling**: It can provide more JavaScript-friendly error handling.

## Embedded Programming In Rust

Embedded Rust programming is an exciting field that allows you to use Rust's 
safety and performance features for microcontroller-based systems.


To program embedded Rust, first, you'll need to install some additional tools:

```bash
rustup target add thumbv7em-none-eabihf  
# ^ For ARM Cortex-M4F and Cortex-M7F

cargo install cargo-embed cargo-binutils
```

Here are some key concepts that you need to be aware of:

* **No Standard Library**: Embedded Rust often uses `#![no_std]` attribute as 
  the full standard library isn't available.
* **Hardware Abstraction Layers (*HAL*s)**: Crates that provide a safe, 
  high-level interface to microcontroller peripherals.
* **Embedded HAL**: A standardized API for common embedded functionality.
* **Runtime**: Embedded Rust programs often provide their own runtime, 
  including interrupt vectors and initialization code.

Here is an example:

Let's create a simple LED blink program for an `STM32F3DISCOVERY` board 
(*which uses an ARM Cortex-M4F*).

First, create a new project:

```bash
cargo new --bin led_blink
cd led_blink
```

Then update `Cargo.toml`:

```toml
[package]
name = "led_blink"
version = "0.1.0"
edition = "2021"

[dependencies]
cortex-m = "0.7"
cortex-m-rt = "0.7"
panic-halt = "0.2"
stm32f3xx-hal = { version = "0.9", features = ["stm32f303xc", "rt"] }

[[bin]]
name = "led_blink"
test = false
bench = false
```

Replace `src/main.rs` with the following:

```rust
#![no_std]
#![no_main]

use panic_halt as _;
use cortex_m_rt::entry;
use stm32f3xx_hal::{pac, prelude::*};

#[entry]
fn main() -> ! {
    let dp = pac::Peripherals::take().unwrap();

    let mut rcc = dp.RCC.constrain();
    let mut gpioe = dp.GPIOE.split(&mut rcc.ahb);

    let mut led = gpioe
        .pe13
        .into_push_pull_output(
            &mut gpioe.moder, &mut gpioe.otyper);

    loop {
        led.set_high().unwrap();
        cortex_m::asm::delay(8_000_000);
        led.set_low().unwrap();
        cortex_m::asm::delay(8_000_000);
    }
}
```

Now let's build the project:

```bash
cargo build --release
```

Build for release:

```bash
cargo embed --release
```

Here are some important differences from standard Rust:

* `#![no_std]`: We can't use the standard library.
* `#![no_main]`: We define our own entry point with `#[entry]`.
* `-> !`: The main function never returns (it's an infinite loop).
* **Direct hardware manipulation**: We're directly controlling GPIO pins.
* **No dynamic memory allocation**: Typically, we avoid using the heap in 
  embedded systems.

Embedded Rust supports debugging through **GDB** and **OpenOCD**. You can use 
`cargo run` with the appropriate runner configuration to start a debug session.

For more complex applications, you might use an **RTOS** (*realtime operating 
system*). The [**RTIC** (*Real-Time Interrupt-driven Concurrency*)][rtic] 
framework is popular in the Rust embedded community.

Here are some other common creates for embedded development:

* [embedded-hal][embedded-hal]: Provides traits for common embedded functionalities.
* [cortex-m][cortex-m]: Low-level access to Cortex-M processors.
* [cortex-m-rt][cortex-m-rt]: Startup code and minimal runtime for Cortex-M processors.
* Various HAL crates for specific microcontroller families (*like `stm32f3xx-hal` 
  in our example*).

Embedded Rust combines the safety and expressiveness of Rust with the ability to 
write low-level code for microcontrollers, making it an excellent choice for 
developing reliable embedded systems.

## Rustup

`rustup` is the official Rust toolchain installer and version management tool. 
It allows you to:

* Install and update Rust
* Switch between stable, beta, and nightly Rust versions
* Keep track of and install different Rust versions
* Install additional components like rust-src or rust-analyzer

Here are some key commands:

```bash
rustup update                 # Update Rust
rustup default stable         # Set the default toolchain
rustup target add wasm32-unknown-unknown  # Add a compilation target
rustup component add rustfmt  # Add a component
```

## Cargo

Cargo is Rust's package manager and build system. It's installed alongside 
Rust and handles:

* Creating new projects
* Building your code
* Managing dependencies
* Running tests
* Generating documentation

Here are some key commands:

```bash
cargo new my_project # Create a new project
cargo build          # Compile the project
cargo run            # Run the project
cargo test           # Run tests
cargo doc --open     # Generate and open documentation
```

## `rustc`

The Rust compiler. You typically interact with it through Cargo, but you can 
use it directly too:

```bash
rustc main.rs  # Compile a single file
```

## `rustfmt`

The official Rust code formatter. It ensures consistent code style across Rust 
projects.

## Clippy

A collection of lints to catch common mistakes and improve your Rust code.

```bash
cargo clippy  # Run clippy on your project
```

## `rust-analyzer`

A language server implementation for Rust, providing IDE-like features to 
code editors.

These tools (*and some others*) form the core of the Rust development experience, 
providing a robust, integrated ecosystem for writing, testing, and deploying 
Rust code.

## Testing Rust

### Unit Tests

Unit tests in Rust are typically written in the same file as the code they're 
testing.

* They are annotated with `#[test]`
* They are placed in a module annotated with `#[cfg(test)]`

```rust
// In src/lib.rs or src/main.rs
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add() {
        assert_eq!(add(2, 2), 4);
    }
}
```

### Integration Tests

Integration tests are external to your library and use it as any other code would.

They're placed in the tests directory
Each file in the tests directory is compiled as a separate crate

Here is an example:

```rust
// In tests/integration_test.rs
use my_crate;

#[test]
fn test_add_integration() {
    assert_eq!(my_crate::add(2, 2), 4);
}
```

### Organization

* Unit tests: In the same file as the code, within a tests module
* Integration tests: In the tests directory
* You can have multiple test files in the tests directory


### Running Tests

Here is how you run tests:

```bash
cargo test  # Run all tests
cargo test test_name  # Run a specific test
cargo test -- --nocapture  # Show println! output
```

### Test Attributes

* `#[should_panic]`: Test should panic
* `#[ignore]`: Skip this test unless specifically requested

Here's an example:

```rust
#[test]
#[should_panic(expected = "divide by zero")]
fn test_divide_by_zero() {
    divide(1, 0);
}

#[test]
#[ignore]
fn expensive_test() {
    // ...
}
```

### Test Organization Best Practices

* Keep unit tests close to the code they're testing
* Use descriptive test names
* Group related tests in modules
* Use helper functions for common setup or assertions

Here's an example of a more organized test structure:

```rust
// In src/lib.rs
pub mod math {
    pub fn add(a: i32, b: i32) -> i32 {
        a + b
    }

    pub fn subtract(a: i32, b: i32) -> i32 {
        a - b
    }

    #[cfg(test)]
    mod tests {
        use super::*;

        #[test]
        fn test_add() {
            assert_eq!(add(2, 2), 4);
        }

        #[test]
        fn test_subtract() {
            assert_eq!(subtract(4, 2), 2);
        }
    }
}
```

```rust
// In tests/math_integration_tests.rs
use my_crate::math;

#[test]
fn test_add_and_subtract() {
    let result = math::add(5, 5);
    assert_eq!(math::subtract(result, 5), 5);
}
```

### Mocking

Rust doesn't have a built-in mocking framework, but crates like 
[mockall][mockall] can be used for mocking.

### Test Coverage

You can use tools like [tarpaulin][tarpaulin] to measure test coverage:

```bash
cargo install cargo-tarpaulin
cargo tarpaulin
```

## Publishing Packages

Here is how you can publish your Rust crate:

First, ensure your Cargo.toml file is properly configured:

```toml
[package]
name = "your_crate_name"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]
edition = "2024"
description = "A short description of your crate"
license = "MIT"
repository = "https://github.com/yourusername/your_crate"
documentation = "https://docs.rs/your_crate_name"
readme = "README.md"
keywords = ["keyword1", "keyword2"]
categories = ["category1", "category2"]

[dependencies]
# Your dependencies here
```

Then, create an Account on crates.io, if you haven't already done so.

Then login to crates.io via Cargo

```bash
cargo login
```

Before publishing, it's good to check your package:

```bash
cargo package
```

This command will create a `.crate` file in the `target/package/` directory.

When you're ready to publish, execute the following command:

```bash
cargo publish
```

This will upload your crate to [crates.io][crates].

To publish a new version, update the `version` field in `Cargo.toml` and run 
`cargo publish` again.

## Publishing Best Practices


* Use semantic versioning (`MAJOR.MINOR.PATCH`) for your crate versions.
* Write good documentation. Use `//!` for module-level docs and `///` for 
  function/struct docs. Your crate's documentation will automatically be built 
  and published on `docs.rs`.
* Include a `README.md` file with basic usage instructions and examples.
* Ensure you've chosen an appropriate license for your crate.
* Make sure all tests pass before publishing.
* If you publish a version with a critical bug, you can 
  yank it: `cargo yank --vers 1.0.1`
* If your crate depends on private crates, you can't publish it on `crates.io`.
* You can do a dry run of publishing with: `cargo publish --dry-run`.
* Choose appropriate categories and keywords to make your crate discoverable.

## Atomics in Rust

Rust provides atomic types in the `std::sync::atomic` module. These types allow 
for **lock-free** synchronization between threads.

Here are basic atomic types:

* `AtomicBool`
* `AtomicI32`, `AtomicU32`, `AtomicI64`, `AtomicU64`
* `AtomicUsize`, `AtomicIsize`
* `AtomicPtr<T>`

Here's a sample code that uses atomics:

```rust
use std::sync::atomic::{AtomicUsize, Ordering};

let counter = AtomicUsize::new(0);
counter.fetch_add(1, Ordering::SeqCst);
println!("Counter: {}", counter.load(Ordering::SeqCst));
```

## Memory Ordering

Rust's atomics allow you to specify memory ordering constraints:

* `Ordering::Relaxed`: Provides no synchronization or ordering guarantees. 
  It's the fastest but also the most dangerous to use incorrectly.
* `Ordering::Release`: Ensures that all memory operations before the release 
  operation are visible to other threads that perform an **acquire** operation 
  on the same variable.
* `Ordering::Acquire`: Ensures that all memory operations **after** the 
  **acquire** operation are ordered after the **acquire**. Or, more 
  concisely, all subsequent operations see the effects of the previous 
  **release**.
* `Ordering:AcqRel`: Combines the effects of both Acquire and Release orderings. 
* `Ordering:SeqCst`: Provides the strongest guarantees, ensuring a total order 
  for all `SeqCst` operations across all threads.

Ordering is crucial for implementing synchronization primitives and lock-free 
data structures. It allows one thread to safely communicate changes to shared 
data to other threads.

A common pattern is:

* Thread A: Modify shared data, then do a `Release` operation 
  (*e.g., `store` with `Release` ordering*)
* Thread B: Perform an `Acquire` operation (e.g., `load` with `Acquire` 
  ordering), then read the shared data.

### Happens-before Relationship

Think of `Release` as sealing an envelope: Everything you've written
(*previous memory operations*) is sealed inside. The `Acquire` `load` is
like opening the envelope, ensuring the recipient sees all its contents.

The `Release` `store` establishes a **happens-before** relationship with the 
corresponding `Acquire` `load`.

This means all operations before the `Release` are guaranteed to happen 
**before** all operations **after** the `Acquire` in the other thread.

The "*`Acquire` first, `Release` next*" pattern typically refers to the
consumer-producer relationship:

* **Producer** uses `Release` to signal that data is ready.
* **Consumer** uses `Acquire` to wait for and read that signal.

### Bringing Balance to the Force

`Release` ordering is more expensive than `Relaxed` but less expensive than 
`SeqCst`. It provides a good balance between performance and necessary 
synchronization for this pattern.

### Why Orderings Matter

Without `Order::Acquire` and other orderings, the CPU might reorder memory 
operations for optimization purposes. The `Acquire` and other orderings prevent 
this specific type of reordering.

* For example, with a relaxed `load`, the CPU might speculatively execute 
  subsequent reads or writes *before* the load actually completes. `Acquire` 
  ordering prevents this.
* Compiler reordering: It's not just the CPU. The compiler can also reorder 
  operations for optimization. `Acquire` ordering also constrains the 
  compiler, preventing it from moving operations that come after the `Acquire` 
  (*in program order*) to before it.
* Memory visibility across cores: In multicore systems, memory operations on 
 one core might not be immediately visible to other cores. `Acquire` synchronizes 
 with Release operations on other cores, ensuring proper visibility of memory 
 operations across cores.
* Out-of-order execution: CPUs can execute instructions out of order if they 
  determine it's safe to do so.
* Speculative execution: CPUs might execute instructions before they're certain 
  they're needed.
* Compiler optimizations: Compilers might reorder operations if they believe 
  it won't affect the program's observable behavior.
* Cache coherency: In multicore systems, each core might have its own cache, 
  leading to potential inconsistencies in memory visibility.

Lets' see this with a multithreaded example:

```rust
use std::sync::atomic::{AtomicBool, Ordering};
use std::thread;

static FLAG: AtomicBool = AtomicBool::new(false);
static DATA: AtomicBool = AtomicBool::new(false);

fn main() {
    let t1 = thread::spawn(|| {
        DATA.store(true, Ordering::Relaxed);
        FLAG.store(true, Ordering::Relaxed);
    });

    let t2 = thread::spawn(|| {
        while !FLAG.load(Ordering::Relaxed) {}
        assert!(DATA.load(Ordering::Relaxed));
    });

    t1.join().unwrap();
    t2.join().unwrap();
}
```

In this code, we might expect that if thread 2 sees `FLAG` set to `true`, 
it would always see `DATA` as true. However, with `Relaxed` ordering, this isn't 
guaranteed. The CPU or compiler could reorder the operations in thread 1, or 
the write to `DATA` might not be visible to thread 2 immediately.

Here's some reasons why this might happen:

* **Single-thread perspective**: The compiler often reasons about optimizations 
  from the perspective of a single thread. If swapping two lines doesn't affect 
  the observable behavior within that thread, the compiler might indeed reorder 
  lines of code.
* **As-if rule**: Compilers follow what's known as the "*as-if*" rule. They 
  can perform any optimization as long as the observable behavior of the program 
  remains the same--from the perspective of that single thread.
* **Lack of inter-thread awareness**: Without explicit synchronization or memory 
  ordering constraints, the compiler doesn't consider the effects of its
  optimizations on other threads. It assumes that each thread operates 
  independently.

By using appropriate memory orderings, you're essentially saying to the 
compiler (and the CPU): "*Even though you can't see why from a single-thread 
perspective, these operations need to stay in this order for the program to 
work correctly across all threads*."

To fix the random behavior that might happen in the code above, we would use 
`Release` ordering for the `store`s in thread 1 and `Acquire` ordering for the 
`load`s in thread 2:

```rust
FLAG.store(true, Ordering::Release);
// ...
while !FLAG.load(Ordering::Acquire) {}
```

### Lock-Free Programming

Here's a more practical example of a lock-free stack implementation that 
leverages memory ordering:

```rust
use std::sync::atomic::{AtomicPtr, Ordering};
use std::ptr;

struct Node<T> {
    data: T,
    next: AtomicPtr<Node<T>>,
}

pub struct Stack<T> {
    head: AtomicPtr<Node<T>>,
}

impl<T> Stack<T> {
    pub fn new() -> Self {
        Stack { head: AtomicPtr::new(ptr::null_mut()) }
    }

    pub fn push(&self, data: T) {
        let new_node = Box::into_raw(Box::new(Node {
            data,
            next: AtomicPtr::new(ptr::null_mut()),
        }));

        loop {
            let old_head = self.head.load(Ordering::Relaxed);
            unsafe {
                (*new_node).next.store(old_head, Ordering::Relaxed);
            }
            if self.head.compare_exchange(old_head, new_node, 
                Ordering::Release, Ordering::Relaxed).is_ok() {
                break;
            }
        }
    }

    pub fn pop(&self) -> Option<T> {
        loop {
            let old_head = self.head.load(Ordering::Acquire);
            if old_head.is_null() {
                return None;
            }
            let new_head = unsafe { 
                (*old_head).next.load(Ordering::Relaxed) };
            if self.head.compare_exchange(old_head, new_head, 
                Ordering::Release, Ordering::Relaxed).is_ok() {
                let data = unsafe { Box::from_raw(old_head).data };
                return Some(data);
            }
        }
    }
}
```

### Ordering Types for `store` Operations

* `store` operations can use `Relaxed`, `Release`, or `SeqCst` ordering.
* `Acquire` and `AcqRel` orderings are not applicable to store operations.
* `Acquire` ordering is used for `load` operations. It ensures that subsequent
  memory accesses in the same thread cannot be reordered before this `load`.

### Lock-Free Programming Is Not Easy

Remember, while lock-free structures can offer great performance benefits, 
they are also much more challenging to implement correctly. 

Always profile and benchmark to ensure they are providing real benefits in 
your specific use case.

## References and Further Reading

Here is a non-exhaustive list of tools, resources, references, libraries, and 
concepts mentioned in this article:

* [Haskell Programming Language][haskell]
* [Go Programming Language][go]
* [Rust Programming Language][rust]
* ["*The*" Rust Book][rust-book]
* [Rustlings][rustlings]
* [Rust Reddit][r-rust]
* [Rust on YouTube][rust-youtube]
* [Programming Rust][programming-rust]
* [Rust by Example][rust-by-example]
* [Rust Installation][rust-up]
* [Crates.io: The Rust community’s crate registry][crates]
* [Rust Macros][macro]
* [Metaprogramming][metaprogramming]
* [Functional Programming][fp]
* [Data Races and Race Conditions][data-race]
* [Non-Lexical Lifetimes][nll]
* [Understanding Monads][monad]
* [Builder Pattern][builder]
* [Type Theory][type-theory]
* [Crossbeam Library][crossbeam]
* [Abstract Syntax Tree][ast]
* [Strategy Pattern][strategy]
* [Rocket Web Framework][rocket]
* [Actix Web Framework][actix]
* [WebAssembly][wasm]
* [Document Object Model][dom]
* [Real-Time Interrupt-driven Concurrency][rtic]
* [Embedded HAL][embedded-hal]
* [Cortex-M][cortex-m]
* [Cortex-M RT][cortex-m-rt]
* [Mockall][mockall]
* [Tarpaulin][tarpaulin]

## Conclusion

This was a deep dive into a lot of features and paradigms in Rust, while
occasionally comparing it with other languages such as C++ and Go.

Rust is a powerful language that offers a unique blend of performance, safety,
and expressiveness. It's a great choice for systems programming, web development,
and embedded programming.

Having said that, it's impossible to get a feeling of it without actually
programming something in Rust. So, I encourage you to start coding in Rust,
copy the examples you see here, and try to modify and make sense of them.

The more you code in Rust, the more you'll appreciate its design choices and
the benefits it offers. Also the more you code in rust, the more the relatively
weirder parts of it will start to make sense.

Until next time... May the source be with you 🦄.

[rust]: https://www.rust-lang.org/ "Rust Programming Language"
[go]: https://golang.org/ "Go Programming Language"
[macro]: https://doc.rust-lang.org/book/ch19-06-macros.html "Rust Macros"
[metaprogramming]: https://en.wikipedia.org/wiki/Metaprogramming "Metaprogramming"
[rust-book]: https://doc.rust-lang.org/book/ "The Rust Programming Language"
[rust-by-example]: https://doc.rust-lang.org/rust-by-example/ "Rust by Example"
[rustlings]: https://github.com/rust-lang/rustlings "Rustlings"
[r-rust]: https://www.reddit.com/r/rust/ "Rust Reddit"
[rust-youtube]: https://www.youtube.com/channel/UCaYhcUwRBNscFNUKTjgPFiA "Rust on YouTube"
[programming-rust]: https://www.amazon.com/Programming-Rust-Fast-Systems-Development/dp/1492052590 "Programming Rust"
[rust-up]: https://www.rust-lang.org/tools/install "Rust Installation"
[fp]: https://en.wikipedia.org/wiki/Functional_programming "Functional Programming"
[data-race]: https://doc.rust-lang.org/nomicon/races.html "Data Races and Race Conditions"
[nll]: https://blog.rust-lang.org/2022/08/05/nll-by-default.html "Non-Lexical Lifetimes"
[haskell]: https://www.haskell.org/ "Haskell Programming Language"
[monad]: https://en.wikibooks.org/wiki/Haskell/Understanding_monads/IO "Understanding Monads"
[builder]: https://en.wikipedia.org/wiki/Builder_pattern "Builder Pattern"
[type-theory]: https://en.wikipedia.org/wiki/Type_theory "Type Theory"
[crossbeam]: https://docs.rs/crossbeam/ "Crossbeam Library"
[ast]: https://en.wikipedia.org/wiki/Abstract_syntax_tree "Abstract Syntax Tree"
[strategy]: https://en.wikipedia.org/wiki/Strategy_pattern "Strategy Pattern"
[rocket]: https://rocket.rs/ "Rocket Web Framework"
[actix]: https://actix.rs/ "Actix Web Framework"
[wasm]: https://webassembly.org/ "WebAssembly"
[dom]: https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model "Document Object Model"
[rtic]: https://rtic.rs/ "Real-Time Interrupt-driven Concurrency"
[embedded-hal]: https://docs.rs/embedded-hal/ "Embedded HAL"
[cortex-m]: https://docs.rs/cortex-m/ "Cortex-M"
[cortex-m-rt]: https://docs.rs/cortex-m-rt/ "Cortex-M RT"
[mockall]: https://docs.rs/mockall/ "Mockall"
[tarpaulin]: https://github.com/xd009642/tarpaulin "Tarpaulin"
[crates]: https://crates.io/ "Crates.io"
