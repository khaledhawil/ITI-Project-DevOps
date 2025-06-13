#!/bin/sh

# Build script for React app with OpenSSL legacy provider support
# This script handles the OpenSSL digital envelope routines error

echo "Starting React build with OpenSSL legacy provider..."

# Try different approaches to build the React app
if command -v node >/dev/null 2>&1; then
    NODE_VERSION=$(node --version | cut -d'.' -f1 | sed 's/v//')
    echo "Node.js version: $NODE_VERSION"
    
    if [ "$NODE_VERSION" -ge 17 ]; then
        echo "Using OpenSSL legacy provider for Node.js $NODE_VERSION..."
        # For Node.js 17+ we need the legacy provider
        export NODE_OPTIONS="--openssl-legacy-provider"
        npm run build:safe 2>/dev/null || {
            echo "Legacy provider failed, trying direct approach..."
            unset NODE_OPTIONS
            node --openssl-legacy-provider ./node_modules/.bin/react-scripts build 2>/dev/null || {
                echo "Direct approach failed, trying CI=false..."
                CI=false node --openssl-legacy-provider ./node_modules/.bin/react-scripts build 2>/dev/null || {
                    echo "All OpenSSL approaches failed, trying standard build..."
                    CI=false npm run build:fallback
                }
            }
        }
    else
        echo "Using standard build for Node.js $NODE_VERSION..."
        CI=false npm run build:fallback
    fi
else
    echo "Node.js not found, trying standard npm build..."
    CI=false npm run build:fallback
fi

# Check if build was successful
if [ -d "build" ] && [ "$(ls -A build)" ]; then
    echo "✅ Build completed successfully!"
    ls -la build/
else
    echo "❌ Build failed - build directory is empty or missing"
    exit 1
fi
