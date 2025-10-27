# Use official Python runtime as base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py .
COPY test_app.py .

# Run tests during build (optional - can be skipped if tests already ran in CI)
# Uncomment the line below to run tests during Docker build:
# RUN pytest test_app.py -v

# Set the command to run the application
CMD ["python", "app.py"]
