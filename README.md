# openldap-pla

## Run openldap and phpldapadmin in Docker

Install Docker

Clone this repository

chmod -x run.sh

./run.sh

Login (pre-populated) cn=admin,dc=example,dc=org

Password: password

Install and start Apache Directory studio on local machine.

Create new LDAP Connection

Host: localhost

cn=admin,dc=example,dc=org

LESSON 15, Deep dive into web interface

Exec into phpldapadmin container

docker exec -it phpldapadmin-service  bash

To edit files:
```
apt-get update
apt-get install apt-file
apt-file update
apt-get install vim     
OR
apt-get update && apt-get install apt-file -y && apt-file update && apt-get install vim -y
```


Create country template from ou template.

cd /var/www/phpldapadmin/templates/creation

cp ou.xml country.xml

cat country.xml
```
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE template SYSTEM "template.dtd">

<template>
<askcontainer>1</askcontainer>
<description>New Organisational Unit</description>
<icon>ldap-ou.png</icon>
<invalid>0</invalid>
<rdn>ou</rdn>
<!-- <regexp>^o=.*,</regexp> -->
<title>Generic: Organisational Unit</title>
<visible>1</visible>

<objectClasses>
<objectClass id="organizationalUnit"></objectClass>
</objectClasses>

<attributes>
<attribute id="ou">
	<display>Organisational Unit</display>
	<hint>don't include "ou="</hint>
	<order>1</order>
	<page>1</page>
</attribute>
</attributes>

</template>
```
============================
Change to match templates/create/country.xml in this project.

```
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE template SYSTEM "template.dtd">

<template>
<askcontainer>1</askcontainer>
<description>New Country Object Class</description>
<icon>ldap-ou.png</icon>
<invalid>0</invalid>
<rdn>c</rdn>
<!-- <regexp>^o=.*,</regexp> -->
<title>Generic: country</title>
<visible>1</visible>

<objectClasses>
<objectClass id="country"></objectClass>
</objectClasses>

<attributes>
<attribute id="c">
	<display>country</display>
	<hint>don't include "c="</hint>
	<order>1</order>
	<page>1</page>
</attribute>
</attributes>

</template>
```
chmod 777 country.xml

Add organization template the same way we added country template.

cd /var/www/phpldapadmin/templates/creation

cp ou.xml o.xml

etc.

## Lesson 16 - Apache2 Directory Studio

No need to install templates, as with PLA.

Must be installed on your machine.

Two perspectives:

LDAP

Schema Editor





Apache2 Directory studio LDAP result code 21 - invalidAttributeSyntax objectClass: posixAccount value #1 invalid per syntax posixAccount



 	
Could not determine the root of your LDAP tree.
It appears that the LDAP server has been configured to not reveal its root.
Please specify it in config.php


## Lesson 19 Command Line tools

Exec into ldap server:

docker exec -it ldap-service bash

Use password and bind DN.
Use -w password and -D '


ldapsearch -x -D 'cn=admin,dc=example,dc=org' -z 200 -b 'dc=example,dc=org' -s sub -w password -v '(uid=davis)'

ldapsearch -x -D 'cn=admin,dc=example,dc=org' -z 200 -b 'dc=example,dc=org' -s sub -w password -v 'objectclass=*'


ldapsearch -x \
  -D "cn=admin,dc=example,dc=org" \
  -w password \
  -v \
  -b "dc=example,dc=org" \
  -s sub "(uid=*)"








## Lesson   LDAP Schemas

In ldap host

ldapsearch -Q -LLL -Y EXTERNAL 


## LDAP User Authentication Setup

Set up user auth in Ubuntu Linux

Spin up Ubuntu Linux server in the cloud.
password: bananab

sudo apt-get update

sudo apt-get install libpam-ldap nscd


Configuring ldap-auth-config
----------------------------

Please enter the URI of the LDAP server to use. This is a string in the form of
ldap://<hostname or IP>:<port>/. ldaps:// or ldapi:// can also be used. The port number is
optional.

Note: It is usually a good idea to use an IP address because it reduces risks of failure in the
event name service problems.

LDAP server Uniform Resource Identifier:

LDAP server Uniform Resource Identifier: ldap://172.17.0.2


Please enter the distinguished name of the LDAP search base. Many sites use the components of
their domain names for this purpose. For example, the domain "example.net" would use
"dc=example,dc=net" as the distinguished name of the search base.

Distinguished name of the search base:

dc=example,dc=org

Please enter which version of the LDAP protocol should be used by ldapns. It is usually a good
idea to set this to the highest available version.

  1. 3  2. 2
LDAP version to use: 1


This option will allow you to make password utilities that use pam to behave like you would be
changing local passwords.

The password will be stored in a separate file which will be made readable to root only.

If you are using NFS mounted /etc or any other custom setup, you should disable this.

Make local root Database admin: [yes/no] yes



Choose this option if you are required to login to the database to retrieve entries.

Note: Under a normal setup, this is not needed.

