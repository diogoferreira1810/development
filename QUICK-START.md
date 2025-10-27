# Quick Start Guide

Get started with pipeline training in 5 minutes!

## Prerequisites

- Git installed
- Python 3.9+ installed
- GitHub account
- Basic command line knowledge

## Step 1: Clone the Repository (30 seconds)

```bash
git clone https://github.com/diogoferreira1810/development.git
cd development
```

## Step 2: Set Up Local Environment (1 minute)

```bash
# Install Python dependencies
pip install -r requirements.txt

# Run the application
python app.py

# Run tests
pytest test_app.py -v
```

**Expected output:**
```
Calculator Demo
5 + 3 = 8
10 - 4 = 6
7 * 6 = 42
20 / 5 = 4.0
```

## Step 3: Explore Workflows (1 minute)

Look at the pipeline files:

```bash
# List all workflows
ls .github/workflows/

# View basic CI pipeline
cat .github/workflows/01-basic-ci.yml

# View advanced CI pipeline
cat .github/workflows/02-advanced-ci.yml
```

**What's included:**
- ✅ **01-basic-ci.yml**: Simple CI pipeline (build, test, lint)
- ✅ **02-advanced-ci.yml**: Advanced with matrix builds and coverage
- ✅ **03-multi-stage-pipeline.yml**: Multi-stage with deployments
- ✅ **04-docker-pipeline.yml**: Docker build pipeline

## Step 4: Make Your First Change (2 minutes)

Let's trigger a pipeline!

```bash
# Create a new branch
git checkout -b my-first-pipeline-test

# Make a simple change (add a comment to app.py)
echo "# My first change" >> app.py

# Commit and push
git add app.py
git commit -m "Test: trigger my first pipeline"
git push origin my-first-pipeline-test
```

## Step 5: Watch Your Pipeline Run (1 minute)

1. Go to your repository on GitHub
2. Click the **"Actions"** tab
3. You'll see your workflow running!
4. Click on the workflow run to see details
5. Click on jobs to see step-by-step execution

**What you'll see:**
- ✅ Checkout code
- ✅ Set up Python
- ✅ Install dependencies
- ✅ Run linter
- ✅ Run tests
- ✅ Run application

## What's Next?

### For Beginners
1. **Read the README**: Full documentation of all features
2. **Try Exercise 1**: Make a simple workflow modification (EXERCISES.md)
3. **Understand concepts**: Read PIPELINE-CONCEPTS.md

### For Intermediate Users
1. **Matrix Builds**: Explore multi-version testing
2. **Caching**: Speed up your pipelines
3. **Artifacts**: Work with build outputs
4. **Try Exercise 3-6**: Hands-on with advanced features

### For Advanced Users
1. **Multi-stage pipelines**: Build complex workflows
2. **Docker integration**: Containerize your applications
3. **Environments**: Set up deployment targets
4. **Try Challenges**: Advanced exercises

## Common Commands Reference

### Local Development
```bash
# Run application
python app.py

# Run tests
pytest test_app.py -v

# Run tests with coverage
pytest test_app.py --cov=app --cov-report=html

# Lint code
flake8 app.py test_app.py --max-line-length=100

# Format code
black app.py test_app.py
```

### Git Commands
```bash
# Create a branch
git checkout -b feature-name

# See changes
git status
git diff

# Commit changes
git add .
git commit -m "Description of changes"

# Push to GitHub
git push origin feature-name

# Pull latest changes
git pull origin main
```

### Docker Commands
```bash
# Build Docker image
docker build -t calculator-app .

# Run Docker container
docker run calculator-app

# Run tests in Docker
docker run calculator-app pytest test_app.py -v
```

## File Structure Overview

```
development/
├── .github/
│   └── workflows/              # All pipeline definitions
│       ├── 01-basic-ci.yml
│       ├── 02-advanced-ci.yml
│       ├── 03-multi-stage-pipeline.yml
│       └── 04-docker-pipeline.yml
├── app.py                      # Sample Python application
├── test_app.py                 # Unit tests
├── requirements.txt            # Python dependencies
├── Dockerfile                  # Docker configuration
├── README.md                   # Main documentation
├── QUICK-START.md             # This file
├── PIPELINE-CONCEPTS.md       # Pipeline concepts explained
├── EXERCISES.md               # Hands-on exercises
└── TROUBLESHOOTING.md         # Common issues and solutions
```

## Troubleshooting

### Pipeline not running?
- Check that you pushed to GitHub (not just committed locally)
- Verify you're on a branch that matches the workflow trigger
- Look in the Actions tab for any errors

### Tests failing locally?
```bash
# Reinstall dependencies
pip install -r requirements.txt --force-reinstall

# Check Python version (needs 3.9+)
python --version

# Run tests with verbose output
pytest test_app.py -v -s
```

### Can't push to GitHub?
```bash
# Make sure you're on your own branch
git branch

# If on main, create a new branch
git checkout -b my-branch-name

# Then push
git push origin my-branch-name
```

### Import errors?
```bash
# Make sure you're in the right directory
pwd
# Should show: .../development

# Install dependencies
pip install -r requirements.txt
```

## Learning Path

### Week 1: Basics
- [ ] Set up local environment
- [ ] Run your first pipeline
- [ ] Understand workflow structure
- [ ] Complete Exercise 1-2

### Week 2: Intermediate
- [ ] Work with matrix builds
- [ ] Implement caching
- [ ] Use artifacts
- [ ] Complete Exercise 3-6

### Week 3: Advanced
- [ ] Multi-stage pipelines
- [ ] Environment deployments
- [ ] Docker integration
- [ ] Complete Exercise 7-12

### Week 4: Mastery
- [ ] Create custom workflows
- [ ] Optimize pipeline performance
- [ ] Security best practices
- [ ] Complete advanced challenges

## Tips for Success

1. **Experiment Freely**: This is a training repo - break things!
2. **Read the Logs**: Most learning happens in the Action logs
3. **Start Simple**: Begin with basic-ci.yml before advanced topics
4. **Use the Docs**: All files are well-documented
5. **Track Progress**: Use the checklists in EXERCISES.md

## Get Help

- **Documentation Issues**: Check TROUBLESHOOTING.md
- **Pipeline Concepts**: Read PIPELINE-CONCEPTS.md
- **Hands-on Practice**: Follow EXERCISES.md
- **GitHub Docs**: https://docs.github.com/en/actions

## Your First Goal

**By the end of today, you should:**
- ✅ Have the repo cloned and working locally
- ✅ Have run at least one pipeline on GitHub
- ✅ Understand what a workflow, job, and step are
- ✅ Have made a change that triggered a pipeline

**Ready? Let's build pipelines! 🚀**

---

Need help? Create an issue in the repository or check the TROUBLESHOOTING.md file.
