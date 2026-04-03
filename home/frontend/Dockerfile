FROM node:25.9-alpine3.23 AS base
RUN npm install -g pnpm@10.33.0

FROM base AS deps
WORKDIR /app
COPY ./app/package.json ./
COPY ./app/pnpm-lock.yaml ./pnpm-lock.yaml
RUN pnpm install --frozen-lockfile

FROM deps AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY ./app .
RUN pnpm build


FROM node:25.9-alpine3.23
WORKDIR /app
COPY --from=build /app/.next/standalone ./
COPY --from=build /app/public ./public
COPY --from=build /app/.next/static ./.next/static
EXPOSE 3000
ENTRYPOINT [ "node" ]
CMD [ "/standalone/server.js" ]