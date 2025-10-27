# Pipeline Training Repository

Welcome to your pipeline training repository! This repo is designed to help you learn and practice CI/CD pipeline concepts using GitHub Actions.

## 📚 What You'll Learn

- Basic CI/CD pipeline concepts
- GitHub Actions workflows
- Multi-stage pipelines
- Matrix builds (testing across multiple versions)
- Caching strategies
- Artifact management
- Environment deployments
- Docker integration
- Security scanning
- Code quality checks

## 🚀 Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/diogoferreira1810/development.git
   cd development
   ```

2. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Run the application**
   ```bash
   python app.py
   ```

4. **Run tests**
   ```bash
   pytest test_app.py -v
   ```

## 📁 Repository Structure

```
.
├── .github/
│   └── workflows/           # GitHub Actions pipeline definitions
│       ├── 01-basic-ci.yml              # Basic CI pipeline
│       ├── 02-advanced-ci.yml           # Advanced CI with coverage
│       ├── 03-multi-stage-pipeline.yml  # Multi-stage deployment pipeline
│       └── 04-docker-pipeline.yml       # Docker build pipeline
├── app.py                   # Sample Python application
├── test_app.py             # Unit tests
├── requirements.txt        # Python dependencies
├── Dockerfile              # Docker configuration
└── README.md              # This file
```

## 🔄 Pipeline Overview

### 1. Basic CI Pipeline (`01-basic-ci.yml`)
**Purpose:** Introduction to CI/CD basics

**What it does:**
- Checks out code
- Sets up Python environment
- Installs dependencies
- Runs linter (flake8)
- Runs unit tests
- Executes the application

**Triggers:** Push and Pull Requests to `main` and `develop` branches

**Key Concepts:**
- Workflow triggers (`on`)
- Jobs and steps
- Using actions (`actions/checkout`, `actions/setup-python`)
- Running commands

### 2. Advanced CI Pipeline (`02-advanced-ci.yml`)
**Purpose:** Learn advanced CI features

**What it does:**
- Tests across multiple Python versions (3.9, 3.10, 3.11, 3.12)
- Generates code coverage reports
- Uploads artifacts (coverage reports)
- Performs code quality checks with Black
- Uses caching to speed up builds

**Key Concepts:**
- Matrix builds (`strategy.matrix`)
- Dependency caching
- Artifact uploads
- Code coverage
- Parallel job execution

### 3. Multi-Stage Pipeline (`03-multi-stage-pipeline.yml`)
**Purpose:** Learn about complex deployment pipelines

**What it does:**
- Build stage: Creates deployable artifacts
- Test stage: Runs comprehensive tests
- Security scan: Checks for vulnerabilities
- Staging deployment: Deploys to staging environment
- Production deployment: Deploys to production (manual trigger)

**Key Concepts:**
- Job dependencies (`needs`)
- Environment variables
- Conditional execution (`if`)
- Manual workflows (`workflow_dispatch`)
- Environment deployments
- Artifact passing between jobs

### 4. Docker Pipeline (`04-docker-pipeline.yml`)
**Purpose:** Learn container-based workflows

**What it does:**
- Builds Docker images
- Uses Docker layer caching
- Tests containerized application

**Key Concepts:**
- Docker Buildx
- Container builds
- Docker caching strategies
- Running containers in CI

## 🎯 Learning Exercises

### Beginner Level
1. **Modify the Basic CI Pipeline**
   - Add a new step to check Python version
   - Add a step to display installed packages
   - Try triggering the workflow on different branches

2. **Update the Application**
   - Add a new function to `app.py` (e.g., modulo, power)
   - Write tests for your new function
   - Watch the pipeline run automatically

3. **Experiment with Triggers**
   - Modify when pipelines run
   - Try schedule triggers (cron)
   - Add path filters

### Intermediate Level
1. **Work with Matrix Builds**
   - Add more Python versions to test
   - Add a matrix dimension for different OS (ubuntu, windows, macos)
   - Exclude specific combinations

2. **Implement Caching**
   - Add caching to the basic pipeline
   - Experiment with cache keys
   - Observe build time improvements

3. **Use Artifacts**
   - Generate a build artifact (e.g., compiled files)
   - Pass artifacts between jobs
   - Download and verify artifacts

4. **Add Code Quality Gates**
   - Set coverage thresholds
   - Fail pipeline if coverage drops
   - Add more linters (pylint, mypy)

### Advanced Level
1. **Create a Complete CD Pipeline**
   - Deploy to multiple environments
   - Add manual approval steps
   - Implement blue-green deployment strategy
   - Add rollback capabilities

2. **Implement Security Scanning**
   - Add SAST (Static Application Security Testing)
   - Add dependency vulnerability scanning
   - Implement secret scanning
   - Add container image scanning

3. **Optimize Pipeline Performance**
   - Implement advanced caching strategies
   - Parallelize independent jobs
   - Use matrix builds effectively
   - Minimize artifact sizes

4. **Create Reusable Workflows**
   - Extract common steps to composite actions
   - Create reusable workflows
   - Build custom actions

## 🛠️ Common Pipeline Commands

### Local Testing
```bash
# Install dependencies
pip install -r requirements.txt

