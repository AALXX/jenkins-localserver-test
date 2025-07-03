# Use Node LTS base image
FROM node:18-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy app source and build
COPY . .
RUN npm run build

# Run app in production environment
FROM node:18-alpine AS runner
WORKDIR /app

# Only copy necessary files
COPY --from=builder /app/.next .next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules

ENV NODE_ENV=production
EXPOSE 3000

CMD ["npm", "start"]
