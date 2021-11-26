FROM node:14-alpine AS build
RUN apk add --no-cache make curl
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY package*.json yarn.lock ./
ENV NODE_ENV=production
RUN yarn install --frozen-lockfile --production=false
COPY . .
RUN yarn build-static -j8
RUN yarn build

FROM nginx:stable-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /usr/src/app/build /usr/share/nginx/html
RUN chmod -R 755 /usr/share/nginx/html

STOPSIGNAL SIGQUIT
