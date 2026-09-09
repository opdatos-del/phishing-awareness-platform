# --- Build stage ---
FROM node:24-alpine AS build
RUN corepack enable && corepack prepare pnpm@latest --activate
WORKDIR /app

COPY package.json pnpm-lock.yaml* ./
RUN pnpm install --frozen-lockfile || pnpm install

COPY . .
RUN pnpm run build

# --- Runtime stage ---
FROM nginx:alpine

RUN apk add --no-cache gettext

COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/templates/default.conf.template

ENV BACKEND_URL=http://backend:8080
ENV BACKEND_HOST=backend
ENV PORT=80

EXPOSE 80

CMD ["/bin/sh", "-c", "until getent hosts ${BACKEND_HOST} >/dev/null 2>&1; do echo waiting for backend DNS; sleep 2; done; /docker-entrypoint.sh nginx -g 'daemon off;'"]
