#!/bin/bash

# scripts/download-models.sh - Helper to download required GGUF models

# Load model names from .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "ERROR: .env file not found!"
    exit 1
fi

MODEL_DIR="./models"
mkdir -p "$MODEL_DIR"

echo "Checking for models in $MODEL_DIR..."

# 1. Reasoning Model
REASONING_PATH="$MODEL_DIR/$ACTIVE_MODEL_FILENAME"
if [ ! -f "$REASONING_PATH" ]; then
    echo "Downloading Reasoning Model: $ACTIVE_MODEL_FILENAME..."
    # Note: Assuming Qwen2.5 since Qwen3 isn't out. 
    # Adjust URL if you have a specific link.
    URL="https://huggingface.co/bartowski/Qwen2.5-7B-Instruct-GGUF/resolve/main/Qwen2.5-7B-Instruct-Q4_K_M.gguf"
    curl -L "$URL" -o "$REASONING_PATH"
else
    echo "Reasoning model already exists."
fi

# 2. Embedding Model
EMBEDDING_PATH="$MODEL_DIR/$EMBEDDING_MODEL_FILENAME"
if [ ! -f "$EMBEDDING_PATH" ]; then
    echo "Downloading Embedding Model: $EMBEDDING_MODEL_FILENAME..."
    URL="https://huggingface.co/CompendiumLabs/bge-small-en-v1.5-gguf/resolve/main/bge-small-en-v1.5-q8_0.gguf"
    curl -L "$URL" -o "$EMBEDDING_PATH"
else
    echo "Embedding model already exists."
fi

echo "All models ready!"
