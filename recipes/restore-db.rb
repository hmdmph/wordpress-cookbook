#
# Cookbook Name:: wordpress
# Recipe:: restore-db
# Author:: Manoj Prasanna Handapangoda (<hmdmph@gmail.com>)
#
#

include_recipe "mysql::client" unless platform_family?('windows') # No MySQL client on Windows
include_recipe "mysql-chef_gem" # Replaces mysql::ruby

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
::Chef::Recipe.send(:include, Wordpress::Helpers)

node.set_unless['wordpress']['db']['pass'] = secure_password

node.save unless Chef::Config[:solo]

db = node['wordpress']['db']
olddb = node['wordpress']['old']['db']
old_data = node['wordpress']['old']
new_data = node['wordpress']['new']

if is_local_host? db['host']
  include_recipe "mysql::server"

  mysql_connection_info = {
      :host     => 'localhost',
      :username => 'root',
      :password => node['mysql']['server_root_password']
  }

  #drop database if exists
  mysql_database olddb['name'] do
    connection mysql_connection_info
    action [:drop]
  end

  #create new database
  mysql_database olddb['name'] do
    connection mysql_connection_info
    action [:create]
  end

  execute 'restore-databases' do
    command "mysql -u root -p#{node['mysql']['server_root_password']} -D #{olddb['name']} < #{node['wordpress']['db']['backup']['path']}"
  end


  mysql_database_user olddb['user'] do
    connection    mysql_connection_info
    password      olddb['pass']
    host          db['host']
    database_name olddb['name']
    action        :create
  end

  mysql_database_user olddb['user'] do
    connection    mysql_connection_info
    database_name olddb['name']
    privileges    [:all]
    action        :grant
  end

  #current restore support only for the linux environment only
  #linux temp folder path
  template "/tmp/restore-query.sql" do
    source 'restore-query.sql.erb'
    mode 0644
    variables(
        :db_name  => olddb['name'],
        :old_domain_name => node['wordpress']['old']['site_url'],
        :new_domain_name => node['wordpress']['new']['site_url']
    )
    owner node['wordpress']['install']['user']
    group node['wordpress']['install']['group']
    action :create
  end

#if the domain names are same no need to run the change/update queries in restored database
  if old_data['site_url'] != new_data['site_url']
    mysql_database olddb['name'] do
      connection mysql_connection_info
      sql { ::File.open("/tmp/restore-query.sql").read }
      action :query
    end
  else
    #do nothing here
  end

end
