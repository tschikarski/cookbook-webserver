#
# Cookbook Name:: robertlemke-webserver
# Recipe:: default
#
# Copyright 2013, Robert Lemke
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'robertlemke-baseserver'

#
# MYSQL
#

# Note that ruby-dev must be installed on the base box already in order to compile
# mysql::ruby which in turn is necessary for database::mysql

include_recipe 'mysql::client'
include_recipe 'mysql::server'
include_recipe 'database::mysql'

node.default['mysql']['tunable']['collation-server'] = "utf8_unicode_ci"
node.default['mysql']['tunable']['max_connections'] = "150"
node.default['mysql']['delete_anonymous_users'] = true
node.default['mysql']['delete_passwordless_users'] = true

#
# APACHE
#

include_recipe 'apache2'
include_recipe 'apache2::logrotate'
include_recipe 'apache2::mod_rewrite'

node.default['apache']['contact'] = "hostmaster@robertlemke.net"

file "/var/www/index.html" do
  action :delete
end

file "/var/www/index.php" do
  content "<?php echo(gethostname()); ?>"
  owner "root"
  group "www-data"
  mode 00775
end

#
# PHP
#

include_recipe 'php'
include_recipe 'apache2::mod_php5'

template "100-general-additions.ini" do
  path "/etc/php5/conf.d/100-general-additions.ini"
  source "100-general-additions.ini"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "apache2")
end

php_pear "igbinary" do
  action :install
end

package 'php5-curl' do
  action :install
end

package 'php5-gd' do
  action :install
end

package 'php5-mysql' do
  action :install
end

package 'php-apc' do
  action :install
end

template "100-apc-additions.ini" do
  path "/etc/php5/conf.d/100-apc-additions.ini"
  source "100-apc-additions.ini"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "apache2")
end

#
# COMPOSER
#

composer "/usr/local/bin" do
  action [:install, :update]
end
