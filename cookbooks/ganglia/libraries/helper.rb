#
# Cookbook Name::       ganglia
# Description::         
# module::              GangliaHelper
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

include Ironfan::CookbookUtils
include Ironfan::Discovery

# change logic :
#  for generator: discover collectors on chef server
#  for collector: user node[announces] to get collectors.  DO NOT DISCOVER!!
#  DISCOVER only works after the NEXT chef-run

module GangliaHelper

    def get_previously_announced_collector_port(cluster_id)
        realm = node[:ganglia][:grid] || ""
        key   = Ironfan::Component.fullname(realm, :ganglia, "collector-#{cluster_id}")
        elem  = search(:node, "announces:#{key}")[0]
        port  = elem[:announces][key][:info][:recv_port].to_i

        Chef::Log.debug("Ganglia::helper::get_previously_announced_collector_port for: #{key} => port:#{port}")
        port
    end

    # true  if :ganglia:generator has been announced by this node
    def is_generator?
        realm = node[:ganglia][:grid] || ""
        r = announced_services(:ganglia, [:generator], realm).any?
        Chef::Log.debug("Ganglia::helper::is_generator? => #{r}")
        r
    end

    def own_collectors
        realm = node[:ganglia][:grid]
        component_name = Ironfan::Component.fullname(realm, :ganglia, "collector-")
        r = node[:announces].select{ |ann| ann.start_with?(component_name) }
        Chef::Log.debug("Ganglia::helper::own_collectors => #{r.inspect}")
        r
    end

    def own_collectors_data
        r = Hash.new
        own_collectors.keys.each do |k|
            ip         = private_ip_of(node)
            port       = node[:announces][k][:info][:recv_port].to_i
            cluster_id = node[:announces][k][:info][:cluster_id]
            r[cluster_id] = ip, port
        end

        Chef::Log.debug("Ganglia::helper::own_collectors_data => r:#{r.inspect}")
        r
    end

    def number_of_own_collectors
        r = own_collectors.length
        Chef::Log.debug("Ganglia::helper::number_of_own_collectors => #{r}")
        r
    end

    # check if collector is already announced for this cluster_id
    # use 'search' i.s.o. 'discover' because we also want to find our own node,
    # which is filtered out by 'discover/discover_all'
    def was_collector_previously_announced?(cluster_id)
        realm = node[:ganglia][:grid] || ""
        component_name = Ironfan::Component.fullname(realm, :ganglia, "collector-#{cluster_id}")
        r = search(:node, "announces:#{component_name}").any? rescue false
        Chef::Log.debug("Ganglia::helper::is_collector_already_announced? => #{r}")
        r
    end

    # true  if :ganglia:collector has been nannounced by this node
    def is_collector?
        r = number_of_own_collectors > 0
        Chef::Log.debug("Ganglia::helper::is_collector? => #{r}")
        r
    end

    def next_free_port
        all_ports = *(node[:ganglia][:collector][:start_port]..node[:ganglia][:collector][:end_port])
        used_ports = []
        own_collectors.keys.each do |col|
            used_ports << node[:announces][k][:info][:recv_port].to_i
        end

        free_port = (all_ports - used_ports)[0]
        Chef::Log.debug("Ganglia::helper::next_free_port => free_port:#{free_port.inspect}")
        free_port
    end

    def find_all_monitorable_clusters
        cluster_list = []
        realm        = node[:ganglia][:grid] || ""

        if node[:ganglia][:collector][:cluster_names].nil? || node[:ganglia][:collector][:cluster_names].empty?
            discover_all(:ganglia, :generator, realm).each do |gen|
                cluster_list << gen.info[:info][:cluster_id]
            end
        else
            cluster_list = node[:ganglia][:collector][:cluster_names]
        end

        Chef::Log.debug("Ganglia::helper::find_all_monitorable_clusters => cluster_list:#{cluster_list.inspect}")
        cluster_list.sort.uniq
    end                 


    def has_collector?(cluster_id)
        realm     = node[:ganglia][:grid] || ""
        collector = discover(:ganglia, "collector-#{cluster_id}", realm) rescue nil
        Chef::Log.debug("Ganglia::helper::has_collector? => collector:#{collector.inspect}")

        (collector != nil) ? true : false
    end

    def find_collector_addr_info(cluster_id)
        port      = nil
        addr      = nil
        realm     = node[:ganglia][:grid] || ""
        collector = discover(:ganglia, "collector-#{cluster_id}", realm) rescue nil
        if (collector != nil)
            addr = collector.private_ip
            port = collector.info[:info][:recv_port].to_i
        end

        Chef::Log.debug("Ganglia::helper::find_collector_addr_info => addr:#{addr}, port:#{port}")
        return addr, port
    end
end

class Chef::Recipe              ; include GangliaHelper ; end
class Chef::Resource::Directory ; include GangliaHelper ; end
class Chef::Resource::Execute   ; include GangliaHelper ; end
class Chef::Resource::Template  ; include GangliaHelper ; end

