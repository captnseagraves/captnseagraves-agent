FROM node:23

WORKDIR /app

COPY . .

RUN apt-get update && \
    apt-get install -y \
    python3 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN npm install

ENV NODE_OPTIONS="--max-old-space-size=4096"

EXPOSE 3000

CMD ["npm", "start", "--characters=characters/dinewell.character.json"]