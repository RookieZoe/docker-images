# VibeVoice ASR Docker Image

[![Docker Pulls](https://img.shields.io/docker/pulls/rookiezoe/vibevoice-asr)](https://hub.docker.com/r/rookiezoe/vibevoice-asr)
[![Docker Image Size](https://img.shields.io/docker/image-size/rookiezoe/vibevoice-asr/latest)](https://hub.docker.com/r/rookiezoe/vibevoice-asr)

Pre-built Docker image for [VibeVoice ASR](https://github.com/microsoft/VibeVoice) with vLLM serving.

## Features

- 🚀 **Ready to use** - All dependencies pre-installed
- 🎵 **Long audio support** - Process up to 60+ minutes in a single request
- 📡 **OpenAI-compatible API** - Standard `/v1/chat/completions` endpoint
- 🔌 **Streaming support** - Real-time transcription output

## Quick Start

```bash
docker run --gpus all -p 8000:8000 \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  rookiezoe/vibevoice-asr:latest
```

## Docker Compose

See [compose.example.yml](./compose.example.yml) for a complete example.

```bash
# Copy and modify the example
cp compose.example.yml compose.yml

# Start the service
docker compose up -d

# View logs
docker compose logs -f
```

## Environment Variables

| Variable                 | Default                   | Description                           |
| ------------------------ | ------------------------- | ------------------------------------- |
| `MODEL_PATH`             | `microsoft/VibeVoice-ASR` | HuggingFace model ID or local path    |
| `PORT`                   | `8000`                    | Server port                           |
| `TENSOR_PARALLEL_SIZE`   | `1`                       | Number of GPUs for tensor parallelism |
| `GPU_MEMORY_UTILIZATION` | `0.8`                     | GPU memory utilization (0.0-1.0)      |
| `MAX_MODEL_LEN`          | `65536`                   | Maximum model context length          |
| `MAX_NUM_SEQS`           | `64`                      | Maximum concurrent sequences          |
| `SKIP_TOKENIZER`         | `false`                   | Skip tokenizer file generation        |

## API Usage

### Basic Request

```bash
curl -X POST http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "vibevoice-asr",
    "messages": [
      {
        "role": "user",
        "content": [
          {"type": "audio_url", "audio_url": {"url": "https://example.com/audio.wav"}},
          {"type": "text", "text": "This is a 10.00 seconds audio, please transcribe it with these keys: Start time, End time, Speaker ID, Content"}
        ]
      }
    ],
    "max_tokens": 4096,
    "temperature": 0.0
  }'
```

> **Note**: The duration in the text prompt should match the actual audio length. This helps the model generate accurate timestamps.

### With Base64 Audio (Python)

```python
import requests
import base64
import subprocess

def get_audio_duration(path: str) -> float:
    """Get audio duration using ffprobe."""
    cmd = [
        "ffprobe", "-v", "error",
        "-show_entries", "format=duration",
        "-of", "default=noprint_wrappers=1:nokey=1",
        path
    ]
    out = subprocess.check_output(cmd).decode().strip()
    return float(out)

# Load audio file
audio_path = "audio.wav"
duration = get_audio_duration(audio_path)

with open(audio_path, "rb") as f:
    audio_b64 = base64.b64encode(f.read()).decode()

# Build prompt with duration
prompt = f"This is a {duration:.2f} seconds audio, please transcribe it with these keys: Start time, End time, Speaker ID, Content"

response = requests.post(
    "http://localhost:8000/v1/chat/completions",
    json={
        "model": "vibevoice-asr",
        "messages": [
            {
                "role": "user",
                "content": [
                    {
                        "type": "audio_url",
                        "audio_url": {"url": f"data:audio/wav;base64,{audio_b64}"}
                    },
                    {
                        "type": "text",
                        "text": prompt
                    }
                ]
            }
        ],
        "max_tokens": 4096,
        "temperature": 0.0,
        "stream": True
    },
    stream=True
)

for line in response.iter_lines():
    if line:
        print(line.decode())
```

## Output Format

The model outputs JSON with transcription segments:

```json
[
  { "Start": 0.0, "End": 2.5, "Speaker": 0, "Content": "Hello, how are you?" },
  { "Start": 2.8, "End": 5.2, "Speaker": 1, "Content": "I'm doing well, thanks!" }
]
```

## Requirements

- NVIDIA GPU with CUDA support
- nvidia-container-toolkit installed
- At least 16GB GPU memory (24GB+ recommended)

## Build Locally

```bash
docker build -t vibevoice-asr:local \
  --build-arg VLLM_VERSION=latest \
  --build-arg VIBEVOICE_VERSION=main \
  .
```

## License

- This Docker image: MIT License
- VibeVoice: [MIT License](https://github.com/microsoft/VibeVoice/blob/main/LICENSE)
