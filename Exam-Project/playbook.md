# Cloud Engineering Second Semester Examination Project

### (Deploy Laravel and Set up Postgresql)

#### Question

You are required to deploy the same Laravel application from your mini project. This time, the entire deployment steps including installation of packages and dependencies, configuring your apache webserver etc, will be defined in an ansible playbook and deployed to atleast one ansible slave.
You should also write a bash script that would install and set up postgresql. This bash script would be run on your ansible slaves using an ansible playbook.

### Requirements

* We should be able to access your deployment using a domain name of your choice(not an IP address).
* We should be able to test all the endpoints without errors.
* Your base url may or may not display the default Laravel page.
* These must be done on virtual machines on any cloud provider of your choice(any Linux distro of your choice).
* Your application must be encrypted with TLS/SSL.
* You may or may not define a logical network on the cloud, but extra efforts would be rewarded.

## Solution


Embedded with this markdown file is the contents of my Config.yaml and Playbook.yaml files used to deploy this project.

After successfully deploying it, here's a link to my domain angelifechukwu.me

I also tested the endpoints and here's a link to the result.



## Config.yaml

```ruby
host: localhost
mysql_user: root
mysql_root_password: 1234
db_user: angel
user_pass: 1234
db_name: angeldb
http_port: "80"
https_port: "443"
ssh_port: "22"
mysql_port: "3306
```

## Playbook.yaml

