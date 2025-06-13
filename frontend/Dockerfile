FROM node:14-alpine

WORKDIR /app

COPY package*.json ./

# Install all dependencies
RUN npm install

COPY . .

# Set environment variables to disable strict CI checks and source maps
ENV CI=false
ENV GENERATE_SOURCEMAP=false

EXPOSE 3000

# Use production-ready nginx build - run with legacy OpenSSL directly
RUN node --openssl-legacy-provider node_modules/.bin/react-scripts build

# Use nginx to serve the built files
FROM nginx:alpine
COPY --from=0 /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]