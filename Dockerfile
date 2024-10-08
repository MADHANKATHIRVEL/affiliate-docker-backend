# Stage 1: Install dependencies
FROM node:19-slim AS dependencies

WORKDIR /app

COPY package*.json ./
RUN npm install --production

# Stage 2: Create the final image
FROM node:19-slim

WORKDIR /app

COPY --from=dependencies /app/node_modules /app/node_modules
COPY . .

EXPOSE 3000

CMD ["node", "index.js"]