Does the LDAP database require login? [yes/no]  no



This account will be used when root changes a password.

Note: This account has to be a privileged account.

LDAP account for root:  cn=admin,dc=example,dc=org

Please enter the password to use when ldap-auth-config tries to login to the LDAP directory
using the LDAP account for root.

The password will be stored in a separate file /etc/ldap.secret which will be made readable to
root only.

Entering an empty password will re-use the old password.

LDAP root account password: password


The PAM module can set the password crypt locally when changing the passwords, which is usually
a good choice. Specifying something other than clear ensures that the password gets crypted in
some way.

The meanings for selections are:

clear - Don't set any encryptions. This is useful with servers that automatically encrypt
userPassword entry.

crypt - (Default) make userPassword use the same format as the flat filesystem. This will work
for most configurations.

nds - Use Novell Directory Services-style updating by first removing the old password and then
update with a cleartext password.

ad - Active Directory-style. Create a Unicode password and update the unicodePwd attribute.

exop - Use the OpenLDAP password change extended operation to update the password.
[More]



md5 - Use the stronger md5 algorithm instead of standard crypt.

  1. clear  2. crypt  3. nds  4. ad  5. exop  6. md5
Local crypt to use when changing passwords: 1





to do over:

sudo dpkg-reconfigure ldap-auth-config


apt-get install nscd

Continuing in the ubuntu container:

vim /etc/nsswitch.conf

```
# /etc/nsswitch.conf
#
# Example configuration of GNU Name Service Switch functionality.
# If you have the `glibc-doc-reference' and `info' packages installed, try:
# `info libc "Name Service Switch"' for information about this file.

passwd:         files systemd
group:          files systemd
shadow:         files
gshadow:        files

hosts:          files dns
networks:       files

protocols:      db files
services:       db files
ethers:         db files
rpc:            db files

netgroup:       nis
"nsswitch.conf" 20L, 510B
```
CHANGE three lines as follows:
passwd:         ldap files systemd
group:          ldap files systemd
shadow:         ldap files


Want to automatically create a home directory when a user logs in:

vim /etc/pam.d/common-session

```

# /etc/pam.d/common-session - session-related modules common to all services
#
# This file is included from other service-specific PAM config files,
# and should contain a list of modules that define tasks to be performed
# at the start and end of interactive sessions.
#
# As of pam 1.0.1-6, this file is managed by pam-auth-update by default.
# To take advantage of this, it is recommended that you configure any
# local modules either before or after the default block, and use
# pam-auth-update to manage selection of other modules.  See
# pam-auth-update(8) for details.

# here are the per-package modules (the "Primary" block)
session [default=1]                     pam_permit.so
# here's the fallback if no module succeeds
session requisite                       pam_deny.so
# prime the stack with a positive return value if there isn't one already;
# this avoids us returning an error just because nothing sets a success code
# since the modules above will each just jump around
session required                        pam_permit.so
# The pam_umask module will set the umask according to the system default in
# /etc/login.defs and user settings, solving the problem of different
# umask settings with different shells, display managers, remote sessions etc.
# See "man pam_umask".
session optional                        pam_umask.so
# and here are more per-package modules (the "Additional" block)
session required        pam_unix.so
session optional                        pam_ldap.so
session optional        pam_systemd.so
# end of pam-auth-update config

```
at the end of the file add:

session required  pam_mkhomedir.so skel=/etc/skel umask=0022

Restart the service so our config changes will take effect:

sudo /etc/init.d/nscd restart

If you logged in using public key instead of password, you must enable password authentication before you proceed.

Set the password:

sudo passwd

Make sure PasswordAuthentication yes is set in the file:
sudo vim /etc/ssh/sshd_config

If you changed sshd_config, you have to restart ssh as root.

```
sudo -s
/etc/init.d/ssh restart
```

Find user steve password using Apache Directory Studio

it is: steveldap






root@phpldapadmin-service:/var/www/phpldapadmin/templates/creation#


### 7 - Create Django project and install libs
```bash
django-admin startproject autenticationLdap
pip install django-auth-ldap
```

### 8 - Configure Django to authenticate OpenLDAP
Edit settings.py
```python
AUTH_LDAP_SERVER_URI = 'ldap://172.17.0.2' #IP from LDAP server

AUTH_LDAP_BIND_DN = 'cn=admin,dc=example,dc=org' # Distinguished Name from Admin
AUTH_LDAP_BIND_PASSWORD = 'admin' # Password from Admin
AUTH_LDAP_USER_SEARCH = LDAPSearch( # Path to find users 
    'dc=example,dc=org',
    ldap.SCOPE_SUBTREE,
    '(uid=%(user)s)',
)
AUTH_LDAP_START_TLS = False

# This is the default, but I like to be explicit.
AUTH_LDAP_ALWAYS_UPDATE_USER = True

# Use LDAP group membership to calculate group permissions.
AUTH_LDAP_FIND_GROUP_PERMS = True

