FROM node:16-alpine

WORKDIR /app

COPY package*.json ./

# Install all dependencies
RUN npm ci

COPY . .

# Set environment variables to disable strict CI checks and source maps
ENV CI=false
ENV GENERATE_SOURCEMAP=false

EXPOSE 3000
# Use node directly to avoid NODE_OPTIONS restriction
CMD ["sh", "-c", "node --openssl-legacy-provider ./node_modules/.bin/react-scripts start"]