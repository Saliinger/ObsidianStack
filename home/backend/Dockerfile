FROM node:25.9-alpine3.23 AS base
RUN corepack enable && corepack prepare pnpm@10.33.0 --activate

FROM base AS deps
WORKDIR /app
COPY ./app/package.json /app/package.json
RUN pnpm install --frozen-lockfile

FROM deps AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY ./app .
RUN pnpm run build

FROM node:25.9-alpine3.23
WORKDIR /app
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY --from=build /app/package.json ./
EXPOSE 3001
ENTRYPOINT [ "node" ]
CMD [ "./dist/main.js" ]