FROM node:16-alpine

WORKDIR /app

COPY package*.json ./

# Install all dependencies
RUN npm install

COPY . .

# Set environment variables to disable strict CI checks and source maps
ENV CI=false
ENV GENERATE_SOURCEMAP=false

EXPOSE 3000

# Custom start script to handle NODE_OPTIONS
CMD ["sh", "-c", "NODE_OPTIONS=--openssl-legacy-provider npm start"]