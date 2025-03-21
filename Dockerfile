FROM python:3.10

# Install OpenCV system dependencies
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy project files
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port (important for Railway)
EXPOSE 5000

# Use Gunicorn to run the application
CMD ["gunicorn", "app:app", "--workers", "4", "--bind", "0.0.0.0:5000"]
