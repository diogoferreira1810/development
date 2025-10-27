# Pipeline Glossary

A quick reference guide for CI/CD and GitHub Actions terminology.

## General CI/CD Terms

**CI (Continuous Integration)**
- The practice of automatically building and testing code changes
- Helps catch bugs early
- Ensures code integrates well with existing codebase

**CD (Continuous Delivery)**
- Automatically preparing code for release
- Requires manual approval for production deployment
- Ensures code is always in a deployable state

**CD (Continuous Deployment)**
- Automatically deploying code to production
- No manual approval required
- Every change that passes tests goes live

**Pipeline**
- A series of automated steps that code goes through
- Typically: Build → Test → Deploy
- Defined in YAML files in GitHub Actions

**Build**
- Compiling source code into executable/deployable format
- Installing dependencies
- Creating artifacts

**Artifact**
- Files produced by a build or job
- Examples: compiled binaries, packages, reports
- Can be passed between jobs or downloaded

**Deployment**
- Releasing code to an environment
- Can be staging, production, or other environments
- Often automated in CD pipelines

## GitHub Actions Terms

**Action**
- Reusable unit of code
- Can be from GitHub Marketplace or custom
- Example: `actions/checkout@v4`

**Workflow**
- Automated process defined in YAML
- Located in `.github/workflows/`
- Contains one or more jobs

**Job**
- Set of steps that run on the same runner
- Jobs run in parallel by default
- Can depend on other jobs with `needs`

**Step**
- Individual task within a job
- Runs sequentially within a job
- Can be an action or a shell command

**Runner**
- Server that executes workflows
- Can be GitHub-hosted or self-hosted
- Examples: `ubuntu-latest`, `windows-latest`

**Event**
- Triggers that start a workflow
- Examples: push, pull_request, schedule
- Defined with `on:` in workflow file

**Matrix**
- Strategy for running jobs with different configurations
- Tests across multiple versions/platforms
- Example: Python 3.9, 3.10, 3.11 on Ubuntu, Windows

**Context**
- Information about workflow runs
- Accessed with `${{ }}` syntax
- Examples: `github.ref`, `runner.os`

**Secret**
- Encrypted environment variable
- Stored in repository settings
- Used for sensitive data like API keys

**Environment**
- Deployment target (staging, production)
- Can have protection rules
- Can have environment-specific secrets

## Workflow Components

**on (trigger)**
```yaml
on: push  # When workflow runs
```

**jobs**
```yaml
jobs:     # Collection of jobs in workflow
```

**runs-on**
```yaml
runs-on: ubuntu-latest  # OS for the job
```

**steps**
```yaml
steps:    # Sequential tasks in a job
```

**uses**
```yaml
uses: actions/checkout@v4  # Use an action
```

**run**
```yaml
run: echo "Hello"  # Run a command
```

**with**
```yaml
with:     # Input parameters for an action
  key: value
```

**env**
```yaml
env:      # Environment variables
  VAR: value
```

**if**
```yaml
if: github.ref == 'refs/heads/main'  # Condition
```

**needs**
```yaml
needs: build  # Job dependency
```

## Testing Terms

**Unit Test**
- Tests individual functions/methods
- Fast and isolated
- Example: testing a calculator's add function

**Integration Test**
- Tests how components work together
- More complex than unit tests
- Example: testing API with database

**End-to-End Test (E2E)**
- Tests entire application flow
- Simulates real user scenarios
- Slowest but most comprehensive

