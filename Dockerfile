# 1. build stage: based on Node.js to build and compile frontend
FROM node:16-alpine AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install -g cnpm --registry=https://registry.npm.taobao.org && npm install --arch=x64 --platform=linux sharp && cnpm install
COPY . .
RUN npm run deploy

# 2. base on Nginx to have only the compiled app
FROM nginx:1.23.1-alpine
RUN mkdir /app
COPY --from=build-stage /app/public /usr/share/nginx/html
# copy the nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf