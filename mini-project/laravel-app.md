# THE PROJECT HAS THE FOLLOWING REQUIREMENTS
- Debian 11 Server aka (Bullseye)
- Git, Apache, Wget, Curl
- Php 8.0 and it's dependencies
- Mysql/MariaDb Database
- Composer

## SETUP
Install LAMP Stack on Debian 11 / Debian 10


### Prerequisites to Install LAMP
- Root access to your server or a sudo user
- Domain pointed to your server IP to install

### Update the Package Installer

We will be using the Apt installer to install new packages onto our server. Before we start installing packages, we need to ensure it is up to date.
To do so, we can use the following command:

```
apt update
```

Once the update is done we can go to the next step.

### Install the following packages (Apache2, Wget, Git, Curl)

Now that our installer is up to date, we can now install our web server Apache and the following packages on the server.
This will install the Apache webserver package and start the Apache web service automatically

```
apt install -y wget \ 
git \
apache2 \
curl
```

> Note: The **-y** si to anser yes to all prompts



### Configure git global Username and Email
git config --global user.name "your name"

git config --global user.email youremail@example.com

### Install PHP

###### Add the SURY PPA for PHP 8.1

```
apt -y install lsb-release apt-transport-https ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
```

Now you can add the PPA to the server packages.

```
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
```

Update the packages and install PHP 8.1

```
apt update
apt install php libapache2-mod-php php8.1-mysql php8.1-common php8.1-mysql 
php8.1-xml php8.1-xmlrpc php8.1-curl php8.1-gd php8.1-imagick php8.1-cli php8.1-dev 
php8.1-imap php8.1-mbstring php8.1-opcache php8.1-soap php8.1-zip php8.1-intl -y
```

Once PHP is installed you can check the version using the following command.

```
php -v
```



### Install Laravel 8 Using Composer 

Change the directory to apache's document root

```
cd /var/www/html
```
clone the laravel project repo from github

```
git clone https://github.com/f1amy/laravel-realworld-example-app.git
```
Rename the the cloned directory to your desired name
```
mv laravel-realworld-example-app laravel
```

#### cd into your project
You will need to be inside that project file to enter all of the rest of the commands 

```
cd laravel 
```

### Create a copy of your .env file

**.env** files are not generally committed to source control for security reasons. But there is a .env.example which is a template of the .env file that the project expects us to have. So we will make a copy of the .env.example file and create a .env file that we can start to fill out to do things like database configuration in the next few steps.

```
cp .env.example .env
```
This will create a copy of the .env.example file in your project and name the copy simply .env.

Next, change the permission and ownership of Laravel directory: 

```
chown -R :www-data /var/www/html/laravel
chmod -R 775 /var/www/html/laravel
chmod -R 775 /var/www/html/laravel/storage
```

### Install Composer

Composer is a dependency manager for PHP used for managing dependencies and libraries required for PHP applications. 

To install Composer, run the following command: 

```
curl -sS https://getcomposer.org/installer | php
```
You should get the following output: 

```
All settings correct for using Composer
Downloading...
Composer (version 2.1.6) successfully installed to: /root/composer.phar
Use it: php composer.phar 
```
Next, move the downloaded binary to the system path: 

```
mv composer.phar /usr/local/bin/composer
```

chmod +x /usr/local/bin/composer

Next, verify the Composer version using the following command: 

```
composer --version
```

You should see the following output: 

```
Composer version 2.1.6 2021-08-19 17:11:08
```


### Install Composer Dependencies

Whenever you clone a new Laravel project you must now install all of the project dependencies. This is what actually installs Laravel itself, among other necessary packages to get started. When we run composer, it checks the composer.json file which is submitted to the github repo and lists all of the composer (PHP) packages that your repo requires. Because these packages are constantly changing, the source code is generally not submitted to github, but instead we let composer handle these updates. So to install all this source code we run composer with the following command.

```
composer install
```


generate the artisan key with the following command:
```
php artisan key:generate
```

### Configure Apache to Host Laravel 8
Laravel is tricky. It is because the main index.php file of the project resides in the public directory of the project. It means that we have to update our virtual host in such a way that it should route the traffic into the public directory inside our project directory.

It's easy too! We just have to add /public at the end of the DocumentRoot and at other places in the virtual host file where we have to define the document root of our project. 
Next, you'll need to create an Apache virtual host configuration file to host a Laravel application. 

You can create it using the following command: 

```ruby
nano /etc/apache2/sites-available/lara.conf
```
### nano /etc/apache2/sites-available/laravel.conf
Add the following lines:

```ruby
<VirtualHost *:80>
    ServerAdmin admin@altschool.me
    ServerName altschool.me
    ServerAlias www.altschool.me
    DocumentRoot /var/www/altschool/laravel/public
    
    <Directory /var/www/altschool/laravel/public>
       AllowOverride All
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

Save and close the file and then enable the Apache rewrite module and activate the Laravel virtual host with the following command: 

```ruby
root@bullseye:~# a2enmod rewrite
```

```ruby
root@bullseye:~# a2ensite laravel.conf
```

Finally, reload the Apache service to apply the changes: 

```ruby
root@bullseye:~# systemctl restart apache2
```

### Access Laravel
Now, open your web browser and access the Laravel using the URL http://laravel.example.com. You will be redirected to the Laravel default page:

navigate to this path in your browser: yourip/laravel/public

If you see the laravel default page you're good :+1::skin-tone-5:
