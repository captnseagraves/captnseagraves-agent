# Build stage
FROM node:22-slim AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && \
    apt-get install -y \
    git \
    make \
    g++ \
    python3 \
    build-essential && \
    rm -rf /var/lib/apt/lists/*

# Copy only package files first
COPY package.json pnpm-lock.yaml ./

# Install pnpm and dependencies
ENV NODE_OPTIONS="--max-old-space-size=4096"
RUN npm install -g pnpm && \
    pnpm install --frozen-lockfile

# Copy source files
COPY . .

# Build the application if needed
RUN pnpm build

# Production stage
FROM node:22-slim

WORKDIR /app

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y \
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

# Copy built application from builder stage
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/characters ./characters
COPY --from=builder /app/package.json ./

# Set production environment
ENV NODE_ENV=production

# Start the application
CMD ["pnpm", "start", "--characters=characters/dinewell.character.json"]