#
# Cookbook:: Nginx_Cookbook
# Description : Installs Nginx into centos/RHEL
# Recipe:: Install_Nginx
# Author : Ashfaq Ahmed Shaik
#
# Copyright:: 2017, The Authors, All Rights Reserved.

archives = ['pcre-8.40.tar.gz', 'zlib-1.2.11.tar.gz', 'openssl-1.0.2f.tar.gz', 'nginx-1.10.3.tar.gz']
directories = ['/tmp/pcre-8.40', '/tmp/zlib-1.2.11', '/tmp/openssl-1.0.2f', 'nginx-1.10.3']

#
# Install development tools
#
execute 'Installing Development Tools' do
  command 'yum -y groupinstall "Development tools"'
  action :run
end
execute 'Installing Glibc' do
  command 'yum -y install glibc*'
  action :run
end


# Copy Dependencies
archives.each do |archive|
  cookbook_file '/tmp/' + archive do
  source archive
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  end
end

# Extract all dependencies
archives.each do |archive|
  execute 'Extracting ' + archive do
    command 'tar -xzf ' + archive
    action :run
    cwd '/tmp'
  end
end

# Build PCRE
execute 'Building PCRE' do
  command './configure && make && make install'
  action :run
  cwd '/tmp/pcre-8.40'
end

# Build Zlib
execute 'Building Zlib' do
  command './configure && make && make install'
  action :run
  cwd '/tmp/zlib-1.2.11'
end

# Build Open SSL
execute 'Building Open SSL' do
  command './config --prefix=/usr && make && make install'
  action :run
  cwd '/tmp/openssl-1.0.2f'
end

# Build Nginx
execute 'Building Nginx' do
  command './configure && make && make install'
  action :run
  cwd '/tmp/nginx-1.10.3'
end