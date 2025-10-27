# Pipeline Learning Exercises

This document contains hands-on exercises to help you master CI/CD pipelines.

## 🎯 Exercise 1: Your First Pipeline Modification

**Objective**: Get comfortable editing workflows

**Task**: Modify `01-basic-ci.yml` to add a new step that prints "Hello Pipeline!"

**Steps**:
1. Open `.github/workflows/01-basic-ci.yml`
2. Add a new step after the checkout step:
   ```yaml
   - name: Say Hello
     run: echo "Hello Pipeline!"
   ```
3. Commit and push your changes
4. Go to the Actions tab and watch your workflow run

**Success Criteria**: Your workflow runs successfully and you can see "Hello Pipeline!" in the logs

---

## 🎯 Exercise 2: Add a New Function

**Objective**: Practice the full development cycle with CI

**Task**: Add a new math function to the calculator app

**Steps**:
1. Open `app.py`
2. Add a new function (e.g., `power(a, b)` for exponentiation)
3. Open `test_app.py`
4. Add tests for your new function
5. Update the `main()` function to demonstrate your new function
6. Commit and push
7. Watch the CI pipeline run

**Success Criteria**: 
- All tests pass
- Linter passes
- Your new function works correctly

---

## 🎯 Exercise 3: Matrix Build Configuration

**Objective**: Learn to test across multiple environments

**Task**: Add Windows testing to the matrix build

**Steps**:
1. Open `.github/workflows/02-advanced-ci.yml`
2. Modify the matrix to include OS:
   ```yaml
   strategy:
     matrix:
       python-version: ['3.9', '3.11']
       os: [ubuntu-latest, windows-latest]
   ```
3. Update the job name to include OS
4. Update the runs-on to use the matrix variable
5. Commit and watch the pipeline run on multiple OS

**Success Criteria**: Pipeline runs on both Ubuntu and Windows

---

## 🎯 Exercise 4: Working with Artifacts

**Objective**: Learn to create and use build artifacts

**Task**: Create a build artifact and verify it in another job

**Steps**:
1. Create a new workflow file `05-artifact-practice.yml`
2. Create a job that generates a simple text file
3. Upload it as an artifact
4. Create a second job that downloads and displays the artifact
5. Use job dependencies to ensure proper order

**Example**:
```yaml
name: Artifact Practice

on: [push]

jobs:
  create:
    runs-on: ubuntu-latest
    steps:
      - name: Create file
        run: echo "Build timestamp $(date)" > build-info.txt
      
      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          name: build-info
          path: build-info.txt
  
  use:
    needs: create
    runs-on: ubuntu-latest
    steps:
      - name: Download artifact
        uses: actions/download-artifact@v3
        with:
          name: build-info
      
      - name: Display content
        run: cat build-info.txt
```

**Success Criteria**: Both jobs complete and artifact is successfully passed

---

## 🎯 Exercise 5: Implement Caching

**Objective**: Speed up your pipelines with caching

**Task**: Add pip caching to the basic CI workflow

**Steps**:
1. Open `.github/workflows/01-basic-ci.yml`
2. Add a cache step before installing dependencies:
   ```yaml
   - name: Cache pip packages
     uses: actions/cache@v3
     with:
       path: ~/.cache/pip
       key: ${{ runner.os }}-pip-${{ hashFiles('requirements.txt') }}
       restore-keys: |
         ${{ runner.os }}-pip-
   ```
3. Run the workflow twice and compare execution times

**Success Criteria**: Second run shows "Cache restored" and is faster

---

## 🎯 Exercise 6: Environment Deployments

**Objective**: Learn about deployment environments

**Task**: Create a staging environment deployment

**Steps**:
1. Go to your repository Settings > Environments
2. Create a new environment called "staging"
3. Optionally add environment protection rules
4. Trigger the multi-stage pipeline with manual workflow dispatch
5. Watch the deployment job run

**Success Criteria**: Deployment job runs with environment shown

---

## 🎯 Exercise 7: Conditional Execution

