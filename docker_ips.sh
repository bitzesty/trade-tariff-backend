#!/bin/sh

API_HOST=tariff-api.dev.gov.uk
FRONTEND_HOST=tariff.dev.gov.uk
ADMIN_HOST=tariff-admin.dev.gov.uk

# Remove current line with hostname at the end of line ($ means end of line)
sed -i '/'$API_HOST'$/ d' /etc/hosts
sed -i '/'$FRONTEND_HOST'$/ d' /etc/hosts
sed -i '/'$ADMIN_HOST'$/ d' /etc/hosts

# Puts new IPs of docker containers
api_ip=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' tradetariffbackend_api_1)
frontend_ip=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' tradetarifffrontend_frontend_1)
admin_ip=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' tradetariffadmin_admin_1)

echo "$api_ip $API_HOST" >>/etc/hosts
echo "$frontend_ip $FRONTEND_HOST" >>/etc/hosts
echo "$admin_ip $ADMIN_HOST" >>/etc/hosts

echo "[Docker hosts] updated"