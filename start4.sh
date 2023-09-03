#!/bin/bash -e
# https://github.com/osixia/docker-phpLDAPadmin

docker run \
    --env LDAP_ORGANISATION="My company" \
	--env LDAP_DOMAIN="example.org" \
	--env LDAP_ADMIN_PASSWORD="password" \
    --name ldap-service \
    --hostname ldap-service \
    --detach osixia/openldap:1.1.8

docker run -p 6443:443 \
    --name phpldapadmin-service \
    --hostname phpldapadmin-service \
    --link ldap-service:ldap-host \
    --env PHPLDAPADMIN_LDAP_HOSTS=ldap-host \
    --volume /Users/john.kraus/workspaces/ldap-projects/Server-LDAP/data/config-auto.php:/container/service/phpldapadmin/assets/config/config.php \
    --detach osixia/phpldapadmin:0.9.0 --copy-service


#     --volume /Users/john.kraus/workspaces/ldap-projects/Server-LDAP/data/my-config.php:/container/service/phpldapadmin/assets/config/config.php \

PHPLDAP_IP=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" phpldapadmin-service)

# docker inspect -f "{{ .NetworkSettings.IPAddress }}" phpldapadmin-service

echo "Go to: https://$PHPLDAP_IP"
echo "Login DN: cn=admin,dc=example,dc=org"
echo "Password: admin"

# browse to:  https://localhost:6443/
# how to login: https://fadi.cetic.be/doc/USERMANAGEMENT.html#:~:text=Connect%20to%20phpLDAPadmin,Password%3A%20password1

# Login: cn=admin,dc=example,dc=org
# Password: admin


