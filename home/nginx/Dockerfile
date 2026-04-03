FROM debian:bulleyes

RUN  apt-get install nginx

COPY ../conf/nginx.conf /etc/nginx/nginx.conf

COPY ../tools/run.sh /run.sh

EXPOSE 8443
EXPOSE 8080

ENTRYPOINT ["/run.sh"]
