# 前端构建阶段
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# 生产运行阶段
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf.template

RUN /bin/sh -c 'export BACKEND_URL=${BACKEND_URL:-http://localhost:8000} && envsubst < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf'

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
