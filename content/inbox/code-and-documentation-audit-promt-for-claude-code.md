+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Code and Documentation Audit Promt for Claude Code"
date = "2025-12-03"

[taxonomies]
tags = ["inbox", "development", "draft"]
+++

```text
 I need a comprehensive audit of Go documentation vs implementation across the 
 codebase.

Scope: /home/volkan/WORKSPACE/spike-sdk-go

For each exported function, check:
1. Return type mismatches (e.g., doc says "error" but returns 
   "*sdkErrors.SDKError")
2. Parameter type mismatches (e.g., doc says "string" but uses custom type)
3. Missing godoc comments
4. Outdated behavior descriptions
5. Missing parameter documentation
6. Missing return value documentation
7. Inconsistent example code

Focus on:
- All packages under api/
- crypto/ package
- kv/ package
- log/ package
- retry/ package
- security/ package
- strings/ package
- system/ package
- validation/ package
- net/ package
- errors/ package
- spiffe/ package

Return:
- A structured markdown report grouped by issue type
- File paths with line numbers
- Current vs expected documentation
- Severity rating (critical/moderate/minor)

Do NOT make any changes - only analyze and report.

Based on this report, we will create a phased plan and incrementally fix things.

Alternative: Iterative Approach

If you want changes made incrementally:

Audit and FIX documentation issues in these files:
- /home/volkan/WORKSPACE/spike-sdk-go/api/internal/impl/secret/*.go

Check and fix:
1. Return types: Update "error" to "*sdkErrors.SDKError" where applicable
2. Add missing godoc for exported functions
3. Ensure parameter types match function signatures
4. Verify return value lists are complete

After each file, report:
- What was found
- What was fixed
- Line numbers changed
```
