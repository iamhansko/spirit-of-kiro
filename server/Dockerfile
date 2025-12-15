FROM oven/bun:1.2.15

WORKDIR /app

# Install curl for healthcheck
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy package.json for better layer caching
COPY package.json ./

# Install dependencies
RUN bun install

# Copy the rest of the server files
COPY . .

# Create necessary directories
RUN mkdir -p /app/server/iac

# Expose port 8080
EXPOSE 8080

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080 || exit 1

# Switch to non-root user
USER bun

# Set the command to run the server
CMD ["bun","--watch", "server.ts"]