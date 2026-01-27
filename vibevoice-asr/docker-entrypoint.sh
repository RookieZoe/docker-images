#!/bin/bash
# vim:sw=4:ts=4:et

set -e

if [ -z "${VIBEVOICE_ENTRYPOINT_QUIET_LOGS:-}" ]; then
    exec 3>&1
else
    exec 3>/dev/null
fi

# Run initialization scripts if present
if /usr/bin/find "/docker-entrypoint.d/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read -r; then
    echo >&3 "$0: /docker-entrypoint.d/ is not empty, will attempt to perform configuration"

    echo >&3 "$0: Looking for shell scripts in /docker-entrypoint.d/"
    find "/docker-entrypoint.d/" -follow -type f -print | sort -V | while read -r f; do
        case "$f" in
        *.sh)
            if [ -x "$f" ]; then
                echo >&3 "$0: Launching $f"
                "$f"
            else
                echo >&3 "$0: Ignoring $f, not executable"
            fi
            ;;
        *) echo >&3 "$0: Ignoring $f" ;;
        esac
    done

    echo >&3 "$0: Configuration complete; ready for start up"
else
    echo >&3 "$0: No files found in /docker-entrypoint.d/, skipping configuration"
fi

# Default values
MODEL_PATH="${MODEL_PATH:-microsoft/VibeVoice-ASR}"
PORT="${PORT:-8000}"
TENSOR_PARALLEL_SIZE="${TENSOR_PARALLEL_SIZE:-1}"
SKIP_TOKENIZER="${SKIP_TOKENIZER:-false}"
GPU_MEMORY_UTILIZATION="${GPU_MEMORY_UTILIZATION:-0.8}"
MAX_MODEL_LEN="${MAX_MODEL_LEN:-65536}"
MAX_NUM_SEQS="${MAX_NUM_SEQS:-64}"

echo >&3 "============================================================"
echo >&3 "  VibeVoice ASR vLLM Server"
echo >&3 "============================================================"
echo >&3 "  Model: ${MODEL_PATH}"
echo >&3 "  Port:  ${PORT}"
echo >&3 "  Tensor Parallel Size: ${TENSOR_PARALLEL_SIZE}"
echo >&3 "  GPU Memory Utilization: ${GPU_MEMORY_UTILIZATION}"
echo >&3 "============================================================"

# Download model if it's a HuggingFace ID (contains /)
if [[ "${MODEL_PATH}" == *"/"* ]]; then
    echo >&3 "$0: Downloading model from HuggingFace: ${MODEL_PATH}"
    MODEL_DIR=$(python3 -c "
from huggingface_hub import snapshot_download
import warnings
with warnings.catch_warnings():
    warnings.simplefilter('ignore')
    print(snapshot_download('${MODEL_PATH}'))
")
    echo >&3 "$0: Model downloaded to: ${MODEL_DIR}"
else
    MODEL_DIR="${MODEL_PATH}"
    echo >&3 "$0: Using local model path: ${MODEL_DIR}"
fi

# Generate tokenizer files if needed
if [[ "${SKIP_TOKENIZER}" != "true" ]]; then
    echo >&3 "$0: Generating tokenizer files..."
    python3 -m vllm_plugin.tools.generate_tokenizer_files --output "${MODEL_DIR}"
fi

echo >&3 "$0: Starting vLLM server..."

# Start vLLM server
exec vllm serve "${MODEL_DIR}" \
    --served-model-name vibevoice-asr \
    --trust-remote-code \
    --dtype bfloat16 \
    --max-num-seqs "${MAX_NUM_SEQS}" \
    --max-model-len "${MAX_MODEL_LEN}" \
    --max-num-batched-tokens 32768 \
    --gpu-memory-utilization "${GPU_MEMORY_UTILIZATION}" \
    --enforce-eager \
    --no-enable-prefix-caching \
    --enable-chunked-prefill \
    --chat-template-content-format openai \
    --tensor-parallel-size "${TENSOR_PARALLEL_SIZE}" \
    --allowed-local-media-path /app \
    --port "${PORT}"
