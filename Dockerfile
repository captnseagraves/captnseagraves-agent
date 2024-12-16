# Use Node 22 as base image
FROM node:22-slim

# Create and set working directory
WORKDIR /app

# Copy package files
COPY package.json ./
COPY pnpm-lock.yaml ./
COPY characters/dinewell.character.json ./characters/

# Install pnpm globally and install dependencies with memory limits
ENV NODE_OPTIONS="--max-old-space-size=2048"
RUN npm install -g pnpm && \
    pnpm install --production --no-optional

# Copy only necessary files
COPY src ./src
COPY tsconfig.json ./

# Start the application
CMD ["pnpm", "start", "--characters=characters/dinewell.character.json"]