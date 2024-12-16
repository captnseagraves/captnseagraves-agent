# Use Node 22 as base image
FROM node:22

# Create and set working directory
WORKDIR /app

# Copy package files
COPY package.json ./
COPY pnpm-lock.yaml ./
COPY characters/dinewell.character.json ./characters/
COPY src ./src

# Install pnpm globally and install dependencies
RUN npm install -g pnpm && \
    pnpm install

# Copy the rest of the application
COPY . .

# Start the application
CMD ["pnpm", "start", "--characters=characters/dinewell.character.json"]