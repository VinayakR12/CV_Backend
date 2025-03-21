# Use official Python 3.10 image
FROM python:3.10

# Set the working directory
WORKDIR /app

# Install OpenCV and system dependencies
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*  # Fix for libGL.so.1 error

# Copy the requirements file first (to leverage Docker caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the project files
COPY . .

# Expose port for Railway deployment
EXPOSE 5000

# Run the application with optimized Gunicorn settings
CMD ["gunicorn", "app:app", "--workers", "2", "--threads", "1", "--timeout", "600", "-k", "gevent", "--bind", "0.0.0.0:5000"]
