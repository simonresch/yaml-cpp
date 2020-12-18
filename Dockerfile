FROM ubuntu:20.10

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && apt-get install -y --no-install-recommends \
    # git pull script dependencies
    ca-certificates \
    git \
    # yaml-cpp dependencies
    build-essential \
    cmake\
 && rm -rf /var/lib/apt/lists/*