# Cache distinguised names and group memberships for an hour to minimize
# LDAP traffic.
AUTH_LDAP_CACHE_TIMEOUT = 3600

# Keep ModelBackend around for per-user permissions and maybe a local
# superuser.
AUTHENTICATION_BACKENDS = [
    'django_auth_ldap.backend.LDAPBackend',
    'django.contrib.auth.backends.ModelBackend',
]

#Adding logger to LDAP server
logger = logging.getLogger('django_auth_ldap')
logger.addHandler(logging.StreamHandler())
logger.setLevel(logging.DEBUG)
```

### 9 - Create group from users
(Generic: Posix Group)
![screenshot from 2019-01-08 12-20-47](https://user-images.githubusercontent.com/12220181/50836440-5b2cad00-1340-11e9-83d4-77203f25f17e.png) 
![screenshot from 2019-01-08 12-21-24](https://user-images.githubusercontent.com/12220181/50836441-5b2cad00-1340-11e9-9aab-72cbcaafedaa.png)

### 10 - Create user
(Generic: User Account)
![screenshot from 2019-01-08 12-20-47](https://user-images.githubusercontent.com/12220181/50836440-5b2cad00-1340-11e9-83d4-77203f25f17e.png) 
![screenshot from 2019-01-08 12-22-05](https://user-images.githubusercontent.com/12220181/50836442-5bc54380-1340-11e9-82d8-79d60f1a3278.png)

### 11 - Create super user from Django
```bash
python manage.py createsuperuser
```

### 12 - Loggin in Django admin
Log with user create in phpLDAPadmin
http://127.0.0.1:8000/admin/

Exit terminal debug Django application
```bash
[08/Jan/2019 16:10:12] "GET / HTTP/1.1" 200 16348
[08/Jan/2019 16:10:12] "GET /static/admin/css/fonts.css HTTP/1.1" 304 0
[08/Jan/2019 16:10:12] "GET /static/admin/fonts/Roboto-Regular-webfont.woff HTTP/1.1" 304 0
[08/Jan/2019 16:10:12] "GET /static/admin/fonts/Roboto-Bold-webfont.woff HTTP/1.1" 304 0
[08/Jan/2019 16:10:12] "GET /static/admin/fonts/Roboto-Light-webfont.woff HTTP/1.1" 304 0
Not Found: /favicon.ico
[08/Jan/2019 16:10:12] "GET /favicon.ico HTTP/1.1" 404 1983
[08/Jan/2019 16:10:15] "GET /admin/ HTTP/1.1" 200 3264
[08/Jan/2019 16:10:15] "GET /static/admin/css/base.css HTTP/1.1" 304 0
[08/Jan/2019 16:10:15] "GET /static/admin/css/dashboard.css HTTP/1.1" 304 0
[08/Jan/2019 16:10:16] "GET /admin/ HTTP/1.1" 200 3264
[08/Jan/2019 16:10:16] "GET /static/admin/css/responsive.css HTTP/1.1" 304 0
[08/Jan/2019 16:10:16] "GET /static/admin/img/icon-changelink.svg HTTP/1.1" 304 0
[08/Jan/2019 16:10:16] "GET /static/admin/img/icon-addlink.svg HTTP/1.1" 304 0
[08/Jan/2019 16:10:18] "GET /admin/logout/ HTTP/1.1" 200 1207
[08/Jan/2019 16:10:19] "GET /admin/logout/ HTTP/1.1" 302 0
[08/Jan/2019 16:10:19] "GET /admin/ HTTP/1.1" 302 0
[08/Jan/2019 16:10:19] "GET /admin/login/?next=/admin/ HTTP/1.1" 200 1819
[08/Jan/2019 16:10:19] "GET /static/admin/css/login.css HTTP/1.1" 304 0
search_s('dc=example,dc=org', 2, '(uid=%(user)s)') returned 1 objects: cn=test,dc=example,dc=org
Creating Django user test
Populating Django user test
[08/Jan/2019 16:10:24] "POST /admin/login/?next=/admin/ HTTP/1.1" 200 1979
```

Django admin page return this erro:
![screenshot from 2019-01-08 14-28-58](https://user-images.githubusercontent.com/12220181/50844398-c7fc7300-1351-11e9-9da0-ff5a104b8811.png)


### 13 - Loggin with super user in Django admin
Go to users and change user test to super user.

![screenshot from 2019-01-08 14-22-20](https://user-images.githubusercontent.com/12220181/50843970-ea41c100-1350-11e9-9af3-d0383da15029.png)

### 14 - Edit settings.py
Remove this line from settings.py:
```python    
'django.contrib.auth.backends.ModelBackend',
```
Now Django is configurate autentication only OpenLDAP, it isn't using default authentication from ModelsBackend.

### 15 - Loggin in Django admin
Loggin with user test now loggin sucefful.
![screenshot from 2019-01-08 14-35-06](https://user-images.githubusercontent.com/12220181/50844793-a8b21580-1352-11e9-8c6d-bb5c190f29ea.png)
