# Pipeline Concepts Guide

## What is a CI/CD Pipeline?

A **CI/CD pipeline** is an automated process that takes code from a repository, builds it, tests it, and optionally deploys it to production. It ensures code quality and enables rapid, reliable software delivery.

### Key Terms

- **CI (Continuous Integration)**: Automatically building and testing code whenever changes are made
- **CD (Continuous Delivery)**: Automatically preparing code for deployment (with manual approval)
- **CD (Continuous Deployment)**: Automatically deploying code to production (no manual approval)

## GitHub Actions Concepts

### 1. Workflows

A **workflow** is an automated process defined in a YAML file (`.github/workflows/*.yml`).

```yaml
name: My Workflow          # Workflow name (shown in UI)
on: [push, pull_request]   # When to run
jobs:                      # What to do
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Hello!"
```

### 2. Events (Triggers)

Events trigger workflows. Common events:

| Event | Description | Example |
|-------|-------------|---------|
| `push` | Code pushed to repository | `on: push` |
| `pull_request` | PR opened/updated | `on: pull_request` |
| `schedule` | Runs on schedule | `on: schedule: - cron: '0 0 * * *'` |
| `workflow_dispatch` | Manual trigger | `on: workflow_dispatch` |
| `release` | Release created | `on: release` |

**Branch Filtering:**
```yaml
on:
  push:
    branches: [ main, develop ]  # Only these branches
    paths:                       # Only when these files change
      - 'src/**'
      - '**.py'
```

### 3. Jobs

**Jobs** are independent units of work that run in parallel by default.

```yaml
jobs:
  job1:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Job 1"
  
  job2:
    needs: job1  # Run after job1
    runs-on: ubuntu-latest
    steps:
      - run: echo "Job 2"
```

**Key Properties:**
- `runs-on`: OS to run on (ubuntu-latest, windows-latest, macos-latest)
- `needs`: Jobs this job depends on
- `if`: Condition for running the job
- `timeout-minutes`: Max execution time

### 4. Steps

**Steps** are sequential tasks within a job.

```yaml
steps:
  - name: Checkout code           # Use an action
    uses: actions/checkout@v4
  
  - name: Run a command           # Run a shell command
    run: echo "Hello World"
  
  - name: Multi-line command      # Multiple commands
    run: |
      echo "Line 1"
      echo "Line 2"
```

### 5. Actions

**Actions** are reusable units of code. Two types:

**Marketplace Actions:**
```yaml
- uses: actions/checkout@v4        # Official GitHub action
- uses: actions/setup-python@v4    # Setup Python environment
  with:                            # Action inputs
    python-version: '3.11'
```

**Local Actions:**
```yaml
- uses: ./.github/actions/my-action  # Your custom action
```

### 6. Runners

**Runners** execute jobs. GitHub provides:
- `ubuntu-latest` (Ubuntu 22.04)
- `windows-latest` (Windows Server 2022)
- `macos-latest` (macOS 14)

**Self-hosted runners** are machines you manage.

### 7. Matrix Builds

Test across multiple versions/platforms simultaneously:

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest, macos-latest]
    python-version: ['3.9', '3.10', '3.11', '3.12']
    exclude:
      - os: macos-latest
        python-version: '3.9'
  fail-fast: false  # Continue if one fails

runs-on: ${{ matrix.os }}
steps:
  - uses: actions/setup-python@v4
    with:
      python-version: ${{ matrix.python-version }}
```

Creates 11 jobs (3 × 4 - 1 excluded).

### 8. Artifacts

**Artifacts** are files produced by jobs:

```yaml
# Upload
- uses: actions/upload-artifact@v3
  with:
    name: my-artifact
    path: dist/
    retention-days: 30

# Download (in another job)
- uses: actions/download-artifact@v3
  with:
    name: my-artifact