**Code Coverage**
- Percentage of code tested
- Measured in lines/branches/functions
- Higher is generally better (but 100% isn't always necessary)

**Test Suite**
- Collection of tests
- Run together in CI
- Should be fast and reliable

**Mock**
- Simulated object/function for testing
- Replaces real dependencies
- Helps isolate tests

**Assertion**
- Statement that checks expected vs actual
- Example: `assert add(2, 2) == 4`
- Test fails if assertion is false

## Code Quality Terms

**Linting**
- Checking code for style/syntax issues
- Example tools: flake8, ESLint
- Catches common mistakes

**Formatting**
- Automatic code styling
- Example tools: Black, Prettier
- Ensures consistent style

**Static Analysis**
- Analyzing code without running it
- Finds bugs, security issues
- Example: type checking

**SAST (Static Application Security Testing)**
- Security scanning of source code
- Finds vulnerabilities before deployment
- Example: CodeQL, Bandit

**DAST (Dynamic Application Security Testing)**
- Security testing of running application
- Tests actual behavior
- Complements SAST

## Deployment Terms

**Staging**
- Pre-production environment
- Used for final testing
- Should mirror production closely

**Production**
- Live environment
- Serves real users
- Requires careful deployment

**Blue-Green Deployment**
- Two identical environments (blue, green)
- Switch traffic between them
- Enables quick rollback

**Canary Deployment**
- Gradual rollout to subset of users
- Monitor for issues
- Roll back if problems detected

**Rolling Deployment**
- Update instances one at a time
- Maintains availability
- Slower but safer

**Rollback**
- Reverting to previous version
- Done when issues detected
- Should be quick and automated

## GitHub Specific Terms

**Repository (Repo)**
- Project containing code and history
- Can be public or private
- Has settings, issues, PRs, etc.

**Branch**
- Parallel version of code
- Used for features/fixes
- Merged back to main

**Pull Request (PR)**
- Request to merge code
- Includes review process
- Triggers CI checks

**Commit**
- Saved change to code
- Has unique SHA identifier
- Part of git history

**SHA**
- Unique identifier for commit
- 40-character hash
- Example: `a1b2c3d4e5f6...`

**Fork**
- Personal copy of repository
- Used for contributions
- Can submit PRs back

**Checkout**
- Switching to specific branch/commit
- First step in most workflows
- Uses `actions/checkout`

## Performance Terms

**Cache**
- Stored data for reuse
- Speeds up workflows
- Example: cached dependencies

**Cache Hit**
- Cache found and used
- Saves time
- Good for performance

**Cache Miss**
- Cache not found
- Must rebuild/redownload
- First run or cache expired

**Parallel Execution**
- Running jobs simultaneously
- Faster than sequential
- Limited by runner availability

**Concurrency**
- Number of simultaneous runs
- Can be limited per plan
- Affects wait times

## Common Abbreviations

**CI/CD** - Continuous Integration/Continuous Deployment
**PR** - Pull Request
**YAML** - YAML Ain't Markup Language
**JSON** - JavaScript Object Notation
**API** - Application Programming Interface
**CLI** - Command Line Interface
**SSH** - Secure Shell
**HTTPS** - HyperText Transfer Protocol Secure
**ENV** - Environment
**OS** - Operating System
**VM** - Virtual Machine
**IaC** - Infrastructure as Code
**SLA** - Service Level Agreement

## Status Terms

**Pending**
- Workflow is queued
- Waiting for runner
- Not yet started

**In Progress**
- Workflow is running
- Steps being executed
- Can be cancelled

**Success** ✅
- All steps passed
- No errors
- Workflow completed

**Failure** ❌
- One or more steps failed
- Needs attention
- Check logs for details

**Cancelled** ⚫
- Manually stopped
- Or stopped by GitHub
- No final status

**Skipped** ⊘
- Step/job didn't run
- Due to condition
- Example: `if: false`

## Best Practices Terms

**DRY (Don't Repeat Yourself)**
- Avoid code duplication
- Use reusable workflows
- Create custom actions

**Idempotent**
- Can run multiple times safely
- Same result each time
- Important for deployments

**Fast Feedback**
- Quick pipeline execution
- Early failure detection
- Better developer experience

**Fail Fast**
- Stop on first error
- Don't waste resources
- Can be disabled with `fail-fast: false`

**Defensive Programming**
- Anticipate failures
- Handle errors gracefully
- Add timeouts and retries

## Need More Information?

- Check **PIPELINE-CONCEPTS.md** for detailed explanations
- See **README.md** for practical examples
- Read **EXERCISES.md** for hands-on learning

---

**Tip**: Bookmark this page for quick reference while learning!
