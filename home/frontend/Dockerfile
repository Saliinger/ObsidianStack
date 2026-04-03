FROM node:25.9-alpine3.23 AS base
RUN corepack && corepack prepare pnpm@10.33.0 --activate

FROM base AS deps
WORKDIR /app
COPY ./app/package.json ./
RUN pnpm install --frozen-lockfile

FROM deps AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY ./app ./
RUN pnpm build


FROM node:25.9-alpine3.23
WORKDIR /app
COPY --from=deps /app/.next/standalone ./
COPY --from=deps /app/.next/public ./public
COPY --from=deps /app/.next/static ./.next/static
EXPOSE 3000
ENTRYPOINT [ "node" ]
CMD [ "/standalone/server.js" ]