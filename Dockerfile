FROM node:18-bookworm

# Установка CLIPS
RUN apt-get update && \
    apt-get install -y clips && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "server.js"]