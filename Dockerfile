# Build stage
FROM node:23 AS builder

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm
RUN npm install -g pnpm@8.6.12

# Copy package files
COPY package.json pnpm-lock.yaml* ./

# Set environment variables to skip browser downloads
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV NODE_OPTIONS="--max-old-space-size=4096"

# Install dependencies
RUN pnpm install --frozen-lockfile --prod

# Copy source
COPY . .

# Production stage
FROM node:23-slim

WORKDIR /app

# Copy built node modules and source
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app ./

# Set production environment
ENV NODE_ENV=production
ENV NODE_OPTIONS="--max-old-space-size=4096"

# Expose port
EXPOSE 3000

# Start command
CMD ["npm", "start", "--characters=characters/dinewell.character.json"]