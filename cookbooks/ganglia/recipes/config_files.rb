#
# Cookbook Name::       ganglia
# Description::         Writes the ganglia config files filled with auto-discovered goodness
# Recipe::              config_files
# Author::              Philip (flip) Kromer - Infochimps, Inc
#
# Copyright 2011, Philip (flip) Kromer - Infochimps, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# Conf file -- auto-discovers ganglia collectors and generators
#

if is_collector?
    # monitoring_groups = map of all 'monitorable clusters' with their contact address:
    # cluster_name, ip:port
    # here, as all cluster collectors normally run on the same node as gmetad, 'ip' would always be 'localhost'

    own_collectors_data.each do |cluster_id, collector_addr|
        ip   = collector_addr[0]
        port = collector_addr[1]

        Chef::Log.debug("Ganglia::config_files --- setup collector for cluster '#{cluster_id}' @ #{ip}:#{port}")

        #template for individual collector gmond services
        template "#{node[:ganglia][:conf_dir]}/gmond.#{cluster_id}.conf" do
            source      'gmond.conf.erb'
            backup      false
            owner       node[:ganglia][:user]
            group       node[:ganglia][:group]
            mode        '0644'
            variables(
                :user    => node[:ganglia][:user],
                :cluster => {
                    :name          => cluster_id,
                    :owner         => nil,
                    :latlong       => nil,
                    :url           => nil,
                    :host_location => nil
                },
                :send_udp => nil,
                :recv_udp => {
                    :addr => ip,
                    :port => port
                },
                :recv_tcp => {
                    :addr => 'localhost',
                    :port => port
                },
                :config => {
                    :host_lifetime          => node[:ganglia][:config][:host_lifetime],
                    :host_cleanup_threshold => node[:ganglia][:config][:host_cleanup_threshold]
                }
            )
            notifies :restart, "service[ganglia_collector_#{cluster_id}]", :delayed if startable?(node[:ganglia][:collector])
        end
    end

    h = Hash.new
    own_collectors_data.map{|k,v| h[k] = "localhost:#{v[1]}"}

    # collector is also generator
    if is_generator?
        
        h[cluster_id] = 'localhost:6666'
        
        realm      = node[:ganglia][:grid]
        cluster_id = node[:cluster_name] || ""

        template "#{node[:ganglia][:conf_dir]}/gmond.conf" do
            source      'gmond.conf.erb'
            backup      false
            owner       node[:ganglia][:user]
            group       node[:ganglia][:group]
            mode        '0644'
            variables(
                :user    => node[:ganglia][:user],
                :cluster => {
                    :name          => cluster_id,
                    :owner         => nil,
                    :latlong       => nil,
                    :url           => nil,
                    :host_location => nil
                },
                :send_udp => nil,
                :recv_udp => nil,
                :recv_tcp => 6666,
                :config => {
                    :host_lifetime          => node[:ganglia][:config][:host_lifetime],
                    :host_cleanup_threshold => node[:ganglia][:config][:host_cleanup_threshold],
                    :hostname               => "#{node[:launch_spec][:facet_name]}-#{node[:launch_spec][:facet_index]}",
                    :plugin_dir             => node[:ganglia][:plugin_dir]
                }
            )

            notifies :restart, 'service[ganglia_generator]', :delayed if startable?(node[:ganglia][:generator]) && has_collector?(cluster_id)
        end
    end

    Chef::Log.debug("Ganglia::config_files --- monitor_groups: #{h.inspect}")

    template "#{node[:ganglia][:conf_dir]}/gmetad.conf" do
        source      'gmetad.conf.erb'
        backup      false
        owner       node[:ganglia][:user]
        group       node[:ganglia][:group]
        mode        '0644'
        notifies    :restart, "service[ganglia_metad]", :delayed if startable?(node[:ganglia][:collector])
        variables   ({
            :monitor_groups => h,
            :grid           => node[:ganglia][:grid],
            :all_trusted    => node[:ganglia][:all_trusted],
            :data_dir       => node[:ganglia][:data_dir]	
        })
    end

    # Replace the default ganglia home_dir by a symlink to the real location (for the web front ends)
    link '/var/lib/ganglia' do
        to      "#{node[:ganglia][:home_dir]}"
        owner   'root'
        group   'root'
        action  :create
    end

elsif is_generator?
    realm                          = node[:ganglia][:grid]
    cluster_id                     = node[:cluster_name] || ""
    collector_addr, collector_port = find_collector_addr_info(cluster_id) rescue [nil, nil]

    Chef::Log.debug("Ganglia::config_files --- found a collector for cluster '#{realm}::#{cluster_id}' @ #{collector_addr}:#{collector_port}")

    template "#{node[:ganglia][:conf_dir]}/gmond.conf" do
        source      'gmond.conf.erb'
        backup      false
        owner       node[:ganglia][:user]
        group       node[:ganglia][:group]
        mode        '0644'
        variables(
            :user    => node[:ganglia][:user],
            :cluster => {
                :name          => cluster_id,
                :owner         => nil,
                :latlong       => nil,
                :url           => nil,
                :host_location => nil
            },
            :send_udp => {
                :addr => collector_addr,
                :port => collector_port
            },
            :recv_udp => node[:ganglia][:generator][:inject_port].nil? ? nil : {:port => node[:ganglia][:generator][:inject_port]},
            :recv_tcp => nil,
            :config => {
                :host_lifetime          => node[:ganglia][:config][:host_lifetime],
                :host_cleanup_threshold => node[:ganglia][:config][:host_cleanup_threshold],
                :hostname               => "#{node[:launch_spec][:facet_name]}-#{node[:launch_spec][:facet_index]}",
                :plugin_dir             => node[:ganglia][:plugin_dir]
            }
        )

        notifies :restart, 'service[ganglia_generator]', :delayed if startable?(node[:ganglia][:generator]) && has_collector?(cluster_id)
    end
end

