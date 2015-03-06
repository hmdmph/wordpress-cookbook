#
# Author:: Manoj Prasanna Handapangoda (<hmdmph@gmail.com>)
#
# Cookbook Name:: wordpress
# Recipe:: restore

#first restore database
include_recipe "wordpress::database-restore"

#restore files to given location
include_recipe "wordpress::files-restore"

web_app_name = node['wordpress']['server_short_name']

web_app web_app_name do
  template "wordpress.conf.erb"
  docroot node['wordpress']['dir']
  server_name node['wordpress']['server_name']
  server_aliases node['wordpress']['server_aliases']
  server_port node['wordpress']['server_port']
  server_internal_ip node['wordpress']['server_internal_ip']
  enable true
end