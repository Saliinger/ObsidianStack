FROM debian:bookworm-slim
RUN apt-get update && apt-get install mariadb-server && rm -rf /var/lib/apt/lists/*
WORKDIR /run
COPY ../tools/run.sh ./run.sh