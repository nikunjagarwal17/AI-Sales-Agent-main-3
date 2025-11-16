# Use Python 3.11 slim image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies for audio processing and build tools
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    make \
    portaudio19-dev \
    python3-dev \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Expose port
EXPOSE 8000

# Set environment variables
ENV STREAMLIT_SERVER_PORT=8000
ENV STREAMLIT_SERVER_ADDRESS=0.0.0.0
ENV STREAMLIT_SERVER_HEADLESS=true

# Create startup script that prepares vector database before running app
RUN echo '#!/bin/bash\n\
echo "Starting AI Sales Agent..."\n\
echo "Preparing vector database..."\n\
python create_catalog.py\n\
echo "Vector database ready. Starting Streamlit app..."\n\
streamlit run app.py --server.port=8000 --server.address=0.0.0.0' > /app/docker-entrypoint.sh && \
    chmod +x /app/docker-entrypoint.sh

# Run the startup script
CMD ["/app/docker-entrypoint.sh"]
