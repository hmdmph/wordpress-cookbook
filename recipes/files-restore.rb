#
# Author:: Manoj Prasanna Handapangoda (<hmdmph@gmail.com>)
#
# Cookbook Name:: wordpress
# Recipe:: files-restore


directory node['wordpress']['dir'] do
  action :create
  recursive true
  if platform_family?('windows')
    rights :read, 'Everyone'
  else
    owner node['wordpress']['install']['user']
    group node['wordpress']['install']['group']
    mode  '00755'
  end
end


backup_archive = node['wordpress']['files']['backup']['path']
destination_folder = node['wordpress']['dir']

tar_extract backup_archive do
  action :extract_local
  target_dir destination_folder
  creates "#{destination_folder}/lib"
end
