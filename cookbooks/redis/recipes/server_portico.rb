include_recipe 'runit'
include_recipe 'silverware'

daemon_user(:redis) do
  home node[:redis][:home_dir]
end

[:conf_dir, :log_dir, :home_dir, :data_dir].each do |sym|
  directory node[:redis][sym] do
    recursive true
    owner node[:redis][:user]
    group node[:redis][:user]
  end
end

execute "untar-redis" do
  action :nothing
  command "tar -xvzf #{Chef::Config[:file_cache_path]}/redis-#{node[:redis][:version]}.tar.gz -C #{node[:redis][:home_dir]} --strip 1"
end

remote_file "#{Chef::Config[:file_cache_path]}/redis-#{node[:redis][:version]}.tar.gz" do
  source "http://download.redis.io/releases/redis-#{node[:redis][:version]}.tar.gz"
  mode 00644
  only_if { not ::File.exists?("#{Chef::Config[:file_cache_path]}/redis-#{node[:redis][:version]}.tar.gz") }
  notifies :run, "execute[untar-redis]", :immediate
end

bash "make-redis" do
  cwd "#{node[:redis][:home_dir]}/src"
  code "make && make PREFIX=#{node[:redis][:home_dir]} install"
end

execute "chown-redis" do
  command "chown -R #{node[:redis][:user]}:#{node[:redis][:user]} #{node[:redis][:home_dir]}"
end

runit_service "redis_server" do
  options       node[:redis]
end

template "#{node[:redis][:conf_dir]}/redis.conf" do
  source        "redis.conf.erb"
  owner         node[:redis][:user]
  group         node[:redis][:user]
  mode          0644
  variables     :redis => node[:redis], :redis_server => node[:redis][:server]
  notifies      :restart, "service[redis_server]"
end