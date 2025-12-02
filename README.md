# LLM Benchmark - Prerequisites for running vLLM

This repository contains scripts to benchmark an LLM using a vLLM server. Before running the bench scripts, ensure a vLLM server is running and accessible, and that authentication is configured via a Hugging Face token.

Prerequisites
- A running vLLM server with a loaded model. See the vLLM documentation for details on starting and configuring the server.
- Python 3.8+ and pip installed on your system.

Environment setup
- Expose a Hugging Face Hub token as an environment variable to authenticate when pulling private models. The following example uses the variable HF_TOKEN.
- export HF_TOKEN="your_hf_token_here"
- If you also use the Hugging Face Hub token from the legacy environment variable, you may set:
- export HUGGINGFACE_HUB_TOKEN="$HF_TOKEN"

Quick start running vLLM with GLM-AIR

`$ vllm serve --host 0.0.0.0 --port 8000 --model zai-org/GLM-4.5-Air-FP8 --dtype auto --enforce-eager --gpu-memory-utilization 0.95 --api-key sk-IrR7Bwxtin0haWagUnPrBgq5PurnUz86 --kv-cache-dtype fp8 --max-model-len 9152`

Documentation
- For detailed guidance on vLLM, consult the official docs:
https://vllm.ai/docs/

Troubleshooting
- If the server cannot be reached, verify the vLLM server is running and the endpoint matches what the bench scripts expect.
- If HF_TOKEN is rejected, re-export a valid token and retry.