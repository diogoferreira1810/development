# Pipeline Troubleshooting Guide

## Common Issues and Solutions

### 1. Pipeline Not Triggering

**Problem:** Pipeline doesn't run when you push code

**Solutions:**
- Check that your branch name matches the trigger configuration
- Verify the workflow file is in `.github/workflows/`
- Ensure the workflow file has `.yml` or `.yaml` extension
- Check if there are any syntax errors in the YAML file

### 2. "No module named X" Error

**Problem:** Import errors during test or build steps

**Solutions:**
```yaml
# Make sure you install dependencies first
- name: Install dependencies
  run: |
    python -m pip install --upgrade pip
    pip install -r requirements.txt
```

### 3. Permission Denied

**Problem:** Cannot execute scripts or access files

**Solutions:**
```yaml
# Make script executable
- name: Make script executable
  run: chmod +x ./script.sh

# Or run with explicit interpreter
- name: Run script
  run: bash ./script.sh
```

### 4. Timeout Issues

**Problem:** Job times out

**Solutions:**
```yaml
# Increase timeout (default is 360 minutes)
jobs:
  build:
    runs-on: ubuntu-latest
    timeout-minutes: 60  # Adjust as needed
```

### 5. Cache Not Working

**Problem:** Cache not being restored or saved

**Solutions:**
- Ensure cache key is unique and deterministic
- Check if cache paths exist
- Verify cache size limits (10GB per repository)

```yaml
- name: Cache dependencies
  uses: actions/cache@v3
  with:
    path: ~/.cache/pip
    key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
    restore-keys: |
      ${{ runner.os }}-pip-
```

### 6. Artifact Upload/Download Failures

**Problem:** Cannot upload or download artifacts

**Solutions:**
- Check artifact names match exactly
- Ensure artifacts are created before upload
- Verify path exists and contains files

```yaml
- name: Check before upload
  run: |
    ls -la path/to/artifact
    
- name: Upload with clear name
  uses: actions/upload-artifact@v3
  with:
    name: my-artifact
    path: path/to/artifact
    if-no-files-found: error  # Fail if no files found
```

### 7. Environment Variables Not Set

**Problem:** Environment variables are empty

**Solutions:**
```yaml
# Set at workflow level
env:
  MY_VAR: value

# Set at job level
jobs:
  build:
    env:
      JOB_VAR: value
    
# Set at step level
- name: Run with env
  env:
    STEP_VAR: value
  run: echo $STEP_VAR

# Use GitHub Secrets
- name: Use secret
  env:
    API_KEY: ${{ secrets.API_KEY }}
  run: echo "Key is set"
```

### 8. Matrix Build Failures

**Problem:** Some matrix combinations fail

**Solutions:**
```yaml
strategy:
  matrix:
    python-version: [3.9, 3.10, 3.11]
    os: [ubuntu-latest, windows-latest]
    exclude:
      # Exclude specific combinations
      - python-version: 3.9
        os: windows-latest
  fail-fast: false  # Continue other jobs if one fails
```

### 9. Docker Build Issues

**Problem:** Docker build fails in CI

**Solutions:**
```yaml
- name: Debug Docker
  run: |
    docker version
    docker info
    
- name: Build with verbose output
  run: docker build --progress=plain -t myapp .

# Check Docker daemon is available
- name: Check Docker
  run: docker ps
```

### 10. Git Issues in Pipeline

**Problem:** Git commands fail or show wrong state

**Solutions:**
```yaml
# Fetch full history if needed
- uses: actions/checkout@v4
  with:
    fetch-depth: 0  # Fetch all history

# Configure git if needed
- name: Configure Git
  run: |
    git config --global user.email "action@github.com"
    git config --global user.name "GitHub Action"
```

## Debugging Techniques

### 1. Add Debug Output

```yaml
- name: Debug Information
  run: |
    echo "Runner OS: ${{ runner.os }}"
    echo "GitHub Ref: ${{ github.ref }}"
    echo "GitHub SHA: ${{ github.sha }}"
    echo "Working Directory: $(pwd)"
    ls -la
    env | sort
```

### 2. Enable Debug Logging

In your repository settings, add these secrets:
- `ACTIONS_RUNNER_DEBUG` = `true`
- `ACTIONS_STEP_DEBUG` = `true`

### 3. Use Matrix to Debug

```yaml
strategy:
  matrix:
    include:
      - debug: true
        python-version: 3.11

steps:
  - name: Debug step
    if: matrix.debug
    run: |
      echo "Debug mode enabled"
      # Add debug commands
```

### 4. Conditional Steps for Debugging

```yaml
- name: Debug on failure
  if: failure()
  run: |
    echo "Previous step failed"
    # Add debug commands
    
- name: Always run debug
  if: always()
  run: |
    echo "This runs regardless of previous steps"
```

### 5. Use act for Local Testing

```bash
# Install act (GitHub Actions local runner)
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Run workflow locally
act -l  # List workflows
act push  # Run push event workflows
act -j job-name  # Run specific job
```

## Performance Optimization Tips

### 1. Minimize Checkout Time
```yaml
- uses: actions/checkout@v4
  with:
    sparse-checkout: |
      src/
      tests/
```

### 2. Parallel Jobs
```yaml
jobs:
  test-unit:
    # Runs in parallel
  test-integration:
    # Runs in parallel
  build:
    needs: [test-unit, test-integration]
    # Runs after both tests complete
```

### 3. Smart Caching
```yaml
- uses: actions/cache@v3
  with:
    path: |
      ~/.cache/pip
      ~/.cache/pre-commit
    key: ${{ runner.os }}-${{ hashFiles('**/requirements.txt', '**/.pre-commit-config.yaml') }}
```

### 4. Conditional Execution
```yaml
- name: Skip on docs changes
  if: |
    !contains(github.event.head_commit.message, '[skip ci]') &&
    !startsWith(github.event.head_commit.message, 'docs:')
```

## Getting Help

1. **Check workflow logs**: Most detailed information is in the logs
2. **GitHub Actions Status**: https://www.githubstatus.com/
3. **GitHub Actions Community**: https://github.community/c/code-to-cloud/github-actions/
4. **Stack Overflow**: Tag questions with `github-actions`

## Quick Reference: Exit Codes

- `0`: Success
- `1`: General error
- `2`: Misuse of shell command
- `126`: Command cannot execute
- `127`: Command not found
- `128+n`: Fatal error signal "n"
- `130`: Script terminated by Ctrl+C
- `255`: Exit status out of range