**Objective**: Control when jobs and steps run

**Task**: Create a workflow that only runs on specific paths

**Steps**:
1. Create a new workflow `06-conditional.yml`
2. Set it to only trigger when Python files change:
   ```yaml
   on:
     push:
       paths:
         - '**.py'
   ```
3. Add a job that only runs on main branch:
   ```yaml
   jobs:
     main-only:
       if: github.ref == 'refs/heads/main'
       runs-on: ubuntu-latest
       steps:
         - run: echo "Running on main"
   ```
4. Test by pushing changes to different files and branches

**Success Criteria**: Workflow only runs when conditions are met

---

## 🎯 Exercise 8: Scheduled Workflows

**Objective**: Learn to run workflows on a schedule

**Task**: Create a nightly test run

**Steps**:
1. Create `07-scheduled.yml`
2. Add a cron schedule:
   ```yaml
   on:
     schedule:
       - cron: '0 2 * * *'  # Runs at 2 AM UTC daily
   ```
3. Add a simple test job

**Note**: Scheduled workflows only run on the default branch

**Success Criteria**: Workflow is configured (you don't need to wait for it to run)

---

## 🎯 Exercise 9: Secret Management

**Objective**: Learn to use secrets securely

**Task**: Add a secret and use it in a workflow

**Steps**:
1. Go to Settings > Secrets and variables > Actions
2. Add a new secret (e.g., `API_KEY` with any value)
3. Create a workflow that uses the secret:
   ```yaml
   - name: Use secret
     env:
       MY_SECRET: ${{ secrets.API_KEY }}
     run: |
       if [ -z "$MY_SECRET" ]; then
         echo "Secret not set"
         exit 1
       else
         echo "Secret is set (length: ${#MY_SECRET})"
       fi
   ```

**Success Criteria**: Workflow runs and confirms secret is set (but doesn't print it)

---

## 🎯 Exercise 10: Docker Integration

**Objective**: Build and test with Docker

**Task**: Run your tests inside a Docker container

**Steps**:
1. Ensure you have `Dockerfile` in your repo
2. Run the Docker workflow
3. Modify the Dockerfile to use a different Python version
4. Build locally: `docker build -t calculator .`
5. Run locally: `docker run calculator`

**Success Criteria**: Docker workflow passes and you can run locally

---

## 🎯 Exercise 11: Fail Fast Strategy

**Objective**: Control matrix build behavior

**Task**: Configure matrix to continue even if one job fails

**Steps**:
1. Open `.github/workflows/02-advanced-ci.yml`
2. Add to the strategy section:
   ```yaml
   strategy:
     fail-fast: false
     matrix:
       # ... your matrix
   ```
3. Intentionally break one matrix combination
4. Watch other combinations continue running

**Success Criteria**: Other matrix jobs continue when one fails

---

## 🎯 Exercise 12: Composite Actions

**Objective**: Reuse common steps

**Task**: Create a composite action for setup

**Steps**:
1. Create `.github/actions/setup-python-env/action.yml`:
   ```yaml
   name: 'Setup Python Environment'
   description: 'Sets up Python and installs dependencies'
   runs:
     using: 'composite'
     steps:
       - name: Setup Python
         uses: actions/setup-python@v4
         with:
           python-version: '3.11'
       
       - name: Install dependencies
         shell: bash
         run: |
           python -m pip install --upgrade pip
           pip install -r requirements.txt
   ```

2. Use it in a workflow:
   ```yaml
   - uses: ./.github/actions/setup-python-env
   ```

**Success Criteria**: Workflow uses your composite action successfully

---

## 🎯 Exercise 13: Status Badges

**Objective**: Add build status to your README

**Task**: Add a status badge for your workflows

**Steps**:
1. Get the badge URL: `https://github.com/{owner}/{repo}/workflows/{workflow-name}/badge.svg`
2. Add to README:
   ```markdown
   ![CI](https://github.com/diogoferreira1810/development/workflows/Basic%20CI%20Pipeline/badge.svg)
   ```

**Success Criteria**: Badge shows in README and reflects pipeline status

---

## 🎯 Exercise 14: Manual Workflow Inputs

**Objective**: Create interactive workflows

**Task**: Create a workflow with user inputs

**Steps**:
1. Create `08-manual-workflow.yml`:
   ```yaml
   on:
     workflow_dispatch:
       inputs:
         name:
           description: 'Your name'
           required: true
         greeting:
           description: 'Greeting type'
           required: true
           type: choice
           options:
             - Hello
             - Hi
             - Howdy
   
   jobs:
     greet:
       runs-on: ubuntu-latest
       steps:
         - name: Greet user
           run: echo "${{ inputs.greeting }}, ${{ inputs.name }}!"
   ```

2. Go to Actions tab and run manually with inputs

**Success Criteria**: Workflow runs with your chosen inputs

---

## 🎯 Exercise 15: Custom Filters

**Objective**: Filter when workflows run

**Task**: Create a workflow that skips CI for docs

**Steps**:
1. Add to workflow:
   ```yaml
   jobs:
     check-skip:
       runs-on: ubuntu-latest
       outputs:
         should-skip: ${{ steps.skip-check.outputs.should-skip }}
       steps:
         - id: skip-check
           run: |
             if [[ "${{ github.event.head_commit.message }}" == *"[skip ci]"* ]]; then
               echo "should-skip=true" >> $GITHUB_OUTPUT
             else
               echo "should-skip=false" >> $GITHUB_OUTPUT
             fi
     
     test:
       needs: check-skip
       if: needs.check-skip.outputs.should-skip != 'true'
       runs-on: ubuntu-latest
       steps:
         - run: echo "Running tests"
   ```

**Success Criteria**: Tests skip when commit message contains `[skip ci]`

---

## 🏆 Advanced Challenges

### Challenge 1: Full CD Pipeline
Create a complete deployment pipeline with:
- Build and test stages
- Security scanning
- Deploy to staging (automatic)
- Deploy to production (manual approval)
- Rollback capability

### Challenge 2: Multi-Language Pipeline
Add a Node.js component to the repo and create a pipeline that:
- Tests both Python and Node.js code
- Creates separate artifacts for each
- Runs integration tests

### Challenge 3: Performance Monitoring
Create a workflow that:
- Measures test execution time
- Compares with previous runs
- Fails if performance degrades significantly

### Challenge 4: Self-Updating Pipeline
Create a workflow that:
- Checks for action updates
- Creates a PR to update them
- Includes release notes

---

## 📊 Progress Tracking

Mark off exercises as you complete them:

- [ ] Exercise 1: First Pipeline Modification
- [ ] Exercise 2: Add a New Function
- [ ] Exercise 3: Matrix Build Configuration
- [ ] Exercise 4: Working with Artifacts
- [ ] Exercise 5: Implement Caching
- [ ] Exercise 6: Environment Deployments
- [ ] Exercise 7: Conditional Execution
- [ ] Exercise 8: Scheduled Workflows
- [ ] Exercise 9: Secret Management
- [ ] Exercise 10: Docker Integration
- [ ] Exercise 11: Fail Fast Strategy
- [ ] Exercise 12: Composite Actions
- [ ] Exercise 13: Status Badges
- [ ] Exercise 14: Manual Workflow Inputs
- [ ] Exercise 15: Custom Filters

### Advanced
- [ ] Challenge 1: Full CD Pipeline
- [ ] Challenge 2: Multi-Language Pipeline
- [ ] Challenge 3: Performance Monitoring
- [ ] Challenge 4: Self-Updating Pipeline

---

## 💡 Tips

1. **Always check the logs**: Most learning happens by reading what the pipeline does
2. **Break things**: Intentionally cause failures to understand error messages
3. **Experiment**: Try different configurations and see what happens
4. **Read docs**: GitHub Actions documentation is excellent
5. **Ask questions**: Use issues in this repo to document what you learn

Happy learning! 🚀
