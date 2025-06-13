FROM node:16-alpine

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .
# expose the backend port 
EXPOSE 5000

CMD ["npm", "start"]