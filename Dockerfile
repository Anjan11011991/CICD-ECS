# Use the official Python image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Copy the rest of the application code
COPY app.py app.py

# Expose the port the app runs on
EXPOSE 8080

# Run the application
CMD ["python", "app.py"]
