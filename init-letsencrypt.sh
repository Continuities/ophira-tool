#!/bin/bash

docker_cmd="docker-compose"
domain=rage.ophirathestalker.ca
rsa_key_size=4096
email="michael@doublespeakgames.com"
staging=0 # Set to 1 when testing to avoid hitting request limits

echo "### Creating dummy certificate for $domain ..."
path="/etc/letsencrypt/live/$domain"
$docker_cmd run --rm --entrypoint "mkdir -p '$path'" certbot
$docker_cmd run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:2048 -days 1\
    -keyout '$path/privkey.pem' \
    -out '$path/fullchain.pem' \
    -subj '/CN=localhost'" certbot
echo

echo "### Starting server ..."
$docker_cmd up --force-recreate -d server
echo

echo "### Deleting dummy certificate for $domain ..."
$docker_cmd run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live/$domain && \
  rm -Rf /etc/letsencrypt/archive/$domain && \
  rm -Rf /etc/letsencrypt/renewal/$domain.conf" certbot
echo

echo "### Requesting Let's Encrypt certificate for $domain ..."
domain_args=" -d $domain"
email_arg="--email $email"
if [ $staging != "0" ]; then staging_arg="--staging"; fi

$docker_cmd run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot \
    $staging_arg \
    $email_arg \
    $domain_args \
    --rsa-key-size $rsa_key_size \
    --agree-tos \
    --force-renewal" certbot
echo

echo "### Reloading server ..."
$docker_cmd exec server nginx -s reload
