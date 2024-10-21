# Stage 1: Build the NestJS app
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Install dependencies
# yarn.lock
COPY package.json  ./
RUN yarn install --frozen-lockfile

# Copy the rest of the application code
COPY . .

# Build the NestJS app
RUN yarn build

# Stage 2: Production image
FROM node:18-alpine AS production

# Set environment to production
ENV NODE_ENV=production

# Set working directory
WORKDIR /app

# Copy built files from the builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Expose the port on which the NestJS app will run
EXPOSE 3000

# Start the NestJS app
CMD ["node", "dist/main"]

