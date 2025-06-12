FROM node:18-slim

# Avoid interactive prompts
ENV CI=true

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*

# Copy only lockfiles & manifests first for better caching
COPY package.json package-lock.json ./

# Install dependencies using npm
RUN npm ci

# Copy all project files
COPY . .

# Build the project
RUN npm run build

# Expose Strapi default port
EXPOSE 1337

# Start the app
CMD ["yarn", "start"]
