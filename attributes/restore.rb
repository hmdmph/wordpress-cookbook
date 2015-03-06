#
# Author:: Manoj Prasanna Handapangoda (<hmdmph@gmail.com>)
#
# Cookbook Name:: wordpress
# Attributes:: restore

# General wordpress restore settings

#location of the database back up of web site
node['wordpress']['db']['backup']['path']="/home/ubuntu/db_backup_file.sql"

#location of the files backup of the web site ( in tar.gz format)
node['wordpress']['files']['backup']['path']="/home/ubuntu/wp-backup-website.tar.gz"

#old wordpress url ( when you taking database backup)
node['wordpress']['old']['site_url']="http://www.old-site-url.com"

#new wordpress url ( if you are restoring backup in to new url or else use the same ord url )
node['wordpress']['new']['site_url']="http://www.new-site-url.com"

#old database user name if your are going to restore under same user ( take these values from wp-config.php file in old wordpress )
node['wordpress']['old']['db']['user']="old_db_username"

#old database name if your are going to restore under same user ( take these values from wp-config.php file in old wordpress )
node['wordpress']['old']['db']['name']="old_db_name"

#old database user password if your are going to restore under same user ( take these values from wp-config.php file in old wordpress )
node['wordpress']['old']['db']['pass']="old_db_user_password"


