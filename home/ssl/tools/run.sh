#! /bin/sh
if [ ! -f /certs/key.pem ] || [ ! -f /certs/certs.pem ]; then
	openssl req -x509 -newkey rsa:2048 -keyout /certs/key.pem -out /certs/certs.pem -nodes -days 365 -subj "/CN=localhost"
fi