```

**Use cases:**
- Build outputs
- Test reports
- Logs
- Coverage reports

### 9. Caching

**Caching** speeds up workflows by reusing dependencies:

```yaml
- uses: actions/cache@v3
  with:
    path: ~/.cache/pip              # What to cache
    key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
    restore-keys: |                 # Fallback keys
      ${{ runner.os }}-pip-
```

**Cache key components:**
- OS: `${{ runner.os }}`
- File hash: `${{ hashFiles('**/*.lock') }}`
- Branch: `${{ github.ref }}`

### 10. Secrets

**Secrets** store sensitive data securely:

```yaml
- name: Deploy
  env:
    API_KEY: ${{ secrets.API_KEY }}      # From repo settings
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}  # Automatic
  run: ./deploy.sh
```

**Adding secrets:**
1. Go to repository Settings
2. Secrets and variables > Actions
3. New repository secret

**Best practices:**
- Never log secrets
- Use organization secrets for shared values
- Rotate regularly

### 11. Environments

**Environments** represent deployment targets:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment:
      name: production
      url: https://example.com
    steps:
      - run: ./deploy.sh
```

**Features:**
- Protection rules (required reviewers)
- Secrets scoped to environment
- Deployment history

### 12. Outputs

Pass data between jobs:

```yaml
jobs:
  job1:
    runs-on: ubuntu-latest
    outputs:
      version: ${{ steps.get_version.outputs.version }}
    steps:
      - id: get_version
        run: echo "version=1.0.0" >> $GITHUB_OUTPUT
  
  job2:
    needs: job1
    runs-on: ubuntu-latest
    steps:
      - run: echo "Version is ${{ needs.job1.outputs.version }}"
```

### 13. Conditionals

Control when steps/jobs run:

```yaml
jobs:
  production:
    if: github.ref == 'refs/heads/main'  # Only on main branch
    steps:
      - if: failure()                     # Run if previous failed
        run: echo "Failed"
      
      - if: success()                     # Run if previous succeeded
        run: echo "Success"
      
      - if: always()                      # Always run
        run: echo "Cleanup"
```

**Common conditions:**
- `github.ref == 'refs/heads/main'` - specific branch
- `github.event_name == 'push'` - specific event
- `success()` - previous steps succeeded
- `failure()` - previous steps failed
- `cancelled()` - workflow cancelled
- `always()` - always run

### 14. Context Variables

Access workflow information:

```yaml
- run: |
    echo "Repository: ${{ github.repository }}"
    echo "Branch: ${{ github.ref }}"
    echo "SHA: ${{ github.sha }}"
    echo "Actor: ${{ github.actor }}"
    echo "Event: ${{ github.event_name }}"
    echo "Runner OS: ${{ runner.os }}"
    echo "Job status: ${{ job.status }}"
```

## Pipeline Stages

A typical pipeline has these stages:

### 1. Build
- Check out code
- Install dependencies
- Compile/package code
- Create artifacts

### 2. Test
- Unit tests
- Integration tests
- Coverage reports
- Performance tests

### 3. Quality
- Linting
- Code formatting
- Static analysis
- Complexity checks

### 4. Security
- Dependency scanning
- SAST (Static Application Security Testing)
- Container scanning
- Secret scanning

### 5. Deploy
- Deploy to environments
- Run smoke tests
- Update infrastructure
- Notify stakeholders

## Best Practices

### 1. Keep Workflows Fast
- ✅ Use caching for dependencies
- ✅ Run jobs in parallel
- ✅ Use matrix builds efficiently
- ✅ Only run necessary steps
- ❌ Don't install unnecessary tools
- ❌ Don't run all tests on every change

### 2. Make Workflows Reliable
- ✅ Pin action versions (`@v4`, not `@main`)
- ✅ Use specific Docker tags
- ✅ Set timeouts
- ✅ Handle failures gracefully
- ❌ Don't rely on external services without fallbacks
- ❌ Don't use mutable dependencies

