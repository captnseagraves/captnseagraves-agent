# Use Node 22 as base image
FROM node:22-slim

# Create and set working directory
WORKDIR /app

# Install required system dependencies
RUN apt-get update && \
    apt-get install -y \
    git \
    make \
    g++ \
    python3 \
    build-essential \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 && \
    rm -rf /var/lib/apt/lists/*

# Copy package files
COPY package.json ./
COPY pnpm-lock.yaml ./
COPY characters/dinewell.character.json ./characters/

# Install pnpm globally and install dependencies with memory limits
ENV NODE_OPTIONS="--max-old-space-size=4096"
RUN npm install -g pnpm && \
    pnpm install

# Copy the rest of the application
COPY . .

# Start the application
CMD ["pnpm", "start", "--characters=characters/dinewell.character.json"]