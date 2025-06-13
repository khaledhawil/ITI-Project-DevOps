FROM node:16-alpine

WORKDIR /app

COPY package*.json ./

# Install all dependencies
RUN npm install

COPY . .

# Set environment variables to disable strict CI checks and source maps
ENV CI=false
ENV GENERATE_SOURCEMAP=false
ENV NODE_OPTIONS=--openssl-legacy-provider

EXPOSE 3000
# Use react-scripts start normally
CMD ["npm", "start"]