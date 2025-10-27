#!/bin/bash

# Set the OpenAI API key as per ai_bench.md
export OPENAI_API_KEY=sk-IrR7Bwxtin0haWagUnPrBgq5PurnUz86

# Check if model name and folder name are provided as arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <model_name_of_the_llm> <folder_name>"
    exit 1
fi

MODEL_NAME=$1
RESULT_DIR=$2
mkdir -p "$RESULT_DIR"

# Define scenarios based on the table in ai_bench.md
# Input lengths and output lengths arrays
INPUTS=(128 512 2048 4096 8192)
OUTPUTS=(64 64 64 64 64)

# Loop through each scenario
for i in "${!INPUTS[@]}"; do
    INPUT_LEN=${INPUTS[$i]}
    OUTPUT_LEN=${OUTPUTS[$i]}

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
done

# Tar.gz the result directory at the end
tar -czf "${RESULT_DIR}.tar.gz" "$RESULT_DIR"

echo "Benchmark completed. Results archived in ${RESULT_DIR}.tar.gz"
