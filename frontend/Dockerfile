FROM node:16-alpine

WORKDIR /app

COPY package*.json ./

RUN npm ci --only=production

COPY . .

# Set environment variables to disable strict CI  checks and source maps
ENV CI=false
ENV GENERATE_SOURCEMAP=false
## Build the React app
EXPOSE 3000
CMD ["npm", "start"]