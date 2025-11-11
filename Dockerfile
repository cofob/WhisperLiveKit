FROM nvidia/cuda:12.9.1-cudnn-devel-ubuntu24.04

ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-venv \
        ffmpeg \
        git \
        build-essential \
        python3-dev \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 --disable-pip-version-check install --timeout=120 --retries=5 \
        --index-url https://download.pytorch.org/whl/cu129 \
        torch torchaudio

RUN pip install --break-system-packages 'git+https://github.com/NVIDIA/NeMo.git@main#egg=nemo_toolkit[asr]'
RUN pip install --break-system-packages --no-cache-dir whisperlivekit

EXPOSE 8000

ENTRYPOINT ["whisperlivekit-server", "--host", "0.0.0.0"]

CMD ["--model", "medium"]
