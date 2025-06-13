FROM node:16-alpine

WORKDIR /app

COPY package*.json ./

# Install all dependencies including devDependencies for nodemon
RUN npm ci

COPY . .
EXPOSE 5000
# start the server
CMD ["npm", "start"]