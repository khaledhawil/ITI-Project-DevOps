FROM node:16-alpine

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .
EXPOSE 5000
# start the server
CMD ["npm", "start"]