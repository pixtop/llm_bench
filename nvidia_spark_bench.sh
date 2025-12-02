#!/bin/bash

# Set the OpenAI API key as per ai_bench.md
export OPENAI_API_KEY=sk-IrR7Bwxtin0haWagUnPrBgq5PurnUz86

INPUT_LEN=8192
MODEL_NAME=zai-org/GLM-4.5-Air-FP8
RESULT_DIR=spark_results
mkdir -p "$RESULT_DIR"

OUTPUT_LEN=64
# Loop through request rates 1 to 12
for RATE in {1..12}; do
    echo "Running benchmark for scenario $(($i+1)): input_len=$INPUT_LEN, output_len=$OUTPUT_LEN, request_rate=$RATE"

    # Run vllm bench serve command as per example in ai_bench.md
    vllm bench serve \
        --backend vllm \
        --model "$MODEL_NAME" \
        --endpoint /v1/completions \
        --dataset-name random \
        --random-input "$INPUT_LEN" \
        --random-output "$OUTPUT_LEN" \
        --request-rate "$RATE" \
        --num-prompt 100 \
        --metric-percentiles 90 \
        --save-result \
        --result-dir "$RESULT_DIR" \
        --label "${INPUT_LEN}_${OUTPUT_LEN}"
done

# Tar.gz the result directory at the end
tar -czf "${RESULT_DIR}.tar.gz" "$RESULT_DIR"

echo "Benchmark completed. Results archived in ${RESULT_DIR}.tar.gz"
