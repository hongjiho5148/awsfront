# 1. Build Stage
FROM node:18-alpine AS build
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . ./
ARG REACT_APP_API_BASE_URL
ENV REACT_APP_API_BASE_URL=$REACT_APP_API_BASE_URL

RUN npm run build

# 2. Production Stage (Nginx)
FROM nginx:alpine
# 빌드된 정적 파일들을 Nginx 웹 루트로 복사
COPY --from=build /app/build /usr/share/nginx/html

# Nginx 기본 포트
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]