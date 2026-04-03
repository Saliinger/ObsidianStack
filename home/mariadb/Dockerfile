FROM debian:bookworm-slim
RUN apt-get update && apt-get install mariadb-server -y && rm -rf /var/lib/apt/lists/*
WORKDIR /setup
COPY ./tools/run.sh ./run.sh
RUN chmod +x ./run.sh
EXPOSE 3306
ENTRYPOINT [ "./run.sh" ]