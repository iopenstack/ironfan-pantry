include_recipe 'runit'
include_recipe 'silverware'
include_recipe 'java'
complain_if_not_sun_java(:zookeeper)

daemon_user(:zookeeper) do
  home node[:zookeeper][:home_dir]
end

[:conf_dir, :log_dir, :home_dir, :pid_dir, :data_dir, :journal_dir].each do |sym|
  if node[:zookeeper].has_key? sym
    directory node[:zookeeper][sym] do
      recursive true
      owner node[:zookeeper][:user]
      group node[:zookeeper][:user]
    end
  end
end

execute "untar-zookeeper" do
  action :nothing
  command "tar -xvzf #{Chef::Config[:file_cache_path]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz -C #{node[:zookeeper][:home_dir]} --strip 1"
end

remote_file "#{Chef::Config[:file_cache_path]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz" do
  source "https://s3-eu-west-1.amazonaws.com/portico-binaries/zookeeper-#{node[:zookeeper][:version]}.tar.gz"
  mode 00644
  only_if { not ::File.exists?("#{Chef::Config[:file_cache_path]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz") }
  notifies :run, "execute[untar-zookeeper]", :immediate
end

# JMX should listen on the public interface
node.set[:zookeeper][:jmx_dash_addr] = node['launch_spec']['ipv4']['public']

execute "chown-zookeeper" do
  command "chown -R #{node[:zookeeper][:user]}:#{node[:zookeeper][:user]} #{node[:zookeeper][:home_dir]}"
end

runit_service "zookeeper_server" do
  run_state     node[:zookeeper][:server][:run_state]
  options       node[:zookeeper]
end

include_recipe "zookeeper::config_files"

node.set[:zookeeper][:client_port] = node[:zookeeper][:client_port]
announce(:zookeeper, :server, {
  :logs  => { :server => node[:zookeeper][:log_dir] },
  :ports => {
    :client_port => {
      :port => node[:zookeeper][:client_port]
    },
    :jmx => { 
      :port => node[:zookeeper][:jmx_dash_port],
      :dashboard => true
    }, 
  },
  :daemons => {
    :java => {
      :name    => 'java',
      :user    => node[:zookeeper][:user],
      :cmd     => 'QuorumPeerMain'
    }
  }
})