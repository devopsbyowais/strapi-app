FROM node:18-slim

# Avoid interactive prompts
ENV CI=true

# Set working directory
WORKDIR /app

# Install system deps
RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*

# Copy only lockfiles & manifests first for layer caching
COPY package.json yarn.lock ./

# Run yarn with network timeout and retry settings
RUN yarn install --network-timeout 600000 || yarn install --network-timeout 600000

# Copy all remaining files
COPY . .

# Build the project
RUN yarn build

# Expose Strapi default port
EXPOSE 1337

# Start the app
CMD ["yarn", "start"]
