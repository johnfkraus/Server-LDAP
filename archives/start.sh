#!/bin/bash -e

docker run  -p 389:389 -p 636:636 --name ldap-service --hostname ldap-service --detach osixia/openldap:1.5.0

# https://github.com/osixia/docker-phpLDAPadmin
docker run -p 6443:443 \
        --env PHPLDAPADMIN_LDAP_HOSTS=ldap.example.com \
        --detach osixia/phpldapadmin:0.9.0


docker run --name phpldapadmin-service --hostname phpldapadmin-service --link ldap-service:ldap-host --env PHPLDAPADMIN_LDAP_HOSTS=ldap-host --detach osixia/phpldapadmin:0.7.2

PHPLDAP_IP=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" phpldapadmin-service)

echo "Go to: https://$PHPLDAP_IP"
echo "Login DN: cn=admin,dc=example,dc=org"
echo "Password: admin"




docker run  -p 389:389 -p 636:636 --name phpldapadmin-service --hostname phpldapadmin-service --link ldap-service:ldap-host --env PHPLDAPADMIN_LDAP_HOSTS=ldap-host --detach osixia/phpldapadmin:0.7.2

PHPLDAP_IP=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" phpldapadmin-service)

echo "Go to: https://$PHPLDAP_IP"
echo "Login DN: cn=admin,dc=example,dc=org"
echo "Password: admin"



# https://github.com/osixia/docker-openldap

docker run -p 389:389 -p 636:636 --name my-openldap-container --detach osixia/openldap:1.5.0
