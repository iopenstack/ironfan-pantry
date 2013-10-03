#
# Author        :: Bart Vercammen (<bart.vercammen@portico.io>)
# Cookbook Name :: storm
# module        :: StormCluster
#
# Copyright 2013, Technicolor, Portico
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

include Ironfan::NodeUtils
include Ironfan::Discovery

module StormCluster

    # storm cluster name
    def storm_cluster
        node[:storm][:cluster_name]
    end

    def storm_zookeeper_port
        if node[:storm][:zookeeper][:servers].any?
            node[:storm][:zookeeper][:port]
        else
            zookeeper_server = search(:node, "cluster_set:#{node['launch_spec']['cluster_set']} AND role:zookeeper_server").first rescue nil
            unless zookeeper_server.nil?
                return zookeeper_server['zookeeper']['client_port']
            end
            return ""
        end
    end

    # discover all zookeeper ip addresses
    def storm_zookeepers
        if node[:storm][:zookeeper][:servers].any?
            node[:storm][:zookeeper][:servers]
        else
            zk_hosts = []
            zookeeper_servers = search(:node, "cluster_set:#{node['launch_spec']['cluster_set']} AND role:zookeeper_server")
            if not zookeeper_servers.nil?
                zk_hosts = zookeeper_servers.map{|s| s['launch_spec']['ipv4']['local'] }
            end
            zk_hosts.sort.uniq
        end
    end

    # discover nimbus ip address
    def storm_nimbus
        if node[:storm][:nimbus][:host].nil?
            search(:node, "cluster_set:#{node['launch_spec']['cluster_set']} AND role:storm_master").first['launch_spec']['ipv4']['local'] rescue nil
        else
            node[:storm][:nimbus][:host]
        end
    end

    # List of the storm services this machine provides
    def storm_services
        announced_services(:storm, [:nimbus, :supervisor, :ui])
    end

    # (re)start the storm services present on this node (and when node[:storm][:run_state] = :start)
    def notify_startable_storm_services
        notify_startable_services(:storm, storm_services)
    end

end

class Chef::Recipe              ; include StormCluster ; end
class Chef::Resource::Directory ; include StormCluster ; end
class Chef::Resource::Execute   ; include StormCluster ; end
class Chef::Resource::Template  ; include StormCluster ; end

