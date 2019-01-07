## How to run server OpenLdap with PHPldapadmin
  ### 1 - Clone repository
  ### 2 - Install Docker (https://docs.docker.com/v17.09/engine/installation/linux/docker-ce/ubuntu/#set-up-the-repository)
  ### 3 - Run script.sh
```console
chmode -x start.sh 
bash -x start.sh
```
  ### 4 - Get IP from PHPldapAdmin
```bash
+ docker run --name ldap-service --hostname ldap-service --detach osixia/openldap:1.1.8
01b9973eb7bad5aa60ea0531e73530a79ed82d7b6543ec5318cda51c829e97e4
+ docker run --name phpldapadmin-service --hostname phpldapadmin-service --link ldap-service:ldap-host --env PHPLDAPADMIN_LDAP_HOSTS=ldap-host --detach osixia/phpldapadmin:0.7.2
74f60c540b4889f44ee199c0bae407ceb951907059530f1676dfc35fc2291ec6
++ docker inspect -f '{{ .NetworkSettings.IPAddress }}' phpldapadmin-service
+ PHPLDAP_IP=172.17.0.3
+ echo 'Go to: https://172.17.0.3'
Go to: https://172.17.0.3
+ echo 'Login DN: cn=admin,dc=example,dc=org'
Login DN: cn=admin,dc=example,dc=org
+ echo 'Password: admin'
Password: admin
```
  ### 5 - Go to PHPldapAdmin
  ![screenshot from 2019-01-06 12-35-48](https://user-images.githubusercontent.com/12220181/50763854-280eee80-1258-11e9-9cc6-6696bda5fb24.png)
  
    url: https://172.17.0.3
    login: cn=admin,dc=example,dc=org
    password: admin

### 6 - Get IP from OpenLDAP
```bash
docker inspect -f '{{ .NetworkSettings.IPAddress }}' ldap-service
127.17.0.3
```