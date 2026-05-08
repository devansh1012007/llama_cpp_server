#!/bin/bash

# start-llama.sh - Dynamic entrypoint for llama-server
# Routes the start command based on whether we are starting the reasoning or embedding container.

MODE=$1

if [ "$MODE" = "reasoning" ]; then
    MODEL_PATH="/models/${ACTIVE_MODEL_FILENAME}"
    PORT=8080
    
    # Reasoning model optimizations:
    # 1. User specified context size
    # 2. q8_0 KV cache to halve memory
    # 3. Flash attention for speed and memory efficiency on long contexts
    #EXTRA_ARGS="--ctx-size ${CONTEXT_SIZE:-48000} --threads ${THREADS:-8} --gpu-layers ${GPU_LAYERS:-99} --flash-attn on --cache-type-k q8_0 --cache-type-v q8_0"
    EXTRA_ARGS="\
    --ctx-size ${CONTEXT_SIZE:-16000} \
    --threads ${THREADS:-12} \
    --gpu-layers ${GPU_LAYERS:-8} \
    --parallel 1 \
    --cache-type-k q4_0 \
    --cache-type-v q4_0 \
    --no-warmup"
elif [ "$MODE" = "embedding" ]; then
    MODEL_PATH="/models/${EMBEDDING_MODEL_FILENAME}"
    PORT=8081
    
    # Embedding model optimizations:
    # 1. Static 8k context size is standard for bge-small
    # 2. Enable --embedding flag for API compatibility
    #EXTRA_ARGS="--ctx-size 8192 --threads 4 --gpu-layers ${GPU_LAYERS:-99} --embedding"
    EXTRA_ARGS="\
    --ctx-size 512 \
    --threads 4 \
    --gpu-layers 12 \
    --embedding \
    --no-warmup"
else
    echo "Invalid mode. Use 'reasoning' or 'embedding'"
    exit 1
fi

if [ ! -f "$MODEL_PATH" ]; then
    echo "ERROR: Model file $MODEL_PATH not found."
    echo "Please download the .gguf file into the 'models' directory."
    exit 1
fi

echo "Starting llama-server in $MODE mode on port $PORT..."
echo "Using model: $MODEL_PATH"

exec llama-server \
    --host 0.0.0.0 \
    --port $PORT \
    --model "$MODEL_PATH" \
    --mlock \
    $EXTRA_ARGS
