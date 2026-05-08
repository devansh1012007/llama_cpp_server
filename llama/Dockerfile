FROM ubuntu:24.04

# Prevent interactive prompts during apt install
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies.
# spirv-headers provides the correct spirv.hpp that llama.cpp's Vulkan backend
# needs (spv:: namespace with OpCodeMask, WordCountShift, etc.).
# glslang-dev ships glslangValidator which is required to compile GLSL shaders.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    clang \
    cmake \
    git \
    wget \
    curl \
    ca-certificates \
    vulkan-tools \
    libvulkan-dev \
    libvulkan1 \
    mesa-vulkan-drivers \
    glslang-tools \
    glslang-dev \
    glslc \
    spirv-headers \
    spirv-tools \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Pin to a stable tagged release to avoid bleeding-edge breakage.
# Update LLAMA_TAG to upgrade; check https://github.com/ggerganov/llama.cpp/releases
ARG LLAMA_TAG=b9055
RUN git clone --depth 1 --branch ${LLAMA_TAG} \
    https://github.com/ggerganov/llama.cpp.git .

# Build with Vulkan support.
# Use clang to avoid cc1plus memory exhaustion during shader compilation.
RUN mkdir build && cd build && \
    cmake .. \
        -DGGML_VULKAN=1 \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DCMAKE_BUILD_TYPE=Release && \
    cmake --build . --config Release -j 1

# Move the built binary to a global bin path
RUN cp build/bin/llama-server /usr/local/bin/

WORKDIR /models
