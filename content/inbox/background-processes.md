+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Managing Background Processes in Bash: A Complete Guide"
description = "Managing Background Processes in Bash: A Complete Guide"
date = "2024-11-24"

[taxonomies]
tags = ["inbox", "bash"]
+++

When developing applications or running multiple services locally, you often need to run several scripts simultaneously. While you could open multiple terminal windows, a more elegant solution is to manage these processes programmatically. In this post, I'll show you how to create a robust script that can run multiple processes in the background, manage their logs, and clean up properly when shutting down.

## The Challenge

Common scenarios where you might need this approach include:
- Running multiple microservices locally for development
- Starting various components of a distributed system
- Running long-running tasks that need to be monitored

The key requirements for our solution are:
1. Run multiple scripts in the background
2. Capture logs from each process
3. Clean up processes properly when the main script exits
4. Handle interrupts gracefully

## The Solution

Here's a complete script that handles all these requirements:

```bash
#!/bin/bash

declare -a BG_PIDS
LOG_DIR="logs"

cleanup() {
    echo "Cleaning up background processes..."
    for pid in "${BG_PIDS[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            echo "Killing process $pid"
            kill "$pid"
            wait "$pid" 2>/dev/null
        fi
    done
    exit
}

trap cleanup EXIT INT TERM

mkdir -p "$LOG_DIR"

run_background() {
    local script="$1"
    local logfile="$LOG_DIR/$(basename "$script").log"
    
    if [ ! -x "$script" ]; then
        echo "Error: $script is not executable"
        return 1
    fi
    
    "$script" > "$logfile" 2>&1 &
    local pid=$!
    BG_PIDS+=("$pid")
    echo "Started $script with PID $pid, logging to $logfile"
}

run_background "./hack/spike-agent-starter.sh"
# run_background "./path/to/another/script.sh"

echo "Scripts running in background. Logs in $LOG_DIR. Press Ctrl+C to stop all processes."
wait
```

## How It Works

Let's break down the key components:

### Process Management
The script uses an array (`BG_PIDS`) to keep track of all background processes. This is crucial for proper cleanup later.

```bash
declare -a BG_PIDS
```

### Log Management
Each process gets its own log file in a dedicated logs directory:

```bash
LOG_DIR="logs"
mkdir -p "$LOG_DIR"
```

### The Cleanup Function
The cleanup function is responsible for gracefully shutting down all background processes:

```bash
cleanup() {
    echo "Cleaning up background processes..."
    for pid in "${BG_PIDS[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            echo "Killing process $pid"
            kill "$pid"
            wait "$pid" 2>/dev/null
        fi
    done
    exit
}
```

### Signal Handling
The script uses `trap` to ensure cleanup happens in all exit scenarios:

```bash
trap cleanup EXIT INT TERM
```

This catches:
- Normal script exit (EXIT)
- Ctrl+C interrupts (INT)
- Termination signals (TERM)

### Running Background Processes
The `run_background` function handles starting processes and setting up their logs:

```bash
run_background() {
    local script="$1"
    local logfile="$LOG_DIR/$(basename "$script").log"
    
    if [ ! -x "$script" ]; then
        echo "Error: $script is not executable"
        return 1
    fi
    
    "$script" > "$logfile" 2>&1 &
    local pid=$!
    BG_PIDS+=("$pid")
    echo "Started $script with PID $pid, logging to $logfile"
}
```

## Usage

1. Save the script as `run-background.sh`
2. Make it executable:
   ```bash
   chmod +x run-background.sh
   ```
3. Add your scripts to the main execution section:
   ```bash
   run_background "./your-script.sh"
   ```
4. Run it:
   ```bash
   ./run-background.sh
   ```

## Best Practices

1. **Always check executability**: The script verifies that each program is executable before attempting to run it.
2. **Proper signal handling**: Using `trap` ensures no processes are left running.
3. **Organized logging**: Each process gets its own log file, making debugging easier.
4. **Clean exit handling**: The cleanup function verifies each process exists before attempting to kill it.

## Common Issues and Solutions

1. **Zombie Processes**: The script uses `wait` to properly reap child processes.
2. **Log Management**: Logs are automatically organized by script name in the logs directory.
3. **Permission Issues**: The script checks for executable permissions before running each program.

## Conclusion

This script provides a robust foundation for managing background processes in a development environment. It's particularly useful for microservices development, where you need to run multiple services simultaneously.

Remember to modify the script paths and add any specific error handling your use case might require. The modular nature of the script makes it easy to extend with additional functionality like log rotation or process monitoring.
