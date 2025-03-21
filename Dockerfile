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
    libgl1-mesa-glx \  # Fix for libGL.so.1 error
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file first (to leverage Docker caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the project files
COPY . .

# Expose port (important for Railway)
EXPOSE 5000

# Use Gunicorn to run the application
CMD ["gunicorn", "app:app", "--workers", "4", "--bind", "0.0.0.0:5000"]
