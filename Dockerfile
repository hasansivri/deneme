# Dockerfile for Node.js microservice
FROM node:14-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD [ "node", "app.js" ]
