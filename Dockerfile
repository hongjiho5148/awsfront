# 1. Build Stage
FROM node:18-alpine AS build
WORKDIR /app

# 빌드 시점에 외부(GitHub Actions)에서 넘겨줄 인자 선언
ARG REACT_APP_API_URL
# 리액트 빌드 프로세스가 인식할 수 있도록 환경 변수로 설정
ENV REACT_APP_API_URL=$REACT_APP_API_URL

COPY package.json ./
RUN npm install
COPY . ./

# 이 단계에서 위에서 설정한 ENV 값이 코드(App.js)에 심어집니다.
RUN npm run build

# 2. Production Stage (Nginx)
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]