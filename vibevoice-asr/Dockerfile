# VibeVoice ASR vLLM Server
#
# This image provides a ready-to-use vLLM server for VibeVoice ASR model.
# All dependencies are pre-installed, just mount your HuggingFace cache and run.
#
# Build Args:
#   VLLM_VERSION      - vLLM version tag (default: latest)
#   VIBEVOICE_VERSION - VibeVoice branch/tag (default: main)
#
# Environment Variables:
#   MODEL_PATH              - HuggingFace model ID or local path (default: microsoft/VibeVoice-ASR)
#   PORT                    - Server port (default: 8000)
#   TENSOR_PARALLEL_SIZE    - Number of GPUs for tensor parallelism (default: 1)
#   GPU_MEMORY_UTILIZATION  - GPU memory utilization (default: 0.8)
#   MAX_MODEL_LEN           - Maximum model context length (default: 65536)
#   MAX_NUM_SEQS            - Maximum number of sequences (default: 64)
#   SKIP_TOKENIZER          - Skip tokenizer generation (default: false)

ARG VLLM_VERSION=latest
FROM vllm/vllm-openai:v${VLLM_VERSION}

LABEL maintainer="Rookie_Zoe <i@rookiezoe.com>"
LABEL org.opencontainers.image.source="https://github.com/microsoft/VibeVoice"
LABEL org.opencontainers.image.description="VibeVoice ASR with vLLM serving"

ARG VIBEVOICE_VERSION=main
ENV VIBEVOICE_VERSION=${VIBEVOICE_VERSION}

# Avoid interactive prompts during apt install
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ffmpeg \
        libsndfile1 \
        git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Clone and install VibeVoice
WORKDIR /app

RUN set -ex \
    && git clone --depth 1 --branch ${VIBEVOICE_VERSION} https://github.com/microsoft/VibeVoice.git . \
    && pip install --no-cache-dir -e ".[vllm]" \
    && rm -rf .git

# Setup entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN set -ex \
    && mkdir -p /docker-entrypoint.d \
    && chmod +x /docker-entrypoint.sh

# Environment configuration
ENV VIBEVOICE_FFMPEG_MAX_CONCURRENCY=64
ENV PYTORCH_ALLOC_CONF=expandable_segments:True

EXPOSE 8000

ENTRYPOINT ["/docker-entrypoint.sh"]
