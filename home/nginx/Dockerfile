FROM alpine:3.23
RUN apk add --no-cache nginx
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
ENTRYPOINT [ "nginx" ]
CMD [ "-g", "daemon off;" ]