### 3. Security First
- ✅ Use secrets for sensitive data
- ✅ Minimize permissions (GITHUB_TOKEN)
- ✅ Review third-party actions
- ✅ Scan for vulnerabilities
- ❌ Never commit secrets
- ❌ Don't log sensitive data

### 4. Maintainability
- ✅ Use clear, descriptive names
- ✅ Add comments for complex logic
- ✅ Create reusable workflows
- ✅ Keep workflows focused
- ❌ Don't duplicate code
- ❌ Don't create overly complex workflows

### 5. Cost Optimization
- ✅ Use caching effectively
- ✅ Cancel redundant runs
- ✅ Use appropriate runner sizes
- ✅ Clean up artifacts regularly
- ❌ Don't run on every commit (use paths filters)
- ❌ Don't store large artifacts long-term

## Common Patterns

### Pattern 1: Build Once, Deploy Many
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: ./build.sh
      - uses: actions/upload-artifact@v3
        with:
          name: app
          path: dist/
  
  deploy-staging:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v3
        with:
          name: app
      - run: ./deploy.sh staging
  
  deploy-production:
    needs: deploy-staging
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v3
        with:
          name: app
      - run: ./deploy.sh production
```

### Pattern 2: Pull Request Validation
```yaml
on:
  pull_request:
    branches: [ main ]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm test
      - run: npm run lint
      - if: failure()
        uses: actions/github-script@v7
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '❌ Tests failed!'
            })
```

### Pattern 3: Scheduled Maintenance
```yaml
on:
  schedule:
    - cron: '0 2 * * 0'  # 2 AM every Sunday

jobs:
  cleanup:
    runs-on: ubuntu-latest
    steps:
      - run: ./cleanup-old-data.sh
      - run: ./update-dependencies.sh
      - run: ./generate-reports.sh
```

### Pattern 4: Manual Deployment
```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        type: choice
        options: [staging, production]
        required: true
      version:
        type: string
        required: true

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}
    steps:
      - run: |
          echo "Deploying version ${{ inputs.version }}"
          echo "To environment ${{ inputs.environment }}"
          ./deploy.sh
```

## Debugging Workflows

### View Logs
1. Go to Actions tab
2. Click on workflow run
3. Click on job
4. Expand steps to see output

### Enable Debug Logging
Add repository secrets:
- `ACTIONS_RUNNER_DEBUG=true`
- `ACTIONS_STEP_DEBUG=true`

### Add Debug Steps
```yaml
- name: Debug
  run: |
    echo "::debug::This is a debug message"
    echo "::warning::This is a warning"
    echo "::error::This is an error"
    env | sort
    ls -laR
```

### Test Locally with act
```bash
# Install act
brew install act  # macOS
# or
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Run workflows locally
act push
act pull_request
act -j job-name
```

## Learning Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
- [Marketplace](https://github.com/marketplace?type=actions)
- [Events Reference](https://docs.github.com/en/actions/reference/events-that-trigger-workflows)

## Quick Reference

### Workflow File Location
```
.github/workflows/my-workflow.yml
```

### Basic Structure
```yaml
name: Workflow Name
on: [push]
jobs:
  job-name:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "Hello"
```

### Common Actions
```yaml
- uses: actions/checkout@v4                    # Checkout code
- uses: actions/setup-python@v4                # Setup Python
- uses: actions/setup-node@v4                  # Setup Node.js
- uses: actions/cache@v3                       # Cache dependencies
- uses: actions/upload-artifact@v3             # Upload artifacts
- uses: actions/download-artifact@v3           # Download artifacts
```

### Context Variables
```yaml
${{ github.repository }}      # owner/repo
${{ github.ref }}            # refs/heads/main
${{ github.sha }}            # commit SHA
${{ github.actor }}          # username who triggered
${{ runner.os }}             # Linux/Windows/macOS
${{ secrets.SECRET_NAME }}   # secret value
```

---

**Ready to build pipelines?** Start with the exercises in `EXERCISES.md`!
