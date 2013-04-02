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

#monitor_groups = Hash.new{|h,k| h[k] = [] }
#discover_all(:ganglia, :agent).each do |svr|
#  monitor_groups[svr.name] << "#{svr.private_ip}:#{svr.node_info[:rcv_port]}"
#    
#end

if is_collector?
    # monitoring_groups = map of all 'monitorable clusters' with their contact address:
    # cluster_name, ip:port
    # here, as all cluster collectors normally run on the same node as gmetad, 'ip' would always be 'localhost'

    monitor_groups = Hash.new{|h,k| h[k] = [] }
    own_collectors.each do |collector|
        #TODO: fill port and ip
        #monitor_groups[collector.name] << "#{collector.private_ip}:#{collector.node_info[:recv_port]}"

        Chef::Log.info("CAMME: own_collector=#{collector.node_info.inspect}")
        Chef::Log.info("CAMME: monitor_groups=#{monitor_groups.inspect}")

        #template for individual collector gmond services
        template "#{node[:ganglia][:conf_dir]}/gmond.#{collector}.conf" do
            source      'gmond.conf.erb'
            backup      false
            owner       node[:ganglia][:user]
            group       node[:ganglia][:group]
            mode        '0644'
            variables(
                :user    => node[:ganglia][:user],
                :cluster => {
                    :name          => collector,
                    :owner         => nil,
                    :latlong       => nil,
                    :url           => nil,
                    :host_location => nil },
                :send_addr => collector_addr,
                :send_port => collector_port
            )
            notifies :restart, "service[ganglia_collector_#{collector}]", :delayed if startable?(node[:ganglia][:collector])
        end
    end

    template "#{node[:ganglia][:conf_dir]}/gmetad.conf" do
        source      'gmetad.conf.erb'
        backup      false
        owner       node[:ganglia][:user]
        group       node[:ganglia][:group]
        mode        '0644'
        notifies    :restart, "service[ganglia_metad]", :delayed if startable?(node[:ganglia][:collector])
        variables   :monitor_groups => monitor_groups
    end
end

if is_generator?
    realm                          = node[:ganglia][:grid]
    cluster_id                     = node[:cluster_name] || ""
    collector_addr, collector_port = find_collector_addr_info(cluster_id) rescue [nil, nil]

    Chef::Log.info("CAMME: Discovered collector for cluster '#{realm}::#{cluster_id}' @ #{collector_addr}:#{collector_port}")

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
                :host_location => nil },
            :send_addr => collector_addr,
            :send_port => collector_port
        )
        notifies :restart, 'service[ganglia_generator]' if startable?(node[:ganglia][:generator]) && has_collector?(cluster_id)
    end
end

