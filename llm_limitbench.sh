#!/bin/bash

# Set the OpenAI API key as per ai_bench.md
export OPENAI_API_KEY=sk-IrR7Bwxtin0haWagUnPrBgq5PurnUz86

# Check if model name and folder name are provided as arguments
if [ $# -ne 4 ]; then
    echo "Usage: $0 <max-req> <context_length> <model_name_of_the_llm> <folder_name>"
    exit 1
fi

M_CONCU=$1
INPUT_LEN=$2
MODEL_NAME=$3
RESULT_DIR=$4
mkdir -p "$RESULT_DIR"

OUTPUT_LEN=64
echo "Running benchmark for: input_len=$INPUT_LEN, output_len=$OUTPUT_LEN, max_concurrency=$M_CONCU"

# Run vllm bench serve command as per example in ai_bench.md
vllm bench serve \
  --backend vllm \
  --model "$MODEL_NAME" \
  --endpoint /v1/completions \
  --dataset-name random \
  --random-input "$INPUT_LEN" \
  --random-output "$OUTPUT_LEN" \
  --max-concurrency "$M_CONCU" \
  --num-prompt 10 \
  --metric-percentiles 90 \
  --save-result \
  --result-dir "$RESULT_DIR" \
  --label "${INPUT_LEN}_${OUTPUT_LEN}"

# Tar.gz the result directory at the end
tar -czf "${RESULT_DIR}.tar.gz" "$RESULT_DIR"

echo "Benchmark completed. Results archived in ${RESULT_DIR}.tar.gz"
