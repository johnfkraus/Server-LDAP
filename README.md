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