```ruby
---
- name: deploy apache2 on host server[remote]
  hosts: all
  become: true
  become_user: root
  vars_files:
    - laravel-app/config.yaml

  tasks:
    - name: Update "apt" repository
      apt:
        update_cache: true
        autoclean: true
        autoremove: true

    - name: Install (git, apache2 unzip, curl)
      apt:
        pkg:
        - git
        - apache2
        - unzip
        - curl
        - ufw

    - name: Install Software properties
      command: apt install -y software-properties-common

    - name: Add Apt Repo for PHP
      command: add-apt-repository ppa:ondrej/php -y

    - name: Update "apt"
      apt:
        update_cache: true
        autoclean: true

    - name: Install PHP
      command: apt install --no-install-recommends php8.1 -y

    - name: Update "apt"
      apt:
        update_cache: true
        autoclean: true

    - name: Install PHP 8.0 and it's libraries
      apt:
        pkg:
        - libapache2-mod-php
        - php8.1-common
        - php8.1-mysql
        - php8.1-xml
        - php8.1-xmlrpc
        - php8.1-curl
        - php8.1-gd
        - php8.1-imagick
        - php8.1-cli
        - php8.1-dev
        - php8.1-imap
        - php8.1-mbstring
        - php8.1-opcache
        - php8.1-soap
        - php8.1-zip
        - php8.1-intl

    - name: Update "apt"
      apt:
        update_cache: true
        autoclean: true

    - name: Install Python3
      apt:
        name: python3
        state: latest

    - name: Install Pip
      apt:
        name: pip
        state: latest

    - name: Install MySQL server
      apt:
        name: mysql-server
        state: latest

    - name: Install MySQL client
      apt:
        name: mysql-client
        state: latest

    - name: Install PyMySQL Library
      pip:
        name: pymysql
        state: latest

    - name: Start the MySQL service
      service:
        name: mysql
        state: started
        enabled: true

    - name: Ensure mySQL is running and starts on boot
      service: name=mysql state=started enabled=true

    - name: sql query
      command:  mysql -u root --execute="ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '"{{ mysql_root_password }}"';"

    - name: Create ~/.my.cnf
      file:
        path: ~/.my.cnf
        state: touch

    - name: Insert into ~/.my.cnf
      blockinfile:
        path: ~/.my.cnf
        block: |
          [client]
          user={{ mysql_user }}
          password={{ mysql_root_password }}

    - name: sql query flush
      command:  mysql -u root --execute="FLUSH PRIVILEGES"

    - name: Create a Database
      mysql_db:
        login_user: 'root'
        login_password: "{{ mysql_root_password }}"
        name: "{{ db_name }}"
        state: present

    - name: Create a Database User
      mysql_user:
        login_user: 'root'
        login_password: "{{ mysql_root_password }}"
        name: "{{ db_user }}"
        password: "{{ user_pass }}"
        host: localhost
        priv: '{{ db_name }}.*:ALL,GRANT'

    - name: Restart MySQL
      service: name=mysql state=restarted

    - name: "UFW - Allow HTTP on port {{ http_port }}"
      ufw:
        rule: allow
        port: "{{ http_port }}"
        proto: tcp

    - name: "UFW - Allow HTTPS on port {{ https_port }}"
      ufw:
        rule: allow
        port: "{{ https_port }}"
        proto: tcp

    - name: "UFW - Allow SSH on port {{ ssh_port }}"
      ufw:
        rule: allow
        port: "{{ ssh_port }}"
        proto: tcp

    - name: "UFW - Allow MySQL on port {{ mysql_port }}"
      ufw:
        rule: allow
        port: "{{ mysql_port }}"
        proto: tcp

    - name: Change the working directory to /var/www/ and create angel directory
      command: mkdir angel
      args:
        chdir: /var/www/
        creates: angel

    - name: Clone the project repo into a new directory
      git:
        repo: https://github.com/f1amy/laravel-realworld-example-app.git
        dest: /var/www/angel
        clone: true
        update: false

    - name: Create the web.php file in the routes directory
      ansible.builtin.copy:
        dest: /var/www/angel/routes/web.php
        content: |
          <?php

          Route::get('/', function () {
              return view('welcome');
          });

    - name: Create the .env file
      ansible.builtin.copy:
        dest: /var/www/angel/.env
        content: |
          APP_NAME="Laravel Realworld Example App"
          APP_ENV=local
          APP_KEY=
          APP_DEBUG=true
          APP_URL=http://localhost
          APP_PORT=3000

          LOG_CHANNEL=stack
          LOG_DEPRECATIONS_CHANNEL=null
          LOG_LEVEL=debug

          DB_CONNECTION=mysql
          DB_HOST=localhost
          DB_PORT=3306
          DB_DATABASE=angeldb
          DB_USERNAME=root
          DB_PASSWORD=1234

          BROADCAST_DRIVER=log
          CACHE_DRIVER=file
          FILESYSTEM_DISK=local
          QUEUE_CONNECTION=sync
          SESSION_DRIVER=file
          SESSION_LIFETIME=120

          MEMCACHED_HOST=127.0.0.1

          REDIS_HOST=127.0.0.1
          REDIS_PASSWORD=null
          REDIS_PORT=6379

          MAIL_MAILER=smtp
          MAIL_HOST=mailhog
          MAIL_PORT=1025
          MAIL_USERNAME=null
          MAIL_PASSWORD=null
          MAIL_ENCRYPTION=null
          MAIL_FROM_ADDRESS="hello@example.com"
          MAIL_FROM_NAME="${APP_NAME}"

          AWS_ACCESS_KEY_ID=
          AWS_SECRET_ACCESS_KEY=
          AWS_DEFAULT_REGION=us-east-1
          AWS_BUCKET=
          AWS_USE_PATH_STYLE_ENDPOINT=false

          PUSHER_APP_ID=
          PUSHER_APP_KEY=
          PUSHER_APP_SECRET=
          PUSHER_APP_CLUSTER=mt1

          MIX_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
          MIX_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"

          L5_SWAGGER_GENERATE_ALWAYS=true
          SAIL_XDEBUG_MODE=develop,debug
          SAIL_SKIP_CHECKS=true

    - name: Change the project directory and install Composer        
      ansible.builtin.shell: curl -sS https://getcomposer.org/installer | php
      args:
        chdir: /var/www/angel

    - name: Move the downloaded composer binary to the system path   
      ansible.builtin.command: mv composer.phar /usr/local/bin/composer
      args:
        chdir: /var/www/angel

    - name: Make composer executable by user
      ansible.builtin.file:
        path: /usr/local/bin/composer
        mode: '755'

    - name: Install Composer
      ansible.builtin.shell: composer install --no-interaction       
      args:
        chdir: /var/www/angel

    - name: Run the php artisan key:generate command
      ansible.builtin.shell: php artisan key:generate
      args:
        chdir: /var/www/angel

    - name: Run the php artisan config:cache command
      ansible.builtin.shell: php artisan config:cache
      args:
        chdir: /var/www/angel

    - name: Run the php artisan migrate:fresh command
      ansible.builtin.shell: php artisan migrate:fresh
      args:
        chdir: /var/www/angel

    - name: Run the php artisan migrate --seed command
      ansible.builtin.shell: php artisan migrate --seed
      args:
        chdir: /var/www/angel

    - name: Create an apache virtual host configuration file
      ansible.builtin.copy:
        dest: /etc/apache2/sites-available/angel.conf
        content: |
          <VirtualHost *:80>
              ServerAdmin admin@angelifechukwu.me
              ServerName angelifechukwu.me
              ServerAlias www.angelifechukwu.me
              DocumentRoot /var/www/angel/public

              <Directory /var/www/angel/public>
                  AllowOverride All
              </Directory>

              ErrorLog ${APACHE_LOG_DIR}/error.log
              CustomLog ${APACHE_LOG_DIR}/access.log combined        
          </VirtualHost>

    - name: Enable a2enmod rewrite
      ansible.builtin.command: a2enmod rewrite

    - name: Disable default apache page
      ansible.builtin.command: a2dissite 000-default.conf

    - name: Enable laravel page
      ansible.builtin.command: a2ensite angel.conf

    - name: Change file ownership, group and permissions
      ansible.builtin.file:
        path: /var/www/angel
        state: directory
        recurse: true
        owner: www-data
        group: www-data
        mode: '775'

    - name: Restart apache web server
      ansible.builtin.command: systemctl restart apache2

    - name: set timezone to Africa/Lagos
      timezone:
        name: Africa/Lagos

    - name: Script to install PostgreSQL
      ansible.builtin.script: /home/vagrant/postgres.sh
      args:
        chdir: /home/ubuntu


    - name : Install Python Package
      apt:
        name: python3
        update_cache: yes
        state: latest

    - name : Install Let's Encrypt Package
      apt:
        name: python3-certbot-apache
        update_cache: yes
        state: latest

    - name: SSL THingy
      command: sudo certbot --apache -w /var/www/laravel-app -d angelifechukwu.me -d www.angelifechuwku.me --non-interactive --agree-tos -m angelifechukwu00@gmail.com
      ```