# Run tests
pytest test_app.py -v

# Run with coverage
pytest test_app.py --cov=app --cov-report=html

# Lint code
flake8 app.py test_app.py --max-line-length=100

# Format code
black app.py test_app.py

# Security scan
bandit -r app.py
```

### Docker Commands
```bash
# Build image
docker build -t calculator-app .

# Run container
docker run calculator-app

# Run tests in container
docker run calculator-app pytest test_app.py -v
```

## 📖 Pipeline Concepts Explained

### What is CI/CD?
- **Continuous Integration (CI)**: Automatically building and testing code changes
- **Continuous Deployment (CD)**: Automatically deploying code to production
- **Continuous Delivery (CD)**: Automatically preparing code for deployment (manual approval before production)

### Key Pipeline Components

**1. Triggers**: Events that start a pipeline
- Push to branches
- Pull requests
- Scheduled (cron)
- Manual (workflow_dispatch)
- External webhooks

**2. Jobs**: Independent units of work that run in parallel (unless dependencies exist)

**3. Steps**: Sequential tasks within a job

**4. Runners**: Machines that execute pipeline jobs
- GitHub-hosted (ubuntu, windows, macos)
- Self-hosted

**5. Actions**: Reusable units of code
- Marketplace actions (e.g., `actions/checkout`)
- Custom actions

**6. Artifacts**: Files produced by pipeline jobs
- Build outputs
- Test reports
- Logs

**7. Environments**: Deployment targets
- Development
- Staging
- Production

### Best Practices

1. **Keep pipelines fast**
   - Use caching
   - Parallelize independent jobs
   - Only run necessary steps

2. **Make pipelines reliable**
   - Pin action versions
   - Use specific Docker image tags
   - Handle failures gracefully

3. **Security first**
   - Never commit secrets
   - Use GitHub Secrets for sensitive data
   - Scan for vulnerabilities
   - Minimize permissions

4. **Maintainable pipelines**
   - Use clear naming
   - Add comments
   - Keep jobs focused
   - Reuse common steps

## 🔍 Monitoring Your Pipelines

### GitHub Actions Interface
1. Go to the "Actions" tab in your repository
2. View workflow runs and their status
3. Click on a run to see job details
4. View logs for each step
5. Download artifacts

### Understanding Pipeline Status
- ✅ **Success**: All steps completed successfully
- ❌ **Failure**: One or more steps failed
- 🟡 **In Progress**: Pipeline is currently running
- ⚫ **Cancelled**: Pipeline was manually cancelled
- ⊘ **Skipped**: Job was skipped due to conditions

## 🎓 Next Steps

1. **Explore the workflows**: Open each workflow file and read the comments
2. **Make changes**: Modify the code and watch pipelines run
3. **Break things**: Intentionally cause failures to see how pipelines behave
4. **Add features**: Implement your own pipeline stages
5. **Optimize**: Improve pipeline speed and reliability
6. **Share**: Document what you learn

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)
- [Workflow Syntax Reference](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
- [CI/CD Best Practices](https://docs.github.com/en/actions/guides)

## 🤝 Contributing

This is your training repository! Feel free to:
- Add more pipeline examples
- Improve existing workflows
- Add documentation
- Create issues for learning questions
- Share your learnings

## 📝 License

This is a training repository - use it however you like to learn!

---

**Happy Pipeline Building! 🚀**