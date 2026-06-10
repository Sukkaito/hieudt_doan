FROM runpod/pytorch:1.0.3-cu1281-torch280-ubuntu2404

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# System packages inferred from the source file:
# - zstd
# - curl (needed by Ollama install script)
# - python3/pip for running the API code
RUN apt-get update && apt-get install -y --no-install-recommends \
    zstd \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Ollama exactly as in the source notebook/script
RUN curl -fsSL https://ollama.com/install.sh | sh

# Python packages deduplicated from the source file only
RUN pip install --upgrade pip && \
    pip install \
    ultralytics \
    fastapi \
    uvicorn \
    pyngrok \
    nest_asyncio \
    opencv-python-headless \
    requests \
    fastdtw \
    scipy \
    google-generativeai \
    google-genai

RUN python3 -c "import cv2; print('cv2 ok')"

RUN python3 -c "from ultralytics import YOLO; YOLO('yolov8n-pose.pt')"

COPY hieudt_doan.py /app/hieudt_doan.py

EXPOSE 8000

# Notes:
# - The provided Python file contains Jupyter/Colab shell-magics (lines starting with '!').
# - Those are not valid in regular Python execution. Keep shell as default command.
CMD ["bash"]
