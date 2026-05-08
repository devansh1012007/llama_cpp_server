#!/bin/bash


MODE=$1

if [ "$MODE" = "reasoning" ]; then
    MODEL_PATH="/models/${ACTIVE_MODEL_FILENAME}"
    PORT=8080

    EXTRA_ARGS="\
    --ctx-size ${CONTEXT_SIZE:-32768} \
    --threads ${THREADS:-6} \
    --gpu-layers ${GPU_LAYERS:-12} \
    -fa \
    --cache-type-k q4_0 \
    --cache-type-v q4_0 \
    --no-warmup"

elif [ "$MODE" = "embedding" ]; then
    MODEL_PATH="/models/${EMBEDDING_MODEL_FILENAME}"
    PORT=8081

    EXTRA_ARGS="\
    --ctx-size 8192 \
    --threads 4 \
    --gpu-layers 0 \
    --embedding \
    --no-warmup"

else
    echo "Invalid mode. Use 'reasoning' or 'embedding'"
    exit 1
fi

if [ ! -f "$MODEL_PATH" ]; then
    echo "ERROR: Model file $MODEL_PATH not found."
    exit 1
fi

echo "Starting llama-server in $MODE mode on port $PORT..."
echo "Using model: $MODEL_PATH"

exec llama-server \
    --host 0.0.0.0 \
    --port $PORT \
    --model "$MODEL_PATH" \
    --mlock \
    --no-mmap \
    $EXTRA_ARGS